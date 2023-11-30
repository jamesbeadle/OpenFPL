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
  List_3.fill(IDL.Opt(IDL.Tuple(PlayerEventData, List_3)));
  const GameweekNumber = IDL.Nat8;
  const Fixture = IDL.Record({
    'id' : IDL.Nat32,
    'status' : IDL.Nat8,
    'awayTeamId' : TeamId,
    'highestScoringPlayerId' : IDL.Nat16,
    'homeTeamId' : TeamId,
    'seasonId' : SeasonId,
    'events' : List_3,
    'kickOff' : IDL.Int,
    'homeGoals' : IDL.Nat8,
    'gameweek' : GameweekNumber,
    'awayGoals' : IDL.Nat8,
  });
  const PlayerDTO = IDL.Record({
    'id' : IDL.Nat16,
    'value' : IDL.Nat,
    'dateOfBirth' : IDL.Int,
    'nationality' : IDL.Text,
    'shirtNumber' : IDL.Nat8,
    'totalPoints' : IDL.Int16,
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
    'events' : List_3,
    'teamId' : IDL.Nat16,
    'position' : IDL.Nat8,
    'points' : IDL.Int16,
  });
  const DataCache = IDL.Record({ 'hash' : IDL.Text, 'category' : IDL.Text });
  const PlayerId = IDL.Nat16;
  const PlayerGameweek = IDL.Record({
    'events' : List_3,
    'number' : IDL.Nat8,
    'points' : IDL.Int16,
  });
  List_2.fill(IDL.Opt(IDL.Tuple(PlayerGameweek, List_2)));
  const PlayerSeason = IDL.Record({ 'id' : IDL.Nat16, 'gameweeks' : List_2 });
  List_1.fill(IDL.Opt(IDL.Tuple(PlayerSeason, List_1)));
  const InjuryHistory = IDL.Record({
    'description' : IDL.Text,
    'injuryStartDate' : IDL.Int,
    'expectedEndDate' : IDL.Int,
  });
  List.fill(IDL.Opt(IDL.Tuple(InjuryHistory, List)));
  const TransferHistory = IDL.Record({
    'transferDate' : IDL.Int,
    'loanEndDate' : IDL.Int,
    'toTeam' : TeamId,
    'transferSeason' : SeasonId,
    'fromTeam' : TeamId,
    'transferGameweek' : GameweekNumber,
  });
  List_4.fill(IDL.Opt(IDL.Tuple(TransferHistory, List_4)));
  const ValueHistory = IDL.Record({
    'oldValue' : IDL.Nat,
    'newValue' : IDL.Nat,
    'seasonId' : IDL.Nat16,
    'gameweek' : IDL.Nat8,
  });
  List_5.fill(IDL.Opt(IDL.Tuple(ValueHistory, List_5)));
  const Player = IDL.Record({
    'id' : PlayerId,
    'value' : IDL.Nat,
    'seasons' : List_1,
    'dateOfBirth' : IDL.Int,
    'injuryHistory' : List,
    'transferHistory' : List_4,
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
  return IDL.Service({
    'calculatePlayerScores' : IDL.Func(
        [IDL.Nat16, IDL.Nat8, Fixture],
        [Fixture],
        [],
      ),
    'createPlayer' : IDL.Func(
        [
          TeamId,
          IDL.Nat8,
          IDL.Text,
          IDL.Text,
          IDL.Nat8,
          IDL.Nat,
          IDL.Int,
          IDL.Text,
        ],
        [],
        [],
      ),
    'getActivePlayers' : IDL.Func([], [IDL.Vec(PlayerDTO)], ['query']),
    'getAllPlayers' : IDL.Func([], [IDL.Vec(PlayerDTO)], ['query']),
    'getAllPlayersMap' : IDL.Func(
        [IDL.Nat16, IDL.Nat8],
        [IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO))],
        ['query'],
      ),
    'getDataHashes' : IDL.Func([], [IDL.Vec(DataCache)], ['query']),
    'getPlayer' : IDL.Func([IDL.Nat16], [Player], ['query']),
    'getPlayerDetails' : IDL.Func(
        [IDL.Nat16, SeasonId],
        [PlayerDetailDTO],
        ['query'],
      ),
    'getPlayerDetailsForGameweek' : IDL.Func(
        [IDL.Nat16, IDL.Nat8],
        [IDL.Vec(PlayerPointsDTO)],
        ['query'],
      ),
    'getPlayersDetailsForGameweek' : IDL.Func(
        [IDL.Vec(PlayerId), IDL.Nat16, IDL.Nat8],
        [IDL.Vec(PlayerPointsDTO)],
        ['query'],
      ),
    'getRetiredPlayer' : IDL.Func([IDL.Text], [IDL.Vec(Player)], ['query']),
    'loanPlayer' : IDL.Func(
        [PlayerId, TeamId, IDL.Int, SeasonId, GameweekNumber],
        [],
        [],
      ),
    'recallPlayer' : IDL.Func([PlayerId], [], []),
    'retirePlayer' : IDL.Func([PlayerId, IDL.Int], [], []),
    'revaluePlayerDown' : IDL.Func(
        [PlayerId, SeasonId, GameweekNumber],
        [],
        ['oneway'],
      ),
    'revaluePlayerUp' : IDL.Func([PlayerId, SeasonId, GameweekNumber], [], []),
    'setDefaultHashes' : IDL.Func([], [], []),
    'setPlayerInjury' : IDL.Func([PlayerId, IDL.Text, IDL.Int], [], []),
    'transferPlayer' : IDL.Func(
        [PlayerId, TeamId, SeasonId, GameweekNumber],
        [],
        [],
      ),
    'unretirePlayer' : IDL.Func([PlayerId], [], []),
    'updateHashForCategory' : IDL.Func([IDL.Text], [], []),
    'updatePlayer' : IDL.Func(
        [PlayerId, IDL.Nat8, IDL.Text, IDL.Text, IDL.Nat8, IDL.Int, IDL.Text],
        [],
        [],
      ),
    'updatePlayerEventDataCache' : IDL.Func([], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
