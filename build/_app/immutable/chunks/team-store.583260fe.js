import { a as m, A as N, i as E, r as I } from "./Layout.3f9368f3.js";
import { w as y } from "./singletons.e655d5e5.js";
function A() {
  const { subscribe: r, set: l } = y(null);
  let n = N.createActor(E, "bboqb-jiaaa-aaaal-qb6ea-cai");
  async function i() {
    let t = "system_state",
      o = (await n.getDataHashes()).find((e) => e.category === t) ?? null;
    const s = localStorage.getItem(t);
    if (o?.hash != s) {
      let e = await n.getSystemState();
      localStorage.setItem("system_state_data", JSON.stringify(e, I)),
        localStorage.setItem(t, o?.hash ?? ""),
        l(e);
    } else {
      const e = localStorage.getItem("system_state_data");
      let _ = null;
      try {
        _ = JSON.parse(e || "{}");
      } catch {
        _ = null;
      }
      l(_);
    }
  }
  async function S() {
    let t;
    return (
      r((a) => {
        t = a;
      })(),
      t
    );
  }
  async function c(t) {
    try {
      const o = await (
        await N.createIdentityActor(m, "bboqb-jiaaa-aaaal-qb6ea-cai")
      ).updateSystemState(t);
      return i(), o;
    } catch (a) {
      throw (console.error("Error updating system state:", a), a);
    }
  }
  return { subscribe: r, sync: i, getSystemState: S, updateSystemState: c };
}
const R = A();
function T() {
  const { subscribe: r, set: l } = y([]),
    n = N.createActor(E, "bboqb-jiaaa-aaaal-qb6ea-cai");
  async function i() {
    const c = "teams",
      a = (await n.getDataHashes()).find((s) => s.category === c) ?? null,
      o = localStorage.getItem(c);
    if (a?.hash != o) {
      const s = await n.getTeams();
      localStorage.setItem("teams_data", JSON.stringify(s, I)),
        localStorage.setItem(c, a?.hash ?? ""),
        l(s);
    } else {
      const s = localStorage.getItem("teams_data");
      let e = [];
      try {
        e = JSON.parse(s || "[]");
      } catch {
        e = [];
      }
      l(e);
    }
  }
  async function S(c) {
    let t = [];
    return (
      r((a) => {
        t = a;
      })(),
      t.find((a) => a.id === c)
    );
  }
  return { subscribe: r, sync: i, getTeamById: S };
}
const b = T();
export { R as s, b as t };
