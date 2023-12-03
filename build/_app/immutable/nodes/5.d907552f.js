import { B as Nt } from "../chunks/BadgeIcon.ac2d82f5.js";
import {
  u as Ca,
  a as Ia,
  L as Pa,
  e as Ta,
  P as Va,
  h as ca,
  j as da,
  t as el,
  b as fa,
  q as ia,
  o as kt,
  g as na,
  f as tl,
  s as ua,
} from "../chunks/Layout.0e76e124.js";
import { S as ka } from "../chunks/ShirtIcon.3da312bd.js";
import {
  I as $a,
  f as At,
  A as Ce,
  N as Da,
  O as Ea,
  v as Ht,
  b as Me,
  B as Pe,
  y as Te,
  K as Yt,
  L as Zt,
  g as _e,
  n as a,
  r as b,
  J as ba,
  M as bl,
  m as c,
  G as e,
  p as et,
  q as g,
  d as ge,
  k as i,
  z as ke,
  c as m,
  l as n,
  e as oa,
  x as ra,
  h as s,
  u as ue,
  a as v,
  o as wa,
  s as wl,
  H as xa,
  S as xl,
  P as ya,
  i as yl,
} from "../chunks/index.a8c54947.js";
import { p as Na } from "../chunks/stores.95126db5.js";
function va(r, t, o) {
  const l = r.slice();
  return (l[5] = t[o]), l;
}
function ma(r, t, o) {
  const l = r.slice();
  return (l[8] = t[o]), l;
}
function ha(r) {
  let t,
    o = kt(r[8]) + "",
    l;
  return {
    c() {
      (t = i("option")), (l = g(o)), this.h();
    },
    l(f) {
      t = n(f, "OPTION", {});
      var d = c(t);
      (l = b(d, o)), d.forEach(s), this.h();
    },
    h() {
      (t.__value = r[8]), (t.value = t.__value);
    },
    m(f, d) {
      Me(f, t, d), e(t, l);
    },
    p: xa,
    d(f) {
      f && s(t);
    },
  };
}
function _a(r) {
  let t,
    o,
    l,
    f = (r[5].shirtNumber === 0 ? "-" : r[5].shirtNumber) + "",
    d,
    T,
    H,
    _ = (r[5].firstName === "" ? "-" : r[5].firstName) + "",
    h,
    P,
    Q,
    S = r[5].lastName + "",
    w,
    O,
    te,
    Y = kt(r[5].position) + "",
    N,
    J,
    se,
    G = ia(Number(r[5].dateOfBirth)) + "",
    M,
    ne,
    q,
    C,
    re,
    X,
    ae = r[5].totalPoints + "",
    Z,
    k,
    E,
    F,
    oe = (Number(r[5].value) / 4).toFixed(2) + "",
    W,
    de,
    le,
    ve,
    z;
  var ie = na(r[5].nationality);
  function ce(p) {
    return { props: { class: "w-10 h-10", size: "100" } };
  }
  return (
    ie && (C = ra(ie, ce())),
    {
      c() {
        (t = i("div")),
          (o = i("a")),
          (l = i("div")),
          (d = g(f)),
          (T = v()),
          (H = i("div")),
          (h = g(_)),
          (P = v()),
          (Q = i("div")),
          (w = g(S)),
          (O = v()),
          (te = i("div")),
          (N = g(Y)),
          (J = v()),
          (se = i("div")),
          (M = g(G)),
          (ne = v()),
          (q = i("div")),
          C && Te(C.$$.fragment),
          (re = v()),
          (X = i("div")),
          (Z = g(ae)),
          (k = v()),
          (E = i("div")),
          (F = g("£")),
          (W = g(oe)),
          (de = g("m")),
          (ve = v()),
          this.h();
      },
      l(p) {
        t = n(p, "DIV", { class: !0 });
        var A = c(t);
        o = n(A, "A", { class: !0, href: !0 });
        var u = c(o);
        l = n(u, "DIV", { class: !0 });
        var L = c(l);
        (d = b(L, f)),
          L.forEach(s),
          (T = m(u)),
          (H = n(u, "DIV", { class: !0 }));
        var x = c(H);
        (h = b(x, _)),
          x.forEach(s),
          (P = m(u)),
          (Q = n(u, "DIV", { class: !0 }));
        var R = c(Q);
        (w = b(R, S)),
          R.forEach(s),
          (O = m(u)),
          (te = n(u, "DIV", { class: !0 }));
        var y = c(te);
        (N = b(y, Y)),
          y.forEach(s),
          (J = m(u)),
          (se = n(u, "DIV", { class: !0 }));
        var j = c(se);
        (M = b(j, G)),
          j.forEach(s),
          (ne = m(u)),
          (q = n(u, "DIV", { class: !0 }));
        var I = c(q);
        C && ke(C.$$.fragment, I),
          I.forEach(s),
          (re = m(u)),
          (X = n(u, "DIV", { class: !0 }));
        var ee = c(X);
        (Z = b(ee, ae)),
          ee.forEach(s),
          (k = m(u)),
          (E = n(u, "DIV", { class: !0 }));
        var me = c(E);
        (F = b(me, "£")),
          (W = b(me, oe)),
          (de = b(me, "m")),
          me.forEach(s),
          u.forEach(s),
          (ve = m(A)),
          A.forEach(s),
          this.h();
      },
      h() {
        a(l, "class", "flex items-center w-1/2 px-3"),
          a(H, "class", "flex items-center w-1/2 px-3"),
          a(Q, "class", "flex items-center w-1/2 px-3"),
          a(te, "class", "flex items-center w-1/2 px-3"),
          a(se, "class", "flex items-center w-1/2 px-3"),
          a(q, "class", "flex items-center w-1/2 px-3"),
          a(X, "class", "flex items-center w-1/2 px-3"),
          a(E, "class", "flex items-center w-1/2 px-3"),
          a(
            o,
            "class",
            "flex-grow flex items-center justify-start space-x-2 px-4"
          ),
          a(o, "href", (le = `/player?id=${r[5].id}`)),
          a(
            t,
            "class",
            "flex items-center justify-between py-2 border-b border-gray-700 text-white cursor-pointer"
          );
      },
      m(p, A) {
        Me(p, t, A),
          e(t, o),
          e(o, l),
          e(l, d),
          e(o, T),
          e(o, H),
          e(H, h),
          e(o, P),
          e(o, Q),
          e(Q, w),
          e(o, O),
          e(o, te),
          e(te, N),
          e(o, J),
          e(o, se),
          e(se, M),
          e(o, ne),
          e(o, q),
          C && Ce(C, q, null),
          e(o, re),
          e(o, X),
          e(X, Z),
          e(o, k),
          e(o, E),
          e(E, F),
          e(E, W),
          e(E, de),
          e(t, ve),
          (z = !0);
      },
      p(p, A) {
        if (
          ((!z || A & 2) &&
            f !==
              (f = (p[5].shirtNumber === 0 ? "-" : p[5].shirtNumber) + "") &&
            ue(d, f),
          (!z || A & 2) &&
            _ !== (_ = (p[5].firstName === "" ? "-" : p[5].firstName) + "") &&
            ue(h, _),
          (!z || A & 2) && S !== (S = p[5].lastName + "") && ue(w, S),
          (!z || A & 2) && Y !== (Y = kt(p[5].position) + "") && ue(N, Y),
          (!z || A & 2) &&
            G !== (G = ia(Number(p[5].dateOfBirth)) + "") &&
            ue(M, G),
          A & 2 && ie !== (ie = na(p[5].nationality)))
        ) {
          if (C) {
            Ht();
            const u = C;
            ge(u.$$.fragment, 1, 0, () => {
              Pe(u, 1);
            }),
              At();
          }
          ie
            ? ((C = ra(ie, ce())),
              Te(C.$$.fragment),
              _e(C.$$.fragment, 1),
              Ce(C, q, null))
            : (C = null);
        }
        (!z || A & 2) && ae !== (ae = p[5].totalPoints + "") && ue(Z, ae),
          (!z || A & 2) &&
            oe !== (oe = (Number(p[5].value) / 4).toFixed(2) + "") &&
            ue(W, oe),
          (!z || (A & 2 && le !== (le = `/player?id=${p[5].id}`))) &&
            a(o, "href", le);
      },
      i(p) {
        z || (C && _e(C.$$.fragment, p), (z = !0));
      },
      o(p) {
        C && ge(C.$$.fragment, p), (z = !1);
      },
      d(p) {
        p && s(t), C && Pe(C);
      },
    }
  );
}
function Ha(r) {
  let t,
    o,
    l,
    f,
    d,
    T,
    H,
    _,
    h,
    P,
    Q,
    S,
    w,
    O,
    te,
    Y,
    N,
    J,
    se,
    G,
    M,
    ne,
    q,
    C,
    re,
    X,
    ae,
    Z,
    k,
    E,
    F,
    oe,
    W,
    de,
    le,
    ve,
    z,
    ie,
    ce,
    p,
    A = r[2],
    u = [];
  for (let y = 0; y < A.length; y += 1) u[y] = ha(ma(r, A, y));
  let L = r[1],
    x = [];
  for (let y = 0; y < L.length; y += 1) x[y] = _a(va(r, L, y));
  const R = (y) =>
    ge(x[y], 1, 1, () => {
      x[y] = null;
    });
  return {
    c() {
      (t = i("div")),
        (o = i("div")),
        (l = i("div")),
        (f = i("div")),
        (d = i("div")),
        (T = i("p")),
        (H = g("Position:")),
        (_ = v()),
        (h = i("select")),
        (P = i("option")),
        (Q = g("All"));
      for (let y = 0; y < u.length; y += 1) u[y].c();
      (S = v()),
        (w = i("div")),
        (O = i("div")),
        (te = g("Number")),
        (Y = v()),
        (N = i("div")),
        (J = g("First Name")),
        (se = v()),
        (G = i("div")),
        (M = g("Last Name")),
        (ne = v()),
        (q = i("div")),
        (C = g("Position")),
        (re = v()),
        (X = i("div")),
        (ae = g("Age")),
        (Z = v()),
        (k = i("div")),
        (E = g("Nationality")),
        (F = v()),
        (oe = i("div")),
        (W = g("Season Points")),
        (de = v()),
        (le = i("div")),
        (ve = g("Value")),
        (z = v());
      for (let y = 0; y < x.length; y += 1) x[y].c();
      this.h();
    },
    l(y) {
      t = n(y, "DIV", { class: !0 });
      var j = c(t);
      o = n(j, "DIV", { class: !0 });
      var I = c(o);
      l = n(I, "DIV", {});
      var ee = c(l);
      f = n(ee, "DIV", { class: !0 });
      var me = c(f);
      d = n(me, "DIV", { class: !0 });
      var K = c(d);
      T = n(K, "P", { class: !0 });
      var V = c(T);
      (H = b(V, "Position:")),
        V.forEach(s),
        (_ = m(K)),
        (h = n(K, "SELECT", { class: !0 }));
      var $ = c(h);
      P = n($, "OPTION", {});
      var pe = c(P);
      (Q = b(pe, "All")), pe.forEach(s);
      for (let fe = 0; fe < u.length; fe += 1) u[fe].l($);
      $.forEach(s),
        K.forEach(s),
        me.forEach(s),
        (S = m(ee)),
        (w = n(ee, "DIV", { class: !0 }));
      var B = c(w);
      O = n(B, "DIV", { class: !0 });
      var $e = c(O);
      (te = b($e, "Number")),
        $e.forEach(s),
        (Y = m(B)),
        (N = n(B, "DIV", { class: !0 }));
      var xe = c(N);
      (J = b(xe, "First Name")),
        xe.forEach(s),
        (se = m(B)),
        (G = n(B, "DIV", { class: !0 }));
      var De = c(G);
      (M = b(De, "Last Name")),
        De.forEach(s),
        (ne = m(B)),
        (q = n(B, "DIV", { class: !0 }));
      var be = c(q);
      (C = b(be, "Position")),
        be.forEach(s),
        (re = m(B)),
        (X = n(B, "DIV", { class: !0 }));
      var ye = c(X);
      (ae = b(ye, "Age")),
        ye.forEach(s),
        (Z = m(B)),
        (k = n(B, "DIV", { class: !0 }));
      var je = c(k);
      (E = b(je, "Nationality")),
        je.forEach(s),
        (F = m(B)),
        (oe = n(B, "DIV", { class: !0 }));
      var Le = c(oe);
      (W = b(Le, "Season Points")),
        Le.forEach(s),
        (de = m(B)),
        (le = n(B, "DIV", { class: !0 }));
      var Ve = c(le);
      (ve = b(Ve, "Value")), Ve.forEach(s), B.forEach(s), (z = m(ee));
      for (let fe = 0; fe < x.length; fe += 1) x[fe].l(ee);
      ee.forEach(s), I.forEach(s), j.forEach(s), this.h();
    },
    h() {
      a(T, "class", "text-sm md:text-xl mr-4"),
        (P.__value = -1),
        (P.value = P.__value),
        a(h, "class", "p-2 fpl-dropdown text-sm md:text-xl"),
        r[0] === void 0 && ba(() => r[4].call(h)),
        a(d, "class", "flex items-center ml-4"),
        a(f, "class", "flex p-4"),
        a(O, "class", "flex-grow px-4 w-1/2"),
        a(N, "class", "flex-grow px-4 w-1/2"),
        a(G, "class", "flex-grow px-4 w-1/2"),
        a(q, "class", "flex-grow px-4 w-1/2"),
        a(X, "class", "flex-grow px-4 w-1/2"),
        a(k, "class", "flex-grow px-4 w-1/2"),
        a(oe, "class", "flex-grow px-4 w-1/2"),
        a(le, "class", "flex-grow px-4 w-1/2"),
        a(
          w,
          "class",
          "flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
        ),
        a(o, "class", "flex flex-col space-y-4"),
        a(t, "class", "container-fluid");
    },
    m(y, j) {
      Me(y, t, j),
        e(t, o),
        e(o, l),
        e(l, f),
        e(f, d),
        e(d, T),
        e(T, H),
        e(d, _),
        e(d, h),
        e(h, P),
        e(P, Q);
      for (let I = 0; I < u.length; I += 1) u[I] && u[I].m(h, null);
      Yt(h, r[0], !0),
        e(l, S),
        e(l, w),
        e(w, O),
        e(O, te),
        e(w, Y),
        e(w, N),
        e(N, J),
        e(w, se),
        e(w, G),
        e(G, M),
        e(w, ne),
        e(w, q),
        e(q, C),
        e(w, re),
        e(w, X),
        e(X, ae),
        e(w, Z),
        e(w, k),
        e(k, E),
        e(w, F),
        e(w, oe),
        e(oe, W),
        e(w, de),
        e(w, le),
        e(le, ve),
        e(l, z);
      for (let I = 0; I < x.length; I += 1) x[I] && x[I].m(l, null);
      (ie = !0), ce || ((p = Zt(h, "change", r[4])), (ce = !0));
    },
    p(y, [j]) {
      if (j & 4) {
        A = y[2];
        let I;
        for (I = 0; I < A.length; I += 1) {
          const ee = ma(y, A, I);
          u[I] ? u[I].p(ee, j) : ((u[I] = ha(ee)), u[I].c(), u[I].m(h, null));
        }
        for (; I < u.length; I += 1) u[I].d(1);
        u.length = A.length;
      }
      if ((j & 5 && Yt(h, y[0]), j & 2)) {
        L = y[1];
        let I;
        for (I = 0; I < L.length; I += 1) {
          const ee = va(y, L, I);
          x[I]
            ? (x[I].p(ee, j), _e(x[I], 1))
            : ((x[I] = _a(ee)), x[I].c(), _e(x[I], 1), x[I].m(l, null));
        }
        for (Ht(), I = L.length; I < x.length; I += 1) R(I);
        At();
      }
    },
    i(y) {
      if (!ie) {
        for (let j = 0; j < L.length; j += 1) _e(x[j]);
        ie = !0;
      }
    },
    o(y) {
      x = x.filter(Boolean);
      for (let j = 0; j < x.length; j += 1) ge(x[j]);
      ie = !1;
    },
    d(y) {
      y && s(t), bl(u, y), bl(x, y), (ce = !1), p();
    },
  };
}
function Aa(r, t, o) {
  let l,
    { players: f = [] } = t,
    d = -1,
    T = Object.values(Va).filter((_) => typeof _ == "number");
  function H() {
    (d = ya(this)), o(0, d), o(2, T);
  }
  return (
    (r.$$set = (_) => {
      "players" in _ && o(3, (f = _.players));
    }),
    (r.$$.update = () => {
      r.$$.dirty & 9 &&
        o(1, (l = d === -1 ? f : f.filter((_) => _.position === d)));
    }),
    [d, l, T, f, H]
  );
}
class Sa extends xl {
  constructor(t) {
    super(), yl(this, t, Aa, Ha, wl, { players: 3 });
  }
}
function pa(r, t, o) {
  const l = r.slice();
  return (
    (l[10] = t[o].fixture), (l[11] = t[o].homeTeam), (l[12] = t[o].awayTeam), l
  );
}
function ga(r) {
  let t,
    o,
    l = r[10].gameweek + "",
    f,
    d,
    T,
    H,
    _,
    h,
    P,
    Q,
    S,
    w,
    O,
    te,
    Y,
    N,
    J,
    se,
    G,
    M = ca(Number(r[10].kickOff)) + "",
    ne,
    q,
    C,
    re = fa(Number(r[10].kickOff)) + "",
    X,
    ae,
    Z,
    k,
    E,
    F = (r[11] ? r[11].friendlyName : "") + "",
    oe,
    W,
    de,
    le,
    ve = (r[12] ? r[12].friendlyName : "") + "",
    z,
    ie,
    ce,
    p,
    A,
    u,
    L = (r[10].status === 0 ? "-" : r[10].homeGoals) + "",
    x,
    R,
    y,
    j = (r[10].status === 0 ? "-" : r[10].awayGoals) + "",
    I,
    ee,
    me,
    K;
  return (
    (h = new Nt({
      props: {
        primaryColour: r[11] ? r[11].primaryColourHex : "",
        secondaryColour: r[11] ? r[11].secondaryColourHex : "",
        thirdColour: r[11] ? r[11].thirdColourHex : "",
      },
    })),
    (N = new Nt({
      props: {
        primaryColour: r[12] ? r[12].primaryColourHex : "",
        secondaryColour: r[12] ? r[12].secondaryColourHex : "",
        thirdColour: r[12] ? r[12].thirdColourHex : "",
      },
    })),
    {
      c() {
        (t = i("div")),
          (o = i("div")),
          (f = g(l)),
          (d = v()),
          (T = i("div")),
          (H = i("div")),
          (_ = i("a")),
          Te(h.$$.fragment),
          (Q = v()),
          (S = i("span")),
          (w = g("v")),
          (O = v()),
          (te = i("div")),
          (Y = i("a")),
          Te(N.$$.fragment),
          (se = v()),
          (G = i("div")),
          (ne = g(M)),
          (q = v()),
          (C = i("div")),
          (X = g(re)),
          (ae = v()),
          (Z = i("div")),
          (k = i("div")),
          (E = i("a")),
          (oe = g(F)),
          (de = v()),
          (le = i("a")),
          (z = g(ve)),
          (ce = v()),
          (p = i("div")),
          (A = i("div")),
          (u = i("span")),
          (x = g(L)),
          (R = v()),
          (y = i("span")),
          (I = g(j)),
          (ee = v()),
          this.h();
      },
      l(V) {
        t = n(V, "DIV", { class: !0 });
        var $ = c(t);
        o = n($, "DIV", { class: !0 });
        var pe = c(o);
        (f = b(pe, l)),
          pe.forEach(s),
          (d = m($)),
          (T = n($, "DIV", { class: !0 }));
        var B = c(T);
        H = n(B, "DIV", { class: !0 });
        var $e = c(H);
        _ = n($e, "A", { href: !0 });
        var xe = c(_);
        ke(h.$$.fragment, xe),
          xe.forEach(s),
          $e.forEach(s),
          (Q = m(B)),
          (S = n(B, "SPAN", { class: !0 }));
        var De = c(S);
        (w = b(De, "v")),
          De.forEach(s),
          (O = m(B)),
          (te = n(B, "DIV", { class: !0 }));
        var be = c(te);
        Y = n(be, "A", { href: !0 });
        var ye = c(Y);
        ke(N.$$.fragment, ye),
          ye.forEach(s),
          be.forEach(s),
          B.forEach(s),
          (se = m($)),
          (G = n($, "DIV", { class: !0 }));
        var je = c(G);
        (ne = b(je, M)),
          je.forEach(s),
          (q = m($)),
          (C = n($, "DIV", { class: !0 }));
        var Le = c(C);
        (X = b(Le, re)),
          Le.forEach(s),
          (ae = m($)),
          (Z = n($, "DIV", { class: !0 }));
        var Ve = c(Z);
        k = n(Ve, "DIV", { class: !0 });
        var fe = c(k);
        E = n(fe, "A", { href: !0 });
        var Ge = c(E);
        (oe = b(Ge, F)),
          Ge.forEach(s),
          (de = m(fe)),
          (le = n(fe, "A", { href: !0 }));
        var He = c(le);
        (z = b(He, ve)),
          He.forEach(s),
          fe.forEach(s),
          Ve.forEach(s),
          (ce = m($)),
          (p = n($, "DIV", { class: !0 }));
        var Ne = c(p);
        A = n(Ne, "DIV", { class: !0 });
        var Be = c(A);
        u = n(Be, "SPAN", {});
        var nt = c(u);
        (x = b(nt, L)), nt.forEach(s), (R = m(Be)), (y = n(Be, "SPAN", {}));
        var Ue = c(y);
        (I = b(Ue, j)),
          Ue.forEach(s),
          Be.forEach(s),
          Ne.forEach(s),
          (ee = m($)),
          $.forEach(s),
          this.h();
      },
      h() {
        a(o, "class", "w-1/6 ml-4"),
          a(_, "href", (P = `/club?id=${r[10].homeTeamId}`)),
          a(H, "class", "w-10 items-center justify-center mr-4"),
          a(S, "class", "font-bold text-lg"),
          a(Y, "href", (J = `/club?id=${r[10].awayTeamId}`)),
          a(te, "class", "w-10 items-center justify-center ml-4"),
          a(T, "class", "w-1/3 flex justify-center"),
          a(G, "class", "w-1/3"),
          a(C, "class", "w-1/4 text-center"),
          a(E, "href", (W = `/club?id=${r[10].homeTeamId}`)),
          a(le, "href", (ie = `/club?id=${r[10].awayTeamId}`)),
          a(k, "class", "flex flex-col text-xs md:text-base"),
          a(Z, "class", "w-1/3"),
          a(A, "class", "flex flex-col text-xs md:text-base"),
          a(p, "class", "w-1/4 mr-4"),
          a(
            t,
            "class",
            (me = `flex items-center justify-between border-b border-gray-700 p-2 px-4  
          ${r[10].status === 0 ? "text-gray-400" : "text-white"}`)
          );
      },
      m(V, $) {
        Me(V, t, $),
          e(t, o),
          e(o, f),
          e(t, d),
          e(t, T),
          e(T, H),
          e(H, _),
          Ce(h, _, null),
          e(T, Q),
          e(T, S),
          e(S, w),
          e(T, O),
          e(T, te),
          e(te, Y),
          Ce(N, Y, null),
          e(t, se),
          e(t, G),
          e(G, ne),
          e(t, q),
          e(t, C),
          e(C, X),
          e(t, ae),
          e(t, Z),
          e(Z, k),
          e(k, E),
          e(E, oe),
          e(k, de),
          e(k, le),
          e(le, z),
          e(t, ce),
          e(t, p),
          e(p, A),
          e(A, u),
          e(u, x),
          e(A, R),
          e(A, y),
          e(y, I),
          e(t, ee),
          (K = !0);
      },
      p(V, $) {
        (!K || $ & 2) && l !== (l = V[10].gameweek + "") && ue(f, l);
        const pe = {};
        $ & 2 && (pe.primaryColour = V[11] ? V[11].primaryColourHex : ""),
          $ & 2 && (pe.secondaryColour = V[11] ? V[11].secondaryColourHex : ""),
          $ & 2 && (pe.thirdColour = V[11] ? V[11].thirdColourHex : ""),
          h.$set(pe),
          (!K || ($ & 2 && P !== (P = `/club?id=${V[10].homeTeamId}`))) &&
            a(_, "href", P);
        const B = {};
        $ & 2 && (B.primaryColour = V[12] ? V[12].primaryColourHex : ""),
          $ & 2 && (B.secondaryColour = V[12] ? V[12].secondaryColourHex : ""),
          $ & 2 && (B.thirdColour = V[12] ? V[12].thirdColourHex : ""),
          N.$set(B),
          (!K || ($ & 2 && J !== (J = `/club?id=${V[10].awayTeamId}`))) &&
            a(Y, "href", J),
          (!K || $ & 2) &&
            M !== (M = ca(Number(V[10].kickOff)) + "") &&
            ue(ne, M),
          (!K || $ & 2) &&
            re !== (re = fa(Number(V[10].kickOff)) + "") &&
            ue(X, re),
          (!K || $ & 2) &&
            F !== (F = (V[11] ? V[11].friendlyName : "") + "") &&
            ue(oe, F),
          (!K || ($ & 2 && W !== (W = `/club?id=${V[10].homeTeamId}`))) &&
            a(E, "href", W),
          (!K || $ & 2) &&
            ve !== (ve = (V[12] ? V[12].friendlyName : "") + "") &&
            ue(z, ve),
          (!K || ($ & 2 && ie !== (ie = `/club?id=${V[10].awayTeamId}`))) &&
            a(le, "href", ie),
          (!K || $ & 2) &&
            L !== (L = (V[10].status === 0 ? "-" : V[10].homeGoals) + "") &&
            ue(x, L),
          (!K || $ & 2) &&
            j !== (j = (V[10].status === 0 ? "-" : V[10].awayGoals) + "") &&
            ue(I, j),
          (!K ||
            ($ & 2 &&
              me !==
                (me = `flex items-center justify-between border-b border-gray-700 p-2 px-4  
          ${V[10].status === 0 ? "text-gray-400" : "text-white"}`))) &&
            a(t, "class", me);
      },
      i(V) {
        K || (_e(h.$$.fragment, V), _e(N.$$.fragment, V), (K = !0));
      },
      o(V) {
        ge(h.$$.fragment, V), ge(N.$$.fragment, V), (K = !1);
      },
      d(V) {
        V && s(t), Pe(h), Pe(N);
      },
    }
  );
}
function Oa(r) {
  let t,
    o,
    l,
    f,
    d,
    T,
    H,
    _,
    h,
    P,
    Q,
    S,
    w,
    O,
    te,
    Y,
    N,
    J,
    se,
    G,
    M,
    ne,
    q,
    C,
    re,
    X,
    ae,
    Z,
    k,
    E,
    F,
    oe,
    W,
    de,
    le,
    ve,
    z,
    ie,
    ce = r[1],
    p = [];
  for (let u = 0; u < ce.length; u += 1) p[u] = ga(pa(r, ce, u));
  const A = (u) =>
    ge(p[u], 1, 1, () => {
      p[u] = null;
    });
  return {
    c() {
      (t = i("div")),
        (o = i("div")),
        (l = i("div")),
        (f = i("div")),
        (d = i("div")),
        (T = i("p")),
        (H = g("Type:")),
        (_ = v()),
        (h = i("select")),
        (P = i("option")),
        (Q = g("All")),
        (S = i("option")),
        (w = g("Home")),
        (O = i("option")),
        (te = g("Away")),
        (Y = v()),
        (N = i("div")),
        (J = i("div")),
        (se = g("Gameweek")),
        (G = v()),
        (M = i("div")),
        (ne = g("Game")),
        (q = v()),
        (C = i("div")),
        (re = g("Date")),
        (X = v()),
        (ae = i("div")),
        (Z = g("Time")),
        (k = v()),
        (E = i("div")),
        (F = g("Teams")),
        (oe = v()),
        (W = i("div")),
        (de = g("Result")),
        (le = v());
      for (let u = 0; u < p.length; u += 1) p[u].c();
      this.h();
    },
    l(u) {
      t = n(u, "DIV", { class: !0 });
      var L = c(t);
      o = n(L, "DIV", { class: !0 });
      var x = c(o);
      l = n(x, "DIV", {});
      var R = c(l);
      f = n(R, "DIV", { class: !0 });
      var y = c(f);
      d = n(y, "DIV", { class: !0 });
      var j = c(d);
      T = n(j, "P", { class: !0 });
      var I = c(T);
      (H = b(I, "Type:")),
        I.forEach(s),
        (_ = m(j)),
        (h = n(j, "SELECT", { class: !0 }));
      var ee = c(h);
      P = n(ee, "OPTION", {});
      var me = c(P);
      (Q = b(me, "All")), me.forEach(s), (S = n(ee, "OPTION", {}));
      var K = c(S);
      (w = b(K, "Home")), K.forEach(s), (O = n(ee, "OPTION", {}));
      var V = c(O);
      (te = b(V, "Away")),
        V.forEach(s),
        ee.forEach(s),
        j.forEach(s),
        y.forEach(s),
        (Y = m(R)),
        (N = n(R, "DIV", { class: !0 }));
      var $ = c(N);
      J = n($, "DIV", { class: !0 });
      var pe = c(J);
      (se = b(pe, "Gameweek")),
        pe.forEach(s),
        (G = m($)),
        (M = n($, "DIV", { class: !0 }));
      var B = c(M);
      (ne = b(B, "Game")),
        B.forEach(s),
        (q = m($)),
        (C = n($, "DIV", { class: !0 }));
      var $e = c(C);
      (re = b($e, "Date")),
        $e.forEach(s),
        (X = m($)),
        (ae = n($, "DIV", { class: !0 }));
      var xe = c(ae);
      (Z = b(xe, "Time")),
        xe.forEach(s),
        (k = m($)),
        (E = n($, "DIV", { class: !0 }));
      var De = c(E);
      (F = b(De, "Teams")),
        De.forEach(s),
        (oe = m($)),
        (W = n($, "DIV", { class: !0 }));
      var be = c(W);
      (de = b(be, "Result")), be.forEach(s), $.forEach(s), (le = m(R));
      for (let ye = 0; ye < p.length; ye += 1) p[ye].l(R);
      R.forEach(s), x.forEach(s), L.forEach(s), this.h();
    },
    h() {
      a(T, "class", "text-sm md:text-xl mr-4"),
        (P.__value = -1),
        (P.value = P.__value),
        (S.__value = 0),
        (S.value = S.__value),
        (O.__value = 1),
        (O.value = O.__value),
        a(h, "class", "p-2 fpl-dropdown text-sm md:text-xl"),
        r[0] === void 0 && ba(() => r[4].call(h)),
        a(d, "class", "flex items-center ml-4"),
        a(f, "class", "flex p-4"),
        a(J, "class", "flex-grow w-1/6 ml-4"),
        a(M, "class", "flex-grow w-1/3 text-center"),
        a(C, "class", "flex-grow w-1/3"),
        a(ae, "class", "flex-grow w-1/4 text-center"),
        a(E, "class", "flex-grow w-1/3"),
        a(W, "class", "flex-grow w-1/4 mr-4"),
        a(
          N,
          "class",
          "flex justify-between p-2 border border-gray-700 py-4 bg-light-gray px-4"
        ),
        a(o, "class", "flex flex-col space-y-4"),
        a(t, "class", "container-fluid");
    },
    m(u, L) {
      Me(u, t, L),
        e(t, o),
        e(o, l),
        e(l, f),
        e(f, d),
        e(d, T),
        e(T, H),
        e(d, _),
        e(d, h),
        e(h, P),
        e(P, Q),
        e(h, S),
        e(S, w),
        e(h, O),
        e(O, te),
        Yt(h, r[0], !0),
        e(l, Y),
        e(l, N),
        e(N, J),
        e(J, se),
        e(N, G),
        e(N, M),
        e(M, ne),
        e(N, q),
        e(N, C),
        e(C, re),
        e(N, X),
        e(N, ae),
        e(ae, Z),
        e(N, k),
        e(N, E),
        e(E, F),
        e(N, oe),
        e(N, W),
        e(W, de),
        e(l, le);
      for (let x = 0; x < p.length; x += 1) p[x] && p[x].m(l, null);
      (ve = !0), z || ((ie = Zt(h, "change", r[4])), (z = !0));
    },
    p(u, [L]) {
      if ((L & 1 && Yt(h, u[0]), L & 2)) {
        ce = u[1];
        let x;
        for (x = 0; x < ce.length; x += 1) {
          const R = pa(u, ce, x);
          p[x]
            ? (p[x].p(R, L), _e(p[x], 1))
            : ((p[x] = ga(R)), p[x].c(), _e(p[x], 1), p[x].m(l, null));
        }
        for (Ht(), x = ce.length; x < p.length; x += 1) A(x);
        At();
      }
    },
    i(u) {
      if (!ve) {
        for (let L = 0; L < ce.length; L += 1) _e(p[L]);
        ve = !0;
      }
    },
    o(u) {
      p = p.filter(Boolean);
      for (let L = 0; L < p.length; L += 1) ge(p[L]);
      ve = !1;
    },
    d(u) {
      u && s(t), bl(p, u), (z = !1), ie();
    },
  };
}
function Fa(r, t, o) {
  let l,
    { clubId: f = null } = t,
    d = [],
    T = [],
    H = [],
    _ = -1,
    h,
    P;
  wa(async () => {
    try {
      await el.sync(),
        await tl.sync(),
        (h = el.subscribe((w) => {
          d = w;
        })),
        (P = tl.subscribe((w) => {
          (T = w),
            o(
              3,
              (H = T.map((O) => ({
                fixture: O,
                homeTeam: Q(O.homeTeamId),
                awayTeam: Q(O.awayTeamId),
              })))
            );
        }));
    } catch (w) {
      Ia.show("Error fetching team fixtures.", "error"),
        console.error("Error fetching team fixtures:", w);
    } finally {
    }
  }),
    Ea(() => {
      h?.(), P?.();
    });
  function Q(w) {
    return d.find((O) => O.id === w);
  }
  function S() {
    (_ = ya(this)), o(0, _);
  }
  return (
    (r.$$set = (w) => {
      "clubId" in w && o(2, (f = w.clubId));
    }),
    (r.$$.update = () => {
      r.$$.dirty & 13 &&
        o(
          1,
          (l =
            _ === -1
              ? H.filter(
                  ({ fixture: w }) =>
                    f === null || w.homeTeamId === f || w.awayTeamId === f
                )
              : _ === 0
              ? H.filter(({ fixture: w }) => f === null || w.homeTeamId === f)
              : H.filter(({ fixture: w }) => f === null || w.awayTeamId === f))
        );
    }),
    [_, l, f, H, S]
  );
}
class ja extends xl {
  constructor(t) {
    super(), yl(this, t, Fa, Oa, wl, { clubId: 2 });
  }
}
function La(r) {
  let t,
    o,
    l,
    f,
    d,
    T = tt?.friendlyName + "",
    H,
    _,
    h,
    P,
    Q,
    S,
    w,
    O,
    te = tt?.abbreviatedName + "",
    Y,
    N,
    J,
    se,
    G,
    M,
    ne,
    q,
    C,
    re = r[1].length + "",
    X,
    ae,
    Z,
    k,
    E,
    F,
    oe,
    W,
    de,
    le,
    ve,
    z,
    ie = r[9](r[7]) + "",
    ce,
    p,
    A,
    u = r[0].name + "",
    L,
    x,
    R,
    y,
    j,
    I,
    ee,
    me,
    K = r[10](r[7]) + "",
    V,
    $,
    pe,
    B,
    $e,
    xe,
    De,
    be,
    ye,
    je,
    Le,
    Ve,
    fe,
    Ge,
    He,
    Ne,
    Be,
    nt,
    Ue,
    ct,
    ll,
    al,
    ft,
    lt,
    We,
    St,
    sl,
    Ae,
    ut,
    dt,
    Je,
    It = r[2]?.abbreviatedName + "",
    Ot,
    Ft,
    rl,
    $t,
    ol,
    vt,
    mt,
    Ke,
    Dt = r[3]?.abbreviatedName + "",
    jt,
    Lt,
    il,
    at,
    nl,
    Se,
    ht,
    cl,
    fl,
    _t,
    st,
    Vt = r[4]?.lastName + "",
    Gt,
    Bt,
    ul,
    qe,
    Tt = kt(r[4]?.position ?? 0) + "",
    Ut,
    dl,
    Ct = r[4]?.totalPoints + "",
    qt,
    vl,
    Rt,
    rt,
    Re,
    Qe,
    ot,
    Xe,
    ml,
    zt,
    Mt,
    hl,
    it,
    Ye,
    _l,
    Wt,
    Jt,
    pl,
    we,
    Ee,
    he,
    gl,
    El;
  (P = new Nt({
    props: {
      className: "h-10",
      primaryColour: tt?.primaryColourHex,
      secondaryColour: tt?.secondaryColourHex,
      thirdColour: tt?.thirdColourHex,
    },
  })),
    (S = new ka({
      props: {
        className: "h-10",
        primaryColour: tt?.primaryColourHex,
        secondaryColour: tt?.secondaryColourHex,
        thirdColour: tt?.thirdColourHex,
      },
    })),
    (Ne = new Nt({
      props: {
        primaryColour: r[2]?.primaryColourHex,
        secondaryColour: r[2]?.secondaryColourHex,
        thirdColour: r[2]?.thirdColourHex,
      },
    })),
    (We = new Nt({
      props: {
        primaryColour: r[3]?.primaryColourHex,
        secondaryColour: r[3]?.secondaryColourHex,
        thirdColour: r[3]?.thirdColourHex,
      },
    }));
  const Il = [Ua, Ba],
    Ze = [];
  function $l(D, U) {
    return D[5] === "players" ? 0 : D[5] === "fixtures" ? 1 : -1;
  }
  return (
    ~(we = $l(r)) && (Ee = Ze[we] = Il[we](r)),
    {
      c() {
        (t = i("div")),
          (o = i("div")),
          (l = i("div")),
          (f = i("div")),
          (d = i("p")),
          (H = g(T)),
          (_ = v()),
          (h = i("div")),
          Te(P.$$.fragment),
          (Q = v()),
          Te(S.$$.fragment),
          (w = v()),
          (O = i("p")),
          (Y = g(te)),
          (N = v()),
          (J = i("div")),
          (se = v()),
          (G = i("div")),
          (M = i("p")),
          (ne = g("Players")),
          (q = v()),
          (C = i("p")),
          (X = g(re)),
          (ae = v()),
          (Z = i("p")),
          (k = g("Total")),
          (E = v()),
          (F = i("div")),
          (oe = v()),
          (W = i("div")),
          (de = i("p")),
          (le = g("League Position")),
          (ve = v()),
          (z = i("p")),
          (ce = g(ie)),
          (p = v()),
          (A = i("p")),
          (L = g(u)),
          (x = v()),
          (R = i("div")),
          (y = i("div")),
          (j = i("p")),
          (I = g("League Points")),
          (ee = v()),
          (me = i("p")),
          (V = g(K)),
          ($ = v()),
          (pe = i("p")),
          (B = g("Total")),
          ($e = v()),
          (xe = i("div")),
          (De = v()),
          (be = i("div")),
          (ye = i("p")),
          (je = g("Next Game:")),
          (Le = v()),
          (Ve = i("div")),
          (fe = i("div")),
          (Ge = i("div")),
          (He = i("a")),
          Te(Ne.$$.fragment),
          (nt = v()),
          (Ue = i("div")),
          (ct = i("p")),
          (ll = g("v")),
          (al = v()),
          (ft = i("div")),
          (lt = i("a")),
          Te(We.$$.fragment),
          (sl = v()),
          (Ae = i("div")),
          (ut = i("div")),
          (dt = i("p")),
          (Je = i("a")),
          (Ot = g(It)),
          (rl = v()),
          ($t = i("div")),
          (ol = v()),
          (vt = i("div")),
          (mt = i("p")),
          (Ke = i("a")),
          (jt = g(Dt)),
          (il = v()),
          (at = i("div")),
          (nl = v()),
          (Se = i("div")),
          (ht = i("p")),
          (cl = g("Highest Scoring Player")),
          (fl = v()),
          (_t = i("p")),
          (st = i("a")),
          (Gt = g(Vt)),
          (ul = v()),
          (qe = i("p")),
          (Ut = g(Tt)),
          (dl = g(`
              (`)),
          (qt = g(Ct)),
          (vl = g(")")),
          (Rt = v()),
          (rt = i("div")),
          (Re = i("div")),
          (Qe = i("ul")),
          (ot = i("li")),
          (Xe = i("button")),
          (ml = g("Players")),
          (hl = v()),
          (it = i("li")),
          (Ye = i("button")),
          (_l = g("Fixtures")),
          (pl = v()),
          Ee && Ee.c(),
          this.h();
      },
      l(D) {
        t = n(D, "DIV", { class: !0 });
        var U = c(t);
        o = n(U, "DIV", { class: !0 });
        var ze = c(o);
        l = n(ze, "DIV", { class: !0 });
        var Ie = c(l);
        f = n(Ie, "DIV", { class: !0 });
        var Oe = c(f);
        d = n(Oe, "P", { class: !0 });
        var Dl = c(d);
        (H = b(Dl, T)),
          Dl.forEach(s),
          (_ = m(Oe)),
          (h = n(Oe, "DIV", { class: !0 }));
        var Kt = c(h);
        ke(P.$$.fragment, Kt),
          (Q = m(Kt)),
          ke(S.$$.fragment, Kt),
          Kt.forEach(s),
          (w = m(Oe)),
          (O = n(Oe, "P", { class: !0 }));
        var Vl = c(O);
        (Y = b(Vl, te)),
          Vl.forEach(s),
          Oe.forEach(s),
          (N = m(Ie)),
          (J = n(Ie, "DIV", { class: !0, style: !0 })),
          c(J).forEach(s),
          (se = m(Ie)),
          (G = n(Ie, "DIV", { class: !0 }));
        var pt = c(G);
        M = n(pt, "P", { class: !0 });
        var Tl = c(M);
        (ne = b(Tl, "Players")),
          Tl.forEach(s),
          (q = m(pt)),
          (C = n(pt, "P", { class: !0 }));
        var Cl = c(C);
        (X = b(Cl, re)),
          Cl.forEach(s),
          (ae = m(pt)),
          (Z = n(pt, "P", { class: !0 }));
        var Pl = c(Z);
        (k = b(Pl, "Total")),
          Pl.forEach(s),
          pt.forEach(s),
          (E = m(Ie)),
          (F = n(Ie, "DIV", { class: !0, style: !0 })),
          c(F).forEach(s),
          (oe = m(Ie)),
          (W = n(Ie, "DIV", { class: !0 }));
        var gt = c(W);
        de = n(gt, "P", { class: !0 });
        var Nl = c(de);
        (le = b(Nl, "League Position")),
          Nl.forEach(s),
          (ve = m(gt)),
          (z = n(gt, "P", { class: !0 }));
        var kl = c(z);
        (ce = b(kl, ie)),
          kl.forEach(s),
          (p = m(gt)),
          (A = n(gt, "P", { class: !0 }));
        var Hl = c(A);
        (L = b(Hl, u)),
          Hl.forEach(s),
          gt.forEach(s),
          Ie.forEach(s),
          (x = m(ze)),
          (R = n(ze, "DIV", { class: !0 }));
        var Fe = c(R);
        y = n(Fe, "DIV", { class: !0 });
        var bt = c(y);
        j = n(bt, "P", { class: !0 });
        var Al = c(j);
        (I = b(Al, "League Points")),
          Al.forEach(s),
          (ee = m(bt)),
          (me = n(bt, "P", { class: !0 }));
        var Sl = c(me);
        (V = b(Sl, K)),
          Sl.forEach(s),
          ($ = m(bt)),
          (pe = n(bt, "P", { class: !0 }));
        var Ol = c(pe);
        (B = b(Ol, "Total")),
          Ol.forEach(s),
          bt.forEach(s),
          ($e = m(Fe)),
          (xe = n(Fe, "DIV", { class: !0, style: !0 })),
          c(xe).forEach(s),
          (De = m(Fe)),
          (be = n(Fe, "DIV", { class: !0 }));
        var xt = c(be);
        ye = n(xt, "P", { class: !0 });
        var Fl = c(ye);
        (je = b(Fl, "Next Game:")),
          Fl.forEach(s),
          (Le = m(xt)),
          (Ve = n(xt, "DIV", { class: !0 }));
        var jl = c(Ve);
        fe = n(jl, "DIV", { class: !0 });
        var yt = c(fe);
        Ge = n(yt, "DIV", { class: !0 });
        var Ll = c(Ge);
        He = n(Ll, "A", { href: !0 });
        var Gl = c(He);
        ke(Ne.$$.fragment, Gl),
          Gl.forEach(s),
          Ll.forEach(s),
          (nt = m(yt)),
          (Ue = n(yt, "DIV", { class: !0 }));
        var Bl = c(Ue);
        ct = n(Bl, "P", { class: !0 });
        var Ul = c(ct);
        (ll = b(Ul, "v")),
          Ul.forEach(s),
          Bl.forEach(s),
          (al = m(yt)),
          (ft = n(yt, "DIV", { class: !0 }));
        var ql = c(ft);
        lt = n(ql, "A", { href: !0 });
        var Rl = c(lt);
        ke(We.$$.fragment, Rl),
          Rl.forEach(s),
          ql.forEach(s),
          yt.forEach(s),
          jl.forEach(s),
          (sl = m(xt)),
          (Ae = n(xt, "DIV", { class: !0 }));
        var wt = c(Ae);
        ut = n(wt, "DIV", { class: !0 });
        var zl = c(ut);
        dt = n(zl, "P", { class: !0 });
        var Ml = c(dt);
        Je = n(Ml, "A", { class: !0, href: !0 });
        var Wl = c(Je);
        (Ot = b(Wl, It)),
          Wl.forEach(s),
          Ml.forEach(s),
          zl.forEach(s),
          (rl = m(wt)),
          ($t = n(wt, "DIV", { class: !0 })),
          c($t).forEach(s),
          (ol = m(wt)),
          (vt = n(wt, "DIV", { class: !0 }));
        var Jl = c(vt);
        mt = n(Jl, "P", { class: !0 });
        var Kl = c(mt);
        Ke = n(Kl, "A", { class: !0, href: !0 });
        var Ql = c(Ke);
        (jt = b(Ql, Dt)),
          Ql.forEach(s),
          Kl.forEach(s),
          Jl.forEach(s),
          wt.forEach(s),
          xt.forEach(s),
          (il = m(Fe)),
          (at = n(Fe, "DIV", { class: !0, style: !0 })),
          c(at).forEach(s),
          (nl = m(Fe)),
          (Se = n(Fe, "DIV", { class: !0 }));
        var Et = c(Se);
        ht = n(Et, "P", { class: !0 });
        var Xl = c(ht);
        (cl = b(Xl, "Highest Scoring Player")),
          Xl.forEach(s),
          (fl = m(Et)),
          (_t = n(Et, "P", { class: !0 }));
        var Yl = c(_t);
        st = n(Yl, "A", { href: !0 });
        var Zl = c(st);
        (Gt = b(Zl, Vt)),
          Zl.forEach(s),
          Yl.forEach(s),
          (ul = m(Et)),
          (qe = n(Et, "P", { class: !0 }));
        var Pt = c(qe);
        (Ut = b(Pt, Tt)),
          (dl = b(
            Pt,
            `
              (`
          )),
          (qt = b(Pt, Ct)),
          (vl = b(Pt, ")")),
          Pt.forEach(s),
          Et.forEach(s),
          Fe.forEach(s),
          ze.forEach(s),
          U.forEach(s),
          (Rt = m(D)),
          (rt = n(D, "DIV", { class: !0 }));
        var ea = c(rt);
        Re = n(ea, "DIV", { class: !0 });
        var Qt = c(Re);
        Qe = n(Qt, "UL", { class: !0 });
        var Xt = c(Qe);
        ot = n(Xt, "LI", { class: !0 });
        var ta = c(ot);
        Xe = n(ta, "BUTTON", { class: !0 });
        var la = c(Xe);
        (ml = b(la, "Players")),
          la.forEach(s),
          ta.forEach(s),
          (hl = m(Xt)),
          (it = n(Xt, "LI", { class: !0 }));
        var aa = c(it);
        Ye = n(aa, "BUTTON", { class: !0 });
        var sa = c(Ye);
        (_l = b(sa, "Fixtures")),
          sa.forEach(s),
          aa.forEach(s),
          Xt.forEach(s),
          (pl = m(Qt)),
          Ee && Ee.l(Qt),
          Qt.forEach(s),
          ea.forEach(s),
          this.h();
      },
      h() {
        a(d, "class", "text-gray-300 text-xs"),
          a(h, "class", "py-2 flex space-x-4"),
          a(O, "class", "text-gray-300 text-xs"),
          a(f, "class", "flex-grow flex flex-col items-center"),
          a(J, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
          et(J, "min-width", "2px"),
          et(J, "min-height", "50px"),
          a(M, "class", "text-gray-300 text-xs"),
          a(C, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
          a(Z, "class", "text-gray-300 text-xs"),
          a(G, "class", "flex-grow"),
          a(F, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
          et(F, "min-width", "2px"),
          et(F, "min-height", "50px"),
          a(de, "class", "text-gray-300 text-xs"),
          a(z, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
          a(A, "class", "text-gray-300 text-xs"),
          a(W, "class", "flex-grow"),
          a(
            l,
            "class",
            "flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
          ),
          a(j, "class", "text-gray-300 text-xs"),
          a(
            me,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          a(pe, "class", "text-gray-300 text-xs"),
          a(y, "class", "flex-grow mb-4 md:mb-0"),
          a(
            xe,
            "class",
            "h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
          ),
          et(xe, "min-height", "2px"),
          et(xe, "min-width", "2px"),
          a(ye, "class", "text-gray-300 text-xs"),
          a(He, "href", (Be = `/club?id=${r[2]?.id}`)),
          a(Ge, "class", "w-10 ml-4 mr-4"),
          a(ct, "class", "text-xs mt-2 mb-2 font-bold"),
          a(Ue, "class", "w-v ml-1 mr-1 flex justify-center"),
          a(lt, "href", (St = `/club?id=${r[3]?.id}`)),
          a(ft, "class", "w-10 ml-4"),
          a(fe, "class", "flex justify-center items-center"),
          a(Ve, "class", "flex justify-center mb-2 mt-2"),
          a(Je, "class", "text-gray-300 text-xs text-center"),
          a(Je, "href", (Ft = `/club?id=${r[2]?.id}`)),
          a(dt, "class", "text-gray-300 text-xs text-center"),
          a(ut, "class", "w-10 ml-4 mr-4"),
          a($t, "class", "w-v ml-2 mr-2"),
          a(Ke, "class", "text-gray-300 text-xs text-center"),
          a(Ke, "href", (Lt = `/club?id=${r[3]?.id}`)),
          a(mt, "class", "text-gray-300 text-xs text-center"),
          a(vt, "class", "w-10 ml-4"),
          a(Ae, "class", "flex justify-center"),
          a(be, "class", "flex-grow mb-4 md:mb-0"),
          a(
            at,
            "class",
            "h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
          ),
          et(at, "min-height", "2px"),
          et(at, "min-width", "2px"),
          a(ht, "class", "text-gray-300 text-xs mt-4 md:mt-0"),
          a(st, "href", (Bt = `/player?id=${r[4]?.id}`)),
          a(
            _t,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          a(qe, "class", "text-gray-300 text-xs"),
          a(Se, "class", "flex-grow"),
          a(
            R,
            "class",
            "flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
          ),
          a(o, "class", "flex flex-col md:flex-row"),
          a(t, "class", "m-4"),
          a(
            Xe,
            "class",
            (zt = `p-2 ${r[5] === "players" ? "text-white" : "text-gray-400"}`)
          ),
          a(
            ot,
            "class",
            (Mt = `mr-4 text-xs md:text-base ${
              r[5] === "players" ? "active-tab" : ""
            }`)
          ),
          a(
            Ye,
            "class",
            (Wt = `p-2 ${r[5] === "fixtures" ? "text-white" : "text-gray-400"}`)
          ),
          a(
            it,
            "class",
            (Jt = `mr-4 text-xs md:text-base ${
              r[5] === "fixtures" ? "active-tab" : ""
            }`)
          ),
          a(Qe, "class", "flex bg-light-gray px-4 pt-2"),
          a(Re, "class", "bg-panel rounded-md m-4"),
          a(rt, "class", "m-4");
      },
      m(D, U) {
        Me(D, t, U),
          e(t, o),
          e(o, l),
          e(l, f),
          e(f, d),
          e(d, H),
          e(f, _),
          e(f, h),
          Ce(P, h, null),
          e(h, Q),
          Ce(S, h, null),
          e(f, w),
          e(f, O),
          e(O, Y),
          e(l, N),
          e(l, J),
          e(l, se),
          e(l, G),
          e(G, M),
          e(M, ne),
          e(G, q),
          e(G, C),
          e(C, X),
          e(G, ae),
          e(G, Z),
          e(Z, k),
          e(l, E),
          e(l, F),
          e(l, oe),
          e(l, W),
          e(W, de),
          e(de, le),
          e(W, ve),
          e(W, z),
          e(z, ce),
          e(W, p),
          e(W, A),
          e(A, L),
          e(o, x),
          e(o, R),
          e(R, y),
          e(y, j),
          e(j, I),
          e(y, ee),
          e(y, me),
          e(me, V),
          e(y, $),
          e(y, pe),
          e(pe, B),
          e(R, $e),
          e(R, xe),
          e(R, De),
          e(R, be),
          e(be, ye),
          e(ye, je),
          e(be, Le),
          e(be, Ve),
          e(Ve, fe),
          e(fe, Ge),
          e(Ge, He),
          Ce(Ne, He, null),
          e(fe, nt),
          e(fe, Ue),
          e(Ue, ct),
          e(ct, ll),
          e(fe, al),
          e(fe, ft),
          e(ft, lt),
          Ce(We, lt, null),
          e(be, sl),
          e(be, Ae),
          e(Ae, ut),
          e(ut, dt),
          e(dt, Je),
          e(Je, Ot),
          e(Ae, rl),
          e(Ae, $t),
          e(Ae, ol),
          e(Ae, vt),
          e(vt, mt),
          e(mt, Ke),
          e(Ke, jt),
          e(R, il),
          e(R, at),
          e(R, nl),
          e(R, Se),
          e(Se, ht),
          e(ht, cl),
          e(Se, fl),
          e(Se, _t),
          e(_t, st),
          e(st, Gt),
          e(Se, ul),
          e(Se, qe),
          e(qe, Ut),
          e(qe, dl),
          e(qe, qt),
          e(qe, vl),
          Me(D, Rt, U),
          Me(D, rt, U),
          e(rt, Re),
          e(Re, Qe),
          e(Qe, ot),
          e(ot, Xe),
          e(Xe, ml),
          e(Qe, hl),
          e(Qe, it),
          e(it, Ye),
          e(Ye, _l),
          e(Re, pl),
          ~we && Ze[we].m(Re, null),
          (he = !0),
          gl ||
            ((El = [Zt(Xe, "click", r[15]), Zt(Ye, "click", r[16])]),
            (gl = !0));
      },
      p(D, U) {
        (!he || U & 2) && re !== (re = D[1].length + "") && ue(X, re),
          (!he || U & 128) && ie !== (ie = D[9](D[7]) + "") && ue(ce, ie),
          (!he || U & 1) && u !== (u = D[0].name + "") && ue(L, u),
          (!he || U & 128) && K !== (K = D[10](D[7]) + "") && ue(V, K);
        const ze = {};
        U & 4 && (ze.primaryColour = D[2]?.primaryColourHex),
          U & 4 && (ze.secondaryColour = D[2]?.secondaryColourHex),
          U & 4 && (ze.thirdColour = D[2]?.thirdColourHex),
          Ne.$set(ze),
          (!he || (U & 4 && Be !== (Be = `/club?id=${D[2]?.id}`))) &&
            a(He, "href", Be);
        const Ie = {};
        U & 8 && (Ie.primaryColour = D[3]?.primaryColourHex),
          U & 8 && (Ie.secondaryColour = D[3]?.secondaryColourHex),
          U & 8 && (Ie.thirdColour = D[3]?.thirdColourHex),
          We.$set(Ie),
          (!he || (U & 8 && St !== (St = `/club?id=${D[3]?.id}`))) &&
            a(lt, "href", St),
          (!he || U & 4) &&
            It !== (It = D[2]?.abbreviatedName + "") &&
            ue(Ot, It),
          (!he || (U & 4 && Ft !== (Ft = `/club?id=${D[2]?.id}`))) &&
            a(Je, "href", Ft),
          (!he || U & 8) &&
            Dt !== (Dt = D[3]?.abbreviatedName + "") &&
            ue(jt, Dt),
          (!he || (U & 8 && Lt !== (Lt = `/club?id=${D[3]?.id}`))) &&
            a(Ke, "href", Lt),
          (!he || U & 16) && Vt !== (Vt = D[4]?.lastName + "") && ue(Gt, Vt),
          (!he || (U & 16 && Bt !== (Bt = `/player?id=${D[4]?.id}`))) &&
            a(st, "href", Bt),
          (!he || U & 16) &&
            Tt !== (Tt = kt(D[4]?.position ?? 0) + "") &&
            ue(Ut, Tt),
          (!he || U & 16) && Ct !== (Ct = D[4]?.totalPoints + "") && ue(qt, Ct),
          (!he ||
            (U & 32 &&
              zt !==
                (zt = `p-2 ${
                  D[5] === "players" ? "text-white" : "text-gray-400"
                }`))) &&
            a(Xe, "class", zt),
          (!he ||
            (U & 32 &&
              Mt !==
                (Mt = `mr-4 text-xs md:text-base ${
                  D[5] === "players" ? "active-tab" : ""
                }`))) &&
            a(ot, "class", Mt),
          (!he ||
            (U & 32 &&
              Wt !==
                (Wt = `p-2 ${
                  D[5] === "fixtures" ? "text-white" : "text-gray-400"
                }`))) &&
            a(Ye, "class", Wt),
          (!he ||
            (U & 32 &&
              Jt !==
                (Jt = `mr-4 text-xs md:text-base ${
                  D[5] === "fixtures" ? "active-tab" : ""
                }`))) &&
            a(it, "class", Jt);
        let Oe = we;
        (we = $l(D)),
          we === Oe
            ? ~we && Ze[we].p(D, U)
            : (Ee &&
                (Ht(),
                ge(Ze[Oe], 1, 1, () => {
                  Ze[Oe] = null;
                }),
                At()),
              ~we
                ? ((Ee = Ze[we]),
                  Ee ? Ee.p(D, U) : ((Ee = Ze[we] = Il[we](D)), Ee.c()),
                  _e(Ee, 1),
                  Ee.m(Re, null))
                : (Ee = null));
      },
      i(D) {
        he ||
          (_e(P.$$.fragment, D),
          _e(S.$$.fragment, D),
          _e(Ne.$$.fragment, D),
          _e(We.$$.fragment, D),
          _e(Ee),
          (he = !0));
      },
      o(D) {
        ge(P.$$.fragment, D),
          ge(S.$$.fragment, D),
          ge(Ne.$$.fragment, D),
          ge(We.$$.fragment, D),
          ge(Ee),
          (he = !1);
      },
      d(D) {
        D && s(t),
          Pe(P),
          Pe(S),
          Pe(Ne),
          Pe(We),
          D && s(Rt),
          D && s(rt),
          ~we && Ze[we].d(),
          (gl = !1),
          Da(El);
      },
    }
  );
}
function Ga(r) {
  let t, o;
  return (
    (t = new Pa({})),
    {
      c() {
        Te(t.$$.fragment);
      },
      l(l) {
        ke(t.$$.fragment, l);
      },
      m(l, f) {
        Ce(t, l, f), (o = !0);
      },
      p: xa,
      i(l) {
        o || (_e(t.$$.fragment, l), (o = !0));
      },
      o(l) {
        ge(t.$$.fragment, l), (o = !1);
      },
      d(l) {
        Pe(t, l);
      },
    }
  );
}
function Ba(r) {
  let t, o;
  return (
    (t = new ja({ props: { clubId: r[7] } })),
    {
      c() {
        Te(t.$$.fragment);
      },
      l(l) {
        ke(t.$$.fragment, l);
      },
      m(l, f) {
        Ce(t, l, f), (o = !0);
      },
      p(l, f) {
        const d = {};
        f & 128 && (d.clubId = l[7]), t.$set(d);
      },
      i(l) {
        o || (_e(t.$$.fragment, l), (o = !0));
      },
      o(l) {
        ge(t.$$.fragment, l), (o = !1);
      },
      d(l) {
        Pe(t, l);
      },
    }
  );
}
function Ua(r) {
  let t, o;
  return (
    (t = new Sa({ props: { players: r[1] } })),
    {
      c() {
        Te(t.$$.fragment);
      },
      l(l) {
        ke(t.$$.fragment, l);
      },
      m(l, f) {
        Ce(t, l, f), (o = !0);
      },
      p(l, f) {
        const d = {};
        f & 2 && (d.players = l[1]), t.$set(d);
      },
      i(l) {
        o || (_e(t.$$.fragment, l), (o = !0));
      },
      o(l) {
        ge(t.$$.fragment, l), (o = !1);
      },
      d(l) {
        Pe(t, l);
      },
    }
  );
}
function qa(r) {
  let t, o, l, f;
  const d = [Ga, La],
    T = [];
  function H(_, h) {
    return _[6] ? 0 : 1;
  }
  return (
    (t = H(r)),
    (o = T[t] = d[t](r)),
    {
      c() {
        o.c(), (l = oa());
      },
      l(_) {
        o.l(_), (l = oa());
      },
      m(_, h) {
        T[t].m(_, h), Me(_, l, h), (f = !0);
      },
      p(_, h) {
        let P = t;
        (t = H(_)),
          t === P
            ? T[t].p(_, h)
            : (Ht(),
              ge(T[P], 1, 1, () => {
                T[P] = null;
              }),
              At(),
              (o = T[t]),
              o ? o.p(_, h) : ((o = T[t] = d[t](_)), o.c()),
              _e(o, 1),
              o.m(l.parentNode, l));
      },
      i(_) {
        f || (_e(o), (f = !0));
      },
      o(_) {
        ge(o), (f = !1);
      },
      d(_) {
        T[t].d(_), _ && s(l);
      },
    }
  );
}
function Ra(r) {
  let t, o;
  return (
    (t = new Ta({
      props: { $$slots: { default: [qa] }, $$scope: { ctx: r } },
    })),
    {
      c() {
        Te(t.$$.fragment);
      },
      l(l) {
        ke(t.$$.fragment, l);
      },
      m(l, f) {
        Ce(t, l, f), (o = !0);
      },
      p(l, [f]) {
        const d = {};
        f & 67109119 && (d.$$scope = { dirty: f, ctx: l }), t.$set(d);
      },
      i(l) {
        o || (_e(t.$$.fragment, l), (o = !0));
      },
      o(l) {
        ge(t.$$.fragment, l), (o = !1);
      },
      d(l) {
        Pe(t, l);
      },
    }
  );
}
let tt = null;
function za(r, t, o) {
  let l, f;
  $a(r, Na, (k) => o(14, (f = k)));
  let d = [],
    T = [],
    H,
    _ = [],
    h = 1,
    P,
    Q = [],
    S = null,
    w = null,
    O = null,
    te = null,
    Y = "players",
    N,
    J,
    se,
    G,
    M = !0;
  wa(async () => {
    try {
      await el.sync(),
        await tl.sync(),
        await ua.sync(),
        await da.sync(),
        (J = tl.subscribe((E) => {
          (T = E),
            o(
              12,
              (_ = T.map((F) => ({
                fixture: F,
                homeTeam: q(F.homeTeamId),
                awayTeam: q(F.awayTeamId),
              })))
            );
        })),
        (N = el.subscribe((E) => {
          o(11, (d = E));
        })),
        (se = ua.subscribe((E) => {
          H = E;
        })),
        (G = da.subscribe((E) => {
          o(1, (Q = E.filter((F) => F.teamId === l)));
        }));
      let k = T.filter((E) => E.homeTeamId === l || E.awayTeamId === l);
      o(
        12,
        (_ = k.map((E) => ({
          fixture: E,
          homeTeam: q(E.homeTeamId),
          awayTeam: q(E.awayTeamId),
        })))
      ),
        o(
          4,
          (te = Q.sort((E, F) => E.totalPoints - F.totalPoints).sort(
            (E, F) => Number(F.value) - Number(E.value)
          )[0])
        ),
        o(13, (h = H?.activeGameweek ?? h)),
        o(0, (P = H?.activeSeason ?? P)),
        (S = k.find((E) => E.gameweek === h) ?? null),
        o(2, (w = q(S?.homeTeamId ?? 0) ?? null)),
        o(3, (O = q(S?.awayTeamId ?? 0) ?? null));
    } catch (k) {
      Ia.show("Error fetching club details.", "error"),
        console.error("Error fetching club details:", k);
    } finally {
      o(6, (M = !1));
    }
  }),
    Ea(() => {
      N?.(), J?.(), se?.(), G?.();
    });
  let ne = [];
  function q(k) {
    return d.find((E) => E.id === k);
  }
  function C(k) {
    o(5, (Y = k));
  }
  const re = (k) => {
      const E = ne.findIndex((F) => F.id === k);
      return E !== -1 ? E + 1 : "Not found";
    },
    X = (k) => ne.find((F) => F.id === k).points,
    ae = () => C("players"),
    Z = () => C("fixtures");
  return (
    (r.$$.update = () => {
      r.$$.dirty & 16384 && o(7, (l = Number(f.url.searchParams.get("id")))),
        r.$$.dirty & 14336 &&
          _.length > 0 &&
          d.length > 0 &&
          (ne = Ca(_, d, h));
    }),
    [P, Q, w, O, te, Y, M, l, C, re, X, d, _, h, f, ae, Z]
  );
}
class Xa extends xl {
  constructor(t) {
    super(), yl(this, t, za, Ra, wl, {});
  }
}
export { Xa as component };