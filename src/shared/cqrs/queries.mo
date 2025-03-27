import FootballTypes "mo:waterway-mops/FootballTypes";
import Base "mo:waterway-mops/BaseTypes";
import AppTypes "../types/app_types";
import DTOs "../dtos/dtos";
import Membership "../types/membership_types";

module Queries {

    public type GetFixturesDTO = {};

    public type FixturesDTO = {
        fixtures : [DTOs.FixtureDTO];
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

    public type GetWeeklyLeaderboardDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        limit : Nat;
        offset : Nat;
        searchTerm : Text;
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
        canisterId : Base.CanisterId;
        firstGameweek : Bool;
    };

    public type GetWeeklyRewardsLeaderboardDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type WeeklyRewardsLeaderboardDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
        entries : [AppTypes.RewardEntry];
    };

    public type GetCanistersDTO = {
        canisterType : AppTypes.CanisterType;
    };

    public type CanisterDTO = {
        canisterId : Base.CanisterId;
        cycles : Nat;
        computeAllocation : Nat;
        topups : [Base.CanisterTopup];
    };

    public type GetPlayerPointsDTO = {
        playerId : FootballTypes.ClubId;
        seasonId : FootballTypes.SeasonId;
    };

    public type GetAppStatusDTO = {};

    public type GetSnapshotPlayersDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type GetPlayersMapDTO = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
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

    public type GetPlayersMap = {
        seasonId : FootballTypes.SeasonId;
        gameweek : FootballTypes.GameweekNumber;
    };

    public type PlayerMap = (Nat16, DTOs.PlayerScoreDTO);

    public type GetPlayerDetailsDTO = {
        playerId : FootballTypes.ClubId;
        seasonId : FootballTypes.SeasonId;
    };

    public type IsUsernameValid = {
        username : Text;
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

    public type ICFCMembershipDTO = {
        membershipType : AppTypes.MembershipType;
        membershipClaims : [AppTypes.MembershipClaim];
        membershipExpiryTime : Int;
    };

    public type GetICFCProfile = {
        principalId : Base.PrincipalId;
    };


    public type ICFCProfile = {
        principalId : Base.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : Membership.MembershipType;
        membershipClaims : [Membership.MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        membershipExpiryTime : Int;
        favouriteLeagueId : ?FootballTypes.LeagueId;
        favouriteClubId : ?FootballTypes.ClubId;
        nationalityId : ?Base.CountryId;
    };

};
