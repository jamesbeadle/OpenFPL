import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Order "mo:base/Order";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Utilities "utilities";
import Int "mo:base/Int";
import Debug "mo:base/Debug";
import Int16 "mo:base/Int16";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";

module {
  public class FantasyTeams(
    getPlayersMap : (seasonId : Nat16, gameweek : Nat8) -> async [(Nat16, DTOs.PlayerScoreDTO)],
    getPlayer : (playerId : Nat16) -> async T.Player,
    getProfiles : () -> [(Text, T.Profile)],
    getPlayers : () -> async [DTOs.PlayerDTO],
  ) {

    private var seasonLeaderboards : HashMap.HashMap<Nat16, T.SeasonLeaderboards> = HashMap.HashMap<Nat16, T.SeasonLeaderboards>(100, Utilities.eqNat16, Utilities.hashNat16);
    private var monthlyLeaderboards : HashMap.HashMap<T.SeasonId, List.List<T.ClubLeaderboard>> = HashMap.HashMap<T.SeasonId, List.List<T.ClubLeaderboard>>(100, Utilities.eqNat16, Utilities.hashNat16);

    private var getGameweekFixtures : ?((seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> [T.Fixture]) = null;

    public func setGetFixturesFunction(_getGameweekFixtures : ((seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> [T.Fixture])) {
      getGameweekFixtures := ?_getGameweekFixtures;
    };

    public func getMonthlyLeaderboards() : [(T.SeasonId, List.List<T.ClubLeaderboard>)] {
      return Iter.toArray(monthlyLeaderboards.entries());
    };

    public func setDataForMonthlyLeaderboards(data : [(T.SeasonId, List.List<T.ClubLeaderboard>)]) {
      monthlyLeaderboards := HashMap.fromIter<T.SeasonId, List.List<T.ClubLeaderboard>>(
        data.vals(),
        data.size(),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    };

    public func setData(stable_fantasy_teams : [(Text, T.UserFantasyTeam)]) {
      fantasyTeams := HashMap.fromIter<Text, T.UserFantasyTeam>(
        stable_fantasy_teams.vals(),
        stable_fantasy_teams.size(),
        Text.equal,
        Text.hash,
      );
    };

    public func getFantasyTeams() : [(Text, T.UserFantasyTeam)] {
      return Iter.toArray(fantasyTeams.entries());
    };

    public func getSeasonLeaderboards() : [(Nat16, T.SeasonLeaderboards)] {
      return Iter.toArray(seasonLeaderboards.entries());
    };

    public func setDataForSeasonLeaderboards(data : [(Nat16, T.SeasonLeaderboards)]) {
      seasonLeaderboards := HashMap.fromIter<Nat16, T.SeasonLeaderboards>(
        data.vals(),
        data.size(),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    };

    public func getFantasyTeam(principalId : Text) : ?T.UserFantasyTeam {
      return fantasyTeams.get(principalId);
    };

    public func createFantasyTeam(principalId : Text, teamName : Text, favouriteTeamId : T.TeamId, gameweek : Nat8, newPlayers : [DTOs.PlayerDTO], captainId : Nat16, bonusId : Nat8, bonusPlayerId : Nat16, bonusTeamId : Nat16) : Result.Result<(), T.Error> {

      let existingTeam = fantasyTeams.get(principalId);

      switch (existingTeam) {
        case (null) {

          let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(newPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.value });

          if (not isTeamValid(newPlayers, bonusId, bonusPlayerId)) {
            return #err(#InvalidTeamError);
          };

          let totalTeamValue = Array.foldLeft<Nat, Nat>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

          if (totalTeamValue > 1200) {
            return #err(#InvalidTeamError);
          };

          let bank : Nat = 1200 - totalTeamValue;

          var bankBalance = bank;
          var goalGetterGameweek = Nat8.fromNat(0);
          var goalGetterPlayerId = Nat16.fromNat(0);
          var passMasterGameweek = Nat8.fromNat(0);
          var passMasterPlayerId = Nat16.fromNat(0);
          var noEntryGameweek = Nat8.fromNat(0);
          var noEntryPlayerId = Nat16.fromNat(0);
          var teamBoostGameweek = Nat8.fromNat(0);
          var teamBoostTeamId = Nat16.fromNat(0);
          var safeHandsGameweek = Nat8.fromNat(0);
          var captainFantasticGameweek = Nat8.fromNat(0);

          var countrymenGameweek = Nat8.fromNat(0);
          var countrymenCountryId = Nat16.fromNat(0);
          var prospectsGameweek = Nat8.fromNat(0);
          var braceBonusGameweek = Nat8.fromNat(0);
          var hatTrickHeroGameweek = Nat8.fromNat(0);
          var newCaptainId = captainId;

          let sortedPlayers = sortPlayers(newPlayers);
          let allPlayerIds = Array.map<DTOs.PlayerDTO, Nat16>(sortedPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.id });

          if (newCaptainId == 0) {
            var highestValue = 0;
            for (i in Iter.range(0, Array.size(newPlayers) -1)) {
              if (newPlayers[i].value > highestValue) {
                highestValue := newPlayers[i].value;
                newCaptainId := newPlayers[i].id;
              };
            };
          };

          if (bonusId == 1 and bonusPlayerId > 0) {
            goalGetterGameweek := gameweek;
            goalGetterPlayerId := bonusPlayerId;
          };

          if (bonusId == 2 and bonusPlayerId > 0) {
            passMasterGameweek := gameweek;
            passMasterPlayerId := bonusPlayerId;
          };

          if (bonusId == 3 and bonusPlayerId > 0) {
            noEntryGameweek := gameweek;
            noEntryPlayerId := bonusPlayerId;
          };

          if (bonusId == 4 and bonusTeamId > 0) {
            teamBoostGameweek := gameweek;
            teamBoostTeamId := bonusTeamId;
          };

          if (bonusId == 5) {
            safeHandsGameweek := gameweek;
          };

          if (bonusId == 6) {
            captainFantasticGameweek := gameweek;
          };

          if (bonusId == 7) {
            prospectsGameweek := gameweek;
          };

          if (bonusId == 8) {
            countrymenGameweek := gameweek;
            countrymenCountryId := bonusPlayerId;
          };

          if (bonusId == 9) {
            braceBonusGameweek := gameweek;
          };

          if (bonusId == 10) {
            hatTrickHeroGameweek := gameweek;
          };

          var captainFantasticPlayerId : T.PlayerId = 0;
          var safeHandsPlayerId : T.PlayerId = 0;

          if (captainFantasticGameweek == gameweek) {
            captainFantasticPlayerId := newCaptainId;
          };

          if (safeHandsGameweek == gameweek) {

            let goalKeeper = List.find<DTOs.PlayerDTO>(
              List.fromArray(sortedPlayers),
              func(player : DTOs.PlayerDTO) : Bool {
                return player.position == 0;
              },
            );

            switch (goalKeeper) {
              case (null) {};
              case (?gk) {
                safeHandsPlayerId := gk.id;
              };
            };
          };

          var newTeam : T.FantasyTeam = {
            principalId = principalId;
            bankBalance = bankBalance;
            playerIds = allPlayerIds;
            transfersAvailable = 3;
            transferWindowGameweek = 0;
            captainId = newCaptainId;
            goalGetterGameweek = goalGetterGameweek;
            goalGetterPlayerId = goalGetterPlayerId;
            passMasterGameweek = passMasterGameweek;
            passMasterPlayerId = passMasterPlayerId;
            noEntryGameweek = noEntryGameweek;
            noEntryPlayerId = noEntryPlayerId;
            teamBoostGameweek = teamBoostGameweek;
            teamBoostTeamId = teamBoostTeamId;
            safeHandsGameweek = safeHandsGameweek;
            safeHandsPlayerId = safeHandsPlayerId;
            captainFantasticGameweek = captainFantasticGameweek;
            captainFantasticPlayerId = captainFantasticPlayerId;
            countrymenGameweek = countrymenGameweek;
            countrymenCountryId = countrymenCountryId;
            prospectsGameweek = prospectsGameweek;
            braceBonusGameweek = braceBonusGameweek;
            hatTrickHeroGameweek = hatTrickHeroGameweek;
            teamName = teamName;
            favouriteTeamId = favouriteTeamId;
          };

          let newUserTeam : T.UserFantasyTeam = {
            fantasyTeam = newTeam;
            history = List.nil<T.FantasyTeamSeason>();
          };

          fantasyTeams.put(principalId, newUserTeam);
          return #ok(());
        };
        case (?existingTeam) { return #ok(()) };
      };
    };

    public func updateFantasyTeam(principalId : Text, newPlayers : [DTOs.PlayerDTO], captainId : Nat16, bonusId : Nat8, bonusPlayerId : Nat16, bonusTeamId : Nat16, gameweek : Nat8, existingPlayers : [DTOs.PlayerDTO], transferWindowGameweek: T.GameweekNumber) : async Result.Result<(), T.Error> {

      let existingUserTeam = fantasyTeams.get(principalId);
      switch (existingUserTeam) {
        case (null) { return #ok(()) };
        case (?e) {
          let existingTeam = e.fantasyTeam;
          let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(newPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.value });

          if (not isTeamValid(newPlayers, bonusId, bonusPlayerId)) {
            return #err(#InvalidTeamError);
          };

          let playersAdded = Array.filter<DTOs.PlayerDTO>(
            newPlayers,
            func(player : DTOs.PlayerDTO) : Bool {
              let playerId = player.id;
              let isPlayerIdInExistingTeam = Array.find(
                existingTeam.playerIds,
                func(id : Nat16) : Bool {
                  return id == playerId;
                },
              );
              return Option.isNull(isPlayerIdInExistingTeam);
            },
          );

          if(existingTeam.transferWindowGameweek != gameweek and gameweek != 1 and Nat8.fromNat(Array.size(playersAdded)) > existingTeam.transfersAvailable){
            return #err(#InvalidTeamError);
          };

          let playersRemoved = Array.filter<Nat16>(
            existingTeam.playerIds,
            func(playerId : Nat16) : Bool {
              let isPlayerIdInPlayers = Array.find(
                newPlayers,
                func(player : DTOs.PlayerDTO) : Bool {
                  return player.id == playerId;
                },
              );
              return Option.isNull(isPlayerIdInPlayers);
            },
          );

          let spent = Array.foldLeft<DTOs.PlayerDTO, Nat>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.value);
          var sold : Nat = 0;
          for (i in Iter.range(0, Array.size(playersRemoved) -1)) {
            let newPlayer = await getPlayer(playersRemoved[i]);
            sold := sold + newPlayer.value;
          };

          let netSpendQMs : Int = spent - sold;

          if (netSpendQMs > existingTeam.bankBalance) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 1 and existingTeam.goalGetterGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 2 and existingTeam.passMasterGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 3 and existingTeam.noEntryGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 4 and existingTeam.teamBoostGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 5 and existingTeam.safeHandsGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 6 and existingTeam.captainFantasticGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 7 and existingTeam.braceBonusGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 8 and existingTeam.hatTrickHeroGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (
            bonusId > 0 and (
              existingTeam.goalGetterGameweek == gameweek or existingTeam.passMasterGameweek == gameweek or existingTeam.noEntryGameweek == gameweek or existingTeam.teamBoostGameweek == gameweek or existingTeam.safeHandsGameweek == gameweek or existingTeam.captainFantasticGameweek == gameweek or existingTeam.braceBonusGameweek == gameweek or existingTeam.hatTrickHeroGameweek == gameweek,
            ),
          ) {
            return #err(#InvalidTeamError);
          };

          var goalGetterGameweek = existingTeam.goalGetterGameweek;
          var goalGetterPlayerId = existingTeam.goalGetterPlayerId;
          var passMasterGameweek = existingTeam.passMasterGameweek;
          var passMasterPlayerId = existingTeam.passMasterPlayerId;
          var noEntryGameweek = existingTeam.noEntryGameweek;
          var noEntryPlayerId = existingTeam.noEntryPlayerId;
          var teamBoostGameweek = existingTeam.teamBoostGameweek;
          var teamBoostTeamId = existingTeam.teamBoostTeamId;
          var safeHandsGameweek = existingTeam.safeHandsGameweek;
          var captainFantasticGameweek = existingTeam.captainFantasticGameweek;

          var countrymenGameweek = existingTeam.countrymenGameweek;
          var countrymenCountryId = existingTeam.countrymenCountryId;
          var prospectsGameweek = existingTeam.prospectsGameweek;

          var braceBonusGameweek = existingTeam.braceBonusGameweek;
          var hatTrickHeroGameweek = existingTeam.hatTrickHeroGameweek;
          var newCaptainId = captainId;

          let sortedPlayers = sortPlayers(newPlayers);
          let allPlayerIds = Array.map<DTOs.PlayerDTO, Nat16>(sortedPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.id });

          if (newCaptainId == 0) {
            var highestValue = 0;
            for (i in Iter.range(0, Array.size(newPlayers) -1)) {
              if (newPlayers[i].value > highestValue) {
                highestValue := newPlayers[i].value;
                newCaptainId := newPlayers[i].id;
              };
            };
          };

          if (bonusId == 1 and bonusPlayerId > 0) {
            goalGetterGameweek := gameweek;
            goalGetterPlayerId := bonusPlayerId;
          };

          if (bonusId == 2 and bonusPlayerId > 0) {
            passMasterGameweek := gameweek;
            passMasterPlayerId := bonusPlayerId;
          };

          if (bonusId == 3 and bonusPlayerId > 0) {
            noEntryGameweek := gameweek;
            noEntryPlayerId := bonusPlayerId;
          };

          if (bonusId == 4 and bonusTeamId > 0) {
            teamBoostGameweek := gameweek;
            teamBoostTeamId := bonusTeamId;
          };

          if (bonusId == 5) {
            safeHandsGameweek := gameweek;
          };

          if (bonusId == 6) {
            captainFantasticGameweek := gameweek;
          };

          if (bonusId == 7) {
            braceBonusGameweek := gameweek;
          };

          if (bonusId == 8) {
            hatTrickHeroGameweek := gameweek;
          };

          let newBankBalance : Int = existingTeam.bankBalance - netSpendQMs;

          if (newBankBalance < 0) {
            return #err(#InvalidTeamError);
          };

          let natBankBalance : Nat = Nat16.toNat(Int16.toNat16(Int16.fromInt(newBankBalance)));


          //check if january transfer window played, only allow if
            //not already played 
            //it's for a week which is in january
            //if valid can skip the transfers available check
            //ensure that you set that it's been used


          //if not played do standard transfer checks


          var newTransfersAvailable : Nat8 = 3;

          if (gameweek != 1 and existingTeam.transferWindowGameweek != gameweek) {
            newTransfersAvailable := existingTeam.transfersAvailable - Nat8.fromNat(Array.size(playersAdded));
          };

          var captainFantasticPlayerId : T.PlayerId = 0;
          var safeHandsPlayerId : T.PlayerId = 0;

          if (captainFantasticGameweek == gameweek) {
            captainFantasticPlayerId := newCaptainId;
          };

          if (safeHandsGameweek == gameweek) {

            let goalKeeper = List.find<DTOs.PlayerDTO>(
              List.fromArray(sortedPlayers),
              func(player : DTOs.PlayerDTO) : Bool {
                return player.position == 0;
              },
            );

            switch (goalKeeper) {
              case (null) {};
              case (?gk) {
                safeHandsPlayerId := gk.id;
              };
            };
          };

          let updatedTeam : T.FantasyTeam = {
            principalId = principalId;
            bankBalance = natBankBalance;
            playerIds = allPlayerIds;
            transfersAvailable = newTransfersAvailable;
            transferWindowGameweek = transferWindowGameweek;
            captainId = newCaptainId;
            goalGetterGameweek = goalGetterGameweek;
            goalGetterPlayerId = goalGetterPlayerId;
            passMasterGameweek = passMasterGameweek;
            passMasterPlayerId = passMasterPlayerId;
            noEntryGameweek = noEntryGameweek;
            noEntryPlayerId = noEntryPlayerId;
            teamBoostGameweek = teamBoostGameweek;
            teamBoostTeamId = teamBoostTeamId;
            safeHandsGameweek = safeHandsGameweek;
            safeHandsPlayerId = safeHandsPlayerId;
            captainFantasticGameweek = captainFantasticGameweek;
            captainFantasticPlayerId = captainFantasticPlayerId;
            countrymenGameweek = countrymenGameweek;
            countrymenCountryId = countrymenCountryId;
            prospectsGameweek = prospectsGameweek;
            braceBonusGameweek = braceBonusGameweek;
            hatTrickHeroGameweek = hatTrickHeroGameweek;
            favouriteTeamId = existingTeam.favouriteTeamId;
            teamName = existingTeam.teamName;
          };

          let updatedUserTeam : T.UserFantasyTeam = {
            fantasyTeam = updatedTeam;
            history = e.history;
          };

          fantasyTeams.put(principalId, updatedUserTeam);
          return #ok(());
        };
      };
    };

    private func sortPlayers(players : [DTOs.PlayerDTO]) : [DTOs.PlayerDTO] {

      let sortedPlayers = Array.sort(
        players,
        func(a : DTOs.PlayerDTO, b : DTOs.PlayerDTO) : Order.Order {
          if (a.position < b.position) { return #less };
          if (a.position > b.position) { return #greater };
          if (a.value > b.value) { return #less };
          if (a.value < b.value) { return #greater };
          return #equal;
        },
      );
      return sortedPlayers;
    };

    public func isTeamValid(players : [DTOs.PlayerDTO], bonusId : Nat8, bonusPlayerId : Nat16) : Bool {
      let playerPositions = Array.map<DTOs.PlayerDTO, Nat8>(players, func(player : DTOs.PlayerDTO) : Nat8 { return player.position });

      let playerCount = playerPositions.size();
      if (playerCount != 11) {
        return false;
      };

      var teamPlayerCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
      var playerIdCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
      var goalkeeperCount = 0;
      var defenderCount = 0;
      var midfielderCount = 0;
      var forwardCount = 0;

      for (i in Iter.range(0, playerCount -1)) {
        let count = teamPlayerCounts.get(Nat16.toText(players[i].teamId));
        switch (count) {
          case (null) {
            teamPlayerCounts.put(Nat16.toText(players[i].teamId), 1);
          };
          case (?count) {
            teamPlayerCounts.put(Nat16.toText(players[i].teamId), count + 1);
          };
        };

        let playerIdCount = playerIdCounts.get(Nat16.toText(players[i].id));
        switch (playerIdCount) {
          case (null) { playerIdCounts.put(Nat16.toText(players[i].id), 1) };
          case (?count) {
            return false;
          };
        };

        if (players[i].position == 0) {
          goalkeeperCount += 1;
        };

        if (players[i].position == 1) {
          defenderCount += 1;
        };

        if (players[i].position == 2) {
          midfielderCount += 1;
        };

        if (players[i].position == 3) {
          forwardCount += 1;
        };

      };

      for ((key, value) in teamPlayerCounts.entries()) {
        if (value > 2) {
          return false;
        };
      };

      if (
        goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3,
      ) {
        return false;
      };

      if (bonusId == 3) {
        let bonusPlayer = List.find<DTOs.PlayerDTO>(
          List.fromArray(players),
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == bonusPlayerId;
          },
        );
        switch (bonusPlayer) {
          case (null) { return false };
          case (?player) {
            if (player.position != 1) { return false };
          };
        };
      };

      return true;
    };

    public func resetTransfers() : async () {

      for ((key, value) in fantasyTeams.entries()) {
        let userFantasyTeam = value.fantasyTeam;
        let updatedTeam : T.FantasyTeam = {
          principalId = userFantasyTeam.principalId;
          transfersAvailable = Nat8.fromNat(3);
          bankBalance = userFantasyTeam.bankBalance;
          playerIds = userFantasyTeam.playerIds;
          captainId = userFantasyTeam.captainId;
          goalGetterGameweek = userFantasyTeam.goalGetterGameweek;
          goalGetterPlayerId = userFantasyTeam.goalGetterPlayerId;
          passMasterGameweek = userFantasyTeam.passMasterGameweek;
          passMasterPlayerId = userFantasyTeam.passMasterPlayerId;
          noEntryGameweek = userFantasyTeam.noEntryGameweek;
          noEntryPlayerId = userFantasyTeam.noEntryPlayerId;
          teamBoostGameweek = userFantasyTeam.teamBoostGameweek;
          teamBoostTeamId = userFantasyTeam.teamBoostTeamId;
          safeHandsGameweek = userFantasyTeam.safeHandsGameweek;
          safeHandsPlayerId = userFantasyTeam.safeHandsPlayerId;
          captainFantasticGameweek = userFantasyTeam.captainFantasticGameweek;
          captainFantasticPlayerId = userFantasyTeam.captainFantasticPlayerId;
          countrymenGameweek = userFantasyTeam.countrymenGameweek;
          countrymenCountryId = userFantasyTeam.countrymenCountryId;
          prospectsGameweek = userFantasyTeam.prospectsGameweek;
          braceBonusGameweek = userFantasyTeam.braceBonusGameweek;
          hatTrickHeroGameweek = userFantasyTeam.hatTrickHeroGameweek;
          teamName = userFantasyTeam.teamName;
          favouriteTeamId = userFantasyTeam.favouriteTeamId;
          transferWindowGameweek = userFantasyTeam.transferWindowGameweek;
        };

        let updatedUserTeam : T.UserFantasyTeam = {
          fantasyTeam = updatedTeam;
          history = value.history;
        };

        fantasyTeams.put(key, updatedUserTeam);
      };
    };

    public func calculateFantasyTeamScores(seasonId : Nat16, gameweek : Nat8) : async () {
      let allPlayersList = await getPlayersMap(seasonId, gameweek);
      var allPlayers = HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO>(500, Utilities.eqNat16, Utilities.hashNat16);
      for ((key, value) in Iter.fromArray(allPlayersList)) {
        allPlayers.put(key, value);
      };

      for ((key, value) in fantasyTeams.entries()) {

        let currentSeason = List.find<T.FantasyTeamSeason>(
          value.history,
          func(teamSeason : T.FantasyTeamSeason) : Bool {
            return teamSeason.seasonId == seasonId;
          },
        );

        switch (currentSeason) {
          case (null) {};
          case (?foundSeason) {
            let currentSnapshot = List.find<T.FantasyTeamSnapshot>(
              foundSeason.gameweeks,
              func(snapshot : T.FantasyTeamSnapshot) : Bool {
                return snapshot.gameweek == gameweek;
              },
            );
            switch (currentSnapshot) {
              case (null) {};
              case (?foundSnapshot) {

                var totalTeamPoints : Int16 = 0;
                for (i in Iter.range(0, Array.size(foundSnapshot.playerIds) -1)) {
                  let playerId = foundSnapshot.playerIds[i];
                  let playerData = allPlayers.get(playerId);
                  switch (playerData) {
                    case (null) {};
                    case (?player) {

                      var totalScore : Int16 = player.points;

                      // Goal Getter
                      if (foundSnapshot.goalGetterGameweek == gameweek and foundSnapshot.goalGetterPlayerId == playerId) {
                        totalScore += calculateGoalPoints(player.position, player.goalsScored);
                      };

                      // Pass Master
                      if (foundSnapshot.passMasterGameweek == gameweek and foundSnapshot.passMasterPlayerId == playerId) {
                        totalScore += calculateAssistPoints(player.position, player.assists);
                      };

                      // No Entry
                      if (foundSnapshot.noEntryGameweek == gameweek and (player.position < 2) and player.goalsConceded == 0) {
                        totalScore := totalScore * 3;
                      };

                      // Team Boost
                      if (foundSnapshot.teamBoostGameweek == gameweek and player.teamId == foundSnapshot.teamBoostTeamId) {
                        totalScore := totalScore * 2;
                      };

                      // Safe Hands
                      if (foundSnapshot.safeHandsGameweek == gameweek and player.position == 0 and player.saves > 4) {
                        totalScore := totalScore * 3;
                      };

                      // Captain Fantastic
                      if (foundSnapshot.captainFantasticGameweek == gameweek and foundSnapshot.captainId == playerId and player.goalsScored > 0) {
                        totalScore := totalScore * 2;
                      };

                      // Countrymen
                      if (foundSnapshot.countrymenGameweek == gameweek and foundSnapshot.countrymenCountryId == player.nationality) {
                        totalScore := totalScore * 2;
                      };

                      // Prospects
                      if (foundSnapshot.prospectsGameweek == gameweek and Utilities.calculateAgeFromUnix(player.dateOfBirth) < 21) {
                        totalScore := totalScore * 2;
                      };

                      // Brace Bonus
                      if (foundSnapshot.braceBonusGameweek == gameweek and player.goalsScored >= 2) {
                        totalScore := totalScore * 2;
                      };

                      // Hat Trick Hero
                      if (foundSnapshot.hatTrickHeroGameweek == gameweek and player.goalsScored >= 3) {
                        totalScore := totalScore * 3;
                      };

                      // Handle captain bonus
                      if (playerId == foundSnapshot.captainId) {
                        totalScore := totalScore * 2;
                      };

                      totalTeamPoints += totalScore;
                    };
                  };
                };
                updateSnapshotPoints(key, seasonId, gameweek, totalTeamPoints);
              };
            }

          };
        };
      };
      calculateLeaderboards(seasonId, gameweek);
      calculateMonthlyLeaderboards(seasonId, gameweek);
    };

    private func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : Nat8, teamPoints : Int16) : () {
      let userFantasyTeam = fantasyTeams.get(principalId);

      switch (userFantasyTeam) {
        case (null) {};
        case (?ufTeam) {

          let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

          switch (ufTeam.history) {
            case (null) {};
            case (existingHistory) {
              for (season in List.toIter<T.FantasyTeamSeason>(existingHistory)) {
                if (season.seasonId == seasonId) {
                  let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);

                  for (snapshot in List.toIter<T.FantasyTeamSnapshot>(season.gameweeks)) {
                    if (snapshot.gameweek == gameweek) {

                      let updatedSnapshot : T.FantasyTeamSnapshot = {
                        principalId = snapshot.principalId;
                        gameweek = snapshot.gameweek;
                        transfersAvailable = snapshot.transfersAvailable;
                        bankBalance = snapshot.bankBalance;
                        playerIds = snapshot.playerIds;
                        captainId = snapshot.captainId;
                        goalGetterGameweek = snapshot.goalGetterGameweek;
                        goalGetterPlayerId = snapshot.goalGetterPlayerId;
                        passMasterGameweek = snapshot.passMasterGameweek;
                        passMasterPlayerId = snapshot.passMasterPlayerId;
                        noEntryGameweek = snapshot.noEntryGameweek;
                        noEntryPlayerId = snapshot.noEntryPlayerId;
                        teamBoostGameweek = snapshot.teamBoostGameweek;
                        teamBoostTeamId = snapshot.teamBoostTeamId;
                        safeHandsGameweek = snapshot.safeHandsGameweek;
                        safeHandsPlayerId = snapshot.safeHandsPlayerId;
                        captainFantasticGameweek = snapshot.captainFantasticGameweek;
                        captainFantasticPlayerId = snapshot.captainFantasticPlayerId;
                        countrymenGameweek = snapshot.countrymenGameweek;
                        countrymenCountryId = snapshot.countrymenCountryId;
                        prospectsGameweek = snapshot.prospectsGameweek;
                        braceBonusGameweek = snapshot.braceBonusGameweek;
                        hatTrickHeroGameweek = snapshot.hatTrickHeroGameweek;
                        favouriteTeamId = snapshot.favouriteTeamId;
                        teamName = snapshot.teamName;
                        points = teamPoints;
                        transferWindowGameweek = snapshot.transferWindowGameweek;
                      };

                      snapshotBuffer.add(updatedSnapshot);

                    } else { snapshotBuffer.add(snapshot) };
                  };

                  let gameweekSnapshots = Buffer.toArray<T.FantasyTeamSnapshot>(snapshotBuffer);

                  let totalSeasonPoints = Array.foldLeft<T.FantasyTeamSnapshot, Int16>(gameweekSnapshots, 0, func(sumSoFar, x) = sumSoFar + x.points);

                  let updatedSeason : T.FantasyTeamSeason = {
                    gameweeks = List.fromArray(gameweekSnapshots);
                    seasonId = season.seasonId;
                    totalPoints = totalSeasonPoints;
                  };

                  teamHistoryBuffer.add(updatedSeason);

                } else { teamHistoryBuffer.add(season) };
              };
            };
          };

          let updatedUserFantasyTeam : T.UserFantasyTeam = {
            fantasyTeam = ufTeam.fantasyTeam;
            history = List.fromArray(Buffer.toArray<T.FantasyTeamSeason>(teamHistoryBuffer));
          };
          fantasyTeams.put(principalId, updatedUserFantasyTeam);
        };
      };
    };

    private func calculateLeaderboards(seasonId : Nat16, gameweek : Nat8) : () {

      let seasonEntries = Array.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
        Iter.toArray(fantasyTeams.entries()),
        func(pair) {
          return createLeaderboardEntry(pair.0, pair.1.fantasyTeam.teamName, pair.1, totalPointsForSeason(pair.1, seasonId));
        }

      );

      let gameweekEntries = Array.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
        Iter.toArray(fantasyTeams.entries()),
        func(pair) {
          return createLeaderboardEntry(pair.0, pair.1.fantasyTeam.teamName, pair.1, totalPointsForGameweek(pair.1, seasonId, gameweek));
        },
      );

      let sortedGameweekEntries = List.reverse(mergeSort(List.fromArray(gameweekEntries)));
      let sortedSeasonEntries = List.reverse(mergeSort(List.fromArray(seasonEntries)));

      let positionedGameweekEntries = assignPositionText(sortedGameweekEntries);
      let positionedSeasonEntries = assignPositionText(sortedSeasonEntries);

      let existingSeasonLeaderboard = seasonLeaderboards.get(seasonId);

      let currentGameweekLeaderboard : T.Leaderboard = {
        seasonId = seasonId;
        gameweek = gameweek;
        entries = positionedGameweekEntries;
      };

      var updatedGameweekLeaderboards = List.fromArray<T.Leaderboard>([]);

      switch (existingSeasonLeaderboard) {
        case (null) {
          updatedGameweekLeaderboards := List.fromArray([currentGameweekLeaderboard]);
        };
        case (?foundLeaderboard) {
          var gameweekLeaderboardExists = false;
          updatedGameweekLeaderboards := List.map<T.Leaderboard, T.Leaderboard>(
            foundLeaderboard.gameweekLeaderboards,
            func(leaderboard : T.Leaderboard) : T.Leaderboard {
              if (leaderboard.gameweek == gameweek) {
                gameweekLeaderboardExists := true;
                return currentGameweekLeaderboard;
              } else { return leaderboard };
            },
          );

          if (not gameweekLeaderboardExists) {
            updatedGameweekLeaderboards := List.append(updatedGameweekLeaderboards, List.fromArray([currentGameweekLeaderboard]));
          };

        };
      };

      let updatedSeasonLeaderboard : T.SeasonLeaderboards = {
        seasonLeaderboard = {
          seasonId = seasonId;
          gameweek = gameweek;
          entries = positionedSeasonEntries;
        };
        gameweekLeaderboards = updatedGameweekLeaderboards;
      };

      seasonLeaderboards.put(seasonId, updatedSeasonLeaderboard);

    };

    private func calculateMonthlyLeaderboards(seasonId : Nat16, gameweek : Nat8) : () {

      var monthGameweeks : List.List<Nat8> = List.nil();
      var gameweekMonth : Nat8 = 0;

      func getLatestFixtureTime(fixtures : [T.Fixture]) : Int {
        return Array.foldLeft(
          fixtures,
          fixtures[0].kickOff,
          func(acc : Int, fixture : T.Fixture) : Int {
            if (fixture.kickOff > acc) {
              return fixture.kickOff;
            } else {
              return acc;
            };
          },
        );
      };

      switch (getGameweekFixtures) {
        case (null) {};
        case (?actualFunction) {
          let activeGameweekFixtures = actualFunction(seasonId, gameweek);
          if (activeGameweekFixtures.size() > 0) {
            gameweekMonth := Utilities.unixTimeToMonth(getLatestFixtureTime(activeGameweekFixtures));
            monthGameweeks := List.append(monthGameweeks, List.fromArray([gameweek]));

            var currentGameweek = gameweek;
            label gwLoop while (currentGameweek > 1) {
              currentGameweek -= 1;
              let currentFixtures = actualFunction(seasonId, currentGameweek);
              let currentMonth = Utilities.unixTimeToMonth(getLatestFixtureTime(currentFixtures));
              if (currentMonth == gameweekMonth) {
                monthGameweeks := List.append(monthGameweeks, List.fromArray([currentGameweek]));
              } else {
                break gwLoop;
              };
            };
          };

        };
      };

      let allUserProfiles = getProfiles();
      let profilesMap = HashMap.fromIter<Text, T.Profile>(allUserProfiles.vals(), allUserProfiles.size(), Text.equal, Text.hash);
      let clubGroup = groupByTeam(fantasyTeams, profilesMap);
      var updatedLeaderboards = List.nil<T.ClubLeaderboard>();

      for ((clubId, userTeams) : (T.TeamId, [(Text, T.UserFantasyTeam)]) in clubGroup.entries()) {

        let filteredTeams = List.filter<(Text, T.UserFantasyTeam)>(
          List.fromArray(userTeams),
          func(team : (Text, T.UserFantasyTeam)) : Bool {
            return team.1.fantasyTeam.favouriteTeamId != 0;
          },
        );

        let monthEntries = List.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
          filteredTeams,
          func(pair : (Text, T.UserFantasyTeam)) : T.LeaderboardEntry {
            return createLeaderboardEntry(pair.0, pair.1.fantasyTeam.teamName, pair.1, totalPointsForMonth(pair.1, seasonId, monthGameweeks));
          },
        );

        let sortedMonthEntries = List.reverse(mergeSort(monthEntries));
        let positionedGameweekEntries = assignPositionText(sortedMonthEntries);

        let clubMonthlyLeaderboard : T.ClubLeaderboard = {
          seasonId = seasonId;
          month = gameweekMonth;
          clubId = clubId;
          entries = positionedGameweekEntries;
        };

        updatedLeaderboards := List.append<T.ClubLeaderboard>(updatedLeaderboards, List.fromArray([clubMonthlyLeaderboard]));
      };

      var seasonMonthlyLeaderboards = List.nil<T.ClubLeaderboard>();

      switch (monthlyLeaderboards.get(seasonId)) {
        case (null) {};
        case (?value) { seasonMonthlyLeaderboards := value };
      };

      for (leaderboard in Iter.fromList(seasonMonthlyLeaderboards)) {
        if (not (leaderboard.month == gameweekMonth)) {
          updatedLeaderboards := List.append<T.ClubLeaderboard>(updatedLeaderboards, List.fromArray([leaderboard]));
        };
      };

      monthlyLeaderboards.put(seasonId, updatedLeaderboards);
    };

    private func createLeaderboardEntry(principalId : Text, username : Text, team : T.UserFantasyTeam, points : Int16) : T.LeaderboardEntry {
      return {
        position = 0;
        positionText = "";
        username = username;
        principalId = principalId;
        points = points;
      };
    };

    private func assignPositionText(sortedEntries : List.List<T.LeaderboardEntry>) : List.List<T.LeaderboardEntry> {
      var position = 1;
      var previousScore : ?Int16 = null;
      var currentPosition = 1;

      func updatePosition(entry : T.LeaderboardEntry) : T.LeaderboardEntry {
        if (previousScore == null) {
          previousScore := ?entry.points;
          let updatedEntry = {
            entry with position = position;
            positionText = Int.toText(position);
          };
          currentPosition += 1;
          return updatedEntry;
        } else if (previousScore == ?entry.points) {
          currentPosition += 1;
          return { entry with position = position; positionText = "-" };
        } else {
          position := currentPosition;
          previousScore := ?entry.points;
          let updatedEntry = {
            entry with position = position;
            positionText = Int.toText(position);
          };
          currentPosition += 1;
          return updatedEntry;
        };
      };

      return List.map(sortedEntries, updatePosition);
    };

    private func groupByTeam(fantasyTeams : HashMap.HashMap<Text, T.UserFantasyTeam>, allProfiles : HashMap.HashMap<Text, T.Profile>) : HashMap.HashMap<T.TeamId, [(Text, T.UserFantasyTeam)]> {
      let groupedTeams : HashMap.HashMap<T.TeamId, [(Text, T.UserFantasyTeam)]> = HashMap.HashMap<T.TeamId, [(Text, T.UserFantasyTeam)]>(10, Utilities.eqNat16, Utilities.hashNat16);

      for ((principalId, fantasyTeam) in fantasyTeams.entries()) {
        let profile = allProfiles.get(principalId);
        switch (profile) {
          case (null) {};
          case (?foundProfile) {
            let teamId = foundProfile.favouriteTeamId;
            switch (groupedTeams.get(teamId)) {
              case null {
                groupedTeams.put(teamId, [(principalId, fantasyTeam)]);
              };
              case (?existingEntries) {
                let updatedEntries = Buffer.fromArray<(Text, T.UserFantasyTeam)>(existingEntries);
                updatedEntries.add((principalId, fantasyTeam));
                groupedTeams.put(teamId, Buffer.toArray(updatedEntries));
              };
            };
          };
        };
      };

      return groupedTeams;
    };

    private func totalPointsForGameweek(team : T.UserFantasyTeam, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : Int16 {

      let season = List.find(
        team.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );
      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          let seasonGameweek = List.find(
            foundSeason.gameweeks,
            func(gw : T.FantasyTeamSnapshot) : Bool {
              return gw.gameweek == gameweek;
            },
          );
          switch (seasonGameweek) {
            case null { return 0 };
            case (?foundSeasonGameweek) {
              return foundSeasonGameweek.points;
            };
          };
        };
      };
    };

    private func totalPointsForSeason(team : T.UserFantasyTeam, seasonId : T.SeasonId) : Int16 {

      var totalPoints : Int16 = 0;

      let season = List.find(
        team.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );

      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          for (gameweek in Iter.fromList(foundSeason.gameweeks)) {
            totalPoints += gameweek.points;
          };
          return totalPoints;
        };
      };
    };

    private func totalPointsForMonth(team : T.UserFantasyTeam, seasonId : T.SeasonId, monthGameweeks : List.List<Nat8>) : Int16 {

      var totalPoints : Int16 = 0;

      let season = List.find(
        team.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );

      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          for (gameweek in Iter.fromList(foundSeason.gameweeks)) {
            if (List.some(monthGameweeks, func(mw : Nat8) : Bool { return mw == gameweek.gameweek })) {
              totalPoints += gameweek.points;
            };
          };
          return totalPoints;
        };
      };
    };

    public func snapshotGameweek(seasonId : Nat16, gameweek : T.GameweekNumber) : async () {
      for ((principalId, userFantasyTeam) in fantasyTeams.entries()) {
        let newSnapshot : T.FantasyTeamSnapshot = {
          principalId = userFantasyTeam.fantasyTeam.principalId;
          gameweek = gameweek;
          transfersAvailable = userFantasyTeam.fantasyTeam.transfersAvailable;
          bankBalance = userFantasyTeam.fantasyTeam.bankBalance;
          playerIds = userFantasyTeam.fantasyTeam.playerIds;
          captainId = userFantasyTeam.fantasyTeam.captainId;
          goalGetterGameweek = userFantasyTeam.fantasyTeam.goalGetterGameweek;
          goalGetterPlayerId = userFantasyTeam.fantasyTeam.goalGetterPlayerId;
          passMasterGameweek = userFantasyTeam.fantasyTeam.passMasterGameweek;
          passMasterPlayerId = userFantasyTeam.fantasyTeam.passMasterPlayerId;
          noEntryGameweek = userFantasyTeam.fantasyTeam.noEntryGameweek;
          noEntryPlayerId = userFantasyTeam.fantasyTeam.noEntryPlayerId;
          teamBoostGameweek = userFantasyTeam.fantasyTeam.teamBoostGameweek;
          teamBoostTeamId = userFantasyTeam.fantasyTeam.teamBoostTeamId;
          safeHandsGameweek = userFantasyTeam.fantasyTeam.safeHandsGameweek;
          safeHandsPlayerId = userFantasyTeam.fantasyTeam.safeHandsPlayerId;
          captainFantasticGameweek = userFantasyTeam.fantasyTeam.captainFantasticGameweek;
          captainFantasticPlayerId = userFantasyTeam.fantasyTeam.captainFantasticPlayerId;
          countrymenGameweek = userFantasyTeam.fantasyTeam.countrymenGameweek;
          countrymenCountryId = userFantasyTeam.fantasyTeam.countrymenCountryId;
          prospectsGameweek = userFantasyTeam.fantasyTeam.prospectsGameweek;
          braceBonusGameweek = userFantasyTeam.fantasyTeam.braceBonusGameweek;
          hatTrickHeroGameweek = userFantasyTeam.fantasyTeam.hatTrickHeroGameweek;
          teamName = userFantasyTeam.fantasyTeam.teamName;
          favouriteTeamId = userFantasyTeam.fantasyTeam.favouriteTeamId;
          points = 0;
          transferWindowGameweek = userFantasyTeam.fantasyTeam.transferWindowGameweek;
        };

        var seasonFound = false;

        var updatedSeasons = List.map<T.FantasyTeamSeason, T.FantasyTeamSeason>(
          userFantasyTeam.history,
          func(season : T.FantasyTeamSeason) : T.FantasyTeamSeason {
            if (season.seasonId == seasonId) {
              seasonFound := true;

              let otherSeasonGameweeks = List.filter<T.FantasyTeamSnapshot>(
                season.gameweeks,
                func(snapshot : T.FantasyTeamSnapshot) : Bool {
                  return snapshot.gameweek != gameweek;
                },
              );

              let updatedGameweeks = List.push(newSnapshot, otherSeasonGameweeks);

              return {
                seasonId = season.seasonId;
                totalPoints = season.totalPoints;
                gameweeks = updatedGameweeks;
              };
            };
            return season;
          },
        );

        if (not seasonFound) {
          let newSeason : T.FantasyTeamSeason = {
            seasonId = seasonId;
            totalPoints = 0;
            gameweeks = List.push(newSnapshot, List.nil());
          };

          updatedSeasons := List.push(newSeason, updatedSeasons);
        };

        let updatedUserTeam : T.UserFantasyTeam = {
          fantasyTeam = userFantasyTeam.fantasyTeam;
          history = updatedSeasons;
        };

        fantasyTeams.put(principalId, updatedUserTeam);
      };
    };

    public func getTotalManagers() : Nat {
      fantasyTeams.size();
    };

    public func getWeeklyLeaderboard(activeSeasonId : Nat16, activeGameweek : Nat8, limit : Nat, offset : Nat) : DTOs.PaginatedLeaderboard {
      switch (seasonLeaderboards.get(activeSeasonId)) {
        case (null) {
          return {
            seasonId = activeSeasonId;
            gameweek = activeGameweek;
            entries = [];
            totalEntries = 0;
          };
        };

        case (?seasonData) {
          let allGameweekLeaderboards = seasonData.gameweekLeaderboards;
          let matchingGameweekLeaderboard = List.find(
            allGameweekLeaderboards,
            func(leaderboard : T.Leaderboard) : Bool {
              return leaderboard.gameweek == activeGameweek;
            },
          );

          switch (matchingGameweekLeaderboard) {
            case (null) {
              return {
                seasonId = activeSeasonId;
                gameweek = activeGameweek;
                entries = [];
                totalEntries = 0;
              };
            };
            case (?foundLeaderboard) {
              let droppedEntries = List.drop<T.LeaderboardEntry>(foundLeaderboard.entries, offset);
              let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

              return {
                seasonId = activeSeasonId;
                gameweek = activeGameweek;
                entries = List.toArray(paginatedEntries);
                totalEntries = List.size<T.LeaderboardEntry>(foundLeaderboard.entries);
              };
            };
          };
        };
      };
    };

    public func getSeasonLeaderboard(activeSeasonId : Nat16, limit : Nat, offset : Nat) : DTOs.PaginatedLeaderboard {
      switch (seasonLeaderboards.get(activeSeasonId)) {
        case (null) {
          return {
            seasonId = activeSeasonId;
            gameweek = 0;
            entries = [];
            totalEntries = 0;
          };
        };

        case (?seasonData) {
          let allSeasonLeaderboardEntries = seasonData.seasonLeaderboard.entries;

          let droppedEntries = List.drop<T.LeaderboardEntry>(allSeasonLeaderboardEntries, offset);
          let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

          return {
            seasonId = activeSeasonId;
            gameweek = 0;
            entries = List.toArray(paginatedEntries);
            totalEntries = List.size<T.LeaderboardEntry>(allSeasonLeaderboardEntries);
          };
        };
      };
    };

    public func getClubLeaderboard(seasonId : T.SeasonId, month : Nat8, clubId : T.TeamId, limit : Nat, offset : Nat) : DTOs.PaginatedClubLeaderboard {

      let defaultLeaderboard = {
        seasonId = seasonId;
        month = month;
        clubId = clubId;
        entries = [];
        totalEntries = 0;
      };

      switch (monthlyLeaderboards.get(seasonId)) {
        case (null) { return defaultLeaderboard };
        case (?foundMonthlyLeaderboards) {

          let clubLeaderboard = List.find<T.ClubLeaderboard>(
            foundMonthlyLeaderboards,
            func(monthlyLeaderboard : T.ClubLeaderboard) : Bool {
              return monthlyLeaderboard.month == month and monthlyLeaderboard.clubId == clubId;
            },
          );

          switch (clubLeaderboard) {
            case (null) { return defaultLeaderboard };
            case (?foundClubLeaderboard) {
              let allClubLeaderboardEntries = foundClubLeaderboard.entries;

              let droppedEntries = List.drop<T.LeaderboardEntry>(allClubLeaderboardEntries, offset);
              let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

              return {
                seasonId = seasonId;
                month = month;
                clubId = clubId;
                entries = List.toArray(paginatedEntries);
                totalEntries = List.size<T.LeaderboardEntry>(allClubLeaderboardEntries);
              };

            };
          };

        };
      };
    };

    public func getClubLeaderboards(seasonId : T.SeasonId, month : Nat8, limit : Nat, offset : Nat) : [DTOs.PaginatedClubLeaderboard] {

      let defaultLeaderboard = {
        seasonId = seasonId;
        month = month;
        clubId = 0;
        entries = [];
        totalEntries = 0;
      };

      switch (monthlyLeaderboards.get(seasonId)) {
        case (null) { return [] };
        case (?foundMonthlyLeaderboards) {

          let monthlyLeaderboards = List.filter<T.ClubLeaderboard>(
            foundMonthlyLeaderboards,
            func(monthlyLeaderboard : T.ClubLeaderboard) : Bool {
              return monthlyLeaderboard.month == month;
            },
          );

          return List.toArray(
            List.map<T.ClubLeaderboard, DTOs.PaginatedClubLeaderboard>(
              monthlyLeaderboards,
              func(monthlyLeaderboard : T.ClubLeaderboard) : DTOs.PaginatedClubLeaderboard {
                return {
                  seasonId = monthlyLeaderboard.seasonId;
                  month = monthlyLeaderboard.month;
                  clubId = monthlyLeaderboard.clubId;
                  entries = List.toArray(monthlyLeaderboard.entries);
                  totalEntries = List.size(monthlyLeaderboard.entries);
                };
              },
            ),
          );
        };
      };
    };

    public func getFantasyTeamForGameweek(managerId : Text, seasonId : Nat16, gameweek : Nat8) : T.FantasyTeamSnapshot {
      let emptySnapshot : T.FantasyTeamSnapshot = {
        principalId = "";
        transfersAvailable = 0;
        bankBalance = 0;
        playerIds = [];
        captainId = 0;
        gameweek = 0;
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
        countrymenGameweek = 0;
        countrymenCountryId = 0;
        prospectsGameweek = 0;
        braceBonusGameweek = 0;
        hatTrickHeroGameweek = 0;
        points = 0;
        favouriteTeamId = 0;
        teamName = "";
        transferWindowGameweek = 0;
      };
      let fantasyTeam = fantasyTeams.get(managerId);
      switch (fantasyTeam) {
        case (null) { return emptySnapshot };
        case (?foundTeam) {

          let teamHistory = foundTeam.history;
          switch (teamHistory) {
            case (null) { return emptySnapshot };
            case (foundHistory) {
              let foundSeason = List.find<T.FantasyTeamSeason>(
                foundHistory,
                func(season : T.FantasyTeamSeason) : Bool {
                  return season.seasonId == seasonId;
                },
              );
              switch (foundSeason) {
                case (null) { return emptySnapshot };
                case (?fs) {
                  let foundGameweek = List.find<T.FantasyTeamSnapshot>(
                    fs.gameweeks,
                    func(gw : T.FantasyTeamSnapshot) : Bool {
                      return gw.gameweek == gameweek;
                    },
                  );
                  switch (foundGameweek) {
                    case (null) { return emptySnapshot };
                    case (?fgw) { return fgw };
                  };
                };
              };

            };

          };
        };
      };
    };

    func calculateGoalPoints(position : Nat8, goalsScored : Int16) : Int16 {
      switch (position) {
        case 0 { return 40 * goalsScored };
        case 1 { return 40 * goalsScored };
        case 2 { return 30 * goalsScored };
        case 3 { return 20 * goalsScored };
        case _ { return 0 };
      };
    };

    func calculateAssistPoints(position : Nat8, assists : Int16) : Int16 {
      switch (position) {
        case 0 { return 30 * assists };
        case 1 { return 30 * assists };
        case 2 { return 20 * assists };
        case 3 { return 20 * assists };
        case _ { return 0 };
      };
    };

    public func resetFantasyTeams() : async () {
      for ((principalId, userFantasyTeam) in fantasyTeams.entries()) {

        let clearTeam = clearFantasyTeam(principalId);

        let updatedUserTeam : T.UserFantasyTeam = {
          fantasyTeam = clearTeam;
          history = userFantasyTeam.history;
        };

        fantasyTeams.put(principalId, updatedUserTeam);
      };
    };

    public func updateDisplayName(principalName : Text, displayName : Text) : () {
      let existingTeam = fantasyTeams.get(principalName);
      switch (existingTeam) {
        case (null) {};
        case (?foundTeam) {
          if (foundTeam.fantasyTeam.teamName == displayName) {
            return;
          };

          let updatedFantasyTeam : T.FantasyTeam = {
            principalId = foundTeam.fantasyTeam.principalId;
            teamName = displayName;
            favouriteTeamId = foundTeam.fantasyTeam.favouriteTeamId;
            transfersAvailable = foundTeam.fantasyTeam.transfersAvailable;
            bankBalance = foundTeam.fantasyTeam.bankBalance;
            playerIds = foundTeam.fantasyTeam.playerIds;
            captainId = foundTeam.fantasyTeam.captainId;
            goalGetterGameweek = foundTeam.fantasyTeam.goalGetterGameweek;
            goalGetterPlayerId = foundTeam.fantasyTeam.goalGetterPlayerId;
            passMasterGameweek = foundTeam.fantasyTeam.passMasterGameweek;
            passMasterPlayerId = foundTeam.fantasyTeam.passMasterPlayerId;
            noEntryGameweek = foundTeam.fantasyTeam.noEntryGameweek;
            noEntryPlayerId = foundTeam.fantasyTeam.noEntryPlayerId;
            teamBoostGameweek = foundTeam.fantasyTeam.teamBoostGameweek;
            teamBoostTeamId = foundTeam.fantasyTeam.teamBoostTeamId;
            safeHandsGameweek = foundTeam.fantasyTeam.safeHandsGameweek;
            safeHandsPlayerId = foundTeam.fantasyTeam.safeHandsPlayerId;
            captainFantasticGameweek = foundTeam.fantasyTeam.captainFantasticGameweek;
            captainFantasticPlayerId = foundTeam.fantasyTeam.captainFantasticPlayerId;
            countrymenGameweek = foundTeam.fantasyTeam.countrymenGameweek;
            countrymenCountryId = foundTeam.fantasyTeam.countrymenCountryId;
            prospectsGameweek = foundTeam.fantasyTeam.prospectsGameweek;
            braceBonusGameweek = foundTeam.fantasyTeam.braceBonusGameweek;
            hatTrickHeroGameweek = foundTeam.fantasyTeam.hatTrickHeroGameweek;
            transferWindowGameweek = foundTeam.fantasyTeam.transferWindowGameweek;
          };

          let updatedUserFantasyTeam : T.UserFantasyTeam = {
            fantasyTeam = updatedFantasyTeam;
            history = foundTeam.history;
          };

          fantasyTeams.put(principalName, updatedUserFantasyTeam);
        };
      };
    };

    public func updateFavouriteTeam(principalName : Text, favouriteTeamId : Nat16) : () {
      let existingTeam = fantasyTeams.get(principalName);
      switch (existingTeam) {
        case (null) {};
        case (?foundTeam) {

          let updatedFantasyTeam : T.FantasyTeam = {
            principalId = foundTeam.fantasyTeam.principalId;
            teamName = foundTeam.fantasyTeam.teamName;
            favouriteTeamId = favouriteTeamId;
            transfersAvailable = foundTeam.fantasyTeam.transfersAvailable;
            bankBalance = foundTeam.fantasyTeam.bankBalance;
            playerIds = foundTeam.fantasyTeam.playerIds;
            captainId = foundTeam.fantasyTeam.captainId;
            goalGetterGameweek = foundTeam.fantasyTeam.goalGetterGameweek;
            goalGetterPlayerId = foundTeam.fantasyTeam.goalGetterPlayerId;
            passMasterGameweek = foundTeam.fantasyTeam.passMasterGameweek;
            passMasterPlayerId = foundTeam.fantasyTeam.passMasterPlayerId;
            noEntryGameweek = foundTeam.fantasyTeam.noEntryGameweek;
            noEntryPlayerId = foundTeam.fantasyTeam.noEntryPlayerId;
            teamBoostGameweek = foundTeam.fantasyTeam.teamBoostGameweek;
            teamBoostTeamId = foundTeam.fantasyTeam.teamBoostTeamId;
            safeHandsGameweek = foundTeam.fantasyTeam.safeHandsGameweek;
            safeHandsPlayerId = foundTeam.fantasyTeam.safeHandsPlayerId;
            captainFantasticGameweek = foundTeam.fantasyTeam.captainFantasticGameweek;
            captainFantasticPlayerId = foundTeam.fantasyTeam.captainFantasticPlayerId;
            countrymenGameweek = foundTeam.fantasyTeam.countrymenGameweek;
            countrymenCountryId = foundTeam.fantasyTeam.countrymenCountryId;
            prospectsGameweek = foundTeam.fantasyTeam.prospectsGameweek;
            braceBonusGameweek = foundTeam.fantasyTeam.braceBonusGameweek;
            hatTrickHeroGameweek = foundTeam.fantasyTeam.hatTrickHeroGameweek;
            transferWindowGameweek = foundTeam.fantasyTeam.transferWindowGameweek;
          };

          let updatedUserFantasyTeam : T.UserFantasyTeam = {
            fantasyTeam = updatedFantasyTeam;
            history = foundTeam.history;
          };

          fantasyTeams.put(principalName, updatedUserFantasyTeam);
        };
      };
    };

    private func clearFantasyTeam(principalId : Text) : T.FantasyTeam {
      return {
        principalId = principalId;
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
        countrymenGameweek = 0;
        countrymenCountryId = 0;
        prospectsGameweek = 0;
        braceBonusGameweek = 0;
        hatTrickHeroGameweek = 0;
        teamName = "";
        favouriteTeamId = 0;
        transferWindowGameweek = 0;
      };
    };

    private func compare(entry1 : T.LeaderboardEntry, entry2 : T.LeaderboardEntry) : Bool {
      return entry1.points <= entry2.points;
    };

    func mergeSort(entries : List.List<T.LeaderboardEntry>) : List.List<T.LeaderboardEntry> {
      let len = List.size(entries);
      if (len <= 1) {
        return entries;
      } else {
        let (firstHalf, secondHalf) = List.split(len / 2, entries);
        return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
      };
    };

    public func getWeeklyLeaderboardEntry(managerId : Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : ?T.LeaderboardEntry {

      for ((seasonId, seasonLeaderboards) in seasonLeaderboards.entries()) {
        if (seasonId == seasonId) {
          let weeklyLeaderboard = List.find<T.Leaderboard>(
            seasonLeaderboards.gameweekLeaderboards,
            func(gameweekLeaderboard : T.Leaderboard) : Bool {
              return gameweekLeaderboard.gameweek == gameweek;
            },
          );
          switch (weeklyLeaderboard) {
            case (null) {};
            case (?foundWeeklyLeaderboard) {

              return List.find<T.LeaderboardEntry>(
                foundWeeklyLeaderboard.entries,
                func(entry : T.LeaderboardEntry) : Bool {
                  return entry.principalId == managerId;
                },
              );
            };
          };
        };
      };

      return null;
    };

    public func getMonthlyLeaderboardEntry(managerId : Text, seasonId : T.SeasonId, clubId : T.TeamId) : ?T.LeaderboardEntry {

      for ((seasonId, clubLeaderboards) in monthlyLeaderboards.entries()) {
        if (seasonId == seasonId) {

          let clubLeaderboard = List.find<T.ClubLeaderboard>(
            clubLeaderboards,
            func(leaderboard : T.ClubLeaderboard) : Bool {
              return leaderboard.clubId == clubId;
            },
          );

          switch (clubLeaderboard) {
            case (null) {};
            case (?foundClubLeaderboard) {
              return List.find<T.LeaderboardEntry>(
                foundClubLeaderboard.entries,
                func(entry : T.LeaderboardEntry) : Bool {
                  return entry.principalId == managerId;
                },
              );
            };
          };
        };
      };

      return null;
    };

    public func getSeasonLeaderboardEntry(managerId : Text, seasonId : T.SeasonId) : ?T.LeaderboardEntry {

      for ((seasonId, seasonLeaderboards) in seasonLeaderboards.entries()) {
        if (seasonId == seasonId) {
          return List.find<T.LeaderboardEntry>(
            seasonLeaderboards.seasonLeaderboard.entries,
            func(entry : T.LeaderboardEntry) : Bool {
              return entry.principalId == managerId;
            },
          );
        };
      };

      return null;
    };

    public func recalculateLeaderboards() : async () {
      calculateLeaderboards(1, 1);
      calculateMonthlyLeaderboards(1, 1);
      calculateLeaderboards(1, 2);
      calculateMonthlyLeaderboards(1, 2);
      calculateLeaderboards(1, 3);
      calculateMonthlyLeaderboards(1, 3);
      calculateLeaderboards(1, 4);
      calculateMonthlyLeaderboards(1, 4);
      calculateLeaderboards(1, 5);
      calculateMonthlyLeaderboards(1, 5);
      calculateLeaderboards(1, 6);
      calculateMonthlyLeaderboards(1, 6);
      calculateLeaderboards(1, 7);
      calculateMonthlyLeaderboards(1, 7);
      calculateLeaderboards(1, 8);
      calculateMonthlyLeaderboards(1, 8);
      calculateLeaderboards(1, 9);
      calculateMonthlyLeaderboards(1, 9);
    };

    public func getTeamValueInfo() : async [Text] {
      let allPlayers = await getPlayers();
      let teamDetailsBuffer = Buffer.fromArray<Text>([]);
      for (fantasyTeam in fantasyTeams.entries()) {

        let currentTeam : T.UserFantasyTeam = fantasyTeam.1;
        var allTeamPlayers : [DTOs.PlayerDTO] = [];
        let allTeamPlayersBuffer = Buffer.fromArray<DTOs.PlayerDTO>([]);
        for (playerId in Iter.fromArray(currentTeam.fantasyTeam.playerIds)) {
          let player = Array.find<DTOs.PlayerDTO>(
            allPlayers,
            func(player : DTOs.PlayerDTO) : Bool {
              return player.id == playerId;
            },
          );
          switch (player) {
            case (null) {};
            case (?foundPlayer) {
              allTeamPlayersBuffer.add(foundPlayer);
            };
          };
        };

        allTeamPlayers := Buffer.toArray(allTeamPlayersBuffer);
        let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(allTeamPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.value });
        let totalTeamValue = Array.foldLeft<Nat, Nat>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

        teamDetailsBuffer.add(currentTeam.fantasyTeam.principalId # " - " # Nat.toText(totalTeamValue));
      };
      return Buffer.toArray(teamDetailsBuffer);
    };

    public func updateTeamValueInfo() : async () {
      let updatedFantasyTeams : HashMap.HashMap<Text, T.UserFantasyTeam> = HashMap.HashMap<Text, T.UserFantasyTeam>(100, Text.equal, Text.hash);
      let allPlayers = await getPlayers();
      for (fantasyTeam in fantasyTeams.entries()) {

        let currentTeam : T.UserFantasyTeam = fantasyTeam.1;
        var allTeamPlayers : [DTOs.PlayerDTO] = [];
        let allTeamPlayersBuffer = Buffer.fromArray<DTOs.PlayerDTO>([]);
        for (playerId in Iter.fromArray(currentTeam.fantasyTeam.playerIds)) {
          let player = Array.find<DTOs.PlayerDTO>(
            allPlayers,
            func(player : DTOs.PlayerDTO) : Bool {
              return player.id == playerId;
            },
          );
          switch (player) {
            case (null) {};
            case (?foundPlayer) {
              allTeamPlayersBuffer.add(foundPlayer);
            };
          };
        };

        allTeamPlayers := Buffer.toArray(allTeamPlayersBuffer);
        let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(allTeamPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.value });
        let totalTeamValue = Array.foldLeft<Nat, Nat>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

        let ut : T.FantasyTeam = {
          principalId = currentTeam.fantasyTeam.principalId;
          favouriteTeamId = currentTeam.fantasyTeam.favouriteTeamId;
          teamName = currentTeam.fantasyTeam.teamName;
          transfersAvailable = currentTeam.fantasyTeam.transfersAvailable;
          bankBalance = Nat.sub(1200, totalTeamValue);
          playerIds = currentTeam.fantasyTeam.playerIds;
          captainId = currentTeam.fantasyTeam.captainId;
          goalGetterGameweek = currentTeam.fantasyTeam.goalGetterGameweek;
          goalGetterPlayerId = currentTeam.fantasyTeam.goalGetterPlayerId;
          passMasterGameweek = currentTeam.fantasyTeam.passMasterGameweek;
          passMasterPlayerId = currentTeam.fantasyTeam.passMasterPlayerId;
          noEntryGameweek = currentTeam.fantasyTeam.noEntryGameweek;
          noEntryPlayerId = currentTeam.fantasyTeam.noEntryPlayerId;
          teamBoostGameweek = currentTeam.fantasyTeam.teamBoostGameweek;
          teamBoostTeamId = currentTeam.fantasyTeam.teamBoostTeamId;
          safeHandsGameweek = currentTeam.fantasyTeam.safeHandsGameweek;
          safeHandsPlayerId = currentTeam.fantasyTeam.safeHandsPlayerId;
          captainFantasticGameweek = currentTeam.fantasyTeam.captainFantasticGameweek;
          captainFantasticPlayerId = currentTeam.fantasyTeam.captainFantasticPlayerId;
          countrymenGameweek = currentTeam.fantasyTeam.countrymenGameweek;
          countrymenCountryId = currentTeam.fantasyTeam.countrymenCountryId;
          prospectsGameweek = currentTeam.fantasyTeam.prospectsGameweek;
          braceBonusGameweek = currentTeam.fantasyTeam.braceBonusGameweek;
          hatTrickHeroGameweek = currentTeam.fantasyTeam.hatTrickHeroGameweek;
          transferWindowGameweek = currentTeam.fantasyTeam.transferWindowGameweek;
        };

        let updatedFantasyteam : T.UserFantasyTeam = {
          fantasyTeam = ut;
          history = currentTeam.history;
        };
        updatedFantasyTeams.put(fantasyTeam.0, updatedFantasyteam);

      };
      fantasyTeams := updatedFantasyTeams;
    };
  };

};
