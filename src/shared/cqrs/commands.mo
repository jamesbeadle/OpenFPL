import FootballTypes "mo:waterway-mops/FootballTypes";
import Base "mo:waterway-mops/BaseTypes";
import AppTypes "../types/app_types";

module Commands {

  public type UpdateUsernameDTO = {
    username : Text;
  };

  public type UpdateFavouriteClubDTO = {
    favouriteClubId : FootballTypes.ClubId;
  };

  public type UpdateProfilePictureDTO = {
    profilePicture : Blob;
    extension : Text;
  };

  public type SaveTeamDTO = {
    teamName : ?Text;
    playerIds : [FootballTypes.PlayerId];
    captainId : FootballTypes.ClubId;
    transferWindowGameweek : ?FootballTypes.GameweekNumber;
  };

  public type SaveBonusDTO = {
    goalGetterGameweek : ?FootballTypes.GameweekNumber;
    goalGetterPlayerId : ?FootballTypes.ClubId;
    passMasterGameweek : ?FootballTypes.GameweekNumber;
    passMasterPlayerId : ?FootballTypes.ClubId;
    noEntryGameweek : ?FootballTypes.GameweekNumber;
    noEntryPlayerId : ?FootballTypes.ClubId;
    teamBoostGameweek : ?FootballTypes.GameweekNumber;
    teamBoostClubId : ?FootballTypes.ClubId;
    safeHandsGameweek : ?FootballTypes.GameweekNumber;
    safeHandsPlayerId : ?FootballTypes.ClubId;
    captainFantasticGameweek : ?FootballTypes.GameweekNumber;
    captainFantasticPlayerId : ?FootballTypes.ClubId;
    oneNationGameweek : ?FootballTypes.GameweekNumber;
    oneNationCountryId : ?Base.CountryId;
    prospectsGameweek : ?FootballTypes.GameweekNumber;
    braceBonusGameweek : ?FootballTypes.GameweekNumber;
    hatTrickHeroGameweek : ?FootballTypes.GameweekNumber;
  };

  public type LoanPlayerDTO = {
    playerId : FootballTypes.PlayerId;
    fromLeagueId : FootballTypes.LeagueId;
    fromClubId : FootballTypes.ClubId;
    toLeagueId : FootballTypes.LeagueId;
    toClubId : FootballTypes.ClubId;
  };

  public type RecallLoanDTO = {
    playerId : FootballTypes.PlayerId;
    recalledFromLeagueId : FootballTypes.LeagueId;
    recalledFromClubId : FootballTypes.ClubId;
    recalledToLeagueId : FootballTypes.LeagueId;
    recalledToClubId : FootballTypes.ClubId;
  };

  public type TransferPlayerDTO = {
    playerId : FootballTypes.ClubId;
    fromLeagueId : FootballTypes.LeagueId;
    fromClubId : FootballTypes.ClubId;
    toLeagueId : FootballTypes.LeagueId;
    toClubId : FootballTypes.ClubId;
    newShirtNumber : Nat8;
  };

  public type RetirePlayerDTO = {
    playerId : FootballTypes.ClubId;
    retirementDate : Int;
  };

  public type SetFreeAgentDTO = {
    playerId : FootballTypes.ClubId;
  };

  public type ChangePlayerPositionDTO = {
    playerId : FootballTypes.ClubId;
    newPosition : FootballTypes.PlayerPosition;
  };

  public type FinaliseFixtureDTO = {
    fixtureId : FootballTypes.FixtureId;
  };

  public type MoveFixtureDTO = {
    seasonId : FootballTypes.SeasonId;
    fixtureId : FootballTypes.FixtureId;
    updatedFixtureGameweek : FootballTypes.GameweekNumber;
    updatedFixtureDate : Int;
  };

  public type PostponeFixtureDTO = {
    seasonId : FootballTypes.SeasonId;
    fixtureId : FootballTypes.FixtureId;
  };

  public type RescheduleFixtureDTO = {
    fixtureId : FootballTypes.FixtureId;
    updatedFixtureGameweek : FootballTypes.GameweekNumber;
    updatedFixtureDate : Int;
  };

  public type UpdateAppStatusDTO = {
    onHold : Bool;
    version : Text;
  };

  public type CreateManagerDTO = {
    username : Text;
    favouriteClubId : ?FootballTypes.ClubId;
  };

  public type GetICFCMembership = {
    principalId : Base.PrincipalId;

  };

  public type NotifyAppofLink = {
    subAppUserPrincipalId : Base.PrincipalId;
    subApp : AppTypes.SubApp;
    icfcPrincipalId : Base.PrincipalId;
  };

  public type VerifyICFCProfile = {
    principalId : Base.PrincipalId;
  };

  public type VerifySubApp = {
    subAppUserPrincipalId : Base.PrincipalId;
    subApp : AppTypes.SubApp;
    icfcPrincipalId : Base.PrincipalId;
  };
};
