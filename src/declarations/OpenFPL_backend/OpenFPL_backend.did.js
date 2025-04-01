export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    DuplicateData: IDL.Null,
    InvalidProperty: IDL.Null,
    NotFound: IDL.Null,
    IncorrectSetup: IDL.Null,
    NotAuthorized: IDL.Null,
    MaxDataExceeded: IDL.Null,
    InvalidData: IDL.Null,
    SystemOnHold: IDL.Null,
    AlreadyExists: IDL.Null,
    CanisterCreateError: IDL.Null,
    InsufficientFunds: IDL.Null,
  });
  const Result_2 = IDL.Variant({ ok: IDL.Text, err: Error });
  const CanisterId = IDL.Text;
  const Result_1 = IDL.Variant({ ok: IDL.Vec(CanisterId), err: Error });
  const LeagueId = IDL.Nat16;
  const PlayerId = IDL.Nat16;
  const Result = IDL.Variant({ ok: IDL.Null, err: Error });
  const SeasonId = IDL.Nat16;
  return IDL.Service({
    getActiveLeaderboardCanisterId: IDL.Func([], [Result_2], []),
    getLeaderboardCanisterIds: IDL.Func([], [Result_1], []),
    getManagerCanisterIds: IDL.Func([], [Result_1], []),
    notifyAppsOfLoanExpired: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfPositionChange: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfRetirement: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfSeasonComplete: IDL.Func([LeagueId, SeasonId], [Result], []),
  });
};
export const init = ({ IDL }) => {
  return [];
};
