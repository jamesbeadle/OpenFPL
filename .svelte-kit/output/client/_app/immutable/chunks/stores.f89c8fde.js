import { d as e } from "./singletons.fe993027.js";
const r = () => {
    const s = e;
    return {
      page: { subscribe: s.page.subscribe },
      navigating: { subscribe: s.navigating.subscribe },
      updated: s.updated,
    };
  },
  b = {
    subscribe(s) {
      return r().page.subscribe(s);
    },
  };
export { b as p };
