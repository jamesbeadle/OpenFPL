import { a as i, A as n, i as d } from "./Layout.3f9368f3.js";
import { w as P } from "./singletons.e655d5e5.js";
import { s as y } from "./team-store.583260fe.js";
function D() {
  const { subscribe: E, set: R } = P(null);
  let c;
  y.subscribe((a) => {
    c = a;
  });
  const o = n.createActor(d, "bboqb-jiaaa-aaaal-qb6ea-cai");
  async function I(a, r, t) {
    try {
      return await o.getManager(a, r, t);
    } catch (e) {
      throw (console.error("Error fetching manager for gameweek:", e), e);
    }
  }
  async function N() {
    try {
      const a = await o.getTotalManagers();
      return Number(a);
    } catch (a) {
      throw (console.error("Error fetching total managers:", a), a);
    }
  }
  async function _(a, r) {
    try {
      return await o.getFantasyTeamForGameweek(a, c?.activeSeason.id, r);
    } catch (t) {
      throw (console.error("Error fetching fantasy team for gameweek:", t), t);
    }
  }
  async function l() {
    try {
      return await (
        await n.createIdentityActor(i, "bboqb-jiaaa-aaaal-qb6ea-cai")
      ).getFantasyTeam();
    } catch (a) {
      throw (console.error("Error fetching fantasy team:", a), a);
    }
  }
  async function s(a, r) {
    try {
      let t = f(a, r),
        e = A(a, r),
        g = b(a, r);
      return await (
        await n.createIdentityActor(i, "bboqb-jiaaa-aaaal-qb6ea-cai")
      ).saveFantasyTeam(a.playerIds, a.captainId, t, e, g);
    } catch (t) {
      throw (console.error("Error saving fantasy team:", t), t);
    }
  }
  function f(a, r) {
    let t = 0;
    return (
      a.goalGetterGameweek === r && (t = 1),
      a.passMasterGameweek === r && (t = 2),
      a.noEntryGameweek === r && (t = 3),
      a.teamBoostGameweek === r && (t = 4),
      a.safeHandsGameweek === r && (t = 5),
      a.captainFantasticGameweek === r && (t = 6),
      a.hatTrickHeroGameweek === r && (t = 7),
      a.hatTrickHeroGameweek === r && (t = 8),
      t
    );
  }
  function A(a, r) {
    let t = 0;
    return (
      a.goalGetterGameweek === r && (t = a.goalGetterPlayerId),
      a.passMasterGameweek === r && (t = a.passMasterPlayerId),
      a.noEntryGameweek === r && (t = a.noEntryPlayerId),
      a.safeHandsGameweek === r && (t = a.safeHandsPlayerId),
      a.captainFantasticGameweek === r && (t = a.captainId),
      t
    );
  }
  function b(a, r) {
    let t = 0;
    return a.teamBoostGameweek === r && (t = a.teamBoostTeamId), t;
  }
  return {
    subscribe: E,
    getManager: I,
    getTotalManagers: N,
    getFantasyTeamForGameweek: _,
    getFantasyTeam: l,
    saveFantasyTeam: s,
  };
}
const h = D();
export { h as m };
