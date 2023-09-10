export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const List_1 = IDL.Rec();
  const List_2 = IDL.Rec();
  const List_3 = IDL.Rec();
  const List_4 = IDL.Rec();
  const List_5 = IDL.Rec();
  const TeamId = IDL.Nat16;
  const SeasonId = IDL.Nat16;
  const FixtureId = IDL.Nat32;
  const PlayerEventData = IDL.Record({
    'fixtureId' : FixtureId,
    'playerId' : IDL.Nat16,
    'eventStartMinute' : IDL.Nat8,
    'eventEndMinute' : IDL.Nat8,
    'teamId' : TeamId,
    'eventType' : IDL.Nat8,
  });
  List_4.fill(IDL.Opt(IDL.Tuple(PlayerEventData, List_4)));
  const GameweekNumber = IDL.Nat8;
  const Fixture = IDL.Record({
    'id' : IDL.Nat32,
    'status' : IDL.Nat8,
    'awayTeamId' : TeamId,
    'highestScoringPlayerId' : IDL.Nat16,
    'homeTeamId' : TeamId,
    'seasonId' : SeasonId,
    'events' : List_4,
    'kickOff' : IDL.Int,
    'homeGoals' : IDL.Nat8,
    'gameweek' : GameweekNumber,
    'awayGoals' : IDL.Nat8,
  });
  const CreatePlayerPayload = IDL.Record({
    'value' : IDL.Nat,
    'dateOfBirth' : IDL.Int,
    'nationality' : IDL.Text,
    'shirtNumber' : IDL.Nat8,
    'teamId' : TeamId,
    'position' : IDL.Nat8,
    'lastName' : IDL.Text,
    'firstName' : IDL.Text,
  });
  const PlayerDTO = IDL.Record({
    'id' : IDL.Nat16,
    'value' : IDL.Nat,
    'dateOfBirth' : IDL.Int,
    'nationality' : IDL.Text,
    'shirtNumber' : IDL.Nat8,
    'totalPoints' : IDL.Nat16,
    'teamId' : IDL.Nat16,
    'position' : IDL.Nat8,
    'lastName' : IDL.Text,
    'firstName' : IDL.Text,
  });
  const PlayerScoreDTO = IDL.Record({
    'id' : IDL.Nat16,
    'assists' : IDL.Int16,
    'goalsScored' : IDL.Int16,
    'saves' : IDL.Int16,
    'goalsConceded' : IDL.Int16,
    'events' : List_4,
    'teamId' : IDL.Nat16,
    'position' : IDL.Nat8,
    'points' : IDL.Int16,
  });
  const PlayerId = IDL.Nat16;
  const PlayerGameweek = IDL.Record({
    'events' : List_4,
    'number' : IDL.Nat8,
    'points' : IDL.Int16,
  });
  List_3.fill(IDL.Opt(IDL.Tuple(PlayerGameweek, List_3)));
  const PlayerSeason = IDL.Record({ 'id' : IDL.Nat16, 'gameweeks' : List_3 });
  List_2.fill(IDL.Opt(IDL.Tuple(PlayerSeason, List_2)));
  const InjuryHistory = IDL.Record({
    'description' : IDL.Text,
    'expectedEndDate' : IDL.Int,
  });
  List_1.fill(IDL.Opt(IDL.Tuple(InjuryHistory, List_1)));
  const ValueHistory = IDL.Record({
    'oldValue' : IDL.Float64,
    'newValue' : IDL.Float64,
    'seasonId' : IDL.Nat16,
    'gameweek' : IDL.Nat8,
  });
  List_5.fill(IDL.Opt(IDL.Tuple(ValueHistory, List_5)));
  const Player = IDL.Record({
    'id' : PlayerId,
    'value' : IDL.Nat,
    'seasons' : List_2,
    'dateOfBirth' : IDL.Int,
    'injuryHistory' : List_1,
    'isInjured' : IDL.Bool,
    'nationality' : IDL.Text,
    'retirementDate' : IDL.Int,
    'valueHistory' : List_5,
    'shirtNumber' : IDL.Nat8,
    'teamId' : TeamId,
    'position' : IDL.Nat8,
    'parentTeamId' : IDL.Nat16,
    'lastName' : IDL.Text,
    'onLoan' : IDL.Bool,
    'firstName' : IDL.Text,
  });
  const DataCache = IDL.Record({ 'hash' : IDL.Text, 'category' : IDL.Text });
  const PlayerGameweekDTO = IDL.Record({
    'fixtureId' : FixtureId,
    'events' : IDL.Vec(PlayerEventData),
    'number' : IDL.Nat8,
    'points' : IDL.Int16,
  });
  const PlayerDetailDTO = IDL.Record({
    'id' : PlayerId,
    'value' : IDL.Nat,
    'dateOfBirth' : IDL.Int,
    'injuryHistory' : IDL.Vec(InjuryHistory),
    'seasonId' : SeasonId,
    'isInjured' : IDL.Bool,
    'gameweeks' : IDL.Vec(PlayerGameweekDTO),
    'nationality' : IDL.Text,
    'retirementDate' : IDL.Int,
    'valueHistory' : IDL.Vec(ValueHistory),
    'shirtNumber' : IDL.Nat8,
    'teamId' : TeamId,
    'position' : IDL.Nat8,
    'parentTeamId' : IDL.Nat16,
    'lastName' : IDL.Text,
    'onLoan' : IDL.Bool,
    'firstName' : IDL.Text,
  });
  const PlayerPointsDTO = IDL.Record({
    'id' : IDL.Nat16,
    'events' : IDL.Vec(PlayerEventData),
    'teamId' : IDL.Nat16,
    'position' : IDL.Nat8,
    'gameweek' : GameweekNumber,
    'points' : IDL.Int16,
  });
  const LoanPlayerPayload = IDL.Record({
    'loanTeamId' : TeamId,
    'loanEndDate' : IDL.Int,
    'playerId' : PlayerId,
  });
  const RecallPlayerPayload = IDL.Record({ 'playerId' : PlayerId });
  const RetirePlayerPayload = IDL.Record({
    'playerId' : PlayerId,
    'retirementDate' : IDL.Int,
  });
  const RevaluationDirection = IDL.Variant({
    'Decrease' : IDL.Null,
    'Increase' : IDL.Null,
  });
  const RevaluedPlayer = IDL.Record({
    'direction' : RevaluationDirection,
    'playerId' : PlayerId,
  });
  List.fill(IDL.Opt(IDL.Tuple(RevaluedPlayer, List)));
  const SetPlayerInjuryPayload = IDL.Record({
    'recovered' : IDL.Bool,
    'playerId' : PlayerId,
    'injuryDescription' : IDL.Text,
    'expectedEndDate' : IDL.Int,
  });
  const TransferPlayerPayload = IDL.Record({
    'playerId' : PlayerId,
    'newTeamId' : TeamId,
  });
  const UnretirePlayerPayload = IDL.Record({ 'playerId' : PlayerId });
  const UpdatePlayerPayload = IDL.Record({
    'dateOfBirth' : IDL.Int,
    'playerId' : PlayerId,
    'nationality' : IDL.Text,
    'shirtNumber' : IDL.Nat8,
    'teamId' : TeamId,
    'position' : IDL.Nat8,
    'lastName' : IDL.Text,
    'firstName' : IDL.Text,
  });
  return IDL.Service({
    'calculatePlayerScores' : IDL.Func(
        [IDL.Nat16, IDL.Nat8, Fixture],
        [Fixture],
        [],
      ),
    'createPlayer' : IDL.Func([CreatePlayerPayload], [], []),
    'getActivePlayers' : IDL.Func([], [IDL.Vec(PlayerDTO)], ['query']),
    'getAllPlayers' : IDL.Func([], [IDL.Vec(PlayerDTO)], ['query']),
    'getAllPlayersMap' : IDL.Func(
        [IDL.Nat16, IDL.Nat8],
        [IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO))],
        ['query'],
      ),
    'getPlayer' : IDL.Func([IDL.Nat16], [Player], ['query']),
    'getPlayerDataCache' : IDL.Func([], [DataCache], ['query']),
    'getPlayerDetails' : IDL.Func(
        [IDL.Nat16, SeasonId],
        [PlayerDetailDTO],
        ['query'],
      ),
    'getPlayersDetailsForGameweek' : IDL.Func(
        [IDL.Vec(PlayerId), IDL.Nat16, IDL.Nat8],
        [IDL.Vec(PlayerPointsDTO)],
        ['query'],
      ),
    'loanPlayer' : IDL.Func([LoanPlayerPayload], [], []),
    'recallPlayer' : IDL.Func([RecallPlayerPayload], [], []),
    'retirePlayer' : IDL.Func([RetirePlayerPayload], [], []),
    'revaluePlayers' : IDL.Func([IDL.Nat16, IDL.Nat8, List], [], []),
    'setPlayerInjury' : IDL.Func([SetPlayerInjuryPayload], [], []),
    'transferPlayer' : IDL.Func([TransferPlayerPayload], [], []),
    'unretirePlayer' : IDL.Func([UnretirePlayerPayload], [], []),
    'updatePlayer' : IDL.Func([UpdatePlayerPayload], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
