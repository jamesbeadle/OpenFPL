// SeasonManager.mo

import T "types";
import Timer "mo:base/Timer";
import { now } = "mo:base/Time";
import Int "mo:base/Int";
import Time "mo:base/Time";

module {

  public class SeasonManager(resetTransfers: shared () -> async ()) {

    private var seasons: [T.Season] = [];
    private var activeSeasonId: Nat16 = 1;
    private var nextSeasonId: Nat16 = 2;
    private var activeTimers: [Nat] = [];
    private let oneHour = 1_000_000_000 * 60 * 30;

    public func init_genesis_season(firstFixture: T.Fixture){
        //new season created, fixture consensus reched and gameweek and season id set

        //set gameweek 1 timers
        let now = Time.now();
        let gameweekBeginTimerId = Timer.setTimer(#nanoseconds (Int.abs(firstFixture.kickOff - now - oneHour)), gameweekBegin);

    };

    private func gameweekBegin() : async (){
        //the active gameweek has begun
        //set system status to gameweek closed
        //for each fixture of the active gameweek of the active season you need to load the game kickoff timer
    };

    private func gameKickOff() : async (){
        //game kicked off

        //timer for 2 hours from now to mark game as completed
        //load the game completed timer in 2 hours
    };

    private func gameCompleted() : async (){
        //the active gameweek has begun
        //set voting period timer
    };

    private func allowVotingPeriod() : async (){
        //at this point consensus will be reached either by timer or voting period
    };

    private func consensusReached() : async (){
        //check if reached via voting power
        //if not trigger third party API check if activated (won't be in first instance)
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
        await resetTransfers();
    };

    private func setNextGameweek() : async (){
        //check if current is 38
    };

    private func createNewSeason() : async (){
        //create a new season
    };

    private func intialFixturesConfirmed() : async (){
        //set gameweek to 1
        //set current season to new season
    };



    //create a timer that kicks off for gameweek 1 of the already added season and things can begin

    //create new season
    //fixture consensus achieved, set new season to active season
    //reset season and gameweek

    //create gameweek timers    
        //gameweek begins: 1 hour before first kickoff
        //game kickoffs: kickoff time for each game
        //2 hours after game kickoffs: game set to rquires consensus
    
    //events linked to this
        //game consensus reached for all games
        //potential comparison with 3rd party APIs
        //check all games are verified

    //when all games are verified
        //calculate points, distribute rewards, settle user bets, revalue players and reset weekly transfers
    
    //back to create gameweek timers unless gameweek 38 finished then create new season


  };
}
