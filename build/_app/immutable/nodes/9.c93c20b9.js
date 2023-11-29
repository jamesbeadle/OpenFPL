import { B as Gl } from "../chunks/BadgeIcon.5f1570c4.js";
import { f as ea } from "../chunks/fixture-store.8fe042dd.js";
import { i as Ul } from "../chunks/global-stores.803ba169.js";
import { w as al } from "../chunks/index.8caf67b2.js";
import {
  $ as hl,
  A as Be,
  a as V,
  a0 as pe,
  a1 as ve,
  a2 as Ta,
  a3 as Pa,
  a4 as Ps,
  a5 as Gs,
  B as Fe,
  b as z,
  c as N,
  d as fe,
  e as rl,
  f as ft,
  g as ae,
  G as s,
  H as Le,
  h as o,
  I as Ll,
  i as Lt,
  J as pl,
  k as h,
  K as Pt,
  L as we,
  l as _,
  m as u,
  M as Vt,
  N as Kl,
  n,
  O as aa,
  o as la,
  p as it,
  P as _l,
  Q as Nl,
  q as T,
  R as Jl,
  r as P,
  S as St,
  s as Ut,
  T as Ql,
  u as be,
  U as Rl,
  v as ct,
  V as Vl,
  W as $l,
  X as Cs,
  x as Va,
  y as Me,
  Y as Qe,
  z as Oe,
  Z as Ts,
} from "../chunks/index.c7b38e5e.js";
import { a as Ms } from "../chunks/Layout.39e2a716.js";
import { m as Da } from "../chunks/manager-store.58a33dc2.js";
import { p as Zl } from "../chunks/player-store.55a4cc5d.js";
import { S as Hs } from "../chunks/ShirtIcon.cbb688e3.js";
import { s as Yl } from "../chunks/system-store.408d352e.js";
import {
  a as Na,
  b as Bs,
  c as Fs,
  f as ta,
  g as xa,
  h as Os,
  t as sl,
} from "../chunks/team-store.a9afdac8.js";
import { t as jl } from "../chunks/toast-store.64ad2768.js";
var qe = ((a) => (
  (a[(a.AUTOMATIC = 0)] = "AUTOMATIC"),
  (a[(a.PLAYER = 1)] = "PLAYER"),
  (a[(a.TEAM = 2)] = "TEAM"),
  (a[(a.COUNTRY = 3)] = "COUNTRY"),
  a
))(qe || {});
function Aa(a, e, t) {
  const l = a.slice();
  return (l[26] = e[t]), l;
}
function Ga(a, e, t) {
  const l = a.slice();
  return (l[29] = e[t]), l;
}
function Ma(a, e, t) {
  const l = a.slice();
  return (l[32] = e[t]), l;
}
function Ba(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c,
    f,
    d = a[3].name + "",
    m,
    v,
    b,
    E,
    y = a[3].description + "",
    k,
    w,
    g,
    I,
    C,
    x,
    H,
    U,
    F,
    Z,
    X,
    re,
    j,
    R,
    O,
    ne,
    A,
    M,
    $,
    te,
    D,
    Y,
    K = a[3].selectionType === qe.PLAYER && Fa(a),
    J = a[3].selectionType === qe.COUNTRY && Ha(a),
    B = a[3].selectionType === qe.TEAM && La(a);
  return {
    c() {
      (e = h("div")),
        (t = h("div")),
        (l = h("img")),
        (p = V()),
        (c = h("div")),
        (f = h("h3")),
        (m = T(d)),
        (v = V()),
        (b = h("div")),
        (E = h("p")),
        (k = T(y)),
        (w = V()),
        K && K.c(),
        (g = V()),
        J && J.c(),
        (I = V()),
        B && B.c(),
        (C = V()),
        (x = h("div")),
        (H = h("p")),
        (U = T("Warning")),
        (F = V()),
        (Z = h("p")),
        (X =
          T(`Your bonus will be activated when you save your team and it cannot
            be reversed. A bonus can only be played once per season.`)),
        (re = V()),
        (j = h("div")),
        (R = h("button")),
        (O = T("Cancel")),
        (ne = V()),
        (A = h("button")),
        (M = T("Use")),
        this.h();
    },
    l(ie) {
      e = _(ie, "DIV", { class: !0 });
      var Q = u(e);
      t = _(Q, "DIV", { class: !0 });
      var Ee = u(t);
      (l = _(Ee, "IMG", { src: !0, class: !0, alt: !0 })),
        (p = N(Ee)),
        (c = _(Ee, "DIV", { class: !0 }));
      var L = u(c);
      f = _(L, "H3", { class: !0 });
      var S = u(f);
      (m = P(S, d)), S.forEach(o), (v = N(L)), (b = _(L, "DIV", { class: !0 }));
      var se = u(b);
      E = _(se, "P", { class: !0 });
      var ke = u(E);
      (k = P(ke, y)),
        ke.forEach(o),
        se.forEach(o),
        (w = N(L)),
        K && K.l(L),
        (g = N(L)),
        J && J.l(L),
        (I = N(L)),
        B && B.l(L),
        (C = N(L)),
        (x = _(L, "DIV", { class: !0, role: !0 }));
      var ce = u(x);
      H = _(ce, "P", { class: !0 });
      var Ne = u(H);
      (U = P(Ne, "Warning")),
        Ne.forEach(o),
        (F = N(ce)),
        (Z = _(ce, "P", { class: !0 }));
      var de = u(Z);
      (X = P(
        de,
        `Your bonus will be activated when you save your team and it cannot
            be reversed. A bonus can only be played once per season.`
      )),
        de.forEach(o),
        ce.forEach(o),
        (re = N(L)),
        (j = _(L, "DIV", { class: !0 }));
      var ue = u(j);
      R = _(ue, "BUTTON", { class: !0 });
      var xe = u(R);
      (O = P(xe, "Cancel")),
        xe.forEach(o),
        (ne = N(ue)),
        (A = _(ue, "BUTTON", { class: !0 }));
      var Pe = u(A);
      (M = P(Pe, "Use")),
        Pe.forEach(o),
        ue.forEach(o),
        L.forEach(o),
        Ee.forEach(o),
        Q.forEach(o),
        this.h();
    },
    h() {
      hl(l.src, (r = a[3].image)) || n(l, "src", r),
        n(l, "class", "w-16 mx-auto block"),
        n(l, "alt", (i = a[3].name)),
        n(f, "class", "text-lg leading-6 font-medium"),
        n(E, "class", "text-sm"),
        n(b, "class", "mt-2 px-7 py-3"),
        n(H, "class", "font-bold text-sm"),
        n(Z, "class", "font-bold text-xs"),
        n(
          x,
          "class",
          "bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-2"
        ),
        n(x, "role", "alert"),
        n(
          R,
          "class",
          "px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        ),
        n(
          A,
          "class",
          ($ =
            Rl(
              `px-4 py-2 ${
                a[8] ? "fpl-purple-btn" : "bg-gray-500"
              } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`
            ) + " svelte-18qswye")
        ),
        (A.disabled = te = !a[8]),
        n(j, "class", "items-center py-3 flex space-x-4"),
        n(c, "class", "mt-3 text-center"),
        n(
          t,
          "class",
          "relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
        ),
        n(
          e,
          "class",
          "fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop svelte-18qswye"
        );
    },
    m(ie, Q) {
      z(ie, e, Q),
        s(e, t),
        s(t, l),
        s(t, p),
        s(t, c),
        s(c, f),
        s(f, m),
        s(c, v),
        s(c, b),
        s(b, E),
        s(E, k),
        s(c, w),
        K && K.m(c, null),
        s(c, g),
        J && J.m(c, null),
        s(c, I),
        B && B.m(c, null),
        s(c, C),
        s(c, x),
        s(x, H),
        s(H, U),
        s(x, F),
        s(x, Z),
        s(Z, X),
        s(c, re),
        s(c, j),
        s(j, R),
        s(R, O),
        s(j, ne),
        s(j, A),
        s(A, M),
        D ||
          ((Y = [
            we(R, "click", function () {
              Nl(a[2]) && a[2].apply(this, arguments);
            }),
            we(A, "click", a[11]),
            we(t, "click", Jl(a[16])),
            we(t, "keydown", a[12]),
            we(e, "click", function () {
              Nl(a[2]) && a[2].apply(this, arguments);
            }),
            we(e, "keydown", a[12]),
          ]),
          (D = !0));
    },
    p(ie, Q) {
      (a = ie),
        Q[0] & 8 && !hl(l.src, (r = a[3].image)) && n(l, "src", r),
        Q[0] & 8 && i !== (i = a[3].name) && n(l, "alt", i),
        Q[0] & 8 && d !== (d = a[3].name + "") && be(m, d),
        Q[0] & 8 && y !== (y = a[3].description + "") && be(k, y),
        a[3].selectionType === qe.PLAYER
          ? K
            ? K.p(a, Q)
            : ((K = Fa(a)), K.c(), K.m(c, g))
          : K && (K.d(1), (K = null)),
        a[3].selectionType === qe.COUNTRY
          ? J
            ? J.p(a, Q)
            : ((J = Ha(a)), J.c(), J.m(c, I))
          : J && (J.d(1), (J = null)),
        a[3].selectionType === qe.TEAM
          ? B
            ? B.p(a, Q)
            : ((B = La(a)), B.c(), B.m(c, C))
          : B && (B.d(1), (B = null)),
        Q[0] & 256 &&
          $ !==
            ($ =
              Rl(
                `px-4 py-2 ${
                  a[8] ? "fpl-purple-btn" : "bg-gray-500"
                } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`
              ) + " svelte-18qswye") &&
          n(A, "class", $),
        Q[0] & 256 && te !== (te = !a[8]) && (A.disabled = te);
    },
    d(ie) {
      ie && o(e), K && K.d(), J && J.d(), B && B.d(), (D = !1), Kl(Y);
    },
  };
}
function Fa(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c = a[10],
    f = [];
  for (let d = 0; d < c.length; d += 1) f[d] = Oa(Ma(a, c, d));
  return {
    c() {
      (e = h("div")),
        (t = h("select")),
        (l = h("option")),
        (r = T("Select Player"));
      for (let d = 0; d < f.length; d += 1) f[d].c();
      this.h();
    },
    l(d) {
      e = _(d, "DIV", { class: !0 });
      var m = u(e);
      t = _(m, "SELECT", { class: !0 });
      var v = u(t);
      l = _(v, "OPTION", {});
      var b = u(l);
      (r = P(b, "Select Player")), b.forEach(o);
      for (let E = 0; E < f.length; E += 1) f[E].l(v);
      v.forEach(o), m.forEach(o), this.h();
    },
    h() {
      (l.__value = 0),
        (l.value = l.__value),
        n(t, "class", "w-full p-2 rounded-md fpl-dropdown"),
        a[5] === void 0 && pl(() => a[17].call(t)),
        n(e, "class", "w-full border border-gray-500 my-4");
    },
    m(d, m) {
      z(d, e, m), s(e, t), s(t, l), s(l, r);
      for (let v = 0; v < f.length; v += 1) f[v] && f[v].m(t, null);
      Pt(t, a[5], !0), i || ((p = we(t, "change", a[17])), (i = !0));
    },
    p(d, m) {
      if (m[0] & 1024) {
        c = d[10];
        let v;
        for (v = 0; v < c.length; v += 1) {
          const b = Ma(d, c, v);
          f[v] ? f[v].p(b, m) : ((f[v] = Oa(b)), f[v].c(), f[v].m(t, null));
        }
        for (; v < f.length; v += 1) f[v].d(1);
        f.length = c.length;
      }
      m[0] & 1056 && Pt(t, d[5]);
    },
    d(d) {
      d && o(e), Vt(f, d), (i = !1), p();
    },
  };
}
function Oa(a) {
  let e,
    t = a[32].name + "",
    l,
    r;
  return {
    c() {
      (e = h("option")), (l = T(t)), this.h();
    },
    l(i) {
      e = _(i, "OPTION", {});
      var p = u(e);
      (l = P(p, t)), p.forEach(o), this.h();
    },
    h() {
      (e.__value = r = a[32].id), (e.value = e.__value);
    },
    m(i, p) {
      z(i, e, p), s(e, l);
    },
    p(i, p) {
      p[0] & 1024 && t !== (t = i[32].name + "") && be(l, t),
        p[0] & 1024 &&
          r !== (r = i[32].id) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(i) {
      i && o(e);
    },
  };
}
function Ha(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c = a[7],
    f = [];
  for (let d = 0; d < c.length; d += 1) f[d] = Sa(Ga(a, c, d));
  return {
    c() {
      (e = h("div")),
        (t = h("select")),
        (l = h("option")),
        (r = T("Select Country"));
      for (let d = 0; d < f.length; d += 1) f[d].c();
      this.h();
    },
    l(d) {
      e = _(d, "DIV", { class: !0 });
      var m = u(e);
      t = _(m, "SELECT", { class: !0 });
      var v = u(t);
      l = _(v, "OPTION", {});
      var b = u(l);
      (r = P(b, "Select Country")), b.forEach(o);
      for (let E = 0; E < f.length; E += 1) f[E].l(v);
      v.forEach(o), m.forEach(o), this.h();
    },
    h() {
      (l.__value = 0),
        (l.value = l.__value),
        n(t, "class", "w-full p-2 rounded-md fpl-dropdown"),
        a[6] === void 0 && pl(() => a[18].call(t)),
        n(e, "class", "w-full border border-gray-500 my-4");
    },
    m(d, m) {
      z(d, e, m), s(e, t), s(t, l), s(l, r);
      for (let v = 0; v < f.length; v += 1) f[v] && f[v].m(t, null);
      Pt(t, a[6], !0), i || ((p = we(t, "change", a[18])), (i = !0));
    },
    p(d, m) {
      if (m[0] & 128) {
        c = d[7];
        let v;
        for (v = 0; v < c.length; v += 1) {
          const b = Ga(d, c, v);
          f[v] ? f[v].p(b, m) : ((f[v] = Sa(b)), f[v].c(), f[v].m(t, null));
        }
        for (; v < f.length; v += 1) f[v].d(1);
        f.length = c.length;
      }
      m[0] & 192 && Pt(t, d[6]);
    },
    d(d) {
      d && o(e), Vt(f, d), (i = !1), p();
    },
  };
}
function Sa(a) {
  let e,
    t = a[29] + "",
    l,
    r;
  return {
    c() {
      (e = h("option")), (l = T(t)), this.h();
    },
    l(i) {
      e = _(i, "OPTION", {});
      var p = u(e);
      (l = P(p, t)), p.forEach(o), this.h();
    },
    h() {
      (e.__value = r = a[29]), (e.value = e.__value);
    },
    m(i, p) {
      z(i, e, p), s(e, l);
    },
    p(i, p) {
      p[0] & 128 && t !== (t = i[29] + "") && be(l, t),
        p[0] & 128 &&
          r !== (r = i[29]) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(i) {
      i && o(e);
    },
  };
}
function La(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c = a[9],
    f = [];
  for (let d = 0; d < c.length; d += 1) f[d] = Ua(Aa(a, c, d));
  return {
    c() {
      (e = h("div")),
        (t = h("select")),
        (l = h("option")),
        (r = T("Select Team"));
      for (let d = 0; d < f.length; d += 1) f[d].c();
      this.h();
    },
    l(d) {
      e = _(d, "DIV", { class: !0 });
      var m = u(e);
      t = _(m, "SELECT", { class: !0 });
      var v = u(t);
      l = _(v, "OPTION", {});
      var b = u(l);
      (r = P(b, "Select Team")), b.forEach(o);
      for (let E = 0; E < f.length; E += 1) f[E].l(v);
      v.forEach(o), m.forEach(o), this.h();
    },
    h() {
      (l.__value = 0),
        (l.value = l.__value),
        n(t, "class", "w-full p-2 rounded-md fpl-dropdown"),
        a[4] === void 0 && pl(() => a[19].call(t)),
        n(e, "class", "w-full border border-gray-500 my-4");
    },
    m(d, m) {
      z(d, e, m), s(e, t), s(t, l), s(l, r);
      for (let v = 0; v < f.length; v += 1) f[v] && f[v].m(t, null);
      Pt(t, a[4], !0), i || ((p = we(t, "change", a[19])), (i = !0));
    },
    p(d, m) {
      if (m[0] & 512) {
        c = d[9];
        let v;
        for (v = 0; v < c.length; v += 1) {
          const b = Aa(d, c, v);
          f[v] ? f[v].p(b, m) : ((f[v] = Ua(b)), f[v].c(), f[v].m(t, null));
        }
        for (; v < f.length; v += 1) f[v].d(1);
        f.length = c.length;
      }
      m[0] & 528 && Pt(t, d[4]);
    },
    d(d) {
      d && o(e), Vt(f, d), (i = !1), p();
    },
  };
}
function Ua(a) {
  let e,
    t = a[26].name + "",
    l,
    r;
  return {
    c() {
      (e = h("option")), (l = T(t)), this.h();
    },
    l(i) {
      e = _(i, "OPTION", {});
      var p = u(e);
      (l = P(p, t)), p.forEach(o), this.h();
    },
    h() {
      (e.__value = r = a[26].id), (e.value = e.__value);
    },
    m(i, p) {
      z(i, e, p), s(e, l);
    },
    p(i, p) {
      p[0] & 512 && t !== (t = i[26].name + "") && be(l, t),
        p[0] & 512 &&
          r !== (r = i[26].id) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(i) {
      i && o(e);
    },
  };
}
function Ss(a) {
  let e,
    t = a[1] && Ba(a);
  return {
    c() {
      t && t.c(), (e = rl());
    },
    l(l) {
      t && t.l(l), (e = rl());
    },
    m(l, r) {
      t && t.m(l, r), z(l, e, r);
    },
    p(l, r) {
      l[1]
        ? t
          ? t.p(l, r)
          : ((t = Ba(l)), t.c(), t.m(e.parentNode, e))
        : t && (t.d(1), (t = null));
    },
    i: Le,
    o: Le,
    d(l) {
      t && t.d(l), l && o(e);
    },
  };
}
function Ls(a, e, t) {
  let l,
    r,
    i,
    p,
    c = Le,
    f = () => (c(), (c = Cs(d, (A) => t(20, (p = A)))), d);
  a.$$.on_destroy.push(() => c());
  let { fantasyTeam: d = al(null) } = e;
  f();
  let { players: m } = e,
    { teams: v } = e,
    { activeGameweek: b } = e,
    { showModal: E } = e,
    { closeBonusModal: y } = e,
    {
      bonus: k = {
        id: 0,
        name: "",
        description: "",
        image: "",
        selectionType: 0,
      },
    } = e,
    w,
    g = 0,
    I = 0,
    C = "";
  const x = () => {
      const A = Qe(d);
      if (!A || !A.playerIds) return [];
      const M = new Set(A.playerIds),
        $ = m.filter((te) => M.has(te.id)).map((te) => te.nationality);
      return [...new Set($)].sort();
    },
    H = () =>
      m
        .filter((A) => U(A.id))
        .map((A) => ({ id: A.id, name: `${A.firstName} ${A.lastName}` })),
    U = (A) => {
      const M = Qe(d);
      return M ? M.playerIds && M.playerIds.includes(A) : !1;
    },
    F = () => {
      const A = new Set(m.filter((M) => U(M.id)).map((M) => M.teamId));
      return v
        .filter((M) => A.has(M.id))
        .map((M) => ({ id: M.id, name: M.friendlyName }));
    },
    Z = () => {
      const A = Qe(d);
      if (!A || !A.playerIds) return 0;
      for (const M of A.playerIds) {
        const $ = m.find((te) => te.id === M);
        if ($ && $.position === 0) return $.id;
      }
      return 0;
    };
  function X() {
    if (Qe(d)) {
      switch (k.id) {
        case 1:
          d.update(
            (M) =>
              M && {
                ...M,
                goalGetterPlayerId: I,
                goalGetterGameweek: b,
                playerIds: M.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 2:
          d.update(
            (M) =>
              M && {
                ...M,
                passMasterPlayerId: I,
                passMasterGameweek: b,
                playerIds: M.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 3:
          d.update(
            (M) =>
              M && {
                ...M,
                noEntryPlayerId: g,
                noEntryGameweek: b,
                playerIds: M.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 4:
          d.update(
            (M) =>
              M && {
                ...M,
                teamBoostTeamId: g,
                teamBoostGameweek: b,
                playerIds: M.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 5:
          d.update(
            (M) =>
              M && {
                ...M,
                safeHandsGameweek: b,
                safeHandsPlayerId: Z(),
                playerIds: M.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 6:
          d.update(
            (M) =>
              M && {
                ...M,
                captainFantasticPlayerId: p?.captainId ?? 0,
                captainFantasticGameweek: b,
                playerIds: M.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 7:
          break;
        case 8:
          break;
        case 9:
          d.update(
            (M) =>
              M && {
                ...M,
                braceBonusGameweek: b,
                playerIds: M.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 10:
          d.update(
            (M) =>
              M && {
                ...M,
                hatTrickHeroGameweek: b,
                playerIds: M.playerIds || new Uint16Array(11),
              }
          );
          break;
      }
      y();
    }
  }
  function re(A) {
    !(A.target instanceof HTMLInputElement) && A.key === "Escape" && y();
  }
  function j(A) {
    Ql.call(this, a, A);
  }
  function R() {
    (I = _l(this)), t(5, I), t(10, l);
  }
  function O() {
    (C = _l(this)), t(6, C), t(7, w);
  }
  function ne() {
    (g = _l(this)), t(4, g), t(9, r);
  }
  return (
    (a.$$set = (A) => {
      "fantasyTeam" in A && f(t(0, (d = A.fantasyTeam))),
        "players" in A && t(13, (m = A.players)),
        "teams" in A && t(14, (v = A.teams)),
        "activeGameweek" in A && t(15, (b = A.activeGameweek)),
        "showModal" in A && t(1, (E = A.showModal)),
        "closeBonusModal" in A && t(2, (y = A.closeBonusModal)),
        "bonus" in A && t(3, (k = A.bonus));
    }),
    (a.$$.update = () => {
      a.$$.dirty[0] & 120 &&
        t(
          8,
          (i = (() => {
            switch (k.selectionType) {
              case qe.PLAYER:
                return I !== 0;
              case qe.TEAM:
                return g !== 0;
              case qe.COUNTRY:
                return C !== "";
              default:
                return !0;
            }
          })())
        );
    }),
    t(7, (w = x())),
    t(10, (l = H())),
    t(9, (r = F())),
    [d, E, y, k, g, I, C, w, i, r, l, X, re, m, v, b, j, R, O, ne]
  );
}
class Us extends St {
  constructor(e) {
    super(),
      Lt(
        this,
        e,
        Ls,
        Ss,
        Ut,
        {
          fantasyTeam: 0,
          players: 13,
          teams: 14,
          activeGameweek: 15,
          showModal: 1,
          closeBonusModal: 2,
          bonus: 3,
        },
        null,
        [-1, -1]
      );
  }
}
function ja(a, e, t) {
  const l = a.slice();
  return (l[14] = e[t]), l;
}
function Ra(a, e, t) {
  const l = a.slice();
  return (l[14] = e[t]), l;
}
function $a(a) {
  let e, t;
  return (
    (e = new Us({
      props: {
        showModal: a[4],
        bonus: a[6][a[5] - 1],
        closeBonusModal: a[10],
        players: a[1],
        teams: a[2],
        fantasyTeam: a[0],
        activeGameweek: a[3],
      },
    })),
    {
      c() {
        Me(e.$$.fragment);
      },
      l(l) {
        Oe(e.$$.fragment, l);
      },
      m(l, r) {
        Be(e, l, r), (t = !0);
      },
      p(l, r) {
        const i = {};
        r & 16 && (i.showModal = l[4]),
          r & 32 && (i.bonus = l[6][l[5] - 1]),
          r & 2 && (i.players = l[1]),
          r & 4 && (i.teams = l[2]),
          r & 1 && (i.fantasyTeam = l[0]),
          r & 8 && (i.activeGameweek = l[3]),
          e.$set(i);
      },
      i(l) {
        t || (ae(e.$$.fragment, l), (t = !0));
      },
      o(l) {
        fe(e.$$.fragment, l), (t = !1);
      },
      d(l) {
        Fe(e, l);
      },
    }
  );
}
function Ya(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c = a[14].name + "",
    f,
    d,
    m,
    v,
    b,
    E,
    y;
  function k() {
    return a[12](a[14]);
  }
  return {
    c() {
      (e = h("div")),
        (t = h("div")),
        (l = h("img")),
        (i = V()),
        (p = h("p")),
        (f = T(c)),
        (d = V()),
        (m = h("button")),
        (v = T("Use")),
        (b = V()),
        this.h();
    },
    l(w) {
      e = _(w, "DIV", { class: !0 });
      var g = u(e);
      t = _(g, "DIV", { class: !0 });
      var I = u(t);
      (l = _(I, "IMG", { alt: !0, src: !0, class: !0 })),
        (i = N(I)),
        (p = _(I, "P", { class: !0 }));
      var C = u(p);
      (f = P(C, c)),
        C.forEach(o),
        (d = N(I)),
        (m = _(I, "BUTTON", { class: !0 }));
      var x = u(m);
      (v = P(x, "Use")),
        x.forEach(o),
        I.forEach(o),
        (b = N(g)),
        g.forEach(o),
        this.h();
    },
    h() {
      n(l, "alt", a[14].name),
        hl(l.src, (r = a[14].image)) || n(l, "src", r),
        n(l, "class", "h-10 md:h-24 mt-2"),
        n(p, "class", "text-center text-xs mt-4 m-2 font-bold"),
        n(
          m,
          "class",
          "fpl-purple-btn mt-4 mb-8 p-2 px-4 rounded-md min-w-[100px]"
        ),
        n(
          t,
          "class",
          Rl("flex flex-col justify-center items-center flex-1") +
            " svelte-1nv76pl"
        ),
        n(
          e,
          "class",
          "flex items-center w-1/5 bonus-panel-inner m-1 md:m-4 rounded-lg border border-gray-700 svelte-1nv76pl"
        );
    },
    m(w, g) {
      z(w, e, g),
        s(e, t),
        s(t, l),
        s(t, i),
        s(t, p),
        s(p, f),
        s(t, d),
        s(t, m),
        s(m, v),
        s(e, b),
        E || ((y = we(m, "click", k)), (E = !0));
    },
    p(w, g) {
      a = w;
    },
    d(w) {
      w && o(e), (E = !1), y();
    },
  };
}
function js(a) {
  let e, t, l, r;
  function i() {
    return a[13](a[14]);
  }
  return {
    c() {
      (e = h("button")), (t = T("Use")), this.h();
    },
    l(p) {
      e = _(p, "BUTTON", { class: !0 });
      var c = u(e);
      (t = P(c, "Use")), c.forEach(o), this.h();
    },
    h() {
      n(
        e,
        "class",
        "fpl-purple-btn mt-4 mb-8 p-2 px-4 rounded-md min-w-[100px]"
      );
    },
    m(p, c) {
      z(p, e, c), s(e, t), l || ((r = we(e, "click", i)), (l = !0));
    },
    p(p, c) {
      a = p;
    },
    d(p) {
      p && o(e), (l = !1), r();
    },
  };
}
function Rs(a) {
  let e,
    t,
    l = a[11](a[14].id) + "",
    r;
  return {
    c() {
      (e = h("p")), (t = T("Used in GW ")), (r = T(l)), this.h();
    },
    l(i) {
      e = _(i, "P", { class: !0 });
      var p = u(e);
      (t = P(p, "Used in GW ")), (r = P(p, l)), p.forEach(o), this.h();
    },
    h() {
      n(e, "class", "text-center text-xs mt-4 m-2");
    },
    m(i, p) {
      z(i, e, p), s(e, t), s(e, r);
    },
    p: Le,
    d(i) {
      i && o(e);
    },
  };
}
function Za(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c = a[14].name + "",
    f,
    d,
    m;
  function v(y, k) {
    return y[11](y[14].id) ? Rs : js;
  }
  let E = v(a)(a);
  return {
    c() {
      (e = h("div")),
        (t = h("div")),
        (l = h("img")),
        (i = V()),
        (p = h("p")),
        (f = T(c)),
        (d = V()),
        E.c(),
        (m = V()),
        this.h();
    },
    l(y) {
      e = _(y, "DIV", { class: !0 });
      var k = u(e);
      t = _(k, "DIV", { class: !0 });
      var w = u(t);
      (l = _(w, "IMG", { alt: !0, src: !0, class: !0 })),
        (i = N(w)),
        (p = _(w, "P", { class: !0 }));
      var g = u(p);
      (f = P(g, c)),
        g.forEach(o),
        (d = N(w)),
        E.l(w),
        w.forEach(o),
        (m = N(k)),
        k.forEach(o),
        this.h();
    },
    h() {
      n(l, "alt", a[14].name),
        hl(l.src, (r = a[14].image)) || n(l, "src", r),
        n(l, "class", "h-10 md:h-24 mt-2"),
        n(p, "class", "text-center text-xs mt-4 m-2 font-bold"),
        n(
          t,
          "class",
          Rl("flex flex-col justify-center items-center flex-1") +
            " svelte-1nv76pl"
        ),
        n(
          e,
          "class",
          "flex items-center w-1/5 bonus-panel-inner m-1 md:m-4 rounded-lg border border-gray-700 svelte-1nv76pl"
        );
    },
    m(y, k) {
      z(y, e, k),
        s(e, t),
        s(t, l),
        s(t, i),
        s(t, p),
        s(p, f),
        s(t, d),
        E.m(t, null),
        s(e, m);
    },
    p(y, k) {
      E.p(y, k);
    },
    d(y) {
      y && o(e), E.d();
    },
  };
}
function $s(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c,
    f,
    d,
    m,
    v,
    b = a[5] > 0 && $a(a),
    E = a[7],
    y = [];
  for (let g = 0; g < E.length; g += 1) y[g] = Ya(Ra(a, E, g));
  let k = a[8],
    w = [];
  for (let g = 0; g < k.length; g += 1) w[g] = Za(ja(a, k, g));
  return {
    c() {
      (e = h("div")),
        b && b.c(),
        (t = V()),
        (l = h("div")),
        (r = h("h1")),
        (i = T("Bonuses")),
        (p = V()),
        (c = h("div")),
        (f = h("div"));
      for (let g = 0; g < y.length; g += 1) y[g].c();
      (d = V()), (m = h("div"));
      for (let g = 0; g < w.length; g += 1) w[g].c();
      this.h();
    },
    l(g) {
      e = _(g, "DIV", { class: !0 });
      var I = u(e);
      b && b.l(I), (t = N(I)), (l = _(I, "DIV", { class: !0 }));
      var C = u(l);
      r = _(C, "H1", { class: !0 });
      var x = u(r);
      (i = P(x, "Bonuses")),
        x.forEach(o),
        C.forEach(o),
        (p = N(I)),
        (c = _(I, "DIV", { class: !0 }));
      var H = u(c);
      f = _(H, "DIV", { class: !0 });
      var U = u(f);
      for (let Z = 0; Z < y.length; Z += 1) y[Z].l(U);
      U.forEach(o), (d = N(H)), (m = _(H, "DIV", { class: !0 }));
      var F = u(m);
      for (let Z = 0; Z < w.length; Z += 1) w[Z].l(F);
      F.forEach(o), H.forEach(o), I.forEach(o), this.h();
    },
    h() {
      n(r, "class", "m-4 font-bold"),
        n(
          l,
          "class",
          "flex flex-col md:flex-row bonus-panel-inner svelte-1nv76pl"
        ),
        n(f, "class", "flex items-center w-100 md:w-1/2"),
        n(m, "class", "flex items-center w-100 md:w-1/2"),
        n(c, "class", "flex flex-col md:flex-row"),
        n(e, "class", "bonus-panel rounded-md m-4 flex-1 svelte-1nv76pl");
    },
    m(g, I) {
      z(g, e, I),
        b && b.m(e, null),
        s(e, t),
        s(e, l),
        s(l, r),
        s(r, i),
        s(e, p),
        s(e, c),
        s(c, f);
      for (let C = 0; C < y.length; C += 1) y[C] && y[C].m(f, null);
      s(c, d), s(c, m);
      for (let C = 0; C < w.length; C += 1) w[C] && w[C].m(m, null);
      v = !0;
    },
    p(g, [I]) {
      if (
        (g[5] > 0
          ? b
            ? (b.p(g, I), I & 32 && ae(b, 1))
            : ((b = $a(g)), b.c(), ae(b, 1), b.m(e, t))
          : b &&
            (ct(),
            fe(b, 1, 1, () => {
              b = null;
            }),
            ft()),
        I & 640)
      ) {
        E = g[7];
        let C;
        for (C = 0; C < E.length; C += 1) {
          const x = Ra(g, E, C);
          y[C] ? y[C].p(x, I) : ((y[C] = Ya(x)), y[C].c(), y[C].m(f, null));
        }
        for (; C < y.length; C += 1) y[C].d(1);
        y.length = E.length;
      }
      if (I & 2816) {
        k = g[8];
        let C;
        for (C = 0; C < k.length; C += 1) {
          const x = ja(g, k, C);
          w[C] ? w[C].p(x, I) : ((w[C] = Za(x)), w[C].c(), w[C].m(m, null));
        }
        for (; C < w.length; C += 1) w[C].d(1);
        w.length = k.length;
      }
    },
    i(g) {
      v || (ae(b), (v = !0));
    },
    o(g) {
      fe(b), (v = !1);
    },
    d(g) {
      g && o(e), b && b.d(), Vt(y, g), Vt(w, g);
    },
  };
}
function Ys(a, e, t) {
  let { fantasyTeam: l = al(null) } = e,
    { players: r } = e,
    { teams: i } = e,
    { activeGameweek: p } = e,
    c = !1,
    f = 0,
    d = [
      {
        id: 1,
        name: "Goal Getter",
        image: "goal-getter.png",
        description:
          "Select a player you think will score in a game to receive a X3 mulitplier for each goal scored.",
        selectionType: qe.PLAYER,
      },
      {
        id: 2,
        name: "Pass Master",
        image: "pass-master.png",
        description:
          "Select a player you think will assist in a game to receive a X3 mulitplier for each assist.",
        selectionType: qe.PLAYER,
      },
      {
        id: 3,
        name: "No Entry",
        image: "no-entry.png",
        description:
          "Select a goalkeeper or defender you think will keep a clean sheet to receive a X3 multipler on their total score.",
        selectionType: qe.PLAYER,
      },
      {
        id: 4,
        name: "Team Boost",
        image: "team-boost.png",
        description:
          "Receive a X2 multiplier from all players from a single club that are in your team.",
        selectionType: qe.TEAM,
      },
      {
        id: 5,
        name: "Safe Hands",
        image: "safe-hands.png",
        description:
          "Receive a X3 multiplier on your goalkeeper if they make 5 saves in a match.",
        selectionType: qe.AUTOMATIC,
      },
      {
        id: 6,
        name: "Captain Fantastic",
        image: "captain-fantastic.png",
        description:
          "Receive a X2 multiplier on your team captain's score if they score a goal in a match.",
        selectionType: qe.AUTOMATIC,
      },
      {
        id: 7,
        name: "Prospects",
        image: "prospects.png",
        description: "Receive a X2 multiplier for players under the age of 21.",
        selectionType: qe.AUTOMATIC,
      },
      {
        id: 8,
        name: "Countrymen",
        image: "countrymen.png",
        description:
          "Receive a X2 multiplier for players of a selected nationality.",
        selectionType: qe.COUNTRY,
      },
      {
        id: 9,
        name: "Brace Bonus",
        image: "brace-bonus.png",
        description:
          "Receive a X2 multiplier on a player's score if they score 2 or more goals in a game. Applies to every player who scores a brace.",
        selectionType: qe.AUTOMATIC,
      },
      {
        id: 10,
        name: "Hat-Trick Hero",
        image: "hat-trick-hero.png",
        description:
          "Receive a X3 multiplier on a player's score if they score 3 or more goals in a game. Applies to every player who scores a hat-trick.",
        selectionType: qe.AUTOMATIC,
      },
    ],
    m = d.slice(0, 5),
    v = d.slice(5, 10);
  function b(g) {
    t(5, (f = g)), t(4, (c = !0));
  }
  function E() {
    t(4, (c = !1));
  }
  function y(g) {
    const I = Qe(l);
    if (!I) return !1;
    switch (g) {
      case 1:
        return I.goalGetterGameweek && I.goalGetterGameweek > 0
          ? I.goalGetterGameweek
          : !1;
      case 2:
        return I.passMasterGameweek && I.passMasterGameweek > 0
          ? I.passMasterGameweek
          : !1;
      case 3:
        return I.noEntryGameweek && I.noEntryGameweek > 0
          ? I.noEntryGameweek
          : !1;
      case 4:
        return I.teamBoostGameweek && I.teamBoostGameweek > 0
          ? I.teamBoostGameweek
          : !1;
      case 5:
        return I.safeHandsGameweek && I.safeHandsGameweek > 0
          ? I.safeHandsGameweek
          : !1;
      case 6:
        return I.captainFantasticGameweek && I.captainFantasticGameweek > 0
          ? I.captainFantasticGameweek
          : !1;
      case 7:
        return !1;
      case 8:
        return !1;
      case 9:
        return I.braceBonusGameweek && I.braceBonusGameweek > 0
          ? I.braceBonusGameweek
          : !1;
      case 10:
        return I.hatTrickHeroGameweek && I.hatTrickHeroGameweek > 0
          ? I.hatTrickHeroGameweek
          : !1;
      default:
        return !1;
    }
  }
  const k = (g) => b(g.id),
    w = (g) => b(g.id);
  return (
    (a.$$set = (g) => {
      "fantasyTeam" in g && t(0, (l = g.fantasyTeam)),
        "players" in g && t(1, (r = g.players)),
        "teams" in g && t(2, (i = g.teams)),
        "activeGameweek" in g && t(3, (p = g.activeGameweek));
    }),
    [l, r, i, p, c, f, d, m, v, b, E, y, k, w]
  );
}
class Zs extends St {
  constructor(e) {
    super(),
      Lt(this, e, Ys, $s, Ut, {
        fantasyTeam: 0,
        players: 1,
        teams: 2,
        activeGameweek: 3,
      });
  }
}
function Xs(a) {
  let e, t;
  return {
    c() {
      (e = pe("svg")), (t = pe("path")), this.h();
    },
    l(l) {
      e = ve(l, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var r = u(e);
      (t = ve(r, "path", { d: !0, fill: !0 })),
        u(t).forEach(o),
        r.forEach(o),
        this.h();
    },
    h() {
      n(
        t,
        "d",
        "M16 6.66667H9.33333V0H6.66667V6.66667H0V9.33333H6.66667V16H9.33333V9.33333H16V6.66667Z"
      ),
        n(t, "fill", "#FFFFFF"),
        n(e, "xmlns", "http://www.w3.org/2000/svg"),
        n(e, "class", a[0]),
        n(e, "fill", "currentColor"),
        n(e, "viewBox", "0 0 16 16");
    },
    m(l, r) {
      z(l, e, r), s(e, t);
    },
    p(l, [r]) {
      r & 1 && n(e, "class", l[0]);
    },
    i: Le,
    o: Le,
    d(l) {
      l && o(e);
    },
  };
}
function Ks(a, e, t) {
  let { className: l = "" } = e;
  return (
    (a.$$set = (r) => {
      "className" in r && t(0, (l = r.className));
    }),
    [l]
  );
}
class Vs extends St {
  constructor(e) {
    super(), Lt(this, e, Ks, Xs, Ut, { className: 0 });
  }
}
function Xa(a, e, t) {
  const l = a.slice();
  return (l[34] = e[t]), (l[36] = t), l;
}
function Ka(a, e, t) {
  const l = a.slice();
  return (l[37] = e[t]), (l[36] = t), l;
}
function qa(a, e, t) {
  const l = a.slice();
  return (l[39] = e[t]), l;
}
function Wa(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c,
    f,
    d,
    m,
    v,
    b,
    E,
    y,
    k,
    w,
    g,
    I,
    C,
    x,
    H,
    U,
    F,
    Z,
    X,
    re,
    j,
    R,
    O,
    ne,
    A,
    M,
    $,
    te,
    D,
    Y,
    K,
    J,
    B,
    ie,
    Q,
    Ee,
    L,
    S,
    se,
    ke,
    ce,
    Ne,
    de,
    ue,
    xe,
    Pe,
    Ve,
    Ye,
    Te,
    Ie,
    Ze,
    We = (a[13] / 4).toFixed(2) + "",
    He,
    Xe,
    lt,
    bt,
    dt,
    Mt,
    Ue,
    mt,
    Kt,
    qt,
    G,
    q,
    le,
    oe,
    me,
    ge,
    ye,
    Se,
    ze,
    je,
    gt,
    et,
    Ae,
    Nt,
    At,
    ut,
    nl,
    at,
    yt,
    ol,
    jt,
    wt,
    Wt,
    Rt,
    il,
    zt,
    $t = a[11],
    Re = [];
  for (let he = 0; he < $t.length; he += 1) Re[he] = za(qa(a, $t, he));
  let Et = a[10],
    Ce = [];
  for (let he = 0; he < Et.length; he += 1) Ce[he] = ls(Ka(a, Et, he));
  const Yt = (he) =>
    fe(Ce[he], 1, 1, () => {
      Ce[he] = null;
    });
  let ht = Array(Math.ceil(a[9].length / Xl)),
    $e = [];
  for (let he = 0; he < ht.length; he += 1) $e[he] = as(Xa(a, ht, he));
  return {
    c() {
      (e = h("div")),
        (t = h("div")),
        (l = h("div")),
        (r = h("h3")),
        (i = T("Select Player")),
        (p = V()),
        (c = h("button")),
        (f = T("×")),
        (d = V()),
        (m = h("div")),
        (v = h("div")),
        (b = h("div")),
        (E = h("label")),
        (y = T("Filter by Team:")),
        (k = V()),
        (w = h("select")),
        (g = h("option")),
        (I = T("All"));
      for (let he = 0; he < Re.length; he += 1) Re[he].c();
      (C = V()),
        (x = h("div")),
        (H = h("label")),
        (U = T("Filter by Position:")),
        (F = V()),
        (Z = h("select")),
        (X = h("option")),
        (re = T("All")),
        (j = h("option")),
        (R = T("Goalkeepers")),
        (O = h("option")),
        (ne = T("Defenders")),
        (A = h("option")),
        (M = T("Midfielders")),
        ($ = h("option")),
        (te = T("Forwards")),
        (D = V()),
        (Y = h("div")),
        (K = h("div")),
        (J = h("label")),
        (B = T("Min Value:")),
        (ie = V()),
        (Q = h("input")),
        (Ee = V()),
        (L = h("div")),
        (S = h("label")),
        (se = T("Max Value:")),
        (ke = V()),
        (ce = h("input")),
        (Ne = V()),
        (de = h("div")),
        (ue = h("label")),
        (xe = T("Search by Name:")),
        (Pe = V()),
        (Ve = h("input")),
        (Ye = V()),
        (Te = h("div")),
        (Ie = h("label")),
        (Ze = T("Available Balance: £")),
        (He = T(We)),
        (Xe = T("m")),
        (lt = V()),
        (bt = h("div")),
        (dt = h("table")),
        (Mt = h("thead")),
        (Ue = h("tr")),
        (mt = h("th")),
        (Kt = T("Pos")),
        (qt = V()),
        (G = h("th")),
        (q = T("Name")),
        (le = V()),
        (oe = h("th")),
        (me = T("Club")),
        (ge = V()),
        (ye = h("th")),
        (Se = T("Value")),
        (ze = V()),
        (je = h("th")),
        (gt = T("Pts")),
        (et = V()),
        (Ae = h("th")),
        (Nt = T(" ")),
        (At = V()),
        (ut = h("tbody"));
      for (let he = 0; he < Ce.length; he += 1) Ce[he].c();
      (nl = V()), (at = h("div")), (yt = h("div"));
      for (let he = 0; he < $e.length; he += 1) $e[he].c();
      (ol = V()),
        (jt = h("div")),
        (wt = h("button")),
        (Wt = T("Close")),
        this.h();
    },
    l(he) {
      e = _(he, "DIV", { class: !0 });
      var De = u(e);
      t = _(De, "DIV", { class: !0 });
      var W = u(t);
      l = _(W, "DIV", { class: !0 });
      var st = u(l);
      r = _(st, "H3", { class: !0 });
      var cl = u(r);
      (i = P(cl, "Select Player")),
        cl.forEach(o),
        (p = N(st)),
        (c = _(st, "BUTTON", { class: !0 }));
      var vl = u(c);
      (f = P(vl, "×")),
        vl.forEach(o),
        st.forEach(o),
        (d = N(W)),
        (m = _(W, "DIV", { class: !0 }));
      var _t = u(m);
      v = _(_t, "DIV", { class: !0 });
      var Gt = u(v);
      b = _(Gt, "DIV", {});
      var Qt = u(b);
      E = _(Qt, "LABEL", { for: !0, class: !0 });
      var kt = u(E);
      (y = P(kt, "Filter by Team:")),
        kt.forEach(o),
        (k = N(Qt)),
        (w = _(Qt, "SELECT", { id: !0, class: !0 }));
      var fl = u(w);
      g = _(fl, "OPTION", {});
      var Bt = u(g);
      (I = P(Bt, "All")), Bt.forEach(o);
      for (let Tt = 0; Tt < Re.length; Tt += 1) Re[Tt].l(fl);
      fl.forEach(o), Qt.forEach(o), (C = N(Gt)), (x = _(Gt, "DIV", {}));
      var pt = u(x);
      H = _(pt, "LABEL", { for: !0, class: !0 });
      var bl = u(H);
      (U = P(bl, "Filter by Position:")),
        bl.forEach(o),
        (F = N(pt)),
        (Z = _(pt, "SELECT", { id: !0, class: !0 }));
      var Ft = u(Z);
      X = _(Ft, "OPTION", {});
      var ul = u(X);
      (re = P(ul, "All")), ul.forEach(o), (j = _(Ft, "OPTION", {}));
      var gl = u(j);
      (R = P(gl, "Goalkeepers")), gl.forEach(o), (O = _(Ft, "OPTION", {}));
      var xt = u(O);
      (ne = P(xt, "Defenders")), xt.forEach(o), (A = _(Ft, "OPTION", {}));
      var yl = u(A);
      (M = P(yl, "Midfielders")), yl.forEach(o), ($ = _(Ft, "OPTION", {}));
      var dl = u($);
      (te = P(dl, "Forwards")),
        dl.forEach(o),
        Ft.forEach(o),
        pt.forEach(o),
        Gt.forEach(o),
        (D = N(_t)),
        (Y = _(_t, "DIV", { class: !0 }));
      var el = u(Y);
      K = _(el, "DIV", {});
      var It = u(K);
      J = _(It, "LABEL", { for: !0, class: !0 });
      var vt = u(J);
      (B = P(vt, "Min Value:")),
        vt.forEach(o),
        (ie = N(It)),
        (Q = _(It, "INPUT", { id: !0, type: !0, class: !0 })),
        It.forEach(o),
        (Ee = N(el)),
        (L = _(el, "DIV", {}));
      var rt = u(L);
      S = _(rt, "LABEL", { for: !0, class: !0 });
      var ml = u(S);
      (se = P(ml, "Max Value:")),
        ml.forEach(o),
        (ke = N(rt)),
        (ce = _(rt, "INPUT", { id: !0, type: !0, class: !0 })),
        rt.forEach(o),
        el.forEach(o),
        (Ne = N(_t)),
        (de = _(_t, "DIV", { class: !0 }));
      var Ot = u(de);
      ue = _(Ot, "LABEL", { for: !0, class: !0 });
      var Zt = u(ue);
      (xe = P(Zt, "Search by Name:")),
        Zt.forEach(o),
        (Pe = N(Ot)),
        (Ve = _(Ot, "INPUT", { id: !0, type: !0, class: !0, placeholder: !0 })),
        Ot.forEach(o),
        (Ye = N(_t)),
        (Te = _(_t, "DIV", { class: !0 }));
      var wl = u(Te);
      Ie = _(wl, "LABEL", { for: !0, class: !0 });
      var Dt = u(Ie);
      (Ze = P(Dt, "Available Balance: £")),
        (He = P(Dt, We)),
        (Xe = P(Dt, "m")),
        Dt.forEach(o),
        wl.forEach(o),
        _t.forEach(o),
        (lt = N(W)),
        (bt = _(W, "DIV", { class: !0 }));
      var Ge = u(bt);
      dt = _(Ge, "TABLE", { class: !0 });
      var tl = u(dt);
      Mt = _(tl, "THEAD", {});
      var xl = u(Mt);
      Ue = _(xl, "TR", {});
      var Je = u(Ue);
      mt = _(Je, "TH", { class: !0 });
      var Ke = u(mt);
      (Kt = P(Ke, "Pos")),
        Ke.forEach(o),
        (qt = N(Je)),
        (G = _(Je, "TH", { class: !0 }));
      var Dl = u(G);
      (q = P(Dl, "Name")),
        Dl.forEach(o),
        (le = N(Je)),
        (oe = _(Je, "TH", { class: !0 }));
      var Ht = u(oe);
      (me = P(Ht, "Club")),
        Ht.forEach(o),
        (ge = N(Je)),
        (ye = _(Je, "TH", { class: !0 }));
      var Al = u(ye);
      (Se = P(Al, "Value")),
        Al.forEach(o),
        (ze = N(Je)),
        (je = _(Je, "TH", { class: !0 }));
      var ee = u(je);
      (gt = P(ee, "Pts")),
        ee.forEach(o),
        (et = N(Je)),
        (Ae = _(Je, "TH", { class: !0 }));
      var _e = u(Ae);
      (Nt = P(_e, " ")),
        _e.forEach(o),
        Je.forEach(o),
        xl.forEach(o),
        (At = N(tl)),
        (ut = _(tl, "TBODY", {}));
      var nt = u(ut);
      for (let Tt = 0; Tt < Ce.length; Tt += 1) Ce[Tt].l(nt);
      nt.forEach(o),
        tl.forEach(o),
        Ge.forEach(o),
        (nl = N(W)),
        (at = _(W, "DIV", { class: !0 }));
      var ot = u(at);
      yt = _(ot, "DIV", { class: !0 });
      var Ct = u(yt);
      for (let Tt = 0; Tt < $e.length; Tt += 1) $e[Tt].l(Ct);
      Ct.forEach(o),
        ot.forEach(o),
        (ol = N(W)),
        (jt = _(W, "DIV", { class: !0 }));
      var tt = u(jt);
      wt = _(tt, "BUTTON", { class: !0 });
      var ll = u(wt);
      (Wt = P(ll, "Close")),
        ll.forEach(o),
        tt.forEach(o),
        W.forEach(o),
        De.forEach(o),
        this.h();
    },
    h() {
      n(r, "class", "text-xl font-semibold"),
        n(c, "class", "text-3xl leading-none"),
        n(l, "class", "flex justify-between items-center mb-4"),
        n(E, "for", "filterTeam"),
        n(E, "class", "text-sm"),
        (g.__value = -1),
        (g.value = g.__value),
        n(w, "id", "filterTeam"),
        n(
          w,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        a[4] === void 0 && pl(() => a[22].call(w)),
        n(H, "for", "filterPosition"),
        n(H, "class", "text-sm"),
        (X.__value = -1),
        (X.value = X.__value),
        (j.__value = 0),
        (j.value = j.__value),
        (O.__value = 1),
        (O.value = O.__value),
        (A.__value = 2),
        (A.value = A.__value),
        ($.__value = 3),
        ($.value = $.__value),
        n(Z, "id", "filterPosition"),
        n(
          Z,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        a[0] === void 0 && pl(() => a[23].call(Z)),
        n(v, "class", "grid grid-cols-1 md:grid-cols-2 gap-4 mb-4"),
        n(J, "for", "minValue"),
        n(J, "class", "text-sm"),
        n(Q, "id", "minValue"),
        n(Q, "type", "number"),
        n(
          Q,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        n(S, "for", "maxValue"),
        n(S, "class", "text-sm"),
        n(ce, "id", "maxValue"),
        n(ce, "type", "number"),
        n(
          ce,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        n(Y, "class", "grid grid-cols-1 md:grid-cols-2 gap-4 mb-4"),
        n(ue, "for", "filterSurname"),
        n(ue, "class", "text-sm"),
        n(Ve, "id", "filterSurname"),
        n(Ve, "type", "text"),
        n(
          Ve,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        n(Ve, "placeholder", "Enter"),
        n(de, "class", "mb-4"),
        n(Ie, "for", "bankBalance"),
        n(Ie, "class", "font-bold"),
        n(Te, "class", "mb-4"),
        n(m, "class", "mb-4"),
        n(mt, "class", "text-left p-2"),
        n(G, "class", "text-left p-2"),
        n(oe, "class", "text-left p-2"),
        n(ye, "class", "text-left p-2"),
        n(je, "class", "text-left p-2"),
        n(Ae, "class", "text-left p-2"),
        n(dt, "class", "w-full"),
        n(bt, "class", "overflow-x-auto"),
        n(yt, "class", "flex space-x-1 min-w-max"),
        n(at, "class", "justify-center mt-4 pb-4 overflow-x-auto"),
        n(wt, "class", "px-4 py-2 fpl-purple-btn rounded-md text-white"),
        n(jt, "class", "flex justify-end mt-4"),
        n(
          t,
          "class",
          "relative top-20 mx-auto p-5 border w-full max-w-4xl shadow-lg rounded-md bg-panel text-white"
        ),
        n(
          e,
          "class",
          "fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop svelte-1jzawa3"
        );
    },
    m(he, De) {
      z(he, e, De),
        s(e, t),
        s(t, l),
        s(l, r),
        s(r, i),
        s(l, p),
        s(l, c),
        s(c, f),
        s(t, d),
        s(t, m),
        s(m, v),
        s(v, b),
        s(b, E),
        s(E, y),
        s(b, k),
        s(b, w),
        s(w, g),
        s(g, I);
      for (let W = 0; W < Re.length; W += 1) Re[W] && Re[W].m(w, null);
      Pt(w, a[4], !0),
        s(v, C),
        s(v, x),
        s(x, H),
        s(H, U),
        s(x, F),
        s(x, Z),
        s(Z, X),
        s(X, re),
        s(Z, j),
        s(j, R),
        s(Z, O),
        s(O, ne),
        s(Z, A),
        s(A, M),
        s(Z, $),
        s($, te),
        Pt(Z, a[0], !0),
        s(m, D),
        s(m, Y),
        s(Y, K),
        s(K, J),
        s(J, B),
        s(K, ie),
        s(K, Q),
        Vl(Q, a[6]),
        s(Y, Ee),
        s(Y, L),
        s(L, S),
        s(S, se),
        s(L, ke),
        s(L, ce),
        Vl(ce, a[7]),
        s(m, Ne),
        s(m, de),
        s(de, ue),
        s(ue, xe),
        s(de, Pe),
        s(de, Ve),
        Vl(Ve, a[5]),
        s(m, Ye),
        s(m, Te),
        s(Te, Ie),
        s(Ie, Ze),
        s(Ie, He),
        s(Ie, Xe),
        s(t, lt),
        s(t, bt),
        s(bt, dt),
        s(dt, Mt),
        s(Mt, Ue),
        s(Ue, mt),
        s(mt, Kt),
        s(Ue, qt),
        s(Ue, G),
        s(G, q),
        s(Ue, le),
        s(Ue, oe),
        s(oe, me),
        s(Ue, ge),
        s(Ue, ye),
        s(ye, Se),
        s(Ue, ze),
        s(Ue, je),
        s(je, gt),
        s(Ue, et),
        s(Ue, Ae),
        s(Ae, Nt),
        s(dt, At),
        s(dt, ut);
      for (let W = 0; W < Ce.length; W += 1) Ce[W] && Ce[W].m(ut, null);
      s(t, nl), s(t, at), s(at, yt);
      for (let W = 0; W < $e.length; W += 1) $e[W] && $e[W].m(yt, null);
      s(t, ol),
        s(t, jt),
        s(jt, wt),
        s(wt, Wt),
        (Rt = !0),
        il ||
          ((zt = [
            we(c, "click", function () {
              Nl(a[2]) && a[2].apply(this, arguments);
            }),
            we(w, "change", a[22]),
            we(Z, "change", a[23]),
            we(Q, "input", a[24]),
            we(ce, "input", a[25]),
            we(Ve, "input", a[26]),
            we(wt, "click", function () {
              Nl(a[2]) && a[2].apply(this, arguments);
            }),
            we(t, "click", Jl(a[20])),
            we(t, "keydown", Jl(a[21])),
            we(e, "click", function () {
              Nl(a[2]) && a[2].apply(this, arguments);
            }),
            we(e, "keydown", function () {
              Nl(a[2]) && a[2].apply(this, arguments);
            }),
          ]),
          (il = !0));
    },
    p(he, De) {
      if (((a = he), De[0] & 2048)) {
        $t = a[11];
        let W;
        for (W = 0; W < $t.length; W += 1) {
          const st = qa(a, $t, W);
          Re[W]
            ? Re[W].p(st, De)
            : ((Re[W] = za(st)), Re[W].c(), Re[W].m(w, null));
        }
        for (; W < Re.length; W += 1) Re[W].d(1);
        Re.length = $t.length;
      }
      if (
        (De[0] & 2064 && Pt(w, a[4]),
        De[0] & 1 && Pt(Z, a[0]),
        De[0] & 64 && $l(Q.value) !== a[6] && Vl(Q, a[6]),
        De[0] & 128 && $l(ce.value) !== a[7] && Vl(ce, a[7]),
        De[0] & 32 && Ve.value !== a[5] && Vl(Ve, a[5]),
        (!Rt || De[0] & 8192) &&
          We !== (We = (a[13] / 4).toFixed(2) + "") &&
          be(He, We),
        De[0] & 37888)
      ) {
        Et = a[10];
        let W;
        for (W = 0; W < Et.length; W += 1) {
          const st = Ka(a, Et, W);
          Ce[W]
            ? (Ce[W].p(st, De), ae(Ce[W], 1))
            : ((Ce[W] = ls(st)), Ce[W].c(), ae(Ce[W], 1), Ce[W].m(ut, null));
        }
        for (ct(), W = Et.length; W < Ce.length; W += 1) Yt(W);
        ft();
      }
      if (De[0] & 17152) {
        ht = Array(Math.ceil(a[9].length / Xl));
        let W;
        for (W = 0; W < ht.length; W += 1) {
          const st = Xa(a, ht, W);
          $e[W]
            ? $e[W].p(st, De)
            : (($e[W] = as(st)), $e[W].c(), $e[W].m(yt, null));
        }
        for (; W < $e.length; W += 1) $e[W].d(1);
        $e.length = ht.length;
      }
    },
    i(he) {
      if (!Rt) {
        for (let De = 0; De < Et.length; De += 1) ae(Ce[De]);
        Rt = !0;
      }
    },
    o(he) {
      Ce = Ce.filter(Boolean);
      for (let De = 0; De < Ce.length; De += 1) fe(Ce[De]);
      Rt = !1;
    },
    d(he) {
      he && o(e), Vt(Re, he), Vt(Ce, he), Vt($e, he), (il = !1), Kl(zt);
    },
  };
}
function za(a) {
  let e,
    t = a[39].friendlyName + "",
    l,
    r;
  return {
    c() {
      (e = h("option")), (l = T(t)), this.h();
    },
    l(i) {
      e = _(i, "OPTION", {});
      var p = u(e);
      (l = P(p, t)), p.forEach(o), this.h();
    },
    h() {
      (e.__value = r = a[39].id), (e.value = e.__value);
    },
    m(i, p) {
      z(i, e, p), s(e, l);
    },
    p(i, p) {
      p[0] & 2048 && t !== (t = i[39].friendlyName + "") && be(l, t),
        p[0] & 2048 &&
          r !== (r = i[39].id) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(i) {
      i && o(e);
    },
  };
}
function Ja(a) {
  let e, t;
  return {
    c() {
      (e = h("td")), (t = T("GK")), this.h();
    },
    l(l) {
      e = _(l, "TD", { class: !0 });
      var r = u(e);
      (t = P(r, "GK")), r.forEach(o), this.h();
    },
    h() {
      n(e, "class", "p-2");
    },
    m(l, r) {
      z(l, e, r), s(e, t);
    },
    d(l) {
      l && o(e);
    },
  };
}
function Qa(a) {
  let e, t;
  return {
    c() {
      (e = h("td")), (t = T("DF")), this.h();
    },
    l(l) {
      e = _(l, "TD", { class: !0 });
      var r = u(e);
      (t = P(r, "DF")), r.forEach(o), this.h();
    },
    h() {
      n(e, "class", "p-2");
    },
    m(l, r) {
      z(l, e, r), s(e, t);
    },
    d(l) {
      l && o(e);
    },
  };
}
function es(a) {
  let e, t;
  return {
    c() {
      (e = h("td")), (t = T("MF")), this.h();
    },
    l(l) {
      e = _(l, "TD", { class: !0 });
      var r = u(e);
      (t = P(r, "MF")), r.forEach(o), this.h();
    },
    h() {
      n(e, "class", "p-2");
    },
    m(l, r) {
      z(l, e, r), s(e, t);
    },
    d(l) {
      l && o(e);
    },
  };
}
function ts(a) {
  let e, t;
  return {
    c() {
      (e = h("td")), (t = T("FW")), this.h();
    },
    l(l) {
      e = _(l, "TD", { class: !0 });
      var r = u(e);
      (t = P(r, "FW")), r.forEach(o), this.h();
    },
    h() {
      n(e, "class", "p-2");
    },
    m(l, r) {
      z(l, e, r), s(e, t);
    },
    d(l) {
      l && o(e);
    },
  };
}
function qs(a) {
  let e, t, l, r, i;
  t = new Vs({ props: { className: "w-6 h-6 p-2" } });
  function p() {
    return a[27](a[37]);
  }
  return {
    c() {
      (e = h("button")), Me(t.$$.fragment), this.h();
    },
    l(c) {
      e = _(c, "BUTTON", { class: !0 });
      var f = u(e);
      Oe(t.$$.fragment, f), f.forEach(o), this.h();
    },
    h() {
      n(e, "class", "text-xl rounded fpl-button flex items-center");
    },
    m(c, f) {
      z(c, e, f),
        Be(t, e, null),
        (l = !0),
        r || ((i = we(e, "click", p)), (r = !0));
    },
    p(c, f) {
      a = c;
    },
    i(c) {
      l || (ae(t.$$.fragment, c), (l = !0));
    },
    o(c) {
      fe(t.$$.fragment, c), (l = !1);
    },
    d(c) {
      c && o(e), Fe(t), (r = !1), i();
    },
  };
}
function Ws(a) {
  let e,
    t = a[12][a[36]] + "",
    l;
  return {
    c() {
      (e = h("span")), (l = T(t)), this.h();
    },
    l(r) {
      e = _(r, "SPAN", { class: !0 });
      var i = u(e);
      (l = P(i, t)), i.forEach(o), this.h();
    },
    h() {
      n(e, "class", "text-xs");
    },
    m(r, i) {
      z(r, e, i), s(e, l);
    },
    p(r, i) {
      i[0] & 4096 && t !== (t = r[12][r[36]] + "") && be(l, t);
    },
    i: Le,
    o: Le,
    d(r) {
      r && o(e);
    },
  };
}
function ls(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c = a[37].firstName + "",
    f,
    d,
    m = a[37].lastName + "",
    v,
    b,
    E,
    y,
    k,
    w,
    g = a[37].team?.abbreviatedName + "",
    I,
    C,
    x,
    H,
    U = (Number(a[37].value) / 4).toFixed(2) + "",
    F,
    Z,
    X,
    re,
    j = a[37].totalPoints + "",
    R,
    O,
    ne,
    A,
    M,
    $,
    te,
    D,
    Y = a[37].position === 0 && Ja(),
    K = a[37].position === 1 && Qa(),
    J = a[37].position === 2 && es(),
    B = a[37].position === 3 && ts();
  k = new Gl({
    props: {
      className: "w-6 h-6 mr-2",
      primaryColour: a[37].team?.primaryColourHex,
      secondaryColour: a[37].team?.secondaryColourHex,
      thirdColour: a[37].team?.thirdColourHex,
    },
  });
  const ie = [Ws, qs],
    Q = [];
  function Ee(L, S) {
    return L[12][L[36]] ? 0 : 1;
  }
  return (
    (M = Ee(a)),
    ($ = Q[M] = ie[M](a)),
    {
      c() {
        (e = h("tr")),
          Y && Y.c(),
          (t = V()),
          K && K.c(),
          (l = V()),
          J && J.c(),
          (r = V()),
          B && B.c(),
          (i = V()),
          (p = h("td")),
          (f = T(c)),
          (d = V()),
          (v = T(m)),
          (b = V()),
          (E = h("td")),
          (y = h("p")),
          Me(k.$$.fragment),
          (w = V()),
          (I = T(g)),
          (C = V()),
          (x = h("td")),
          (H = T("£")),
          (F = T(U)),
          (Z = T("m")),
          (X = V()),
          (re = h("td")),
          (R = T(j)),
          (O = V()),
          (ne = h("td")),
          (A = h("div")),
          $.c(),
          (te = V()),
          this.h();
      },
      l(L) {
        e = _(L, "TR", {});
        var S = u(e);
        Y && Y.l(S),
          (t = N(S)),
          K && K.l(S),
          (l = N(S)),
          J && J.l(S),
          (r = N(S)),
          B && B.l(S),
          (i = N(S)),
          (p = _(S, "TD", { class: !0 }));
        var se = u(p);
        (f = P(se, c)),
          (d = N(se)),
          (v = P(se, m)),
          se.forEach(o),
          (b = N(S)),
          (E = _(S, "TD", { class: !0 }));
        var ke = u(E);
        y = _(ke, "P", { class: !0 });
        var ce = u(y);
        Oe(k.$$.fragment, ce),
          (w = N(ce)),
          (I = P(ce, g)),
          ce.forEach(o),
          ke.forEach(o),
          (C = N(S)),
          (x = _(S, "TD", { class: !0 }));
        var Ne = u(x);
        (H = P(Ne, "£")),
          (F = P(Ne, U)),
          (Z = P(Ne, "m")),
          Ne.forEach(o),
          (X = N(S)),
          (re = _(S, "TD", { class: !0 }));
        var de = u(re);
        (R = P(de, j)),
          de.forEach(o),
          (O = N(S)),
          (ne = _(S, "TD", { class: !0 }));
        var ue = u(ne);
        A = _(ue, "DIV", { class: !0 });
        var xe = u(A);
        $.l(xe),
          xe.forEach(o),
          ue.forEach(o),
          (te = N(S)),
          S.forEach(o),
          this.h();
      },
      h() {
        n(p, "class", "p-2"),
          n(y, "class", "flex items-center"),
          n(E, "class", "p-2"),
          n(x, "class", "p-2"),
          n(re, "class", "p-2"),
          n(A, "class", "w-1/6 flex items-center"),
          n(ne, "class", "p-2");
      },
      m(L, S) {
        z(L, e, S),
          Y && Y.m(e, null),
          s(e, t),
          K && K.m(e, null),
          s(e, l),
          J && J.m(e, null),
          s(e, r),
          B && B.m(e, null),
          s(e, i),
          s(e, p),
          s(p, f),
          s(p, d),
          s(p, v),
          s(e, b),
          s(e, E),
          s(E, y),
          Be(k, y, null),
          s(y, w),
          s(y, I),
          s(e, C),
          s(e, x),
          s(x, H),
          s(x, F),
          s(x, Z),
          s(e, X),
          s(e, re),
          s(re, R),
          s(e, O),
          s(e, ne),
          s(ne, A),
          Q[M].m(A, null),
          s(e, te),
          (D = !0);
      },
      p(L, S) {
        L[37].position === 0
          ? Y || ((Y = Ja()), Y.c(), Y.m(e, t))
          : Y && (Y.d(1), (Y = null)),
          L[37].position === 1
            ? K || ((K = Qa()), K.c(), K.m(e, l))
            : K && (K.d(1), (K = null)),
          L[37].position === 2
            ? J || ((J = es()), J.c(), J.m(e, r))
            : J && (J.d(1), (J = null)),
          L[37].position === 3
            ? B || ((B = ts()), B.c(), B.m(e, i))
            : B && (B.d(1), (B = null)),
          (!D || S[0] & 1024) && c !== (c = L[37].firstName + "") && be(f, c),
          (!D || S[0] & 1024) && m !== (m = L[37].lastName + "") && be(v, m);
        const se = {};
        S[0] & 1024 && (se.primaryColour = L[37].team?.primaryColourHex),
          S[0] & 1024 && (se.secondaryColour = L[37].team?.secondaryColourHex),
          S[0] & 1024 && (se.thirdColour = L[37].team?.thirdColourHex),
          k.$set(se),
          (!D || S[0] & 1024) &&
            g !== (g = L[37].team?.abbreviatedName + "") &&
            be(I, g),
          (!D || S[0] & 1024) &&
            U !== (U = (Number(L[37].value) / 4).toFixed(2) + "") &&
            be(F, U),
          (!D || S[0] & 1024) && j !== (j = L[37].totalPoints + "") && be(R, j);
        let ke = M;
        (M = Ee(L)),
          M === ke
            ? Q[M].p(L, S)
            : (ct(),
              fe(Q[ke], 1, 1, () => {
                Q[ke] = null;
              }),
              ft(),
              ($ = Q[M]),
              $ ? $.p(L, S) : (($ = Q[M] = ie[M](L)), $.c()),
              ae($, 1),
              $.m(A, null));
      },
      i(L) {
        D || (ae(k.$$.fragment, L), ae($), (D = !0));
      },
      o(L) {
        fe(k.$$.fragment, L), fe($), (D = !1);
      },
      d(L) {
        L && o(e),
          Y && Y.d(),
          K && K.d(),
          J && J.d(),
          B && B.d(),
          Fe(k),
          Q[M].d();
      },
    }
  );
}
function as(a) {
  let e,
    t = a[36] + 1 + "",
    l,
    r,
    i,
    p;
  function c() {
    return a[28](a[36]);
  }
  return {
    c() {
      (e = h("button")), (l = T(t)), (r = V()), this.h();
    },
    l(f) {
      e = _(f, "BUTTON", { class: !0 });
      var d = u(e);
      (l = P(d, t)), (r = N(d)), d.forEach(o), this.h();
    },
    h() {
      n(
        e,
        "class",
        "px-4 py-2 bg-gray-700 rounded-md text-white hover:bg-gray-600 svelte-1jzawa3"
      ),
        Ta(e, "active", a[36] + 1 === a[8]);
    },
    m(f, d) {
      z(f, e, d), s(e, l), s(e, r), i || ((p = we(e, "click", c)), (i = !0));
    },
    p(f, d) {
      (a = f), d[0] & 256 && Ta(e, "active", a[36] + 1 === a[8]);
    },
    d(f) {
      f && o(e), (i = !1), p();
    },
  };
}
function zs(a) {
  let e,
    t,
    l = a[1] && Wa(a);
  return {
    c() {
      l && l.c(), (e = rl());
    },
    l(r) {
      l && l.l(r), (e = rl());
    },
    m(r, i) {
      l && l.m(r, i), z(r, e, i), (t = !0);
    },
    p(r, i) {
      r[1]
        ? l
          ? (l.p(r, i), i[0] & 2 && ae(l, 1))
          : ((l = Wa(r)), l.c(), ae(l, 1), l.m(e.parentNode, e))
        : l &&
          (ct(),
          fe(l, 1, 1, () => {
            l = null;
          }),
          ft());
    },
    i(r) {
      t || (ae(l), (t = !0));
    },
    o(r) {
      fe(l), (t = !1);
    },
    d(r) {
      l && l.d(r), r && o(e);
    },
  };
}
const Xl = 10;
function Js(a, e, t) {
  let l,
    r,
    i,
    p,
    c,
    f = Le,
    d = () => (f(), (f = Cs(w, (B) => t(13, (c = B)))), w);
  a.$$.on_destroy.push(() => f());
  let { showAddPlayer: m } = e,
    { closeAddPlayerModal: v } = e,
    { handlePlayerSelection: b } = e,
    { fantasyTeam: E = al(null) } = e,
    { filterPosition: y = -1 } = e,
    { filterColumn: k = -1 } = e,
    { bankBalance: w = al(0) } = e;
  d();
  let g = [],
    I = [],
    C,
    x,
    H = -1,
    U = "",
    F = 0,
    Z = 0,
    X = 1;
  la(async () => {
    try {
      await sl.sync(),
        await Zl.sync(),
        (C = sl.subscribe((ie) => {
          t(11, (I = ie));
        })),
        (x = Zl.subscribe((ie) => {
          t(19, (g = ie));
        }));
      let B = Qe(E);
      i = re(B?.playerIds ?? []);
    } catch (B) {
      jl.show("Error loading add player modal.", "error"),
        console.error("Error fetching homepage data:", B);
    }
  }),
    aa(() => {
      C?.(), x?.();
    });
  function re(B) {
    const ie = {};
    return (
      B.forEach((Q) => {
        const Ee = g.find((L) => L.id === Q);
        Ee && (ie[Ee.teamId] || (ie[Ee.teamId] = 0), ie[Ee.teamId]++);
      }),
      ie
    );
  }
  function j(B) {
    if ((i[B.teamId] || 0) >= 2) return "Max 2 Per Team";
    let Q = Qe(E);
    if (!(Qe(w) >= Number(B.value))) return "Over Budget";
    if (Q && Q.playerIds.includes(B.id)) return "Selected";
    const L = { 0: 0, 1: 0, 2: 0, 3: 0 };
    return (
      Q &&
        Q.playerIds.forEach((ke) => {
          const ce = g.find((Ne) => Ne.id === ke);
          ce && L[ce.position]++;
        }),
      L[B.position]++,
      ["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"].some(
        (ke) => {
          const [ce, Ne, de] = ke.split("-").map(Number),
            ue = Math.max(0, ce - (L[1] || 0)),
            xe = Math.max(0, Ne - (L[2] || 0)),
            Pe = Math.max(0, de - (L[3] || 0)),
            Ve = Math.max(0, 1 - (L[0] || 0)),
            Ye = ue + xe + Pe + Ve;
          return Object.values(L).reduce((Ie, Ze) => Ie + Ze, 0) + Ye <= 11;
        }
      )
        ? null
        : "Invalid Formation"
    );
  }
  function R(B) {
    t(8, (X = B));
  }
  function O(B) {
    b(B), v(), t(9, (l = []));
  }
  function ne(B) {
    Ql.call(this, a, B);
  }
  function A(B) {
    Ql.call(this, a, B);
  }
  function M() {
    (H = _l(this)), t(4, H), t(11, I);
  }
  function $() {
    (y = _l(this)), t(0, y);
  }
  function te() {
    (F = $l(this.value)), t(6, F);
  }
  function D() {
    (Z = $l(this.value)), t(7, Z);
  }
  function Y() {
    (U = this.value), t(5, U);
  }
  const K = (B) => O(B),
    J = (B) => R(B + 1);
  return (
    (a.$$set = (B) => {
      "showAddPlayer" in B && t(1, (m = B.showAddPlayer)),
        "closeAddPlayerModal" in B && t(2, (v = B.closeAddPlayerModal)),
        "handlePlayerSelection" in B && t(16, (b = B.handlePlayerSelection)),
        "fantasyTeam" in B && t(17, (E = B.fantasyTeam)),
        "filterPosition" in B && t(0, (y = B.filterPosition)),
        "filterColumn" in B && t(18, (k = B.filterColumn)),
        "bankBalance" in B && d(t(3, (w = B.bankBalance)));
    }),
    (a.$$.update = () => {
      a.$$.dirty[0] & 786673 &&
        t(
          9,
          (l = g.filter(
            (B) =>
              (H === -1 || B.teamId === H) &&
              (y === -1 || B.position === y) &&
              k > -2 &&
              (F === 0 || B.value >= F) &&
              (Z === 0 || B.value <= Z) &&
              (U === "" || B.lastName.toLowerCase().includes(U.toLowerCase()))
          ))
        ),
        a.$$.dirty[0] & 393457 &&
          (H || y || k || F || Z || U) &&
          ((i = re(Qe(E)?.playerIds ?? [])), t(8, (X = 1))),
        a.$$.dirty[0] & 768 && t(10, (r = l.slice((X - 1) * Xl, X * Xl))),
        a.$$.dirty[0] & 131072 && (i = re(Qe(E)?.playerIds ?? [])),
        a.$$.dirty[0] & 1024 && t(12, (p = r.map((B) => j(B))));
    }),
    [
      y,
      m,
      v,
      w,
      H,
      U,
      F,
      Z,
      X,
      l,
      r,
      I,
      p,
      c,
      R,
      O,
      b,
      E,
      k,
      g,
      ne,
      A,
      M,
      $,
      te,
      D,
      Y,
      K,
      J,
    ]
  );
}
class Qs extends St {
  constructor(e) {
    super(),
      Lt(
        this,
        e,
        Js,
        zs,
        Ut,
        {
          showAddPlayer: 1,
          closeAddPlayerModal: 2,
          handlePlayerSelection: 16,
          fantasyTeam: 17,
          filterPosition: 0,
          filterColumn: 18,
          bankBalance: 3,
        },
        null,
        [-1, -1]
      );
  }
}
function er(a) {
  let e, t, l, r, i, p, c, f, d, m, v, b, E, y, k;
  return {
    c() {
      (e = pe("svg")),
        (t = pe("defs")),
        (l = pe("linearGradient")),
        (r = pe("linearGradient")),
        (i = pe("stop")),
        (p = pe("stop")),
        (c = pe("linearGradient")),
        (f = pe("stop")),
        (d = pe("stop")),
        (m = pe("linearGradient")),
        (v = pe("linearGradient")),
        (b = pe("g")),
        (E = pe("path")),
        (y = pe("path")),
        (k = pe("circle")),
        this.h();
    },
    l(w) {
      e = ve(w, "svg", {
        viewBox: !0,
        class: !0,
        xmlns: !0,
        "xmlns:xlink": !0,
      });
      var g = u(e);
      t = ve(g, "defs", {});
      var I = u(t);
      (l = ve(I, "linearGradient", { id: !0 })),
        u(l).forEach(o),
        (r = ve(I, "linearGradient", { id: !0 }));
      var C = u(r);
      (i = ve(C, "stop", { style: !0, offset: !0 })),
        u(i).forEach(o),
        (p = ve(C, "stop", { style: !0, offset: !0 })),
        u(p).forEach(o),
        C.forEach(o),
        (c = ve(I, "linearGradient", { id: !0 }));
      var x = u(c);
      (f = ve(x, "stop", { style: !0, offset: !0 })),
        u(f).forEach(o),
        (d = ve(x, "stop", { style: !0, offset: !0 })),
        u(d).forEach(o),
        x.forEach(o),
        (m = ve(I, "linearGradient", {
          id: !0,
          gradientUnits: !0,
          x1: !0,
          y1: !0,
          x2: !0,
          y2: !0,
          gradientTransform: !0,
          "xlink:href": !0,
        })),
        u(m).forEach(o),
        (v = ve(I, "linearGradient", {
          id: !0,
          gradientUnits: !0,
          x1: !0,
          y1: !0,
          x2: !0,
          y2: !0,
          gradientTransform: !0,
          "xlink:href": !0,
        })),
        u(v).forEach(o),
        I.forEach(o),
        (b = ve(g, "g", { transform: !0 }));
      var H = u(b);
      (E = ve(H, "path", { d: !0, style: !0, transform: !0 })),
        u(E).forEach(o),
        (y = ve(H, "path", { style: !0, transform: !0, d: !0 })),
        u(y).forEach(o),
        (k = ve(H, "circle", { style: !0, cx: !0, cy: !0, r: !0 })),
        u(k).forEach(o),
        H.forEach(o),
        g.forEach(o),
        this.h();
    },
    h() {
      n(l, "id", "gradient-2"),
        it(i, "stop-color", "rgb(251, 176, 59)"),
        n(i, "offset", "0"),
        it(p, "stop-color", "rgb(240, 90, 36)"),
        n(p, "offset", "1"),
        n(r, "id", "gradient-5"),
        it(f, "stop-color", "rgb(95, 37, 131)"),
        n(f, "offset", "0"),
        it(d, "stop-color", "rgb(237, 30, 121)"),
        n(d, "offset", "1"),
        n(c, "id", "gradient-6"),
        n(m, "id", "gradient-6-1"),
        n(m, "gradientUnits", "userSpaceOnUse"),
        n(m, "x1", "973.216"),
        n(m, "y1", "100.665"),
        n(m, "x2", "973.216"),
        n(m, "y2", "388.077"),
        n(
          m,
          "gradientTransform",
          "matrix(0.974127, -0.22842, 0.310454, 1.352474, -95.300314, 85.515158)"
        ),
        Pa(m, "xlink:href", "#gradient-6"),
        n(v, "id", "gradient-5-0"),
        n(v, "gradientUnits", "userSpaceOnUse"),
        n(v, "x1", "188.919"),
        n(v, "y1", "1.638"),
        n(v, "x2", "188.919"),
        n(v, "y2", "361.638"),
        n(
          v,
          "gradientTransform",
          "matrix(-0.999999, 0.0016, -0.002016, -1.25907, 376.779907, 357.264557)"
        ),
        Pa(v, "xlink:href", "#gradient-5"),
        n(
          E,
          "d",
          "M 188.919 181.638 m -180 0 a 180 180 0 1 0 360 0 a 180 180 0 1 0 -360 0 Z M 188.919 181.638 m -100 0 a 100 100 0 0 1 200 0 a 100 100 0 0 1 -200 0 Z"
        ),
        it(E, "fill", "url(#gradient-5-0)"),
        n(
          E,
          "transform",
          "matrix(1, 0.000074, -0.000074, 1, 61.094498, 68.347626)"
        ),
        it(y, "stroke-width", "0px"),
        it(y, "paint-order", "stroke"),
        it(y, "fill", "url(#gradient-6-1)"),
        n(
          y,
          "transform",
          "matrix(1.031731, 0.000001, 0, 1.020801, -634.597351, 0.544882)"
        ),
        n(
          y,
          "d",
          "M 958.327234958 100.664699414 A 175.433 175.433 0 0 1 958.327234958 388.077300586 L 913.296322517 323.766492741 A 96.924 96.924 0 0 0 913.296322517 164.975507259 Z"
        ),
        it(k, "fill", "rgb(25, 25, 25)"),
        n(k, "cx", "250"),
        n(k, "cy", "250"),
        n(k, "r", "100"),
        n(b, "transform", "matrix(1, 0, 0, 1, -69.98674, -69.986298)"),
        n(e, "viewBox", "0 0 361 361"),
        n(e, "class", a[0]),
        n(e, "xmlns", "http://www.w3.org/2000/svg"),
        n(e, "xmlns:xlink", "http://www.w3.org/1999/xlink");
    },
    m(w, g) {
      z(w, e, g),
        s(e, t),
        s(t, l),
        s(t, r),
        s(r, i),
        s(r, p),
        s(t, c),
        s(c, f),
        s(c, d),
        s(t, m),
        s(t, v),
        s(e, b),
        s(b, E),
        s(b, y),
        s(b, k);
    },
    p(w, [g]) {
      g & 1 && n(e, "class", w[0]);
    },
    i: Le,
    o: Le,
    d(w) {
      w && o(e);
    },
  };
}
function tr(a, e, t) {
  let { className: l = "" } = e;
  return (
    (a.$$set = (r) => {
      "className" in r && t(0, (l = r.className));
    }),
    [l]
  );
}
class ss extends St {
  constructor(e) {
    super(), Lt(this, e, tr, er, Ut, { className: 0 });
  }
}
function rs(a, e, t) {
  const l = a.slice();
  return (l[17] = e[t][0]), (l[2] = e[t][1]), l;
}
function ns(a, e, t) {
  const l = a.slice();
  return (
    (l[20] = e[t].fixture), (l[21] = e[t].homeTeam), (l[22] = e[t].awayTeam), l
  );
}
function os(a, e, t) {
  const l = a.slice();
  return (l[25] = e[t]), l;
}
function is(a) {
  let e,
    t,
    l = a[25] + "",
    r;
  return {
    c() {
      (e = h("option")), (t = T("Gameweek ")), (r = T(l)), this.h();
    },
    l(i) {
      e = _(i, "OPTION", {});
      var p = u(e);
      (t = P(p, "Gameweek ")), (r = P(p, l)), p.forEach(o), this.h();
    },
    h() {
      (e.__value = a[25]), (e.value = e.__value);
    },
    m(i, p) {
      z(i, e, p), s(e, t), s(e, r);
    },
    p: Le,
    d(i) {
      i && o(e);
    },
  };
}
function cs(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c,
    f,
    d,
    m,
    v,
    b,
    E,
    y,
    k,
    w,
    g,
    I,
    C = ta(Number(a[20].kickOff)) + "",
    x,
    H,
    U,
    F,
    Z,
    X = (a[21] ? a[21].friendlyName : "") + "",
    re,
    j,
    R,
    O,
    ne = (a[22] ? a[22].friendlyName : "") + "",
    A,
    M,
    $,
    te,
    D,
    Y = (a[20].status === 0 ? "-" : a[20].homeGoals) + "",
    K,
    J,
    B,
    ie = (a[20].status === 0 ? "-" : a[20].awayGoals) + "",
    Q,
    Ee,
    L;
  return (
    (p = new Gl({
      props: {
        primaryColour: a[21] ? a[21].primaryColourHex : "",
        secondaryColour: a[21] ? a[21].secondaryColourHex : "",
        thirdColour: a[21] ? a[21].thirdColourHex : "",
      },
    })),
    (y = new Gl({
      props: {
        primaryColour: a[22] ? a[22].primaryColourHex : "",
        secondaryColour: a[22] ? a[22].secondaryColourHex : "",
        thirdColour: a[22] ? a[22].thirdColourHex : "",
      },
    })),
    {
      c() {
        (e = h("div")),
          (t = h("div")),
          (l = h("div")),
          (r = h("div")),
          (i = h("a")),
          Me(p.$$.fragment),
          (f = V()),
          (d = h("span")),
          (m = T("v")),
          (v = V()),
          (b = h("div")),
          (E = h("a")),
          Me(y.$$.fragment),
          (w = V()),
          (g = h("div")),
          (I = h("span")),
          (x = T(C)),
          (H = V()),
          (U = h("div")),
          (F = h("div")),
          (Z = h("a")),
          (re = T(X)),
          (R = V()),
          (O = h("a")),
          (A = T(ne)),
          ($ = V()),
          (te = h("div")),
          (D = h("span")),
          (K = T(Y)),
          (J = V()),
          (B = h("span")),
          (Q = T(ie)),
          this.h();
      },
      l(S) {
        e = _(S, "DIV", { class: !0 });
        var se = u(e);
        t = _(se, "DIV", { class: !0 });
        var ke = u(t);
        l = _(ke, "DIV", { class: !0 });
        var ce = u(l);
        r = _(ce, "DIV", { class: !0 });
        var Ne = u(r);
        i = _(Ne, "A", { href: !0 });
        var de = u(i);
        Oe(p.$$.fragment, de),
          de.forEach(o),
          Ne.forEach(o),
          (f = N(ce)),
          (d = _(ce, "SPAN", { class: !0 }));
        var ue = u(d);
        (m = P(ue, "v")),
          ue.forEach(o),
          (v = N(ce)),
          (b = _(ce, "DIV", { class: !0 }));
        var xe = u(b);
        E = _(xe, "A", { href: !0 });
        var Pe = u(E);
        Oe(y.$$.fragment, Pe),
          Pe.forEach(o),
          xe.forEach(o),
          ce.forEach(o),
          (w = N(ke)),
          (g = _(ke, "DIV", { class: !0 }));
        var Ve = u(g);
        I = _(Ve, "SPAN", { class: !0 });
        var Ye = u(I);
        (x = P(Ye, C)),
          Ye.forEach(o),
          Ve.forEach(o),
          ke.forEach(o),
          (H = N(se)),
          (U = _(se, "DIV", { class: !0 }));
        var Te = u(U);
        F = _(Te, "DIV", { class: !0 });
        var Ie = u(F);
        Z = _(Ie, "A", { class: !0, href: !0 });
        var Ze = u(Z);
        (re = P(Ze, X)),
          Ze.forEach(o),
          (R = N(Ie)),
          (O = _(Ie, "A", { class: !0, href: !0 }));
        var We = u(O);
        (A = P(We, ne)),
          We.forEach(o),
          Ie.forEach(o),
          ($ = N(Te)),
          (te = _(Te, "DIV", { class: !0 }));
        var He = u(te);
        D = _(He, "SPAN", {});
        var Xe = u(D);
        (K = P(Xe, Y)), Xe.forEach(o), (J = N(He)), (B = _(He, "SPAN", {}));
        var lt = u(B);
        (Q = P(lt, ie)),
          lt.forEach(o),
          He.forEach(o),
          Te.forEach(o),
          se.forEach(o),
          this.h();
      },
      h() {
        n(i, "href", (c = `/club?id=${a[20].homeTeamId}`)),
          n(r, "class", "w-8 items-center justify-center"),
          n(d, "class", "font-bold text-lg"),
          n(E, "href", (k = `/club?id=${a[20].awayTeamId}`)),
          n(b, "class", "w-8 items-center justify-center"),
          n(l, "class", "flex w-1/2 space-x-4 justify-center"),
          n(I, "class", "text-sm ml-4 md:ml-0 text-left"),
          n(g, "class", "flex w-1/2 md:justify-center"),
          n(t, "class", "flex items-center w-1/2 ml-4"),
          n(Z, "class", "my-1"),
          n(Z, "href", (j = `/club?id=${a[20].homeTeamId}`)),
          n(O, "class", "my-1"),
          n(O, "href", (M = `/club?id=${a[20].awayTeamId}`)),
          n(
            F,
            "class",
            "flex flex-col min-w-[120px] md:min-w-[200px] text-xs 3xl:text-base"
          ),
          n(te, "class", "flex flex-col items-center text-xs"),
          n(U, "class", "flex items-center space-x-10 w-1/2 md:justify-center"),
          n(
            e,
            "class",
            (Ee = `flex items-center justify-between py-2 border-b border-gray-700  
              ${a[20].status === 0 ? "text-gray-400" : "text-white"}`)
          );
      },
      m(S, se) {
        z(S, e, se),
          s(e, t),
          s(t, l),
          s(l, r),
          s(r, i),
          Be(p, i, null),
          s(l, f),
          s(l, d),
          s(d, m),
          s(l, v),
          s(l, b),
          s(b, E),
          Be(y, E, null),
          s(t, w),
          s(t, g),
          s(g, I),
          s(I, x),
          s(e, H),
          s(e, U),
          s(U, F),
          s(F, Z),
          s(Z, re),
          s(F, R),
          s(F, O),
          s(O, A),
          s(U, $),
          s(U, te),
          s(te, D),
          s(D, K),
          s(te, J),
          s(te, B),
          s(B, Q),
          (L = !0);
      },
      p(S, se) {
        const ke = {};
        se & 2 && (ke.primaryColour = S[21] ? S[21].primaryColourHex : ""),
          se & 2 &&
            (ke.secondaryColour = S[21] ? S[21].secondaryColourHex : ""),
          se & 2 && (ke.thirdColour = S[21] ? S[21].thirdColourHex : ""),
          p.$set(ke),
          (!L || (se & 2 && c !== (c = `/club?id=${S[20].homeTeamId}`))) &&
            n(i, "href", c);
        const ce = {};
        se & 2 && (ce.primaryColour = S[22] ? S[22].primaryColourHex : ""),
          se & 2 &&
            (ce.secondaryColour = S[22] ? S[22].secondaryColourHex : ""),
          se & 2 && (ce.thirdColour = S[22] ? S[22].thirdColourHex : ""),
          y.$set(ce),
          (!L || (se & 2 && k !== (k = `/club?id=${S[20].awayTeamId}`))) &&
            n(E, "href", k),
          (!L || se & 2) &&
            C !== (C = ta(Number(S[20].kickOff)) + "") &&
            be(x, C),
          (!L || se & 2) &&
            X !== (X = (S[21] ? S[21].friendlyName : "") + "") &&
            be(re, X),
          (!L || (se & 2 && j !== (j = `/club?id=${S[20].homeTeamId}`))) &&
            n(Z, "href", j),
          (!L || se & 2) &&
            ne !== (ne = (S[22] ? S[22].friendlyName : "") + "") &&
            be(A, ne),
          (!L || (se & 2 && M !== (M = `/club?id=${S[20].awayTeamId}`))) &&
            n(O, "href", M),
          (!L || se & 2) &&
            Y !== (Y = (S[20].status === 0 ? "-" : S[20].homeGoals) + "") &&
            be(K, Y),
          (!L || se & 2) &&
            ie !== (ie = (S[20].status === 0 ? "-" : S[20].awayGoals) + "") &&
            be(Q, ie),
          (!L ||
            (se & 2 &&
              Ee !==
                (Ee = `flex items-center justify-between py-2 border-b border-gray-700  
              ${S[20].status === 0 ? "text-gray-400" : "text-white"}`))) &&
            n(e, "class", Ee);
      },
      i(S) {
        L || (ae(p.$$.fragment, S), ae(y.$$.fragment, S), (L = !0));
      },
      o(S) {
        fe(p.$$.fragment, S), fe(y.$$.fragment, S), (L = !1);
      },
      d(S) {
        S && o(e), Fe(p), Fe(y);
      },
    }
  );
}
function fs(a) {
  let e,
    t,
    l,
    r = a[17] + "",
    i,
    p,
    c,
    f,
    d = a[2],
    m = [];
  for (let b = 0; b < d.length; b += 1) m[b] = cs(ns(a, d, b));
  const v = (b) =>
    fe(m[b], 1, 1, () => {
      m[b] = null;
    });
  return {
    c() {
      (e = h("div")), (t = h("div")), (l = h("h2")), (i = T(r)), (p = V());
      for (let b = 0; b < m.length; b += 1) m[b].c();
      (c = V()), this.h();
    },
    l(b) {
      e = _(b, "DIV", {});
      var E = u(e);
      t = _(E, "DIV", { class: !0 });
      var y = u(t);
      l = _(y, "H2", { class: !0 });
      var k = u(l);
      (i = P(k, r)), k.forEach(o), y.forEach(o), (p = N(E));
      for (let w = 0; w < m.length; w += 1) m[w].l(E);
      (c = N(E)), E.forEach(o), this.h();
    },
    h() {
      n(l, "class", "date-header ml-4 text-xs"),
        n(
          t,
          "class",
          "flex items-center justify-between border border-gray-700 py-2 bg-light-gray"
        );
    },
    m(b, E) {
      z(b, e, E), s(e, t), s(t, l), s(l, i), s(e, p);
      for (let y = 0; y < m.length; y += 1) m[y] && m[y].m(e, null);
      s(e, c), (f = !0);
    },
    p(b, E) {
      if (((!f || E & 2) && r !== (r = b[17] + "") && be(i, r), E & 2)) {
        d = b[2];
        let y;
        for (y = 0; y < d.length; y += 1) {
          const k = ns(b, d, y);
          m[y]
            ? (m[y].p(k, E), ae(m[y], 1))
            : ((m[y] = cs(k)), m[y].c(), ae(m[y], 1), m[y].m(e, c));
        }
        for (ct(), y = d.length; y < m.length; y += 1) v(y);
        ft();
      }
    },
    i(b) {
      if (!f) {
        for (let E = 0; E < d.length; E += 1) ae(m[E]);
        f = !0;
      }
    },
    o(b) {
      m = m.filter(Boolean);
      for (let E = 0; E < m.length; E += 1) fe(m[E]);
      f = !1;
    },
    d(b) {
      b && o(e), Vt(m, b);
    },
  };
}
function lr(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c,
    f,
    d,
    m,
    v,
    b,
    E,
    y,
    k,
    w,
    g,
    I,
    C,
    x,
    H,
    U = a[3],
    F = [];
  for (let j = 0; j < U.length; j += 1) F[j] = is(os(a, U, j));
  let Z = Object.entries(a[1]),
    X = [];
  for (let j = 0; j < Z.length; j += 1) X[j] = fs(rs(a, Z, j));
  const re = (j) =>
    fe(X[j], 1, 1, () => {
      X[j] = null;
    });
  return {
    c() {
      (e = h("div")),
        (t = h("div")),
        (l = h("div")),
        (r = h("h1")),
        (i = T("Fixtures")),
        (p = V()),
        (c = h("div")),
        (f = h("button")),
        (d = T("<")),
        (v = V()),
        (b = h("select"));
      for (let j = 0; j < F.length; j += 1) F[j].c();
      (E = V()), (y = h("button")), (k = T(">")), (g = V()), (I = h("div"));
      for (let j = 0; j < X.length; j += 1) X[j].c();
      this.h();
    },
    l(j) {
      e = _(j, "DIV", { class: !0 });
      var R = u(e);
      t = _(R, "DIV", { class: !0 });
      var O = u(t);
      l = _(O, "DIV", { class: !0 });
      var ne = u(l);
      r = _(ne, "H1", { class: !0 });
      var A = u(r);
      (i = P(A, "Fixtures")),
        A.forEach(o),
        ne.forEach(o),
        (p = N(O)),
        (c = _(O, "DIV", { class: !0 }));
      var M = u(c);
      f = _(M, "BUTTON", { class: !0 });
      var $ = u(f);
      (d = P($, "<")),
        $.forEach(o),
        (v = N(M)),
        (b = _(M, "SELECT", { class: !0 }));
      var te = u(b);
      for (let K = 0; K < F.length; K += 1) F[K].l(te);
      te.forEach(o), (E = N(M)), (y = _(M, "BUTTON", { class: !0 }));
      var D = u(y);
      (k = P(D, ">")),
        D.forEach(o),
        M.forEach(o),
        (g = N(O)),
        (I = _(O, "DIV", {}));
      var Y = u(I);
      for (let K = 0; K < X.length; K += 1) X[K].l(Y);
      Y.forEach(o), O.forEach(o), R.forEach(o), this.h();
    },
    h() {
      n(r, "class", "mx-4 m-2 font-bold"),
        n(l, "class", "flex items-center justify-between py-2 bg-light-gray"),
        n(f, "class", "text-2xl rounded fpl-button px-3 py-1"),
        (f.disabled = m = a[0] === 1),
        n(b, "class", "p-2 fpl-dropdown text-sm md:text-xl text-center"),
        a[0] === void 0 && pl(() => a[8].call(b)),
        n(y, "class", "text-2xl rounded fpl-button px-3 py-1"),
        (y.disabled = w = a[0] === 38),
        n(c, "class", "flex items-center space-x-2 m-3 mx-4"),
        n(t, "class", "container-fluid"),
        n(e, "class", "bg-panel rounded-md m-4 flex-1");
    },
    m(j, R) {
      z(j, e, R),
        s(e, t),
        s(t, l),
        s(l, r),
        s(r, i),
        s(t, p),
        s(t, c),
        s(c, f),
        s(f, d),
        s(c, v),
        s(c, b);
      for (let O = 0; O < F.length; O += 1) F[O] && F[O].m(b, null);
      Pt(b, a[0], !0), s(c, E), s(c, y), s(y, k), s(t, g), s(t, I);
      for (let O = 0; O < X.length; O += 1) X[O] && X[O].m(I, null);
      (C = !0),
        x ||
          ((H = [
            we(f, "click", a[7]),
            we(b, "change", a[8]),
            we(y, "click", a[9]),
          ]),
          (x = !0));
    },
    p(j, [R]) {
      if (
        ((!C || (R & 9 && m !== (m = j[0] === 1))) && (f.disabled = m), R & 8)
      ) {
        U = j[3];
        let O;
        for (O = 0; O < U.length; O += 1) {
          const ne = os(j, U, O);
          F[O] ? F[O].p(ne, R) : ((F[O] = is(ne)), F[O].c(), F[O].m(b, null));
        }
        for (; O < F.length; O += 1) F[O].d(1);
        F.length = U.length;
      }
      if (
        (R & 9 && Pt(b, j[0]),
        (!C || (R & 9 && w !== (w = j[0] === 38))) && (y.disabled = w),
        R & 2)
      ) {
        Z = Object.entries(j[1]);
        let O;
        for (O = 0; O < Z.length; O += 1) {
          const ne = rs(j, Z, O);
          X[O]
            ? (X[O].p(ne, R), ae(X[O], 1))
            : ((X[O] = fs(ne)), X[O].c(), ae(X[O], 1), X[O].m(I, null));
        }
        for (ct(), O = Z.length; O < X.length; O += 1) re(O);
        ft();
      }
    },
    i(j) {
      if (!C) {
        for (let R = 0; R < Z.length; R += 1) ae(X[R]);
        C = !0;
      }
    },
    o(j) {
      X = X.filter(Boolean);
      for (let R = 0; R < X.length; R += 1) fe(X[R]);
      C = !1;
    },
    d(j) {
      j && o(e), Vt(F, j), Vt(X, j), (x = !1), Kl(H);
    },
  };
}
function ar(a, e, t) {
  let l,
    r,
    i = [],
    p = [],
    c = [],
    f = 1,
    d = Array.from({ length: 38 }, (I, C) => C + 1),
    m,
    v,
    b;
  la(async () => {
    await sl.sync(),
      await ea.sync(),
      await Yl.sync(),
      (m = sl.subscribe((I) => {
        i = I;
      })),
      (v = ea.subscribe((I) => {
        t(2, (p = I)),
          t(
            5,
            (c = p.map((C) => ({
              fixture: C,
              homeTeam: y(C.homeTeamId),
              awayTeam: y(C.awayTeamId),
            })))
          );
      })),
      (b = Yl.subscribe((I) => {}));
  }),
    aa(() => {
      m?.(), v?.(), b?.();
    });
  const E = (I) => {
    t(0, (f = Math.max(1, Math.min(38, f + I))));
  };
  function y(I) {
    return i.find((C) => C.id === I);
  }
  const k = () => E(-1);
  function w() {
    (f = _l(this)), t(0, f), t(3, d);
  }
  const g = () => E(1);
  return (
    (a.$$.update = () => {
      a.$$.dirty & 33 &&
        t(6, (l = c.filter(({ fixture: I }) => I.gameweek === f))),
        a.$$.dirty & 64 &&
          t(
            1,
            (r = l.reduce((I, C) => {
              const x = new Date(Number(C.fixture.kickOff) / 1e6),
                U = new Intl.DateTimeFormat("en-GB", {
                  weekday: "long",
                  day: "numeric",
                  month: "long",
                  year: "numeric",
                }).format(x);
              return I[U] || (I[U] = []), I[U].push(C), I;
            }, {}))
          );
    }),
    [f, r, p, d, E, c, l, k, w, g]
  );
}
class sr extends St {
  constructor(e) {
    super(), Lt(this, e, ar, lr, Ut, {});
  }
}
function rr(a) {
  let e, t, l, r, i, p, c, f, d, m, v, b, E, y, k, w, g;
  return {
    c() {
      (e = pe("svg")),
        (t = pe("g")),
        (l = pe("path")),
        (r = pe("path")),
        (i = pe("path")),
        (p = pe("g")),
        (c = pe("path")),
        (f = pe("defs")),
        (d = pe("filter")),
        (m = pe("feFlood")),
        (v = pe("feColorMatrix")),
        (b = pe("feOffset")),
        (E = pe("feGaussianBlur")),
        (y = pe("feComposite")),
        (k = pe("feColorMatrix")),
        (w = pe("feBlend")),
        (g = pe("feBlend")),
        this.h();
    },
    l(I) {
      e = ve(I, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var C = u(e);
      t = ve(C, "g", { filter: !0 });
      var x = u(t);
      (l = ve(x, "path", { d: !0, fill: !0 })),
        u(l).forEach(o),
        (r = ve(x, "path", { d: !0, fill: !0 })),
        u(r).forEach(o),
        (i = ve(x, "path", { d: !0, fill: !0 })),
        u(i).forEach(o),
        x.forEach(o),
        (p = ve(C, "g", { transform: !0 }));
      var H = u(p);
      (c = ve(H, "path", { d: !0, fill: !0 })),
        u(c).forEach(o),
        H.forEach(o),
        (f = ve(C, "defs", {}));
      var U = u(f);
      d = ve(U, "filter", {
        id: !0,
        x: !0,
        y: !0,
        width: !0,
        height: !0,
        filterUnits: !0,
      });
      var F = u(d);
      (m = ve(F, "feFlood", { "flood-opacity": !0, result: !0 })),
        u(m).forEach(o),
        (v = ve(F, "feColorMatrix", {
          in: !0,
          type: !0,
          values: !0,
          result: !0,
        })),
        u(v).forEach(o),
        (b = ve(F, "feOffset", { dy: !0 })),
        u(b).forEach(o),
        (E = ve(F, "feGaussianBlur", { stdDeviation: !0 })),
        u(E).forEach(o),
        (y = ve(F, "feComposite", { in2: !0, operator: !0 })),
        u(y).forEach(o),
        (k = ve(F, "feColorMatrix", { type: !0, values: !0 })),
        u(k).forEach(o),
        (w = ve(F, "feBlend", { mode: !0, in2: !0, result: !0 })),
        u(w).forEach(o),
        (g = ve(F, "feBlend", { mode: !0, in: !0, in2: !0, result: !0 })),
        u(g).forEach(o),
        F.forEach(o),
        U.forEach(o),
        C.forEach(o),
        this.h();
    },
    h() {
      n(
        l,
        "d",
        "M65.9308 38.3253L63.5966 33.0215L63.642 33.2129C63.5966 34.2107 63.5603 35.2633 63.533 36.366C63.4831 38.3299 63.4604 40.4442 63.4604 42.6587C63.4604 54.9386 64.1597 70.308 64.8727 79.9999H21.1266C21.835 70.2989 22.5389 54.9159 22.5389 42.6313C22.5389 40.4214 22.5162 38.3162 22.4663 36.3569C22.439 35.2542 22.4027 34.2062 22.3573 33.2129L22.3982 33.0215L20.0685 38.3253L9.30566 33.3131L20.5453 10.6213L20.5862 10.5438L20.6271 10.4573C20.6271 10.4573 31.6578 6.72087 32.0166 6.3609C32.0983 6.27889 32.2346 6.09662 32.3935 5.86424C34.2554 8.43871 36.6668 10.6122 39.4688 12.2252C40.2726 12.69 41.1037 13.1046 41.971 13.4737C42.3026 13.615 42.6432 13.7517 42.9883 13.8747V13.8838C42.9883 13.8838 42.9928 13.8838 42.9974 13.8793C43.0019 13.8838 43.0065 13.8838 43.011 13.8838V13.8747C43.3516 13.7517 43.6922 13.615 44.0237 13.4737C44.8865 13.1092 45.7267 12.69 46.5305 12.2252C49.3324 10.6122 51.7439 8.43871 53.6058 5.85968C53.7647 6.09662 53.901 6.27889 53.9827 6.3609C54.3415 6.72087 65.3722 10.4573 65.3722 10.4573L65.4131 10.5438L65.454 10.6213L76.6891 33.3131L65.9308 38.3253Z"
      ),
        n(l, "fill", a[1]),
        n(
          r,
          "d",
          "M51.2756 3.04364C51.1348 3.26691 50.985 3.48563 50.8351 3.69979C49.0504 6.26059 46.7298 8.43864 44.0232 10.0881C43.6917 10.2932 43.3556 10.4845 43.0105 10.6714C43.0105 10.6714 43.0059 10.6759 43.0014 10.6759C42.9969 10.6759 42.9923 10.6714 42.9878 10.6714C42.6426 10.4845 42.302 10.2886 41.9705 10.0836C39.2685 8.43864 36.9479 6.26059 35.1632 3.69979C35.0133 3.48563 34.8634 3.26691 34.7227 3.04364H51.2756Z"
        ),
        n(r, "fill", a[2]),
        n(
          i,
          "d",
          "M68.5512 8.58005L68.265 8.00136C68.265 8.00136 68.2514 7.99681 68.2287 7.98769C67.5294 7.75075 57.3478 4.29686 55.1726 3.35365C54.9546 3.25796 54.8138 3.18505 54.7775 3.1486C54.7502 3.12126 54.7184 3.08936 54.6866 3.0438C54.2416 2.49701 53.1699 0.715384 52.8429 0.164037C52.7793 0.0592356 52.743 0 52.743 0H33.2564C33.2564 0 33.22 0.0592356 33.1565 0.164037C32.8295 0.715384 31.7578 2.49701 31.3173 3.0438C31.2809 3.08936 31.2491 3.12126 31.2219 3.1486C31.1856 3.18505 31.0448 3.25796 30.8223 3.35365C28.6424 4.29686 18.4654 7.75075 17.7706 7.98769C17.7479 7.99681 17.7343 8.00136 17.7343 8.00136L17.4482 8.5846L4.33301 35.0629L18.5835 41.7019L20.0685 38.3254L9.3057 33.3132L20.5454 10.6214L20.5862 10.5439L20.6271 10.4574C20.6271 10.4574 31.6578 6.72096 32.0166 6.36099C32.0984 6.27897 32.2346 6.09671 32.3935 5.86432C34.2555 8.43879 36.6669 10.6123 39.4688 12.2253C40.2726 12.6901 41.1037 13.1047 41.9711 13.4738C42.3026 13.6151 42.6432 13.7518 42.9883 13.8748C42.9883 13.8748 42.9914 13.8763 42.9974 13.8794C42.9974 13.8794 43.0065 13.8794 43.011 13.8748C43.3516 13.7518 43.6922 13.6151 44.0237 13.4738C44.8866 13.1093 45.7267 12.6901 46.5305 12.2253C49.3325 10.6123 51.7439 8.43879 53.6058 5.85977C53.7648 6.09671 53.901 6.27897 53.9827 6.36099C54.3415 6.72096 65.3723 10.4574 65.3723 10.4574L65.4131 10.5439L65.454 10.6214L76.6891 33.3132L65.9308 38.3254L67.4158 41.7019L81.6663 35.0629L68.5512 8.58005ZM50.8356 3.69995C49.0509 6.26075 46.7303 8.43879 44.0237 10.0883C43.6922 10.2933 43.3562 10.4847 43.011 10.6715V10.6806H43.0019C42.9974 10.6806 42.9929 10.6806 42.9883 10.6806V10.6715C42.6432 10.4847 42.3026 10.2888 41.9711 10.0837C39.269 8.43879 36.9484 6.26075 35.1637 3.69995C35.0138 3.48579 34.864 3.26707 34.7232 3.0438H51.2761C51.1354 3.26707 50.9855 3.48579 50.8356 3.69995Z"
        ),
        n(i, "fill", a[3]),
        n(t, "filter", "url(#filter0_d_354_581)"),
        n(
          c,
          "d",
          "M16 6.66667H9.33333V0H6.66667V6.66667H0V9.33333H6.66667V16H9.33333V9.33333H16V6.66667Z"
        ),
        n(c, "fill", "#FFFFF"),
        n(p, "transform", "translate(36 30)"),
        n(m, "flood-opacity", "0"),
        n(m, "result", "BackgroundImageFix"),
        n(v, "in", "SourceAlpha"),
        n(v, "type", "matrix"),
        n(v, "values", "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"),
        n(v, "result", "hardAlpha"),
        n(b, "dy", "4"),
        n(E, "stdDeviation", "2"),
        n(y, "in2", "hardAlpha"),
        n(y, "operator", "out"),
        n(k, "type", "matrix"),
        n(k, "values", "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0"),
        n(w, "mode", "normal"),
        n(w, "in2", "BackgroundImageFix"),
        n(w, "result", "effect1_dropShadow_354_581"),
        n(g, "mode", "normal"),
        n(g, "in", "SourceGraphic"),
        n(g, "in2", "effect1_dropShadow_354_581"),
        n(g, "result", "shape"),
        n(d, "id", "filter0_d_354_581"),
        n(d, "x", "0.333008"),
        n(d, "y", "0"),
        n(d, "width", "85.333"),
        n(d, "height", "87.9999"),
        n(d, "filterUnits", "userSpaceOnUse"),
        n(e, "xmlns", "http://www.w3.org/2000/svg"),
        n(e, "class", a[0]),
        n(e, "fill", "currentColor"),
        n(e, "viewBox", "0 0 86 88");
    },
    m(I, C) {
      z(I, e, C),
        s(e, t),
        s(t, l),
        s(t, r),
        s(t, i),
        s(e, p),
        s(p, c),
        s(e, f),
        s(f, d),
        s(d, m),
        s(d, v),
        s(d, b),
        s(d, E),
        s(d, y),
        s(d, k),
        s(d, w),
        s(d, g);
    },
    p(I, [C]) {
      C & 2 && n(l, "fill", I[1]),
        C & 4 && n(r, "fill", I[2]),
        C & 8 && n(i, "fill", I[3]),
        C & 1 && n(e, "class", I[0]);
    },
    i: Le,
    o: Le,
    d(I) {
      I && o(e);
    },
  };
}
function nr(a, e, t) {
  let { className: l = "" } = e,
    { primaryColour: r = "#2CE3A6" } = e,
    { secondaryColour: i = "#777777" } = e,
    { thirdColour: p = "#FFFFFF" } = e;
  return (
    (a.$$set = (c) => {
      "className" in c && t(0, (l = c.className)),
        "primaryColour" in c && t(1, (r = c.primaryColour)),
        "secondaryColour" in c && t(2, (i = c.secondaryColour)),
        "thirdColour" in c && t(3, (p = c.thirdColour));
    }),
    [l, r, i, p]
  );
}
class or extends St {
  constructor(e) {
    super(),
      Lt(this, e, nr, rr, Ut, {
        className: 0,
        primaryColour: 1,
        secondaryColour: 2,
        thirdColour: 3,
      });
  }
}
function ir(a) {
  let e, t;
  return {
    c() {
      (e = pe("svg")), (t = pe("path")), this.h();
    },
    l(l) {
      e = ve(l, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var r = u(e);
      (t = ve(r, "path", { d: !0, fill: !0 })),
        u(t).forEach(o),
        r.forEach(o),
        this.h();
    },
    h() {
      n(
        t,
        "d",
        "M14.5979 8.93594L14.6033 8.89794V8.89927C14.6193 8.7806 14.6326 8.66127 14.6419 8.54127C14.6579 8.33994 14.5159 8.0006 14.1426 8.0006C13.8819 8.0006 13.6659 8.2006 13.6446 8.4606C13.6326 8.60794 13.6153 8.75394 13.5926 8.89794C13.1626 11.5986 10.8206 13.6666 7.99859 13.6666C5.97392 13.6666 4.19592 12.6019 3.19459 11.0033L4.52192 10.9999C4.79792 10.9999 5.02192 10.7759 5.02192 10.4999C5.02192 10.2239 4.79792 9.99994 4.52192 9.99994H1.83325C1.55725 9.99994 1.33325 10.2239 1.33325 10.4999V13.1993C1.33325 13.4753 1.55725 13.6993 1.83325 13.6993C2.10925 13.6993 2.33325 13.4759 2.33325 13.1993L2.33525 11.5159C3.51192 13.4066 5.60925 14.6666 7.99859 14.6666C11.3599 14.6666 14.1433 12.1726 14.5979 8.93594ZM1.41525 6.95327L1.40925 6.9906V6.98927C1.38592 7.1446 1.36725 7.30194 1.35459 7.46127C1.33859 7.6626 1.48059 8.00194 1.85392 8.00194C2.11459 8.00194 2.33059 7.80194 2.35192 7.54194C2.36659 7.35527 2.39059 7.17127 2.42325 6.9906C2.90059 4.34527 5.21592 2.33594 7.99792 2.33594C10.0226 2.33594 11.8006 3.4006 12.8019 4.99927L11.4746 5.0026C11.1986 5.0026 10.9746 5.2266 10.9746 5.5026C10.9746 5.7786 11.1986 6.0026 11.4746 6.0026H14.1633C14.4393 6.0026 14.6633 5.7786 14.6633 5.5026V2.80327C14.6633 2.52727 14.4393 2.30327 14.1633 2.30327C13.8873 2.30327 13.6633 2.5266 13.6633 2.80327L13.6613 4.4866C12.4846 2.59594 10.3873 1.33594 7.99792 1.33594C4.67525 1.33594 1.91792 3.77194 1.41525 6.95327Z"
      ),
        n(t, "fill", "white"),
        n(e, "xmlns", "http://www.w3.org/2000/svg"),
        n(e, "class", a[0]),
        n(e, "fill", "currentColor"),
        n(e, "viewBox", "0 0 16 16");
    },
    m(l, r) {
      z(l, e, r), s(e, t);
    },
    p(l, [r]) {
      r & 1 && n(e, "class", l[0]);
    },
    i: Le,
    o: Le,
    d(l) {
      l && o(e);
    },
  };
}
function cr(a, e, t) {
  let { className: l = "" } = e;
  return (
    (a.$$set = (r) => {
      "className" in r && t(0, (l = r.className));
    }),
    [l]
  );
}
class Ns extends St {
  constructor(e) {
    super(), Lt(this, e, cr, ir, Ut, { className: 0 });
  }
}
function fr(a) {
  let e, t, l;
  return {
    c() {
      (e = pe("svg")), (t = pe("circle")), (l = pe("path")), this.h();
    },
    l(r) {
      e = ve(r, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var i = u(e);
      (t = ve(i, "circle", {
        cx: !0,
        cy: !0,
        r: !0,
        fill: !0,
        "fill-opacity": !0,
      })),
        u(t).forEach(o),
        (l = ve(i, "path", { transform: !0, d: !0, fill: !0 })),
        u(l).forEach(o),
        i.forEach(o),
        this.h();
    },
    h() {
      n(t, "cx", "11.5"),
        n(t, "cy", "11"),
        n(t, "r", "11"),
        n(t, "fill", "#242529"),
        n(t, "fill-opacity", "0.9"),
        n(l, "transform", "translate(4.7,4) scale(0.8,0.8)"),
        n(
          l,
          "d",
          "M8.39289 1.61501C8.47689 1.44234 8.65289 1.33301 8.84489 1.33301C9.03756 1.33301 9.21289 1.44234 9.29689 1.61501C9.94622 2.94701 11.0636 5.24167 11.0636 5.24167C11.0636 5.24167 13.6042 5.59101 15.0782 5.79434C15.3469 5.83101 15.5116 6.05834 15.5116 6.29234C15.5116 6.41901 15.4636 6.54767 15.3576 6.64967C14.2842 7.67501 12.4362 9.44368 12.4362 9.44368C12.4362 9.44368 12.8876 11.955 13.1489 13.4117C13.2042 13.7197 12.9656 13.9997 12.6542 13.9997C12.5729 13.9997 12.4916 13.9803 12.4176 13.9403C11.1056 13.2417 8.84489 12.0397 8.84489 12.0397C8.84489 12.0397 6.58422 13.2417 5.27222 13.9403C5.19822 13.9803 5.11622 13.9997 5.03489 13.9997C4.72489 13.9997 4.48489 13.719 4.54089 13.4117C4.80289 11.955 5.25422 9.44368 5.25422 9.44368C5.25422 9.44368 3.40556 7.67501 2.33289 6.64967C2.22622 6.54767 2.17822 6.41901 2.17822 6.29301C2.17822 6.05834 2.34422 5.83034 2.61222 5.79434C4.08622 5.59101 6.62622 5.24167 6.62622 5.24167C6.62622 5.24167 7.74422 2.94701 8.39289 1.61501ZM8.84489 2.97034L7.27089 6.16501L3.77356 6.64434L6.33889 9.07301L5.70689 12.5763L8.84489 10.9063L11.9829 12.5763L11.3489 9.08567L13.9162 6.64434L10.3736 6.14034L8.84489 2.97034Z"
        ),
        n(l, "fill", "#2CE3A6"),
        n(e, "xmlns", "http://www.w3.org/2000/svg"),
        n(e, "class", a[0]),
        n(e, "fill", "currentColor"),
        n(e, "viewBox", "0 0 23 22");
    },
    m(r, i) {
      z(r, e, i), s(e, t), s(e, l);
    },
    p(r, [i]) {
      i & 1 && n(e, "class", r[0]);
    },
    i: Le,
    o: Le,
    d(r) {
      r && o(e);
    },
  };
}
function ur(a, e, t) {
  let { className: l = "" } = e;
  return (
    (a.$$set = (r) => {
      "className" in r && t(0, (l = r.className));
    }),
    [l]
  );
}
class xs extends St {
  constructor(e) {
    super(), Lt(this, e, ur, fr, Ut, { className: 0 });
  }
}
function dr(a) {
  let e, t, l;
  return {
    c() {
      (e = pe("svg")), (t = pe("circle")), (l = pe("path")), this.h();
    },
    l(r) {
      e = ve(r, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var i = u(e);
      (t = ve(i, "circle", {
        cx: !0,
        cy: !0,
        r: !0,
        fill: !0,
        fillopacity: !0,
      })),
        u(t).forEach(o),
        (l = ve(i, "path", { transform: !0, d: !0, fill: !0 })),
        u(l).forEach(o),
        i.forEach(o),
        this.h();
    },
    h() {
      n(t, "cx", "11.5"),
        n(t, "cy", "11"),
        n(t, "r", "11"),
        n(t, "fill", "#242529"),
        n(t, "fillopacity", "0.9"),
        n(l, "transform", "translate(4.7,4) scale(0.8,0.8)"),
        n(
          l,
          "d",
          "M8.39289 1.61501C8.47689 1.44234 8.65289 1.33301 8.84489 1.33301C9.03756 1.33301 9.21289 1.44234 9.29689 1.61501C9.94622 2.94701 11.0636 5.24167 11.0636 5.24167C11.0636 5.24167 13.6042 5.59101 15.0782 5.79434C15.3469 5.83101 15.5116 6.05834 15.5116 6.29234C15.5116 6.41901 15.4636 6.54767 15.3576 6.64967C14.2842 7.67501 12.4362 9.44368 12.4362 9.44368C12.4362 9.44368 12.8876 11.955 13.1489 13.4117C13.2042 13.7197 12.9656 13.9997 12.6542 13.9997C12.5729 13.9997 12.4916 13.9803 12.4176 13.9403C11.1056 13.2417 8.84489 12.0397 8.84489 12.0397C8.84489 12.0397 6.58422 13.2417 5.27222 13.9403C5.19822 13.9803 5.11622 13.9997 5.03489 13.9997C4.72489 13.9997 4.48489 13.719 4.54089 13.4117C4.80289 11.955 5.25422 9.44368 5.25422 9.44368C5.25422 9.44368 3.40556 7.67501 2.33289 6.64967C2.22622 6.54767 2.17822 6.41901 2.17822 6.29301C2.17822 6.05834 2.34422 5.83034 2.61222 5.79434C4.08622 5.59101 6.62622 5.24167 6.62622 5.24167C6.62622 5.24167 7.74422 2.94701 8.39289 1.61501Z"
        ),
        n(l, "fill", "#2CE3A6"),
        n(e, "xmlns", "http://www.w3.org/2000/svg"),
        n(e, "class", a[0]),
        n(e, "fill", "currentColor"),
        n(e, "viewBox", "0 0 23 22");
    },
    m(r, i) {
      z(r, e, i), s(e, t), s(e, l);
    },
    p(r, [i]) {
      i & 1 && n(e, "class", r[0]);
    },
    i: Le,
    o: Le,
    d(r) {
      r && o(e);
    },
  };
}
function mr(a, e, t) {
  let { className: l = "" } = e;
  return (
    (a.$$set = (r) => {
      "className" in r && t(0, (l = r.className));
    }),
    [l]
  );
}
class Ds extends St {
  constructor(e) {
    super(), Lt(this, e, mr, dr, Ut, { className: 0 });
  }
}
const { Map: As } = Gs;
function us(a, e, t) {
  const l = a.slice();
  return (l[66] = e[t]), (l[68] = t), l;
}
function ds(a, e, t) {
  const l = a.slice();
  (l[69] = e[t]), (l[75] = t);
  const r = l[31](l[68], l[75]);
  l[70] = r;
  const i = l[2]?.playerIds ?? [];
  l[71] = i;
  const p = l[71][l[70]];
  l[72] = p;
  const c = l[1].find(function (...m) {
    return a[45](l[72], ...m);
  });
  l[73] = c;
  const f = l[15].find(function (...m) {
    return a[46](l[73], ...m);
  });
  return (l[76] = f), l;
}
function ms(a, e, t) {
  const l = a.slice();
  return (l[66] = e[t]), (l[68] = t), l;
}
function hs(a, e, t) {
  const l = a.slice();
  (l[69] = e[t]), (l[75] = t);
  const r = l[31](l[68], l[75]);
  l[70] = r;
  const i = l[2]?.playerIds ?? [];
  l[71] = i;
  const p = l[71][l[70]];
  l[72] = p;
  const c = l[1].find(function (...d) {
    return a[41](l[72], ...d);
  });
  return (l[73] = c), l;
}
function hr(a) {
  const e = a.slice(),
    t = e[15].find(function (...r) {
      return a[37](e[73], ...r);
    });
  return (e[76] = t), e;
}
function _s(a, e, t) {
  const l = a.slice();
  return (l[79] = e[t]), l;
}
function ps(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c,
    f,
    d,
    m,
    v,
    b,
    E,
    y,
    k,
    w,
    g,
    I,
    C,
    x,
    H,
    U,
    F,
    Z,
    X,
    re,
    j,
    R,
    O,
    ne,
    A,
    M,
    $,
    te,
    D,
    Y,
    K,
    J,
    B,
    ie,
    Q,
    Ee,
    L,
    S,
    se,
    ke,
    ce,
    Ne = a[2]?.playerIds.filter(Es).length + "",
    de,
    ue,
    xe,
    Pe,
    Ve,
    Ye,
    Te,
    Ie,
    Ze,
    We,
    He,
    Xe,
    lt,
    bt = a[14].toFixed(2) + "",
    dt,
    Mt,
    Ue,
    mt,
    Kt,
    qt,
    G,
    q,
    le,
    oe,
    me,
    ge,
    ye,
    Se,
    ze = (a[20] / 4).toFixed(2) + "",
    je,
    gt,
    et,
    Ae,
    Nt,
    At,
    ut,
    nl,
    at,
    yt,
    ol,
    jt,
    wt,
    Wt = (a[19] === 1 / 0 ? "Unlimited" : a[19]) + "",
    Rt,
    il,
    zt,
    $t,
    Re,
    Et,
    Ce,
    Yt,
    ht,
    $e,
    he,
    De,
    W,
    st,
    cl,
    vl,
    _t,
    Gt,
    Qt,
    kt,
    fl,
    Bt,
    pt,
    bl,
    Ft,
    ul,
    gl,
    xt,
    yl,
    dl,
    el,
    It,
    vt,
    rt,
    ml,
    Ot,
    Zt,
    wl,
    Dt,
    Ge,
    tl,
    xl;
  e = new Qs({
    props: {
      handlePlayerSelection: a[30],
      filterPosition: a[10],
      filterColumn: a[11],
      showAddPlayer: a[13],
      closeAddPlayerModal: a[29],
      fantasyTeam: a[23],
      bankBalance: a[25],
    },
  });
  let Je = a[21],
    Ke = [];
  for (let ee = 0; ee < Je.length; ee += 1) Ke[ee] = vs(_s(a, Je, ee));
  const Dl = [pr, _r],
    Ht = [];
  function Al(ee, _e) {
    return ee[12] ? 0 : 1;
  }
  return (
    (vt = Al(a)),
    (rt = Ht[vt] = Dl[vt](a)),
    (Zt = new sr({})),
    (Dt = new Zs({
      props: {
        fantasyTeam: a[23],
        teams: a[15],
        players: a[1],
        activeGameweek: a[4],
      },
    })),
    {
      c() {
        Me(e.$$.fragment),
          (t = V()),
          (l = h("div")),
          (r = h("div")),
          (i = h("div")),
          (p = h("div")),
          (c = h("p")),
          (f = T("Gameweek")),
          (d = V()),
          (m = h("p")),
          (v = T(a[4])),
          (b = V()),
          (E = h("p")),
          (y = T(a[3])),
          (k = V()),
          (w = h("div")),
          (g = V()),
          (I = h("div")),
          (C = h("p")),
          (x = T("Kick Off:")),
          (H = V()),
          (U = h("div")),
          (F = h("p")),
          (Z = T(a[7])),
          (X = h("span")),
          (re = T("d")),
          (j = T(`
                : `)),
          (R = T(a[8])),
          (O = h("span")),
          (ne = T("h")),
          (A = T(`
                : `)),
          (M = T(a[9])),
          ($ = h("span")),
          (te = T("m")),
          (D = V()),
          (Y = h("p")),
          (K = T(a[5])),
          (J = T(" | ")),
          (B = T(a[6])),
          (ie = V()),
          (Q = h("div")),
          (Ee = V()),
          (L = h("div")),
          (S = h("p")),
          (se = T("Players")),
          (ke = V()),
          (ce = h("p")),
          (de = T(Ne)),
          (ue = T("/11")),
          (xe = V()),
          (Pe = h("p")),
          (Ve = T("Selected")),
          (Ye = V()),
          (Te = h("div")),
          (Ie = h("div")),
          (Ze = h("p")),
          (We = T("Team Value")),
          (He = V()),
          (Xe = h("p")),
          (lt = T("£")),
          (dt = T(bt)),
          (Mt = T("m")),
          (Ue = V()),
          (mt = h("p")),
          (Kt = T("GBP")),
          (qt = V()),
          (G = h("div")),
          (q = V()),
          (le = h("div")),
          (oe = h("p")),
          (me = T("Bank Balance")),
          (ge = V()),
          (ye = h("p")),
          (Se = T("£")),
          (je = T(ze)),
          (gt = T("m")),
          (et = V()),
          (Ae = h("p")),
          (Nt = T("GBP")),
          (At = V()),
          (ut = h("div")),
          (nl = V()),
          (at = h("div")),
          (yt = h("p")),
          (ol = T("Transfers")),
          (jt = V()),
          (wt = h("p")),
          (Rt = T(Wt)),
          (il = V()),
          (zt = h("p")),
          ($t = T("Available")),
          (Re = V()),
          (Et = h("div")),
          (Ce = h("div")),
          (Yt = h("div")),
          (ht = h("button")),
          ($e = T("Pitch View")),
          (De = V()),
          (W = h("button")),
          (st = T("List View")),
          (vl = V()),
          (_t = h("div")),
          (Gt = h("span")),
          (Qt = T(`Formation:
              `)),
          (kt = h("select"));
        for (let ee = 0; ee < Ke.length; ee += 1) Ke[ee].c();
        (fl = V()),
          (Bt = h("div")),
          (pt = h("button")),
          (bl = T("Auto Fill")),
          (gl = V()),
          (xt = h("button")),
          (yl = T("Save Team")),
          (el = V()),
          (It = h("div")),
          rt.c(),
          (ml = V()),
          (Ot = h("div")),
          Me(Zt.$$.fragment),
          (wl = V()),
          Me(Dt.$$.fragment),
          this.h();
      },
      l(ee) {
        Oe(e.$$.fragment, ee), (t = N(ee)), (l = _(ee, "DIV", { class: !0 }));
        var _e = u(l);
        r = _(_e, "DIV", { class: !0 });
        var nt = u(r);
        i = _(nt, "DIV", { class: !0 });
        var ot = u(i);
        p = _(ot, "DIV", { class: !0 });
        var Ct = u(p);
        c = _(Ct, "P", { class: !0 });
        var tt = u(c);
        (f = P(tt, "Gameweek")),
          tt.forEach(o),
          (d = N(Ct)),
          (m = _(Ct, "P", { class: !0 }));
        var ll = u(m);
        (v = P(ll, a[4])),
          ll.forEach(o),
          (b = N(Ct)),
          (E = _(Ct, "P", { class: !0 }));
        var Tt = u(E);
        (y = P(Tt, a[3])),
          Tt.forEach(o),
          Ct.forEach(o),
          (k = N(ot)),
          (w = _(ot, "DIV", { class: !0, style: !0 })),
          u(w).forEach(o),
          (g = N(ot)),
          (I = _(ot, "DIV", { class: !0 }));
        var El = u(I);
        C = _(El, "P", { class: !0 });
        var sa = u(C);
        (x = P(sa, "Kick Off:")),
          sa.forEach(o),
          (H = N(El)),
          (U = _(El, "DIV", { class: !0 }));
        var ra = u(U);
        F = _(ra, "P", { class: !0 });
        var Jt = u(F);
        (Z = P(Jt, a[7])), (X = _(Jt, "SPAN", { class: !0 }));
        var na = u(X);
        (re = P(na, "d")),
          na.forEach(o),
          (j = P(
            Jt,
            `
                : `
          )),
          (R = P(Jt, a[8])),
          (O = _(Jt, "SPAN", { class: !0 }));
        var oa = u(O);
        (ne = P(oa, "h")),
          oa.forEach(o),
          (A = P(
            Jt,
            `
                : `
          )),
          (M = P(Jt, a[9])),
          ($ = _(Jt, "SPAN", { class: !0 }));
        var ia = u($);
        (te = P(ia, "m")),
          ia.forEach(o),
          Jt.forEach(o),
          ra.forEach(o),
          (D = N(El)),
          (Y = _(El, "P", { class: !0 }));
        var Ml = u(Y);
        (K = P(Ml, a[5])),
          (J = P(Ml, " | ")),
          (B = P(Ml, a[6])),
          Ml.forEach(o),
          El.forEach(o),
          (ie = N(ot)),
          (Q = _(ot, "DIV", { class: !0, style: !0 })),
          u(Q).forEach(o),
          (Ee = N(ot)),
          (L = _(ot, "DIV", { class: !0 }));
        var kl = u(L);
        S = _(kl, "P", { class: !0 });
        var ca = u(S);
        (se = P(ca, "Players")),
          ca.forEach(o),
          (ke = N(kl)),
          (ce = _(kl, "P", { class: !0 }));
        var ql = u(ce);
        (de = P(ql, Ne)),
          (ue = P(ql, "/11")),
          ql.forEach(o),
          (xe = N(kl)),
          (Pe = _(kl, "P", { class: !0 }));
        var fa = u(Pe);
        (Ve = P(fa, "Selected")),
          fa.forEach(o),
          kl.forEach(o),
          ot.forEach(o),
          (Ye = N(nt)),
          (Te = _(nt, "DIV", { class: !0 }));
        var Xt = u(Te);
        Ie = _(Xt, "DIV", { class: !0 });
        var Il = u(Ie);
        Ze = _(Il, "P", { class: !0 });
        var ua = u(Ze);
        (We = P(ua, "Team Value")),
          ua.forEach(o),
          (He = N(Il)),
          (Xe = _(Il, "P", { class: !0 }));
        var Bl = u(Xe);
        (lt = P(Bl, "£")),
          (dt = P(Bl, bt)),
          (Mt = P(Bl, "m")),
          Bl.forEach(o),
          (Ue = N(Il)),
          (mt = _(Il, "P", { class: !0 }));
        var da = u(mt);
        (Kt = P(da, "GBP")),
          da.forEach(o),
          Il.forEach(o),
          (qt = N(Xt)),
          (G = _(Xt, "DIV", { class: !0, style: !0 })),
          u(G).forEach(o),
          (q = N(Xt)),
          (le = _(Xt, "DIV", { class: !0 }));
        var Cl = u(le);
        oe = _(Cl, "P", { class: !0 });
        var ma = u(oe);
        (me = P(ma, "Bank Balance")),
          ma.forEach(o),
          (ge = N(Cl)),
          (ye = _(Cl, "P", { class: !0 }));
        var Fl = u(ye);
        (Se = P(Fl, "£")),
          (je = P(Fl, ze)),
          (gt = P(Fl, "m")),
          Fl.forEach(o),
          (et = N(Cl)),
          (Ae = _(Cl, "P", { class: !0 }));
        var ha = u(Ae);
        (Nt = P(ha, "GBP")),
          ha.forEach(o),
          Cl.forEach(o),
          (At = N(Xt)),
          (ut = _(Xt, "DIV", { class: !0, style: !0 })),
          u(ut).forEach(o),
          (nl = N(Xt)),
          (at = _(Xt, "DIV", { class: !0 }));
        var Tl = u(at);
        yt = _(Tl, "P", { class: !0 });
        var _a = u(yt);
        (ol = P(_a, "Transfers")),
          _a.forEach(o),
          (jt = N(Tl)),
          (wt = _(Tl, "P", { class: !0 }));
        var pa = u(wt);
        (Rt = P(pa, Wt)),
          pa.forEach(o),
          (il = N(Tl)),
          (zt = _(Tl, "P", { class: !0 }));
        var va = u(zt);
        ($t = P(va, "Available")),
          va.forEach(o),
          Tl.forEach(o),
          Xt.forEach(o),
          nt.forEach(o),
          (Re = N(_e)),
          (Et = _(_e, "DIV", { class: !0 }));
        var ba = u(Et);
        Ce = _(ba, "DIV", { class: !0 });
        var Pl = u(Ce);
        Yt = _(Pl, "DIV", { class: !0 });
        var Ol = u(Yt);
        ht = _(Ol, "BUTTON", { class: !0 });
        var ga = u(ht);
        ($e = P(ga, "Pitch View")),
          ga.forEach(o),
          (De = N(Ol)),
          (W = _(Ol, "BUTTON", { class: !0 }));
        var ya = u(W);
        (st = P(ya, "List View")),
          ya.forEach(o),
          Ol.forEach(o),
          (vl = N(Pl)),
          (_t = _(Pl, "DIV", { class: !0 }));
        var wa = u(_t);
        Gt = _(wa, "SPAN", { class: !0 });
        var Wl = u(Gt);
        (Qt = P(
          Wl,
          `Formation:
              `
        )),
          (kt = _(Wl, "SELECT", { class: !0 }));
        var Ea = u(kt);
        for (let zl = 0; zl < Ke.length; zl += 1) Ke[zl].l(Ea);
        Ea.forEach(o),
          Wl.forEach(o),
          wa.forEach(o),
          (fl = N(Pl)),
          (Bt = _(Pl, "DIV", { class: !0 }));
        var Hl = u(Bt);
        pt = _(Hl, "BUTTON", { class: !0 });
        var ka = u(pt);
        (bl = P(ka, "Auto Fill")),
          ka.forEach(o),
          (gl = N(Hl)),
          (xt = _(Hl, "BUTTON", { class: !0 }));
        var Ia = u(xt);
        (yl = P(Ia, "Save Team")),
          Ia.forEach(o),
          Hl.forEach(o),
          Pl.forEach(o),
          ba.forEach(o),
          (el = N(_e)),
          (It = _(_e, "DIV", { class: !0 }));
        var Sl = u(It);
        rt.l(Sl), (ml = N(Sl)), (Ot = _(Sl, "DIV", { class: !0 }));
        var Ca = u(Ot);
        Oe(Zt.$$.fragment, Ca),
          Ca.forEach(o),
          Sl.forEach(o),
          (wl = N(_e)),
          Oe(Dt.$$.fragment, _e),
          _e.forEach(o),
          this.h();
      },
      h() {
        n(c, "class", "text-gray-300 text-xs"),
          n(m, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
          n(E, "class", "text-gray-300 text-xs"),
          n(p, "class", "flex-grow mb-4 md:mb-0"),
          n(
            w,
            "class",
            "h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
          ),
          it(w, "min-height", "2px"),
          it(w, "min-width", "2px"),
          n(C, "class", "text-gray-300 text-xs mt-4 md:mt-0"),
          n(X, "class", "text-gray-300 text-xs ml-1"),
          n(O, "class", "text-gray-300 text-xs ml-1"),
          n($, "class", "text-gray-300 text-xs ml-1"),
          n(F, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
          n(U, "class", "flex"),
          n(Y, "class", "text-gray-300 text-xs"),
          n(I, "class", "flex-grow mb-4 md:mb-0"),
          n(
            Q,
            "class",
            "h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
          ),
          it(Q, "min-height", "2px"),
          it(Q, "min-width", "2px"),
          n(S, "class", "text-gray-300 text-xs"),
          n(
            ce,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          n(Pe, "class", "text-gray-300 text-xs"),
          n(L, "class", "flex-grow mb-4 md:mb-0 mt-4 md:mt-0"),
          n(
            i,
            "class",
            "flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
          ),
          n(Ze, "class", "text-gray-300 text-xs"),
          n(
            Xe,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          n(mt, "class", "text-gray-300 text-xs"),
          n(Ie, "class", "flex-grow"),
          n(G, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
          it(G, "min-width", "2px"),
          it(G, "min-height", "50px"),
          n(oe, "class", "text-gray-300 text-xs"),
          n(
            ye,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          n(Ae, "class", "text-gray-300 text-xs"),
          n(le, "class", "flex-grow"),
          n(ut, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
          it(ut, "min-width", "2px"),
          it(ut, "min-height", "50px"),
          n(yt, "class", "text-gray-300 text-xs"),
          n(
            wt,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          n(zt, "class", "text-gray-300 text-xs"),
          n(at, "class", "flex-grow"),
          n(
            Te,
            "class",
            "flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
          ),
          n(r, "class", "flex flex-col md:flex-row"),
          n(
            ht,
            "class",
            (he = `btn ${
              a[12] ? "fpl-button" : "inactive-btn"
            } px-4 py-2 rounded-l-md font-bold text-md min-w-[125px] my-4`)
          ),
          n(
            W,
            "class",
            (cl = `btn ${
              a[12] ? "inactive-btn" : "fpl-button"
            } px-4 py-2 rounded-r-md font-bold text-md min-w-[125px] my-4`)
          ),
          n(
            Yt,
            "class",
            "flex flex-row justify-between md:justify-start flex-grow mb-2 md:mb-0 ml-4 order-3 md:order-1"
          ),
          n(kt, "class", "p-2 fpl-dropdown text-lg text-center"),
          a[0] === void 0 && pl(() => a[36].call(kt)),
          n(Gt, "class", "text-lg"),
          n(
            _t,
            "class",
            "text-center md:text-left w-full mt-4 md:mt-0 md:ml-8 order-2"
          ),
          (pt.disabled = Ft =
            a[2]?.playerIds ? a[2]?.playerIds.filter(ks).length === 0 : !0),
          n(
            pt,
            "class",
            (ul = `btn w-full md:w-auto px-4 py-2 rounded ${
              a[2]?.playerIds && a[2]?.playerIds.filter(Is).length > 0
                ? "fpl-purple-btn"
                : "bg-gray-500"
            } text-white min-w-[125px]`)
          ),
          (xt.disabled = a[18]),
          n(
            xt,
            "class",
            (dl = `btn w-full md:w-auto px-4 py-2 rounded  ${
              a[18] ? "fpl-purple-btn" : "bg-gray-500"
            } text-white min-w-[125px]`)
          ),
          n(
            Bt,
            "class",
            "flex flex-col md:flex-row w-full md:justify-end gap-4 mr-0 md:mr-4 order-1 md:order-3"
          ),
          n(
            Ce,
            "class",
            "flex flex-col md:flex-row justify-between items-center text-white m-4 bg-panel p-4 rounded-md md:w-full"
          ),
          n(Et, "class", "flex flex-col md:flex-row"),
          n(Ot, "class", "flex w-100 md:w-1/2"),
          n(It, "class", "flex flex-col md:flex-row"),
          n(l, "class", "m-4");
      },
      m(ee, _e) {
        Be(e, ee, _e),
          z(ee, t, _e),
          z(ee, l, _e),
          s(l, r),
          s(r, i),
          s(i, p),
          s(p, c),
          s(c, f),
          s(p, d),
          s(p, m),
          s(m, v),
          s(p, b),
          s(p, E),
          s(E, y),
          s(i, k),
          s(i, w),
          s(i, g),
          s(i, I),
          s(I, C),
          s(C, x),
          s(I, H),
          s(I, U),
          s(U, F),
          s(F, Z),
          s(F, X),
          s(X, re),
          s(F, j),
          s(F, R),
          s(F, O),
          s(O, ne),
          s(F, A),
          s(F, M),
          s(F, $),
          s($, te),
          s(I, D),
          s(I, Y),
          s(Y, K),
          s(Y, J),
          s(Y, B),
          s(i, ie),
          s(i, Q),
          s(i, Ee),
          s(i, L),
          s(L, S),
          s(S, se),
          s(L, ke),
          s(L, ce),
          s(ce, de),
          s(ce, ue),
          s(L, xe),
          s(L, Pe),
          s(Pe, Ve),
          s(r, Ye),
          s(r, Te),
          s(Te, Ie),
          s(Ie, Ze),
          s(Ze, We),
          s(Ie, He),
          s(Ie, Xe),
          s(Xe, lt),
          s(Xe, dt),
          s(Xe, Mt),
          s(Ie, Ue),
          s(Ie, mt),
          s(mt, Kt),
          s(Te, qt),
          s(Te, G),
          s(Te, q),
          s(Te, le),
          s(le, oe),
          s(oe, me),
          s(le, ge),
          s(le, ye),
          s(ye, Se),
          s(ye, je),
          s(ye, gt),
          s(le, et),
          s(le, Ae),
          s(Ae, Nt),
          s(Te, At),
          s(Te, ut),
          s(Te, nl),
          s(Te, at),
          s(at, yt),
          s(yt, ol),
          s(at, jt),
          s(at, wt),
          s(wt, Rt),
          s(at, il),
          s(at, zt),
          s(zt, $t),
          s(l, Re),
          s(l, Et),
          s(Et, Ce),
          s(Ce, Yt),
          s(Yt, ht),
          s(ht, $e),
          s(Yt, De),
          s(Yt, W),
          s(W, st),
          s(Ce, vl),
          s(Ce, _t),
          s(_t, Gt),
          s(Gt, Qt),
          s(Gt, kt);
        for (let nt = 0; nt < Ke.length; nt += 1) Ke[nt] && Ke[nt].m(kt, null);
        Pt(kt, a[0], !0),
          s(Ce, fl),
          s(Ce, Bt),
          s(Bt, pt),
          s(pt, bl),
          s(Bt, gl),
          s(Bt, xt),
          s(xt, yl),
          s(l, el),
          s(l, It),
          Ht[vt].m(It, null),
          s(It, ml),
          s(It, Ot),
          Be(Zt, Ot, null),
          s(l, wl),
          Be(Dt, l, null),
          (Ge = !0),
          tl ||
            ((xl = [
              we(ht, "click", a[26]),
              we(W, "click", a[27]),
              we(kt, "change", a[36]),
              we(pt, "click", a[34]),
              we(xt, "click", a[35]),
            ]),
            (tl = !0));
      },
      p(ee, _e) {
        const nt = {};
        if (
          (_e[0] & 1024 && (nt.filterPosition = ee[10]),
          _e[0] & 2048 && (nt.filterColumn = ee[11]),
          _e[0] & 8192 && (nt.showAddPlayer = ee[13]),
          e.$set(nt),
          (!Ge || _e[0] & 16) && be(v, ee[4]),
          (!Ge || _e[0] & 8) && be(y, ee[3]),
          (!Ge || _e[0] & 128) && be(Z, ee[7]),
          (!Ge || _e[0] & 256) && be(R, ee[8]),
          (!Ge || _e[0] & 512) && be(M, ee[9]),
          (!Ge || _e[0] & 32) && be(K, ee[5]),
          (!Ge || _e[0] & 64) && be(B, ee[6]),
          (!Ge || _e[0] & 4) &&
            Ne !== (Ne = ee[2]?.playerIds.filter(Es).length + "") &&
            be(de, Ne),
          (!Ge || _e[0] & 16384) &&
            bt !== (bt = ee[14].toFixed(2) + "") &&
            be(dt, bt),
          (!Ge || _e[0] & 1048576) &&
            ze !== (ze = (ee[20] / 4).toFixed(2) + "") &&
            be(je, ze),
          (!Ge || _e[0] & 524288) &&
            Wt !== (Wt = (ee[19] === 1 / 0 ? "Unlimited" : ee[19]) + "") &&
            be(Rt, Wt),
          (!Ge ||
            (_e[0] & 4096 &&
              he !==
                (he = `btn ${
                  ee[12] ? "fpl-button" : "inactive-btn"
                } px-4 py-2 rounded-l-md font-bold text-md min-w-[125px] my-4`))) &&
            n(ht, "class", he),
          (!Ge ||
            (_e[0] & 4096 &&
              cl !==
                (cl = `btn ${
                  ee[12] ? "inactive-btn" : "fpl-button"
                } px-4 py-2 rounded-r-md font-bold text-md min-w-[125px] my-4`))) &&
            n(W, "class", cl),
          _e[0] & 2097152)
        ) {
          Je = ee[21];
          let tt;
          for (tt = 0; tt < Je.length; tt += 1) {
            const ll = _s(ee, Je, tt);
            Ke[tt]
              ? Ke[tt].p(ll, _e)
              : ((Ke[tt] = vs(ll)), Ke[tt].c(), Ke[tt].m(kt, null));
          }
          for (; tt < Ke.length; tt += 1) Ke[tt].d(1);
          Ke.length = Je.length;
        }
        _e[0] & 2097153 && Pt(kt, ee[0]),
          (!Ge ||
            (_e[0] & 4 &&
              Ft !==
                (Ft = ee[2]?.playerIds
                  ? ee[2]?.playerIds.filter(ks).length === 0
                  : !0))) &&
            (pt.disabled = Ft),
          (!Ge ||
            (_e[0] & 4 &&
              ul !==
                (ul = `btn w-full md:w-auto px-4 py-2 rounded ${
                  ee[2]?.playerIds && ee[2]?.playerIds.filter(Is).length > 0
                    ? "fpl-purple-btn"
                    : "bg-gray-500"
                } text-white min-w-[125px]`))) &&
            n(pt, "class", ul),
          (!Ge || _e[0] & 262144) && (xt.disabled = ee[18]),
          (!Ge ||
            (_e[0] & 262144 &&
              dl !==
                (dl = `btn w-full md:w-auto px-4 py-2 rounded  ${
                  ee[18] ? "fpl-purple-btn" : "bg-gray-500"
                } text-white min-w-[125px]`))) &&
            n(xt, "class", dl);
        let ot = vt;
        (vt = Al(ee)),
          vt === ot
            ? Ht[vt].p(ee, _e)
            : (ct(),
              fe(Ht[ot], 1, 1, () => {
                Ht[ot] = null;
              }),
              ft(),
              (rt = Ht[vt]),
              rt ? rt.p(ee, _e) : ((rt = Ht[vt] = Dl[vt](ee)), rt.c()),
              ae(rt, 1),
              rt.m(It, ml));
        const Ct = {};
        _e[0] & 32768 && (Ct.teams = ee[15]),
          _e[0] & 2 && (Ct.players = ee[1]),
          _e[0] & 16 && (Ct.activeGameweek = ee[4]),
          Dt.$set(Ct);
      },
      i(ee) {
        Ge ||
          (ae(e.$$.fragment, ee),
          ae(rt),
          ae(Zt.$$.fragment, ee),
          ae(Dt.$$.fragment, ee),
          (Ge = !0));
      },
      o(ee) {
        fe(e.$$.fragment, ee),
          fe(rt),
          fe(Zt.$$.fragment, ee),
          fe(Dt.$$.fragment, ee),
          (Ge = !1);
      },
      d(ee) {
        Fe(e, ee),
          ee && o(t),
          ee && o(l),
          Vt(Ke, ee),
          Ht[vt].d(),
          Fe(Zt),
          Fe(Dt),
          (tl = !1),
          Kl(xl);
      },
    }
  );
}
function vs(a) {
  let e,
    t = a[79] + "",
    l,
    r;
  return {
    c() {
      (e = h("option")), (l = T(t)), this.h();
    },
    l(i) {
      e = _(i, "OPTION", {});
      var p = u(e);
      (l = P(p, t)), p.forEach(o), this.h();
    },
    h() {
      (e.__value = r = a[79]), (e.value = e.__value);
    },
    m(i, p) {
      z(i, e, p), s(e, l);
    },
    p(i, p) {
      p[0] & 2097152 && t !== (t = i[79] + "") && be(l, t),
        p[0] & 2097152 &&
          r !== (r = i[79]) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(i) {
      i && o(e);
    },
  };
}
function _r(a) {
  let e,
    t,
    l,
    r = a[17],
    i = [];
  for (let c = 0; c < r.length; c += 1) i[c] = gs(us(a, r, c));
  const p = (c) =>
    fe(i[c], 1, 1, () => {
      i[c] = null;
    });
  return {
    c() {
      (e = h("div")), (t = h("div"));
      for (let c = 0; c < i.length; c += 1) i[c].c();
      this.h();
    },
    l(c) {
      e = _(c, "DIV", { class: !0 });
      var f = u(e);
      t = _(f, "DIV", { class: !0 });
      var d = u(t);
      for (let m = 0; m < i.length; m += 1) i[m].l(d);
      d.forEach(o), f.forEach(o), this.h();
    },
    h() {
      n(t, "class", "container-fluid"),
        n(e, "class", "bg-panel rounded-md m-4 flex-1");
    },
    m(c, f) {
      z(c, e, f), s(e, t);
      for (let d = 0; d < i.length; d += 1) i[d] && i[d].m(t, null);
      l = !0;
    },
    p(c, f) {
      if ((f[0] & 268599302) | (f[1] & 7)) {
        r = c[17];
        let d;
        for (d = 0; d < r.length; d += 1) {
          const m = us(c, r, d);
          i[d]
            ? (i[d].p(m, f), ae(i[d], 1))
            : ((i[d] = gs(m)), i[d].c(), ae(i[d], 1), i[d].m(t, null));
        }
        for (ct(), d = r.length; d < i.length; d += 1) p(d);
        ft();
      }
    },
    i(c) {
      if (!l) {
        for (let f = 0; f < r.length; f += 1) ae(i[f]);
        l = !0;
      }
    },
    o(c) {
      i = i.filter(Boolean);
      for (let f = 0; f < i.length; f += 1) fe(i[f]);
      l = !1;
    },
    d(c) {
      c && o(e), Vt(i, c);
    },
  };
}
function pr(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c,
    f,
    d,
    m,
    v,
    b,
    E,
    y,
    k,
    w,
    g,
    I,
    C,
    x,
    H,
    U,
    F,
    Z,
    X,
    re,
    j,
    R,
    O;
  (E = new ss({ props: { className: "h-4 md:h-6 mr-1 md:mr-2" } })),
    (Z = new ss({ props: { className: "h-4 md:h-6 mr-1 md:mr-2" } }));
  let ne = a[17],
    A = [];
  for (let $ = 0; $ < ne.length; $ += 1) A[$] = ws(ms(a, ne, $));
  const M = ($) =>
    fe(A[$], 1, 1, () => {
      A[$] = null;
    });
  return {
    c() {
      (e = h("div")),
        (t = h("img")),
        (r = V()),
        (i = h("div")),
        (p = h("div")),
        (c = h("div")),
        (f = h("img")),
        (m = V()),
        (v = h("div")),
        (b = h("a")),
        Me(E.$$.fragment),
        (y = V()),
        (k = h("span")),
        (w = T("OpenChat")),
        (g = V()),
        (I = h("div")),
        (C = h("img")),
        (H = V()),
        (U = h("div")),
        (F = h("a")),
        Me(Z.$$.fragment),
        (X = V()),
        (re = h("span")),
        (j = T("OpenChat")),
        (R = V());
      for (let $ = 0; $ < A.length; $ += 1) A[$].c();
      this.h();
    },
    l($) {
      e = _($, "DIV", { class: !0 });
      var te = u(e);
      (t = _(te, "IMG", { src: !0, alt: !0, class: !0 })),
        (r = N(te)),
        (i = _(te, "DIV", { class: !0 }));
      var D = u(i);
      p = _(D, "DIV", { class: !0 });
      var Y = u(p);
      c = _(Y, "DIV", { class: !0 });
      var K = u(c);
      (f = _(K, "IMG", { class: !0, src: !0, alt: !0 })),
        (m = N(K)),
        (v = _(K, "DIV", { class: !0 }));
      var J = u(v);
      b = _(J, "A", { class: !0, target: !0, href: !0 });
      var B = u(b);
      Oe(E.$$.fragment, B), (y = N(B)), (k = _(B, "SPAN", { class: !0 }));
      var ie = u(k);
      (w = P(ie, "OpenChat")),
        ie.forEach(o),
        B.forEach(o),
        J.forEach(o),
        K.forEach(o),
        (g = N(Y)),
        (I = _(Y, "DIV", { class: !0 }));
      var Q = u(I);
      (C = _(Q, "IMG", { class: !0, src: !0, alt: !0 })),
        (H = N(Q)),
        (U = _(Q, "DIV", { class: !0 }));
      var Ee = u(U);
      F = _(Ee, "A", { class: !0, target: !0, href: !0 });
      var L = u(F);
      Oe(Z.$$.fragment, L), (X = N(L)), (re = _(L, "SPAN", { class: !0 }));
      var S = u(re);
      (j = P(S, "OpenChat")),
        S.forEach(o),
        L.forEach(o),
        Ee.forEach(o),
        Q.forEach(o),
        Y.forEach(o),
        (R = N(D));
      for (let se = 0; se < A.length; se += 1) A[se].l(D);
      D.forEach(o), te.forEach(o), this.h();
    },
    h() {
      hl(t.src, (l = "pitch.png")) || n(t, "src", l),
        n(t, "alt", "pitch"),
        n(t, "class", "w-full"),
        n(f, "class", "h-6 md:h-12 m-0 md:m-1"),
        hl(f.src, (d = "board.png")) || n(f, "src", d),
        n(f, "alt", "OpenChat"),
        n(k, "class", "text-white text-xs md:text-xl mr-4 oc-logo"),
        n(
          b,
          "class",
          "flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
        ),
        n(b, "target", "_blank"),
        n(
          b,
          "href",
          "https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
        ),
        n(v, "class", "absolute top-0 left-0 w-full h-full"),
        n(c, "class", "relative inline-block"),
        n(C, "class", "h-6 md:h-12 m-0 md:m-1"),
        hl(C.src, (x = "board.png")) || n(C, "src", x),
        n(C, "alt", "OpenChat"),
        n(re, "class", "text-white text-xs md:text-xl mr-4 oc-logo"),
        n(
          F,
          "class",
          "flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
        ),
        n(F, "target", "_blank"),
        n(
          F,
          "href",
          "https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
        ),
        n(U, "class", "absolute top-0 left-0 w-full h-full"),
        n(I, "class", "relative inline-block"),
        n(p, "class", "flex justify-around w-full h-auto"),
        n(i, "class", "absolute top-0 left-0 right-0 bottom-0"),
        n(e, "class", "relative w-full md:w-1/2 mt-4");
    },
    m($, te) {
      z($, e, te),
        s(e, t),
        s(e, r),
        s(e, i),
        s(i, p),
        s(p, c),
        s(c, f),
        s(c, m),
        s(c, v),
        s(v, b),
        Be(E, b, null),
        s(b, y),
        s(b, k),
        s(k, w),
        s(p, g),
        s(p, I),
        s(I, C),
        s(I, H),
        s(I, U),
        s(U, F),
        Be(Z, F, null),
        s(F, X),
        s(F, re),
        s(re, j),
        s(i, R);
      for (let D = 0; D < A.length; D += 1) A[D] && A[D].m(i, null);
      O = !0;
    },
    p($, te) {
      if ((te[0] & 268599302) | (te[1] & 7)) {
        ne = $[17];
        let D;
        for (D = 0; D < ne.length; D += 1) {
          const Y = ms($, ne, D);
          A[D]
            ? (A[D].p(Y, te), ae(A[D], 1))
            : ((A[D] = ws(Y)), A[D].c(), ae(A[D], 1), A[D].m(i, null));
        }
        for (ct(), D = ne.length; D < A.length; D += 1) M(D);
        ft();
      }
    },
    i($) {
      if (!O) {
        ae(E.$$.fragment, $), ae(Z.$$.fragment, $);
        for (let te = 0; te < ne.length; te += 1) ae(A[te]);
        O = !0;
      }
    },
    o($) {
      fe(E.$$.fragment, $), fe(Z.$$.fragment, $), (A = A.filter(Boolean));
      for (let te = 0; te < A.length; te += 1) fe(A[te]);
      O = !1;
    },
    d($) {
      $ && o(e), Fe(E), Fe(Z), Vt(A, $);
    },
  };
}
function vr(a) {
  let e, t, l, r, i, p, c, f, d, m, v, b, E, y, k;
  return {
    c() {
      (e = h("div")),
        (t = h("div")),
        (l = T("Goalkeeper")),
        (r = V()),
        (i = h("div")),
        (p = T("(c)")),
        (c = V()),
        (f = h("div")),
        (d = T("Team")),
        (m = V()),
        (v = h("div")),
        (b = T("Value")),
        (E = V()),
        (y = h("div")),
        (k = T(" ")),
        this.h();
    },
    l(w) {
      e = _(w, "DIV", { class: !0 });
      var g = u(e);
      t = _(g, "DIV", { class: !0 });
      var I = u(t);
      (l = P(I, "Goalkeeper")),
        I.forEach(o),
        (r = N(g)),
        (i = _(g, "DIV", { class: !0 }));
      var C = u(i);
      (p = P(C, "(c)")),
        C.forEach(o),
        (c = N(g)),
        (f = _(g, "DIV", { class: !0 }));
      var x = u(f);
      (d = P(x, "Team")),
        x.forEach(o),
        (m = N(g)),
        (v = _(g, "DIV", { class: !0 }));
      var H = u(v);
      (b = P(H, "Value")),
        H.forEach(o),
        (E = N(g)),
        (y = _(g, "DIV", { class: !0 }));
      var U = u(y);
      (k = P(U, " ")), U.forEach(o), g.forEach(o), this.h();
    },
    h() {
      n(t, "class", "w-1/3"),
        n(i, "class", "w-1/6"),
        n(f, "class", "w-1/3"),
        n(v, "class", "w-1/6"),
        n(y, "class", "w-1/6"),
        n(
          e,
          "class",
          "flex items-center justify-between py-2 bg-light-gray px-4"
        );
    },
    m(w, g) {
      z(w, e, g),
        s(e, t),
        s(t, l),
        s(e, r),
        s(e, i),
        s(i, p),
        s(e, c),
        s(e, f),
        s(f, d),
        s(e, m),
        s(e, v),
        s(v, b),
        s(e, E),
        s(e, y),
        s(y, k);
    },
    d(w) {
      w && o(e);
    },
  };
}
function br(a) {
  let e, t, l, r, i, p, c, f, d, m, v, b, E, y, k;
  return {
    c() {
      (e = h("div")),
        (t = h("div")),
        (l = T("Defenders")),
        (r = V()),
        (i = h("div")),
        (p = T("(c)")),
        (c = V()),
        (f = h("div")),
        (d = T("Team")),
        (m = V()),
        (v = h("div")),
        (b = T("Value")),
        (E = V()),
        (y = h("div")),
        (k = T(" ")),
        this.h();
    },
    l(w) {
      e = _(w, "DIV", { class: !0 });
      var g = u(e);
      t = _(g, "DIV", { class: !0 });
      var I = u(t);
      (l = P(I, "Defenders")),
        I.forEach(o),
        (r = N(g)),
        (i = _(g, "DIV", { class: !0 }));
      var C = u(i);
      (p = P(C, "(c)")),
        C.forEach(o),
        (c = N(g)),
        (f = _(g, "DIV", { class: !0 }));
      var x = u(f);
      (d = P(x, "Team")),
        x.forEach(o),
        (m = N(g)),
        (v = _(g, "DIV", { class: !0 }));
      var H = u(v);
      (b = P(H, "Value")),
        H.forEach(o),
        (E = N(g)),
        (y = _(g, "DIV", { class: !0 }));
      var U = u(y);
      (k = P(U, " ")), U.forEach(o), g.forEach(o), this.h();
    },
    h() {
      n(t, "class", "w-1/3"),
        n(i, "class", "w-1/6"),
        n(f, "class", "w-1/3"),
        n(v, "class", "w-1/6"),
        n(y, "class", "w-1/6"),
        n(
          e,
          "class",
          "flex items-center justify-between py-2 bg-light-gray px-4"
        );
    },
    m(w, g) {
      z(w, e, g),
        s(e, t),
        s(t, l),
        s(e, r),
        s(e, i),
        s(i, p),
        s(e, c),
        s(e, f),
        s(f, d),
        s(e, m),
        s(e, v),
        s(v, b),
        s(e, E),
        s(e, y),
        s(y, k);
    },
    d(w) {
      w && o(e);
    },
  };
}
function gr(a) {
  let e, t, l, r, i, p, c, f, d, m, v, b, E, y, k;
  return {
    c() {
      (e = h("div")),
        (t = h("div")),
        (l = T("Midfielders")),
        (r = V()),
        (i = h("div")),
        (p = T("(c)")),
        (c = V()),
        (f = h("div")),
        (d = T("Team")),
        (m = V()),
        (v = h("div")),
        (b = T("Value")),
        (E = V()),
        (y = h("div")),
        (k = T(" ")),
        this.h();
    },
    l(w) {
      e = _(w, "DIV", { class: !0 });
      var g = u(e);
      t = _(g, "DIV", { class: !0 });
      var I = u(t);
      (l = P(I, "Midfielders")),
        I.forEach(o),
        (r = N(g)),
        (i = _(g, "DIV", { class: !0 }));
      var C = u(i);
      (p = P(C, "(c)")),
        C.forEach(o),
        (c = N(g)),
        (f = _(g, "DIV", { class: !0 }));
      var x = u(f);
      (d = P(x, "Team")),
        x.forEach(o),
        (m = N(g)),
        (v = _(g, "DIV", { class: !0 }));
      var H = u(v);
      (b = P(H, "Value")),
        H.forEach(o),
        (E = N(g)),
        (y = _(g, "DIV", { class: !0 }));
      var U = u(y);
      (k = P(U, " ")), U.forEach(o), g.forEach(o), this.h();
    },
    h() {
      n(t, "class", "w-1/3"),
        n(i, "class", "w-1/6"),
        n(f, "class", "w-1/3"),
        n(v, "class", "w-1/6"),
        n(y, "class", "w-1/6"),
        n(
          e,
          "class",
          "flex items-center justify-between py-2 bg-light-gray px-4"
        );
    },
    m(w, g) {
      z(w, e, g),
        s(e, t),
        s(t, l),
        s(e, r),
        s(e, i),
        s(i, p),
        s(e, c),
        s(e, f),
        s(f, d),
        s(e, m),
        s(e, v),
        s(v, b),
        s(e, E),
        s(e, y),
        s(y, k);
    },
    d(w) {
      w && o(e);
    },
  };
}
function yr(a) {
  let e, t, l, r, i, p, c, f, d, m, v, b, E, y, k;
  return {
    c() {
      (e = h("div")),
        (t = h("div")),
        (l = T("Forwards")),
        (r = V()),
        (i = h("div")),
        (p = T("(c)")),
        (c = V()),
        (f = h("div")),
        (d = T("Team")),
        (m = V()),
        (v = h("div")),
        (b = T("Value")),
        (E = V()),
        (y = h("div")),
        (k = T(" ")),
        this.h();
    },
    l(w) {
      e = _(w, "DIV", { class: !0 });
      var g = u(e);
      t = _(g, "DIV", { class: !0 });
      var I = u(t);
      (l = P(I, "Forwards")),
        I.forEach(o),
        (r = N(g)),
        (i = _(g, "DIV", { class: !0 }));
      var C = u(i);
      (p = P(C, "(c)")),
        C.forEach(o),
        (c = N(g)),
        (f = _(g, "DIV", { class: !0 }));
      var x = u(f);
      (d = P(x, "Team")),
        x.forEach(o),
        (m = N(g)),
        (v = _(g, "DIV", { class: !0 }));
      var H = u(v);
      (b = P(H, "Value")),
        H.forEach(o),
        (E = N(g)),
        (y = _(g, "DIV", { class: !0 }));
      var U = u(y);
      (k = P(U, " ")), U.forEach(o), g.forEach(o), this.h();
    },
    h() {
      n(t, "class", "w-1/3"),
        n(i, "class", "w-1/6"),
        n(f, "class", "w-1/3"),
        n(v, "class", "w-1/6"),
        n(y, "class", "w-1/6"),
        n(
          e,
          "class",
          "flex items-center justify-between py-2 bg-light-gray px-4"
        );
    },
    m(w, g) {
      z(w, e, g),
        s(e, t),
        s(t, l),
        s(e, r),
        s(e, i),
        s(i, p),
        s(e, c),
        s(e, f),
        s(f, d),
        s(e, m),
        s(e, v),
        s(v, b),
        s(e, E),
        s(e, y),
        s(y, k);
    },
    d(w) {
      w && o(e);
    },
  };
}
function wr(a) {
  let e, t, l, r, i, p, c, f, d, m, v, b, E, y, k, w, g, I;
  k = new Vs({ props: { className: "w-6 h-6 p-2" } });
  function C() {
    return a[44](a[68], a[75]);
  }
  return {
    c() {
      (e = h("div")),
        (t = T("-")),
        (l = V()),
        (r = h("div")),
        (i = T("-")),
        (p = V()),
        (c = h("div")),
        (f = T("-")),
        (d = V()),
        (m = h("div")),
        (v = T("-")),
        (b = V()),
        (E = h("div")),
        (y = h("button")),
        Me(k.$$.fragment),
        this.h();
    },
    l(x) {
      e = _(x, "DIV", { class: !0 });
      var H = u(e);
      (t = P(H, "-")),
        H.forEach(o),
        (l = N(x)),
        (r = _(x, "DIV", { class: !0 }));
      var U = u(r);
      (i = P(U, "-")),
        U.forEach(o),
        (p = N(x)),
        (c = _(x, "DIV", { class: !0 }));
      var F = u(c);
      (f = P(F, "-")),
        F.forEach(o),
        (d = N(x)),
        (m = _(x, "DIV", { class: !0 }));
      var Z = u(m);
      (v = P(Z, "-")),
        Z.forEach(o),
        (b = N(x)),
        (E = _(x, "DIV", { class: !0 }));
      var X = u(E);
      y = _(X, "BUTTON", { class: !0 });
      var re = u(y);
      Oe(k.$$.fragment, re), re.forEach(o), X.forEach(o), this.h();
    },
    h() {
      n(e, "class", "w-1/3"),
        n(r, "class", "w-1/6"),
        n(c, "class", "w-1/3"),
        n(m, "class", "w-1/6"),
        n(y, "class", "text-xl rounded fpl-button flex items-center"),
        n(E, "class", "w-1/6 flex items-center");
    },
    m(x, H) {
      z(x, e, H),
        s(e, t),
        z(x, l, H),
        z(x, r, H),
        s(r, i),
        z(x, p, H),
        z(x, c, H),
        s(c, f),
        z(x, d, H),
        z(x, m, H),
        s(m, v),
        z(x, b, H),
        z(x, E, H),
        s(E, y),
        Be(k, y, null),
        (w = !0),
        g || ((I = we(y, "click", C)), (g = !0));
    },
    p(x, H) {
      a = x;
    },
    i(x) {
      w || (ae(k.$$.fragment, x), (w = !0));
    },
    o(x) {
      fe(k.$$.fragment, x), (w = !1);
    },
    d(x) {
      x && o(e),
        x && o(l),
        x && o(r),
        x && o(p),
        x && o(c),
        x && o(d),
        x && o(m),
        x && o(b),
        x && o(E),
        Fe(k),
        (g = !1),
        I();
    },
  };
}
function Er(a) {
  let e,
    t = a[73].firstName + "",
    l,
    r,
    i = a[73].lastName + "",
    p,
    c,
    f,
    d,
    m,
    v,
    b,
    E,
    y,
    k,
    w = a[76]?.name + "",
    g,
    I,
    C,
    x,
    H = (Number(a[73].value) / 4).toFixed(2) + "",
    U,
    F,
    Z,
    X,
    re,
    j,
    R,
    O,
    ne;
  const A = [Ir, kr],
    M = [];
  function $(D, Y) {
    return D[2]?.captainId === D[72] ? 0 : 1;
  }
  (d = $(a)),
    (m = M[d] = A[d](a)),
    (E = new Gl({
      props: {
        className: "h-5 w-5 mr-2",
        primaryColour: a[76]?.primaryColourHex,
        secondaryColour: a[76]?.secondaryColourHex,
        thirdColour: a[76]?.thirdColourHex,
      },
    })),
    (j = new Ns({ props: { className: "w-6 h-6 p-2" } }));
  function te() {
    return a[43](a[73]);
  }
  return {
    c() {
      (e = h("div")),
        (l = T(t)),
        (r = V()),
        (p = T(i)),
        (c = V()),
        (f = h("div")),
        m.c(),
        (v = V()),
        (b = h("div")),
        Me(E.$$.fragment),
        (y = V()),
        (k = h("p")),
        (g = T(w)),
        (I = V()),
        (C = h("div")),
        (x = T("£")),
        (U = T(H)),
        (F = T("m")),
        (Z = V()),
        (X = h("div")),
        (re = h("button")),
        Me(j.$$.fragment),
        this.h();
    },
    l(D) {
      e = _(D, "DIV", { class: !0 });
      var Y = u(e);
      (l = P(Y, t)),
        (r = N(Y)),
        (p = P(Y, i)),
        Y.forEach(o),
        (c = N(D)),
        (f = _(D, "DIV", { class: !0 }));
      var K = u(f);
      m.l(K), K.forEach(o), (v = N(D)), (b = _(D, "DIV", { class: !0 }));
      var J = u(b);
      Oe(E.$$.fragment, J), (y = N(J)), (k = _(J, "P", {}));
      var B = u(k);
      (g = P(B, w)),
        B.forEach(o),
        J.forEach(o),
        (I = N(D)),
        (C = _(D, "DIV", { class: !0 }));
      var ie = u(C);
      (x = P(ie, "£")),
        (U = P(ie, H)),
        (F = P(ie, "m")),
        ie.forEach(o),
        (Z = N(D)),
        (X = _(D, "DIV", { class: !0 }));
      var Q = u(X);
      re = _(Q, "BUTTON", { class: !0 });
      var Ee = u(re);
      Oe(j.$$.fragment, Ee), Ee.forEach(o), Q.forEach(o), this.h();
    },
    h() {
      n(e, "class", "w-1/3"),
        n(f, "class", "w-1/6 flex items-center"),
        n(b, "class", "flex w-1/3 items-center"),
        n(C, "class", "w-1/6"),
        n(re, "class", "bg-red-600 mb-1 rounded-sm"),
        n(X, "class", "w-1/6 flex items-center");
    },
    m(D, Y) {
      z(D, e, Y),
        s(e, l),
        s(e, r),
        s(e, p),
        z(D, c, Y),
        z(D, f, Y),
        M[d].m(f, null),
        z(D, v, Y),
        z(D, b, Y),
        Be(E, b, null),
        s(b, y),
        s(b, k),
        s(k, g),
        z(D, I, Y),
        z(D, C, Y),
        s(C, x),
        s(C, U),
        s(C, F),
        z(D, Z, Y),
        z(D, X, Y),
        s(X, re),
        Be(j, re, null),
        (R = !0),
        O || ((ne = we(re, "click", te)), (O = !0));
    },
    p(D, Y) {
      (a = D),
        (!R || Y[0] & 131078) && t !== (t = a[73].firstName + "") && be(l, t),
        (!R || Y[0] & 131078) && i !== (i = a[73].lastName + "") && be(p, i);
      let K = d;
      (d = $(a)),
        d === K
          ? M[d].p(a, Y)
          : (ct(),
            fe(M[K], 1, 1, () => {
              M[K] = null;
            }),
            ft(),
            (m = M[d]),
            m ? m.p(a, Y) : ((m = M[d] = A[d](a)), m.c()),
            ae(m, 1),
            m.m(f, null));
      const J = {};
      Y[0] & 163846 && (J.primaryColour = a[76]?.primaryColourHex),
        Y[0] & 163846 && (J.secondaryColour = a[76]?.secondaryColourHex),
        Y[0] & 163846 && (J.thirdColour = a[76]?.thirdColourHex),
        E.$set(J),
        (!R || Y[0] & 163846) && w !== (w = a[76]?.name + "") && be(g, w),
        (!R || Y[0] & 131078) &&
          H !== (H = (Number(a[73].value) / 4).toFixed(2) + "") &&
          be(U, H);
    },
    i(D) {
      R || (ae(m), ae(E.$$.fragment, D), ae(j.$$.fragment, D), (R = !0));
    },
    o(D) {
      fe(m), fe(E.$$.fragment, D), fe(j.$$.fragment, D), (R = !1);
    },
    d(D) {
      D && o(e),
        D && o(c),
        D && o(f),
        M[d].d(),
        D && o(v),
        D && o(b),
        Fe(E),
        D && o(I),
        D && o(C),
        D && o(Z),
        D && o(X),
        Fe(j),
        (O = !1),
        ne();
    },
  };
}
function kr(a) {
  let e, t, l, r, i;
  t = new xs({ props: { className: "w-6 h-6" } });
  function p() {
    return a[42](a[73]);
  }
  return {
    c() {
      (e = h("button")), Me(t.$$.fragment);
    },
    l(c) {
      e = _(c, "BUTTON", {});
      var f = u(e);
      Oe(t.$$.fragment, f), f.forEach(o);
    },
    m(c, f) {
      z(c, e, f),
        Be(t, e, null),
        (l = !0),
        r || ((i = we(e, "click", p)), (r = !0));
    },
    p(c, f) {
      a = c;
    },
    i(c) {
      l || (ae(t.$$.fragment, c), (l = !0));
    },
    o(c) {
      fe(t.$$.fragment, c), (l = !1);
    },
    d(c) {
      c && o(e), Fe(t), (r = !1), i();
    },
  };
}
function Ir(a) {
  let e, t, l;
  return (
    (t = new Ds({ props: { className: "w-6 h-6" } })),
    {
      c() {
        (e = h("span")), Me(t.$$.fragment);
      },
      l(r) {
        e = _(r, "SPAN", {});
        var i = u(e);
        Oe(t.$$.fragment, i), i.forEach(o);
      },
      m(r, i) {
        z(r, e, i), Be(t, e, null), (l = !0);
      },
      p: Le,
      i(r) {
        l || (ae(t.$$.fragment, r), (l = !0));
      },
      o(r) {
        fe(t.$$.fragment, r), (l = !1);
      },
      d(r) {
        r && o(e), Fe(t);
      },
    }
  );
}
function bs(a, e) {
  let t, l, r, i, p;
  const c = [Er, wr],
    f = [];
  function d(m, v) {
    return m[72] > 0 && m[73] ? 0 : 1;
  }
  return (
    (l = d(e)),
    (r = f[l] = c[l](e)),
    {
      key: a,
      first: null,
      c() {
        (t = h("div")), r.c(), (i = V()), this.h();
      },
      l(m) {
        t = _(m, "DIV", { class: !0 });
        var v = u(t);
        r.l(v), (i = N(v)), v.forEach(o), this.h();
      },
      h() {
        n(t, "class", "flex items-center justify-between py-2 px-4"),
          (this.first = t);
      },
      m(m, v) {
        z(m, t, v), f[l].m(t, null), s(t, i), (p = !0);
      },
      p(m, v) {
        e = m;
        let b = l;
        (l = d(e)),
          l === b
            ? f[l].p(e, v)
            : (ct(),
              fe(f[b], 1, 1, () => {
                f[b] = null;
              }),
              ft(),
              (r = f[l]),
              r ? r.p(e, v) : ((r = f[l] = c[l](e)), r.c()),
              ae(r, 1),
              r.m(t, i));
      },
      i(m) {
        p || (ae(r), (p = !0));
      },
      o(m) {
        fe(r), (p = !1);
      },
      d(m) {
        m && o(t), f[l].d();
      },
    }
  );
}
function gs(a) {
  let e,
    t,
    l,
    r,
    i = [],
    p = new As(),
    c,
    f,
    d = a[68] === 0 && vr(),
    m = a[68] === 1 && br(),
    v = a[68] === 2 && gr(),
    b = a[68] === 3 && yr(),
    E = a[66];
  const y = (k) => k[75];
  for (let k = 0; k < E.length; k += 1) {
    let w = ds(a, E, k),
      g = y(w);
    p.set(g, (i[k] = bs(g, w)));
  }
  return {
    c() {
      d && d.c(),
        (e = V()),
        m && m.c(),
        (t = V()),
        v && v.c(),
        (l = V()),
        b && b.c(),
        (r = V());
      for (let k = 0; k < i.length; k += 1) i[k].c();
      c = rl();
    },
    l(k) {
      d && d.l(k),
        (e = N(k)),
        m && m.l(k),
        (t = N(k)),
        v && v.l(k),
        (l = N(k)),
        b && b.l(k),
        (r = N(k));
      for (let w = 0; w < i.length; w += 1) i[w].l(k);
      c = rl();
    },
    m(k, w) {
      d && d.m(k, w),
        z(k, e, w),
        m && m.m(k, w),
        z(k, t, w),
        v && v.m(k, w),
        z(k, l, w),
        b && b.m(k, w),
        z(k, r, w);
      for (let g = 0; g < i.length; g += 1) i[g] && i[g].m(k, w);
      z(k, c, w), (f = !0);
    },
    p(k, w) {
      (w[0] & 268599302) | (w[1] & 7) &&
        ((E = k[66]),
        ct(),
        (i = Ts(i, w, y, 1, k, E, p, c.parentNode, Ps, bs, c, ds)),
        ft());
    },
    i(k) {
      if (!f) {
        for (let w = 0; w < E.length; w += 1) ae(i[w]);
        f = !0;
      }
    },
    o(k) {
      for (let w = 0; w < i.length; w += 1) fe(i[w]);
      f = !1;
    },
    d(k) {
      d && d.d(k),
        k && o(e),
        m && m.d(k),
        k && o(t),
        v && v.d(k),
        k && o(l),
        b && b.d(k),
        k && o(r);
      for (let w = 0; w < i.length; w += 1) i[w].d(k);
      k && o(c);
    },
  };
}
function Cr(a) {
  let e, t, l, r, i;
  t = new or({ props: { className: "h-12 md:h-16 mt-2 mb-2 md:mb-24" } });
  function p() {
    return a[40](a[68], a[75]);
  }
  return {
    c() {
      (e = h("button")), Me(t.$$.fragment);
    },
    l(c) {
      e = _(c, "BUTTON", {});
      var f = u(e);
      Oe(t.$$.fragment, f), f.forEach(o);
    },
    m(c, f) {
      z(c, e, f),
        Be(t, e, null),
        (l = !0),
        r || ((i = we(e, "click", p)), (r = !0));
    },
    p(c, f) {
      a = c;
    },
    i(c) {
      l || (ae(t.$$.fragment, c), (l = !0));
    },
    o(c) {
      fe(t.$$.fragment, c), (l = !1);
    },
    d(c) {
      c && o(e), Fe(t), (r = !1), i();
    },
  };
}
function Tr(a) {
  let e,
    t,
    l,
    r,
    i,
    p,
    c,
    f,
    d,
    m,
    v,
    b,
    E,
    y,
    k,
    w = Na(a[73].position) + "",
    g,
    I,
    C,
    x,
    H,
    U = a[73].firstName.length > 2 ? a[73].firstName.substring(0, 1) + "." : "",
    F,
    Z,
    X = a[73].lastName + "",
    re,
    j,
    R,
    O,
    ne = a[76]?.abbreviatedName + "",
    A,
    M,
    $,
    te,
    D,
    Y,
    K = (Number(a[73].value) / 4).toFixed(2) + "",
    J,
    B,
    ie,
    Q,
    Ee;
  i = new Ns({ props: { className: "w-5 h-5 p-1" } });
  function L() {
    return a[38](a[73]);
  }
  f = new Hs({
    props: {
      className: "h-16",
      primaryColour: a[76]?.primaryColourHex,
      secondaryColour: a[76]?.secondaryColourHex,
      thirdColour: a[76]?.thirdColourHex,
    },
  });
  const S = [Vr, Pr],
    se = [];
  function ke(de, ue) {
    return de[2]?.captainId === de[72] ? 0 : 1;
  }
  (m = ke(a)), (v = se[m] = S[m](a));
  var ce = xa(a[73].nationality);
  function Ne(de) {
    return { props: { class: "h-4 w-4 ml-2 mr-2 min-w-[15px]" } };
  }
  return (
    ce && (C = Va(ce, Ne())),
    ($ = new Gl({
      props: {
        className: "h-4 w-4 mr-2 ml-2 min-w-[15px]",
        primaryColour: a[76]?.primaryColourHex,
        secondaryColour: a[76]?.secondaryColourHex,
        thirdColour: a[76]?.thirdColourHex,
      },
    })),
    {
      c() {
        (e = h("div")),
          (t = h("div")),
          (l = h("div")),
          (r = h("button")),
          Me(i.$$.fragment),
          (p = V()),
          (c = h("div")),
          Me(f.$$.fragment),
          (d = V()),
          v.c(),
          (b = V()),
          (E = h("div")),
          (y = h("div")),
          (k = h("p")),
          (g = T(w)),
          (I = V()),
          C && Me(C.$$.fragment),
          (x = V()),
          (H = h("p")),
          (F = T(U)),
          (Z = V()),
          (re = T(X)),
          (j = V()),
          (R = h("div")),
          (O = h("p")),
          (A = T(ne)),
          (M = V()),
          Me($.$$.fragment),
          (te = V()),
          (D = h("p")),
          (Y = T("£")),
          (J = T(K)),
          (B = T("m")),
          this.h();
      },
      l(de) {
        e = _(de, "DIV", { class: !0 });
        var ue = u(e);
        t = _(ue, "DIV", { class: !0 });
        var xe = u(t);
        l = _(xe, "DIV", { class: !0 });
        var Pe = u(l);
        r = _(Pe, "BUTTON", { class: !0 });
        var Ve = u(r);
        Oe(i.$$.fragment, Ve),
          Ve.forEach(o),
          (p = N(Pe)),
          (c = _(Pe, "DIV", { class: !0 }));
        var Ye = u(c);
        Oe(f.$$.fragment, Ye),
          Ye.forEach(o),
          (d = N(Pe)),
          v.l(Pe),
          Pe.forEach(o),
          xe.forEach(o),
          (b = N(ue)),
          (E = _(ue, "DIV", { class: !0 }));
        var Te = u(E);
        y = _(Te, "DIV", { class: !0 });
        var Ie = u(y);
        k = _(Ie, "P", { class: !0 });
        var Ze = u(k);
        (g = P(Ze, w)),
          Ze.forEach(o),
          (I = N(Ie)),
          C && Oe(C.$$.fragment, Ie),
          (x = N(Ie)),
          (H = _(Ie, "P", { class: !0 }));
        var We = u(H);
        (F = P(We, U)),
          (Z = N(We)),
          (re = P(We, X)),
          We.forEach(o),
          Ie.forEach(o),
          (j = N(Te)),
          (R = _(Te, "DIV", { class: !0 }));
        var He = u(R);
        O = _(He, "P", { class: !0 });
        var Xe = u(O);
        (A = P(Xe, ne)),
          Xe.forEach(o),
          (M = N(He)),
          Oe($.$$.fragment, He),
          (te = N(He)),
          (D = _(He, "P", { class: !0 }));
        var lt = u(D);
        (Y = P(lt, "£")),
          (J = P(lt, K)),
          (B = P(lt, "m")),
          lt.forEach(o),
          He.forEach(o),
          Te.forEach(o),
          ue.forEach(o),
          this.h();
      },
      h() {
        n(r, "class", "bg-red-600 mb-1 rounded-sm"),
          n(c, "class", "flex justify-center items-center flex-grow"),
          n(l, "class", "flex justify-between items-end w-full"),
          n(t, "class", "flex justify-center items-center"),
          n(k, "class", "min-w-[20px]"),
          n(H, "class", "truncate min-w-[60px] max-w-[60px]"),
          n(
            y,
            "class",
            "flex justify-center items-center bg-gray-700 px-2 py-1 rounded-t-md min-w-[100px]"
          ),
          n(O, "class", "min-w-[20px]"),
          n(D, "class", "truncate min-w-[60px] max-w-[60px]"),
          n(
            R,
            "class",
            "flex justify-center items-center bg-white text-black px-2 py-1 rounded-b-md min-w-[100px]"
          ),
          n(E, "class", "flex flex-col justify-center items-center text-xs"),
          n(
            e,
            "class",
            "mt-2 mb-2 md:mb-12 flex flex-col items-center text-center"
          );
      },
      m(de, ue) {
        z(de, e, ue),
          s(e, t),
          s(t, l),
          s(l, r),
          Be(i, r, null),
          s(l, p),
          s(l, c),
          Be(f, c, null),
          s(l, d),
          se[m].m(l, null),
          s(e, b),
          s(e, E),
          s(E, y),
          s(y, k),
          s(k, g),
          s(y, I),
          C && Be(C, y, null),
          s(y, x),
          s(y, H),
          s(H, F),
          s(H, Z),
          s(H, re),
          s(E, j),
          s(E, R),
          s(R, O),
          s(O, A),
          s(R, M),
          Be($, R, null),
          s(R, te),
          s(R, D),
          s(D, Y),
          s(D, J),
          s(D, B),
          (ie = !0),
          Q || ((Ee = we(r, "click", L)), (Q = !0));
      },
      p(de, ue) {
        a = de;
        const xe = {};
        ue[0] & 163846 && (xe.primaryColour = a[76]?.primaryColourHex),
          ue[0] & 163846 && (xe.secondaryColour = a[76]?.secondaryColourHex),
          ue[0] & 163846 && (xe.thirdColour = a[76]?.thirdColourHex),
          f.$set(xe);
        let Pe = m;
        if (
          ((m = ke(a)),
          m === Pe
            ? se[m].p(a, ue)
            : (ct(),
              fe(se[Pe], 1, 1, () => {
                se[Pe] = null;
              }),
              ft(),
              (v = se[m]),
              v ? v.p(a, ue) : ((v = se[m] = S[m](a)), v.c()),
              ae(v, 1),
              v.m(l, null)),
          (!ie || ue[0] & 131078) &&
            w !== (w = Na(a[73].position) + "") &&
            be(g, w),
          ue[0] & 131078 && ce !== (ce = xa(a[73].nationality)))
        ) {
          if (C) {
            ct();
            const Ye = C;
            fe(Ye.$$.fragment, 1, 0, () => {
              Fe(Ye, 1);
            }),
              ft();
          }
          ce
            ? ((C = Va(ce, Ne())),
              Me(C.$$.fragment),
              ae(C.$$.fragment, 1),
              Be(C, y, x))
            : (C = null);
        }
        (!ie || ue[0] & 131078) &&
          U !==
            (U =
              a[73].firstName.length > 2
                ? a[73].firstName.substring(0, 1) + "."
                : "") &&
          be(F, U),
          (!ie || ue[0] & 131078) &&
            X !== (X = a[73].lastName + "") &&
            be(re, X),
          (!ie || ue[0] & 163846) &&
            ne !== (ne = a[76]?.abbreviatedName + "") &&
            be(A, ne);
        const Ve = {};
        ue[0] & 163846 && (Ve.primaryColour = a[76]?.primaryColourHex),
          ue[0] & 163846 && (Ve.secondaryColour = a[76]?.secondaryColourHex),
          ue[0] & 163846 && (Ve.thirdColour = a[76]?.thirdColourHex),
          $.$set(Ve),
          (!ie || ue[0] & 131078) &&
            K !== (K = (Number(a[73].value) / 4).toFixed(2) + "") &&
            be(J, K);
      },
      i(de) {
        ie ||
          (ae(i.$$.fragment, de),
          ae(f.$$.fragment, de),
          ae(v),
          C && ae(C.$$.fragment, de),
          ae($.$$.fragment, de),
          (ie = !0));
      },
      o(de) {
        fe(i.$$.fragment, de),
          fe(f.$$.fragment, de),
          fe(v),
          C && fe(C.$$.fragment, de),
          fe($.$$.fragment, de),
          (ie = !1);
      },
      d(de) {
        de && o(e), Fe(i), Fe(f), se[m].d(), C && Fe(C), Fe($), (Q = !1), Ee();
      },
    }
  );
}
function Pr(a) {
  let e, t, l, r, i;
  t = new xs({ props: { className: "w-6 h-6" } });
  function p() {
    return a[39](a[73]);
  }
  return {
    c() {
      (e = h("button")), Me(t.$$.fragment), this.h();
    },
    l(c) {
      e = _(c, "BUTTON", { class: !0 });
      var f = u(e);
      Oe(t.$$.fragment, f), f.forEach(o), this.h();
    },
    h() {
      n(e, "class", "mb-1");
    },
    m(c, f) {
      z(c, e, f),
        Be(t, e, null),
        (l = !0),
        r || ((i = we(e, "click", p)), (r = !0));
    },
    p(c, f) {
      a = c;
    },
    i(c) {
      l || (ae(t.$$.fragment, c), (l = !0));
    },
    o(c) {
      fe(t.$$.fragment, c), (l = !1);
    },
    d(c) {
      c && o(e), Fe(t), (r = !1), i();
    },
  };
}
function Vr(a) {
  let e, t, l;
  return (
    (t = new Ds({ props: { className: "w-6 h-6" } })),
    {
      c() {
        (e = h("span")), Me(t.$$.fragment), this.h();
      },
      l(r) {
        e = _(r, "SPAN", { class: !0 });
        var i = u(e);
        Oe(t.$$.fragment, i), i.forEach(o), this.h();
      },
      h() {
        n(e, "class", "mb-1");
      },
      m(r, i) {
        z(r, e, i), Be(t, e, null), (l = !0);
      },
      p: Le,
      i(r) {
        l || (ae(t.$$.fragment, r), (l = !0));
      },
      o(r) {
        fe(t.$$.fragment, r), (l = !1);
      },
      d(r) {
        r && o(e), Fe(t);
      },
    }
  );
}
function ys(a, e) {
  let t, l, r, i;
  const p = [Tr, Cr],
    c = [];
  function f(m, v) {
    return m[72] > 0 && m[73] ? 0 : 1;
  }
  function d(m, v) {
    return v === 0 ? hr(m) : m;
  }
  return (
    (l = f(e)),
    (r = c[l] = p[l](d(e, l))),
    {
      key: a,
      first: null,
      c() {
        (t = h("div")), r.c(), this.h();
      },
      l(m) {
        t = _(m, "DIV", { class: !0 });
        var v = u(t);
        r.l(v), v.forEach(o), this.h();
      },
      h() {
        n(t, "class", "flex flex-col justify-center items-center flex-1"),
          (this.first = t);
      },
      m(m, v) {
        z(m, t, v), c[l].m(t, null), (i = !0);
      },
      p(m, v) {
        e = m;
        let b = l;
        (l = f(e)),
          l === b
            ? c[l].p(d(e, l), v)
            : (ct(),
              fe(c[b], 1, 1, () => {
                c[b] = null;
              }),
              ft(),
              (r = c[l]),
              r ? r.p(d(e, l), v) : ((r = c[l] = p[l](d(e, l))), r.c()),
              ae(r, 1),
              r.m(t, null));
      },
      i(m) {
        i || (ae(r), (i = !0));
      },
      o(m) {
        fe(r), (i = !1);
      },
      d(m) {
        m && o(t), c[l].d();
      },
    }
  );
}
function ws(a) {
  let e,
    t = [],
    l = new As(),
    r,
    i,
    p = a[66];
  const c = (f) => f[75];
  for (let f = 0; f < p.length; f += 1) {
    let d = hs(a, p, f),
      m = c(d);
    l.set(m, (t[f] = ys(m, d)));
  }
  return {
    c() {
      e = h("div");
      for (let f = 0; f < t.length; f += 1) t[f].c();
      (r = V()), this.h();
    },
    l(f) {
      e = _(f, "DIV", { class: !0 });
      var d = u(e);
      for (let m = 0; m < t.length; m += 1) t[m].l(d);
      (r = N(d)), d.forEach(o), this.h();
    },
    h() {
      n(e, "class", "flex justify-around items-center w-full");
    },
    m(f, d) {
      z(f, e, d);
      for (let m = 0; m < t.length; m += 1) t[m] && t[m].m(e, null);
      s(e, r), (i = !0);
    },
    p(f, d) {
      (d[0] & 268599302) | (d[1] & 7) &&
        ((p = f[66]),
        ct(),
        (t = Ts(t, d, c, 1, f, p, l, e, Ps, ys, r, hs)),
        ft());
    },
    i(f) {
      if (!i) {
        for (let d = 0; d < p.length; d += 1) ae(t[d]);
        i = !0;
      }
    },
    o(f) {
      for (let d = 0; d < t.length; d += 1) fe(t[d]);
      i = !1;
    },
    d(f) {
      f && o(e);
      for (let d = 0; d < t.length; d += 1) t[d].d();
    },
  };
}
function Nr(a) {
  let e,
    t,
    l = a[16] && ps(a);
  return {
    c() {
      l && l.c(), (e = rl());
    },
    l(r) {
      l && l.l(r), (e = rl());
    },
    m(r, i) {
      l && l.m(r, i), z(r, e, i), (t = !0);
    },
    p(r, i) {
      r[16]
        ? l
          ? (l.p(r, i), i[0] & 65536 && ae(l, 1))
          : ((l = ps(r)), l.c(), ae(l, 1), l.m(e.parentNode, e))
        : l &&
          (ct(),
          fe(l, 1, 1, () => {
            l = null;
          }),
          ft());
    },
    i(r) {
      t || (ae(l), (t = !0));
    },
    o(r) {
      fe(l), (t = !1);
    },
    d(r) {
      l && l.d(r), r && o(e);
    },
  };
}
function xr(a) {
  let e, t;
  return (
    (e = new Ms({
      props: { $$slots: { default: [Nr] }, $$scope: { ctx: a } },
    })),
    {
      c() {
        Me(e.$$.fragment);
      },
      l(l) {
        Oe(e.$$.fragment, l);
      },
      m(l, r) {
        Be(e, l, r), (t = !0);
      },
      p(l, r) {
        const i = {};
        (r[0] & 4194303) | (r[2] & 1048576) &&
          (i.$$scope = { dirty: r, ctx: l }),
          e.$set(i);
      },
      i(l) {
        t || (ae(e.$$.fragment, l), (t = !0));
      },
      o(l) {
        fe(e.$$.fragment, l), (t = !1);
      },
      d(l) {
        Fe(e, l);
      },
    }
  );
}
function Dr(a) {
  const e = a.split("-").map(Number);
  return [
    [1],
    ...e.map((l) =>
      Array(l)
        .fill(0)
        .map((r, i) => i + 1)
    ),
  ];
}
function Ar(a) {
  if (!a) return !1;
  const e = {},
    t = [
      a.hatTrickHeroGameweek,
      a.teamBoostGameweek,
      a.captainFantasticGameweek,
      a.braceBonusGameweek,
      a.passMasterGameweek,
      a.goalGetterGameweek,
      a.noEntryGameweek,
      a.safeHandsGameweek,
    ];
  for (const l of t)
    if (l !== 0 && ((e[l] = (e[l] || 0) + 1), e[l] > 1)) return !1;
  return !0;
}
function Gr(a, e, t) {
  const l = { 0: 0, 1: 0, 2: 0, 3: 0 };
  e.playerIds.forEach((E) => {
    const y = a.find((k) => k.id === E);
    y && l[y.position]++;
  });
  const [r, i, p] = t.split("-").map(Number),
    c = Math.max(0, r - (l[1] || 0)),
    f = Math.max(0, i - (l[2] || 0)),
    d = Math.max(0, p - (l[3] || 0)),
    m = Math.max(0, 1 - (l[0] || 0)),
    v = c + f + d + m;
  return Object.values(l).reduce((E, y) => E + y, 0) + v <= 11;
}
const Es = (a) => a > 0,
  ks = (a) => a === 0,
  Is = (a) => a === 0;
function Mr(a, e, t) {
  let l, r, i, p, c, f;
  const d = {
      "3-4-3": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3] },
      "3-5-2": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3] },
      "4-3-3": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3] },
      "4-4-2": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3] },
      "4-5-1": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3] },
      "5-4-1": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3] },
      "5-3-2": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3] },
    },
    m = al(["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"]);
  Ll(a, m, (G) => t(21, (f = G)));
  let v = "-",
    b = -1,
    E = "-",
    y = "-",
    k,
    w,
    g = "00",
    I = "00",
    C = "00",
    x = "4-4-2",
    H = -1,
    U = -1,
    F = !0,
    Z = !1,
    X = 0,
    re = !0,
    j,
    R,
    O,
    ne = [],
    A = !1,
    M,
    $,
    te;
  const D = al(null);
  Ll(a, D, (G) => t(2, (i = G)));
  const Y = al(re ? 1 / 0 : 3);
  Ll(a, Y, (G) => t(19, (p = G)));
  const K = al(1200);
  Ll(a, K, (G) => t(20, (c = G))),
    la(async () => {
      Ul.set(!0);
      try {
        await Yl.sync(),
          await sl.sync(),
          await Zl.sync(),
          (M = Yl.subscribe((ge) => {
            (O = ge),
              t(4, (b = O?.activeGameweek ?? b)),
              t(3, (v = O?.activeSeason.name ?? v));
          })),
          ($ = sl.subscribe((ge) => {
            t(15, (j = ge));
          })),
          (te = Zl.subscribe((ge) => {
            t(1, (R = ge));
          }));
        const G = localStorage.getItem("viewMode");
        G && t(12, (F = G === "pitch"));
        let q = await ea.getNextFixture();
        (k = await sl.getTeamById(q?.homeTeamId ?? 0)),
          (w = await sl.getTeamById(q?.awayTeamId ?? 0));
        let le = await Da.getFantasyTeam();
        D.set(le);
        let oe = Qe(D)?.principalId ?? "";
        b > 1 &&
          oe.length > 0 &&
          ((re = !1), Y.set(le.transfersAvailable), K.set(le.bankBalance)),
          D.update((ge) =>
            ge && (!ge.playerIds || ge.playerIds.length !== 11)
              ? { ...ge, playerIds: new Uint16Array(11).fill(0) }
              : ge
          ),
          t(5, (E = Bs(Number(q?.kickOff)))),
          t(6, (y = ta(Number(q?.kickOff))));
        let me = Fs(Number(q?.kickOff));
        t(7, (g = me.days.toString())),
          t(8, (I = me.hours.toString())),
          t(9, (C = me.minutes.toString()));
      } catch (G) {
        jl.show("Error fetching team details.", "error"),
          console.error("Error fetching team details:", G);
      } finally {
        Ul.set(!1), t(16, (A = !0));
      }
    }),
    aa(() => {
      $?.(), te?.(), M?.();
    });
  function J() {
    t(12, (F = !0)), localStorage.setItem("viewMode", "pitch");
  }
  function B() {
    t(12, (F = !1)), localStorage.setItem("viewMode", "list");
  }
  function ie(G, q) {
    t(10, (H = G)), t(11, (U = q)), t(13, (Z = !0));
  }
  function Q() {
    t(13, (Z = !1));
  }
  function Ee(G) {
    const q = Qe(D);
    if (q) {
      if (L(G, q, x)) S(G, q, x);
      else {
        const le = ke(q, G);
        ce(q, le), t(0, (x = le)), S(G, q, le);
      }
      !re && b > 1 && Y.update((le) => (le > 0 ? le - 1 : 0)),
        K.update((le) =>
          le - Number(G.value) > 0 ? le - Number(G.value) : le
        ),
        q.playerIds.includes(G.id) || ne.push(G.id);
    }
  }
  function L(G, q, le) {
    const oe = { 0: 0, 1: 0, 2: 0, 3: 0 };
    q.playerIds.forEach((Nt) => {
      const At = R.find((ut) => ut.id === Nt);
      At && oe[At.position]++;
    }),
      oe[G.position]++;
    const [me, ge, ye] = le.split("-").map(Number),
      Se = Math.max(0, me - (oe[1] || 0)),
      ze = Math.max(0, ge - (oe[2] || 0)),
      je = Math.max(0, ye - (oe[3] || 0)),
      gt = Math.max(0, 1 - (oe[0] || 0)),
      et = Se + ze + je + gt;
    return Object.values(oe).reduce((Nt, At) => Nt + At, 0) + et <= 11;
  }
  function S(G, q, le) {
    const oe = se(G.position, q, le);
    if (oe === -1) {
      console.error("No available position to add the player.");
      return;
    }
    D.update((me) => {
      if (!me) return null;
      const ge = Uint16Array.from(me.playerIds);
      return oe < ge.length
        ? ((ge[oe] = G.id), { ...me, playerIds: ge })
        : (console.error(
            "Index out of bounds when attempting to add player to team."
          ),
          me);
    }),
      xe(Qe(D));
  }
  function se(G, q, le) {
    const oe = d[le].positions;
    for (let me = 0; me < oe.length; me++)
      if (oe[me] === G && q.playerIds[me] === 0) return me;
    return -1;
  }
  function ke(G, q) {
    const le = { 0: 1, 1: 0, 2: 0, 3: 0 };
    G.playerIds.forEach((ge) => {
      const ye = R.find((Se) => Se.id === ge);
      ye && le[ye.position]++;
    }),
      le[q.position]++;
    let oe = null,
      me = Number.MAX_SAFE_INTEGER;
    for (const ge of Object.keys(d)) {
      if (ge === x) continue;
      const ye = d[ge].positions;
      let Se = { 0: 0, 1: 0, 2: 0, 3: 0 };
      ye.forEach((je) => {
        Se[je]++;
      });
      const ze = Object.keys(Se).reduce((je, gt) => {
        const et = parseInt(gt);
        return je + Math.max(0, Se[et] - le[et]);
      }, 0);
      ze < me && Se[q.position] > le[q.position] - 1 && ((oe = ge), (me = ze));
    }
    return oe || (console.error("No valid formation found for the player"), x);
  }
  function ce(G, q) {
    const le = d[q].positions;
    let oe = new Array(11).fill(0);
    G.playerIds.forEach((me) => {
      const ge = R.find((ye) => ye.id === me);
      if (ge) {
        for (let ye = 0; ye < le.length; ye++)
          if (le[ye] === ge.position && oe[ye] === 0) {
            oe[ye] = me;
            break;
          }
      }
    }),
      (G.playerIds = oe);
  }
  function Ne(G, q) {
    return l.slice(0, G).reduce((oe, me) => oe + me.length, 0) + q;
  }
  function de(G) {
    t(10, (H = -1)),
      t(11, (U = -1)),
      D.update((q) => {
        if (!q) return null;
        const le = q.playerIds.indexOf(G);
        if (le === -1) return console.error("Player not found in the team."), q;
        const oe = Uint16Array.from(q.playerIds);
        return (
          (oe[le] = 0),
          ne.includes(G) &&
            (!re && b > 1 && Y.update((me) => me + 1),
            (ne = ne.filter((me) => me !== G))),
          K.update((me) => me + Number(R.find((ge) => ge.id === G)?.value)),
          { ...q, playerIds: oe }
        );
      }),
      xe(Qe(D));
  }
  function ue(G) {
    t(10, (H = -1)),
      t(11, (U = -1)),
      D.update((q) => (q ? { ...q, captainId: G } : null));
  }
  function xe(G) {
    if (
      !G.captainId ||
      G.captainId === 0 ||
      !G.playerIds.includes(G.captainId)
    ) {
      const q = Pe(G);
      ue(q);
    }
  }
  function Pe(G) {
    let q = 0,
      le = 0;
    return (
      G.playerIds.forEach((oe) => {
        const me = R.find((ge) => ge.id === oe);
        me && Number(me.value) > q && ((q = Number(me.value)), (le = oe));
      }),
      le
    );
  }
  function Ve() {
    const G = Qe(D);
    if (!G || !G.playerIds) return;
    const q = Os(R, G);
    m.set(q);
  }
  function Ye() {
    const G = Qe(D);
    if (G) {
      let q = 0;
      G.playerIds.forEach((le) => {
        const oe = R.find((me) => me.id === le);
        oe && (q += Number(oe.value));
      }),
        t(14, (X = q / 4));
    }
  }
  function Te() {
    const G = new Map();
    for (const q of i?.playerIds || [])
      if (q > 0) {
        const le = R.find((oe) => oe.id === q);
        if (
          le &&
          (G.set(le.teamId, (G.get(le.teamId) || 0) + 1), G.get(le.teamId) > 1)
        )
          return !1;
      }
    return !(
      !Ar(i) ||
      i?.playerIds.filter((q) => q > 0).length !== 11 ||
      c < 0 ||
      p < 0 ||
      !Gr(R, i, x)
    );
  }
  function Ie() {
    const G = Qe(D);
    if (!G || !R) return;
    let q = { ...G, playerIds: new Uint16Array(11) },
      le = Qe(K);
    const oe = new Map();
    q.playerIds.forEach((ye) => {
      if (ye > 0) {
        const Se = R.find((ze) => ze.id === ye);
        Se && oe.set(Se.teamId, (oe.get(Se.teamId) || 0) + 1);
      }
    });
    let me = Array.from(new Set(R.map((ye) => ye.teamId))).filter(
      (ye) => ye > 0
    );
    me.sort(() => Math.random() - 0.5),
      d[x].positions.forEach((ye, Se) => {
        if (le <= 0 || me.length === 0) return;
        const ze = me.shift();
        if (ze === void 0) return;
        const je = R.filter(
          (Ae) =>
            Ae.position === ye &&
            Ae.teamId === ze &&
            !q.playerIds.includes(Ae.id) &&
            (oe.get(Ae.teamId) || 0) < 1
        );
        je.sort((Ae, Nt) => Number(Ae.value) - Number(Nt.value));
        const gt = je.slice(0, Math.ceil(je.length / 2)),
          et = gt[Math.floor(Math.random() * gt.length)];
        if (et) {
          const Ae = le - Number(et.value);
          if (Ae < 0) return;
          (q.playerIds[Se] = et.id),
            (le = Ae),
            oe.set(et.teamId, (oe.get(et.teamId) || 0) + 1);
        }
      }),
      le >= 0 && (D.set(q), K.set(le));
  }
  async function Ze() {
    Ul.set(!0);
    let G = Qe(D);
    (G?.captainId === 0 || !G?.playerIds.includes(G?.captainId)) &&
      (G.captainId = Pe(G)),
      G?.safeHandsGameweek === b &&
        G?.safeHandsPlayerId !== G?.playerIds[0] &&
        (G.safeHandsPlayerId = G?.playerIds[0]),
      G?.captainFantasticGameweek === b &&
        G?.captainFantasticPlayerId !== G?.captainId &&
        (G.captainFantasticPlayerId = G?.captainId);
    try {
      await Da.saveFantasyTeam(G, b),
        jl.show("Team saved successully!", "success");
    } catch (q) {
      jl.show("Error saving team.", "error"),
        console.error("Error saving team:", q);
    } finally {
      Ul.set(!1);
    }
  }
  function We() {
    (x = _l(this)), t(0, x);
  }
  const He = (G, q) => q.id === G.teamId,
    Xe = (G) => de(G.id),
    lt = (G) => ue(G.id),
    bt = (G, q) => ie(G, q),
    dt = (G, q) => q.id === G,
    Mt = (G) => ue(G.id),
    Ue = (G) => de(G.id),
    mt = (G, q) => ie(G, q),
    Kt = (G, q) => q.id === G,
    qt = (G, q) => q.id === G?.teamId;
  return (
    (a.$$.update = () => {
      a.$$.dirty[0] & 1 && t(17, (l = Dr(x))),
        a.$$.dirty[0] & 6 && R && i && (Ve(), Ye());
    }),
    t(18, (r = Te())),
    [
      x,
      R,
      i,
      v,
      b,
      E,
      y,
      g,
      I,
      C,
      H,
      U,
      F,
      Z,
      X,
      j,
      A,
      l,
      r,
      p,
      c,
      f,
      m,
      D,
      Y,
      K,
      J,
      B,
      ie,
      Q,
      Ee,
      Ne,
      de,
      ue,
      Ie,
      Ze,
      We,
      He,
      Xe,
      lt,
      bt,
      dt,
      Mt,
      Ue,
      mt,
      Kt,
      qt,
    ]
  );
}
class Xr extends St {
  constructor(e) {
    super(), Lt(this, e, Mr, xr, Ut, {}, null, [-1, -1, -1]);
  }
}
export { Xr as component };
