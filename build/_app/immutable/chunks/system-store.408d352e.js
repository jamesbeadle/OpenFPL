import { w as S } from "./index.8caf67b2.js";
import { A as l, i as I, r as N } from "./team-store.a9afdac8.js";
import "./toast-store.64ad2768.js";
function p() {
  const { subscribe: n, set: o } = S(null);
  let m = l.createActor(I, "bkyz2-fmaaa-aaaaa-qaaaq-cai");
  async function r() {
    let a = "system_state",
      t = (await m.getDataHashes()).find((e) => e.category === a) ?? null;
    const _ = localStorage.getItem(a);
    if (t?.hash != _) {
      let e = await m.getSystemState();
      localStorage.setItem("system_state_data", JSON.stringify(e, N)),
        localStorage.setItem(a, t?.hash ?? ""),
        o(e);
    } else {
      const e = localStorage.getItem("system_state_data");
      let s = null;
      try {
        s = JSON.parse(e || "{}");
      } catch {
        s = null;
      }
      o(s);
    }
  }
  async function c() {
    let a;
    return (
      n((i) => {
        a = i;
      })(),
      a
    );
  }
  return { subscribe: n, sync: r, getSystemState: c };
}
const A = p();
export { A as s };
