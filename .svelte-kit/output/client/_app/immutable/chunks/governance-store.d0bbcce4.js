import { w as c } from "./index.8caf67b2.js";
import { A as o } from "./team-store.90511bc6.js";
import { a as s } from "./toast-store.58fa49f6.js";
function t() {
  const { subscribe: i, set: m } = c([]);
  async function r() {
    const a = await (
      await o.createIdentityActor(s, "bboqb-jiaaa-aaaal-qb6ea-cai")
    ).getValidatableFixtures();
    return m(a), a;
  }
  async function _(n, a) {
    try {
      await (
        await o.createIdentityActor(s, "bboqb-jiaaa-aaaal-qb6ea-cai")
      ).submitFixtureData(n, a);
    } catch (e) {
      throw (console.error("Error submitting fixture data:", e), e);
    }
  }
  return { subscribe: i, getValidatableFixtures: r, submitFixtureData: _ };
}
const p = t();
export { p as g };
