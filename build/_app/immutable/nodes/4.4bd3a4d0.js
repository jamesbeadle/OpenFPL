import { B as Nt } from "../chunks/BadgeIcon.5f1570c4.js";
import { f as tl } from "../chunks/fixture-store.8fe042dd.js";
import { i as va } from "../chunks/global-stores.803ba169.js";
import {
  A as Pe,
  a as v,
  b as Me,
  B as Ne,
  c as m,
  d as be,
  e as oa,
  f as At,
  G as e,
  g as pe,
  h as a,
  H as Da,
  I as Va,
  i as wl,
  J as wa,
  k as r,
  K as Yt,
  l as o,
  L as Zt,
  M as bl,
  m as i,
  n as l,
  N as Ta,
  o as Ea,
  O as Ia,
  p as et,
  P as ya,
  q as p,
  r as _,
  S as xl,
  s as yl,
  u as ue,
  v as Ht,
  x as ra,
  y as Ce,
  z as Fe,
} from "../chunks/index.c7b38e5e.js";
import { a as Na } from "../chunks/Layout.39e2a716.js";
import { p as ua } from "../chunks/player-store.55a4cc5d.js";
import { S as Ha } from "../chunks/ShirtIcon.cbb688e3.js";
import { p as ka } from "../chunks/stores.f0f38284.js";
import { s as da } from "../chunks/system-store.408d352e.js";
import {
  b as fa,
  d as kt,
  e as ia,
  f as ca,
  g as na,
  P as Ca,
  t as el,
  u as Pa,
} from "../chunks/team-store.a9afdac8.js";
import { t as $a } from "../chunks/toast-store.64ad2768.js";
function ma(s, n, f) {
  const t = s.slice();
  return (t[5] = n[f]), t;
}
function ha(s, n, f) {
  const t = s.slice();
  return (t[8] = n[f]), t;
}
function pa(s) {
  let n,
    f = kt(s[8]) + "",
    t;
  return {
    c() {
      (n = r("option")), (t = p(f)), this.h();
    },
    l(c) {
      n = o(c, "OPTION", {});
      var d = i(n);
      (t = _(d, f)), d.forEach(a), this.h();
    },
    h() {
      (n.__value = s[8]), (n.value = n.__value);
    },
    m(c, d) {
      Me(c, n, d), e(n, t);
    },
    p: Da,
    d(c) {
      c && a(n);
    },
  };
}
function _a(s) {
  let n,
    f,
    t,
    c = (s[5].shirtNumber === 0 ? "-" : s[5].shirtNumber) + "",
    d,
    N,
    L,
    T = (s[5].firstName === "" ? "-" : s[5].firstName) + "",
    y,
    k,
    Q,
    A = s[5].lastName + "",
    x,
    S,
    te,
    Y = kt(s[5].position) + "",
    C,
    J,
    se,
    G = ia(Number(s[5].dateOfBirth)) + "",
    M,
    ne,
    R,
    V,
    re,
    X,
    ae = s[5].totalPoints + "",
    Z,
    P,
    w,
    O,
    oe = (Number(s[5].value) / 4).toFixed(2) + "",
    W,
    de,
    le,
    ve,
    z;
  var ie = na(s[5].nationality);
  function fe(h) {
    return { props: { class: "w-10 h-10", size: "100" } };
  }
  return (
    ie && (V = ra(ie, fe())),
    {
      c() {
        (n = r("div")),
          (f = r("a")),
          (t = r("div")),
          (d = p(c)),
          (N = v()),
          (L = r("div")),
          (y = p(T)),
          (k = v()),
          (Q = r("div")),
          (x = p(A)),
          (S = v()),
          (te = r("div")),
          (C = p(Y)),
          (J = v()),
          (se = r("div")),
          (M = p(G)),
          (ne = v()),
          (R = r("div")),
          V && Ce(V.$$.fragment),
          (re = v()),
          (X = r("div")),
          (Z = p(ae)),
          (P = v()),
          (w = r("div")),
          (O = p("£")),
          (W = p(oe)),
          (de = p("m")),
          (ve = v()),
          this.h();
      },
      l(h) {
        n = o(h, "DIV", { class: !0 });
        var H = i(n);
        f = o(H, "A", { class: !0, href: !0 });
        var u = i(f);
        t = o(u, "DIV", { class: !0 });
        var j = i(t);
        (d = _(j, c)),
          j.forEach(a),
          (N = m(u)),
          (L = o(u, "DIV", { class: !0 }));
        var g = i(L);
        (y = _(g, T)),
          g.forEach(a),
          (k = m(u)),
          (Q = o(u, "DIV", { class: !0 }));
        var q = i(Q);
        (x = _(q, A)),
          q.forEach(a),
          (S = m(u)),
          (te = o(u, "DIV", { class: !0 }));
        var b = i(te);
        (C = _(b, Y)),
          b.forEach(a),
          (J = m(u)),
          (se = o(u, "DIV", { class: !0 }));
        var F = i(se);
        (M = _(F, G)),
          F.forEach(a),
          (ne = m(u)),
          (R = o(u, "DIV", { class: !0 }));
        var E = i(R);
        V && Fe(V.$$.fragment, E),
          E.forEach(a),
          (re = m(u)),
          (X = o(u, "DIV", { class: !0 }));
        var ee = i(X);
        (Z = _(ee, ae)),
          ee.forEach(a),
          (P = m(u)),
          (w = o(u, "DIV", { class: !0 }));
        var me = i(w);
        (O = _(me, "£")),
          (W = _(me, oe)),
          (de = _(me, "m")),
          me.forEach(a),
          u.forEach(a),
          (ve = m(H)),
          H.forEach(a),
          this.h();
      },
      h() {
        l(t, "class", "flex items-center w-1/2 px-3"),
          l(L, "class", "flex items-center w-1/2 px-3"),
          l(Q, "class", "flex items-center w-1/2 px-3"),
          l(te, "class", "flex items-center w-1/2 px-3"),
          l(se, "class", "flex items-center w-1/2 px-3"),
          l(R, "class", "flex items-center w-1/2 px-3"),
          l(X, "class", "flex items-center w-1/2 px-3"),
          l(w, "class", "flex items-center w-1/2 px-3"),
          l(
            f,
            "class",
            "flex-grow flex items-center justify-start space-x-2 px-4"
          ),
          l(f, "href", (le = `/player?id=${s[5].id}`)),
          l(
            n,
            "class",
            "flex items-center justify-between py-2 border-b border-gray-700 text-white cursor-pointer"
          );
      },
      m(h, H) {
        Me(h, n, H),
          e(n, f),
          e(f, t),
          e(t, d),
          e(f, N),
          e(f, L),
          e(L, y),
          e(f, k),
          e(f, Q),
          e(Q, x),
          e(f, S),
          e(f, te),
          e(te, C),
          e(f, J),
          e(f, se),
          e(se, M),
          e(f, ne),
          e(f, R),
          V && Pe(V, R, null),
          e(f, re),
          e(f, X),
          e(X, Z),
          e(f, P),
          e(f, w),
          e(w, O),
          e(w, W),
          e(w, de),
          e(n, ve),
          (z = !0);
      },
      p(h, H) {
        if (
          ((!z || H & 2) &&
            c !==
              (c = (h[5].shirtNumber === 0 ? "-" : h[5].shirtNumber) + "") &&
            ue(d, c),
          (!z || H & 2) &&
            T !== (T = (h[5].firstName === "" ? "-" : h[5].firstName) + "") &&
            ue(y, T),
          (!z || H & 2) && A !== (A = h[5].lastName + "") && ue(x, A),
          (!z || H & 2) && Y !== (Y = kt(h[5].position) + "") && ue(C, Y),
          (!z || H & 2) &&
            G !== (G = ia(Number(h[5].dateOfBirth)) + "") &&
            ue(M, G),
          H & 2 && ie !== (ie = na(h[5].nationality)))
        ) {
          if (V) {
            Ht();
            const u = V;
            be(u.$$.fragment, 1, 0, () => {
              Ne(u, 1);
            }),
              At();
          }
          ie
            ? ((V = ra(ie, fe())),
              Ce(V.$$.fragment),
              pe(V.$$.fragment, 1),
              Pe(V, R, null))
            : (V = null);
        }
        (!z || H & 2) && ae !== (ae = h[5].totalPoints + "") && ue(Z, ae),
          (!z || H & 2) &&
            oe !== (oe = (Number(h[5].value) / 4).toFixed(2) + "") &&
            ue(W, oe),
          (!z || (H & 2 && le !== (le = `/player?id=${h[5].id}`))) &&
            l(f, "href", le);
      },
      i(h) {
        z || (V && pe(V.$$.fragment, h), (z = !0));
      },
      o(h) {
        V && be(V.$$.fragment, h), (z = !1);
      },
      d(h) {
        h && a(n), V && Ne(V);
      },
    }
  );
}
function Aa(s) {
  let n,
    f,
    t,
    c,
    d,
    N,
    L,
    T,
    y,
    k,
    Q,
    A,
    x,
    S,
    te,
    Y,
    C,
    J,
    se,
    G,
    M,
    ne,
    R,
    V,
    re,
    X,
    ae,
    Z,
    P,
    w,
    O,
    oe,
    W,
    de,
    le,
    ve,
    z,
    ie,
    fe,
    h,
    H = s[2],
    u = [];
  for (let b = 0; b < H.length; b += 1) u[b] = pa(ha(s, H, b));
  let j = s[1],
    g = [];
  for (let b = 0; b < j.length; b += 1) g[b] = _a(ma(s, j, b));
  const q = (b) =>
    be(g[b], 1, 1, () => {
      g[b] = null;
    });
  return {
    c() {
      (n = r("div")),
        (f = r("div")),
        (t = r("div")),
        (c = r("div")),
        (d = r("div")),
        (N = r("p")),
        (L = p("Position:")),
        (T = v()),
        (y = r("select")),
        (k = r("option")),
        (Q = p("All"));
      for (let b = 0; b < u.length; b += 1) u[b].c();
      (A = v()),
        (x = r("div")),
        (S = r("div")),
        (te = p("Number")),
        (Y = v()),
        (C = r("div")),
        (J = p("First Name")),
        (se = v()),
        (G = r("div")),
        (M = p("Last Name")),
        (ne = v()),
        (R = r("div")),
        (V = p("Position")),
        (re = v()),
        (X = r("div")),
        (ae = p("Age")),
        (Z = v()),
        (P = r("div")),
        (w = p("Nationality")),
        (O = v()),
        (oe = r("div")),
        (W = p("Season Points")),
        (de = v()),
        (le = r("div")),
        (ve = p("Value")),
        (z = v());
      for (let b = 0; b < g.length; b += 1) g[b].c();
      this.h();
    },
    l(b) {
      n = o(b, "DIV", { class: !0 });
      var F = i(n);
      f = o(F, "DIV", { class: !0 });
      var E = i(f);
      t = o(E, "DIV", {});
      var ee = i(t);
      c = o(ee, "DIV", { class: !0 });
      var me = i(c);
      d = o(me, "DIV", { class: !0 });
      var K = i(d);
      N = o(K, "P", { class: !0 });
      var D = i(N);
      (L = _(D, "Position:")),
        D.forEach(a),
        (T = m(K)),
        (y = o(K, "SELECT", { class: !0 }));
      var I = i(y);
      k = o(I, "OPTION", {});
      var _e = i(k);
      (Q = _(_e, "All")), _e.forEach(a);
      for (let ce = 0; ce < u.length; ce += 1) u[ce].l(I);
      I.forEach(a),
        K.forEach(a),
        me.forEach(a),
        (A = m(ee)),
        (x = o(ee, "DIV", { class: !0 }));
      var B = i(x);
      S = o(B, "DIV", { class: !0 });
      var $e = i(S);
      (te = _($e, "Number")),
        $e.forEach(a),
        (Y = m(B)),
        (C = o(B, "DIV", { class: !0 }));
      var xe = i(C);
      (J = _(xe, "First Name")),
        xe.forEach(a),
        (se = m(B)),
        (G = o(B, "DIV", { class: !0 }));
      var De = i(G);
      (M = _(De, "Last Name")),
        De.forEach(a),
        (ne = m(B)),
        (R = o(B, "DIV", { class: !0 }));
      var ge = i(R);
      (V = _(ge, "Position")),
        ge.forEach(a),
        (re = m(B)),
        (X = o(B, "DIV", { class: !0 }));
      var we = i(X);
      (ae = _(we, "Age")),
        we.forEach(a),
        (Z = m(B)),
        (P = o(B, "DIV", { class: !0 }));
      var je = i(P);
      (w = _(je, "Nationality")),
        je.forEach(a),
        (O = m(B)),
        (oe = o(B, "DIV", { class: !0 }));
      var Le = i(oe);
      (W = _(Le, "Season Points")),
        Le.forEach(a),
        (de = m(B)),
        (le = o(B, "DIV", { class: !0 }));
      var Ve = i(le);
      (ve = _(Ve, "Value")), Ve.forEach(a), B.forEach(a), (z = m(ee));
      for (let ce = 0; ce < g.length; ce += 1) g[ce].l(ee);
      ee.forEach(a), E.forEach(a), F.forEach(a), this.h();
    },
    h() {
      l(N, "class", "text-sm md:text-xl mr-4"),
        (k.__value = -1),
        (k.value = k.__value),
        l(y, "class", "p-2 fpl-dropdown text-sm md:text-xl"),
        s[0] === void 0 && wa(() => s[4].call(y)),
        l(d, "class", "flex items-center ml-4"),
        l(c, "class", "flex p-4"),
        l(S, "class", "flex-grow px-4 w-1/2"),
        l(C, "class", "flex-grow px-4 w-1/2"),
        l(G, "class", "flex-grow px-4 w-1/2"),
        l(R, "class", "flex-grow px-4 w-1/2"),
        l(X, "class", "flex-grow px-4 w-1/2"),
        l(P, "class", "flex-grow px-4 w-1/2"),
        l(oe, "class", "flex-grow px-4 w-1/2"),
        l(le, "class", "flex-grow px-4 w-1/2"),
        l(
          x,
          "class",
          "flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
        ),
        l(f, "class", "flex flex-col space-y-4"),
        l(n, "class", "container-fluid");
    },
    m(b, F) {
      Me(b, n, F),
        e(n, f),
        e(f, t),
        e(t, c),
        e(c, d),
        e(d, N),
        e(N, L),
        e(d, T),
        e(d, y),
        e(y, k),
        e(k, Q);
      for (let E = 0; E < u.length; E += 1) u[E] && u[E].m(y, null);
      Yt(y, s[0], !0),
        e(t, A),
        e(t, x),
        e(x, S),
        e(S, te),
        e(x, Y),
        e(x, C),
        e(C, J),
        e(x, se),
        e(x, G),
        e(G, M),
        e(x, ne),
        e(x, R),
        e(R, V),
        e(x, re),
        e(x, X),
        e(X, ae),
        e(x, Z),
        e(x, P),
        e(P, w),
        e(x, O),
        e(x, oe),
        e(oe, W),
        e(x, de),
        e(x, le),
        e(le, ve),
        e(t, z);
      for (let E = 0; E < g.length; E += 1) g[E] && g[E].m(t, null);
      (ie = !0), fe || ((h = Zt(y, "change", s[4])), (fe = !0));
    },
    p(b, [F]) {
      if (F & 4) {
        H = b[2];
        let E;
        for (E = 0; E < H.length; E += 1) {
          const ee = ha(b, H, E);
          u[E] ? u[E].p(ee, F) : ((u[E] = pa(ee)), u[E].c(), u[E].m(y, null));
        }
        for (; E < u.length; E += 1) u[E].d(1);
        u.length = H.length;
      }
      if ((F & 5 && Yt(y, b[0]), F & 2)) {
        j = b[1];
        let E;
        for (E = 0; E < j.length; E += 1) {
          const ee = ma(b, j, E);
          g[E]
            ? (g[E].p(ee, F), pe(g[E], 1))
            : ((g[E] = _a(ee)), g[E].c(), pe(g[E], 1), g[E].m(t, null));
        }
        for (Ht(), E = j.length; E < g.length; E += 1) q(E);
        At();
      }
    },
    i(b) {
      if (!ie) {
        for (let F = 0; F < j.length; F += 1) pe(g[F]);
        ie = !0;
      }
    },
    o(b) {
      g = g.filter(Boolean);
      for (let F = 0; F < g.length; F += 1) be(g[F]);
      ie = !1;
    },
    d(b) {
      b && a(n), bl(u, b), bl(g, b), (fe = !1), h();
    },
  };
}
function Sa(s, n, f) {
  let t,
    { players: c = [] } = n,
    d = -1,
    N = Object.values(Ca).filter((T) => typeof T == "number");
  function L() {
    (d = ya(this)), f(0, d), f(2, N);
  }
  return (
    (s.$$set = (T) => {
      "players" in T && f(3, (c = T.players));
    }),
    (s.$$.update = () => {
      s.$$.dirty & 9 &&
        f(1, (t = d === -1 ? c : c.filter((T) => T.position === d)));
    }),
    [d, t, N, c, L]
  );
}
class Oa extends xl {
  constructor(n) {
    super(), wl(this, n, Sa, Aa, yl, { players: 3 });
  }
}
function ga(s, n, f) {
  const t = s.slice();
  return (
    (t[10] = n[f].fixture), (t[11] = n[f].homeTeam), (t[12] = n[f].awayTeam), t
  );
}
function ba(s) {
  let n,
    f,
    t = s[10].gameweek + "",
    c,
    d,
    N,
    L,
    T,
    y,
    k,
    Q,
    A,
    x,
    S,
    te,
    Y,
    C,
    J,
    se,
    G,
    M = fa(Number(s[10].kickOff)) + "",
    ne,
    R,
    V,
    re = ca(Number(s[10].kickOff)) + "",
    X,
    ae,
    Z,
    P,
    w,
    O = (s[11] ? s[11].friendlyName : "") + "",
    oe,
    W,
    de,
    le,
    ve = (s[12] ? s[12].friendlyName : "") + "",
    z,
    ie,
    fe,
    h,
    H,
    u,
    j = (s[10].status === 0 ? "-" : s[10].homeGoals) + "",
    g,
    q,
    b,
    F = (s[10].status === 0 ? "-" : s[10].awayGoals) + "",
    E,
    ee,
    me,
    K;
  return (
    (y = new Nt({
      props: {
        primaryColour: s[11] ? s[11].primaryColourHex : "",
        secondaryColour: s[11] ? s[11].secondaryColourHex : "",
        thirdColour: s[11] ? s[11].thirdColourHex : "",
      },
    })),
    (C = new Nt({
      props: {
        primaryColour: s[12] ? s[12].primaryColourHex : "",
        secondaryColour: s[12] ? s[12].secondaryColourHex : "",
        thirdColour: s[12] ? s[12].thirdColourHex : "",
      },
    })),
    {
      c() {
        (n = r("div")),
          (f = r("div")),
          (c = p(t)),
          (d = v()),
          (N = r("div")),
          (L = r("div")),
          (T = r("a")),
          Ce(y.$$.fragment),
          (Q = v()),
          (A = r("span")),
          (x = p("v")),
          (S = v()),
          (te = r("div")),
          (Y = r("a")),
          Ce(C.$$.fragment),
          (se = v()),
          (G = r("div")),
          (ne = p(M)),
          (R = v()),
          (V = r("div")),
          (X = p(re)),
          (ae = v()),
          (Z = r("div")),
          (P = r("div")),
          (w = r("a")),
          (oe = p(O)),
          (de = v()),
          (le = r("a")),
          (z = p(ve)),
          (fe = v()),
          (h = r("div")),
          (H = r("div")),
          (u = r("span")),
          (g = p(j)),
          (q = v()),
          (b = r("span")),
          (E = p(F)),
          (ee = v()),
          this.h();
      },
      l(D) {
        n = o(D, "DIV", { class: !0 });
        var I = i(n);
        f = o(I, "DIV", { class: !0 });
        var _e = i(f);
        (c = _(_e, t)),
          _e.forEach(a),
          (d = m(I)),
          (N = o(I, "DIV", { class: !0 }));
        var B = i(N);
        L = o(B, "DIV", { class: !0 });
        var $e = i(L);
        T = o($e, "A", { href: !0 });
        var xe = i(T);
        Fe(y.$$.fragment, xe),
          xe.forEach(a),
          $e.forEach(a),
          (Q = m(B)),
          (A = o(B, "SPAN", { class: !0 }));
        var De = i(A);
        (x = _(De, "v")),
          De.forEach(a),
          (S = m(B)),
          (te = o(B, "DIV", { class: !0 }));
        var ge = i(te);
        Y = o(ge, "A", { href: !0 });
        var we = i(Y);
        Fe(C.$$.fragment, we),
          we.forEach(a),
          ge.forEach(a),
          B.forEach(a),
          (se = m(I)),
          (G = o(I, "DIV", { class: !0 }));
        var je = i(G);
        (ne = _(je, M)),
          je.forEach(a),
          (R = m(I)),
          (V = o(I, "DIV", { class: !0 }));
        var Le = i(V);
        (X = _(Le, re)),
          Le.forEach(a),
          (ae = m(I)),
          (Z = o(I, "DIV", { class: !0 }));
        var Ve = i(Z);
        P = o(Ve, "DIV", { class: !0 });
        var ce = i(P);
        w = o(ce, "A", { href: !0 });
        var Ge = i(w);
        (oe = _(Ge, O)),
          Ge.forEach(a),
          (de = m(ce)),
          (le = o(ce, "A", { href: !0 }));
        var ke = i(le);
        (z = _(ke, ve)),
          ke.forEach(a),
          ce.forEach(a),
          Ve.forEach(a),
          (fe = m(I)),
          (h = o(I, "DIV", { class: !0 }));
        var Te = i(h);
        H = o(Te, "DIV", { class: !0 });
        var Be = i(H);
        u = o(Be, "SPAN", {});
        var nt = i(u);
        (g = _(nt, j)), nt.forEach(a), (q = m(Be)), (b = o(Be, "SPAN", {}));
        var Ue = i(b);
        (E = _(Ue, F)),
          Ue.forEach(a),
          Be.forEach(a),
          Te.forEach(a),
          (ee = m(I)),
          I.forEach(a),
          this.h();
      },
      h() {
        l(f, "class", "w-1/6 ml-4"),
          l(T, "href", (k = `/club?id=${s[10].homeTeamId}`)),
          l(L, "class", "w-10 items-center justify-center mr-4"),
          l(A, "class", "font-bold text-lg"),
          l(Y, "href", (J = `/club?id=${s[10].awayTeamId}`)),
          l(te, "class", "w-10 items-center justify-center ml-4"),
          l(N, "class", "w-1/3 flex justify-center"),
          l(G, "class", "w-1/3"),
          l(V, "class", "w-1/4 text-center"),
          l(w, "href", (W = `/club?id=${s[10].homeTeamId}`)),
          l(le, "href", (ie = `/club?id=${s[10].awayTeamId}`)),
          l(P, "class", "flex flex-col text-xs md:text-lg"),
          l(Z, "class", "w-1/3"),
          l(H, "class", "flex flex-col text-xs md:text-lg"),
          l(h, "class", "w-1/4 mr-4"),
          l(
            n,
            "class",
            (me = `flex items-center justify-between border-b border-gray-700 p-2 px-4  
          ${s[10].status === 0 ? "text-gray-400" : "text-white"}`)
          );
      },
      m(D, I) {
        Me(D, n, I),
          e(n, f),
          e(f, c),
          e(n, d),
          e(n, N),
          e(N, L),
          e(L, T),
          Pe(y, T, null),
          e(N, Q),
          e(N, A),
          e(A, x),
          e(N, S),
          e(N, te),
          e(te, Y),
          Pe(C, Y, null),
          e(n, se),
          e(n, G),
          e(G, ne),
          e(n, R),
          e(n, V),
          e(V, X),
          e(n, ae),
          e(n, Z),
          e(Z, P),
          e(P, w),
          e(w, oe),
          e(P, de),
          e(P, le),
          e(le, z),
          e(n, fe),
          e(n, h),
          e(h, H),
          e(H, u),
          e(u, g),
          e(H, q),
          e(H, b),
          e(b, E),
          e(n, ee),
          (K = !0);
      },
      p(D, I) {
        (!K || I & 2) && t !== (t = D[10].gameweek + "") && ue(c, t);
        const _e = {};
        I & 2 && (_e.primaryColour = D[11] ? D[11].primaryColourHex : ""),
          I & 2 && (_e.secondaryColour = D[11] ? D[11].secondaryColourHex : ""),
          I & 2 && (_e.thirdColour = D[11] ? D[11].thirdColourHex : ""),
          y.$set(_e),
          (!K || (I & 2 && k !== (k = `/club?id=${D[10].homeTeamId}`))) &&
            l(T, "href", k);
        const B = {};
        I & 2 && (B.primaryColour = D[12] ? D[12].primaryColourHex : ""),
          I & 2 && (B.secondaryColour = D[12] ? D[12].secondaryColourHex : ""),
          I & 2 && (B.thirdColour = D[12] ? D[12].thirdColourHex : ""),
          C.$set(B),
          (!K || (I & 2 && J !== (J = `/club?id=${D[10].awayTeamId}`))) &&
            l(Y, "href", J),
          (!K || I & 2) &&
            M !== (M = fa(Number(D[10].kickOff)) + "") &&
            ue(ne, M),
          (!K || I & 2) &&
            re !== (re = ca(Number(D[10].kickOff)) + "") &&
            ue(X, re),
          (!K || I & 2) &&
            O !== (O = (D[11] ? D[11].friendlyName : "") + "") &&
            ue(oe, O),
          (!K || (I & 2 && W !== (W = `/club?id=${D[10].homeTeamId}`))) &&
            l(w, "href", W),
          (!K || I & 2) &&
            ve !== (ve = (D[12] ? D[12].friendlyName : "") + "") &&
            ue(z, ve),
          (!K || (I & 2 && ie !== (ie = `/club?id=${D[10].awayTeamId}`))) &&
            l(le, "href", ie),
          (!K || I & 2) &&
            j !== (j = (D[10].status === 0 ? "-" : D[10].homeGoals) + "") &&
            ue(g, j),
          (!K || I & 2) &&
            F !== (F = (D[10].status === 0 ? "-" : D[10].awayGoals) + "") &&
            ue(E, F),
          (!K ||
            (I & 2 &&
              me !==
                (me = `flex items-center justify-between border-b border-gray-700 p-2 px-4  
          ${D[10].status === 0 ? "text-gray-400" : "text-white"}`))) &&
            l(n, "class", me);
      },
      i(D) {
        K || (pe(y.$$.fragment, D), pe(C.$$.fragment, D), (K = !0));
      },
      o(D) {
        be(y.$$.fragment, D), be(C.$$.fragment, D), (K = !1);
      },
      d(D) {
        D && a(n), Ne(y), Ne(C);
      },
    }
  );
}
function Fa(s) {
  let n,
    f,
    t,
    c,
    d,
    N,
    L,
    T,
    y,
    k,
    Q,
    A,
    x,
    S,
    te,
    Y,
    C,
    J,
    se,
    G,
    M,
    ne,
    R,
    V,
    re,
    X,
    ae,
    Z,
    P,
    w,
    O,
    oe,
    W,
    de,
    le,
    ve,
    z,
    ie,
    fe = s[1],
    h = [];
  for (let u = 0; u < fe.length; u += 1) h[u] = ba(ga(s, fe, u));
  const H = (u) =>
    be(h[u], 1, 1, () => {
      h[u] = null;
    });
  return {
    c() {
      (n = r("div")),
        (f = r("div")),
        (t = r("div")),
        (c = r("div")),
        (d = r("div")),
        (N = r("p")),
        (L = p("Type:")),
        (T = v()),
        (y = r("select")),
        (k = r("option")),
        (Q = p("All")),
        (A = r("option")),
        (x = p("Home")),
        (S = r("option")),
        (te = p("Away")),
        (Y = v()),
        (C = r("div")),
        (J = r("div")),
        (se = p("Gameweek")),
        (G = v()),
        (M = r("div")),
        (ne = p("Game")),
        (R = v()),
        (V = r("div")),
        (re = p("Date")),
        (X = v()),
        (ae = r("div")),
        (Z = p("Time")),
        (P = v()),
        (w = r("div")),
        (O = p("Teams")),
        (oe = v()),
        (W = r("div")),
        (de = p("Result")),
        (le = v());
      for (let u = 0; u < h.length; u += 1) h[u].c();
      this.h();
    },
    l(u) {
      n = o(u, "DIV", { class: !0 });
      var j = i(n);
      f = o(j, "DIV", { class: !0 });
      var g = i(f);
      t = o(g, "DIV", {});
      var q = i(t);
      c = o(q, "DIV", { class: !0 });
      var b = i(c);
      d = o(b, "DIV", { class: !0 });
      var F = i(d);
      N = o(F, "P", { class: !0 });
      var E = i(N);
      (L = _(E, "Type:")),
        E.forEach(a),
        (T = m(F)),
        (y = o(F, "SELECT", { class: !0 }));
      var ee = i(y);
      k = o(ee, "OPTION", {});
      var me = i(k);
      (Q = _(me, "All")), me.forEach(a), (A = o(ee, "OPTION", {}));
      var K = i(A);
      (x = _(K, "Home")), K.forEach(a), (S = o(ee, "OPTION", {}));
      var D = i(S);
      (te = _(D, "Away")),
        D.forEach(a),
        ee.forEach(a),
        F.forEach(a),
        b.forEach(a),
        (Y = m(q)),
        (C = o(q, "DIV", { class: !0 }));
      var I = i(C);
      J = o(I, "DIV", { class: !0 });
      var _e = i(J);
      (se = _(_e, "Gameweek")),
        _e.forEach(a),
        (G = m(I)),
        (M = o(I, "DIV", { class: !0 }));
      var B = i(M);
      (ne = _(B, "Game")),
        B.forEach(a),
        (R = m(I)),
        (V = o(I, "DIV", { class: !0 }));
      var $e = i(V);
      (re = _($e, "Date")),
        $e.forEach(a),
        (X = m(I)),
        (ae = o(I, "DIV", { class: !0 }));
      var xe = i(ae);
      (Z = _(xe, "Time")),
        xe.forEach(a),
        (P = m(I)),
        (w = o(I, "DIV", { class: !0 }));
      var De = i(w);
      (O = _(De, "Teams")),
        De.forEach(a),
        (oe = m(I)),
        (W = o(I, "DIV", { class: !0 }));
      var ge = i(W);
      (de = _(ge, "Result")), ge.forEach(a), I.forEach(a), (le = m(q));
      for (let we = 0; we < h.length; we += 1) h[we].l(q);
      q.forEach(a), g.forEach(a), j.forEach(a), this.h();
    },
    h() {
      l(N, "class", "text-sm md:text-xl mr-4"),
        (k.__value = -1),
        (k.value = k.__value),
        (A.__value = 0),
        (A.value = A.__value),
        (S.__value = 1),
        (S.value = S.__value),
        l(y, "class", "p-2 fpl-dropdown text-sm md:text-xl"),
        s[0] === void 0 && wa(() => s[4].call(y)),
        l(d, "class", "flex items-center ml-4"),
        l(c, "class", "flex p-4"),
        l(J, "class", "flex-grow w-1/6 ml-4"),
        l(M, "class", "flex-grow w-1/3 text-center"),
        l(V, "class", "flex-grow w-1/3"),
        l(ae, "class", "flex-grow w-1/4 text-center"),
        l(w, "class", "flex-grow w-1/3"),
        l(W, "class", "flex-grow w-1/4 mr-4"),
        l(
          C,
          "class",
          "flex justify-between p-2 border border-gray-700 py-4 bg-light-gray px-4"
        ),
        l(f, "class", "flex flex-col space-y-4"),
        l(n, "class", "container-fluid");
    },
    m(u, j) {
      Me(u, n, j),
        e(n, f),
        e(f, t),
        e(t, c),
        e(c, d),
        e(d, N),
        e(N, L),
        e(d, T),
        e(d, y),
        e(y, k),
        e(k, Q),
        e(y, A),
        e(A, x),
        e(y, S),
        e(S, te),
        Yt(y, s[0], !0),
        e(t, Y),
        e(t, C),
        e(C, J),
        e(J, se),
        e(C, G),
        e(C, M),
        e(M, ne),
        e(C, R),
        e(C, V),
        e(V, re),
        e(C, X),
        e(C, ae),
        e(ae, Z),
        e(C, P),
        e(C, w),
        e(w, O),
        e(C, oe),
        e(C, W),
        e(W, de),
        e(t, le);
      for (let g = 0; g < h.length; g += 1) h[g] && h[g].m(t, null);
      (ve = !0), z || ((ie = Zt(y, "change", s[4])), (z = !0));
    },
    p(u, [j]) {
      if ((j & 1 && Yt(y, u[0]), j & 2)) {
        fe = u[1];
        let g;
        for (g = 0; g < fe.length; g += 1) {
          const q = ga(u, fe, g);
          h[g]
            ? (h[g].p(q, j), pe(h[g], 1))
            : ((h[g] = ba(q)), h[g].c(), pe(h[g], 1), h[g].m(t, null));
        }
        for (Ht(), g = fe.length; g < h.length; g += 1) H(g);
        At();
      }
    },
    i(u) {
      if (!ve) {
        for (let j = 0; j < fe.length; j += 1) pe(h[j]);
        ve = !0;
      }
    },
    o(u) {
      h = h.filter(Boolean);
      for (let j = 0; j < h.length; j += 1) be(h[j]);
      ve = !1;
    },
    d(u) {
      u && a(n), bl(h, u), (z = !1), ie();
    },
  };
}
function ja(s, n, f) {
  let t,
    { clubId: c = null } = n,
    d = [],
    N = [],
    L = [],
    T = -1,
    y,
    k;
  Ea(async () => {
    try {
      await el.sync(),
        await tl.sync(),
        (y = el.subscribe((x) => {
          d = x;
        })),
        (k = tl.subscribe((x) => {
          (N = x),
            f(
              3,
              (L = N.map((S) => ({
                fixture: S,
                homeTeam: Q(S.homeTeamId),
                awayTeam: Q(S.awayTeamId),
              })))
            );
        }));
    } catch (x) {
      $a.show("Error fetching team fixtures.", "error"),
        console.error("Error fetching team fixtures:", x);
    } finally {
    }
  }),
    Ia(() => {
      y?.(), k?.();
    });
  function Q(x) {
    return d.find((S) => S.id === x);
  }
  function A() {
    (T = ya(this)), f(0, T);
  }
  return (
    (s.$$set = (x) => {
      "clubId" in x && f(2, (c = x.clubId));
    }),
    (s.$$.update = () => {
      s.$$.dirty & 13 &&
        f(
          1,
          (t =
            T === -1
              ? L.filter(
                  ({ fixture: x }) =>
                    c === null || x.homeTeamId === c || x.awayTeamId === c
                )
              : T === 0
              ? L.filter(({ fixture: x }) => c === null || x.homeTeamId === c)
              : L.filter(({ fixture: x }) => c === null || x.awayTeamId === c))
        );
    }),
    [T, t, c, L, A]
  );
}
class La extends xl {
  constructor(n) {
    super(), wl(this, n, ja, Fa, yl, { clubId: 2 });
  }
}
function xa(s) {
  let n,
    f,
    t,
    c,
    d,
    N = tt?.friendlyName + "",
    L,
    T,
    y,
    k,
    Q,
    A,
    x,
    S,
    te = tt?.abbreviatedName + "",
    Y,
    C,
    J,
    se,
    G,
    M,
    ne,
    R,
    V,
    re = s[1].length + "",
    X,
    ae,
    Z,
    P,
    w,
    O,
    oe,
    W,
    de,
    le,
    ve,
    z,
    ie = s[9](s[7]) + "",
    fe,
    h,
    H,
    u = s[0].name + "",
    j,
    g,
    q,
    b,
    F,
    E,
    ee,
    me,
    K = s[10](s[7]) + "",
    D,
    I,
    _e,
    B,
    $e,
    xe,
    De,
    ge,
    we,
    je,
    Le,
    Ve,
    ce,
    Ge,
    ke,
    Te,
    Be,
    nt,
    Ue,
    ft,
    ll,
    al,
    ct,
    lt,
    We,
    St,
    sl,
    He,
    ut,
    dt,
    Je,
    It = s[2]?.abbreviatedName + "",
    Ot,
    Ft,
    rl,
    $t,
    ol,
    vt,
    mt,
    Ke,
    Dt = s[3]?.abbreviatedName + "",
    jt,
    Lt,
    il,
    at,
    nl,
    Ae,
    ht,
    fl,
    cl,
    pt,
    st,
    Vt = s[4]?.lastName + "",
    Gt,
    Bt,
    ul,
    Re,
    Tt = kt(s[4]?.position ?? 0) + "",
    Ut,
    dl,
    Ct = s[4]?.totalPoints + "",
    Rt,
    vl,
    qt,
    rt,
    qe,
    Qe,
    ot,
    Xe,
    ml,
    zt,
    Mt,
    hl,
    it,
    Ye,
    pl,
    Wt,
    Jt,
    _l,
    ye,
    Ee,
    he,
    gl,
    El;
  (k = new Nt({
    props: {
      className: "h-10",
      primaryColour: tt?.primaryColourHex,
      secondaryColour: tt?.secondaryColourHex,
      thirdColour: tt?.thirdColourHex,
    },
  })),
    (A = new Ha({
      props: {
        className: "h-10",
        primaryColour: tt?.primaryColourHex,
        secondaryColour: tt?.secondaryColourHex,
        thirdColour: tt?.thirdColourHex,
      },
    })),
    (Te = new Nt({
      props: {
        primaryColour: s[2]?.primaryColourHex,
        secondaryColour: s[2]?.secondaryColourHex,
        thirdColour: s[2]?.thirdColourHex,
      },
    })),
    (We = new Nt({
      props: {
        primaryColour: s[3]?.primaryColourHex,
        secondaryColour: s[3]?.secondaryColourHex,
        thirdColour: s[3]?.thirdColourHex,
      },
    }));
  const Il = [Ba, Ga],
    Ze = [];
  function $l($, U) {
    return $[5] === "players" ? 0 : $[5] === "fixtures" ? 1 : -1;
  }
  return (
    ~(ye = $l(s)) && (Ee = Ze[ye] = Il[ye](s)),
    {
      c() {
        (n = r("div")),
          (f = r("div")),
          (t = r("div")),
          (c = r("div")),
          (d = r("p")),
          (L = p(N)),
          (T = v()),
          (y = r("div")),
          Ce(k.$$.fragment),
          (Q = v()),
          Ce(A.$$.fragment),
          (x = v()),
          (S = r("p")),
          (Y = p(te)),
          (C = v()),
          (J = r("div")),
          (se = v()),
          (G = r("div")),
          (M = r("p")),
          (ne = p("Players")),
          (R = v()),
          (V = r("p")),
          (X = p(re)),
          (ae = v()),
          (Z = r("p")),
          (P = p("Total")),
          (w = v()),
          (O = r("div")),
          (oe = v()),
          (W = r("div")),
          (de = r("p")),
          (le = p("League Position")),
          (ve = v()),
          (z = r("p")),
          (fe = p(ie)),
          (h = v()),
          (H = r("p")),
          (j = p(u)),
          (g = v()),
          (q = r("div")),
          (b = r("div")),
          (F = r("p")),
          (E = p("League Points")),
          (ee = v()),
          (me = r("p")),
          (D = p(K)),
          (I = v()),
          (_e = r("p")),
          (B = p("Total")),
          ($e = v()),
          (xe = r("div")),
          (De = v()),
          (ge = r("div")),
          (we = r("p")),
          (je = p("Next Game:")),
          (Le = v()),
          (Ve = r("div")),
          (ce = r("div")),
          (Ge = r("div")),
          (ke = r("a")),
          Ce(Te.$$.fragment),
          (nt = v()),
          (Ue = r("div")),
          (ft = r("p")),
          (ll = p("v")),
          (al = v()),
          (ct = r("div")),
          (lt = r("a")),
          Ce(We.$$.fragment),
          (sl = v()),
          (He = r("div")),
          (ut = r("div")),
          (dt = r("p")),
          (Je = r("a")),
          (Ot = p(It)),
          (rl = v()),
          ($t = r("div")),
          (ol = v()),
          (vt = r("div")),
          (mt = r("p")),
          (Ke = r("a")),
          (jt = p(Dt)),
          (il = v()),
          (at = r("div")),
          (nl = v()),
          (Ae = r("div")),
          (ht = r("p")),
          (fl = p("Highest Scoring Player")),
          (cl = v()),
          (pt = r("p")),
          (st = r("a")),
          (Gt = p(Vt)),
          (ul = v()),
          (Re = r("p")),
          (Ut = p(Tt)),
          (dl = p(`
              (`)),
          (Rt = p(Ct)),
          (vl = p(")")),
          (qt = v()),
          (rt = r("div")),
          (qe = r("div")),
          (Qe = r("ul")),
          (ot = r("li")),
          (Xe = r("button")),
          (ml = p("Players")),
          (hl = v()),
          (it = r("li")),
          (Ye = r("button")),
          (pl = p("Fixtures")),
          (_l = v()),
          Ee && Ee.c(),
          this.h();
      },
      l($) {
        n = o($, "DIV", { class: !0 });
        var U = i(n);
        f = o(U, "DIV", { class: !0 });
        var ze = i(f);
        t = o(ze, "DIV", { class: !0 });
        var Ie = i(t);
        c = o(Ie, "DIV", { class: !0 });
        var Se = i(c);
        d = o(Se, "P", { class: !0 });
        var Dl = i(d);
        (L = _(Dl, N)),
          Dl.forEach(a),
          (T = m(Se)),
          (y = o(Se, "DIV", { class: !0 }));
        var Kt = i(y);
        Fe(k.$$.fragment, Kt),
          (Q = m(Kt)),
          Fe(A.$$.fragment, Kt),
          Kt.forEach(a),
          (x = m(Se)),
          (S = o(Se, "P", { class: !0 }));
        var Vl = i(S);
        (Y = _(Vl, te)),
          Vl.forEach(a),
          Se.forEach(a),
          (C = m(Ie)),
          (J = o(Ie, "DIV", { class: !0, style: !0 })),
          i(J).forEach(a),
          (se = m(Ie)),
          (G = o(Ie, "DIV", { class: !0 }));
        var _t = i(G);
        M = o(_t, "P", { class: !0 });
        var Tl = i(M);
        (ne = _(Tl, "Players")),
          Tl.forEach(a),
          (R = m(_t)),
          (V = o(_t, "P", { class: !0 }));
        var Cl = i(V);
        (X = _(Cl, re)),
          Cl.forEach(a),
          (ae = m(_t)),
          (Z = o(_t, "P", { class: !0 }));
        var Pl = i(Z);
        (P = _(Pl, "Total")),
          Pl.forEach(a),
          _t.forEach(a),
          (w = m(Ie)),
          (O = o(Ie, "DIV", { class: !0, style: !0 })),
          i(O).forEach(a),
          (oe = m(Ie)),
          (W = o(Ie, "DIV", { class: !0 }));
        var gt = i(W);
        de = o(gt, "P", { class: !0 });
        var Nl = i(de);
        (le = _(Nl, "League Position")),
          Nl.forEach(a),
          (ve = m(gt)),
          (z = o(gt, "P", { class: !0 }));
        var kl = i(z);
        (fe = _(kl, ie)),
          kl.forEach(a),
          (h = m(gt)),
          (H = o(gt, "P", { class: !0 }));
        var Hl = i(H);
        (j = _(Hl, u)),
          Hl.forEach(a),
          gt.forEach(a),
          Ie.forEach(a),
          (g = m(ze)),
          (q = o(ze, "DIV", { class: !0 }));
        var Oe = i(q);
        b = o(Oe, "DIV", { class: !0 });
        var bt = i(b);
        F = o(bt, "P", { class: !0 });
        var Al = i(F);
        (E = _(Al, "League Points")),
          Al.forEach(a),
          (ee = m(bt)),
          (me = o(bt, "P", { class: !0 }));
        var Sl = i(me);
        (D = _(Sl, K)),
          Sl.forEach(a),
          (I = m(bt)),
          (_e = o(bt, "P", { class: !0 }));
        var Ol = i(_e);
        (B = _(Ol, "Total")),
          Ol.forEach(a),
          bt.forEach(a),
          ($e = m(Oe)),
          (xe = o(Oe, "DIV", { class: !0, style: !0 })),
          i(xe).forEach(a),
          (De = m(Oe)),
          (ge = o(Oe, "DIV", { class: !0 }));
        var xt = i(ge);
        we = o(xt, "P", { class: !0 });
        var Fl = i(we);
        (je = _(Fl, "Next Game:")),
          Fl.forEach(a),
          (Le = m(xt)),
          (Ve = o(xt, "DIV", { class: !0 }));
        var jl = i(Ve);
        ce = o(jl, "DIV", { class: !0 });
        var wt = i(ce);
        Ge = o(wt, "DIV", { class: !0 });
        var Ll = i(Ge);
        ke = o(Ll, "A", { href: !0 });
        var Gl = i(ke);
        Fe(Te.$$.fragment, Gl),
          Gl.forEach(a),
          Ll.forEach(a),
          (nt = m(wt)),
          (Ue = o(wt, "DIV", { class: !0 }));
        var Bl = i(Ue);
        ft = o(Bl, "P", { class: !0 });
        var Ul = i(ft);
        (ll = _(Ul, "v")),
          Ul.forEach(a),
          Bl.forEach(a),
          (al = m(wt)),
          (ct = o(wt, "DIV", { class: !0 }));
        var Rl = i(ct);
        lt = o(Rl, "A", { href: !0 });
        var ql = i(lt);
        Fe(We.$$.fragment, ql),
          ql.forEach(a),
          Rl.forEach(a),
          wt.forEach(a),
          jl.forEach(a),
          (sl = m(xt)),
          (He = o(xt, "DIV", { class: !0 }));
        var yt = i(He);
        ut = o(yt, "DIV", { class: !0 });
        var zl = i(ut);
        dt = o(zl, "P", { class: !0 });
        var Ml = i(dt);
        Je = o(Ml, "A", { class: !0, href: !0 });
        var Wl = i(Je);
        (Ot = _(Wl, It)),
          Wl.forEach(a),
          Ml.forEach(a),
          zl.forEach(a),
          (rl = m(yt)),
          ($t = o(yt, "DIV", { class: !0 })),
          i($t).forEach(a),
          (ol = m(yt)),
          (vt = o(yt, "DIV", { class: !0 }));
        var Jl = i(vt);
        mt = o(Jl, "P", { class: !0 });
        var Kl = i(mt);
        Ke = o(Kl, "A", { class: !0, href: !0 });
        var Ql = i(Ke);
        (jt = _(Ql, Dt)),
          Ql.forEach(a),
          Kl.forEach(a),
          Jl.forEach(a),
          yt.forEach(a),
          xt.forEach(a),
          (il = m(Oe)),
          (at = o(Oe, "DIV", { class: !0, style: !0 })),
          i(at).forEach(a),
          (nl = m(Oe)),
          (Ae = o(Oe, "DIV", { class: !0 }));
        var Et = i(Ae);
        ht = o(Et, "P", { class: !0 });
        var Xl = i(ht);
        (fl = _(Xl, "Highest Scoring Player")),
          Xl.forEach(a),
          (cl = m(Et)),
          (pt = o(Et, "P", { class: !0 }));
        var Yl = i(pt);
        st = o(Yl, "A", { href: !0 });
        var Zl = i(st);
        (Gt = _(Zl, Vt)),
          Zl.forEach(a),
          Yl.forEach(a),
          (ul = m(Et)),
          (Re = o(Et, "P", { class: !0 }));
        var Pt = i(Re);
        (Ut = _(Pt, Tt)),
          (dl = _(
            Pt,
            `
              (`
          )),
          (Rt = _(Pt, Ct)),
          (vl = _(Pt, ")")),
          Pt.forEach(a),
          Et.forEach(a),
          Oe.forEach(a),
          ze.forEach(a),
          U.forEach(a),
          (qt = m($)),
          (rt = o($, "DIV", { class: !0 }));
        var ea = i(rt);
        qe = o(ea, "DIV", { class: !0 });
        var Qt = i(qe);
        Qe = o(Qt, "UL", { class: !0 });
        var Xt = i(Qe);
        ot = o(Xt, "LI", { class: !0 });
        var ta = i(ot);
        Xe = o(ta, "BUTTON", { class: !0 });
        var la = i(Xe);
        (ml = _(la, "Players")),
          la.forEach(a),
          ta.forEach(a),
          (hl = m(Xt)),
          (it = o(Xt, "LI", { class: !0 }));
        var aa = i(it);
        Ye = o(aa, "BUTTON", { class: !0 });
        var sa = i(Ye);
        (pl = _(sa, "Fixtures")),
          sa.forEach(a),
          aa.forEach(a),
          Xt.forEach(a),
          (_l = m(Qt)),
          Ee && Ee.l(Qt),
          Qt.forEach(a),
          ea.forEach(a),
          this.h();
      },
      h() {
        l(d, "class", "text-gray-300 text-xs"),
          l(y, "class", "py-2 flex space-x-4"),
          l(S, "class", "text-gray-300 text-xs"),
          l(c, "class", "flex-grow flex flex-col items-center"),
          l(J, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
          et(J, "min-width", "2px"),
          et(J, "min-height", "50px"),
          l(M, "class", "text-gray-300 text-xs"),
          l(V, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
          l(Z, "class", "text-gray-300 text-xs"),
          l(G, "class", "flex-grow"),
          l(O, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
          et(O, "min-width", "2px"),
          et(O, "min-height", "50px"),
          l(de, "class", "text-gray-300 text-xs"),
          l(z, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
          l(H, "class", "text-gray-300 text-xs"),
          l(W, "class", "flex-grow"),
          l(
            t,
            "class",
            "flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
          ),
          l(F, "class", "text-gray-300 text-xs"),
          l(
            me,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          l(_e, "class", "text-gray-300 text-xs"),
          l(b, "class", "flex-grow mb-4 md:mb-0"),
          l(
            xe,
            "class",
            "h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
          ),
          et(xe, "min-height", "2px"),
          et(xe, "min-width", "2px"),
          l(we, "class", "text-gray-300 text-xs"),
          l(ke, "href", (Be = `/club?id=${s[2]?.id}`)),
          l(Ge, "class", "w-10 ml-4 mr-4"),
          l(ft, "class", "text-xs mt-2 mb-2 font-bold"),
          l(Ue, "class", "w-v ml-1 mr-1 flex justify-center"),
          l(lt, "href", (St = `/club?id=${s[3]?.id}`)),
          l(ct, "class", "w-10 ml-4"),
          l(ce, "class", "flex justify-center items-center"),
          l(Ve, "class", "flex justify-center mb-2 mt-2"),
          l(Je, "class", "text-gray-300 text-xs text-center"),
          l(Je, "href", (Ft = `/club?id=${s[2]?.id}`)),
          l(dt, "class", "text-gray-300 text-xs text-center"),
          l(ut, "class", "w-10 ml-4 mr-4"),
          l($t, "class", "w-v ml-2 mr-2"),
          l(Ke, "class", "text-gray-300 text-xs text-center"),
          l(Ke, "href", (Lt = `/club?id=${s[3]?.id}`)),
          l(mt, "class", "text-gray-300 text-xs text-center"),
          l(vt, "class", "w-10 ml-4"),
          l(He, "class", "flex justify-center"),
          l(ge, "class", "flex-grow mb-4 md:mb-0"),
          l(
            at,
            "class",
            "h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
          ),
          et(at, "min-height", "2px"),
          et(at, "min-width", "2px"),
          l(ht, "class", "text-gray-300 text-xs mt-4 md:mt-0"),
          l(st, "href", (Bt = `/player?id=${s[4]?.id}`)),
          l(
            pt,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          l(Re, "class", "text-gray-300 text-xs"),
          l(Ae, "class", "flex-grow"),
          l(
            q,
            "class",
            "flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
          ),
          l(f, "class", "flex flex-col md:flex-row"),
          l(n, "class", "m-4"),
          l(
            Xe,
            "class",
            (zt = `p-2 ${s[5] === "players" ? "text-white" : "text-gray-400"}`)
          ),
          l(
            ot,
            "class",
            (Mt = `mr-4 text-xs md:text-lg ${
              s[5] === "players" ? "active-tab" : ""
            }`)
          ),
          l(
            Ye,
            "class",
            (Wt = `p-2 ${s[5] === "fixtures" ? "text-white" : "text-gray-400"}`)
          ),
          l(
            it,
            "class",
            (Jt = `mr-4 text-xs md:text-lg ${
              s[5] === "fixtures" ? "active-tab" : ""
            }`)
          ),
          l(Qe, "class", "flex bg-light-gray px-4 pt-2"),
          l(qe, "class", "bg-panel rounded-md m-4"),
          l(rt, "class", "m-4");
      },
      m($, U) {
        Me($, n, U),
          e(n, f),
          e(f, t),
          e(t, c),
          e(c, d),
          e(d, L),
          e(c, T),
          e(c, y),
          Pe(k, y, null),
          e(y, Q),
          Pe(A, y, null),
          e(c, x),
          e(c, S),
          e(S, Y),
          e(t, C),
          e(t, J),
          e(t, se),
          e(t, G),
          e(G, M),
          e(M, ne),
          e(G, R),
          e(G, V),
          e(V, X),
          e(G, ae),
          e(G, Z),
          e(Z, P),
          e(t, w),
          e(t, O),
          e(t, oe),
          e(t, W),
          e(W, de),
          e(de, le),
          e(W, ve),
          e(W, z),
          e(z, fe),
          e(W, h),
          e(W, H),
          e(H, j),
          e(f, g),
          e(f, q),
          e(q, b),
          e(b, F),
          e(F, E),
          e(b, ee),
          e(b, me),
          e(me, D),
          e(b, I),
          e(b, _e),
          e(_e, B),
          e(q, $e),
          e(q, xe),
          e(q, De),
          e(q, ge),
          e(ge, we),
          e(we, je),
          e(ge, Le),
          e(ge, Ve),
          e(Ve, ce),
          e(ce, Ge),
          e(Ge, ke),
          Pe(Te, ke, null),
          e(ce, nt),
          e(ce, Ue),
          e(Ue, ft),
          e(ft, ll),
          e(ce, al),
          e(ce, ct),
          e(ct, lt),
          Pe(We, lt, null),
          e(ge, sl),
          e(ge, He),
          e(He, ut),
          e(ut, dt),
          e(dt, Je),
          e(Je, Ot),
          e(He, rl),
          e(He, $t),
          e(He, ol),
          e(He, vt),
          e(vt, mt),
          e(mt, Ke),
          e(Ke, jt),
          e(q, il),
          e(q, at),
          e(q, nl),
          e(q, Ae),
          e(Ae, ht),
          e(ht, fl),
          e(Ae, cl),
          e(Ae, pt),
          e(pt, st),
          e(st, Gt),
          e(Ae, ul),
          e(Ae, Re),
          e(Re, Ut),
          e(Re, dl),
          e(Re, Rt),
          e(Re, vl),
          Me($, qt, U),
          Me($, rt, U),
          e(rt, qe),
          e(qe, Qe),
          e(Qe, ot),
          e(ot, Xe),
          e(Xe, ml),
          e(Qe, hl),
          e(Qe, it),
          e(it, Ye),
          e(Ye, pl),
          e(qe, _l),
          ~ye && Ze[ye].m(qe, null),
          (he = !0),
          gl ||
            ((El = [Zt(Xe, "click", s[15]), Zt(Ye, "click", s[16])]),
            (gl = !0));
      },
      p($, U) {
        (!he || U & 2) && re !== (re = $[1].length + "") && ue(X, re),
          (!he || U & 128) && ie !== (ie = $[9]($[7]) + "") && ue(fe, ie),
          (!he || U & 1) && u !== (u = $[0].name + "") && ue(j, u),
          (!he || U & 128) && K !== (K = $[10]($[7]) + "") && ue(D, K);
        const ze = {};
        U & 4 && (ze.primaryColour = $[2]?.primaryColourHex),
          U & 4 && (ze.secondaryColour = $[2]?.secondaryColourHex),
          U & 4 && (ze.thirdColour = $[2]?.thirdColourHex),
          Te.$set(ze),
          (!he || (U & 4 && Be !== (Be = `/club?id=${$[2]?.id}`))) &&
            l(ke, "href", Be);
        const Ie = {};
        U & 8 && (Ie.primaryColour = $[3]?.primaryColourHex),
          U & 8 && (Ie.secondaryColour = $[3]?.secondaryColourHex),
          U & 8 && (Ie.thirdColour = $[3]?.thirdColourHex),
          We.$set(Ie),
          (!he || (U & 8 && St !== (St = `/club?id=${$[3]?.id}`))) &&
            l(lt, "href", St),
          (!he || U & 4) &&
            It !== (It = $[2]?.abbreviatedName + "") &&
            ue(Ot, It),
          (!he || (U & 4 && Ft !== (Ft = `/club?id=${$[2]?.id}`))) &&
            l(Je, "href", Ft),
          (!he || U & 8) &&
            Dt !== (Dt = $[3]?.abbreviatedName + "") &&
            ue(jt, Dt),
          (!he || (U & 8 && Lt !== (Lt = `/club?id=${$[3]?.id}`))) &&
            l(Ke, "href", Lt),
          (!he || U & 16) && Vt !== (Vt = $[4]?.lastName + "") && ue(Gt, Vt),
          (!he || (U & 16 && Bt !== (Bt = `/player?id=${$[4]?.id}`))) &&
            l(st, "href", Bt),
          (!he || U & 16) &&
            Tt !== (Tt = kt($[4]?.position ?? 0) + "") &&
            ue(Ut, Tt),
          (!he || U & 16) && Ct !== (Ct = $[4]?.totalPoints + "") && ue(Rt, Ct),
          (!he ||
            (U & 32 &&
              zt !==
                (zt = `p-2 ${
                  $[5] === "players" ? "text-white" : "text-gray-400"
                }`))) &&
            l(Xe, "class", zt),
          (!he ||
            (U & 32 &&
              Mt !==
                (Mt = `mr-4 text-xs md:text-lg ${
                  $[5] === "players" ? "active-tab" : ""
                }`))) &&
            l(ot, "class", Mt),
          (!he ||
            (U & 32 &&
              Wt !==
                (Wt = `p-2 ${
                  $[5] === "fixtures" ? "text-white" : "text-gray-400"
                }`))) &&
            l(Ye, "class", Wt),
          (!he ||
            (U & 32 &&
              Jt !==
                (Jt = `mr-4 text-xs md:text-lg ${
                  $[5] === "fixtures" ? "active-tab" : ""
                }`))) &&
            l(it, "class", Jt);
        let Se = ye;
        (ye = $l($)),
          ye === Se
            ? ~ye && Ze[ye].p($, U)
            : (Ee &&
                (Ht(),
                be(Ze[Se], 1, 1, () => {
                  Ze[Se] = null;
                }),
                At()),
              ~ye
                ? ((Ee = Ze[ye]),
                  Ee ? Ee.p($, U) : ((Ee = Ze[ye] = Il[ye]($)), Ee.c()),
                  pe(Ee, 1),
                  Ee.m(qe, null))
                : (Ee = null));
      },
      i($) {
        he ||
          (pe(k.$$.fragment, $),
          pe(A.$$.fragment, $),
          pe(Te.$$.fragment, $),
          pe(We.$$.fragment, $),
          pe(Ee),
          (he = !0));
      },
      o($) {
        be(k.$$.fragment, $),
          be(A.$$.fragment, $),
          be(Te.$$.fragment, $),
          be(We.$$.fragment, $),
          be(Ee),
          (he = !1);
      },
      d($) {
        $ && a(n),
          Ne(k),
          Ne(A),
          Ne(Te),
          Ne(We),
          $ && a(qt),
          $ && a(rt),
          ~ye && Ze[ye].d(),
          (gl = !1),
          Ta(El);
      },
    }
  );
}
function Ga(s) {
  let n, f;
  return (
    (n = new La({ props: { clubId: s[7] } })),
    {
      c() {
        Ce(n.$$.fragment);
      },
      l(t) {
        Fe(n.$$.fragment, t);
      },
      m(t, c) {
        Pe(n, t, c), (f = !0);
      },
      p(t, c) {
        const d = {};
        c & 128 && (d.clubId = t[7]), n.$set(d);
      },
      i(t) {
        f || (pe(n.$$.fragment, t), (f = !0));
      },
      o(t) {
        be(n.$$.fragment, t), (f = !1);
      },
      d(t) {
        Ne(n, t);
      },
    }
  );
}
function Ba(s) {
  let n, f;
  return (
    (n = new Oa({ props: { players: s[1] } })),
    {
      c() {
        Ce(n.$$.fragment);
      },
      l(t) {
        Fe(n.$$.fragment, t);
      },
      m(t, c) {
        Pe(n, t, c), (f = !0);
      },
      p(t, c) {
        const d = {};
        c & 2 && (d.players = t[1]), n.$set(d);
      },
      i(t) {
        f || (pe(n.$$.fragment, t), (f = !0));
      },
      o(t) {
        be(n.$$.fragment, t), (f = !1);
      },
      d(t) {
        Ne(n, t);
      },
    }
  );
}
function Ua(s) {
  let n,
    f,
    t = s[6] && xa(s);
  return {
    c() {
      t && t.c(), (n = oa());
    },
    l(c) {
      t && t.l(c), (n = oa());
    },
    m(c, d) {
      t && t.m(c, d), Me(c, n, d), (f = !0);
    },
    p(c, d) {
      c[6]
        ? t
          ? (t.p(c, d), d & 64 && pe(t, 1))
          : ((t = xa(c)), t.c(), pe(t, 1), t.m(n.parentNode, n))
        : t &&
          (Ht(),
          be(t, 1, 1, () => {
            t = null;
          }),
          At());
    },
    i(c) {
      f || (pe(t), (f = !0));
    },
    o(c) {
      be(t), (f = !1);
    },
    d(c) {
      t && t.d(c), c && a(n);
    },
  };
}
function Ra(s) {
  let n, f;
  return (
    (n = new Na({
      props: { $$slots: { default: [Ua] }, $$scope: { ctx: s } },
    })),
    {
      c() {
        Ce(n.$$.fragment);
      },
      l(t) {
        Fe(n.$$.fragment, t);
      },
      m(t, c) {
        Pe(n, t, c), (f = !0);
      },
      p(t, [c]) {
        const d = {};
        c & 67109119 && (d.$$scope = { dirty: c, ctx: t }), n.$set(d);
      },
      i(t) {
        f || (pe(n.$$.fragment, t), (f = !0));
      },
      o(t) {
        be(n.$$.fragment, t), (f = !1);
      },
      d(t) {
        Ne(n, t);
      },
    }
  );
}
let tt = null;
function qa(s, n, f) {
  let t, c;
  Va(s, ka, (P) => f(14, (c = P)));
  let d = [],
    N = [],
    L,
    T = [],
    y = 1,
    k,
    Q = [],
    A = null,
    x = null,
    S = null,
    te = null,
    Y = "players",
    C,
    J,
    se,
    G,
    M = !1;
  Ea(async () => {
    va.set(!0);
    try {
      await el.sync(),
        await tl.sync(),
        await da.sync(),
        await ua.sync(),
        (J = tl.subscribe((w) => {
          (N = w),
            f(
              12,
              (T = N.map((O) => ({
                fixture: O,
                homeTeam: R(O.homeTeamId),
                awayTeam: R(O.awayTeamId),
              })))
            );
        })),
        (C = el.subscribe((w) => {
          f(11, (d = w));
        })),
        (se = da.subscribe((w) => {
          L = w;
        })),
        (G = ua.subscribe((w) => {
          f(1, (Q = w.filter((O) => O.teamId === t)));
        }));
      let P = N.filter((w) => w.homeTeamId === t || w.awayTeamId === t);
      f(
        12,
        (T = P.map((w) => ({
          fixture: w,
          homeTeam: R(w.homeTeamId),
          awayTeam: R(w.awayTeamId),
        })))
      ),
        f(
          4,
          (te = Q.sort((w, O) => w.totalPoints - O.totalPoints).sort(
            (w, O) => Number(O.value) - Number(w.value)
          )[0])
        ),
        f(13, (y = L?.activeGameweek ?? y)),
        f(0, (k = L?.activeSeason ?? k)),
        (A = P.find((w) => w.gameweek === y) ?? null),
        f(2, (x = R(A?.homeTeamId ?? 0) ?? null)),
        f(3, (S = R(A?.awayTeamId ?? 0) ?? null));
    } catch (P) {
      $a.show("Error fetching club details.", "error"),
        console.error("Error fetching club details:", P);
    } finally {
      va.set(!1), f(6, (M = !0));
    }
  }),
    Ia(() => {
      C?.(), J?.(), se?.(), G?.();
    });
  let ne = [];
  function R(P) {
    return d.find((w) => w.id === P);
  }
  function V(P) {
    f(5, (Y = P));
  }
  const re = (P) => {
      const w = ne.findIndex((O) => O.id === P);
      return w !== -1 ? w + 1 : "Not found";
    },
    X = (P) => ne.find((O) => O.id === P).points,
    ae = () => V("players"),
    Z = () => V("fixtures");
  return (
    (s.$$.update = () => {
      s.$$.dirty & 16384 && f(7, (t = Number(c.url.searchParams.get("id")))),
        s.$$.dirty & 14336 &&
          T.length > 0 &&
          d.length > 0 &&
          (ne = Pa(T, d, y));
    }),
    [k, Q, x, S, te, Y, M, t, V, re, X, d, T, y, c, ae, Z]
  );
}
class ls extends xl {
  constructor(n) {
    super(), wl(this, n, qa, Ra, yl, {});
  }
}
export { ls as component };
