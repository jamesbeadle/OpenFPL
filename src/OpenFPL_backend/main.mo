import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import TrieMap "mo:base/TrieMap";

import Account "Account";
import Book "book";
import Countries "Countries";
import FantasyTeams "fantasy-teams";
import Teams "teams";
import Profiles "profiles";
import Rewards "rewards";
import SeasonManager "season-manager";
import SHA224 "SHA224";
import Utilities "utilities";

import T "types";
import DTOs "DTOs";

actor Self {

  let seasonManager = SeasonManager.SeasonManager();  
  
  let closeGameweekTimer: ?Timer = null;
  let janTransferWindowStart: ?Timer = null;
  let activeGameTimers: [Timer] = [];

  public shared func init() : async Result.Result<(), T.Error>  {
    let firstFixture = seasonManager.init();
    switch(firstFixture){
      case (null) {

      };
      case (?returnedFixture){
        //set a timer for 1 hour before the first kick off to begin everything
      };
    };
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

  private func loanExpiredCallback() : async () {
    await seasonManager.loanExpiredCallback();
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
      case "loanExpired" {
        Timer.setTimer(duration, gameCompletedExpiredCallback);
      };
      case _ { };
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












  public shared query func getDataHashes() : async DTOs.DataCacheDTO {
    return seasonManager.getDataHashes();
  };

  public shared query func getFixtures(seasonId: T.SeasonId) : async Result.Result<[DTOs.FixtureDTO], T.Error>  {
    return #ok();
  };

  public shared query func getWeeklyLeaderboard(gameweek: T.GameweekNumber, seasonId: T.SeasonId) : async Result.Result<[DTOs.WeeklyLeaderboardDTO], T.Error>  {
    return #ok();
  };

  public shared query func getClubLeaderboard(clubId: T.ClubId) : async Result.Result<[DTOs.ClubLeaderboardDTO], T.Error>  {
    return #ok();
  };

  public shared query func getSeasonLeaderboard(seasonId: T.SeasonId) : async Result.Result<[DTOs.SeasonLeaderboardDTO], T.Error>  {
    return #ok();
  };

  public shared query ({ caller }) func getProfile() : async Result.Result<[DTOs.ProfileDTO], T.Error>  {
    assert not Principal.isAnonymous(caller);
    //include all profile info for caller
    //include all manager info
    //GetProfile
      //GetGameweekPoints?? - Replace with GetProfile which includes their season history
      //Will include their current team and the pick team should copy from this for the in game session changes
    return #ok();
  };

  public shared query func getManager(principalId: Text) : async Result.Result<[DTOs.ProfileDTO], T.Error>  {
    //include all manager info
    return #ok();
  };

  public shared query func getTotalManagers() : async Result.Result<[Nat], T.Error>  {
    return #ok();
  };

  public shared query func getSystemState() : async Result.Result<[DTOs.SystemStateDTO], T.Error>  {
    return #ok();
  };

  public shared query func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error>  {
    return #ok();
  };

  public shared query func getDetailedPlayers(gameweek: T.GameweekNumber) : async Result.Result<[DTOs.PlayerDTO], T.Error>  {
    //return the players with event details for a specific gameweek
    return #ok();
  };

  public shared query func getCountries() : async [DTOs.CountryDTO] {
    return List.toArray(countriesInstance.countries);
  };

  public shared query ({ caller }) func isUsernameAvailable(username : Text) : async Bool {
    assert not Principal.isAnonymous(caller);
    return profilesInstance.isDisplayNameValid(displayName);
  };

  public shared ({ caller }) func createProfile() : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);

    var existingProfile = profilesInstance.getProfile(Principal.toText(caller));
    switch (existingProfile) {
      case (null) {
        profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
      };
      case (_) {};
    };
  };

  public shared ({ caller }) func updateUsername(displayName : Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let invalidName = not profilesInstance.isDisplayNameValid(displayName);
    assert not invalidName;

    var profile = profilesInstance.getProfile(Principal.toText(caller));
    switch (profile) {
      case (null) {
        profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
        profile := profilesInstance.getProfile(Principal.toText(caller));
      };
      case (?foundProfile) {};
    };

    fantasyTeamsInstance.updateDisplayName(Principal.toText(caller), displayName);
    return profilesInstance.updateDisplayName(Principal.toText(caller), displayName);
  };

  public shared ({ caller }) func updateFavouriteClub(favouriteClubId : T.ClubId) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);

    var profile = profilesInstance.getProfile(Principal.toText(caller));
    switch (profile) {
      case (null) {
        profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
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

  public shared ({ caller }) func saveFantasyTeam(fantasyTeam: DTOs.UpdateFantasyTeamDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);

    let principalId = Principal.toText(caller);
    let fantasyTeam = fantasyTeamsInstance.getFantasyTeam(principalId);

    let allPlayers = await playerCanister.getPlayers();

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

    var updateTransferWindowGameweek: T.GameweekNumber = 0;
    let transferWindowActive = false;
    
    if(not transferWindowActive and transferWindowGameweek > 0){

      let transferWindowPlayed = false;
      if(transferWindowPlayed){
        return #err(#InvalidTeamError);
      };

      let activeGameweek = seasonManager.getActiveGameweek();

      if(transferWindowGameweek != activeGameweek){
        return #err(#InvalidTeamError);
      };
      updateTransferWindowGameweek := activeGameweek;
    };

    var teamName = principalId;
    var favouriteTeamId : T.TeamId = 0;

    var userProfile = profilesInstance.getProfile(principalId);
    switch (userProfile) {
      case (null) {

        profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
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

        if(team.fantasyTeam.transferWindowGameweek > 0){
          updateTransferWindowGameweek := team.fantasyTeam.transferWindowGameweek;
        };

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

        return await fantasyTeamsInstance.updateFantasyTeam(principalId, newPlayers, captainId, bonusId, bonusPlayerId, bonusTeamId, seasonManager.getActiveGameweek(), existingPlayers, updateTransferWindowGameweek);
      };
    };
  };
    











  
  //All the governance entry points

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

  public shared func validateCreatePlayer(teamId : T.TeamId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, value : Nat, dateOfBirth : Int, nationality : T.CountryId) : async Result.Result<(), T.Error> {
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

    if (not countriesInstance.isCountryValid(nationality)) {
      return #err(#InvalidData);
    };

    if (Utilities.calculateAgeFromUnix(dateOfBirth) < 16) {
      return #err(#InvalidData);
    };

    return #ok();
  };

  public shared func validateUpdatePlayer(playerId : T.PlayerId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, dateOfBirth : Int, nationality : T.CountryId) : async Result.Result<(), T.Error> {
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

    if (not countriesInstance.isCountryValid(nationality)) {
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
    let allPlayers = await playerCanister.getPlayers();

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

  public shared func executeCreatePlayer(teamId : T.TeamId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, value : Nat, dateOfBirth : Int, nationality : T.CountryId) : async Result.Result<(), T.Error> {
    await playerCanister.createPlayer(teamId, position, firstName, lastName, shirtNumber, value, dateOfBirth, nationality);
    return #ok();
  };

  public shared func executeUpdatePlayer(playerId : T.PlayerId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, dateOfBirth : Int, nationality : T.CountryId) : async Result.Result<(), T.Error> {
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
  private stable var stable_timers : [T.TimerInfo] = [];

  system func preupgrade() {

    stable_fantasy_teams := fantasyTeamsInstance.getFantasyTeams();
    stable_profiles := profilesInstance.getProfiles();
    stable_active_season_id := seasonManager.getActiveSeasonId();
    stable_active_gameweek := seasonManager.getActiveGameweek();
    stable_interesting_gameweek := seasonManager.getInterestingGameweek();
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

  private func recreateTimers() { //NEED TO MAKE SURE THESE ARE THE CORRECT TIMERS TO USE
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

    //recreate close gameweek timer to be 1 hour before the first fixture of the gameweek you are picking your team for

    //recreate the jan transfer window timer to the next January 1st

    //recreate the close jan transfer window timer for midnight on the 31st Jan

    //recreate timers for active games that are counting down to move a game from inactive to active or active to completed

  };

};
