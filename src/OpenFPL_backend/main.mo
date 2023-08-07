import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import DTOs "DTOs";
import Profiles "profiles";
import Account "Account";
import Book "book";
import Teams "teams";
import FantasyTeams "fantasy-teams";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Option "mo:base/Option";
import PlayerCanister "canister:player_canister";
import T "types";
import SeasonManager "season-manager";
import Governance "governance";
import Rewards "rewards";
import PrivateLeagues "private-leagues-manager";
import List "mo:base/List";
import Timer "mo:base/Timer";
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Utilities "utilities";

actor Self {

  let profilesInstance = Profiles.Profiles();
  let bookInstance = Book.Book();
  let teamsInstance = Teams.Teams();
  let rewardsInstance = Rewards.Rewards();
  let privateLeaguesInstance = PrivateLeagues.PrivateLeagues();
  
  let CANISTER_IDS = {
    //JB Local Dev
    token_canister = "tqtu6-byaaa-aaaaa-aaana-cai";
    player_canister = "wqmuk-5qaaa-aaaaa-aaaqq-cai";
    //Live canisters
    //player_canister = "pec6o-uqaaa-aaaal-qb7eq-cai";
    //token_canister = "hwd4h-eyaaa-aaaal-qb6ra-cai";
  };
  
  let tokenCanister = actor (CANISTER_IDS.token_canister): actor 
  { 
    icrc1_name: () -> async Text;
    icrc1_total_supply: () -> async Nat;
    icrc1_balance_of: (T.Account) -> async Nat;
  };
  
  let playerCanister = actor (CANISTER_IDS.player_canister): actor 
  { 
    getAllPlayers: () -> async [DTOs.PlayerDTO];
    getAllPlayersMap: (seasonId: Nat16, gameweek: Nat8) -> async [(Nat16, DTOs.PlayerScoreDTO)];
    revaluePlayers: (List.List<T.RevaluedPlayer>) -> async ();
    getPlayer: (playerId: Nat16) -> async T.Player;
    calculatePlayerScores(seasonId: Nat16, gameweek: Nat8, fixture: T.Fixture) : async T.Fixture;
    transferPlayer: (proposalPayload: T.TransferPlayerPayload) -> async ();
    loanPlayer: (proposalPayload: T.LoanPlayerPayload) -> async ();
    recallPlayer: (proposalPayload: T.RecallPlayerPayload) -> async ();
    createPlayer: (proposalPayload: T.CreatePlayerPayload) -> async ();
    updatePlayer: (proposalPayload: T.UpdatePlayerPayload) -> async ();
    setPlayerInjury: (proposalPayload: T.SetPlayerInjuryPayload) -> async ();
    retirePlayer: (proposalPayload: T.RetirePlayerPayload) -> async ();
    unretirePlayer: (proposalPayload: T.UnretirePlayerPayload) -> async ();
  };

  private func getAllPlayersMap(seasonId: Nat16, gameweek: Nat8): async [(Nat16, DTOs.PlayerScoreDTO)] {
    return await playerCanister.getAllPlayersMap(seasonId, gameweek);
  }; 

  private func getPlayer(playerId: Nat16): async T.Player {
    return await playerCanister.getPlayer(playerId);
  }; 

  let fantasyTeamsInstance = FantasyTeams.FantasyTeams(getAllPlayersMap, getPlayer);

  public shared ({caller}) func getCurrentGameweek() : async Nat8 {
    return seasonManager.getActiveGameweek();
  };

  public shared ({caller}) func getCurrentSeason() : async T.Season {
    return await seasonManager.getActiveSeason();
  };
  
  public query func getTeams() : async [T.Team] {
    return teamsInstance.getTeams();
  };

  public query ({caller}) func getFixtures() : async [T.Fixture]{
    return seasonManager.getFixtures();
  };

  public shared ({caller}) func getFixture(seasonId: T.SeasonId, gameweekNumber: T.GameweekNumber, fixtureId: T.FixtureId) : async T.Fixture{
    return await seasonManager.getFixture(seasonId, gameweekNumber, fixtureId);
  };

  public query ({caller}) func getActiveGameweekFixtures() : async [T.Fixture]{
    return seasonManager.getActiveGameweekFixtures();
  };

  //Profile Functions
  public shared ({caller}) func getProfileDTO() : async DTOs.ProfileDTO {
    assert not Principal.isAnonymous(caller);
    let principalName = Principal.toText(caller);
    var icpDepositAddress = Blob.fromArray([]);
    var fplDepositAddress = Blob.fromArray([]);
    var displayName = "";
    var membershipType = Nat8.fromNat(0);
    var profilePicture = Blob.fromArray([]);
    var favouriteTeamId = Nat16.fromNat(0);
    var createDate: Int = 0;
    var reputation = Nat32.fromNat(0);

    var profile = profilesInstance.getProfile(Principal.toText(caller));
    
    if(profile == null){
      profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller), getICPDepositAccount(caller), getFPLDepositAccount(caller));
      profile := profilesInstance.getProfile(Principal.toText(caller));
    };
    
    switch(profile){
      case (null){};
      case (?p){
        icpDepositAddress := p.icpDepositAddress;
        fplDepositAddress := p.fplDepositAddress;
        displayName := p.displayName;
        membershipType := p.membershipType;
        profilePicture := p.profilePicture;
        favouriteTeamId := p.favouriteTeamId;
        createDate := p.createDate;
        reputation := p.reputation;
      };
    };

    let profileDTO: DTOs.ProfileDTO = {
      principalName = principalName;
      icpDepositAddress = icpDepositAddress;
      fplDepositAddress = fplDepositAddress;
      displayName = displayName;
      membershipType = membershipType;
      profilePicture = profilePicture;
      favouriteTeamId = favouriteTeamId;
      createDate = createDate;
      reputation = reputation;
    };

    return profileDTO;
  };

  public shared query ({caller}) func isDisplayNameValid(displayName: Text) : async Bool {
    assert not Principal.isAnonymous(caller);
    return profilesInstance.isDisplayNameValid(displayName);
  };

  public shared ({caller}) func updateDisplayName(displayName :Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    return profilesInstance.updateDisplayName(Principal.toText(caller), displayName);
  };

  public shared ({caller}) func updateFavouriteTeam(favouriteTeamId :Nat16) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    return profilesInstance.updateFavouriteTeam(Principal.toText(caller), favouriteTeamId);
  };

  public shared ({caller}) func updateProfilePicture(profilePicture :Blob) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);

    let sizeInKB = Array.size(Blob.toArray(profilePicture)) / 1024;
    if (sizeInKB > 4000) {
      return #err(#NotAllowed);
    };

    return profilesInstance.updateProfilePicture(Principal.toText(caller), profilePicture);
  };

  public shared ({caller}) func getAccountBalanceDTO() : async DTOs.AccountBalanceDTO {
    
    assert not Principal.isAnonymous(caller);
    let principalName = Principal.toText(caller);
    var icpBalance = Nat64.fromNat(0);
    var fplBalance = Nat64.fromNat(0);

    icpBalance := await bookInstance.getUserAccountBalance(Principal.fromActor(Self), caller);

    let tokenCanisterUser: T.Account = {
      owner = Principal.fromActor(tokenCanister);
      subaccount = Account.principalToSubaccount(caller);
    };

    fplBalance := Nat64.fromNat(await tokenCanister.icrc1_balance_of(tokenCanisterUser));
    
    let accountBalanceDTO: DTOs.AccountBalanceDTO = {
      icpBalance = icpBalance;
      fplBalance = fplBalance;
    };

    return accountBalanceDTO;
  };

  private func getICPDepositAccount(caller: Principal) : Account.AccountIdentifier {
    Account.accountIdentifier(Principal.fromActor(Self), Account.principalToSubaccount(caller))
  };
  
  private func getFPLDepositAccount(caller: Principal) : Account.AccountIdentifier {
    Account.accountIdentifier(Principal.fromActor(tokenCanister), Account.principalToSubaccount(caller))
  };

  public shared ({caller}) func withdrawICP(amount: Float, withdrawalAddress: Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    
    let userProfile = profilesInstance.getProfile(Principal.toText(caller));
    
    switch userProfile {
      case (null) {
        return #err(#NotFound);
      };
      case (?profile) {
        if(not profilesInstance.isWalletValid(withdrawalAddress)){
          return #err(#NotAllowed);
        };
        return await bookInstance.withdrawICP(Principal.fromActor(Self), caller, amount, withdrawalAddress);
      };
    };
  };

  //Season Functions
  public shared query ({caller}) func getSeasons() : async [T.Season] {
      return seasonManager.getSeasons();
  };

  //League functions
  public shared query ({caller}) func getSeasonTop10() : async T.Leaderboard {
      return fantasyTeamsInstance.getSeasonTop10(seasonManager.getActiveSeasonId());
  };

  public shared query ({caller}) func getWeeklyTop10() : async T.Leaderboard {
      return fantasyTeamsInstance.getWeeklyTop10(seasonManager.getActiveSeasonId(), seasonManager.getActiveGameweek());
  };

  public shared query ({caller}) func getWeeklyLeaderboard(seasonId: Nat16, gameweek: Nat8, limit: Nat, offset: Nat) : async T.PaginatedLeaderboard {
      return fantasyTeamsInstance.getWeeklyLeaderboard(seasonId, gameweek, limit, offset);
  };

  public shared query ({caller}) func getSeasonLeaderboard(seasonId: Nat16, limit: Nat, offset: Nat) : async T.PaginatedLeaderboard {
      return fantasyTeamsInstance.getSeasonLeaderboard(seasonId, limit, offset);
  };
  
  private func addInitialFixtures(proposalPayload: T.AddInitialFixturesPayload) : async () {
    await seasonManager.addInitialFixtures(proposalPayload);
  };

  private func rescheduleFixture(proposalPayload: T.RescheduleFixturePayload) : async () {
    await seasonManager.rescheduleFixture(proposalPayload);
  };

  private func transferPlayer(proposalPayload: T.TransferPlayerPayload) : async () {
    await playerCanister.transferPlayer(proposalPayload);
  };

  private func loanPlayer(proposalPayload: T.LoanPlayerPayload) : async () {
    await playerCanister.loanPlayer(proposalPayload);
  };

  private func recallPlayer(proposalPayload: T.RecallPlayerPayload) : async () {
    await playerCanister.recallPlayer(proposalPayload);
  };

  private func createPlayer(proposalPayload: T.CreatePlayerPayload) : async () {
    await playerCanister.createPlayer(proposalPayload);
  };

  private func updatePlayer(proposalPayload: T.UpdatePlayerPayload) : async () {
    await playerCanister.updatePlayer(proposalPayload);
  };

  private func setPlayerInjury(proposalPayload: T.SetPlayerInjuryPayload) : async () {
    await playerCanister.setPlayerInjury(proposalPayload);
  };

  private func retirePlayer(proposalPayload: T.RetirePlayerPayload) : async () {
    await playerCanister.retirePlayer(proposalPayload);
  };

  private func unretirePlayer(proposalPayload: T.UnretirePlayerPayload) : async () {
    await playerCanister.unretirePlayer(proposalPayload);
  };

  private func promoteTeam(proposalPayload: T.PromoteTeamPayload) : async () {
    await teamsInstance.promoteTeam(proposalPayload);
  };

  private func relegateTeam(proposalPayload: T.RelegateTeamPayload) : async () {
    await teamsInstance.relegateTeam(proposalPayload);
  };

  private func updateTeam(proposalPayload: T.UpdateTeamPayload) : async () {
    await teamsInstance.updateTeam(proposalPayload);
  };

  private func proposalExpiredCallback() : async () {
    await governanceInstance.proposalExpired();
    removeExpiredTimers();
  };

  private func gameweekBeginExpiredCallback() : async () {
    await seasonManager.gameweekBegin();
    removeExpiredTimers();
  };

  private func gameKickOffExpiredCallback() : async () {
    await seasonManager.gameKickOff();
    removeExpiredTimers();
  };

  private func gameCompletedExpiredCallback() : async () {
    await seasonManager.gameCompleted();
    removeExpiredTimers();
  };

  private func votingPeriodOverExpiredCallback() : async () {
    await seasonManager.votingPeriodOver();
    removeExpiredTimers();
  };
  
  private func removeExpiredTimers() : () {
      let currentTime = Time.now();
      stable_timers := Array.filter<T.TimerInfo>(stable_timers, func(timer: T.TimerInfo) : Bool {
          return timer.triggerTime > currentTime;
      });
  };

  private func defaultCallback() : async () { };
  
  private func setAndBackupTimer(duration: Timer.Duration, callbackName: Text, fixtureId: T.FixtureId) : async () {
    let jobId: Timer.TimerId = switch(callbackName) {
        case "proposalExpired" {
            Timer.setTimer(duration, proposalExpiredCallback);
        };
        case "gameweekBeginExpired" {
            Timer.setTimer(duration, gameweekBeginExpiredCallback);
        };
        case "gameKickOffExpired" {
            Timer.setTimer(duration, gameKickOffExpiredCallback);
        };
        case "gameCompletedExpired" {
            Timer.setTimer(duration, gameCompletedExpiredCallback);
        };
        case "votingPeriodOverExpired" {
            Timer.setTimer(duration, votingPeriodOverExpiredCallback);
        };
        case _ {
            Timer.setTimer(duration, defaultCallback);
        }
    };

    let triggerTime = switch (duration) {
        case (#seconds s) {
            Time.now() + s * 1_000_000_000;
        };
        case (#nanoseconds ns) {
            Time.now() + ns;
        };
    };

    let timerInfo: T.TimerInfo = {
      id = jobId;
      triggerTime = triggerTime;
      callbackName = callbackName;
      playerId = 0;
      fixtureId = 0;
    };

    var timerBuffer = Buffer.fromArray<T.TimerInfo>(stable_timers);
    timerBuffer.add(timerInfo);
    stable_timers := Buffer.toArray(timerBuffer);
  };

  private stable var stable_timers: [T.TimerInfo] = [];

  private func finaliseFixture(seasonId: T.SeasonId, gameweekNumber: T.GameweekNumber, fixtureId: T.FixtureId): async (){
    await seasonManager.fixtureConsensusReached(seasonId, gameweekNumber, fixtureId);
  };

  let governanceInstance = Governance.Governance(transferPlayer, loanPlayer, recallPlayer, createPlayer,
      updatePlayer, setPlayerInjury, retirePlayer, unretirePlayer, promoteTeam, relegateTeam, updateTeam);

  //Fantasy team functions
  public shared query ({caller}) func getTotalManagers() : async Nat {
      return fantasyTeamsInstance.getTotalManagers();
  };

  public shared query ({caller}) func getFantasyTeam() : async T.FantasyTeam {
    assert not Principal.isAnonymous(caller);

    let principalId = Principal.toText(caller);
    let fantasyTeam = fantasyTeamsInstance.getFantasyTeam(principalId);

    switch (fantasyTeam) {
        case (null) { return {
          principalId = "";
          transfersAvailable = 0;
          bankBalance = 0;
          playerIds = [];
          captainId = 0;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          teamBoostGameweek = 0;
          teamBoostTeamId = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          braceBonusGameweek = 0;
          hatTrickHeroGameweek = 0;
        }; };
        case (?team) 
        { 
          return team.fantasyTeam;
        };
    };
  };

  public shared ({caller}) func saveFantasyTeam(newPlayerIds: [Nat16], captainId: Nat16, bonusId: Nat8, bonusPlayerId: Nat16, bonusTeamId: Nat16) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);

    if(not seasonManager.getTransfersAllowed()){
      return #err(#NotAllowed);
    };

    let principalId = Principal.toText(caller);
    let fantasyTeam = fantasyTeamsInstance.getFantasyTeam(principalId);

    let allPlayers = await playerCanister.getAllPlayers();

    let newPlayers = Array.filter<DTOs.PlayerDTO>(allPlayers, func (player: DTOs.PlayerDTO): Bool {
        let playerId = player.id;
        let isPlayerIdInNewTeam = Array.find(newPlayerIds, func (id: Nat16): Bool {
            return id == playerId;
        });
        return Option.isSome(isPlayerIdInNewTeam);
    });

    switch (fantasyTeam) {
        case (null) { return fantasyTeamsInstance.createFantasyTeam(principalId, seasonManager.getActiveGameweek(), newPlayers, captainId, bonusId, bonusPlayerId, bonusTeamId); };
        case (?team) 
        { 

          let existingPlayers = Array.filter<DTOs.PlayerDTO>(allPlayers, func (player: DTOs.PlayerDTO): Bool {
              let playerId = player.id;
              let isPlayerIdInExistingTeam = Array.find(team.fantasyTeam.playerIds, func (id: Nat16): Bool {
                  return id == playerId;
              });
              return Option.isSome(isPlayerIdInExistingTeam);
          });
          
          return await fantasyTeamsInstance.updateFantasyTeam(principalId, newPlayers, captainId, bonusId, bonusPlayerId, bonusTeamId, seasonManager.getActiveGameweek(), existingPlayers); 
        };
    };
  };

  public shared query ({caller}) func getValidatableFixtures() : async [T.Fixture]{
    assert not Principal.isAnonymous(caller);
    return seasonManager.getValidatableFixtures();
  };

  public shared ({caller}) func savePlayerEvents(fixtureId: T.FixtureId, playerEvents: [T.PlayerEventData]) : async (){
    assert not Principal.isAnonymous(caller);

    let validPlayerEvents = validatePlayerEvents(playerEvents);
    if(not validPlayerEvents){
      return;
    };

    if(governanceInstance.getVotingPower(Principal.toText(caller)) == 0){
      return;
    };

    let activeSeasonId = seasonManager.getActiveSeasonId();
    let activeGameweek = seasonManager.getActiveGameweek();
    let fixture = await seasonManager.getFixture(activeSeasonId, activeGameweek, fixtureId);

    if(fixture.status != 2){
      return;
    };

    //infer additional player events
      //goals conceded
      //clean sheet


    await governanceInstance.submitPlayerEventData(Principal.toText(caller), fixtureId, playerEvents);
    
    //update the fixture score

  };
  


  private func validatePlayerEvents(playerEvents: [T.PlayerEventData]) : Bool {

    let eventsBelow0 =  Array.filter<T.PlayerEventData>(playerEvents, func(event: T.PlayerEventData) : Bool {
        return event.eventStartMinute < 0;
    });

    if(Array.size(eventsBelow0) > 0){
      return false;
    };

    let eventsAbove90 =  Array.filter<T.PlayerEventData>(playerEvents, func(event: T.PlayerEventData) : Bool {
      return event.eventStartMinute > 90;
    });

    if(Array.size(eventsAbove90) > 0){
      return false;
    };

    let playerEventsMap: TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>> = TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>>(Utilities.eqNat16, Utilities.hashNat16);

    
    for (playerEvent in Iter.fromArray(playerEvents)) {
        switch (playerEventsMap.get(playerEvent.playerId)) {
            case (null) { };
            case (?existingEvents) {
                playerEventsMap.put(playerEvent.playerId, List.push<T.PlayerEventData>(playerEvent, existingEvents));
            };
        }
    };
    
    for ((playerId, events) in playerEventsMap.entries()) { 
      let redCards = List.filter<T.PlayerEventData>(events, func(event: T.PlayerEventData) : Bool {
          return event.eventType == 9; // Red Card
      });

      if (List.size<T.PlayerEventData>(redCards) > 1) {
          return false;
      };

      let yellowCards = List.filter<T.PlayerEventData>(events, func(event: T.PlayerEventData) : Bool {
          return event.eventType == 8; // Yellow Card
      });

      if (List.size<T.PlayerEventData>(yellowCards) > 2) {
          return false;
      };

      if (List.size<T.PlayerEventData>(yellowCards) == 2 and List.size<T.PlayerEventData>(redCards) != 1) {
          return false;
      };

      let assists = List.filter<T.PlayerEventData>(events, func(event: T.PlayerEventData) : Bool {
          return event.eventType == 2; // Goal Assisted
      });

      for (assist in Iter.fromList(assists)) {
          let goalsAtSameMinute = List.filter<T.PlayerEventData>(events, func(event: T.PlayerEventData) : Bool {
              return event.eventType == 1 and event.eventStartMinute == assist.eventStartMinute; // Goal Scored at the same minute
          });

          if (List.size<T.PlayerEventData>(goalsAtSameMinute) == 0) {
              return false;
          }
      };

        let penaltySaves = List.filter<T.PlayerEventData>(events, func(event: T.PlayerEventData) : Bool {
            return event.eventType == 6; // Penalty Saved
        });

        for (penaltySave in Iter.fromList(penaltySaves)) {
            let penaltyMissesAtSameMinute = List.filter<T.PlayerEventData>(events, func(event: T.PlayerEventData) : Bool {
                return event.eventType == 7 and event.eventStartMinute == penaltySave.eventStartMinute; // Penalty Missed at the same minute
            });

            if (List.size<T.PlayerEventData>(penaltyMissesAtSameMinute) == 0) {
                return false;
            }
        };
    };
    
    return true;
  };



  private func resetTransfers(): async () {
    await fantasyTeamsInstance.resetTransfers();
  };

  private func calculatePlayerScores(activeSeason: T.SeasonId, activeGameweek: T.GameweekNumber, fixture: T.Fixture): async T.Fixture {
    return await playerCanister.calculatePlayerScores(activeSeason, activeGameweek, fixture);
  };  

  private func getConsensusPlayerEventData(gameweekId: Nat8, fixtureId: Nat32) : async List.List<T.PlayerEventData>{
    return await governanceInstance.getConsensusPlayerEventData(gameweekId, fixtureId);
  };

  private func distributeRewards(): async () {
    await rewardsInstance.distributeRewards();
  };

  private func settleUserBets(): async (){
    await privateLeaguesInstance.settleUserBets();
  };

  private func revaluePlayers(activeSeasonId: Nat16, activeGameweek: Nat8): async (){
    let revaluedPlayers = await governanceInstance.getRevaluedPlayers(activeSeasonId, activeGameweek);
    await playerCanister.revaluePlayers(revaluedPlayers);
  };

  private func snapshotGameweek(seaasonId: Nat16): async (){
    await fantasyTeamsInstance.snapshotGameweek(seaasonId);
  };

  private func calculateFantasyTeamScores(seasonId: Nat16, gameweek: Nat8) : async (){
    return await fantasyTeamsInstance.calculateFantasyTeamScores(seasonId, gameweek);
  };

  private func resetFantasyTeams(): async () {
    await fantasyTeamsInstance.resetFantasyTeams();
  };

  private func mintWeeklyRewardsPool(): async () {
    //IMPLEMENT
  };

  private func mintAnnualRewardsPool(): async () {
    //IMPLEMENT
  };

  public func initGenesisSeason(): async (){
    let firstFixture: T.Fixture = { id = 1; seasonId = 1; gameweek = 1; kickOff = 1691415000000000000; homeTeamId = 6; awayTeamId = 13; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; };
    await seasonManager.init_genesis_season(firstFixture);
  };
  
  //intialise season manager
  let seasonManager = SeasonManager.SeasonManager(
    resetTransfers, 
    calculatePlayerScores, 
    distributeRewards, 
    settleUserBets, 
    revaluePlayers, 
    snapshotGameweek, 
    mintWeeklyRewardsPool, 
    mintAnnualRewardsPool, 
    calculateFantasyTeamScores, 
    getConsensusPlayerEventData,
    getAllPlayersMap,
    resetFantasyTeams,
    governanceInstance.getEventDataVotePeriod(),
    stable_timers);
    
    governanceInstance.setFixtureFunctions(addInitialFixtures, rescheduleFixture);
    governanceInstance.setTimerBackupFunction(setAndBackupTimer);
    seasonManager.setTimerBackupFunction(setAndBackupTimer);
    governanceInstance.setFinaliseFixtureFunction(finaliseFixture);



  //IMPLEMENT: SUBMIT PROPOSAL SUBMISSION FEE ON SUBMISSION OF PROPOSAL ON FRONT END
  
  //stable variable backup
  private stable var stable_profiles: [(Text, T.Profile)] = [];
  private stable var stable_fantasy_teams: [(Text, T.UserFantasyTeam)] = [];
  private stable var stable_active_season_id : Nat16 = 0;
  private stable var stable_active_gameweek : Nat8 = 0;
  private stable var stable_fixture_data_submissions: [(T.FixtureId, List.List<T.DataSubmission>)] = [];
  private stable var stable_player_revaluation_submissions: [(T.SeasonId, (T.GameweekNumber, (T.PlayerId, List.List<T.PlayerValuationSubmission>)))] = [];
  private stable var stable_proposals: [T.Proposal] = [];
  private stable var stable_transfers_allowed : Bool = true;
  private stable var stable_active_fixtures : [T.Fixture] = [];
  private stable var stable_next_fixture_id : Nat32 = 0;
  private stable var stable_next_season_id : Nat16 = 0;
  private stable var stable_seasons : [T.Season] = [];
  private stable var stable_teams : [T.Team] = [];
  private stable var stable_relegated_teams : [T.Team] = [];
  private stable var stable_next_team_id : Nat16 = 0;
  private stable var stable_event_data_vote_period : Int = 0;
  private stable var stable_event_data_vote_threshold : Nat64 = 0;
  private stable var stable_revaluation_vote_threshold : Nat64 = 0;
  private stable var stable_proposal_vote_threshold : Nat64 = 0;
  private stable var stable_max_votes_per_user : Nat64 = 0;
  private stable var stable_proposal_submission_e8_fee : Nat64 = 0;
  private stable var stable_season_leaderboards: [(Nat16, T.SeasonLeaderboards)] = [];
  private stable var stable_consensus_fixture_data: [(T.FixtureId, T.ConsensusData)] = [];
  
  system func preupgrade() {
    stable_profiles := profilesInstance.getProfiles();
    stable_fantasy_teams := fantasyTeamsInstance.getFantasyTeams();
    stable_active_season_id := seasonManager.getActiveSeasonId();
    stable_active_gameweek := seasonManager.getActiveGameweek();
    stable_fixture_data_submissions := governanceInstance.getFixtureDataSubmissions();
    stable_player_revaluation_submissions := governanceInstance.getPlayerRevaluationSubmissions();
    stable_proposals := governanceInstance.getProposals();
    stable_transfers_allowed := seasonManager.getTransfersAllowed();
    stable_active_fixtures := seasonManager.getActiveFixtures();
    stable_next_fixture_id := seasonManager.getNextFixtureId();
    stable_next_season_id := seasonManager.getNextSeasonId();
    stable_seasons := seasonManager.getSeasons();
    stable_teams := teamsInstance.getTeams();
    stable_relegated_teams := teamsInstance.getRelegatedTeams();
    stable_next_team_id := teamsInstance.getNextTeamId();
    stable_event_data_vote_period := governanceInstance.getEventDataVotePeriod();
    stable_event_data_vote_threshold := governanceInstance.getEventDataVoteThreshold();
    stable_revaluation_vote_threshold := governanceInstance.getRevaluationVoteThreshold();
    stable_proposal_vote_threshold := governanceInstance.getProposalVoteThreshold();
    stable_max_votes_per_user := governanceInstance.getMaxVotesPerUser();
    stable_proposal_submission_e8_fee := governanceInstance.getProposalSubmissione8Fee();
    stable_season_leaderboards := fantasyTeamsInstance.getSeasonLeaderboards();
    stable_consensus_fixture_data := governanceInstance.getConsensusFixtureData();
  };

  system func postupgrade() {
    profilesInstance.setData(stable_profiles);
    fantasyTeamsInstance.setData(stable_fantasy_teams);
    seasonManager.setData(stable_seasons, stable_active_season_id, stable_active_gameweek, stable_transfers_allowed, stable_active_fixtures, stable_next_fixture_id, stable_next_season_id);
    stable_fixture_data_submissions := governanceInstance.getFixtureDataSubmissions();
    teamsInstance.setData(stable_teams, stable_next_team_id, stable_relegated_teams);
    governanceInstance.setData(stable_fixture_data_submissions, stable_player_revaluation_submissions, stable_proposals, stable_consensus_fixture_data);
    governanceInstance.setEventDataVotePeriod(stable_event_data_vote_period);
    governanceInstance.setEventDataVoteThreshold(stable_event_data_vote_threshold);
    governanceInstance.setRevaluationVoteThreshold(stable_revaluation_vote_threshold);
    governanceInstance.setProposalVoteThreshold(stable_proposal_vote_threshold);
    governanceInstance.setMaxVotesPerUser(stable_max_votes_per_user);
    governanceInstance.setProposalSubmissione8Fee(stable_proposal_submission_e8_fee);
    fantasyTeamsInstance.setDataForSeasonLeaderboards(stable_season_leaderboards);
    recreateTimers();
  };

  private func recreateTimers(){
      let currentTime = Time.now();
      for (timerInfo in Iter.fromArray(stable_timers)) {
          let remainingDuration = timerInfo.triggerTime - currentTime;

          if (remainingDuration > 0) { 
              let duration: Timer.Duration =  #nanoseconds(Int.abs(remainingDuration));

              switch(timerInfo.callbackName) {
                  case "proposalExpired" {
                      ignore Timer.setTimer(duration, proposalExpiredCallback);
                  };
                  case "gameweekBeginExpired" {
                      ignore Timer.setTimer(duration, gameweekBeginExpiredCallback);
                  };
                  case "gameKickOffExpired" {
                      ignore Timer.setTimer(duration, gameKickOffExpiredCallback);
                  };
                  case "gameCompletedExpired" {
                      ignore Timer.setTimer(duration, gameCompletedExpiredCallback);
                  };
                  case "votingPeriodOverExpired" {
                      ignore Timer.setTimer(duration, votingPeriodOverExpiredCallback);
                  };
                  case _ {
                      ignore Timer.setTimer(duration, defaultCallback);
                  }
              };
          }
      }
  };

};
