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
import Text "mo:base/Text";
import Int16 "mo:base/Int16";
import Int64 "mo:base/Int64";
import SHA224 "./SHA224";

actor Self {

  let profilesInstance = Profiles.Profiles();
  let bookInstance = Book.Book();
  let teamsInstance = Teams.Teams();
  let rewardsInstance = Rewards.Rewards();
  let privateLeaguesInstance = PrivateLeagues.PrivateLeagues();

  private var dataCacheHashes : List.List<T.DataCache> = List.fromArray([
    { category = "teams"; hash = "DEFAULT_VALUE" },
    { category = "fixtures"; hash = "DEFAULT_VALUE" },
    { category = "seasons"; hash = "DEFAULT_VALUE" },
    { category = "system_state"; hash = "DEFAULT_VALUE" },
    { category = "weekly_leaderboard"; hash = "DEFAULT_VALUE" },
    { category = "monthly_leaderboards"; hash = "DEFAULT_VALUE" },
    { category = "season_leaderboard"; hash = "DEFAULT_VALUE" },
  ]);

  private let oneHour = 1_000_000_000 * 60 * 60;

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
    governance_canister = "rrkah-fqaaa-aaaaa-aaaaq-cai";
  };

  let tokenCanister = actor (CANISTER_IDS.token_canister) : actor {
    icrc1_name : () -> async Text;
    icrc1_total_supply : () -> async Nat;
    icrc1_balance_of : (T.Account) -> async Nat;
  };

  //Player Canister

  let playerCanister = actor (CANISTER_IDS.player_canister) : actor {
    getAllPlayers : () -> async [DTOs.PlayerDTO];
    getAllPlayersMap : (seasonId : Nat16, gameweek : Nat8) -> async [(Nat16, DTOs.PlayerScoreDTO)];
    revaluePlayerUp : (playerId : T.PlayerId, activeSeasonId : T.SeasonId, activeGameweek : T.GameweekNumber) -> async ();
    revaluePlayerDown : (playerId : T.PlayerId, activeSeasonId : T.SeasonId, activeGameweek : T.GameweekNumber) -> async ();
    getPlayer : (playerId : Nat16) -> async T.Player;
    calculatePlayerScores(seasonId : Nat16, gameweek : Nat8, fixture : T.Fixture) : async T.Fixture;
    transferPlayer : (playerId : T.PlayerId, newTeamId : T.TeamId, currentSeasonId : T.SeasonId, currentGameweek : T.GameweekNumber) -> async ();
    loanPlayer : (playerId : T.PlayerId, loanTeamId : T.TeamId, loanEndDate : Int, currentSeasonId : T.SeasonId, currentGameweek : T.GameweekNumber) -> async ();
    recallPlayer : (playerId : T.PlayerId) -> async ();
    createPlayer : (teamId : T.TeamId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, value : Nat, dateOfBirth : Int, nationality : Text) -> async ();
    updatePlayer : (playerId : T.PlayerId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, dateOfBirth : Int, nationality : Text) -> async ();
    setPlayerInjury : (playerId : T.PlayerId, description : Text, expectedEndDate : Int) -> async ();
    retirePlayer : (playerId : T.PlayerId, retirementDate : Int) -> async ();
    unretirePlayer : (playerId : T.PlayerId) -> async ();
    recalculatePlayerScores : (fixture : T.Fixture, seasonId : Nat16, gameweek : Nat8) -> async ();
    updatePlayerEventDataCache : () -> async ();
  };

  private func getAllPlayersMap(seasonId : Nat16, gameweek : Nat8) : async [(Nat16, DTOs.PlayerScoreDTO)] {
    return await playerCanister.getAllPlayersMap(seasonId, gameweek);
  };

  private func getAllPlayers() : async [DTOs.PlayerDTO] {
    return await playerCanister.getAllPlayers();
  };

  private func getPlayer(playerId : Nat16) : async T.Player {
    return await playerCanister.getPlayer(playerId);
  };

  //Profile Canister

  //Whatever Canister - This is where I'll put all the entry points when the multicanister architecture is implemented

  private func getProfiles() : [(Text, T.Profile)] {
    return profilesInstance.getProfiles();
  };

  let fantasyTeamsInstance = FantasyTeams.FantasyTeams(getAllPlayersMap, getPlayer, getProfiles, getAllPlayers);

  public query func getActiveFixtures() : async [T.Fixture] {
    let fixtures = seasonManager.getActiveGameweekFixtures();
  };

  public query func getSystemState() : async T.SystemState {
    let fixtures = seasonManager.getActiveGameweekFixtures();

    var earliestFixtureTime = fixtures[0].kickOff;
    var latestFixtureTime = fixtures[0].kickOff;

    for (fixture in Iter.fromArray<T.Fixture>(fixtures)) {
      if (fixture.kickOff > latestFixtureTime) {
        latestFixtureTime := fixture.kickOff;
      };
      if (fixture.kickOff < earliestFixtureTime) {
        earliestFixtureTime := fixture.kickOff;
      };
    };
    var activeGameweek = seasonManager.getActiveGameweek();
    var focusGameweek = seasonManager.getInterestingGameweek();

    return {
      activeSeason = seasonManager.getActiveSeason();
      activeGameweek = activeGameweek;
      activeMonth = Utilities.unixTimeToMonth(latestFixtureTime);
      focusGameweek = focusGameweek;
    };
  };

  public query func getTeams() : async [T.Team] {
    return teamsInstance.getTeams();
  };

  public query ({ caller }) func getFixtures() : async [T.Fixture] {
    return seasonManager.getFixtures();
  };

  public query ({ caller }) func getFixtureDTOs() : async [DTOs.FixtureDTO] {
    return Array.map<T.Fixture, DTOs.FixtureDTO>(
      seasonManager.getFixtures(),
      func(fixture : T.Fixture) : DTOs.FixtureDTO {
        return {
          id = fixture.id;
          seasonId = fixture.seasonId;
          gameweek = fixture.gameweek;
          kickOff = fixture.kickOff;
          homeTeamId = fixture.homeTeamId;
          awayTeamId = fixture.awayTeamId;
          homeGoals = fixture.homeGoals;
          awayGoals = fixture.awayGoals;
          status = fixture.status;
          highestScoringPlayerId = fixture.highestScoringPlayerId;
          events = [];
        };
      },
    );
  };

  public query ({ caller }) func getFixturesForSeason(seasonId : T.SeasonId) : async [T.Fixture] {
    return seasonManager.getFixturesForSeason(seasonId);
  };

  public shared ({ caller }) func getFixture(seasonId : T.SeasonId, gameweekNumber : T.GameweekNumber, fixtureId : T.FixtureId) : async T.Fixture {
    return await seasonManager.getFixture(seasonId, gameweekNumber, fixtureId);
  };

  public shared ({ caller }) func getProfileDTO() : async DTOs.ProfileDTO {
    assert not Principal.isAnonymous(caller);
    let principalName = Principal.toText(caller);
    var icpDepositAddress = Blob.fromArray([]);
    var fplDepositAddress = Blob.fromArray([]);
    var displayName = "";
    var membershipType = Nat8.fromNat(0);
    var profilePicture = Blob.fromArray([]);
    var favouriteTeamId = Nat16.fromNat(0);
    var createDate : Int = 0;
    var reputation = Nat32.fromNat(0);
    var canUpdateFavouriteTeam = true;

    var profile = profilesInstance.getProfile(Principal.toText(caller));

    if (profile == null) {
      profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller), getICPDepositAccount(caller), getFPLDepositAccount(caller));
      profile := profilesInstance.getProfile(Principal.toText(caller));
    };

    switch (profile) {
      case (null) {};
      case (?p) {
        icpDepositAddress := p.icpDepositAddress;
        fplDepositAddress := p.fplDepositAddress;
        displayName := p.displayName;
        membershipType := p.membershipType;
        profilePicture := p.profilePicture;
        favouriteTeamId := p.favouriteTeamId;
        createDate := p.createDate;
        reputation := p.reputation;
        canUpdateFavouriteTeam := p.favouriteTeamId == 0 or not seasonManager.seasonActive();
      };
    };

    let profileDTO : DTOs.ProfileDTO = {
      principalName = principalName;
      icpDepositAddress = icpDepositAddress;
      fplDepositAddress = fplDepositAddress;
      displayName = displayName;
      membershipType = membershipType;
      profilePicture = profilePicture;
      favouriteTeamId = favouriteTeamId;
      createDate = createDate;
      reputation = reputation;
      canUpdateFavouriteTeam = canUpdateFavouriteTeam;
    };

    return profileDTO;
  };

  public shared query ({ caller }) func getPublicProfileDTO(principalId : Text) : async DTOs.ProfileDTO {
    var icpDepositAddress = Blob.fromArray([]);
    var fplDepositAddress = Blob.fromArray([]);
    var displayName = "";
    var membershipType = Nat8.fromNat(0);
    var profilePicture = Blob.fromArray([]);
    var favouriteTeamId = Nat16.fromNat(0);
    var createDate : Int = 0;
    var reputation = Nat32.fromNat(0);

    var profile = profilesInstance.getProfile(principalId);

    switch (profile) {
      case (null) {};
      case (?p) {
        displayName := p.displayName;
        membershipType := p.membershipType;
        profilePicture := p.profilePicture;
        favouriteTeamId := p.favouriteTeamId;
        reputation := p.reputation;
      };
    };

    let profileDTO : DTOs.ProfileDTO = {
      principalName = principalId;
      icpDepositAddress = icpDepositAddress;
      fplDepositAddress = fplDepositAddress;
      displayName = displayName;
      membershipType = membershipType;
      profilePicture = profilePicture;
      favouriteTeamId = favouriteTeamId;
      createDate = createDate;
      reputation = reputation;
      canUpdateFavouriteTeam = false;
    };

    return profileDTO;
  };

  public shared query ({ caller }) func isDisplayNameValid(displayName : Text) : async Bool {
    assert not Principal.isAnonymous(caller);
    return profilesInstance.isDisplayNameValid(displayName);
  };

  public shared ({ caller }) func updateDisplayName(displayName : Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let invalidName = not profilesInstance.isDisplayNameValid(displayName);
    assert not invalidName;

    var profile = profilesInstance.getProfile(Principal.toText(caller));
    switch (profile) {
      case (null) {
        profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller), getICPDepositAccount(caller), getFPLDepositAccount(caller));
        profile := profilesInstance.getProfile(Principal.toText(caller));
      };
      case (?foundProfile) {};
    };

    fantasyTeamsInstance.updateDisplayName(Principal.toText(caller), displayName);
    return profilesInstance.updateDisplayName(Principal.toText(caller), displayName);
  };

  public shared ({ caller }) func updateFavouriteTeam(favouriteTeamId : Nat16) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);

    var profile = profilesInstance.getProfile(Principal.toText(caller));
    switch (profile) {
      case (null) {
        profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller), getICPDepositAccount(caller), getFPLDepositAccount(caller));
        profile := profilesInstance.getProfile(Principal.toText(caller));
      };
      case (?foundProfile) {
        if (foundProfile.favouriteTeamId > 0) {
          assert not seasonManager.seasonActive();
        };
      };
    };

    fantasyTeamsInstance.updateFavouriteTeam(Principal.toText(caller), favouriteTeamId);
    return profilesInstance.updateFavouriteTeam(Principal.toText(caller), favouriteTeamId);
  };

  public shared ({ caller }) func updateProfilePicture(profilePicture : Blob) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);

    let sizeInKB = Array.size(Blob.toArray(profilePicture)) / 1024;
    if (sizeInKB > 4000) {
      return #err(#NotAllowed);
    };

    return profilesInstance.updateProfilePicture(Principal.toText(caller), profilePicture);
  };

  public shared ({ caller }) func getAccountBalanceDTO() : async DTOs.AccountBalanceDTO {

    assert not Principal.isAnonymous(caller);
    let principalName = Principal.toText(caller);
    var icpBalance = Nat64.fromNat(0);
    var fplBalance = Nat64.fromNat(0);

    icpBalance := await bookInstance.getUserAccountBalance(Principal.fromActor(Self), caller);

    let tokenCanisterUser : T.Account = {
      owner = Principal.fromActor(tokenCanister);
      subaccount = Account.principalToSubaccount(caller);
    };

    fplBalance := Nat64.fromNat(await tokenCanister.icrc1_balance_of(tokenCanisterUser));

    let accountBalanceDTO : DTOs.AccountBalanceDTO = {
      icpBalance = icpBalance;
      fplBalance = fplBalance;
    };

    return accountBalanceDTO;
  };

  private func getICPDepositAccount(caller : Principal) : Account.AccountIdentifier {
    Account.accountIdentifier(Principal.fromActor(Self), Account.principalToSubaccount(caller));
  };

  private func getFPLDepositAccount(caller : Principal) : Account.AccountIdentifier {
    Account.accountIdentifier(Principal.fromActor(tokenCanister), Account.principalToSubaccount(caller));
  };

  public shared ({ caller }) func withdrawICP(amount : Float, withdrawalAddress : Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);

    let userProfile = profilesInstance.getProfile(Principal.toText(caller));

    switch userProfile {
      case (null) {
        return #err(#NotFound);
      };
      case (?profile) {
        if (not profilesInstance.isWalletValid(withdrawalAddress)) {
          return #err(#NotAllowed);
        };
        return await bookInstance.withdrawICP(Principal.fromActor(Self), caller, amount, withdrawalAddress);
      };
    };
  };

  //Season Functions
  public shared query ({ caller }) func getSeasons() : async [DTOs.SeasonDTO] {
    let seasons = seasonManager.getSeasons();
    return Array.map<T.Season, DTOs.SeasonDTO>(
      seasons,
      func(season : T.Season) : DTOs.SeasonDTO {
        return {
          id = season.id;
          name = season.name;
          year = season.year;
        };
      },
    );
  };

  public shared query ({ caller }) func getWeeklyLeaderboard(seasonId : Nat16, gameweek : Nat8, limit : Nat, offset : Nat) : async DTOs.PaginatedLeaderboard {
    return fantasyTeamsInstance.getWeeklyLeaderboard(seasonId, gameweek, limit, offset);
  };

  public shared query ({ caller }) func getSeasonLeaderboard(seasonId : Nat16, limit : Nat, offset : Nat) : async DTOs.PaginatedLeaderboard {
    return fantasyTeamsInstance.getSeasonLeaderboard(seasonId, limit, offset);
  };

  public shared query ({ caller }) func getClubLeaderboard(seasonId : Nat16, month : Nat8, clubId : T.TeamId, limit : Nat, offset : Nat) : async DTOs.PaginatedClubLeaderboard {
    return fantasyTeamsInstance.getClubLeaderboard(seasonId, month, clubId, limit, offset);
  };

  public shared query ({ caller }) func getWeeklyLeaderboardCache(seasonId : Nat16, gameweek : Nat8) : async DTOs.PaginatedLeaderboard {
    return fantasyTeamsInstance.getWeeklyLeaderboard(seasonId, gameweek, 100, 0);
  };

  public shared query ({ caller }) func getSeasonLeaderboardCache(seasonId : Nat16) : async DTOs.PaginatedLeaderboard {
    return fantasyTeamsInstance.getSeasonLeaderboard(seasonId, 100, 0);
  };

  public shared query ({ caller }) func getClubLeaderboardsCache(seasonId : Nat16, month : Nat8) : async [DTOs.PaginatedClubLeaderboard] {
    return fantasyTeamsInstance.getClubLeaderboards(seasonId, month, 100, 0);
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

  private func removeExpiredTimers() : () {
    let currentTime = Time.now();
    stable_timers := Array.filter<T.TimerInfo>(
      stable_timers,
      func(timer : T.TimerInfo) : Bool {
        return timer.triggerTime > currentTime;
      },
    );
  };

  private func defaultCallback() : async () {};

  private func setAndBackupTimer(duration : Timer.Duration, callbackName : Text, fixtureId : T.FixtureId) : async () {
    let jobId : Timer.TimerId = switch (callbackName) {
      case "gameweekBeginExpired" {
        Timer.setTimer(duration, gameweekBeginExpiredCallback);
      };
      case "gameKickOffExpired" {
        Timer.setTimer(duration, gameKickOffExpiredCallback);
      };
      case "gameCompletedExpired" {
        Timer.setTimer(duration, gameCompletedExpiredCallback);
      };
      case _ {
        Timer.setTimer(duration, defaultCallback);
      };
    };

    let triggerTime = switch (duration) {
      case (#seconds s) {
        Time.now() + s * 1_000_000_000;
      };
      case (#nanoseconds ns) {
        Time.now() + ns;
      };
    };

    let timerInfo : T.TimerInfo = {
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

  //Fantasy team functions
  public shared query ({ caller }) func getTotalManagers() : async Nat {
    return fantasyTeamsInstance.getTotalManagers();
  };

  public shared query ({ caller }) func getFantasyTeam() : async T.FantasyTeam {
    assert not Principal.isAnonymous(caller);

    let principalId = Principal.toText(caller);
    let fantasyTeam = fantasyTeamsInstance.getFantasyTeam(principalId);

    switch (fantasyTeam) {
      case (null) {
        return {
          principalId = "";
          transfersAvailable = 3;
          bankBalance = 1200;
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
          favouriteTeamId = 0;
          teamName = "";
        };
      };
      case (?team) {
        return team.fantasyTeam;
      };
    };
  };

  public shared ({ caller }) func saveFantasyTeam(newPlayerIds : [Nat16], captainId : Nat16, bonusId : Nat8, bonusPlayerId : Nat16, bonusTeamId : Nat16) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);

    let principalId = Principal.toText(caller);
    let fantasyTeam = fantasyTeamsInstance.getFantasyTeam(principalId);

    let allPlayers = await playerCanister.getAllPlayers();

    let newPlayers = Array.filter<DTOs.PlayerDTO>(
      allPlayers,
      func(player : DTOs.PlayerDTO) : Bool {
        let playerId = player.id;
        let isPlayerIdInNewTeam = Array.find(
          newPlayerIds,
          func(id : Nat16) : Bool {
            return id == playerId;
          },
        );
        return Option.isSome(isPlayerIdInNewTeam);
      },
    );

    let captainExists = Array.find(
      newPlayerIds,
      func(id : Nat16) : Bool {
        return id == captainId;
      },
    );

    if (not Option.isSome(captainExists)) {
      return #err(#InvalidTeamError);
    };

    var teamName = principalId;
    var favouriteTeamId : T.TeamId = 0;

    var userProfile = profilesInstance.getProfile(principalId);
    switch (userProfile) {
      case (null) {

        profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller), getICPDepositAccount(caller), getFPLDepositAccount(caller));
        let newProfile = profilesInstance.getProfile(Principal.toText(caller));
        switch (newProfile) {
          case (null) {};
          case (?foundNewProfile) {
            teamName := foundNewProfile.displayName;
            favouriteTeamId := foundNewProfile.favouriteTeamId;

          };
        };
      };
      case (?foundProfile) {
        teamName := foundProfile.displayName;
        favouriteTeamId := foundProfile.favouriteTeamId;
      };
    };

    switch (fantasyTeam) {
      case (null) {
        return fantasyTeamsInstance.createFantasyTeam(principalId, teamName, favouriteTeamId, seasonManager.getActiveGameweek(), newPlayers, captainId, bonusId, bonusPlayerId, bonusTeamId);
      };
      case (?team) {

        let existingPlayers = Array.filter<DTOs.PlayerDTO>(
          allPlayers,
          func(player : DTOs.PlayerDTO) : Bool {
            let playerId = player.id;
            let isPlayerIdInExistingTeam = Array.find(
              team.fantasyTeam.playerIds,
              func(id : Nat16) : Bool {
                return id == playerId;
              },
            );
            return Option.isSome(isPlayerIdInExistingTeam);
          },
        );

        return await fantasyTeamsInstance.updateFantasyTeam(principalId, newPlayers, captainId, bonusId, bonusPlayerId, bonusTeamId, seasonManager.getActiveGameweek(), existingPlayers);
      };
    };
  };

  //Governance canister validation
  public shared func validateRevaluePlayerUp(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    return #ok();
  };

  public shared func validateRevaluePlayerDown(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    return #ok();
  };

  public shared func validateSubmitFixtureData(fixtureId : T.FixtureId, playerEventData : [T.PlayerEventData]) : async Result.Result<(), T.Error> {
    let validPlayerEvents = validatePlayerEvents(playerEventData);
    if (not validPlayerEvents) {
      return #err(#InvalidData);
    };

    let activeSeasonId = seasonManager.getActiveSeasonId();
    let activeGameweek = seasonManager.getActiveGameweek();
    let fixture = await seasonManager.getFixture(activeSeasonId, activeGameweek, fixtureId);

    if (fixture.status != 2) {
      return #err(#InvalidData);
    };

    return #ok();
  };

  private func validatePlayerEvents(playerEvents : [T.PlayerEventData]) : Bool {

    let eventsBelow0 = Array.filter<T.PlayerEventData>(
      playerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.eventStartMinute < 0;
      },
    );

    if (Array.size(eventsBelow0) > 0) {
      return false;
    };

    let eventsAbove90 = Array.filter<T.PlayerEventData>(
      playerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.eventStartMinute > 90;
      },
    );

    if (Array.size(eventsAbove90) > 0) {
      return false;
    };

    let playerEventsMap : TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>> = TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>>(Utilities.eqNat16, Utilities.hashNat16);

    for (playerEvent in Iter.fromArray(playerEvents)) {
      switch (playerEventsMap.get(playerEvent.playerId)) {
        case (null) {};
        case (?existingEvents) {
          playerEventsMap.put(playerEvent.playerId, List.push<T.PlayerEventData>(playerEvent, existingEvents));
        };
      };
    };

    for ((playerId, events) in playerEventsMap.entries()) {
      let redCards = List.filter<T.PlayerEventData>(
        events,
        func(event : T.PlayerEventData) : Bool {
          return event.eventType == 9; // Red Card
        },
      );

      if (List.size<T.PlayerEventData>(redCards) > 1) {
        return false;
      };

      let yellowCards = List.filter<T.PlayerEventData>(
        events,
        func(event : T.PlayerEventData) : Bool {
          return event.eventType == 8; // Yellow Card
        },
      );

      if (List.size<T.PlayerEventData>(yellowCards) > 2) {
        return false;
      };

      if (List.size<T.PlayerEventData>(yellowCards) == 2 and List.size<T.PlayerEventData>(redCards) != 1) {
        return false;
      };

      let assists = List.filter<T.PlayerEventData>(
        events,
        func(event : T.PlayerEventData) : Bool {
          return event.eventType == 2; // Goal Assisted
        },
      );

      for (assist in Iter.fromList(assists)) {
        let goalsAtSameMinute = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 1 and event.eventStartMinute == assist.eventStartMinute;
          },
        );

        if (List.size<T.PlayerEventData>(goalsAtSameMinute) == 0) {
          return false;
        };
      };

      let penaltySaves = List.filter<T.PlayerEventData>(
        events,
        func(event : T.PlayerEventData) : Bool {
          return event.eventType == 6;
        },
      );

      for (penaltySave in Iter.fromList(penaltySaves)) {
        let penaltyMissesAtSameMinute = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 7 and event.eventStartMinute == penaltySave.eventStartMinute;
          },
        );

        if (List.size<T.PlayerEventData>(penaltyMissesAtSameMinute) == 0) {
          return false;
        };
      };
    };

    return true;
  };

  public shared func validateAddInitialFixtures(seasonId : T.SeasonId, seasonFixtures : [T.Fixture]) : async Result.Result<(), T.Error> {

    let findIndex = func(arr : [T.TeamId], value : T.TeamId) : ?Nat {
      for (i in Array.keys(arr)) {
        if (arr[i] == value) {
          return ?(i);
        };
      };
      return null;
    };

    //there should be no fixtures for the season currently
    let currentSeason = seasonManager.getSeason(seasonId);
    if (currentSeason.id == 0) {
      return #err(#InvalidData);
    };

    for (gameweek in Iter.fromList(currentSeason.gameweeks)) {
      if (List.size(gameweek.fixtures) > 0) {
        return #err(#InvalidData);
      };
    };

    //there are 380 fixtures
    if (Array.size(seasonFixtures) != 380) {
      return #err(#InvalidData);
    };

    let teams = await getTeams();
    let teamIds = Array.map<T.Team, T.TeamId>(teams, func(t : T.Team) : T.TeamId { return t.id });

    let uniqueTeamIdsBuffer = Buffer.fromArray<T.TeamId>([]);

    for (teamId in Iter.fromArray(teamIds)) {
      if (not Buffer.contains<T.TeamId>(uniqueTeamIdsBuffer, teamId, func(a : T.TeamId, b : T.TeamId) : Bool { a == b })) {
        uniqueTeamIdsBuffer.add(teamId);
      };
    };

    //there are 20 teams
    let uniqueTeamIds = Buffer.toArray<T.TeamId>(uniqueTeamIdsBuffer);
    if (Array.size(uniqueTeamIds) != 20) {
      return #err(#InvalidData);
    };

    //19 home games and 19 away games for each team
    let homeGamesCount = Array.tabulate<Nat>(Array.size(uniqueTeamIds), func(_ : Nat) { return 0 });
    let awayGamesCount = Array.tabulate<Nat>(Array.size(uniqueTeamIds), func(_ : Nat) { return 0 });

    let homeGamesBuffer = Buffer.fromArray<Nat>(homeGamesCount);
    let awayGamesBuffer = Buffer.fromArray<Nat>(awayGamesCount);

    for (f in Iter.fromArray(seasonFixtures)) {

      //all default values are set correctly for starting fixture, scores and statuses etc
      if (
        f.homeGoals != 0 or f.awayGoals != 0 or f.status != 0 or not List.isNil(f.events) or f.highestScoringPlayerId != 0,
      ) {
        return #err(#InvalidData);
      };

      //all team ids exist
      let homeTeam = Array.find<T.TeamId>(teamIds, func(teamId : T.TeamId) : Bool { return teamId == f.homeTeamId });
      let awayTeam = Array.find<T.TeamId>(teamIds, func(teamId : T.TeamId) : Bool { return teamId == f.awayTeamId });
      if (homeTeam == null or awayTeam == null) {
        return #err(#InvalidData);
      };

      let homeTeamIndexOpt = findIndex(uniqueTeamIds, f.homeTeamId);
      let awayTeamIndexOpt = findIndex(uniqueTeamIds, f.awayTeamId);

      label check switch (homeTeamIndexOpt, awayTeamIndexOpt) {
        case (?(homeTeamIndex), ?(awayTeamIndex)) {
          let currentHomeGames = homeGamesBuffer.get(homeTeamIndex);
          let currentAwayGames = awayGamesBuffer.get(awayTeamIndex);
          homeGamesBuffer.put(homeTeamIndex, currentHomeGames + 1);
          awayGamesBuffer.put(awayTeamIndex, currentAwayGames + 1);
          break check;
        };
        case _ {
          return #err(#InvalidData);
        };
      };

    };

    let gameweekFixturesBuffer = Buffer.fromArray<Nat>(Array.tabulate<Nat>(38, func(_ : Nat) { return 0 }));

    for (f in Iter.fromArray(seasonFixtures)) {
      let gameweekIndex = f.gameweek - 1;
      let currentCount = gameweekFixturesBuffer.get(Nat8.toNat(gameweekIndex));
      gameweekFixturesBuffer.put(Nat8.toNat(gameweekIndex), currentCount + 1);
    };

    for (i in Iter.fromArray(Buffer.toArray(gameweekFixturesBuffer))) {
      if (gameweekFixturesBuffer.get(i) != 10) {
        return #err(#InvalidData);
      };
    };

    for (i in Iter.fromArray(Buffer.toArray(homeGamesBuffer))) {
      if (homeGamesBuffer.get(i) != 19 or awayGamesBuffer.get(i) != 19) {
        return #err(#InvalidData);
      };
    };

    return #ok();
  };

  public shared func validateRescheduleFixtures(fixtureId : T.FixtureId, currentFixtureGameweek : T.GameweekNumber, updatedFixtureGameweek : T.GameweekNumber, updatedFixtureDate : Int) : async Result.Result<(), T.Error> {
    if (updatedFixtureDate <= Time.now()) {
      return #err(#InvalidData);
    };

    if (updatedFixtureGameweek <= seasonManager.getActiveGameweek()) {
      return #err(#InvalidData);
    };

    let fixture = await seasonManager.getFixture(seasonManager.getActiveSeason().id, currentFixtureGameweek, fixtureId);
    if (fixture.id == 0 or fixture.status == 3) {
      return #err(#InvalidData);
    };

    return #ok();
  };

  public shared func validateLoanPlayer(playerId : T.PlayerId, loanTeamId : T.TeamId, loanEndDate : Int) : async Result.Result<(), T.Error> {

    if (loanEndDate <= Time.now()) {
      return #err(#InvalidData);
    };

    let player = await playerCanister.getPlayer(playerId);
    if (player.id == 0) {
      return #err(#InvalidData);
    };

    //player is not already on loan
    if (player.onLoan) {
      return #err(#InvalidData);
    };

    //loan team exists unless 0
    if (loanTeamId > 0) {
      switch (teamsInstance.getTeam(loanTeamId)) {
        case (null) {
          return #err(#InvalidData);
        };
        case (?foundTeam) {};
      };
    };

    return #ok();
  };

  public shared func validateTransferPlayer(playerId : T.PlayerId, newTeamId : T.TeamId) : async Result.Result<(), T.Error> {

    let player = await playerCanister.getPlayer(playerId);
    if (player.id == 0) {
      return #err(#InvalidData);
    };

    //new club is premier league team
    if (newTeamId > 0) {
      switch (teamsInstance.getTeam(newTeamId)) {
        case (null) {
          return #err(#InvalidData);
        };
        case (?foundTeam) {};
      };
    };

    return #ok();
  };

  public shared func validateRecallPlayer(playerId : T.PlayerId) : async Result.Result<(), T.Error> {

    let player = await playerCanister.getPlayer(playerId);
    if (player.id == 0) {
      return #err(#InvalidData);
    };

    //player is on loan
    if (not player.onLoan) {
      return #err(#InvalidData);
    };

    return #ok();
  };

  public shared func validateCreatePlayer(teamId : T.TeamId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, value : Nat, dateOfBirth : Int, nationality : Text) : async Result.Result<(), T.Error> {

    switch (teamsInstance.getTeam(teamId)) {
      case (null) {
        return #err(#InvalidData);
      };
      case (?foundTeam) {};
    };

    if (Text.size(firstName) > 50) {
      return #err(#InvalidData);
    };

    if (Text.size(lastName) > 50) {
      return #err(#InvalidData);
    };

    if (position > 3) {
      return #err(#InvalidData);
    };

    if (not Utilities.isNationalityValid(nationality)) {
      return #err(#InvalidData);
    };

    if (Utilities.calculateAgeFromUnix(dateOfBirth) < 16) {
      return #err(#InvalidData);
    };

    return #ok();
  };

  public shared func validateUpdatePlayer(playerId : T.PlayerId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, dateOfBirth : Int, nationality : Text) : async Result.Result<(), T.Error> {

    let player = await playerCanister.getPlayer(playerId);
    if (player.id == 0) {
      return #err(#InvalidData);
    };

    if (Text.size(firstName) > 50) {
      return #err(#InvalidData);
    };

    if (Text.size(lastName) > 50) {
      return #err(#InvalidData);
    };

    if (position > 3) {
      return #err(#InvalidData);
    };

    if (not Utilities.isNationalityValid(nationality)) {
      return #err(#InvalidData);
    };

    if (Utilities.calculateAgeFromUnix(dateOfBirth) < 16) {
      return #err(#InvalidData);
    };

    return #ok();
  };

  public shared func validateSetPlayerInjury(playerId : T.PlayerId, description : Text, expectedEndDate : Int) : async Result.Result<(), T.Error> {
    let player = await playerCanister.getPlayer(playerId);
    if (player.id == 0 or player.isInjured) {
      return #err(#InvalidData);
    };
    return #ok();
  };

  public shared func validateRetirePlayer(playerId : T.PlayerId, retirementDate : Int) : async Result.Result<(), T.Error> {
    let player = await playerCanister.getPlayer(playerId);
    if (player.id == 0 or player.retirementDate > 0) {
      return #err(#InvalidData);
    };
    return #ok();
  };

  public shared func validateUnretirePlayer(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    let player = await playerCanister.getPlayer(playerId);
    if (player.id == 0 or player.retirementDate == 0) {
      return #err(#InvalidData);
    };
    return #ok();
  };

  public shared func validatePromoteFormerTeam(teamId : T.TeamId) : async Result.Result<(), T.Error> {

    let allTeams = teamsInstance.getTeams();

    if (Array.size(allTeams) >= 20) {
      return #err(#InvalidData);
    };

    let activeSeason = seasonManager.getActiveSeason();
    let seasonFixtures = seasonManager.getFixturesForSeason(activeSeason.id);
    if (Array.size(seasonFixtures) > 0) {
      return #err(#InvalidData);
    };

    return #ok();
  };

  public shared func validatePromoteNewTeam(name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text) : async Result.Result<(), T.Error> {

    let allTeams = teamsInstance.getTeams();

    if (Array.size(allTeams) >= 20) {
      return #err(#InvalidData);
    };

    let activeSeason = seasonManager.getActiveSeason();
    let seasonFixtures = seasonManager.getFixturesForSeason(activeSeason.id);
    if (Array.size(seasonFixtures) > 0) {
      return #err(#InvalidData);
    };

    if (Text.size(name) > 100) {
      return #err(#InvalidData);
    };

    if (Text.size(friendlyName) > 50) {
      return #err(#InvalidData);
    };

    if (Text.size(abbreviatedName) != 3) {
      return #err(#InvalidData);
    };

    if (not Utilities.validateHexColor(primaryHexColour)) {
      return #err(#InvalidData);
    };

    if (not Utilities.validateHexColor(secondaryHexColour)) {
      return #err(#InvalidData);
    };

    if (not Utilities.validateHexColor(thirdHexColour)) {
      return #err(#InvalidData);
    };

    return #ok();
  };

  public shared func validateUpdateTeam(teamId : T.TeamId, name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text) : async Result.Result<(), T.Error> {

    switch (teamsInstance.getTeam(teamId)) {
      case (null) {
        return #err(#InvalidData);
      };
      case (?foundTeam) {};
    };

    if (Text.size(name) > 100) {
      return #err(#InvalidData);
    };

    if (Text.size(friendlyName) > 50) {
      return #err(#InvalidData);
    };

    if (Text.size(abbreviatedName) != 3) {
      return #err(#InvalidData);
    };

    if (not Utilities.validateHexColor(primaryHexColour)) {
      return #err(#InvalidData);
    };

    if (not Utilities.validateHexColor(secondaryHexColour)) {
      return #err(#InvalidData);
    };

    if (not Utilities.validateHexColor(thirdHexColour)) {
      return #err(#InvalidData);
    };

    return #ok();
  };

  //Governance target methods

  public shared func executeRevaluePlayerUp(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    await playerCanister.revaluePlayerUp(playerId, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
    return #ok();
  };

  public shared func executeRevaluePlayerDown(seasonId : T.SeasonId, gameweek : T.GameweekNumber, playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    await playerCanister.revaluePlayerDown(playerId, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
    return #ok();
  };

  public shared func executeSubmitFixtureData(fixtureId : T.FixtureId, playerEventData : [T.PlayerEventData]) : async Result.Result<(), T.Error> {

    let activeSeasonId = seasonManager.getActiveSeasonId();
    let activeGameweek = seasonManager.getActiveGameweek();
    let fixture = await seasonManager.getFixture(activeSeasonId, activeGameweek, fixtureId);
    let allPlayers = await playerCanister.getAllPlayers();

    let homeTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
    let awayTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

    for (event in Iter.fromArray(playerEventData)) {
      if (event.teamId == fixture.homeTeamId) {
        homeTeamPlayerIdsBuffer.add(event.playerId);
      } else if (event.teamId == fixture.awayTeamId) {
        awayTeamPlayerIdsBuffer.add(event.playerId);
      };
    };

    let homeTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
    let awayTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

    for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(homeTeamPlayerIdsBuffer))) {
      let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
      switch (player) {
        case (null) {};
        case (?actualPlayer) {
          if (actualPlayer.position == 0 or actualPlayer.position == 1) {
            if (Array.find<Nat16>(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
              homeTeamDefensivePlayerIdsBuffer.add(playerId);
            };
          };
        };
      };
    };

    for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(awayTeamPlayerIdsBuffer))) {
      let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
      switch (player) {
        case (null) {};
        case (?actualPlayer) {
          if (actualPlayer.position == 0 or actualPlayer.position == 1) {
            if (Array.find<Nat16>(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
              awayTeamDefensivePlayerIdsBuffer.add(playerId);
            };
          };
        };
      };
    };

    // Get goals for each team
    let homeTeamGoals = Array.filter<T.PlayerEventData>(
      playerEventData,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.homeTeamId and event.eventType == 1;
      },
    );

    let awayTeamGoals = Array.filter<T.PlayerEventData>(
      playerEventData,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.awayTeamId and event.eventType == 1;
      },
    );

    let homeTeamOwnGoals = Array.filter<T.PlayerEventData>(
      playerEventData,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.homeTeamId and event.eventType == 10;
      },
    );

    let awayTeamOwnGoals = Array.filter<T.PlayerEventData>(
      playerEventData,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.awayTeamId and event.eventType == 10;
      },
    );

    let totalHomeScored = Array.size(homeTeamGoals) + Array.size(awayTeamOwnGoals);
    let totalAwayScored = Array.size(awayTeamGoals) + Array.size(homeTeamOwnGoals);

    let allPlayerEventsBuffer = Buffer.fromArray<T.PlayerEventData>(playerEventData);

    if (totalHomeScored == 0) {
      //add away team clean sheets
      for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            let cleanSheetEvent : T.PlayerEventData = {
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
        for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let concededEvent : T.PlayerEventData = {
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

    if (totalAwayScored == 0) {
      //add home team clean sheets
      for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            let cleanSheetEvent : T.PlayerEventData = {
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
        for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let concededEvent : T.PlayerEventData = {
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

    let fixtureEvents = Buffer.toArray(allPlayerEventsBuffer);
    await seasonManager.fixtureConsensusReached(fixture.seasonId, fixture.gameweek, fixtureId, fixtureEvents);
    return #ok();
  };

  public shared func executeAddInitialFixtures(seasonId : T.SeasonId, seasonFixtures : [T.Fixture]) : async Result.Result<(), T.Error> {
    await seasonManager.addInitialFixtures(seasonId, seasonFixtures);
    return #ok();
  };

  public shared func executeRescheduleFixture(fixtureId : T.FixtureId, currentFixtureGameweek : T.GameweekNumber, updatedFixtureGameweek : T.GameweekNumber, updatedFixtureDate : Int) : async Result.Result<(), T.Error> {
    await seasonManager.rescheduleFixture(fixtureId, currentFixtureGameweek, updatedFixtureGameweek, updatedFixtureDate);
    return #ok();
  };

  public shared func executeTransferPlayer(playerId : T.PlayerId, newTeamId : T.TeamId) : async Result.Result<(), T.Error> {
    await playerCanister.transferPlayer(playerId, newTeamId, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
    return #ok();
  };

  public shared func executeLoanPlayer(playerId : T.PlayerId, loanTeamId : T.TeamId, loanEndDate : Int) : async Result.Result<(), T.Error> {
    await playerCanister.loanPlayer(playerId, loanTeamId, loanEndDate, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
    return #ok();
  };

  public shared func executeRecallPlayer(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    await playerCanister.recallPlayer(playerId);
    return #ok();
  };

  public shared func executeCreatePlayer(teamId : T.TeamId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, value : Nat, dateOfBirth : Int, nationality : Text) : async Result.Result<(), T.Error> {
    await playerCanister.createPlayer(teamId, position, firstName, lastName, shirtNumber, value, dateOfBirth, nationality);
    return #ok();
  };

  public shared func executeUpdatePlayer(playerId : T.PlayerId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, dateOfBirth : Int, nationality : Text) : async Result.Result<(), T.Error> {
    await playerCanister.updatePlayer(playerId, position, firstName, lastName, shirtNumber, dateOfBirth, nationality);
    return #ok();
  };

  public shared func executeSetPlayerInjury(playerId : T.PlayerId, description : Text, expectedEndDate : Int) : async Result.Result<(), T.Error> {
    await playerCanister.setPlayerInjury(playerId, description, expectedEndDate);
    return #ok();
  };

  public shared func executeRetirePlayer(playerId : T.PlayerId, retirementDate : Int) : async Result.Result<(), T.Error> {
    await playerCanister.retirePlayer(playerId, retirementDate);
    return #ok();
  };

  public shared func executeUnretirePlayer(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    await playerCanister.unretirePlayer(playerId);
    return #ok();
  };

  public shared func executePromoteFormerTeam(teamId : T.TeamId) : async Result.Result<(), T.Error> {
    await teamsInstance.promoteFormerTeam(teamId);
    return #ok();
  };

  public shared func executePromoteNewTeam(name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text, shirtType : Nat8) : async Result.Result<(), T.Error> {
    await teamsInstance.promoteNewTeam(name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour, shirtType);
    return #ok();
  };

  public shared func executeUpdateTeam(teamId : T.TeamId, name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text, shirtType : Nat8) : async Result.Result<(), T.Error> {
    await teamsInstance.updateTeam(teamId, name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour, shirtType);
    return #ok();
  };

  //Private functions passed to class instances
  private func resetTransfers() : async () {
    await fantasyTeamsInstance.resetTransfers();
  };

  private func calculatePlayerScores(activeSeason : T.SeasonId, activeGameweek : T.GameweekNumber, fixture : T.Fixture) : async T.Fixture {
    let adjFixtures = await playerCanister.calculatePlayerScores(activeSeason, activeGameweek, fixture);
    return adjFixtures;
  };

  private func distributeRewards() : async () {
    await rewardsInstance.distributeRewards();
  };

  private func settleUserBets() : async () {
    await privateLeaguesInstance.settleUserBets();
  };

  private func snapshotGameweek(seasonId : Nat16, gameweek : Nat8) : async () {
    await fantasyTeamsInstance.snapshotGameweek(seasonId, gameweek);
  };

  private func calculateFantasyTeamScores(seasonId : Nat16, gameweek : Nat8) : async () {
    return await fantasyTeamsInstance.calculateFantasyTeamScores(seasonId, gameweek);
  };

  private func resetFantasyTeams() : async () {
    await fantasyTeamsInstance.resetFantasyTeams();
  };

  private func updateCacheHash(category : Text) : async () {
    let hashBuffer = Buffer.fromArray<T.DataCache>([]);

    for (hashObj in Iter.fromList(dataCacheHashes)) {
      if (hashObj.category == category) {
        let randomHash = await SHA224.getRandomHash();
        hashBuffer.add({ category = hashObj.category; hash = randomHash });
      } else { hashBuffer.add(hashObj) };
    };

    dataCacheHashes := List.fromArray(Buffer.toArray<T.DataCache>(hashBuffer));
  };

  private func updatePlayerEventDataCache() : async () {
    await playerCanister.updatePlayerEventDataCache();
  };

  private func getGameweekFixtures(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : [T.Fixture] {
    return seasonManager.getGameweekFixtures(seasonId, gameweek);
  };

  public shared query ({ caller }) func getFantasyTeamForGameweek(managerId : Text, seasonId : Nat16, gameweek : Nat8) : async T.FantasyTeamSnapshot {
    return fantasyTeamsInstance.getFantasyTeamForGameweek(managerId, seasonId, gameweek);
  };

  public shared query func getManager(managerId : Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async DTOs.ManagerDTO {

    var displayName = "";
    var profilePicture = Blob.fromArray([]);
    var favouriteTeamId : T.TeamId = 0;
    var createDate = Time.now();
    var gameweeks : [T.FantasyTeamSnapshot] = [];

    var weeklyLeaderboardEntry = fantasyTeamsInstance.getWeeklyLeaderboardEntry(managerId, seasonId, gameweek);
    var seasonLeaderboardEntry = fantasyTeamsInstance.getSeasonLeaderboardEntry(managerId, seasonId);
    var monthlyLeaderboardEntry : ?T.LeaderboardEntry = null;

    let userProfile = profilesInstance.getProfile(managerId);
    switch (userProfile) {
      case (null) {};
      case (?foundProfile) {
        displayName := foundProfile.displayName;
        profilePicture := foundProfile.profilePicture;
        favouriteTeamId := foundProfile.favouriteTeamId;
        createDate := foundProfile.createDate;

        if (foundProfile.favouriteTeamId > 0) {
          monthlyLeaderboardEntry := fantasyTeamsInstance.getMonthlyLeaderboardEntry(managerId, seasonId, foundProfile.favouriteTeamId);
        }

      };
    };

    //get gameweek snapshots
    let fantasyTeam = fantasyTeamsInstance.getFantasyTeam(managerId);

    switch (fantasyTeam) {
      case (null) {};
      case (?foundTeam) {

        let season = List.find(
          foundTeam.history,
          func(season : T.FantasyTeamSeason) : Bool {
            return season.seasonId == seasonId;
          },
        );

        switch (season) {
          case (null) {};
          case (?foundSeason) {
            gameweeks := List.toArray(foundSeason.gameweeks);
          };
        };
      };
    };

    var weeklyPosition : Int = 0;
    var monthlyPosition : Int = 0;
    var seasonPosition : Int = 0;

    var weeklyPositionText = "N/A";
    var monthlyPositionText = "N/A";
    var seasonPositionText = "N/A";

    var weeklyPoints : Int16 = 0;
    var monthlyPoints : Int16 = 0;
    var seasonPoints : Int16 = 0;

    switch (weeklyLeaderboardEntry) {
      case (null) {};
      case (?foundEntry) {
        weeklyPosition := foundEntry.position;
        weeklyPositionText := foundEntry.positionText;
        weeklyPoints := foundEntry.points;
      };
    };

    switch (monthlyLeaderboardEntry) {
      case (null) {};
      case (?foundEntry) {
        monthlyPosition := foundEntry.position;
        monthlyPositionText := foundEntry.positionText;
        monthlyPoints := foundEntry.points;
      };
    };

    switch (seasonLeaderboardEntry) {
      case (null) {};
      case (?foundEntry) {
        seasonPosition := foundEntry.position;
        seasonPositionText := foundEntry.positionText;
        seasonPoints := foundEntry.points;
      };
    };

    let managerDTO : DTOs.ManagerDTO = {
      principalId = managerId;
      displayName = displayName;
      profilePicture = profilePicture;
      favouriteTeamId = favouriteTeamId;
      createDate = createDate;
      gameweeks = gameweeks;
      weeklyPosition = weeklyPosition;
      monthlyPosition = monthlyPosition;
      seasonPosition = seasonPosition;
      weeklyPositionText = weeklyPositionText;
      monthlyPositionText = monthlyPositionText;
      seasonPositionText = seasonPositionText;
      weeklyPoints = weeklyPoints;
      monthlyPoints = monthlyPoints;
      seasonPoints = seasonPoints;
    };

    return managerDTO;
  };

  public shared query func getDataHashes() : async [T.DataCache] {
    return List.toArray(dataCacheHashes);
  };

  private stable var stable_timers : [T.TimerInfo] = [];

  //intialise season manager
  let seasonManager = SeasonManager.SeasonManager(
    resetTransfers,
    calculatePlayerScores,
    distributeRewards,
    settleUserBets,
    snapshotGameweek,
    calculateFantasyTeamScores,
    getAllPlayersMap,
    resetFantasyTeams,
    updateCacheHash,
    stable_timers,
    updatePlayerEventDataCache,
  );

  seasonManager.setTimerBackupFunction(setAndBackupTimer);
  fantasyTeamsInstance.setGetFixturesFunction(getGameweekFixtures);

  //stable variable backup
  private stable var stable_profiles : [(Text, T.Profile)] = [];
  private stable var stable_fantasy_teams : [(Text, T.UserFantasyTeam)] = [];
  private stable var stable_active_season_id : Nat16 = 0;
  private stable var stable_active_gameweek : Nat8 = 0;
  private stable var stable_interesting_gameweek : Nat8 = 0;
  private stable var stable_active_fixtures : [T.Fixture] = [];
  private stable var stable_next_fixture_id : Nat32 = 0;
  private stable var stable_next_season_id : Nat16 = 0;
  private stable var stable_seasons : [T.Season] = [];
  private stable var stable_teams : [T.Team] = [];
  private stable var stable_relegated_teams : [T.Team] = [];
  private stable var stable_next_team_id : Nat16 = 0;
  private stable var stable_max_votes_per_user : Nat64 = 0;
  private stable var stable_season_leaderboards : [(Nat16, T.SeasonLeaderboards)] = [];
  private stable var stable_monthly_leaderboards : [(T.SeasonId, List.List<T.ClubLeaderboard>)] = [];
  private stable var stable_data_cache_hashes : [T.DataCache] = [];

  system func preupgrade() {

    stable_fantasy_teams := fantasyTeamsInstance.getFantasyTeams();
    stable_profiles := profilesInstance.getProfiles();
    stable_active_season_id := seasonManager.getActiveSeasonId();
    stable_active_gameweek := seasonManager.getActiveGameweek();
    stable_interesting_gameweek := seasonManager.getInterestingGameweek();
    stable_active_fixtures := seasonManager.getActiveFixtures();
    stable_next_fixture_id := seasonManager.getNextFixtureId();
    stable_next_season_id := seasonManager.getNextSeasonId();
    stable_seasons := seasonManager.getSeasons();
    stable_teams := teamsInstance.getTeams();
    stable_relegated_teams := teamsInstance.getRelegatedTeams();
    stable_next_team_id := teamsInstance.getNextTeamId();
    stable_season_leaderboards := fantasyTeamsInstance.getSeasonLeaderboards();
    stable_monthly_leaderboards := fantasyTeamsInstance.getMonthlyLeaderboards();
    stable_data_cache_hashes := List.toArray(dataCacheHashes);
  };

  system func postupgrade() {
    profilesInstance.setData(stable_profiles);
    fantasyTeamsInstance.setData(stable_fantasy_teams);
    seasonManager.setData(stable_seasons, stable_active_season_id, stable_active_gameweek, stable_active_fixtures, stable_next_fixture_id, stable_next_season_id, stable_interesting_gameweek);
    teamsInstance.setData(stable_teams, stable_next_team_id, stable_relegated_teams);
    fantasyTeamsInstance.setDataForSeasonLeaderboards(stable_season_leaderboards);
    fantasyTeamsInstance.setDataForMonthlyLeaderboards(stable_monthly_leaderboards);
    dataCacheHashes := List.fromArray(stable_data_cache_hashes);
    recreateTimers();
  };

  private func recreateTimers() {
    let currentTime = Time.now();
    for (timerInfo in Iter.fromArray(stable_timers)) {
      let remainingDuration = timerInfo.triggerTime - currentTime;

      if (remainingDuration > 0) {
        let duration : Timer.Duration = #nanoseconds(Int.abs(remainingDuration));

        switch (timerInfo.callbackName) {
          case "gameweekBeginExpired" {
            ignore Timer.setTimer(duration, gameweekBeginExpiredCallback);
          };
          case "gameKickOffExpired" {
            ignore Timer.setTimer(duration, gameKickOffExpiredCallback);
          };
          case "gameCompletedExpired" {
            ignore Timer.setTimer(duration, gameCompletedExpiredCallback);
          };
          case _ {
            ignore Timer.setTimer(duration, defaultCallback);
          };
        };
      };
    };
  };

  /* Remove these functions post-sns */
  public shared ({ caller }) func savePlayerEvents(fixtureId : T.FixtureId, allPlayerEvents : [T.PlayerEventData]) : async () {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == "opyzn-r7zln-jwgvb-tx75c-ncekh-xhvje-epcj7-saonq-z732m-zi4mm-qae"; //JB LIVE
    //assert Principal.toText(caller) == "5mizu-xuphz-aex5b-ovid6-oqt34-jdb5k-fn5hr-ip7iu-ghgz4-jilrl-bqe"; //JB Local 2
    //assert Principal.toText(caller) == "6sbwi-mq6zw-jcwiq-urs3i-2abjy-o7p3o-n33vj-ecw43-vsd2w-4poay-iqe"; //JB LOCAL

    let validPlayerEvents = validatePlayerEvents(allPlayerEvents);

    if (not validPlayerEvents) {
      return;
    };

    let activeSeasonId = seasonManager.getActiveSeasonId();
    let activeGameweek = seasonManager.getActiveGameweek();
    let fixture = await seasonManager.getFixture(activeSeasonId, activeGameweek, fixtureId);

    if (fixture.status != 2) {
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

    for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(homeTeamPlayerIdsBuffer))) {
      let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
      switch (player) {
        case (null) { /* do nothing */ };
        case (?actualPlayer) {
          if (actualPlayer.position == 0 or actualPlayer.position == 1) {
            if (Array.find<Nat16>(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
              homeTeamDefensivePlayerIdsBuffer.add(playerId);
            };
          };
        };
      };
    };

    for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(awayTeamPlayerIdsBuffer))) {
      let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
      switch (player) {
        case (null) { /* do nothing */ };
        case (?actualPlayer) {
          if (actualPlayer.position == 0 or actualPlayer.position == 1) {
            if (Array.find<Nat16>(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
              awayTeamDefensivePlayerIdsBuffer.add(playerId);
            };
          };
        };
      };
    };

    // Get goals for each team
    let homeTeamGoals = Array.filter<T.PlayerEventData>(
      allPlayerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.homeTeamId and event.eventType == 1;
      },
    );

    let awayTeamGoals = Array.filter<T.PlayerEventData>(
      allPlayerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.awayTeamId and event.eventType == 1;
      },
    );

    let homeTeamOwnGoals = Array.filter<T.PlayerEventData>(
      allPlayerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.homeTeamId and event.eventType == 10;
      },
    );

    let awayTeamOwnGoals = Array.filter<T.PlayerEventData>(
      allPlayerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.awayTeamId and event.eventType == 10;
      },
    );

    let totalHomeScored = Array.size(homeTeamGoals) + Array.size(awayTeamOwnGoals);
    let totalAwayScored = Array.size(awayTeamGoals) + Array.size(homeTeamOwnGoals);

    if (totalHomeScored == 0) {
      //add away team clean sheets
      for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            let cleanSheetEvent : T.PlayerEventData = {
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
        for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let concededEvent : T.PlayerEventData = {
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

    if (totalAwayScored == 0) {
      //add home team clean sheets
      for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            let cleanSheetEvent : T.PlayerEventData = {
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
        for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let concededEvent : T.PlayerEventData = {
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

    await finaliseFixture(fixture.seasonId, fixture.gameweek, fixture.id, Buffer.toArray(allPlayerEventsBuffer));
  };

  private func finaliseFixture(seasonId : T.SeasonId, gameweekNumber : T.GameweekNumber, fixtureId : T.FixtureId, events : [T.PlayerEventData]) : async () {
    await seasonManager.fixtureConsensusReached(seasonId, gameweekNumber, fixtureId, events);
  };

  public shared query ({ caller }) func getValidatableFixtures() : async [T.Fixture] {
    assert not Principal.isAnonymous(caller);
    return seasonManager.getValidatableFixtures();
  };

  public func updateTeamValueInfo() : async () {
    await fantasyTeamsInstance.updateTeamValueInfo();
  };

  public func getTeamValueInfo() : async [Text] {
    await fantasyTeamsInstance.getTeamValueInfo();
  };

  public func getTimers() : async [T.TimerInfo] {
    return stable_timers;
  };

  public func rescheduleFixture() : async () {
    return await seasonManager.rescheduleFixture(176, 18, 0, 1_703_343_600_000_000_000);
    await updateCacheHash("fixtures");
    await updateCacheHash("system_state");
  };

  //Local dev functions

  public func setGameweekFixtures() : async () {
    await seasonManager.setGameweekFixtures();
  };

  public shared func getAddTeamsFunction() : async Text {
    let fantasyTeams = fantasyTeamsInstance.getFantasyTeams();
    var output = "let fantasyTeams: [(Text, T.UserFantasyTeam)] = [";
    for ((principal, team) in Iter.fromArray(fantasyTeams)) {
      let fantasyTeam = team.fantasyTeam;
      let history = team.history;

      // Convert FantasyTeam
      var fantasyTeamText = "{playerIds = [" # joinPlayers(fantasyTeam.playerIds, ", ") # "]; " # "captainId=" # Nat16.toText(fantasyTeam.captainId) # "; " # "bankBalance=" # Nat.toText(fantasyTeam.bankBalance) # ";" # "braceBonusGameweek=" # Nat8.toText(fantasyTeam.braceBonusGameweek) # "; " # "captainFantasticGameweek=" # Nat8.toText(fantasyTeam.captainFantasticGameweek) # "; " # "captainFantasticPlayerId=" # Nat16.toText(fantasyTeam.captainFantasticPlayerId) # "; " # "goalGetterGameweek=" # Nat8.toText(fantasyTeam.goalGetterGameweek) # "; " # "goalGetterPlayerId=" # Nat16.toText(fantasyTeam.goalGetterPlayerId) # "; " # "hatTrickHeroGameweek=" # Nat8.toText(fantasyTeam.hatTrickHeroGameweek) # "; " # "noEntryGameweek=" # Nat8.toText(fantasyTeam.noEntryGameweek) # "; " # "noEntryPlayerId=" # Nat16.toText(fantasyTeam.noEntryPlayerId) # "; " # "passMasterGameweek=" # Nat8.toText(fantasyTeam.passMasterGameweek) # "; " # "passMasterPlayerId=" # Nat16.toText(fantasyTeam.passMasterPlayerId) # "; " # "principalId=\"" # fantasyTeam.principalId # "\"" # "; " # "safeHandsGameweek=" # Nat8.toText(fantasyTeam.safeHandsGameweek) # "; " # "safeHandsPlayerId=" # Nat16.toText(fantasyTeam.safeHandsPlayerId) # "; " # "teamBoostGameweek=" # Nat8.toText(fantasyTeam.teamBoostGameweek) # "; " # "teamBoostTeamId=" # Nat16.toText(fantasyTeam.teamBoostTeamId) # "; " # "favouriteTeamId=0; " # "teamName=\"\"; " # "transfersAvailable=" # Nat8.toText(fantasyTeam.transfersAvailable) # "; }";

      // Convert History
      var historyTextsBuffer = Buffer.fromArray<Text>([]);
      for (season in Iter.fromList(history)) {

        var gameweekTextHistoryBuffer = Buffer.fromArray<Text>([]);

        for (gameweek in Iter.fromList(season.gameweeks)) {

          var gameweekText = "{playerIds = [" # joinPlayers(gameweek.playerIds, ", ") # "]; " # "captainId=" # Nat16.toText(gameweek.captainId) # "; " # "bankBalance=" # Nat.toText(gameweek.bankBalance) # ";" # "braceBonusGameweek=" # Nat8.toText(gameweek.braceBonusGameweek) # "; " # "captainFantasticGameweek=" # Nat8.toText(gameweek.captainFantasticGameweek) # "; " # "captainFantasticPlayerId=" # Nat16.toText(gameweek.captainFantasticPlayerId) # "; " # "goalGetterGameweek=" # Nat8.toText(gameweek.goalGetterGameweek) # "; " # "goalGetterPlayerId=" # Nat16.toText(gameweek.goalGetterPlayerId) # "; " # "hatTrickHeroGameweek=" # Nat8.toText(gameweek.hatTrickHeroGameweek) # "; " # "noEntryGameweek=" # Nat8.toText(gameweek.noEntryGameweek) # "; " # "noEntryPlayerId=" # Nat16.toText(gameweek.noEntryPlayerId) # "; " # "passMasterGameweek=" # Nat8.toText(gameweek.passMasterGameweek) # "; " # "passMasterPlayerId=" # Nat16.toText(gameweek.passMasterPlayerId) # "; " # "principalId=\"" # gameweek.principalId # "\"" # "; " # "safeHandsGameweek=" # Nat8.toText(gameweek.safeHandsGameweek) # "; " # "safeHandsPlayerId=" # Nat16.toText(gameweek.safeHandsPlayerId) # "; " # "teamBoostGameweek=" # Nat8.toText(gameweek.teamBoostGameweek) # "; " # "teamBoostTeamId=" # Nat16.toText(gameweek.teamBoostTeamId) # "; " # "points=" # Int16.toText(gameweek.points) # "; " # "gameweek=" # Nat8.toText(gameweek.gameweek) # "; " # "favouriteTeamId=0; " # "teamName=\"\"; " # "transfersAvailable=" # Nat8.toText(gameweek.transfersAvailable) # "; }";
          gameweekTextHistoryBuffer.add(gameweekText);
        };

        let allGameweekText = "List.fromArray<T.FantasyTeamSnapshot>([" # joinText(Buffer.toArray(gameweekTextHistoryBuffer), ", ") # "])";

        var seasonText = "{ seasonId=" # Nat16.toText(season.seasonId) # "; totalPoints=" # Int16.toText(season.totalPoints) # "; gameweeks= " # allGameweekText # "}";

        historyTextsBuffer.add(seasonText);
      };
      let allHistoryText = "List.fromArray<T.FantasyTeamSeason>([" # joinText(Buffer.toArray(historyTextsBuffer), ", ") # "])";

      output #= "(\"" # principal # "\", {" # "fantasyTeam = " # fantasyTeamText # "; history = " # allHistoryText # "}),";
    };
    output #= "];";
    return output;
  };

  private func joinPlayers(arr : [T.PlayerId], delimiter : Text) : Text {
    var result = "";
    let len : Int = Array.size<T.PlayerId>(arr);
    var i : Nat = 0;
    for (item in Iter.fromArray(arr)) {
      result #= Nat16.toText(item);
      if (i != len - 1) {
        result #= delimiter;
      };
      i += 1;
    };
    return result;
  };

  private func joinText(arr : [Text], delimiter : Text) : Text {
    var result = "";
    let len : Int = Array.size<Text>(arr);
    var i : Nat = 0;
    for (item in Iter.fromArray(arr)) {
      result #= item;
      if (i != len - 1) {
        result #= delimiter;
      };
      i += 1;
    };
    return result;
  };
};
