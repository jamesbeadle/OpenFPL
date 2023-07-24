import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import DTOs "DTOs";
import Profiles "profiles";
import Account "Account";
import Book "book";
import Teams "teams";
import FantasyTeams "fantasy-teams";
import Fixtures "fixtures";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Debug "mo:base/Debug";
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
  let fantasyTeamsInstance = FantasyTeams.FantasyTeams();
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
    revaluePlayers: ([T.Player]) -> async ();
    getPlayer: (playerId: Nat16) -> async T.Player;
    calculatePlayerPoints: (gameweek: Nat8, gameweekFixtures: [T.Fixture]) -> async [T.Fixture];
  };

  public shared ({caller}) func getCurrentGameweek() : async Nat8 {
    return seasonManager.getActiveGameweek();
  };
  
  public query func getTeams() : async [T.Team] {
    return teamsInstance.getTeams();
  };

  public query ({caller}) func getFixtures() : async [T.Fixture]{
    return seasonManager.getFixtures();
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

  public shared query ({caller}) func getFantasyTeam() : async ?T.FantasyTeam {

    if(Principal.isAnonymous(caller)){
      return null;
    };

    return fantasyTeamsInstance.getFantasyTeam(Principal.toText(caller));
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
              let isPlayerIdInExistingTeam = Array.find(team.playerIds, func (id: Nat16): Bool {
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

  private func calculateFantasyTeamScores(activeGameweek: Nat8, gameweekFixtures: [T.Fixture]) : async () {
    
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

  private func snapshotGameweek(): async (){
    await fantasyTeamsInstance.snapshotGameweek();
  };

  private func getPlayer(playerId: Nat16): async T.Player {
    return await playerCanister.getPlayer(playerId);
  }; 

  private func calculatePredictionScores(gameweekId: Nat8, fixtures: [T.Fixture]) : async (){
    return await fantasyTeamsInstance.calculatePredictionScores(gameweekId, fixtures);
  };

  private func mintWeeklyRewardsPool(): async () {
    //implement last
  };

  private func mintAnnualRewardsPool(): async () {
    //implement last
  };
  
  //intialise season manager
  let seasonManager = SeasonManager.SeasonManager(
    resetTransfers, 
    calculatePlayerPoints, 
    distributeRewards, 
    settleUserBets, 
    revaluePlayers, 
    snapshotGameweek, 
    getPlayer, 
    mintWeeklyRewardsPool, 
    mintAnnualRewardsPool, 
    calculateFantasyTeamScores, 
    getConsensusPlayerEventData);
  //seasonManager.init_genesis_season();  ONLY UNCOMMENT WHEN READY TO LAUNCH
  
  //stable variable backup
  private stable var stable_profiles: [T.Profile] = [];
  private stable var stable_fantasy_teams: [T.FantasyTeam] = [];
  private stable var stable_proposals: [T.Proposal] = [];
  private stable var stable_next_proposal_id : Nat = 0;
  private stable var stable_active_season_id : Nat16 = 0;
  private stable var stable_active_gameweek : Nat8 = 0;
  
  system func preupgrade() {
    stable_profiles := profilesInstance.getProfiles();
    stable_fantasy_teams := fantasyTeamsInstance.getFantasyTeams();
    stable_active_season_id := seasonManager.getActiveSeasonId();
    stable_active_gameweek := seasonManager.getActiveGameweek();
  };

  system func postupgrade() {
    profilesInstance.setData(stable_profiles);
    fantasyTeamsInstance.setData(stable_fantasy_teams);
  };

};
