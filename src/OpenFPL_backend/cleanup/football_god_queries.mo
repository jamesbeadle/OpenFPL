import FootballTypes "mo:waterway-mops/FootballTypes";
import Base "mo:waterway-mops/BaseTypes";
import AppTypes "../types/app_types";

module FootballQueries {



    public type GetSnapshotPlayers = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type SnapshotPlayers = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        players : [Player]

    };

    public type Player = {
        id : Nat16;
        clubId : FootballTypes.ClubId;
        position : FootballTypes.PlayerPosition;
        firstName : Text;
        lastName : Text;
        shirtNumber : Nat8;
        valueQuarterMillions : Nat16;
        dateOfBirth : Int;
        nationality : Base.CountryId;
        status : FootballTypes.PlayerStatus;
        leagueId : FootballTypes.LeagueId;
        parentLeagueId : FootballTypes.LeagueId;
        parentClubId : FootballTypes.ClubId;
        currentLoanEndDate : Int;
    };




    // TODO ALL SHOULD BE IN FOOTBALL GOD CQRS Library to avoid duplication
    public type GetFixtures = {};

    public type Fixtures = {
        fixtures : [Fixture];
    };

    public type Fixture = {

    };








    public type GetManagerDTO = {
        principalId : Base.PrincipalId;
        seasonId : FootballTypes.SeasonId;
        month : Base.CalendarMonth;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type GetManagerGameweekDTO = {
        principalId : Base.PrincipalId;
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type GetPlayerPointsDTO = {
        playerId : FootballTypes.ClubId;
        seasonId : FootballTypes.SeasonId;
    };

    public type GetPlayersMap = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type PlayersMap = {

    };

    public type GetWeeklyLeaderboardEntriesDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        offset : Nat;
        searchTerm : Text;
    };

    public type GetWeeklyRewardWinnersDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type PlayerMap = (Nat16, PlayerScore);

    public type PlayerScore = {

    };

    public type GetPlayerDetailsDTO = {
        playerId : FootballTypes.ClubId;
        seasonId : FootballTypes.SeasonId;
    };

    public type GetManagerByUsername = {
        username : Text;
    };

    public type GetWeeklyRewardsDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type WeeklyRewardsDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        rewards : [AppTypes.RewardEntry];
    };


};
