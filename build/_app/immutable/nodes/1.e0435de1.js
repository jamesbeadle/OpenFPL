import {
  a as S,
  b as c,
  c as g,
  G as b,
  H as $,
  h as i,
  I as k,
  i as x,
  k as f,
  l as h,
  m as d,
  q as u,
  r as v,
  s as H,
  S as q,
  u as E,
} from "../chunks/index.c7b38e5e.js";
import { p as y } from "../chunks/stores.f0f38284.js";
function C(l) {
  let a,
    t = l[0].status + "",
    r,
    o,
    n,
    p = l[0].error?.message + "",
    m;
  return {
    c() {
      (a = f("h1")), (r = u(t)), (o = S()), (n = f("p")), (m = u(p));
    },
    l(e) {
      a = h(e, "H1", {});
      var s = d(a);
      (r = v(s, t)), s.forEach(i), (o = g(e)), (n = h(e, "P", {}));
      var _ = d(n);
      (m = v(_, p)), _.forEach(i);
    },
    m(e, s) {
      c(e, a, s), b(a, r), c(e, o, s), c(e, n, s), b(n, m);
    },
    p(e, [s]) {
      s & 1 && t !== (t = e[0].status + "") && E(r, t),
        s & 1 && p !== (p = e[0].error?.message + "") && E(m, p);
    },
    i: $,
    o: $,
    d(e) {
      e && i(a), e && i(o), e && i(n);
    },
  };
}
function G(l, a, t) {
  let r;
  return k(l, y, (o) => t(0, (r = o))), [r];
}
class j extends q {
  constructor(a) {
    super(), x(this, a, G, C, H, {});
  }
}
export { j as component };
