// SeasonManager.mo

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

module {

  public class SeasonManager(
    resetTransfers: shared () -> async ()) {

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
  

    public func init_genesis_season(firstFixture: T.Fixture){
        //new season created, fixture consensus reched and gameweek and season id set to 1
        let now = Time.now();
        gameweekBeginTimerId := Timer.setTimer(#nanoseconds (Int.abs(firstFixture.kickOff - now - oneHour)), gameweekBegin);
    };

    private func gameweekBegin() : async (){
        //clear gameweekBegin timer id

        transfersAllowed := false;

        //copy current teams into gameweek predictions

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
        //clear game kickoff timer ids
        await setGameActive();
        let now = Time.now();
        let gameCompletedTimer = Timer.setTimer(#nanoseconds (Int.abs((now + (oneHour * 2)) - now)), gameCompleted);
        
        //add time to gameCompletedTimerIds
        //gameCompletedTimerIds

    };

    private func gameCompleted() : async (){
        //clear game completed timer ids
        await setGameCompleted();
        let now = Time.now();
        let votingPeriodOverTimer = Timer.setTimer(#nanoseconds (Int.abs((now + (oneHour * 2)) - now)), votingPeriodOver);
    };

    private func votingPeriodOver() : async (){
        await checkGameConsensus();
    };

    public func setNextGameweek() : async (){
        //check if current is 38
        //gameweekBeginTimerId := Timer.setTimer(#nanoseconds (Int.abs(firstFixture.kickOff - now - oneHour)), gameweekBegin);
    };

    private func createNewSeason() : async (){
        //create a new season
    };

    private func intialFixturesConfirmed() : async (){
        //set gameweek to 1
        
        //set current season to new season
    };

    public func setGameActive(): async (){
        //for each fixture for this gameweek whose kickoff date is before the time now and whose status is set to unplayed set them as active
        //allow draft data to be collected for a game
    };

    public func setGameCompleted(): async (){
        //for each fixture that has been 
    };

    public func checkGameConsensus(): async (){
        //check if a game has reached consensus via voting power if not set the final score
    };

    public func getActiveSeasonId() : Nat16 {
        return activeSeasonId;
    };

    public func getActiveGameweek() : Nat8 {
        return activeGameweek;
    };

    public func getGameweekFixtures() : [T.Fixture] {
        return fixturesInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
    };

    public func getTransfersAllowed() : Bool {
        return transfersAllowed;
    };

    private func gameVerified() : async (){
        //check if all games in the gameweek are verified
    };

    private func gameweekVerified() : async (){
        //calculate points
        //distribute rewards
        //settle user bets
        //revalue players
        //reset weekly transfers
        //mint FPL
        await resetTransfers();
        transfersAllowed := true;
    };


  };
}
