import { w as S } from "./index.8caf67b2.js";
import { A as I, i as N, r as l } from "./team-store.90511bc6.js";
import "./toast-store.58fa49f6.js";
function p() {
  const { subscribe: o, set: i } = S([]),
    m = I.createActor(N, "bboqb-jiaaa-aaaal-qb6ea-cai");
  async function r() {
    let a = "fixtures",
      e = (await m.getDataHashes()).find((n) => n.category === a) ?? null;
    const _ = localStorage.getItem(a);
    if (e?.hash != _) {
      let n = await m.getFixtures();
      localStorage.setItem("fixtures_data", JSON.stringify(n, l)),
        localStorage.setItem(a, e?.hash ?? ""),
        i(n);
    } else {
      const n = localStorage.getItem("fixtures_data");
      let s = [];
      try {
        s = JSON.parse(n || "[]");
      } catch {
        s = [];
      }
      i(s);
    }
  }
  async function t() {
    let a = [];
    await r(),
      await o((e) => {
        a = e;
      })();
    const c = new Date();
    return a.find((e) => new Date(Number(e.kickOff) / 1e6) > c);
  }
  return { subscribe: o, sync: r, getNextFixture: t };
}
const T = p();
export { T as f };
