import {
  a as i,
  c as x,
  f as o,
  g as m,
  h as p,
  i as u,
  S as h,
  s as _,
  y as v,
} from "../chunks/index.a21d6cee.js";
import { n as l, s as d } from "../chunks/scheduler.e108d1fd.js";
function C(f) {
  let t,
    r = "Welcome to SvelteKit",
    a,
    s,
    c =
      'Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation';
  return {
    c() {
      (t = m("h1")),
        (t.textContent = r),
        (a = _()),
        (s = m("p")),
        (s.innerHTML = c);
    },
    l(e) {
      (t = p(e, "H1", { "data-svelte-h": !0 })),
        v(t) !== "svelte-yyjjjs" && (t.textContent = r),
        (a = x(e)),
        (s = p(e, "P", { "data-svelte-h": !0 })),
        v(s) !== "svelte-jl9sbz" && (s.innerHTML = c);
    },
    m(e, n) {
      i(e, t, n), i(e, a, n), i(e, s, n);
    },
    p: l,
    i: l,
    o: l,
    d(e) {
      e && (o(t), o(a), o(s));
    },
  };
}
class H extends h {
  constructor(t) {
    super(), u(this, t, null, C, d, {});
  }
}
export { H as component };