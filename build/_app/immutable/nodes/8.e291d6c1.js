import {
  m as $,
  k as _,
  i as A,
  d as B,
  h as c,
  s as D,
  c as F,
  b as I,
  y as N,
  G as n,
  z as O,
  g as q,
  a as S,
  S as T,
  B as U,
  n as u,
  A as V,
  l as v,
  r as w,
  q as x,
  L as z,
} from "../chunks/index.a8c54947.js";
import { e as C } from "../chunks/Layout.0e76e124.js";
function L(d) {
  let t, a, e, l, s, f, i, g, b;
  return {
    c() {
      (t = _("div")),
        (a = _("p")),
        (e = x(
          "Proposals will appear here after the SNS decentralisation sale."
        )),
        (l = S()),
        (s = _("p")),
        (f = x(
          "For now the OpenFPL team will continue to add fixture data through "
        )),
        (i = _("a")),
        (g = x("this")),
        (b = x(" view.")),
        this.h();
    },
    l(h) {
      t = v(h, "DIV", { class: !0 });
      var m = $(t);
      a = v(m, "P", {});
      var o = $(a);
      (e = w(
        o,
        "Proposals will appear here after the SNS decentralisation sale."
      )),
        o.forEach(c),
        (l = F(m)),
        (s = v(m, "P", {}));
      var r = $(s);
      (f = w(
        r,
        "For now the OpenFPL team will continue to add fixture data through "
      )),
        (i = v(r, "A", { class: !0, href: !0 }));
      var p = $(i);
      (g = w(p, "this")),
        p.forEach(c),
        (b = w(r, " view.")),
        r.forEach(c),
        m.forEach(c),
        this.h();
    },
    h() {
      u(i, "class", "text-blue-500"),
        u(i, "href", "/fixture-validation"),
        u(t, "class", "p-4");
    },
    m(h, m) {
      I(h, t, m),
        n(t, a),
        n(a, e),
        n(t, l),
        n(t, s),
        n(s, f),
        n(s, i),
        n(i, g),
        n(s, b);
    },
    d(h) {
      h && c(t);
    },
  };
}
function G(d) {
  let t,
    a,
    e,
    l,
    s,
    f,
    i,
    g,
    b,
    h,
    m,
    o = d[0] === "proposals" && L();
  return {
    c() {
      (t = _("div")),
        (a = _("div")),
        (e = _("ul")),
        (l = _("li")),
        (s = _("button")),
        (f = x("Proposals")),
        (b = S()),
        o && o.c(),
        this.h();
    },
    l(r) {
      t = v(r, "DIV", { class: !0 });
      var p = $(t);
      a = v(p, "DIV", { class: !0 });
      var E = $(a);
      e = v(E, "UL", { class: !0 });
      var P = $(e);
      l = v(P, "LI", { class: !0 });
      var y = $(l);
      s = v(y, "BUTTON", { class: !0 });
      var k = $(s);
      (f = w(k, "Proposals")),
        k.forEach(c),
        y.forEach(c),
        P.forEach(c),
        (b = F(E)),
        o && o.l(E),
        E.forEach(c),
        p.forEach(c),
        this.h();
    },
    h() {
      u(
        s,
        "class",
        (i = `p-2 ${d[0] === "proposals" ? "text-white" : "text-gray-400"}`)
      ),
        u(
          l,
          "class",
          (g = `mr-4 text-xs md:text-base ${
            d[0] === "proposals" ? "active-tab" : ""
          }`)
        ),
        u(e, "class", "flex rounded-t-lg bg-light-gray px-4 pt-2"),
        u(a, "class", "bg-panel rounded-lg m-4"),
        u(t, "class", "m-4");
    },
    m(r, p) {
      I(r, t, p),
        n(t, a),
        n(a, e),
        n(e, l),
        n(l, s),
        n(s, f),
        n(a, b),
        o && o.m(a, null),
        h || ((m = z(s, "click", d[2])), (h = !0));
    },
    p(r, p) {
      p & 1 &&
        i !==
          (i = `p-2 ${
            r[0] === "proposals" ? "text-white" : "text-gray-400"
          }`) &&
        u(s, "class", i),
        p & 1 &&
          g !==
            (g = `mr-4 text-xs md:text-base ${
              r[0] === "proposals" ? "active-tab" : ""
            }`) &&
          u(l, "class", g),
        r[0] === "proposals"
          ? o || ((o = L()), o.c(), o.m(a, null))
          : o && (o.d(1), (o = null));
    },
    d(r) {
      r && c(t), o && o.d(), (h = !1), m();
    },
  };
}
function j(d) {
  let t, a;
  return (
    (t = new C({ props: { $$slots: { default: [G] }, $$scope: { ctx: d } } })),
    {
      c() {
        N(t.$$.fragment);
      },
      l(e) {
        O(t.$$.fragment, e);
      },
      m(e, l) {
        V(t, e, l), (a = !0);
      },
      p(e, [l]) {
        const s = {};
        l & 9 && (s.$$scope = { dirty: l, ctx: e }), t.$set(s);
      },
      i(e) {
        a || (q(t.$$.fragment, e), (a = !0));
      },
      o(e) {
        B(t.$$.fragment, e), (a = !1);
      },
      d(e) {
        U(t, e);
      },
    }
  );
}
function H(d, t, a) {
  let e = "proposals";
  function l(f) {
    a(0, (e = f));
  }
  return [e, l, () => l("details")];
}
class M extends T {
  constructor(t) {
    super(), A(this, t, H, j, D, {});
  }
}
export { M as component };
