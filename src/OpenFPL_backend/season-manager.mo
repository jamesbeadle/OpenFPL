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
    resetFantasyTeams: () -> async ()) {

    private var activeSeasonId: Nat16 = 1;
    private var activeGameweek: Nat8 = 1;
    private var activeTimers: [Int] = [];
    private var transfersAllowed: Bool = true;

    //timers
    private var gameweekBeginTimerId: Int = 0;
    private var kickOffTimerIds: [Int] = [];
    private var gameCompletedTimerIds: [Int] = [];
    private var votingPeriodTimerIds: [Int] = [];

    //timer data
    private var activeFixtures: [T.Fixture] = [];
    
    //child modules
    private let seasonsInstance = Seasons.Seasons();

    //definitions
    private let oneHour = 1_000_000_000 * 60 * 60;

    //System variables - to be moved and controlled by proposal
    private let gameConsensusDurationHours = 6;
  
    public func init_genesis_season(firstFixture: T.Fixture){
        //new season created, fixture consensus reched and gameweek and season id set to 1
        gameweekBeginTimerId := Timer.setTimer(#nanoseconds (Int.abs(firstFixture.kickOff - now() - oneHour)), gameweekBegin);
    };

    public func setData(stable_active_season_id: Nat16, stable_active_gameweek: Nat8, stable_active_timers: [Int], stable_transfers_allowed: Bool, 
        stable_gameweek_begin_timer_id: Int, stable_kick_off_timer_ids: [Int], stable_game_completed_timer_ids: [Int], stable_voting_period_timer_ids: [Int],
        stable_active_fixtures: [T.Fixture], stable_next_fixture_id: Nat32, stable_next_season_id: Nat16){
            activeSeasonId := stable_active_season_id;
            activeGameweek :=  stable_active_gameweek; 
            activeTimers :=  stable_active_timers;
            transfersAllowed :=  stable_transfers_allowed; 
            gameweekBeginTimerId := stable_gameweek_begin_timer_id; 
            kickOffTimerIds := stable_kick_off_timer_ids; 
            gameCompletedTimerIds := stable_game_completed_timer_ids; 
            votingPeriodTimerIds := stable_voting_period_timer_ids;
            activeFixtures := stable_active_fixtures; 
            seasonsInstance.setNextFixtureId(stable_next_fixture_id);
            seasonsInstance.setNextSeasonId(stable_next_season_id);

    };
    
    public func getActiveTimerIds() : [Int] {
        return activeTimers;
    };

    public func getGameweekBeginTimerId() : Int {
        return gameweekBeginTimerId;
    };

    public func getKickOffTimerIds() : [Int] {
        return kickOffTimerIds;
    };

    public func getGameCompletedTimerIds() : [Int] {
        return gameCompletedTimerIds;
    };

    public func getVotingPeriodTimerIds() : [Int] {
        return votingPeriodTimerIds;
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

        gameweekBeginTimerId := 0;
        transfersAllowed := false;

        await snapshotGameweek(activeSeasonId);

        activeFixtures := seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
        var gameKickOffTimers = List.nil<Nat>(); 
        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            let gameBeginTimerId = Timer.setTimer(#nanoseconds (Int.abs(activeFixtures[i].kickOff - now())), gameKickOff);
            gameKickOffTimers := List.push(gameBeginTimerId, gameKickOffTimers);
        };

        kickOffTimerIds := List.toArray(gameKickOffTimers);
    };

    private func gameKickOff() : async (){
        
        let timerBuffer = Buffer.fromArray<Int>(gameCompletedTimerIds);
        let activeFixturesBuffer = Buffer.fromArray<T.Fixture>([]);
        
        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            if(activeFixtures[i].kickOff <= now() and activeFixtures[i].status == 0){
                
                let updatedFixture = await seasonsInstance.updateStatus(activeSeasonId, activeGameweek, activeFixtures[i].id, 1);
                activeFixturesBuffer.add(updatedFixture);

                let gameCompletedTimer = Timer.setTimer(#nanoseconds (Int.abs((now() + (oneHour * 2)) - now())), gameCompleted);
                timerBuffer.add(gameCompletedTimer);
            }
            else{
                activeFixturesBuffer.add(activeFixtures[i]);
            };
        };

        gameCompletedTimerIds := Buffer.toArray<Int>(timerBuffer);
        activeFixtures := Buffer.toArray<T.Fixture>(activeFixturesBuffer);
    };

    private func gameCompleted() : async (){
        
        let timerBuffer = Buffer.fromArray<Int>(gameCompletedTimerIds);
        let activeFixturesBuffer = Buffer.fromArray<T.Fixture>([]);
       
        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            if((activeFixtures[i].kickOff + (oneHour * 2))  <= now() and activeFixtures[i].status == 1){
                
                let updatedFixture = await seasonsInstance.updateStatus(activeSeasonId, activeGameweek, activeFixtures[i].id, 2);
                activeFixturesBuffer.add(updatedFixture);

                let votingPeriodOverTimer = Timer.setTimer(#nanoseconds (Int.abs((now() + (oneHour * gameConsensusDurationHours)) - now())), votingPeriodOver);
                timerBuffer.add(votingPeriodOverTimer);
            };
        };

        votingPeriodTimerIds := Buffer.toArray<Int>(timerBuffer);
        activeFixtures := Buffer.toArray<T.Fixture>(activeFixturesBuffer);
        
        let remainingFixtures = Array.find(activeFixtures, func (fixture: T.Fixture): Bool {
            return fixture.status == 0;
        });

        if(Option.isNull(remainingFixtures)){
            gameCompletedTimerIds := [];
        };
        
    };

    private func votingPeriodOver() : async (){

        let activeFixturesBuffer = Buffer.fromArray<T.Fixture>([]);
       
        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            let fixture = activeFixtures[i];
            if((fixture.kickOff + (oneHour * gameConsensusDurationHours)) <= now() and fixture.status == 2){
                let consensusPlayerEventData = await getConsensusPlayerEventData(activeGameweek, fixture.id);
                let updatedFixture = await seasonsInstance.savePlayerEventData(activeSeasonId, activeGameweek, activeFixtures[i].id, consensusPlayerEventData);
                activeFixturesBuffer.add(updatedFixture);
            };
        };
        activeFixtures := Buffer.toArray<T.Fixture>(activeFixturesBuffer);

        let remainingFixtures = Array.find(activeFixtures, func (fixture: T.Fixture): Bool {
            return fixture.status < 3;
        });

        if(Option.isNull(remainingFixtures)){
            votingPeriodTimerIds := [];
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
        if(activeGameweek == 38){
            await seasonsInstance.createNewSeason(activeSeasonId);
            await mintAnnualRewardsPool();
            await resetFantasyTeams();
            return;
        };

        activeGameweek += 1;
        activeFixtures := seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
        await mintWeeklyRewardsPool();
        gameweekBeginTimerId := Timer.setTimer(#nanoseconds (Int.abs(activeFixtures[0].kickOff - now() - oneHour)), gameweekBegin);        
    };

    public func intialFixturesConfirmed() : async (){
        activeGameweek := 1;
        activeFixtures := seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
        gameweekBeginTimerId := Timer.setTimer(#nanoseconds (Int.abs(activeFixtures[0].kickOff - now() - oneHour)), gameweekBegin);     
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
        //IMPLEMENT
    };

    public func rescheduleFixture(proposalPayload: T.RescheduleFixturePayload) : async () {
        //IMPLEMENT
    };
  };
}
