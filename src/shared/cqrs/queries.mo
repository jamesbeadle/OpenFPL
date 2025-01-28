
import FootballTypes "../types/football_types";
import Base "../types/base_types";
import AppTypes "../types/app_types";
import DTOs "../dtos/dtos";

module Queries {

    public type GetFixturesDTO = { };

    public type FixturesDTO = {
        fixtures: [DTOs.FixtureDTO]
    };

    public type GetManagerDTO = {
        principalId: Base.PrincipalId;
        month: Base.CalendarMonth;
        gameweek: FootballTypes.GameweekNumber;
    };

    public type GetManagerGameweekDTO = {
        gameweek: FootballTypes.GameweekNumber;
    };

    public type GetWeeklyLeaderboardDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        limit : Nat;
        offset : Nat;
        searchTerm : Text;
    };

    public type WeeklyLeaderboardDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        entries : [LeaderboardEntryDTO];
        totalEntries : Nat;
    };


    public type LeaderboardEntryDTO = {
        position : Int;
        positionText : Text;
        username : Text;
        principalId : Text;
        points : Int16;
    };

    public type GetTeamSelectionDTO = {};

    public type TeamSelectionDTO = {
        principalId : Text;
        username : Text;
        transfersAvailable : Nat8;
        monthlyBonusesAvailable : Nat8;
        bankQuarterMillions : Nat16;
        playerIds : [FootballTypes.ClubId];
        captainId : FootballTypes.ClubId;
        goalGetterGameweek : FootballTypes.GameweekNumber;
        goalGetterPlayerId : FootballTypes.ClubId;
        passMasterGameweek : FootballTypes.GameweekNumber;
        passMasterPlayerId : FootballTypes.ClubId;
        noEntryGameweek : FootballTypes.GameweekNumber;
        noEntryPlayerId : FootballTypes.ClubId;
        teamBoostGameweek : FootballTypes.GameweekNumber;
        teamBoostClubId : FootballTypes.ClubId;
        safeHandsGameweek : FootballTypes.GameweekNumber;
        safeHandsPlayerId : FootballTypes.ClubId;
        captainFantasticGameweek : FootballTypes.GameweekNumber;
        captainFantasticPlayerId : FootballTypes.ClubId;
        oneNationGameweek : FootballTypes.GameweekNumber;
        oneNationCountryId : Base.CountryId;
        prospectsGameweek : FootballTypes.GameweekNumber;
        braceBonusGameweek : FootballTypes.GameweekNumber;
        hatTrickHeroGameweek : FootballTypes.GameweekNumber;
        transferWindowGameweek : FootballTypes.GameweekNumber;
        canisterId: Base.CanisterId;
        firstGameweek: Bool;
    };

    public type GetWeeklyRewardsLeaderboardDTO = {
        seasonId: FootballTypes.SeasonId;
        gameweek: FootballTypes.GameweekNumber;
    };
    

    public type WeeklyRewardsLeaderboardDTO = {
        seasonId: FootballTypes.SeasonId;
        gameweek: FootballTypes.GameweekNumber;
        entries : [AppTypes.RewardEntry];
    };

    public type GetRewardsPoolDTO = {
        seasonId: FootballTypes.SeasonId;
    };

    public type RewardsPoolDTO = {

    };

    public type GetCanistersDTO = {
        canisterType: AppTypes.CanisterType;
    };

    public type CanisterDTO = {
        canisterId: Base.CanisterId;
        cycles: Nat;
        computeAllocation: Nat;
        topups: [Base.CanisterTopup];
    };

    public type GetPlayerDetailsDTO = {
        playerId : FootballTypes.ClubId;
        seasonId : FootballTypes.SeasonId;
    };

    public type PlayerDetailsDTO = {

    };

    public type GetAppStatusDTO = {};

    public type AppStatusDTO = {
        onHold : Bool;
        version: Text;
    };


};
