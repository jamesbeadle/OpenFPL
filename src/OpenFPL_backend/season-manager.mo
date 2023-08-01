import T "types";
import DTOs "DTOs";
import Timer "mo:base/Timer";
import { now } = "mo:base/Time";
import Int "mo:base/Int";
import FantasyTeams "fantasy-teams";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import List "mo:base/List";
import Seasons "seasons";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Nat8 "mo:base/Nat8";
import Time "mo:base/Time";

module {

  public class SeasonManager(
    resetTransfers: () -> async (),
    calculatePlayerPoints: (activeGameweek: Nat8, gameweekFixtures: [T.Fixture]) -> async [T.Fixture],
    distributeRewards: () -> async (),
    settleUserBets: () -> async (),
    revaluePlayers: (Nat16, Nat8) -> async (),
    snapshotGameweek: (seaasonId: Nat16) -> async (),
    mintWeeklyRewardsPool: () -> async (),
    mintAnnualRewardsPool: () -> async (),
    calculateFantasyTeamScores: (Nat16, Nat8, [T.Fixture]) -> async (),
    getConsensusPlayerEventData: (Nat8, Nat32) -> async List.List<T.PlayerEventData>,
    getAllPlayersMap: (Nat16, Nat8) -> async [(Nat16, DTOs.PlayerScoreDTO)],
    resetFantasyTeams: () -> async (),
    EventData_VotingPeriod: Int,
    setAndBackupTimer: (duration: Timer.Duration, callbackName: Text) -> async ()) {

    private var activeSeasonId: Nat16 = 1;
    private var activeGameweek: Nat8 = 1;
    private var transfersAllowed: Bool = true;

    //timer data
    private var activeFixtures: [T.Fixture] = [];
    
    //child modules
    private let seasonsInstance = Seasons.Seasons();

    //definitions
    private let oneHour = 1_000_000_000 * 60 * 60;
        
    public func init_genesis_season(firstFixture: T.Fixture) : async () {
        let genesisSeasonDuration: Timer.Duration = #nanoseconds (Int.abs(firstFixture.kickOff - Time.now() - oneHour));
        await setAndBackupTimer(genesisSeasonDuration, "gameweekBeginExpired");
    };


    public func setData(stable_seasons: [T.Season], stable_active_season_id: Nat16, stable_active_gameweek: Nat8, stable_transfers_allowed: Bool, 
        stable_active_fixtures: [T.Fixture], stable_next_fixture_id: Nat32, stable_next_season_id: Nat16){
            activeSeasonId := stable_active_season_id;
            activeGameweek :=  stable_active_gameweek; 
            transfersAllowed :=  stable_transfers_allowed; 
            activeFixtures := stable_active_fixtures; 
            seasonsInstance.setSeasons(stable_seasons);
            seasonsInstance.setNextFixtureId(stable_next_fixture_id);
            seasonsInstance.setNextSeasonId(stable_next_season_id);
    };
    
    public func getActiveFixtures() : [T.Fixture] {
        return activeFixtures;
    };

    public func getNextFixtureId() : Nat32 {
        return seasonsInstance.getNextFixtureId();
    };

    public func getNextSeasonId() : Nat16 {
        return seasonsInstance.getNextSeasonId();
    };

    private func gameweekBegin() : async (){
        transfersAllowed := false;

        await snapshotGameweek(activeSeasonId);

        activeFixtures := seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
        var gameKickOffTimers = List.nil<T.TimerInfo>(); 
        for (i in Iter.range(0, Array.size(activeFixtures) - 1)) {
            let gameKickOffDuration: Timer.Duration = #nanoseconds (Int.abs(activeFixtures[i].kickOff - Time.now()));
            await setAndBackupTimer(gameKickOffDuration, "gameKickOffExpired");
        };
    };

    private func gameKickOff() : async (){

        let activeFixturesBuffer = Buffer.fromArray<T.Fixture>([]);
        
        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            if(activeFixtures[i].kickOff <= Time.now() and activeFixtures[i].status == 0){
                
                let updatedFixture = await seasonsInstance.updateStatus(activeSeasonId, activeGameweek, activeFixtures[i].id, 1);
                activeFixturesBuffer.add(updatedFixture);

                let gameCompletedDuration: Timer.Duration = #nanoseconds (Int.abs((Time.now() + (oneHour * 2)) - Time.now()));
                await setAndBackupTimer(gameCompletedDuration, "gameCompletedExpired");
            }
            else{
                activeFixturesBuffer.add(activeFixtures[i]);
            };
        };
        activeFixtures := Buffer.toArray<T.Fixture>(activeFixturesBuffer);
    };


    private func gameCompleted() : async () {
        let activeFixturesBuffer = Buffer.fromArray<T.Fixture>([]);

        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            if((activeFixtures[i].kickOff + (oneHour * 2)) <= Time.now() and activeFixtures[i].status == 1) {

                let updatedFixture = await seasonsInstance.updateStatus(activeSeasonId, activeGameweek, activeFixtures[i].id, 2);
                activeFixturesBuffer.add(updatedFixture);

                let votingPeriodOverDuration: Timer.Duration = #nanoseconds (Int.abs((Time.now() + EventData_VotingPeriod) - Time.now()));
                await setAndBackupTimer(votingPeriodOverDuration, "votingPeriodOverExpired");
            } else {
                activeFixturesBuffer.add(activeFixtures[i]);
            };
        };
        
        activeFixtures := Buffer.toArray<T.Fixture>(activeFixturesBuffer);
    };


    private func votingPeriodOver() : async (){
        let activeFixturesBuffer = Buffer.fromArray<T.Fixture>([]);

        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            let fixture = activeFixtures[i];
            if((fixture.kickOff + EventData_VotingPeriod) <= Time.now() and fixture.status == 2) {
                let consensusPlayerEventData = await getConsensusPlayerEventData(activeGameweek, fixture.id);
                let updatedFixture = await seasonsInstance.savePlayerEventData(activeSeasonId, activeGameweek, activeFixtures[i].id, consensusPlayerEventData);
                activeFixturesBuffer.add(updatedFixture);
            } else {
                activeFixturesBuffer.add(fixture);
            };
        };
        
        activeFixtures := Buffer.toArray<T.Fixture>(activeFixturesBuffer);

        let remainingFixtures = Array.find(activeFixtures, func (fixture: T.Fixture): Bool {
            return fixture.status < 3;
        });

        if(Option.isNull(remainingFixtures)) {
            await gameweekVerified();
            await setNextGameweek();
        };
    };


    private func gameweekVerified() : async (){
          
        let fixturesWithHighestPlayerId = await calculatePlayerPoints(activeGameweek, activeFixtures);
        await seasonsInstance.updateHighestPlayerIds(activeSeasonId, activeGameweek, fixturesWithHighestPlayerId);
        await calculateFantasyTeamScores(activeSeasonId, activeGameweek, activeFixtures);
        await distributeRewards();
        await settleUserBets();
        await revaluePlayers(activeSeasonId, activeGameweek);
        await resetTransfers();
        
        transfersAllowed := true;
    };

    public func setNextGameweek() : async (){
        if(activeGameweek == 38) {
            await seasonsInstance.createNewSeason(activeSeasonId);
            await mintAnnualRewardsPool();
            await resetFantasyTeams();
            return;
        };

        activeGameweek += 1;
        activeFixtures := seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
        await mintWeeklyRewardsPool();

        let gameweekBeginDuration: Timer.Duration = #nanoseconds (Int.abs(activeFixtures[0].kickOff - Time.now() - oneHour));
        await setAndBackupTimer(gameweekBeginDuration, "gameweekBeginExpired");
    };

    public func intialFixturesConfirmed() : async (){
        activeGameweek := 1;
        activeFixtures := seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);

        let initialGameweekBeginDuration: Timer.Duration = #nanoseconds (Int.abs(activeFixtures[0].kickOff - Time.now() - oneHour));
        await setAndBackupTimer(initialGameweekBeginDuration, "gameweekBeginExpired");
    };

    public func getActiveSeasonId() : Nat16 {
        return activeSeasonId;
    };

    public func getActiveGameweek() : Nat8 {
        return activeGameweek;
    };

    public func getFixtures() : [T.Fixture] {
        return seasonsInstance.getSeasonFixtures(activeSeasonId);
    };

    public func getActiveGameweekFixtures() : [T.Fixture] {
        return seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
    };

    public func getTransfersAllowed() : Bool {
        return transfersAllowed;
    };
    
    public func getSeasons() : [T.Season] {
        return seasonsInstance.getSeasons();
    };

    public func addInitialFixtures(proposalPayload: T.AddInitialFixturesPayload) : async () {
        seasonsInstance.addInitialFixtures(proposalPayload);
    };

    public func rescheduleFixture(proposalPayload: T.RescheduleFixturePayload) : async () {
        seasonsInstance.rescheduleFixture(proposalPayload);
    };

    //Only return draft data if over threshold for DraftEventData_VoteThreshold

    //Only return event data if over vote threshold

    

  };
}
