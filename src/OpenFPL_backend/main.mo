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
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";

actor Self {

  let profilesInstance = Profiles.Profiles();
  let bookInstance = Book.Book();
  let teamsInstance = Teams.Teams();
  let rewardsInstance = Rewards.Rewards();
  let privateLeaguesInstance = PrivateLeagues.PrivateLeagues();
  
  
  /*
  //USE FOR LOCAL DEV
  let CANISTER_IDS = {
    token_canister = "br5f7-7uaaa-aaaaa-qaaca-cai";
    player_canister = "be2us-64aaa-aaaaa-qaabq-cai";
  };
  */
  //Live canisters  
  let CANISTER_IDS = {
    player_canister = "pec6o-uqaaa-aaaal-qb7eq-cai";
    token_canister = "hwd4h-eyaaa-aaaal-qb6ra-cai";
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
    getPlayersDetailsForGameweek: (playerIds: [T.PlayerId], seasonId: Nat16, gameweek: Nat8) -> async [DTOs.PlayerPointsDTO];
    recalculatePlayerScores: (fixture: T.Fixture, seasonId: Nat16, gameweek: Nat8) -> async ();
  };

  private func getAllPlayersMap(seasonId: Nat16, gameweek: Nat8): async [(Nat16, DTOs.PlayerScoreDTO)] {
    return await playerCanister.getAllPlayersMap(seasonId, gameweek);
  }; 

  private func getAllPlayers(): async [DTOs.PlayerDTO] {
    return await playerCanister.getAllPlayers();
  }; 

  private func getPlayer(playerId: Nat16): async T.Player {
    return await playerCanister.getPlayer(playerId);
  }; 

  private func getProfiles(): [(Text, T.Profile)] {
    return profilesInstance.getProfiles();
  }; 

  let fantasyTeamsInstance = FantasyTeams.FantasyTeams(getAllPlayersMap, getPlayer, getProfiles, getAllPlayers);

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

  public query ({caller}) func getTransfersAllowed() : async Bool {
    return seasonManager.getTransfersAllowed();
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

  public shared ({caller}) func getPublicProfileDTO(principalId: Text) : async DTOs.ProfileDTO {
    var icpDepositAddress = Blob.fromArray([]);
    var fplDepositAddress = Blob.fromArray([]);
    var displayName = "";
    var membershipType = Nat8.fromNat(0);
    var profilePicture = Blob.fromArray([]);
    var favouriteTeamId = Nat16.fromNat(0);
    var createDate: Int = 0;
    var reputation = Nat32.fromNat(0);

    var profile = profilesInstance.getProfile(principalId);
    
    switch(profile){
      case (null){};
      case (?p){
        displayName := p.displayName;
        membershipType := p.membershipType;
        profilePicture := p.profilePicture;
        favouriteTeamId := p.favouriteTeamId;
        reputation := p.reputation;
      };
    };

    let profileDTO: DTOs.ProfileDTO = {
      principalName = principalId;
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
  public shared query ({caller}) func getSeasonTop10() : async T.PaginatedLeaderboard {
      
      let top10 = fantasyTeamsInstance.getSeasonTop10(seasonManager.getActiveSeasonId());
      
      return {
        seasonId = top10.seasonId;
        gameweek = top10.gameweek;
        entries = List.toArray(top10.entries);
        totalEntries = 10;
      };
      
      
  };

  public shared query ({caller}) func getWeeklyTop10() : async T.PaginatedLeaderboard {
    let top10 = fantasyTeamsInstance.getWeeklyTop10(seasonManager.getActiveSeasonId(), seasonManager.getActiveGameweek());
      
      return {
        seasonId = top10.seasonId;
        gameweek = top10.gameweek;
        entries = List.toArray(top10.entries);
        totalEntries = 10;
      };
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

  public shared ({caller}) func savePlayerEvents(fixtureId: T.FixtureId, allPlayerEvents: [T.PlayerEventData]) : async (){
    
    assert not Principal.isAnonymous(caller);
    let validPlayerEvents = validatePlayerEvents(allPlayerEvents);
    
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

    let allPlayerEventsBuffer = Buffer.fromArray<T.PlayerEventData>(allPlayerEvents);

    let allPlayers = await playerCanister.getAllPlayers();

    let homeTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
    let awayTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
    
    for (event in Iter.fromArray(allPlayerEvents)) {
        if (event.teamId == fixture.homeTeamId) {
            homeTeamPlayerIdsBuffer.add(event.playerId);
        } else if (event.teamId == fixture.awayTeamId) {
            awayTeamPlayerIdsBuffer.add(event.playerId);
        };
    };

    
    let homeTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
    let awayTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

    for(playerId in Iter.fromArray<Nat16>(Buffer.toArray(homeTeamPlayerIdsBuffer))){
      let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p: DTOs.PlayerDTO): Bool { return p.id == playerId; });
          switch (player) {
              case (null) { /* do nothing */ };
              case (?actualPlayer) {
                  if (actualPlayer.position == 0 or actualPlayer.position == 1) {
                      if(Array.find<Nat16>(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer), func(x: Nat16): Bool { return x == playerId; }) == null) {
                          homeTeamDefensivePlayerIdsBuffer.add(playerId);
                      }
                  };
              };
          };
    };

    for(playerId in Iter.fromArray<Nat16>(Buffer.toArray(awayTeamPlayerIdsBuffer))){
      let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p: DTOs.PlayerDTO): Bool { return p.id == playerId; });
          switch (player) {
              case (null) { /* do nothing */ };
              case (?actualPlayer) {
                  if (actualPlayer.position == 0 or actualPlayer.position == 1) {
                      if(Array.find<Nat16>(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer), func(x: Nat16): Bool { return x == playerId; }) == null) {
                          awayTeamDefensivePlayerIdsBuffer.add(playerId);
                      }
                  };
              };
          };
    };


    // Get goals for each team
    let homeTeamGoals = Array.filter<T.PlayerEventData>(allPlayerEvents, func(event: T.PlayerEventData) : Bool {
        return event.teamId == fixture.homeTeamId and event.eventType == 1;
    });

    let awayTeamGoals = Array.filter<T.PlayerEventData>(allPlayerEvents, func(event: T.PlayerEventData) : Bool {
        return event.teamId == fixture.awayTeamId and event.eventType == 1;
    });

    let homeTeamOwnGoals = Array.filter<T.PlayerEventData>(allPlayerEvents, func(event: T.PlayerEventData) : Bool {
      return event.teamId == fixture.homeTeamId and event.eventType == 10;
    });

    let awayTeamOwnGoals = Array.filter<T.PlayerEventData>(allPlayerEvents, func(event: T.PlayerEventData) : Bool {
      return event.teamId == fixture.awayTeamId and event.eventType == 10;
    });

    let totalHomeScored = Array.size(homeTeamGoals) + Array.size(awayTeamOwnGoals);
    let totalAwayScored = Array.size(awayTeamGoals) + Array.size(homeTeamOwnGoals);

    if(totalHomeScored == 0){
      //add away team clean sheets
      for(playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))){
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p: DTOs.PlayerDTO): Bool { return p.id == playerId; });
        switch (player) {
            case (null) {  };
            case (?actualPlayer) {
              let cleanSheetEvent: T.PlayerEventData = {
                fixtureId = fixtureId;
                playerId = playerId;
                eventType = 5;
                eventStartMinute = 90;
                eventEndMinute = 90;
                teamId = actualPlayer.teamId;
                position = actualPlayer.position;
              };
              allPlayerEventsBuffer.add(cleanSheetEvent);
            };
        };
      };
    } else {
      //add away team conceded events
      for (goal in Iter.fromArray(homeTeamGoals)) {
        for(playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))){
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p: DTOs.PlayerDTO): Bool { return p.id == playerId; });
          switch (player) {
              case (null) {  };
              case (?actualPlayer) {
                let concededEvent: T.PlayerEventData = {
                  fixtureId = fixtureId;
                  playerId = actualPlayer.id;
                  eventType = 3;
                  eventStartMinute = goal.eventStartMinute;
                  eventEndMinute = goal.eventStartMinute;
                  teamId = actualPlayer.teamId;
                  position = actualPlayer.position;
                };
                allPlayerEventsBuffer.add(concededEvent);
              };
          };
        };
      };
    };

    if(totalAwayScored == 0){
      //add home team clean sheets
      for(playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))){
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p: DTOs.PlayerDTO): Bool { return p.id == playerId; });
        switch (player) {
            case (null) {  };
            case (?actualPlayer) {
              let cleanSheetEvent: T.PlayerEventData = {
                fixtureId = fixtureId;
                playerId = playerId;
                eventType = 5;
                eventStartMinute = 90;
                eventEndMinute = 90;
                teamId = actualPlayer.teamId;
                position = actualPlayer.position;
              };
              allPlayerEventsBuffer.add(cleanSheetEvent);
            };
        };
      };
    } else {
      //add home team conceded events
      for (goal in Iter.fromArray(awayTeamGoals)) {
        for(playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))){
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p: DTOs.PlayerDTO): Bool { return p.id == playerId; });
          switch (player) {
              case (null) {  };
              case (?actualPlayer) {
                let concededEvent: T.PlayerEventData = {
                  fixtureId = goal.fixtureId;
                  playerId = actualPlayer.id;
                  eventType = 3;
                  eventStartMinute = goal.eventStartMinute;
                  eventEndMinute = goal.eventStartMinute;
                  teamId = actualPlayer.teamId;
                  position = actualPlayer.position;
                };
                allPlayerEventsBuffer.add(concededEvent);
              };
          };
        };
      };
    };

    await governanceInstance.submitPlayerEventData(Principal.toText(caller), fixtureId, Buffer.toArray(allPlayerEventsBuffer));
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
    let adjFixtures = await playerCanister.calculatePlayerScores(activeSeason, activeGameweek, fixture); 
    return adjFixtures;
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

  private func snapshotGameweek(seasonId: Nat16, gameweek: Nat8): async (){
    await fantasyTeamsInstance.snapshotGameweek(seasonId, gameweek);
  };

  private func calculateFantasyTeamScores(seasonId: Nat16, gameweek: Nat8) : async (){
    return await fantasyTeamsInstance.calculateFantasyTeamScores(seasonId, gameweek);
  };

  private func resetFantasyTeams(): async () {
    await fantasyTeamsInstance.resetFantasyTeams();
  };

  private func getGameweekFixtures(seasonId: T.SeasonId, gameweek: T.GameweekNumber): [T.Fixture] {
    return seasonManager.getGameweekFixtures(seasonId, gameweek);
  }; 

  private func mintWeeklyRewardsPool(): async () {
    //IMPLEMENT
  };

  private func mintAnnualRewardsPool(): async () {
    //IMPLEMENT
  };

  public shared ({caller}) func getFantasyTeamForGameweek(managerId: Text, seasonId: Nat16, gameweek: Nat8) : async T.FantasyTeamSnapshot {
      return await fantasyTeamsInstance.getFantasyTeamForGameweek(managerId, seasonId, gameweek);
  };

  public shared ({caller}) func getPlayersDetailsForGameweek(playerIds: [T.PlayerId], seasonId: Nat16, gameweek: Nat8) : async [DTOs.PlayerPointsDTO] {
      return await playerCanister.getPlayersDetailsForGameweek(playerIds, seasonId, gameweek);
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
  fantasyTeamsInstance.setGetFixturesFunction(getGameweekFixtures);


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

    stable_fantasy_teams := fantasyTeamsInstance.getFantasyTeams();
    stable_profiles := profilesInstance.getProfiles();
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
                      Debug.print(debug_show "recreate proposalExpired");
                      ignore Timer.setTimer(duration, proposalExpiredCallback);
                  };
                  case "gameweekBeginExpired" {
                      Debug.print(debug_show "recreate gameweekBeginExpired");
                      ignore Timer.setTimer(duration, gameweekBeginExpiredCallback);
                  };
                  case "gameKickOffExpired" {
                      Debug.print(debug_show "recreate gameKickOffExpired");
                      ignore Timer.setTimer(duration, gameKickOffExpiredCallback);
                  };
                  case "gameCompletedExpired" {
                      Debug.print(debug_show "recreate gameCompletedExpired");
                      ignore Timer.setTimer(duration, gameCompletedExpiredCallback);
                  };
                  case "votingPeriodOverExpired" {
                      Debug.print(debug_show "recreate votingPeriodOverExpired");
                      ignore Timer.setTimer(duration, votingPeriodOverExpiredCallback);
                  };
                  case _ {
                      Debug.print(debug_show "recreate unknown");
                      ignore Timer.setTimer(duration, defaultCallback);
                  }
              };
          }
      }
  };

  //TEST ONLY
  public func getConsensusData(): async [(T.FixtureId, List.List<T.DataSubmission>)]{
    return governanceInstance.getFixtureDataSubmissions();
  };

  public func fixIncorrectData(gameweek: T.GameweekNumber) : async (){
    
    var newConsensusFixtureData: HashMap.HashMap<T.FixtureId, T.ConsensusData> = HashMap.HashMap<T.FixtureId, T.ConsensusData>(22, Utilities.eqNat32, Utilities.hashNat32);
    
    let fixture1Data: T.ConsensusData = { 
      fixtureId = 1;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=1; playerId=461; eventStartMinute=0; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=464; eventStartMinute=0; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=468; eventStartMinute=0; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=470; eventStartMinute=0; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=469; eventStartMinute=0; eventEndMinute=74; teamId=6; eventType=0},
        {fixtureId=1; playerId=478; eventStartMinute=74; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=467; eventStartMinute=0; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=482; eventStartMinute=0; eventEndMinute=61; teamId=6; eventType=0},
        {fixtureId=1; playerId=483; eventStartMinute=61; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=529; eventStartMinute=0; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=475; eventStartMinute=90; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=476; eventStartMinute=0; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=485; eventStartMinute=0; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=471; eventStartMinute=0; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=543; eventStartMinute=0; eventEndMinute=61; teamId=6; eventType=0},
        {fixtureId=1; playerId=478; eventStartMinute=74; eventEndMinute=90; teamId=6; eventType=0},
        {fixtureId=1; playerId=461; eventStartMinute=1; eventEndMinute=1; teamId=6; eventType=4},
        {fixtureId=1; playerId=461; eventStartMinute=2; eventEndMinute=2; teamId=6; eventType=4},
        {fixtureId=1; playerId=461; eventStartMinute=3; eventEndMinute=3; teamId=6; eventType=4},
        {fixtureId=1; playerId=461; eventStartMinute=4; eventEndMinute=4; teamId=6; eventType=4},
        {fixtureId=1; playerId=461; eventStartMinute=5; eventEndMinute=5; teamId=6; eventType=4},
        {fixtureId=1; playerId=461; eventStartMinute=4; eventEndMinute=4; teamId=6; eventType=3},
        {fixtureId=1; playerId=461; eventStartMinute=36; eventEndMinute=36; teamId=6; eventType=3},
        {fixtureId=1; playerId=461; eventStartMinute=75; eventEndMinute=75; teamId=6; eventType=3},
        {fixtureId=1; playerId=464; eventStartMinute=4; eventEndMinute=4; teamId=6; eventType=3},
        {fixtureId=1; playerId=464; eventStartMinute=36; eventEndMinute=36; teamId=6; eventType=3},
        {fixtureId=1; playerId=464; eventStartMinute=75; eventEndMinute=75; teamId=6; eventType=3},
        {fixtureId=1; playerId=468; eventStartMinute=4; eventEndMinute=4; teamId=6; eventType=3},
        {fixtureId=1; playerId=468; eventStartMinute=36; eventEndMinute=36; teamId=6; eventType=3},
        {fixtureId=1; playerId=468; eventStartMinute=75; eventEndMinute=75; teamId=6; eventType=3},
        {fixtureId=1; playerId=470; eventStartMinute=4; eventEndMinute=4; teamId=6; eventType=3},
        {fixtureId=1; playerId=470; eventStartMinute=36; eventEndMinute=36; teamId=6; eventType=3},
        {fixtureId=1; playerId=470; eventStartMinute=75; eventEndMinute=75; teamId=6; eventType=3},
        {fixtureId=1; playerId=469; eventStartMinute=4; eventEndMinute=4; teamId=6; eventType=3},
        {fixtureId=1; playerId=469; eventStartMinute=36; eventEndMinute=36; teamId=6; eventType=3},
        {fixtureId=1; playerId=469; eventStartMinute=75; eventEndMinute=75; teamId=6; eventType=3},
        {fixtureId=1; playerId=467; eventStartMinute=4; eventEndMinute=4; teamId=6; eventType=3},
        {fixtureId=1; playerId=467; eventStartMinute=36; eventEndMinute=36; teamId=6; eventType=3},
        {fixtureId=1; playerId=467; eventStartMinute=75; eventEndMinute=75; teamId=6; eventType=3},
        {fixtureId=1; playerId=264; eventStartMinute=0; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=269; eventStartMinute=0; eventEndMinute=79; teamId=13; eventType=0},
        {fixtureId=1; playerId=271; eventStartMinute=0; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=273; eventStartMinute=79; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=275; eventStartMinute=0; eventEndMinute=79; teamId=13; eventType=0},
        {fixtureId=1; playerId=276; eventStartMinute=0; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=277; eventStartMinute=0; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=280; eventStartMinute=23; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=281; eventStartMinute=0; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=282; eventStartMinute=0; eventEndMinute=23; teamId=13; eventType=0},
        {fixtureId=1; playerId=283; eventStartMinute=80; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=284; eventStartMinute=0; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=287; eventStartMinute=0; eventEndMinute=80; teamId=13; eventType=0},
        {fixtureId=1; playerId=288; eventStartMinute=0; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=542; eventStartMinute=79; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=544; eventStartMinute=90; eventEndMinute=90; teamId=13; eventType=0},
        {fixtureId=1; playerId=264; eventStartMinute=0; eventEndMinute=0; teamId=13; eventType=4},
        {fixtureId=1; playerId=264; eventStartMinute=90; eventEndMinute=90; teamId=13; eventType=5},
        {fixtureId=1; playerId=269; eventStartMinute=90; eventEndMinute=90; teamId=13; eventType=5},
        {fixtureId=1; playerId=271; eventStartMinute=90; eventEndMinute=90; teamId=13; eventType=5},
        {fixtureId=1; playerId=273; eventStartMinute=90; eventEndMinute=90; teamId=13; eventType=5},
        {fixtureId=1; playerId=275; eventStartMinute=90; eventEndMinute=90; teamId=13; eventType=5},
        {fixtureId=1; playerId=276; eventStartMinute=90; eventEndMinute=90; teamId=13; eventType=5},
        {fixtureId=1; playerId=542; eventStartMinute=90; eventEndMinute=90; teamId=13; eventType=5},
        {fixtureId=1; playerId=277; eventStartMinute=75; eventEndMinute=75; teamId=13; eventType=1},
        {fixtureId=1; playerId=277; eventStartMinute=4; eventEndMinute=4; teamId=13; eventType=2},
        {fixtureId=1; playerId=287; eventStartMinute=4; eventEndMinute=4; teamId=13; eventType=1},
        {fixtureId=1; playerId=287; eventStartMinute=36; eventEndMinute=36; teamId=13; eventType=1},
        {fixtureId=1; playerId=288; eventStartMinute=36; eventEndMinute=36; teamId=13; eventType=2}
      ]);
    };

    let fixture2Data: T.ConsensusData = { 
      fixtureId = 2;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=2; playerId=1; eventStartMinute=0; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=15; eventStartMinute=0; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=13; eventStartMinute=0; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=4; eventStartMinute=0; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=5; eventStartMinute=86; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=14; eventStartMinute=50; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=18; eventStartMinute=0; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=19; eventStartMinute=0; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=22; eventStartMinute=0; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=26; eventStartMinute=0; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=28; eventStartMinute=0; eventEndMinute=86; teamId=1; eventType=0},
        {fixtureId=2; playerId=29; eventStartMinute=73; eventEndMinute=90; teamId=1; eventType=0},
        {fixtureId=2; playerId=30; eventStartMinute=0; eventEndMinute=73; teamId=1; eventType=0},
        {fixtureId=2; playerId=545; eventStartMinute=0; eventEndMinute=50; teamId=1; eventType=0},
        {fixtureId=2; playerId=545; eventStartMinute=0; eventEndMinute=0; teamId=1; eventType=8},
        {fixtureId=2; playerId=13; eventStartMinute=0; eventEndMinute=0; teamId=1; eventType=8},
        {fixtureId=2; playerId=1; eventStartMinute=1; eventEndMinute=1; teamId=1; eventType=4},
        {fixtureId=2; playerId=4; eventStartMinute=32; eventEndMinute=32; teamId=1; eventType=2},
        {fixtureId=2; playerId=22; eventStartMinute=32; eventEndMinute=32; teamId=1; eventType=1},
        {fixtureId=2; playerId=28; eventStartMinute=26; eventEndMinute=26; teamId=1; eventType=2},
        {fixtureId=2; playerId=30; eventStartMinute=26; eventEndMinute=26; teamId=1; eventType=1},
        {fixtureId=2; playerId=1; eventStartMinute=82; eventEndMinute=82; teamId=1; eventType=3},
        {fixtureId=2; playerId=15; eventStartMinute=82; eventEndMinute=82; teamId=1; eventType=3},
        {fixtureId=2; playerId=13; eventStartMinute=82; eventEndMinute=82; teamId=1; eventType=3},
        {fixtureId=2; playerId=4; eventStartMinute=82; eventEndMinute=82; teamId=1; eventType=3},
        {fixtureId=2; playerId=545; eventStartMinute=82; eventEndMinute=82; teamId=1; eventType=3},
        {fixtureId=2; playerId=352; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=354; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=353; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=358; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=359; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=364; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=365; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=366; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=368; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=371; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=372; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=373; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=376; eventStartMinute=71; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=2; playerId=378; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=0},
        {fixtureId=2; playerId=546; eventStartMinute=0; eventEndMinute=72; teamId=16; eventType=0},
        {fixtureId=2; playerId=2; eventStartMinute=0; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=2; playerId=373; eventStartMinute=82; eventEndMinute=82; teamId=16; eventType=2},
        {fixtureId=2; playerId=376; eventStartMinute=82; eventEndMinute=82; teamId=16; eventType=1},
        {fixtureId=2; playerId=2; eventStartMinute=32; eventEndMinute=32; teamId=16; eventType=3},
        {fixtureId=2; playerId=2; eventStartMinute=26; eventEndMinute=26; teamId=16; eventType=3},
        {fixtureId=2; playerId=352; eventStartMinute=32; eventEndMinute=32; teamId=16; eventType=3},
        {fixtureId=2; playerId=352; eventStartMinute=26; eventEndMinute=26; teamId=16; eventType=3},
        {fixtureId=2; playerId=353; eventStartMinute=32; eventEndMinute=32; teamId=16; eventType=3},
        {fixtureId=2; playerId=353; eventStartMinute=26; eventEndMinute=26; teamId=16; eventType=3},
        {fixtureId=2; playerId=354; eventStartMinute=32; eventEndMinute=32; teamId=16; eventType=3},
        {fixtureId=2; playerId=354; eventStartMinute=26; eventEndMinute=26; teamId=16; eventType=3},
        {fixtureId=2; playerId=358; eventStartMinute=32; eventEndMinute=32; teamId=16; eventType=3},
        {fixtureId=2; playerId=358; eventStartMinute=26; eventEndMinute=26; teamId=16; eventType=3},
        {fixtureId=2; playerId=359; eventStartMinute=32; eventEndMinute=32; teamId=16; eventType=3},
        {fixtureId=2; playerId=359; eventStartMinute=26; eventEndMinute=26; teamId=16; eventType=3},
        {fixtureId=2; playerId=366; eventStartMinute=0; eventEndMinute=0; teamId=1; eventType=8},
        {fixtureId=2; playerId=546; eventStartMinute=0; eventEndMinute=0; teamId=1; eventType=8}
      ]);
    };

    let fixture3Data: T.ConsensusData = { 
      fixtureId = 3;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=3; playerId=59; eventStartMinute=0; eventEndMinute=90; teamId=3; eventType=0},
        {fixtureId=3; playerId=62; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=63; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=65; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=66; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=69; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=70; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=72; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=73; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=74; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=78; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=80; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=81; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=82; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=85; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=0},
        {fixtureId=3; playerId=547; eventStartMinute=0; eventEndMinute=75; teamId=3; eventType=0},
        {fixtureId=3; playerId=408; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=410; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=411; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=412; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=414; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=417; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=419; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=422; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=423; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=424; eventStartMinute=90; eventEndMinute=90; teamId=19; eventType=0},
        {fixtureId=3; playerId=425; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=428; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=548; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=0},
        {fixtureId=3; playerId=59; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=4},
        {fixtureId=3; playerId=408; eventStartMinute=1; eventEndMinute=1; teamId=19; eventType=4},
        {fixtureId=3; playerId=408; eventStartMinute=2; eventEndMinute=2; teamId=19; eventType=4},
        {fixtureId=3; playerId=408; eventStartMinute=3; eventEndMinute=3; teamId=19; eventType=4},
        {fixtureId=3; playerId=408; eventStartMinute=4; eventEndMinute=4; teamId=19; eventType=4},
        {fixtureId=3; playerId=414; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=8},
        {fixtureId=3; playerId=65; eventStartMinute=0; eventEndMinute=0; teamId=3; eventType=8},
        {fixtureId=3; playerId=425; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=8},
        {fixtureId=3; playerId=428; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=8},
        {fixtureId=3; playerId=422; eventStartMinute=0; eventEndMinute=0; teamId=19; eventType=8},
        {fixtureId=3; playerId=78; eventStartMinute=82; eventEndMinute=82; teamId=3; eventType=1},
        {fixtureId=3; playerId=425; eventStartMinute=51; eventEndMinute=51; teamId=19; eventType=1},
        {fixtureId=3; playerId=419; eventStartMinute=51; eventEndMinute=51; teamId=19; eventType=2},
        {fixtureId=3; playerId=59; eventStartMinute=51; eventEndMinute=51; teamId=3; eventType=3},
        {fixtureId=3; playerId=62; eventStartMinute=51; eventEndMinute=51; teamId=3; eventType=3},
        {fixtureId=3; playerId=63; eventStartMinute=51; eventEndMinute=51; teamId=3; eventType=3},
        {fixtureId=3; playerId=65; eventStartMinute=51; eventEndMinute=51; teamId=3; eventType=3},
        {fixtureId=3; playerId=66; eventStartMinute=51; eventEndMinute=51; teamId=3; eventType=3},
        {fixtureId=3; playerId=69; eventStartMinute=51; eventEndMinute=51; teamId=3; eventType=3},
        {fixtureId=3; playerId=408; eventStartMinute=82; eventEndMinute=82; teamId=19; eventType=3},
        {fixtureId=3; playerId=410; eventStartMinute=82; eventEndMinute=82; teamId=19; eventType=3},
        {fixtureId=3; playerId=411; eventStartMinute=82; eventEndMinute=82; teamId=19; eventType=3},
        {fixtureId=3; playerId=412; eventStartMinute=82; eventEndMinute=82; teamId=19; eventType=3},
        {fixtureId=3; playerId=414; eventStartMinute=82; eventEndMinute=82; teamId=19; eventType=3},
        {fixtureId=3; playerId=417; eventStartMinute=82; eventEndMinute=82; teamId=19; eventType=3}
      ]);
    };

    let fixture4Data: T.ConsensusData = { 
      fixtureId = 4;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=4; playerId=116; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=120; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=122; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=124; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=127; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=129; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=131; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=132; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=136; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=137; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=138; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=139; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=140; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=549; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=541; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=0},
        {fixtureId=4; playerId=490; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=492; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=494; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=495; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=497; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=502; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=503; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=505; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=506; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=507; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=508; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=509; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=515; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=550; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=551; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=514; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=0},
        {fixtureId=4; playerId=137; eventStartMinute=36; eventEndMinute=36; teamId=5; eventType=1},
        {fixtureId=4; playerId=138; eventStartMinute=85; eventEndMinute=85; teamId=5; eventType=1},
        {fixtureId=4; playerId=139; eventStartMinute=90; eventEndMinute=90; teamId=5; eventType=1},
        {fixtureId=4; playerId=541; eventStartMinute=71; eventEndMinute=71; teamId=5; eventType=1},
        {fixtureId=4; playerId=507; eventStartMinute=81; eventEndMinute=81; teamId=12; eventType=1},
        {fixtureId=4; playerId=122; eventStartMinute=90; eventEndMinute=90; teamId=5; eventType=2},
        {fixtureId=4; playerId=136; eventStartMinute=36; eventEndMinute=36; teamId=5; eventType=2},
        {fixtureId=4; playerId=550; eventStartMinute=1; eventEndMinute=1; teamId=12; eventType=4},
        {fixtureId=4; playerId=550; eventStartMinute=2; eventEndMinute=2; teamId=12; eventType=4},
        {fixtureId=4; playerId=550; eventStartMinute=3; eventEndMinute=3; teamId=12; eventType=4},
        {fixtureId=4; playerId=550; eventStartMinute=4; eventEndMinute=4; teamId=12; eventType=4},
        {fixtureId=4; playerId=550; eventStartMinute=5; eventEndMinute=5; teamId=12; eventType=4},
        {fixtureId=4; playerId=550; eventStartMinute=6; eventEndMinute=6; teamId=12; eventType=4},
        {fixtureId=4; playerId=550; eventStartMinute=7; eventEndMinute=7; teamId=12; eventType=4},
        {fixtureId=4; playerId=550; eventStartMinute=8; eventEndMinute=8; teamId=12; eventType=4},
        {fixtureId=4; playerId=116; eventStartMinute=1; eventEndMinute=1; teamId=5; eventType=4},
        {fixtureId=4; playerId=116; eventStartMinute=2; eventEndMinute=2; teamId=5; eventType=4},
        {fixtureId=4; playerId=494; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=8},
        {fixtureId=4; playerId=515; eventStartMinute=0; eventEndMinute=0; teamId=12; eventType=8},
        {fixtureId=4; playerId=122; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=8},
        {fixtureId=4; playerId=136; eventStartMinute=0; eventEndMinute=0; teamId=5; eventType=8},
        {fixtureId=4; playerId=550; eventStartMinute=36; eventEndMinute=36; teamId=12; eventType=3},
        {fixtureId=4; playerId=550; eventStartMinute=85; eventEndMinute=85; teamId=12; eventType=3},
        {fixtureId=4; playerId=550; eventStartMinute=90; eventEndMinute=90; teamId=12; eventType=3},
        {fixtureId=4; playerId=490; eventStartMinute=36; eventEndMinute=36; teamId=12; eventType=3},
        {fixtureId=4; playerId=490; eventStartMinute=85; eventEndMinute=85; teamId=12; eventType=3},
        {fixtureId=4; playerId=490; eventStartMinute=90; eventEndMinute=90; teamId=12; eventType=3},
        {fixtureId=4; playerId=492; eventStartMinute=36; eventEndMinute=36; teamId=12; eventType=3},
        {fixtureId=4; playerId=492; eventStartMinute=85; eventEndMinute=85; teamId=12; eventType=3},
        {fixtureId=4; playerId=492; eventStartMinute=90; eventEndMinute=90; teamId=12; eventType=3},
        {fixtureId=4; playerId=494; eventStartMinute=36; eventEndMinute=36; teamId=12; eventType=3},
        {fixtureId=4; playerId=494; eventStartMinute=85; eventEndMinute=85; teamId=12; eventType=3},
        {fixtureId=4; playerId=494; eventStartMinute=90; eventEndMinute=90; teamId=12; eventType=3},
        {fixtureId=4; playerId=515; eventStartMinute=36; eventEndMinute=36; teamId=12; eventType=3},
        {fixtureId=4; playerId=515; eventStartMinute=85; eventEndMinute=85; teamId=12; eventType=3},
        {fixtureId=4; playerId=515; eventStartMinute=90; eventEndMinute=90; teamId=12; eventType=3},
        {fixtureId=4; playerId=116; eventStartMinute=90; eventEndMinute=90; teamId=5; eventType=3},
        {fixtureId=4; playerId=131; eventStartMinute=90; eventEndMinute=90; teamId=5; eventType=3},
        {fixtureId=4; playerId=549; eventStartMinute=90; eventEndMinute=90; teamId=5; eventType=3},
        {fixtureId=4; playerId=120; eventStartMinute=90; eventEndMinute=90; teamId=5; eventType=3},
        {fixtureId=4; playerId=122; eventStartMinute=90; eventEndMinute=90; teamId=5; eventType=3},
        {fixtureId=4; playerId=124; eventStartMinute=90; eventEndMinute=90; teamId=5; eventType=3}
      ]);
    };

    let fixture5Data: T.ConsensusData = { 
      fixtureId = 5;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=5; playerId=194; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=197; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=199; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=203; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=205; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=206; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=207; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=208; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=209; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=213; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=215; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=216; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=552; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=0},
        {fixtureId=5; playerId=217; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=219; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=221; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=226; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=228; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=229; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=230; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=233; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=234; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=235; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=238; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=240; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=232; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=0},
        {fixtureId=5; playerId=233; eventStartMinute=73; eventEndMinute=73; teamId=10; eventType=1},
        {fixtureId=5; playerId=194; eventStartMinute=0; eventEndMinute=0; teamId=9; eventType=4},
        {fixtureId=5; playerId=217; eventStartMinute=1; eventEndMinute=1; teamId=10; eventType=4},
        {fixtureId=5; playerId=217; eventStartMinute=2; eventEndMinute=2; teamId=10; eventType=4},
        {fixtureId=5; playerId=217; eventStartMinute=3; eventEndMinute=3; teamId=10; eventType=4},
        {fixtureId=5; playerId=217; eventStartMinute=4; eventEndMinute=4; teamId=10; eventType=4},
        {fixtureId=5; playerId=217; eventStartMinute=5; eventEndMinute=5; teamId=10; eventType=4},
        {fixtureId=5; playerId=217; eventStartMinute=6; eventEndMinute=6; teamId=10; eventType=4},
        {fixtureId=5; playerId=217; eventStartMinute=7; eventEndMinute=7; teamId=10; eventType=4},
        {fixtureId=5; playerId=217; eventStartMinute=8; eventEndMinute=8; teamId=10; eventType=4},
        {fixtureId=5; playerId=217; eventStartMinute=9; eventEndMinute=9; teamId=10; eventType=4},
        {fixtureId=5; playerId=226; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=8},
        {fixtureId=5; playerId=234; eventStartMinute=0; eventEndMinute=0; teamId=10; eventType=8},
        {fixtureId=5; playerId=217; eventStartMinute=90; eventEndMinute=90; teamId=10; eventType=5},
        {fixtureId=5; playerId=219; eventStartMinute=90; eventEndMinute=90; teamId=10; eventType=5},
        {fixtureId=5; playerId=221; eventStartMinute=90; eventEndMinute=90; teamId=10; eventType=5},
        {fixtureId=5; playerId=225; eventStartMinute=90; eventEndMinute=90; teamId=10; eventType=5},
        {fixtureId=5; playerId=226; eventStartMinute=90; eventEndMinute=90; teamId=10; eventType=5},
        {fixtureId=5; playerId=194; eventStartMinute=73; eventEndMinute=73; teamId=9; eventType=3},
        {fixtureId=5; playerId=199; eventStartMinute=73; eventEndMinute=73; teamId=9; eventType=3},
        {fixtureId=5; playerId=197; eventStartMinute=73; eventEndMinute=73; teamId=9; eventType=3},
        {fixtureId=5; playerId=203; eventStartMinute=73; eventEndMinute=73; teamId=9; eventType=3},
        {fixtureId=5; playerId=216; eventStartMinute=73; eventEndMinute=73; teamId=9; eventType=3}
      ]);
    };

    let fixture6Data: T.ConsensusData = { 
      fixtureId = 6;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=6; playerId=172; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=176; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=177; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=179; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=180; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=182; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=183; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=186; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=187; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=190; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=192; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=193; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=0},
        {fixtureId=6; playerId=517; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=519; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=520; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=521; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=522; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=523; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=524; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=527; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=530; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=532; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=533; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=536; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=538; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=553; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=554; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=6; playerId=555; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=0},
        {fixtureId=9; playerId=172; eventStartMinute=0; eventEndMinute=0; teamId=8; eventType=4},
        {fixtureId=9; playerId=517; eventStartMinute=1; eventEndMinute=1; teamId=17; eventType=4},
        {fixtureId=9; playerId=517; eventStartMinute=2; eventEndMinute=2; teamId=17; eventType=4},
        {fixtureId=9; playerId=517; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=4},
        {fixtureId=9; playerId=517; eventStartMinute=4; eventEndMinute=4; teamId=17; eventType=4},
        {fixtureId=9; playerId=517; eventStartMinute=5; eventEndMinute=5; teamId=17; eventType=4},
        {fixtureId=9; playerId=517; eventStartMinute=6; eventEndMinute=6; teamId=17; eventType=4},
        {fixtureId=9; playerId=517; eventStartMinute=7; eventEndMinute=7; teamId=17; eventType=4},
        {fixtureId=6; playerId=523; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=8},
        {fixtureId=6; playerId=533; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=8},
        {fixtureId=6; playerId=536; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=8},
        {fixtureId=6; playerId=190; eventStartMinute=49; eventEndMinute=49; teamId=8; eventType=1},
        {fixtureId=6; playerId=192; eventStartMinute=49; eventEndMinute=49; teamId=8; eventType=2},
        {fixtureId=6; playerId=172; eventStartMinute=90; eventEndMinute=90; teamId=8; eventType=5},
        {fixtureId=6; playerId=176; eventStartMinute=90; eventEndMinute=90; teamId=8; eventType=5},
        {fixtureId=6; playerId=177; eventStartMinute=90; eventEndMinute=90; teamId=8; eventType=5},
        {fixtureId=6; playerId=179; eventStartMinute=90; eventEndMinute=90; teamId=8; eventType=5},
        {fixtureId=6; playerId=180; eventStartMinute=90; eventEndMinute=90; teamId=8; eventType=5},
        {fixtureId=6; playerId=182; eventStartMinute=90; eventEndMinute=90; teamId=8; eventType=5},
        {fixtureId=6; playerId=517; eventStartMinute=49; eventEndMinute=49; teamId=17; eventType=3},
        {fixtureId=6; playerId=523; eventStartMinute=49; eventEndMinute=49; teamId=17; eventType=3},
        {fixtureId=6; playerId=521; eventStartMinute=49; eventEndMinute=49; teamId=17; eventType=3},
        {fixtureId=6; playerId=524; eventStartMinute=49; eventEndMinute=49; teamId=17; eventType=3}
      ]);
    };

    let fixture7Data: T.ConsensusData = { 
      fixtureId = 7;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=7; playerId=31; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=33; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=34; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=35; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=36; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=40; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=41; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=42; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=44; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=46; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=47; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=49; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=50; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=52; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=54; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=55; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=0},
        {fixtureId=7; playerId=319; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=323; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=324; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=327; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=329; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=333; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=336; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=339; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=340; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=341; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=342; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=344; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=345; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=347; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=348; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=561; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=0},
        {fixtureId=7; playerId=54; eventStartMinute=11; eventEndMinute=11; teamId=2; eventType=1},
        {fixtureId=7; playerId=340; eventStartMinute=90; eventEndMinute=90; teamId=15; eventType=1},
        {fixtureId=7; playerId=347; eventStartMinute=16; eventEndMinute=16; teamId=15; eventType=1},
        {fixtureId=7; playerId=347; eventStartMinute=58; eventEndMinute=58; teamId=15; eventType=1},
        {fixtureId=7; playerId=348; eventStartMinute=77; eventEndMinute=77; teamId=15; eventType=1},
        {fixtureId=7; playerId=561; eventStartMinute=6; eventEndMinute=6; teamId=15; eventType=1},
        {fixtureId=7; playerId=55; eventStartMinute=11; eventEndMinute=11; teamId=2; eventType=2},
        {fixtureId=7; playerId=323; eventStartMinute=16; eventEndMinute=16; teamId=15; eventType=2},
        {fixtureId=7; playerId=340; eventStartMinute=77; eventEndMinute=77; teamId=15; eventType=2},
        {fixtureId=7; playerId=342; eventStartMinute=6; eventEndMinute=6; teamId=15; eventType=2},
        {fixtureId=7; playerId=345; eventStartMinute=90; eventEndMinute=90; teamId=15; eventType=2},
        {fixtureId=7; playerId=31; eventStartMinute=1; eventEndMinute=1; teamId=2; eventType=4},
        {fixtureId=7; playerId=31; eventStartMinute=2; eventEndMinute=2; teamId=2; eventType=4},
        {fixtureId=7; playerId=31; eventStartMinute=3; eventEndMinute=3; teamId=2; eventType=4},
        {fixtureId=7; playerId=31; eventStartMinute=4; eventEndMinute=4; teamId=2; eventType=4},
        {fixtureId=7; playerId=31; eventStartMinute=5; eventEndMinute=5; teamId=2; eventType=4},
        {fixtureId=7; playerId=31; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=4},
        {fixtureId=7; playerId=31; eventStartMinute=7; eventEndMinute=7; teamId=2; eventType=4},
        {fixtureId=7; playerId=319; eventStartMinute=1; eventEndMinute=1; teamId=15; eventType=4},
        {fixtureId=7; playerId=319; eventStartMinute=2; eventEndMinute=2; teamId=15; eventType=4},
        {fixtureId=7; playerId=319; eventStartMinute=3; eventEndMinute=3; teamId=15; eventType=4},
        {fixtureId=7; playerId=319; eventStartMinute=4; eventEndMinute=4; teamId=15; eventType=4},
        {fixtureId=7; playerId=319; eventStartMinute=5; eventEndMinute=5; teamId=15; eventType=4},
        {fixtureId=7; playerId=323; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=8},
        {fixtureId=7; playerId=561; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=8},
        {fixtureId=7; playerId=333; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=8},
        {fixtureId=7; playerId=342; eventStartMinute=0; eventEndMinute=0; teamId=15; eventType=8},
        {fixtureId=7; playerId=31; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=8},
        {fixtureId=7; playerId=40; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=8},
        {fixtureId=7; playerId=41; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=8},
        {fixtureId=7; playerId=46; eventStartMinute=0; eventEndMinute=0; teamId=2; eventType=8},
        {fixtureId=7; playerId=31; eventStartMinute=90; eventEndMinute=90; teamId=2; eventType=3},
        {fixtureId=7; playerId=31; eventStartMinute=16; eventEndMinute=16; teamId=2; eventType=3},
        {fixtureId=7; playerId=31; eventStartMinute=58; eventEndMinute=58; teamId=2; eventType=3},
        {fixtureId=7; playerId=31; eventStartMinute=77; eventEndMinute=77; teamId=2; eventType=3},
        {fixtureId=7; playerId=31; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=3},
        {fixtureId=7; playerId=33; eventStartMinute=90; eventEndMinute=90; teamId=2; eventType=3},
        {fixtureId=7; playerId=33; eventStartMinute=16; eventEndMinute=16; teamId=2; eventType=3},
        {fixtureId=7; playerId=33; eventStartMinute=58; eventEndMinute=58; teamId=2; eventType=3},
        {fixtureId=7; playerId=33; eventStartMinute=77; eventEndMinute=77; teamId=2; eventType=3},
        {fixtureId=7; playerId=33; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=3},
        {fixtureId=7; playerId=34; eventStartMinute=90; eventEndMinute=90; teamId=2; eventType=3},
        {fixtureId=7; playerId=34; eventStartMinute=16; eventEndMinute=16; teamId=2; eventType=3},
        {fixtureId=7; playerId=34; eventStartMinute=58; eventEndMinute=58; teamId=2; eventType=3},
        {fixtureId=7; playerId=34; eventStartMinute=77; eventEndMinute=77; teamId=2; eventType=3},
        {fixtureId=7; playerId=34; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=3},
        {fixtureId=7; playerId=35; eventStartMinute=90; eventEndMinute=90; teamId=2; eventType=3},
        {fixtureId=7; playerId=35; eventStartMinute=16; eventEndMinute=16; teamId=2; eventType=3},
        {fixtureId=7; playerId=35; eventStartMinute=58; eventEndMinute=58; teamId=2; eventType=3},
        {fixtureId=7; playerId=35; eventStartMinute=77; eventEndMinute=77; teamId=2; eventType=3},
        {fixtureId=7; playerId=35; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=90; eventEndMinute=90; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=16; eventEndMinute=16; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=58; eventEndMinute=58; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=77; eventEndMinute=77; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=3},
        {fixtureId=7; playerId=40; eventStartMinute=90; eventEndMinute=90; teamId=2; eventType=3},
        {fixtureId=7; playerId=40; eventStartMinute=16; eventEndMinute=16; teamId=2; eventType=3},
        {fixtureId=7; playerId=40; eventStartMinute=58; eventEndMinute=58; teamId=2; eventType=3},
        {fixtureId=7; playerId=40; eventStartMinute=77; eventEndMinute=77; teamId=2; eventType=3},
        {fixtureId=7; playerId=40; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=3},
        {fixtureId=7; playerId=41; eventStartMinute=90; eventEndMinute=90; teamId=2; eventType=3},
        {fixtureId=7; playerId=41; eventStartMinute=16; eventEndMinute=16; teamId=2; eventType=3},
        {fixtureId=7; playerId=41; eventStartMinute=58; eventEndMinute=58; teamId=2; eventType=3},
        {fixtureId=7; playerId=41; eventStartMinute=77; eventEndMinute=77; teamId=2; eventType=3},
        {fixtureId=7; playerId=41; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=3},
        {fixtureId=7; playerId=52; eventStartMinute=90; eventEndMinute=90; teamId=2; eventType=3},
        {fixtureId=7; playerId=52; eventStartMinute=16; eventEndMinute=16; teamId=2; eventType=3},
        {fixtureId=7; playerId=52; eventStartMinute=58; eventEndMinute=58; teamId=2; eventType=3},
        {fixtureId=7; playerId=52; eventStartMinute=77; eventEndMinute=77; teamId=2; eventType=3},
        {fixtureId=7; playerId=52; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=90; eventEndMinute=90; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=16; eventEndMinute=16; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=58; eventEndMinute=58; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=77; eventEndMinute=77; teamId=2; eventType=3},
        {fixtureId=7; playerId=36; eventStartMinute=6; eventEndMinute=6; teamId=2; eventType=3},
        {fixtureId=7; playerId=319; eventStartMinute=11; eventEndMinute=11; teamId=2; eventType=3},
        {fixtureId=7; playerId=329; eventStartMinute=11; eventEndMinute=11; teamId=2; eventType=3},
        {fixtureId=7; playerId=324; eventStartMinute=11; eventEndMinute=11; teamId=2; eventType=3},
        {fixtureId=7; playerId=323; eventStartMinute=11; eventEndMinute=11; teamId=2; eventType=3},
        {fixtureId=7; playerId=327; eventStartMinute=11; eventEndMinute=11; teamId=2; eventType=3}
      ]);
    };

    let fixture8Data: T.ConsensusData = { 
      fixtureId = 8;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=8; playerId=88; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=90; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=91; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=93; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=96; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=97; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=98; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=100; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=101; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=102; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=105; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=108; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=99; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=110; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=111; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=113; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=0},
        {fixtureId=8; playerId=383; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=385; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=390; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=392; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=394; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=397; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=398; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=400; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=402; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=404; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=406; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=407; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=539; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=558; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=0},
        {fixtureId=8; playerId=98; eventStartMinute=0; eventEndMinute=0; teamId=4; eventType=8},
        {fixtureId=8; playerId=383; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=8},
        {fixtureId=8; playerId=385; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=8},
        {fixtureId=8; playerId=394; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=8},
        {fixtureId=8; playerId=407; eventStartMinute=0; eventEndMinute=0; teamId=18; eventType=8},
        {fixtureId=8; playerId=110; eventStartMinute=27; eventEndMinute=27; teamId=4; eventType=1},
        {fixtureId=8; playerId=113; eventStartMinute=36; eventEndMinute=36; teamId=4; eventType=1},
        {fixtureId=8; playerId=392; eventStartMinute=45; eventEndMinute=45; teamId=18; eventType=1},
        {fixtureId=8; playerId=539; eventStartMinute=11; eventEndMinute=11; teamId=18; eventType=1},
        {fixtureId=8; playerId=407; eventStartMinute=11; eventEndMinute=11; teamId=18; eventType=2},
        {fixtureId=8; playerId=407; eventStartMinute=45; eventEndMinute=45; teamId=18; eventType=2},
        {fixtureId=8; playerId=97; eventStartMinute=36; eventEndMinute=36; teamId=4; eventType=2},
        {fixtureId=8; playerId=383; eventStartMinute=1; eventEndMinute=1; teamId=18; eventType=4},
        {fixtureId=8; playerId=383; eventStartMinute=2; eventEndMinute=2; teamId=18; eventType=4},
        {fixtureId=8; playerId=383; eventStartMinute=3; eventEndMinute=3; teamId=18; eventType=4},
        {fixtureId=8; playerId=383; eventStartMinute=4; eventEndMinute=4; teamId=18; eventType=4},
        {fixtureId=8; playerId=88; eventStartMinute=1; eventEndMinute=1; teamId=4; eventType=4},
        {fixtureId=8; playerId=88; eventStartMinute=2; eventEndMinute=2; teamId=4; eventType=4},
        {fixtureId=8; playerId=88; eventStartMinute=3; eventEndMinute=3; teamId=4; eventType=4},
        {fixtureId=8; playerId=88; eventStartMinute=4; eventEndMinute=4; teamId=4; eventType=4},
        {fixtureId=8; playerId=88; eventStartMinute=45; eventEndMinute=45; teamId=4; eventType=3},
        {fixtureId=8; playerId=88; eventStartMinute=11; eventEndMinute=11; teamId=4; eventType=3},
        {fixtureId=8; playerId=90; eventStartMinute=45; eventEndMinute=45; teamId=4; eventType=3},
        {fixtureId=8; playerId=90; eventStartMinute=11; eventEndMinute=11; teamId=4; eventType=3},
        {fixtureId=8; playerId=91; eventStartMinute=45; eventEndMinute=45; teamId=4; eventType=3},
        {fixtureId=8; playerId=91; eventStartMinute=11; eventEndMinute=11; teamId=4; eventType=3},
        {fixtureId=8; playerId=93; eventStartMinute=45; eventEndMinute=45; teamId=4; eventType=3},
        {fixtureId=8; playerId=93; eventStartMinute=11; eventEndMinute=11; teamId=4; eventType=3},
        {fixtureId=8; playerId=97; eventStartMinute=45; eventEndMinute=45; teamId=4; eventType=3},
        {fixtureId=8; playerId=97; eventStartMinute=11; eventEndMinute=11; teamId=4; eventType=3},
        {fixtureId=8; playerId=98; eventStartMinute=45; eventEndMinute=45; teamId=4; eventType=3},
        {fixtureId=8; playerId=98; eventStartMinute=11; eventEndMinute=11; teamId=4; eventType=3},
        {fixtureId=8; playerId=99; eventStartMinute=45; eventEndMinute=45; teamId=4; eventType=3},
        {fixtureId=8; playerId=99; eventStartMinute=11; eventEndMinute=11; teamId=4; eventType=3},
        {fixtureId=8; playerId=383; eventStartMinute=27; eventEndMinute=27; teamId=18; eventType=3},
        {fixtureId=8; playerId=383; eventStartMinute=36; eventEndMinute=36; teamId=18; eventType=3},
        {fixtureId=8; playerId=385; eventStartMinute=27; eventEndMinute=27; teamId=18; eventType=3},
        {fixtureId=8; playerId=385; eventStartMinute=36; eventEndMinute=36; teamId=18; eventType=3},
        {fixtureId=8; playerId=390; eventStartMinute=27; eventEndMinute=27; teamId=18; eventType=3},
        {fixtureId=8; playerId=390; eventStartMinute=36; eventEndMinute=36; teamId=18; eventType=3},
        {fixtureId=8; playerId=392; eventStartMinute=27; eventEndMinute=27; teamId=18; eventType=3},
        {fixtureId=8; playerId=392; eventStartMinute=36; eventEndMinute=36; teamId=18; eventType=3},
        {fixtureId=8; playerId=539; eventStartMinute=27; eventEndMinute=27; teamId=18; eventType=3},
        {fixtureId=8; playerId=539; eventStartMinute=36; eventEndMinute=36; teamId=18; eventType=3},
      ]);
    };

    let fixture9Data: T.ConsensusData = { 
      fixtureId = 9;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=9; playerId=150; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=151; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=152; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=156; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=157; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=158; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=159; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=160; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=161; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=162; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=170; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=540; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=115; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=0},
        {fixtureId=9; playerId=242; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=245; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=246; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=250; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=252; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=254; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=256; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=257; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=259; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=258; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=260; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=261; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=262; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=263; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=0},
        {fixtureId=9; playerId=257; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=1},
        {fixtureId=9; playerId=540; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=1},
        {fixtureId=9; playerId=260; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=2},
        {fixtureId=9; playerId=152; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=2},
        {fixtureId=9; playerId=150; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=3},
        {fixtureId=9; playerId=151; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=3},
        {fixtureId=9; playerId=152; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=3},
        {fixtureId=9; playerId=156; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=3},
        {fixtureId=9; playerId=157; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=3},
        {fixtureId=9; playerId=540; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=3},
        {fixtureId=9; playerId=242; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=3},
        {fixtureId=9; playerId=245; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=3},
        {fixtureId=9; playerId=246; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=3},
        {fixtureId=9; playerId=250; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=3},
        {fixtureId=9; playerId=252; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=3},
        {fixtureId=9; playerId=158; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=8},
        {fixtureId=9; playerId=160; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=8},
        {fixtureId=9; playerId=170; eventStartMinute=0; eventEndMinute=0; teamId=7; eventType=8},
        {fixtureId=9; playerId=252; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=8},
        {fixtureId=9; playerId=259; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=8},
        {fixtureId=9; playerId=262; eventStartMinute=0; eventEndMinute=0; teamId=11; eventType=8},
        {fixtureId=9; playerId=242; eventStartMinute=0; eventEndMinute=1; teamId=11; eventType=4},
        {fixtureId=9; playerId=242; eventStartMinute=0; eventEndMinute=2; teamId=11; eventType=4},
        {fixtureId=9; playerId=242; eventStartMinute=0; eventEndMinute=3; teamId=11; eventType=4},
        {fixtureId=9; playerId=242; eventStartMinute=0; eventEndMinute=4; teamId=11; eventType=4}
      ]);
    };

    let fixture10Data: T.ConsensusData = { 
      fixtureId = 10;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=10; playerId=291; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=292; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=293; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=295; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=298; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=303; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=304; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=305; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=306; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=310; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=311; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=312; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=313; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=314; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=315; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=317; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=0},
        {fixtureId=10; playerId=430; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=432; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=434; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=435; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=437; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=438; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=441; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=444; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=445; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=449; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=450; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=451; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=452; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=453; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=454; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=0},
        {fixtureId=10; playerId=291; eventStartMinute=1; eventEndMinute=1; teamId=14; eventType=4},
        {fixtureId=10; playerId=291; eventStartMinute=2; eventEndMinute=2; teamId=14; eventType=4},
        {fixtureId=10; playerId=291; eventStartMinute=3; eventEndMinute=3; teamId=14; eventType=4},
        {fixtureId=10; playerId=291; eventStartMinute=4; eventEndMinute=4; teamId=14; eventType=4},
        {fixtureId=10; playerId=291; eventStartMinute=5; eventEndMinute=5; teamId=14; eventType=4},
        {fixtureId=10; playerId=291; eventStartMinute=6; eventEndMinute=6; teamId=14; eventType=4},
        {fixtureId=10; playerId=430; eventStartMinute=1; eventEndMinute=1; teamId=20; eventType=4},
        {fixtureId=10; playerId=430; eventStartMinute=2; eventEndMinute=2; teamId=20; eventType=4},
        {fixtureId=10; playerId=292; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=8},
        {fixtureId=10; playerId=298; eventStartMinute=0; eventEndMinute=0; teamId=14; eventType=8},
        {fixtureId=10; playerId=435; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=8},
        {fixtureId=10; playerId=441; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=8},
        {fixtureId=10; playerId=449; eventStartMinute=0; eventEndMinute=0; teamId=20; eventType=8},
        {fixtureId=10; playerId=293; eventStartMinute=76; eventEndMinute=76; teamId=14; eventType=1},
        {fixtureId=10; playerId=303; eventStartMinute=76; eventEndMinute=76; teamId=14; eventType=2},
        {fixtureId=10; playerId=291; eventStartMinute=90; eventEndMinute=90; teamId=14; eventType=5},
        {fixtureId=10; playerId=292; eventStartMinute=90; eventEndMinute=90; teamId=14; eventType=5},
        {fixtureId=10; playerId=293; eventStartMinute=90; eventEndMinute=90; teamId=14; eventType=5},
        {fixtureId=10; playerId=295; eventStartMinute=90; eventEndMinute=90; teamId=14; eventType=5},
        {fixtureId=10; playerId=298; eventStartMinute=90; eventEndMinute=90; teamId=14; eventType=5},
        {fixtureId=10; playerId=303; eventStartMinute=90; eventEndMinute=90; teamId=14; eventType=5},
        {fixtureId=10; playerId=430; eventStartMinute=76; eventEndMinute=76; teamId=20; eventType=3},
        {fixtureId=10; playerId=432; eventStartMinute=76; eventEndMinute=76; teamId=20; eventType=3},
        {fixtureId=10; playerId=434; eventStartMinute=76; eventEndMinute=76; teamId=20; eventType=3},
        {fixtureId=10; playerId=435; eventStartMinute=76; eventEndMinute=76; teamId=20; eventType=3},
        {fixtureId=10; playerId=437; eventStartMinute=76; eventEndMinute=76; teamId=20; eventType=3},
        {fixtureId=10; playerId=438; eventStartMinute=76; eventEndMinute=76; teamId=20; eventType=3}
      ]);
    };

    let fixture17Data: T.ConsensusData = { 
      fixtureId = 17;
      totalVotes = {amount_e8s = 1_000_000};
      events = List.fromArray<T.PlayerEventData>([
        {fixtureId=17; playerId=2; eventStartMinute=0; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=351; eventStartMinute=90; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=352; eventStartMinute=0; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=353; eventStartMinute=0; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=354; eventStartMinute=0; eventEndMinute=69; teamId=16; eventType=0},
        {fixtureId=17; playerId=358; eventStartMinute=0; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=359; eventStartMinute=0; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=364; eventStartMinute=0; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=365; eventStartMinute=90; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=366; eventStartMinute=0; eventEndMinute=69; teamId=16; eventType=0},
        {fixtureId=17; playerId=368; eventStartMinute=69; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=371; eventStartMinute=0; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=372; eventStartMinute=0; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=373; eventStartMinute=69; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=376; eventStartMinute=0; eventEndMinute=84; teamId=16; eventType=0},
        {fixtureId=17; playerId=378; eventStartMinute=84; eventEndMinute=90; teamId=16; eventType=0},
        {fixtureId=17; playerId=517; eventStartMinute=0; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=520; eventStartMinute=58; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=521; eventStartMinute=0; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=522; eventStartMinute=0; eventEndMinute=45; teamId=17; eventType=0},
        {fixtureId=17; playerId=523; eventStartMinute=0; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=524; eventStartMinute=0; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=527; eventStartMinute=45; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=532; eventStartMinute=0; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=536; eventStartMinute=0; eventEndMinute=74; teamId=17; eventType=0},
        {fixtureId=17; playerId=538; eventStartMinute=0; eventEndMinute=82; teamId=17; eventType=0},
        {fixtureId=17; playerId=553; eventStartMinute=0; eventEndMinute=58; teamId=17; eventType=0},
        {fixtureId=17; playerId=554; eventStartMinute=74; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=555; eventStartMinute=82; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=530; eventStartMinute=0; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=556; eventStartMinute=0; eventEndMinute=90; teamId=17; eventType=0},
        {fixtureId=17; playerId=376; eventStartMinute=3; eventEndMinute=3; teamId=16; eventType=1},
        {fixtureId=17; playerId=378; eventStartMinute=89; eventEndMinute=89; teamId=16; eventType=1},
        {fixtureId=17; playerId=556; eventStartMinute=48; eventEndMinute=48; teamId=17; eventType=1},
        {fixtureId=17; playerId=359; eventStartMinute=3; eventEndMinute=3; teamId=16; eventType=2},
        {fixtureId=17; playerId=359; eventStartMinute=89; eventEndMinute=89; teamId=16; eventType=2},
        {fixtureId=17; playerId=2; eventStartMinute=1; eventEndMinute=1; teamId=16; eventType=4},
        {fixtureId=17; playerId=2; eventStartMinute=2; eventEndMinute=2; teamId=16; eventType=4},
        {fixtureId=17; playerId=517; eventStartMinute=1; eventEndMinute=1; teamId=17; eventType=4},
        {fixtureId=17; playerId=517; eventStartMinute=2; eventEndMinute=2; teamId=17; eventType=4},
        {fixtureId=17; playerId=354; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=8},
        {fixtureId=17; playerId=359; eventStartMinute=0; eventEndMinute=0; teamId=16; eventType=8},
        {fixtureId=17; playerId=530; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=8},
        {fixtureId=17; playerId=532; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=8},
        {fixtureId=17; playerId=556; eventStartMinute=0; eventEndMinute=0; teamId=17; eventType=8},
        {fixtureId=17; playerId=517; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=3},
        {fixtureId=17; playerId=517; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=3},
        {fixtureId=17; playerId=517; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=3},
        {fixtureId=17; playerId=520; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=3},
        {fixtureId=17; playerId=521; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=3},
        {fixtureId=17; playerId=522; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=3},
        {fixtureId=17; playerId=523; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=3},
        {fixtureId=17; playerId=524; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=3},
        {fixtureId=17; playerId=527; eventStartMinute=3; eventEndMinute=3; teamId=17; eventType=3},
        {fixtureId=17; playerId=517; eventStartMinute=89; eventEndMinute=89; teamId=17; eventType=3},
        {fixtureId=17; playerId=517; eventStartMinute=89; eventEndMinute=89; teamId=17; eventType=3},
        {fixtureId=17; playerId=517; eventStartMinute=89; eventEndMinute=89; teamId=17; eventType=3},
        {fixtureId=17; playerId=520; eventStartMinute=89; eventEndMinute=89; teamId=17; eventType=3},
        {fixtureId=17; playerId=521; eventStartMinute=89; eventEndMinute=89; teamId=17; eventType=3},
        {fixtureId=17; playerId=522; eventStartMinute=89; eventEndMinute=89; teamId=17; eventType=3},
        {fixtureId=17; playerId=523; eventStartMinute=89; eventEndMinute=89; teamId=17; eventType=3},
        {fixtureId=17; playerId=524; eventStartMinute=89; eventEndMinute=89; teamId=17; eventType=3},
        {fixtureId=17; playerId=527; eventStartMinute=89; eventEndMinute=89; teamId=17; eventType=3},
        {fixtureId=17; playerId=2; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=2; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=2; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=351; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=352; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=353; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=354; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=354; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=358; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=359; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=359; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=359; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3},
        {fixtureId=17; playerId=359; eventStartMinute=48; eventEndMinute=48; teamId=16; eventType=3}
      ]);
    };
    
    newConsensusFixtureData.put(1, fixture1Data);
    newConsensusFixtureData.put(2, fixture2Data);
    newConsensusFixtureData.put(3, fixture3Data);
    newConsensusFixtureData.put(4, fixture4Data);
    newConsensusFixtureData.put(5, fixture5Data);
    newConsensusFixtureData.put(6, fixture6Data);
    newConsensusFixtureData.put(7, fixture7Data);
    newConsensusFixtureData.put(8, fixture8Data);
    newConsensusFixtureData.put(9, fixture9Data);
    newConsensusFixtureData.put(10, fixture10Data);
    newConsensusFixtureData.put(17, fixture17Data);

    governanceInstance.resetConsensusData(Iter.toArray(newConsensusFixtureData.entries()));

    let updatedFixture1 = await seasonManager.savePlayerEventData(1, 1, 1, fixture1Data.events);
    let updatedFixture2 = await seasonManager.savePlayerEventData(1, 1, 2, fixture2Data.events);
    let updatedFixture3 = await seasonManager.savePlayerEventData(1, 1, 3, fixture3Data.events);
    let updatedFixture4 = await seasonManager.savePlayerEventData(1, 1, 4, fixture4Data.events);
    let updatedFixture5 = await seasonManager.savePlayerEventData(1, 1, 5, fixture5Data.events);
    let updatedFixture6 = await seasonManager.savePlayerEventData(1, 1, 6, fixture6Data.events);
    let updatedFixture7 = await seasonManager.savePlayerEventData(1, 1, 7, fixture7Data.events);
    let updatedFixture8 = await seasonManager.savePlayerEventData(1, 1, 8, fixture8Data.events);
    let updatedFixture9 = await seasonManager.savePlayerEventData(1, 1, 9, fixture9Data.events);
    let updatedFixture10 = await seasonManager.savePlayerEventData(1, 1, 10, fixture10Data.events);
    let updatedFixture11 = await seasonManager.savePlayerEventData(1, 2, 17, fixture17Data.events);


    let fixtureWithHighestPlayerId1 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture1);
    let fixtureWithHighestPlayerId2 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture2);
    let fixtureWithHighestPlayerId3 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture3);
    let fixtureWithHighestPlayerId4 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture4);
    let fixtureWithHighestPlayerId5 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture5);
    let fixtureWithHighestPlayerId6 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture6);
    let fixtureWithHighestPlayerId7 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture7);
    let fixtureWithHighestPlayerId8 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture8);
    let fixtureWithHighestPlayerId9 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture9);
    let fixtureWithHighestPlayerId10 = await seasonManager.recalculatePlayerScores(1, 1, updatedFixture10);
    let fixtureWithHighestPlayerId11 = await seasonManager.recalculatePlayerScores(1, 2, updatedFixture11);

    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId1);
    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId2);
    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId3);
    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId4);
    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId5);
    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId6);
    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId7);
    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId8);
    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId9);
    await seasonManager.updateHighestPlayerId(1, 1, fixtureWithHighestPlayerId10);

    await seasonManager.updateHighestPlayerId(1, 2, fixtureWithHighestPlayerId11);

    await seasonManager.recalculateFantasyTeamScores(1, 1);
    await seasonManager.recalculateFantasyTeamScores(1, 2);

    
  };

  public func removeIncorrectPlayerEventData() : async (){
    await seasonManager.removeIncorrectPlayerEventData();
  };
  
/*
  
  public func initGenesisSeason(): async (){
    let firstFixture: T.Fixture = { id = 1; seasonId = 1; gameweek = 1; kickOff = 1692435000000000000; homeTeamId = 6; awayTeamId = 13; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; };
    await seasonManager.init_genesis_season(firstFixture);
  };
  
  public func fixBankBalances() : async () {
    await fantasyTeamsInstance.fixBankBalances();
  };

  public func getFantasyTeams() : async [(Text, T.UserFantasyTeam)] {
    return fantasyTeamsInstance.getFantasyTeams();
  };

  //
  
  
  
  */
};
