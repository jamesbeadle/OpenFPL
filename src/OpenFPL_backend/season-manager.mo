import T "types";
import Timer "mo:base/Timer";
import { now } = "mo:base/Time";
import Int "mo:base/Int";
import Time "mo:base/Time";
import FantasyTeams "fantasy-teams";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import List "mo:base/List";
import Fixtures "fixtures";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Nat16 "mo:base/Nat16";
import Text "mo:base/Text";
import Char "mo:base/Char";

module {

  public class SeasonManager(
    resetTransfers: () -> async (),
    calculatePlayerPoints: (activeGameweek: Nat8, gameweekFixtures: [T.Fixture]) -> async [T.Fixture],
    distributeRewards: () -> async (),
    settleUserBets: () -> async (),
    revaluePlayers: () -> async (),
    snapshotGameweek: () -> async (),
    getPlayer: (playerId: Nat16) -> async T.Player,
    mintWeeklyRewardsPool: () -> async (),
    mintAnnualRewardsPool: () -> async (),
    calculateFantasyTeamScores: (Nat8, [T.Fixture]) -> async (),
    getConsensusPlayerEventData: (Nat8, Nat32) -> async List.List<T.PlayerEventData>  ) {

    private var seasons: [T.Season] = [];

    private var activeSeasonId: Nat16 = 1;
    private var activeGameweek: Nat8 = 1;
    private var nextSeasonId: Nat16 = 2;
    private var activeTimers: [Nat] = [];
    private var transfersAllowed: Bool = true;

    //timers
    private var gameweekBeginTimerId: Nat = 0;
    private var kickOffTimerIds: [Nat] = [];
    private var gameCompletedTimerIds: [Nat] = [];
    private var votingPeriodTimerIds: [Nat] = [];

    //timer data
    private var activeFixtures: [T.Fixture] = [];
    
    //child modules
    private let fixturesInstance = Fixtures.Fixtures();

    //definitions
    private let oneHour = 1_000_000_000 * 60 * 60;

    //System variables - to be moved and controlled by proposal
    private let gameConsensusDurationHours = 6;
  
    public func init_genesis_season(firstFixture: T.Fixture){
        //new season created, fixture consensus reched and gameweek and season id set to 1
        let now = Time.now();
        gameweekBeginTimerId := Timer.setTimer(#nanoseconds (Int.abs(firstFixture.kickOff - now - oneHour)), gameweekBegin);
    };

    private func gameweekBegin() : async (){

        gameweekBeginTimerId := 0;
        transfersAllowed := false;

        await snapshotGameweek();

        let now = Time.now();
        activeFixtures := fixturesInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
        var gameKickOffTimers = List.nil<Nat>(); 
        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            let gameBeginTimerId = Timer.setTimer(#nanoseconds (Int.abs(activeFixtures[i].kickOff - now)), gameKickOff);
            gameKickOffTimers := List.push(gameBeginTimerId, gameKickOffTimers);
        };

        kickOffTimerIds := List.toArray(gameKickOffTimers);
    };

    private func gameKickOff() : async (){
        
        let now = Time.now();
        let timerBuffer = Buffer.fromArray<Nat>(gameCompletedTimerIds);
        let activeFixturesBuffer = Buffer.fromArray<T.Fixture>([]);
        
        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            if(activeFixtures[i].kickOff <= now and activeFixtures[i].status == 0){
                
                let updatedFixture = await fixturesInstance.updateStatus(activeFixtures[i].id, 1);
                activeFixturesBuffer.add(updatedFixture);

                let gameCompletedTimer = Timer.setTimer(#nanoseconds (Int.abs((now + (oneHour * 2)) - now)), gameCompleted);
                timerBuffer.add(gameCompletedTimer);
            }
            else{
                activeFixturesBuffer.add(activeFixtures[i]);
            };
        };

        gameCompletedTimerIds := Buffer.toArray<Nat>(timerBuffer);
        activeFixtures := Buffer.toArray<T.Fixture>(activeFixturesBuffer);
    };

    private func gameCompleted() : async (){
        
        let now = Time.now();
        let timerBuffer = Buffer.fromArray<Nat>(gameCompletedTimerIds);
        let activeFixturesBuffer = Buffer.fromArray<T.Fixture>([]);
       
        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            if((activeFixtures[i].kickOff + (oneHour * 2))  <= now and activeFixtures[i].status == 1){
                
                let updatedFixture = await fixturesInstance.updateStatus(activeFixtures[i].id, 2);
                activeFixturesBuffer.add(updatedFixture);

                let votingPeriodOverTimer = Timer.setTimer(#nanoseconds (Int.abs((now + (oneHour * gameConsensusDurationHours)) - now)), votingPeriodOver);
                timerBuffer.add(votingPeriodOverTimer);
            };
        };

        votingPeriodTimerIds := Buffer.toArray<Nat>(timerBuffer);
        activeFixtures := Buffer.toArray<T.Fixture>(activeFixturesBuffer);
        
        let remainingFixtures = Array.find(activeFixtures, func (fixture: T.Fixture): Bool {
            return fixture.status == 0;
        });

        if(Option.isNull(remainingFixtures)){
            gameCompletedTimerIds := [];
        };
        
    };

    private func votingPeriodOver() : async (){

        let now = Time.now();
        let activeFixturesBuffer = Buffer.fromArray<T.Fixture>([]);
       
        for (i in Iter.range(0, Array.size(activeFixtures)-1)) {
            let fixture = activeFixtures[i];
            if((fixture.kickOff + (oneHour * gameConsensusDurationHours)) <= now and fixture.status == 2){
                let consensusPlayerEventData = await getConsensusPlayerEventData(activeGameweek, fixture.id);
                let updatedFixture = await fixturesInstance.savePlayerEventData(activeFixtures[i].id, consensusPlayerEventData);
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
        await fixturesInstance.updateHighestPlayerIds(fixturesWithHighestPlayerId);
        await calculateFantasyTeamScores(activeGameweek, activeFixtures);
        await distributeRewards();
        await settleUserBets();
        await revaluePlayers();
        await resetTransfers();
        
        transfersAllowed := true;
    };

    public func setNextGameweek() : async (){
        if(activeGameweek == 38){
            await createNewSeason();
            return;
        };

        let now = Time.now();
        activeGameweek := activeGameweek + 1;
        activeFixtures := fixturesInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
        await mintWeeklyRewardsPool();
        gameweekBeginTimerId := Timer.setTimer(#nanoseconds (Int.abs(activeFixtures[0].kickOff - now - oneHour)), gameweekBegin);        
    };

    private func createNewSeason() : async (){
        let currentSeason = List.find<T.Season>(List.fromArray(seasons), func (season: T.Season): Bool {
            return season.id == activeSeasonId;
        });

        switch (currentSeason) {
            case (null) { };
            case (?season) { 
                //create a new season
                let newYear = season.year + 1;
                let newSeason: T.Season = {
                    id = nextSeasonId;
                    name = Nat16.toText(newYear) # subText(Nat16.toText(newYear + 1), 2, 3);
                    year = newYear;
                };

                let seasonsBuffer = Buffer.fromArray<T.Season>(seasons);
                seasonsBuffer.add(newSeason);
                seasons := Buffer.toArray(seasonsBuffer);
                nextSeasonId := nextSeasonId + 1;
                await mintAnnualRewardsPool();
             };
        };
    };

    public func intialFixturesConfirmed() : async (){
        let now = Time.now();
        activeSeasonId := nextSeasonId;
        activeGameweek := 1;
        activeFixtures := fixturesInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
        gameweekBeginTimerId := Timer.setTimer(#nanoseconds (Int.abs(activeFixtures[0].kickOff - now - oneHour)), gameweekBegin);     
    };

    public func setHighestScoringPlayerIds(fixtures: [T.Fixture]) : async (){

    };

    public func getActiveSeasonId() : Nat16 {
        return activeSeasonId;
    };

    public func getActiveGameweek() : Nat8 {
        return activeGameweek;
    };

    public func getFixtures() : [T.Fixture] {
        return fixturesInstance.getFixtures(activeSeasonId);
    };

    public query func getGameweekFixtures() : async [T.Fixture] {
        return fixturesInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
    };

    public func getTransfersAllowed() : Bool {
        return transfersAllowed;
    };

    private func subText(value : Text, indexStart : Nat, indexEnd : Nat) : Text {
        if (indexStart == 0 and indexEnd >= value.size()) {
            return value;
        }
        else if (indexStart >= value.size()) {
            return "";
        };
        
        var indexEndValid = indexEnd;
        if (indexEnd > value.size()) {
            indexEndValid := value.size();
        };

        var result : Text = "";
        var iter = Iter.toArray<Char>(Text.toIter(value));
        for (index in Iter.range(indexStart, indexEndValid - 1)) {
            result := result # Char.toText(iter[index]);
        };

        return result;
    };
  };
}
