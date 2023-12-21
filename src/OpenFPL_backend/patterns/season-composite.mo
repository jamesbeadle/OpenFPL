module {

  public class SeasonComposite() {
/*

    //PlayerComposite //implements composite allows changes to seasons and fixtures
    
*/


        /*
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
         let fixtureEvents = Buffer.toArray(allPlayerEventsBuffer);
      await seasonManager.fixtureConsensusReached(fixture.seasonId, fixture.gameweek, fixtureId, fixtureEvents);
      return #ok();


      //IN HERE IF THE GAMEWEEK IS COMPLETE CREATE THE CANISTER FOR THE NEXT GAMEWEEK LEADERBOARD
      //IN HERE IF THE MONTH IS COMPLETE CREATE THE CANISTERS FOR THE NEXT MONTHS CLUB LEADERBOARDS
      //IN HERE IF THE SEASON IS COMPLETE CRAETE THE CANISTER FOR THE NEXT SEASON LEADERBOARD


*/ 



      /* validate submit fixture data execute add initial fixture
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

      */

       /*
seasons := List.map<T.Season, T.Season>(
        seasons,
        func(currentSeason : T.Season) : T.Season {
          if (currentSeason.id == seasonId) {

            var seasonGameweeks = List.nil<T.Gameweek>();

            for (i in Iter.range(1, 38)) {
              let fixturesForCurrentGameweek = Array.filter<T.Fixture>(
                fixtures,
                func(fixture : T.Fixture) : Bool {
                  return Nat8.fromNat(i) == fixture.gameweek;
                },
              );

              let newGameweek : T.Gameweek = {
                id = i;
                number = Nat8.fromNat(i);
                canisterId = "";
                fixtures = List.fromArray(fixturesForCurrentGameweek);
              };

              seasonGameweeks := List.push(newGameweek, seasonGameweeks);
            };

            return {
              id = currentSeason.id;
              name = currentSeason.name;
              year = currentSeason.year;
              gameweeks = seasonGameweeks;
              postponedFixtures = currentSeason.postponedFixtures;
            };
          } else { return currentSeason };
        },
      );













      await seasonManager.addInitialFixtures(seasonId, seasonFixtures);
      */

      
  };
};
