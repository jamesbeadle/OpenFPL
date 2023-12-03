import { B as Ge } from "../chunks/BadgeIcon.ac2d82f5.js";
import {
  a as Ee,
  c as Re,
  b as Ue,
  n as ct,
  L as ft,
  A as it,
  t as je,
  s as le,
  f as qe,
  e as ut,
} from "../chunks/Layout.0e76e124.js";
import {
  q as B,
  Q as Be,
  d as G,
  a as H,
  s as Ie,
  c as L,
  K as Le,
  L as Q,
  N as Se,
  o as Te,
  b as Z,
  J as at,
  k as b,
  e as be,
  h as c,
  m as g,
  f as ge,
  B as ie,
  r as j,
  S as ke,
  I as lt,
  A as ne,
  T as nt,
  z as oe,
  R as ot,
  n as p,
  H as pe,
  g as q,
  G as r,
  y as re,
  $ as rt,
  u as se,
  P as st,
  O as tt,
  l as v,
  v as ve,
  M as we,
  i as xe,
} from "../chunks/index.a8c54947.js";
import { w as dt } from "../chunks/singletons.fdfa7ed0.js";
function Ke(s, e, a) {
  const t = s.slice();
  return (t[17] = e[a][0]), (t[2] = e[a][1]), t;
}
function ze(s, e, a) {
  const t = s.slice();
  return (
    (t[20] = e[a].fixture), (t[21] = e[a].homeTeam), (t[22] = e[a].awayTeam), t
  );
}
function Je(s, e, a) {
  const t = s.slice();
  return (t[25] = e[a]), t;
}
function Qe(s) {
  let e,
    a,
    t = s[25] + "",
    l;
  return {
    c() {
      (e = b("option")), (a = B("Gameweek ")), (l = B(t)), this.h();
    },
    l(u) {
      e = v(u, "OPTION", {});
      var h = g(e);
      (a = j(h, "Gameweek ")), (l = j(h, t)), h.forEach(c), this.h();
    },
    h() {
      (e.__value = s[25]), (e.value = e.__value);
    },
    m(u, h) {
      Z(u, e, h), r(e, a), r(e, l);
    },
    p: pe,
    d(u) {
      u && c(e);
    },
  };
}
function We(s) {
  let e,
    a,
    t,
    l,
    u,
    h,
    x,
    y,
    _,
    i,
    T,
    f,
    n,
    d,
    D,
    C,
    M,
    V,
    E = Ue(Number(s[20].kickOff)) + "",
    w,
    P,
    k,
    A,
    m,
    $ = (s[21] ? s[21].friendlyName : "") + "",
    o,
    S,
    N,
    F,
    K = (s[22] ? s[22].friendlyName : "") + "",
    W,
    X,
    U,
    z,
    ee,
    te = (s[20].status === 0 ? "-" : s[20].homeGoals) + "",
    ae,
    ye,
    ce,
    ue = (s[20].status === 0 ? "-" : s[20].awayGoals) + "",
    fe,
    de,
    R;
  return (
    (h = new Ge({
      props: {
        primaryColour: s[21] ? s[21].primaryColourHex : "",
        secondaryColour: s[21] ? s[21].secondaryColourHex : "",
        thirdColour: s[21] ? s[21].thirdColourHex : "",
      },
    })),
    (d = new Ge({
      props: {
        primaryColour: s[22] ? s[22].primaryColourHex : "",
        secondaryColour: s[22] ? s[22].secondaryColourHex : "",
        thirdColour: s[22] ? s[22].thirdColourHex : "",
      },
    })),
    {
      c() {
        (e = b("div")),
          (a = b("div")),
          (t = b("div")),
          (l = b("div")),
          (u = b("a")),
          re(h.$$.fragment),
          (y = H()),
          (_ = b("span")),
          (i = B("v")),
          (T = H()),
          (f = b("div")),
          (n = b("a")),
          re(d.$$.fragment),
          (C = H()),
          (M = b("div")),
          (V = b("span")),
          (w = B(E)),
          (P = H()),
          (k = b("div")),
          (A = b("div")),
          (m = b("a")),
          (o = B($)),
          (N = H()),
          (F = b("a")),
          (W = B(K)),
          (U = H()),
          (z = b("div")),
          (ee = b("span")),
          (ae = B(te)),
          (ye = H()),
          (ce = b("span")),
          (fe = B(ue)),
          this.h();
      },
      l(I) {
        e = v(I, "DIV", { class: !0 });
        var O = g(e);
        a = v(O, "DIV", { class: !0 });
        var Y = g(a);
        t = v(Y, "DIV", { class: !0 });
        var J = g(t);
        l = v(J, "DIV", { class: !0 });
        var $e = g(l);
        u = v($e, "A", { href: !0 });
        var De = g(u);
        oe(h.$$.fragment, De),
          De.forEach(c),
          $e.forEach(c),
          (y = L(J)),
          (_ = v(J, "SPAN", { class: !0 }));
        var Ce = g(_);
        (i = j(Ce, "v")),
          Ce.forEach(c),
          (T = L(J)),
          (f = v(J, "DIV", { class: !0 }));
        var Ne = g(f);
        n = v(Ne, "A", { href: !0 });
        var Me = g(n);
        oe(d.$$.fragment, Me),
          Me.forEach(c),
          Ne.forEach(c),
          J.forEach(c),
          (C = L(Y)),
          (M = v(Y, "DIV", { class: !0 }));
        var Ae = g(M);
        V = v(Ae, "SPAN", { class: !0 });
        var Ve = g(V);
        (w = j(Ve, E)),
          Ve.forEach(c),
          Ae.forEach(c),
          Y.forEach(c),
          (P = L(O)),
          (k = v(O, "DIV", { class: !0 }));
        var me = g(k);
        A = v(me, "DIV", { class: !0 });
        var he = g(A);
        m = v(he, "A", { href: !0 });
        var Oe = g(m);
        (o = j(Oe, $)),
          Oe.forEach(c),
          (N = L(he)),
          (F = v(he, "A", { href: !0 }));
        var Fe = g(F);
        (W = j(Fe, K)),
          Fe.forEach(c),
          he.forEach(c),
          (U = L(me)),
          (z = v(me, "DIV", { class: !0 }));
        var _e = g(z);
        ee = v(_e, "SPAN", {});
        var Pe = g(ee);
        (ae = j(Pe, te)), Pe.forEach(c), (ye = L(_e)), (ce = v(_e, "SPAN", {}));
        var He = g(ce);
        (fe = j(He, ue)),
          He.forEach(c),
          _e.forEach(c),
          me.forEach(c),
          O.forEach(c),
          this.h();
      },
      h() {
        p(u, "href", (x = `/club?id=${s[20].homeTeamId}`)),
          p(l, "class", "w-10 items-center justify-center"),
          p(_, "class", "font-bold text-lg"),
          p(n, "href", (D = `/club?id=${s[20].awayTeamId}`)),
          p(f, "class", "w-10 items-center justify-center"),
          p(t, "class", "flex w-1/2 space-x-4 justify-center"),
          p(V, "class", "text-sm md:text-lg ml-4 md:ml-0 text-left"),
          p(M, "class", "flex w-1/2 lg:justify-center"),
          p(a, "class", "flex items-center w-1/2 ml-4"),
          p(m, "href", (S = `/club?id=${s[20].homeTeamId}`)),
          p(F, "href", (X = `/club?id=${s[20].awayTeamId}`)),
          p(
            A,
            "class",
            "flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px] text-xs md:text-base"
          ),
          p(
            z,
            "class",
            "flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px] text-xs md:text-base"
          ),
          p(k, "class", "flex items-center space-x-10 w-1/2 lg:justify-center"),
          p(
            e,
            "class",
            (de = `flex items-center justify-between py-2 border-b border-gray-700  ${
              s[20].status === 0 ? "text-gray-400" : "text-white"
            }`)
          );
      },
      m(I, O) {
        Z(I, e, O),
          r(e, a),
          r(a, t),
          r(t, l),
          r(l, u),
          ne(h, u, null),
          r(t, y),
          r(t, _),
          r(_, i),
          r(t, T),
          r(t, f),
          r(f, n),
          ne(d, n, null),
          r(a, C),
          r(a, M),
          r(M, V),
          r(V, w),
          r(e, P),
          r(e, k),
          r(k, A),
          r(A, m),
          r(m, o),
          r(A, N),
          r(A, F),
          r(F, W),
          r(k, U),
          r(k, z),
          r(z, ee),
          r(ee, ae),
          r(z, ye),
          r(z, ce),
          r(ce, fe),
          (R = !0);
      },
      p(I, O) {
        const Y = {};
        O & 2 && (Y.primaryColour = I[21] ? I[21].primaryColourHex : ""),
          O & 2 && (Y.secondaryColour = I[21] ? I[21].secondaryColourHex : ""),
          O & 2 && (Y.thirdColour = I[21] ? I[21].thirdColourHex : ""),
          h.$set(Y),
          (!R || (O & 2 && x !== (x = `/club?id=${I[20].homeTeamId}`))) &&
            p(u, "href", x);
        const J = {};
        O & 2 && (J.primaryColour = I[22] ? I[22].primaryColourHex : ""),
          O & 2 && (J.secondaryColour = I[22] ? I[22].secondaryColourHex : ""),
          O & 2 && (J.thirdColour = I[22] ? I[22].thirdColourHex : ""),
          d.$set(J),
          (!R || (O & 2 && D !== (D = `/club?id=${I[20].awayTeamId}`))) &&
            p(n, "href", D),
          (!R || O & 2) &&
            E !== (E = Ue(Number(I[20].kickOff)) + "") &&
            se(w, E),
          (!R || O & 2) &&
            $ !== ($ = (I[21] ? I[21].friendlyName : "") + "") &&
            se(o, $),
          (!R || (O & 2 && S !== (S = `/club?id=${I[20].homeTeamId}`))) &&
            p(m, "href", S),
          (!R || O & 2) &&
            K !== (K = (I[22] ? I[22].friendlyName : "") + "") &&
            se(W, K),
          (!R || (O & 2 && X !== (X = `/club?id=${I[20].awayTeamId}`))) &&
            p(F, "href", X),
          (!R || O & 2) &&
            te !== (te = (I[20].status === 0 ? "-" : I[20].homeGoals) + "") &&
            se(ae, te),
          (!R || O & 2) &&
            ue !== (ue = (I[20].status === 0 ? "-" : I[20].awayGoals) + "") &&
            se(fe, ue),
          (!R ||
            (O & 2 &&
              de !==
                (de = `flex items-center justify-between py-2 border-b border-gray-700  ${
                  I[20].status === 0 ? "text-gray-400" : "text-white"
                }`))) &&
            p(e, "class", de);
      },
      i(I) {
        R || (q(h.$$.fragment, I), q(d.$$.fragment, I), (R = !0));
      },
      o(I) {
        G(h.$$.fragment, I), G(d.$$.fragment, I), (R = !1);
      },
      d(I) {
        I && c(e), ie(h), ie(d);
      },
    }
  );
}
function Xe(s) {
  let e,
    a,
    t,
    l = s[17] + "",
    u,
    h,
    x,
    y,
    _ = s[2],
    i = [];
  for (let f = 0; f < _.length; f += 1) i[f] = We(ze(s, _, f));
  const T = (f) =>
    G(i[f], 1, 1, () => {
      i[f] = null;
    });
  return {
    c() {
      (e = b("div")), (a = b("div")), (t = b("h2")), (u = B(l)), (h = H());
      for (let f = 0; f < i.length; f += 1) i[f].c();
      (x = H()), this.h();
    },
    l(f) {
      e = v(f, "DIV", {});
      var n = g(e);
      a = v(n, "DIV", { class: !0 });
      var d = g(a);
      t = v(d, "H2", { class: !0 });
      var D = g(t);
      (u = j(D, l)), D.forEach(c), d.forEach(c), (h = L(n));
      for (let C = 0; C < i.length; C += 1) i[C].l(n);
      (x = L(n)), n.forEach(c), this.h();
    },
    h() {
      p(t, "class", "date-header ml-4 text-xs md:text-base"),
        p(
          a,
          "class",
          "flex items-center justify-between border border-gray-700 py-4 bg-light-gray"
        );
    },
    m(f, n) {
      Z(f, e, n), r(e, a), r(a, t), r(t, u), r(e, h);
      for (let d = 0; d < i.length; d += 1) i[d] && i[d].m(e, null);
      r(e, x), (y = !0);
    },
    p(f, n) {
      if (((!y || n & 2) && l !== (l = f[17] + "") && se(u, l), n & 2)) {
        _ = f[2];
        let d;
        for (d = 0; d < _.length; d += 1) {
          const D = ze(f, _, d);
          i[d]
            ? (i[d].p(D, n), q(i[d], 1))
            : ((i[d] = We(D)), i[d].c(), q(i[d], 1), i[d].m(e, x));
        }
        for (ve(), d = _.length; d < i.length; d += 1) T(d);
        ge();
      }
    },
    i(f) {
      if (!y) {
        for (let n = 0; n < _.length; n += 1) q(i[n]);
        y = !0;
      }
    },
    o(f) {
      i = i.filter(Boolean);
      for (let n = 0; n < i.length; n += 1) G(i[n]);
      y = !1;
    },
    d(f) {
      f && c(e), we(i, f);
    },
  };
}
function mt(s) {
  let e,
    a,
    t,
    l,
    u,
    h,
    x,
    y,
    _,
    i,
    T,
    f,
    n,
    d,
    D,
    C,
    M,
    V,
    E = s[3],
    w = [];
  for (let m = 0; m < E.length; m += 1) w[m] = Qe(Je(s, E, m));
  let P = Object.entries(s[1]),
    k = [];
  for (let m = 0; m < P.length; m += 1) k[m] = Xe(Ke(s, P, m));
  const A = (m) =>
    G(k[m], 1, 1, () => {
      k[m] = null;
    });
  return {
    c() {
      (e = b("div")),
        (a = b("div")),
        (t = b("div")),
        (l = b("div")),
        (u = b("button")),
        (h = B("<")),
        (y = H()),
        (_ = b("select"));
      for (let m = 0; m < w.length; m += 1) w[m].c();
      (i = H()), (T = b("button")), (f = B(">")), (d = H()), (D = b("div"));
      for (let m = 0; m < k.length; m += 1) k[m].c();
      this.h();
    },
    l(m) {
      e = v(m, "DIV", { class: !0 });
      var $ = g(e);
      a = v($, "DIV", { class: !0 });
      var o = g(a);
      t = v(o, "DIV", { class: !0 });
      var S = g(t);
      l = v(S, "DIV", { class: !0 });
      var N = g(l);
      u = v(N, "BUTTON", { class: !0 });
      var F = g(u);
      (h = j(F, "<")),
        F.forEach(c),
        (y = L(N)),
        (_ = v(N, "SELECT", { class: !0 }));
      var K = g(_);
      for (let U = 0; U < w.length; U += 1) w[U].l(K);
      K.forEach(c), (i = L(N)), (T = v(N, "BUTTON", { class: !0 }));
      var W = g(T);
      (f = j(W, ">")),
        W.forEach(c),
        N.forEach(c),
        S.forEach(c),
        (d = L(o)),
        (D = v(o, "DIV", {}));
      var X = g(D);
      for (let U = 0; U < k.length; U += 1) k[U].l(X);
      X.forEach(c), o.forEach(c), $.forEach(c), this.h();
    },
    h() {
      p(
        u,
        "class",
        "text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
      ),
        (u.disabled = x = s[0] === 1),
        p(
          _,
          "class",
          "p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]"
        ),
        s[0] === void 0 && at(() => s[8].call(_)),
        p(
          T,
          "class",
          "text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
        ),
        (T.disabled = n = s[0] === 38),
        p(l, "class", "flex items-center space-x-2 ml-4"),
        p(t, "class", "flex flex-col sm:flex-row gap-4 sm:gap-8"),
        p(a, "class", "flex flex-col space-y-4"),
        p(e, "class", "container-fluid mt-4 mb-4");
    },
    m(m, $) {
      Z(m, e, $), r(e, a), r(a, t), r(t, l), r(l, u), r(u, h), r(l, y), r(l, _);
      for (let o = 0; o < w.length; o += 1) w[o] && w[o].m(_, null);
      Le(_, s[0], !0), r(l, i), r(l, T), r(T, f), r(a, d), r(a, D);
      for (let o = 0; o < k.length; o += 1) k[o] && k[o].m(D, null);
      (C = !0),
        M ||
          ((V = [
            Q(u, "click", s[7]),
            Q(_, "change", s[8]),
            Q(T, "click", s[9]),
          ]),
          (M = !0));
    },
    p(m, [$]) {
      if (
        ((!C || ($ & 9 && x !== (x = m[0] === 1))) && (u.disabled = x), $ & 8)
      ) {
        E = m[3];
        let o;
        for (o = 0; o < E.length; o += 1) {
          const S = Je(m, E, o);
          w[o] ? w[o].p(S, $) : ((w[o] = Qe(S)), w[o].c(), w[o].m(_, null));
        }
        for (; o < w.length; o += 1) w[o].d(1);
        w.length = E.length;
      }
      if (
        ($ & 9 && Le(_, m[0]),
        (!C || ($ & 9 && n !== (n = m[0] === 38))) && (T.disabled = n),
        $ & 2)
      ) {
        P = Object.entries(m[1]);
        let o;
        for (o = 0; o < P.length; o += 1) {
          const S = Ke(m, P, o);
          k[o]
            ? (k[o].p(S, $), q(k[o], 1))
            : ((k[o] = Xe(S)), k[o].c(), q(k[o], 1), k[o].m(D, null));
        }
        for (ve(), o = P.length; o < k.length; o += 1) A(o);
        ge();
      }
    },
    i(m) {
      if (!C) {
        for (let $ = 0; $ < P.length; $ += 1) q(k[$]);
        C = !0;
      }
    },
    o(m) {
      k = k.filter(Boolean);
      for (let $ = 0; $ < k.length; $ += 1) G(k[$]);
      C = !1;
    },
    d(m) {
      m && c(e), we(w, m), we(k, m), (M = !1), Se(V);
    },
  };
}
function ht(s, e, a) {
  let t,
    l,
    u = [],
    h = [],
    x = [],
    y,
    _,
    i,
    T,
    f = 1,
    n = Array.from({ length: 38 }, (E, w) => w + 1);
  Te(async () => {
    try {
      await je.sync(),
        await qe.sync(),
        await le.sync(),
        (_ = je.subscribe((E) => {
          u = E;
        })),
        (i = qe.subscribe((E) => {
          a(2, (h = E)),
            a(
              5,
              (x = h.map((w) => ({
                fixture: w,
                homeTeam: D(w.homeTeamId),
                awayTeam: D(w.awayTeamId),
              })))
            );
        })),
        (T = le.subscribe((E) => {
          y = E;
        }));
    } catch (E) {
      Ee.show("Error fetching fixtures data.", "error"),
        console.error("Error fetching fixtures data:", E);
    } finally {
    }
  }),
    tt(() => {
      _?.(), i?.(), T?.();
    });
  const d = (E) => {
    a(0, (f = Math.max(1, Math.min(38, f + E))));
  };
  function D(E) {
    return u.find((w) => w.id === E);
  }
  const C = () => d(-1);
  function M() {
    (f = st(this)), a(0, f), a(3, n);
  }
  const V = () => d(1);
  return (
    (s.$$.update = () => {
      s.$$.dirty & 33 &&
        a(6, (t = x.filter(({ fixture: E }) => E.gameweek === f))),
        s.$$.dirty & 64 &&
          a(
            1,
            (l = t.reduce((E, w) => {
              const P = new Date(Number(w.fixture.kickOff) / 1e6),
                A = new Intl.DateTimeFormat("en-GB", {
                  weekday: "long",
                  day: "numeric",
                  month: "long",
                  year: "numeric",
                }).format(P);
              return E[A] || (E[A] = []), E[A].push(w), E;
            }, {}))
          );
    }),
    [f, l, h, n, d, x, t, C, M, V]
  );
}
class _t extends ke {
  constructor(e) {
    super(), xe(this, e, ht, mt, Ie, {});
  }
}
function pt() {
  const { subscribe: s, set: e } = dt([]),
    a = it.createActor(ct, "bboqb-jiaaa-aaaal-qb6ea-cai");
  async function t() {
    const l = await a.getSeasons();
    e(l);
  }
  return { subscribe: s, sync: t };
}
const Ye = pt();
function Ze(s) {
  let e, a, t, l, u, h, x, y, _, i, T, f, n, d, D, C, M, V;
  return {
    c() {
      (e = b("div")),
        (a = b("div")),
        (t = b("div")),
        (l = b("h3")),
        (u = B("Update System State")),
        (h = H()),
        (x = b("form")),
        (y = b("div")),
        (_ = H()),
        (i = b("div")),
        (T = b("button")),
        (f = B("Cancel")),
        (n = H()),
        (d = b("button")),
        (D = B("Update")),
        this.h();
    },
    l(E) {
      e = v(E, "DIV", { class: !0 });
      var w = g(e);
      a = v(w, "DIV", { class: !0 });
      var P = g(a);
      t = v(P, "DIV", { class: !0 });
      var k = g(t);
      l = v(k, "H3", { class: !0 });
      var A = g(l);
      (u = j(A, "Update System State")),
        A.forEach(c),
        (h = L(k)),
        (x = v(k, "FORM", {}));
      var m = g(x);
      y = v(m, "DIV", { class: !0 });
      var $ = g(y);
      $.forEach(c), (_ = L(m)), (i = v(m, "DIV", { class: !0 }));
      var o = g(i);
      T = v(o, "BUTTON", { class: !0 });
      var S = g(T);
      (f = j(S, "Cancel")),
        S.forEach(c),
        (n = L(o)),
        (d = v(o, "BUTTON", { class: !0, type: !0 }));
      var N = g(d);
      (D = j(N, "Update")),
        N.forEach(c),
        o.forEach(c),
        m.forEach(c),
        k.forEach(c),
        P.forEach(c),
        w.forEach(c),
        this.h();
    },
    h() {
      p(l, "class", "text-lg leading-6 font-medium mb-2"),
        p(y, "class", "mt-4"),
        p(
          T,
          "class",
          "px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        ),
        p(
          d,
          "class",
          (C = `px-4 py-2 ${
            s[2] ? "bg-gray-500" : "fpl-purple-btn"
          } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`)
        ),
        p(d, "type", "submit"),
        (d.disabled = s[2]),
        p(i, "class", "items-center py-3 flex space-x-4"),
        p(t, "class", "mt-3 text-center"),
        p(
          a,
          "class",
          "relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
        ),
        p(
          e,
          "class",
          "fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
        );
    },
    m(E, w) {
      Z(E, e, w),
        r(e, a),
        r(a, t),
        r(t, l),
        r(l, u),
        r(t, h),
        r(t, x),
        r(x, y),
        r(x, _),
        r(x, i),
        r(i, T),
        r(T, f),
        r(i, n),
        r(i, d),
        r(d, D),
        M ||
          ((V = [
            Q(T, "click", function () {
              Be(s[1]) && s[1].apply(this, arguments);
            }),
            Q(x, "submit", rt(s[3])),
            Q(a, "click", ot(s[7])),
            Q(a, "keydown", s[4]),
            Q(e, "click", function () {
              Be(s[1]) && s[1].apply(this, arguments);
            }),
            Q(e, "keydown", s[4]),
          ]),
          (M = !0));
    },
    p(E, w) {
      (s = E),
        w & 4 &&
          C !==
            (C = `px-4 py-2 ${
              s[2] ? "bg-gray-500" : "fpl-purple-btn"
            } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`) &&
          p(d, "class", C),
        w & 4 && (d.disabled = s[2]);
    },
    d(E) {
      E && c(e), (M = !1), Se(V);
    },
  };
}
function bt(s) {
  let e,
    a = s[0] && Ze(s);
  return {
    c() {
      a && a.c(), (e = be());
    },
    l(t) {
      a && a.l(t), (e = be());
    },
    m(t, l) {
      a && a.m(t, l), Z(t, e, l);
    },
    p(t, [l]) {
      t[0]
        ? a
          ? a.p(t, l)
          : ((a = Ze(t)), a.c(), a.m(e.parentNode, e))
        : a && (a.d(1), (a = null));
    },
    i: pe,
    o: pe,
    d(t) {
      a && a.d(t), t && c(e);
    },
  };
}
let vt = 1,
  gt = 1;
function yt(s, e, a) {
  let t, l;
  lt(s, Re, (n) => a(6, (l = n)));
  let { showModal: u } = e,
    { closeModal: h } = e,
    { cancelModal: x } = e,
    y,
    _;
  Te(async () => {
    await Re.sync(),
      await Ye.sync(),
      await le.sync(),
      (y = Ye.subscribe((n) => {})),
      (_ = le.subscribe((n) => {}));
  }),
    tt(() => {
      y?.(), _?.();
    });
  async function i() {
    try {
      let n = { activeGameweek: vt, activeSeasonId: gt };
      await le.updateSystemState(n),
        le.sync(),
        await h(),
        Ee.show("System State Updated.", "success");
    } catch (n) {
      Ee.show("Error updating system state.", "error"),
        console.error("Error updating system state:", n),
        x();
    } finally {
    }
  }
  function T(n) {
    !(n.target instanceof HTMLInputElement) && n.key === "Escape" && h();
  }
  function f(n) {
    nt.call(this, s, n);
  }
  return (
    (s.$$set = (n) => {
      "showModal" in n && a(0, (u = n.showModal)),
        "closeModal" in n && a(5, (h = n.closeModal)),
        "cancelModal" in n && a(1, (x = n.cancelModal));
    }),
    (s.$$.update = () => {
      s.$$.dirty & 64 &&
        a(
          2,
          (t =
            (l.identity?.getPrincipal().toString() ?? "") !==
            "kydhj-2crf5-wwkao-msv4s-vbyvu-kkroq-apnyv-zykjk-r6oyk-ksodu-vqe")
        );
    }),
    [u, x, t, i, T, h, l, f]
  );
}
class wt extends ke {
  constructor(e) {
    super(),
      xe(this, e, yt, bt, Ie, { showModal: 0, closeModal: 5, cancelModal: 1 });
  }
}
function Et(s) {
  let e, a, t, l, u, h, x, y, _, i, T, f, n, d, D, C, M, V, E, w, P, k, A, m, $;
  e = new wt({
    props: { showModal: s[0], closeModal: s[5], cancelModal: s[5] },
  });
  let o = s[1] === "fixtures" && et();
  return {
    c() {
      re(e.$$.fragment),
        (a = H()),
        (t = b("div")),
        (l = b("div")),
        (u = b("div")),
        (h = b("h1")),
        (x = B("OpenFPL Admin")),
        (y = H()),
        (_ = b("p")),
        (i = B("This view is for testing purposes only.")),
        (T = H()),
        (f = b("div")),
        (n = b("button")),
        (d = B("System Status")),
        (D = H()),
        (C = b("ul")),
        (M = b("li")),
        (V = b("button")),
        (E = B("Fixtures")),
        (k = H()),
        o && o.c(),
        this.h();
    },
    l(S) {
      oe(e.$$.fragment, S), (a = L(S)), (t = v(S, "DIV", { class: !0 }));
      var N = g(t);
      l = v(N, "DIV", { class: !0 });
      var F = g(l);
      u = v(F, "DIV", { class: !0 });
      var K = g(u);
      h = v(K, "H1", { class: !0 });
      var W = g(h);
      (x = j(W, "OpenFPL Admin")),
        W.forEach(c),
        (y = L(K)),
        (_ = v(K, "P", { class: !0 }));
      var X = g(_);
      (i = j(X, "This view is for testing purposes only.")),
        X.forEach(c),
        K.forEach(c),
        (T = L(F)),
        (f = v(F, "DIV", { class: !0 }));
      var U = g(f);
      n = v(U, "BUTTON", { class: !0 });
      var z = g(n);
      (d = j(z, "System Status")),
        z.forEach(c),
        U.forEach(c),
        (D = L(F)),
        (C = v(F, "UL", { class: !0 }));
      var ee = g(C);
      M = v(ee, "LI", { class: !0 });
      var te = g(M);
      V = v(te, "BUTTON", { class: !0 });
      var ae = g(V);
      (E = j(ae, "Fixtures")),
        ae.forEach(c),
        te.forEach(c),
        ee.forEach(c),
        (k = L(F)),
        o && o.l(F),
        F.forEach(c),
        N.forEach(c),
        this.h();
    },
    h() {
      p(h, "class", "text-xl"),
        p(_, "class", "mt-2"),
        p(u, "class", "flex flex-col p-4"),
        p(
          n,
          "class",
          "text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
        ),
        p(f, "class", "flex flex-row p-4 space-x-4"),
        p(
          V,
          "class",
          (w = `p-2 ${s[1] === "fixtures" ? "text-white" : "text-gray-400"}`)
        ),
        p(
          M,
          "class",
          (P = `mr-4 text-xs md:text-base ${
            s[1] === "fixtures" ? "active-tab" : ""
          }`)
        ),
        p(C, "class", "flex rounded-t-lg bg-light-gray px-4 pt-2"),
        p(l, "class", "bg-panel rounded-lg m-4"),
        p(t, "class", "m-4");
    },
    m(S, N) {
      ne(e, S, N),
        Z(S, a, N),
        Z(S, t, N),
        r(t, l),
        r(l, u),
        r(u, h),
        r(h, x),
        r(u, y),
        r(u, _),
        r(_, i),
        r(l, T),
        r(l, f),
        r(f, n),
        r(n, d),
        r(l, D),
        r(l, C),
        r(C, M),
        r(M, V),
        r(V, E),
        r(l, k),
        o && o.m(l, null),
        (A = !0),
        m || (($ = [Q(n, "click", s[3]), Q(V, "click", s[6])]), (m = !0));
    },
    p(S, N) {
      const F = {};
      N & 1 && (F.showModal = S[0]),
        e.$set(F),
        (!A ||
          (N & 2 &&
            w !==
              (w = `p-2 ${
                S[1] === "fixtures" ? "text-white" : "text-gray-400"
              }`))) &&
          p(V, "class", w),
        (!A ||
          (N & 2 &&
            P !==
              (P = `mr-4 text-xs md:text-base ${
                S[1] === "fixtures" ? "active-tab" : ""
              }`))) &&
          p(M, "class", P),
        S[1] === "fixtures"
          ? o
            ? N & 2 && q(o, 1)
            : ((o = et()), o.c(), q(o, 1), o.m(l, null))
          : o &&
            (ve(),
            G(o, 1, 1, () => {
              o = null;
            }),
            ge());
    },
    i(S) {
      A || (q(e.$$.fragment, S), q(o), (A = !0));
    },
    o(S) {
      G(e.$$.fragment, S), G(o), (A = !1);
    },
    d(S) {
      ie(e, S), S && c(a), S && c(t), o && o.d(), (m = !1), Se($);
    },
  };
}
function kt(s) {
  let e, a;
  return (
    (e = new ft({})),
    {
      c() {
        re(e.$$.fragment);
      },
      l(t) {
        oe(e.$$.fragment, t);
      },
      m(t, l) {
        ne(e, t, l), (a = !0);
      },
      p: pe,
      i(t) {
        a || (q(e.$$.fragment, t), (a = !0));
      },
      o(t) {
        G(e.$$.fragment, t), (a = !1);
      },
      d(t) {
        ie(e, t);
      },
    }
  );
}
function et(s) {
  let e, a;
  return (
    (e = new _t({})),
    {
      c() {
        re(e.$$.fragment);
      },
      l(t) {
        oe(e.$$.fragment, t);
      },
      m(t, l) {
        ne(e, t, l), (a = !0);
      },
      i(t) {
        a || (q(e.$$.fragment, t), (a = !0));
      },
      o(t) {
        G(e.$$.fragment, t), (a = !1);
      },
      d(t) {
        ie(e, t);
      },
    }
  );
}
function xt(s) {
  let e, a, t, l;
  const u = [kt, Et],
    h = [];
  function x(y, _) {
    return y[2] ? 0 : 1;
  }
  return (
    (e = x(s)),
    (a = h[e] = u[e](s)),
    {
      c() {
        a.c(), (t = be());
      },
      l(y) {
        a.l(y), (t = be());
      },
      m(y, _) {
        h[e].m(y, _), Z(y, t, _), (l = !0);
      },
      p(y, _) {
        let i = e;
        (e = x(y)),
          e === i
            ? h[e].p(y, _)
            : (ve(),
              G(h[i], 1, 1, () => {
                h[i] = null;
              }),
              ge(),
              (a = h[e]),
              a ? a.p(y, _) : ((a = h[e] = u[e](y)), a.c()),
              q(a, 1),
              a.m(t.parentNode, t));
      },
      i(y) {
        l || (q(a), (l = !0));
      },
      o(y) {
        G(a), (l = !1);
      },
      d(y) {
        h[e].d(y), y && c(t);
      },
    }
  );
}
function It(s) {
  let e, a;
  return (
    (e = new ut({
      props: { $$slots: { default: [xt] }, $$scope: { ctx: s } },
    })),
    {
      c() {
        re(e.$$.fragment);
      },
      l(t) {
        oe(e.$$.fragment, t);
      },
      m(t, l) {
        ne(e, t, l), (a = !0);
      },
      p(t, [l]) {
        const u = {};
        l & 135 && (u.$$scope = { dirty: l, ctx: t }), e.$set(u);
      },
      i(t) {
        a || (q(e.$$.fragment, t), (a = !0));
      },
      o(t) {
        G(e.$$.fragment, t), (a = !1);
      },
      d(t) {
        ie(e, t);
      },
    }
  );
}
function St(s, e, a) {
  let { showModal: t = !1 } = e,
    l = "fixtures",
    u = !0;
  Te(async () => {
    a(2, (u = !1));
  });
  function h() {
    a(0, (t = !0));
  }
  function x(i) {
    a(1, (l = i));
  }
  function y() {
    a(0, (t = !1));
  }
  const _ = () => x("fixtures");
  return (
    (s.$$set = (i) => {
      "showModal" in i && a(0, (t = i.showModal));
    }),
    [t, l, u, h, x, y, _]
  );
}
class Nt extends ke {
  constructor(e) {
    super(), xe(this, e, St, It, Ie, { showModal: 0 });
  }
}
export { Nt as component };