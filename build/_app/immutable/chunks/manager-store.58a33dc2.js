import { w as b } from "./index.8caf67b2.js";
import { s as D } from "./system-store.408d352e.js";
import { A as m, i as A } from "./team-store.a9afdac8.js";
import { a as r } from "./toast-store.64ad2768.js";
function T() {
  const { subscribe: _, set: g } = b(null);
  let i;
  D.subscribe((a) => {
    i = a;
  });
  const o = m.createActor(A, "bkyz2-fmaaa-aaaaa-qaaaq-cai");
  async function c(a, n, e) {
    try {
      return await o.getManager(a, n, e);
    } catch (s) {
      throw (console.error("Error fetching fantasy team for gameweek:", s), s);
    }
  }
  async function t() {
    try {
      const a = await o.getTotalManagers();
      return Number(a);
    } catch (a) {
      throw (console.error("Error fetching total managers:", a), a);
    }
  }
  async function I(a, n) {
    try {
      return await o.getFantasyTeamForGameweek(a, i?.activeSeason.id, n);
    } catch (e) {
      throw (console.error("Error fetching fantasy team for gameweek:", e), e);
    }
  }
  async function S() {
    try {
      return await (
        await m.createIdentityActor(r, "bkyz2-fmaaa-aaaaa-qaaaq-cai")
      ).getFantasyTeam();
    } catch (a) {
      throw (console.error("Error fetching fantasy team:", a), a);
    }
  }
  async function N(a, n) {
    try {
      let e = l(a, n),
        s = p(a, n),
        d = E(a, n);
      return await (
        await m.createIdentityActor(r, "bkyz2-fmaaa-aaaaa-qaaaq-cai")
      ).saveFantasyTeam(a.playerIds, a.captainId, e, s, d);
    } catch (e) {
      throw (console.error("Error saving fantasy team:", e), e);
    }
  }
  function l(a, n) {
    let e = 0;
    return (
      a.goalGetterGameweek === n && (e = 1),
      a.passMasterGameweek === n && (e = 2),
      a.noEntryGameweek === n && (e = 3),
      a.teamBoostGameweek === n && (e = 4),
      a.safeHandsGameweek === n && (e = 5),
      a.captainFantasticGameweek === n && (e = 6),
      a.hatTrickHeroGameweek === n && (e = 7),
      a.hatTrickHeroGameweek === n && (e = 8),
      e
    );
  }
  function p(a, n) {
    let e = 0;
    return (
      a.goalGetterGameweek === n && (e = a.goalGetterPlayerId),
      a.passMasterGameweek === n && (e = a.passMasterPlayerId),
      a.noEntryGameweek === n && (e = a.noEntryPlayerId),
      a.safeHandsGameweek === n && (e = a.safeHandsPlayerId),
      a.captainFantasticGameweek === n && (e = a.captainId),
      e
    );
  }
  function E(a, n) {
    let e = 0;
    return a.teamBoostGameweek === n && (e = a.teamBoostTeamId), e;
  }
  return {
    subscribe: _,
    getManager: c,
    getTotalManagers: t,
    getFantasyTeamForGameweek: I,
    getFantasyTeam: S,
    saveFantasyTeam: N,
  };
}
const L = T();
export { L as m };
