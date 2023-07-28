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

actor Self {

  let profilesInstance = Profiles.Profiles();
  let bookInstance = Book.Book();
  let teamsInstance = Teams.Teams();
  let governanceInstance = Governance.Governance();
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
    revaluePlayers: ([T.Player]) -> async ();
    getPlayer: (playerId: Nat16) -> async T.Player;
    calculatePlayerPoints: (gameweek: Nat8, gameweekFixtures: [T.Fixture]) -> async [T.Fixture];
  };

  private func getAllPlayersMap(seasonId: Nat16, gameweek: Nat8): async [(Nat16, DTOs.PlayerScoreDTO)] {
    return await playerCanister.getAllPlayersMap(seasonId, gameweek);
  }; 

  let fantasyTeamsInstance = FantasyTeams.FantasyTeams(getAllPlayersMap);

  public shared ({caller}) func getCurrentGameweek() : async Nat8 {
    return seasonManager.getActiveGameweek();
  };
  
  public query func getTeams() : async [T.Team] {
    return teamsInstance.getTeams();
  };

  public query ({caller}) func getFixtures() : async [T.Fixture]{
    return seasonManager.getFixtures();
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

  //Get homepage DTO

  //League functions
  public shared query ({caller}) func getSeasonTop10() : async T.Leaderboard {
      return fantasyTeamsInstance.getSeasonTop10();
  };

  public shared query ({caller}) func getWeeklyTop10() : async T.Leaderboard {
      return fantasyTeamsInstance.getWeeklyTop10();
  };

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
          
          return fantasyTeamsInstance.updateFantasyTeam(principalId, newPlayers, captainId, bonusId, bonusPlayerId, bonusTeamId, seasonManager.getActiveGameweek(), existingPlayers); 
        };
    };
  };

  private func resetTransfers(): async () {
    await fantasyTeamsInstance.resetTransfers();
  };

  private func calculatePlayerPoints(activeGameweek: Nat8, gameweekFixtures: [T.Fixture]): async [T.Fixture] {
    return await playerCanister.calculatePlayerPoints(activeGameweek, gameweekFixtures);
  };  

  private func getConsensusPlayerEventData(gameweekId: Nat8, fixtureId: Nat32) : async List.List<T.PlayerEventData>{
    return await governanceInstance.getGameweekPlayerEventData(gameweekId, fixtureId);
  };

  private func distributeRewards(): async () {
    await rewardsInstance.distributeRewards();
  };

  private func settleUserBets(): async (){
    await privateLeaguesInstance.settleUserBets();
  };

  private func revaluePlayers(): async (){
    let revaluedPlayers = await governanceInstance.getRevaluedPlayers();
    await playerCanister.revaluePlayers(revaluedPlayers);
  };

  private func snapshotGameweek(seaasonId: Nat16): async (){
    await fantasyTeamsInstance.snapshotGameweek(seaasonId);
  };

  private func getPlayer(playerId: Nat16): async T.Player {
    return await playerCanister.getPlayer(playerId);
  }; 

  private func calculateFantasyTeamScores(seasonId: Nat16, gameweek: Nat8, fixtures: [T.Fixture]) : async (){
    return await fantasyTeamsInstance.calculateFantasyTeamScores(seasonId, gameweek, fixtures);
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
  
  //intialise season manager
  let seasonManager = SeasonManager.SeasonManager(
    resetTransfers, 
    calculatePlayerPoints, 
    distributeRewards, 
    settleUserBets, 
    revaluePlayers, 
    snapshotGameweek, 
    mintWeeklyRewardsPool, 
    mintAnnualRewardsPool, 
    calculateFantasyTeamScores, 
    getConsensusPlayerEventData,
    getAllPlayersMap,
    resetFantasyTeams);
  //seasonManager.init_genesis_season();  ONLY UNCOMMENT WHEN READY TO LAUNCH
  
  //stable variable backup
  private stable var stable_profiles: [(Text, T.Profile)] = [];
  private stable var stable_fantasy_teams: [(Text, T.UserFantasyTeam)] = [];
  private stable var stable_active_season_id : Nat16 = 0;
  private stable var stable_active_gameweek : Nat8 = 0;
  private stable var stable_fixture_data_submissions: [(Nat16, List.List<T.PlayerEventData>)] = [];
  private stable var stable_active_timers : [Int] = [];
  private stable var stable_transfers_allowed : Bool = true;
  private stable var stable_gameweek_begin_timer_id : Int = 0;
  private stable var stable_kick_off_timer_ids : [Int] = [];
  private stable var stable_game_completed_timer_ids : [Int] = [];
  private stable var stable_voting_period_timer_ids : [Int] = [];
  private stable var stable_active_fixtures : [T.Fixture] = [];
  private stable var stable_next_fixture_id : Nat32 = 0;
  private stable var stable_next_season_id : Nat16 = 0;
  private stable var stable_teams : [T.Team] = [];
  private stable var stable_next_team_id : Nat16 = 0;
  
  system func preupgrade() {
    stable_profiles := profilesInstance.getProfiles();
    stable_fantasy_teams := fantasyTeamsInstance.getFantasyTeams();
    stable_active_season_id := seasonManager.getActiveSeasonId();
    stable_active_gameweek := seasonManager.getActiveGameweek();
    stable_fixture_data_submissions := governanceInstance.getFixtureDataSubmissions();
    stable_active_timers := seasonManager.getActiveTimerIds();
    stable_transfers_allowed := seasonManager.getTransfersAllowed();
    stable_gameweek_begin_timer_id := seasonManager.getGameweekBeginTimerId();
    stable_kick_off_timer_ids := seasonManager.getKickOffTimerIds();
    stable_game_completed_timer_ids := seasonManager.getGameCompletedTimerIds();
    stable_voting_period_timer_ids := seasonManager.getVotingPeriodTimerIds();
    stable_active_fixtures := seasonManager.getActiveFixtures();
    stable_next_fixture_id := seasonManager.getNextFixtureId();
    stable_next_season_id := seasonManager.getNextSeasonId();
    stable_teams := teamsInstance.getTeams();
    stable_next_team_id := teamsInstance.getNextTeamId();
  };

  system func postupgrade() {
    profilesInstance.setData(stable_profiles);
    fantasyTeamsInstance.setData(stable_fantasy_teams);
    seasonManager.setData(stable_active_season_id, stable_active_gameweek, stable_active_timers, stable_transfers_allowed, stable_gameweek_begin_timer_id, 
    stable_kick_off_timer_ids, stable_game_completed_timer_ids, stable_voting_period_timer_ids, stable_active_fixtures, stable_next_fixture_id, stable_next_season_id);
    stable_fixture_data_submissions := governanceInstance.getFixtureDataSubmissions();
    stable_teams := teamsInstance.getTeams();
    stable_next_team_id := teamsInstance.getNextTeamId();
  };

};
