import { B as Ml } from "../chunks/BadgeIcon.ac2d82f5.js";
import {
  j as $l,
  e as Bs,
  h as Fs,
  f as Jl,
  g as Na,
  i as Os,
  d as Pa,
  b as Ql,
  s as Rl,
  v as Ss,
  a as Ul,
  m as Va,
  t as Vl,
  L as Vs,
} from "../chunks/Layout.0e76e124.js";
import { S as Ls } from "../chunks/ShirtIcon.3da312bd.js";
import {
  q as C,
  a4 as Ca,
  V as Cl,
  Z as Cs,
  K as Et,
  B as He,
  S as Ht,
  a3 as Ia,
  U as Is,
  M as It,
  R as Kl,
  A as Le,
  a6 as Ms,
  c as N,
  H as Ne,
  a as P,
  y as Se,
  r as T,
  x as Ta,
  Q as Tl,
  a5 as Ts,
  i as Ut,
  N as Wl,
  b as X,
  e as Yt,
  k as _,
  X as al,
  a0 as cl,
  m as d,
  o as ea,
  P as fl,
  h as i,
  I as il,
  z as je,
  W as jl,
  s as jt,
  L as ke,
  f as nt,
  n as o,
  d as oe,
  p as ot,
  l as p,
  a1 as pe,
  v as rt,
  G as s,
  O as ta,
  g as te,
  J as ul,
  a2 as ve,
  u as we,
  T as zl,
} from "../chunks/index.a8c54947.js";
import { m as Da } from "../chunks/manager-store.ef17e835.js";
import { w as it } from "../chunks/singletons.fdfa7ed0.js";
var Qe = ((a) => (
  (a[(a.AUTOMATIC = 0)] = "AUTOMATIC"),
  (a[(a.PLAYER = 1)] = "PLAYER"),
  (a[(a.TEAM = 2)] = "TEAM"),
  (a[(a.COUNTRY = 3)] = "COUNTRY"),
  a
))(Qe || {});
function Ga(a, e, t) {
  const l = a.slice();
  return (l[28] = e[t]), l;
}
function Aa(a, e, t) {
  const l = a.slice();
  return (l[31] = e[t]), l;
}
function Ma(a, e, t) {
  const l = a.slice();
  return (l[34] = e[t]), l;
}
function Ba(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c,
    u = a[5].name + "",
    h,
    v,
    b,
    E,
    x = a[5].description + "",
    g,
    y,
    w,
    V,
    k,
    G,
    D,
    $,
    B,
    H,
    R,
    ce,
    S,
    K,
    O,
    ne,
    q,
    le,
    j,
    ae,
    M,
    L,
    I = a[5].selectionType === Qe.PLAYER && Fa(a),
    W = a[5].selectionType === Qe.COUNTRY && Sa(a),
    Q = a[5].selectionType === Qe.TEAM && Ha(a);
  return {
    c() {
      (e = _("div")),
        (t = _("div")),
        (l = _("img")),
        (m = P()),
        (f = _("div")),
        (c = _("h3")),
        (h = C(u)),
        (v = P()),
        (b = _("div")),
        (E = _("p")),
        (g = C(x)),
        (y = P()),
        I && I.c(),
        (w = P()),
        W && W.c(),
        (V = P()),
        Q && Q.c(),
        (k = P()),
        (G = _("div")),
        (D = _("p")),
        ($ = C("Warning")),
        (B = P()),
        (H = _("p")),
        (R =
          C(`Your bonus will be activated when you save your team and it cannot
            be reversed. A bonus can only be played once per season.`)),
        (ce = P()),
        (S = _("div")),
        (K = _("button")),
        (O = C("Cancel")),
        (ne = P()),
        (q = _("button")),
        (le = C("Use")),
        this.h();
    },
    l(_e) {
      e = p(_e, "DIV", { class: !0 });
      var se = d(e);
      t = p(se, "DIV", { class: !0 });
      var Ce = d(t);
      (l = p(Ce, "IMG", { src: !0, class: !0, alt: !0 })),
        (m = N(Ce)),
        (f = p(Ce, "DIV", { class: !0 }));
      var Y = d(f);
      c = p(Y, "H3", { class: !0 });
      var U = d(c);
      (h = T(U, u)), U.forEach(i), (v = N(Y)), (b = p(Y, "DIV", { class: !0 }));
      var ee = d(b);
      E = p(ee, "P", { class: !0 });
      var Ee = d(E);
      (g = T(Ee, x)),
        Ee.forEach(i),
        ee.forEach(i),
        (y = N(Y)),
        I && I.l(Y),
        (w = N(Y)),
        W && W.l(Y),
        (V = N(Y)),
        Q && Q.l(Y),
        (k = N(Y)),
        (G = p(Y, "DIV", { class: !0, role: !0 }));
      var he = d(G);
      D = p(he, "P", { class: !0 });
      var Be = d(D);
      ($ = T(Be, "Warning")),
        Be.forEach(i),
        (B = N(he)),
        (H = p(he, "P", { class: !0 }));
      var me = d(H);
      (R = T(
        me,
        `Your bonus will be activated when you save your team and it cannot
            be reversed. A bonus can only be played once per season.`
      )),
        me.forEach(i),
        he.forEach(i),
        (ce = N(Y)),
        (S = p(Y, "DIV", { class: !0 }));
      var F = d(S);
      K = p(F, "BUTTON", { class: !0 });
      var be = d(K);
      (O = T(be, "Cancel")),
        be.forEach(i),
        (ne = N(F)),
        (q = p(F, "BUTTON", { class: !0 }));
      var ge = d(q);
      (le = T(ge, "Use")),
        ge.forEach(i),
        F.forEach(i),
        Y.forEach(i),
        Ce.forEach(i),
        se.forEach(i),
        this.h();
    },
    h() {
      cl(l.src, (r = a[5].image)) || o(l, "src", r),
        o(l, "class", "w-16 mx-auto block"),
        o(l, "alt", (n = a[5].name)),
        o(c, "class", "text-lg leading-6 font-medium"),
        o(E, "class", "text-sm"),
        o(b, "class", "mt-2 px-7 py-3"),
        o(D, "class", "font-bold text-sm"),
        o(H, "class", "font-bold text-xs"),
        o(
          G,
          "class",
          "bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-2"
        ),
        o(G, "role", "alert"),
        o(
          K,
          "class",
          "px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        ),
        o(
          q,
          "class",
          (j = `px-4 py-2 ${
            a[10] ? "fpl-purple-btn" : "bg-gray-500"
          } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`)
        ),
        (q.disabled = ae = !a[10]),
        o(S, "class", "items-center py-3 flex space-x-4"),
        o(f, "class", "mt-3 text-center"),
        o(
          t,
          "class",
          "relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
        ),
        o(
          e,
          "class",
          "fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
        );
    },
    m(_e, se) {
      X(_e, e, se),
        s(e, t),
        s(t, l),
        s(t, m),
        s(t, f),
        s(f, c),
        s(c, h),
        s(f, v),
        s(f, b),
        s(b, E),
        s(E, g),
        s(f, y),
        I && I.m(f, null),
        s(f, w),
        W && W.m(f, null),
        s(f, V),
        Q && Q.m(f, null),
        s(f, k),
        s(f, G),
        s(G, D),
        s(D, $),
        s(G, B),
        s(G, H),
        s(H, R),
        s(f, ce),
        s(f, S),
        s(S, K),
        s(K, O),
        s(S, ne),
        s(S, q),
        s(q, le),
        M ||
          ((L = [
            ke(K, "click", function () {
              Tl(a[4]) && a[4].apply(this, arguments);
            }),
            ke(q, "click", a[13]),
            ke(t, "click", Kl(a[16])),
            ke(t, "keydown", a[14]),
            ke(e, "click", function () {
              Tl(a[4]) && a[4].apply(this, arguments);
            }),
            ke(e, "keydown", a[14]),
          ]),
          (M = !0));
    },
    p(_e, se) {
      (a = _e),
        se[0] & 32 && !cl(l.src, (r = a[5].image)) && o(l, "src", r),
        se[0] & 32 && n !== (n = a[5].name) && o(l, "alt", n),
        se[0] & 32 && u !== (u = a[5].name + "") && we(h, u),
        se[0] & 32 && x !== (x = a[5].description + "") && we(g, x),
        a[5].selectionType === Qe.PLAYER
          ? I
            ? I.p(a, se)
            : ((I = Fa(a)), I.c(), I.m(f, w))
          : I && (I.d(1), (I = null)),
        a[5].selectionType === Qe.COUNTRY
          ? W
            ? W.p(a, se)
            : ((W = Sa(a)), W.c(), W.m(f, V))
          : W && (W.d(1), (W = null)),
        a[5].selectionType === Qe.TEAM
          ? Q
            ? Q.p(a, se)
            : ((Q = Ha(a)), Q.c(), Q.m(f, k))
          : Q && (Q.d(1), (Q = null)),
        se[0] & 1024 &&
          j !==
            (j = `px-4 py-2 ${
              a[10] ? "fpl-purple-btn" : "bg-gray-500"
            } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`) &&
          o(q, "class", j),
        se[0] & 1024 && ae !== (ae = !a[10]) && (q.disabled = ae);
    },
    d(_e) {
      _e && i(e), I && I.d(), W && W.d(), Q && Q.d(), (M = !1), Wl(L);
    },
  };
}
function Fa(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f = a[12],
    c = [];
  for (let u = 0; u < f.length; u += 1) c[u] = Oa(Ma(a, f, u));
  return {
    c() {
      (e = _("div")),
        (t = _("select")),
        (l = _("option")),
        (r = C("Select Player"));
      for (let u = 0; u < c.length; u += 1) c[u].c();
      this.h();
    },
    l(u) {
      e = p(u, "DIV", { class: !0 });
      var h = d(e);
      t = p(h, "SELECT", { class: !0 });
      var v = d(t);
      l = p(v, "OPTION", {});
      var b = d(l);
      (r = T(b, "Select Player")), b.forEach(i);
      for (let E = 0; E < c.length; E += 1) c[E].l(v);
      v.forEach(i), h.forEach(i), this.h();
    },
    h() {
      (l.__value = 0),
        (l.value = l.__value),
        o(t, "class", "w-full p-2 rounded-md fpl-dropdown"),
        a[7] === void 0 && ul(() => a[17].call(t)),
        o(e, "class", "w-full border border-gray-500 my-4");
    },
    m(u, h) {
      X(u, e, h), s(e, t), s(t, l), s(l, r);
      for (let v = 0; v < c.length; v += 1) c[v] && c[v].m(t, null);
      Et(t, a[7], !0), n || ((m = ke(t, "change", a[17])), (n = !0));
    },
    p(u, h) {
      if (h[0] & 4096) {
        f = u[12];
        let v;
        for (v = 0; v < f.length; v += 1) {
          const b = Ma(u, f, v);
          c[v] ? c[v].p(b, h) : ((c[v] = Oa(b)), c[v].c(), c[v].m(t, null));
        }
        for (; v < c.length; v += 1) c[v].d(1);
        c.length = f.length;
      }
      h[0] & 4224 && Et(t, u[7]);
    },
    d(u) {
      u && i(e), It(c, u), (n = !1), m();
    },
  };
}
function Oa(a) {
  let e,
    t = a[34].name + "",
    l,
    r;
  return {
    c() {
      (e = _("option")), (l = C(t)), this.h();
    },
    l(n) {
      e = p(n, "OPTION", {});
      var m = d(e);
      (l = T(m, t)), m.forEach(i), this.h();
    },
    h() {
      (e.__value = r = a[34].id), (e.value = e.__value);
    },
    m(n, m) {
      X(n, e, m), s(e, l);
    },
    p(n, m) {
      m[0] & 4096 && t !== (t = n[34].name + "") && we(l, t),
        m[0] & 4096 &&
          r !== (r = n[34].id) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(n) {
      n && i(e);
    },
  };
}
function Sa(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f = a[9],
    c = [];
  for (let u = 0; u < f.length; u += 1) c[u] = La(Aa(a, f, u));
  return {
    c() {
      (e = _("div")),
        (t = _("select")),
        (l = _("option")),
        (r = C("Select Country"));
      for (let u = 0; u < c.length; u += 1) c[u].c();
      this.h();
    },
    l(u) {
      e = p(u, "DIV", { class: !0 });
      var h = d(e);
      t = p(h, "SELECT", { class: !0 });
      var v = d(t);
      l = p(v, "OPTION", {});
      var b = d(l);
      (r = T(b, "Select Country")), b.forEach(i);
      for (let E = 0; E < c.length; E += 1) c[E].l(v);
      v.forEach(i), h.forEach(i), this.h();
    },
    h() {
      (l.__value = 0),
        (l.value = l.__value),
        o(t, "class", "w-full p-2 rounded-md fpl-dropdown"),
        a[8] === void 0 && ul(() => a[18].call(t)),
        o(e, "class", "w-full border border-gray-500 my-4");
    },
    m(u, h) {
      X(u, e, h), s(e, t), s(t, l), s(l, r);
      for (let v = 0; v < c.length; v += 1) c[v] && c[v].m(t, null);
      Et(t, a[8], !0), n || ((m = ke(t, "change", a[18])), (n = !0));
    },
    p(u, h) {
      if (h[0] & 512) {
        f = u[9];
        let v;
        for (v = 0; v < f.length; v += 1) {
          const b = Aa(u, f, v);
          c[v] ? c[v].p(b, h) : ((c[v] = La(b)), c[v].c(), c[v].m(t, null));
        }
        for (; v < c.length; v += 1) c[v].d(1);
        c.length = f.length;
      }
      h[0] & 768 && Et(t, u[8]);
    },
    d(u) {
      u && i(e), It(c, u), (n = !1), m();
    },
  };
}
function La(a) {
  let e,
    t = a[31] + "",
    l,
    r;
  return {
    c() {
      (e = _("option")), (l = C(t)), this.h();
    },
    l(n) {
      e = p(n, "OPTION", {});
      var m = d(e);
      (l = T(m, t)), m.forEach(i), this.h();
    },
    h() {
      (e.__value = r = a[31]), (e.value = e.__value);
    },
    m(n, m) {
      X(n, e, m), s(e, l);
    },
    p(n, m) {
      m[0] & 512 && t !== (t = n[31] + "") && we(l, t),
        m[0] & 512 &&
          r !== (r = n[31]) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(n) {
      n && i(e);
    },
  };
}
function Ha(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f = a[11],
    c = [];
  for (let u = 0; u < f.length; u += 1) c[u] = Ua(Ga(a, f, u));
  return {
    c() {
      (e = _("div")),
        (t = _("select")),
        (l = _("option")),
        (r = C("Select Team"));
      for (let u = 0; u < c.length; u += 1) c[u].c();
      this.h();
    },
    l(u) {
      e = p(u, "DIV", { class: !0 });
      var h = d(e);
      t = p(h, "SELECT", { class: !0 });
      var v = d(t);
      l = p(v, "OPTION", {});
      var b = d(l);
      (r = T(b, "Select Team")), b.forEach(i);
      for (let E = 0; E < c.length; E += 1) c[E].l(v);
      v.forEach(i), h.forEach(i), this.h();
    },
    h() {
      (l.__value = 0),
        (l.value = l.__value),
        o(t, "class", "w-full p-2 rounded-md fpl-dropdown"),
        a[6] === void 0 && ul(() => a[19].call(t)),
        o(e, "class", "w-full border border-gray-500 my-4");
    },
    m(u, h) {
      X(u, e, h), s(e, t), s(t, l), s(l, r);
      for (let v = 0; v < c.length; v += 1) c[v] && c[v].m(t, null);
      Et(t, a[6], !0), n || ((m = ke(t, "change", a[19])), (n = !0));
    },
    p(u, h) {
      if (h[0] & 2048) {
        f = u[11];
        let v;
        for (v = 0; v < f.length; v += 1) {
          const b = Ga(u, f, v);
          c[v] ? c[v].p(b, h) : ((c[v] = Ua(b)), c[v].c(), c[v].m(t, null));
        }
        for (; v < c.length; v += 1) c[v].d(1);
        c.length = f.length;
      }
      h[0] & 2112 && Et(t, u[6]);
    },
    d(u) {
      u && i(e), It(c, u), (n = !1), m();
    },
  };
}
function Ua(a) {
  let e,
    t = a[28].name + "",
    l,
    r;
  return {
    c() {
      (e = _("option")), (l = C(t)), this.h();
    },
    l(n) {
      e = p(n, "OPTION", {});
      var m = d(e);
      (l = T(m, t)), m.forEach(i), this.h();
    },
    h() {
      (e.__value = r = a[28].id), (e.value = e.__value);
    },
    m(n, m) {
      X(n, e, m), s(e, l);
    },
    p(n, m) {
      m[0] & 2048 && t !== (t = n[28].name + "") && we(l, t),
        m[0] & 2048 &&
          r !== (r = n[28].id) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(n) {
      n && i(e);
    },
  };
}
function Hs(a) {
  let e,
    t = a[3] && Ba(a);
  return {
    c() {
      t && t.c(), (e = Yt());
    },
    l(l) {
      t && t.l(l), (e = Yt());
    },
    m(l, r) {
      t && t.m(l, r), X(l, e, r);
    },
    p(l, r) {
      l[3]
        ? t
          ? t.p(l, r)
          : ((t = Ba(l)), t.c(), t.m(e.parentNode, e))
        : t && (t.d(1), (t = null));
    },
    i: Ne,
    o: Ne,
    d(l) {
      t && t.d(l), l && i(e);
    },
  };
}
function Us(a, e, t) {
  let l,
    r,
    n,
    m,
    f = Ne,
    c = () => (f(), (f = al(g, (I) => t(20, (m = I)))), g),
    u,
    h = Ne,
    v = () => (h(), (h = al(y, (I) => t(21, (u = I)))), y),
    b,
    E = Ne,
    x = () => (E(), (E = al(w, (I) => t(22, (b = I)))), w);
  a.$$.on_destroy.push(() => f()),
    a.$$.on_destroy.push(() => h()),
    a.$$.on_destroy.push(() => E());
  let { fantasyTeam: g = it(null) } = e;
  c();
  let { players: y = it([]) } = e;
  v();
  let { teams: w = it([]) } = e;
  x();
  let { activeGameweek: V } = e,
    { showModal: k } = e,
    { closeBonusModal: G } = e,
    {
      bonus: D = {
        id: 0,
        name: "",
        description: "",
        image: "",
        selectionType: 0,
      },
    } = e,
    $,
    B = 0,
    H = 0,
    R = "";
  const ce = () => {
      if (!m || !m.playerIds) return [];
      const I = new Set(m.playerIds),
        W = u.filter((Q) => I.has(Q.id)).map((Q) => Q.nationality);
      return [...new Set(W)].sort();
    },
    S = () =>
      u
        .filter((I) => K(I.id))
        .map((I) => ({ id: I.id, name: `${I.firstName} ${I.lastName}` })),
    K = (I) => (m ? m.playerIds && m.playerIds.includes(I) : !1),
    O = () => {
      const I = new Set(u.filter((W) => K(W.id)).map((W) => W.teamId));
      return b
        .filter((W) => I.has(W.id))
        .map((W) => ({ id: W.id, name: W.friendlyName }));
    },
    ne = () => {
      if (!m || !m.playerIds) return 0;
      for (const I of m.playerIds) {
        const W = u.find((Q) => Q.id === I);
        if (W && W.position === 0) return W.id;
      }
      return 0;
    };
  function q() {
    if (m) {
      switch (D.id) {
        case 1:
          g.update(
            (I) =>
              I && {
                ...I,
                goalGetterPlayerId: H,
                goalGetterGameweek: V,
                playerIds: I.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 2:
          g.update(
            (I) =>
              I && {
                ...I,
                passMasterPlayerId: H,
                passMasterGameweek: V,
                playerIds: I.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 3:
          g.update(
            (I) =>
              I && {
                ...I,
                noEntryPlayerId: B,
                noEntryGameweek: V,
                playerIds: I.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 4:
          g.update(
            (I) =>
              I && {
                ...I,
                teamBoostTeamId: B,
                teamBoostGameweek: V,
                playerIds: I.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 5:
          g.update(
            (I) =>
              I && {
                ...I,
                safeHandsGameweek: V,
                safeHandsPlayerId: ne(),
                playerIds: I.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 6:
          g.update(
            (I) =>
              I && {
                ...I,
                captainFantasticPlayerId: m?.captainId ?? 0,
                captainFantasticGameweek: V,
                playerIds: I.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 7:
          break;
        case 8:
          break;
        case 9:
          g.update(
            (I) =>
              I && {
                ...I,
                braceBonusGameweek: V,
                playerIds: I.playerIds || new Uint16Array(11),
              }
          );
          break;
        case 10:
          g.update(
            (I) =>
              I && {
                ...I,
                hatTrickHeroGameweek: V,
                playerIds: I.playerIds || new Uint16Array(11),
              }
          );
          break;
      }
      G();
    }
  }
  function le(I) {
    !(I.target instanceof HTMLInputElement) && I.key === "Escape" && G();
  }
  function j(I) {
    zl.call(this, a, I);
  }
  function ae() {
    (H = fl(this)), t(7, H), t(12, l);
  }
  function M() {
    (R = fl(this)), t(8, R), t(9, $);
  }
  function L() {
    (B = fl(this)), t(6, B), t(11, r);
  }
  return (
    (a.$$set = (I) => {
      "fantasyTeam" in I && c(t(0, (g = I.fantasyTeam))),
        "players" in I && v(t(1, (y = I.players))),
        "teams" in I && x(t(2, (w = I.teams))),
        "activeGameweek" in I && t(15, (V = I.activeGameweek)),
        "showModal" in I && t(3, (k = I.showModal)),
        "closeBonusModal" in I && t(4, (G = I.closeBonusModal)),
        "bonus" in I && t(5, (D = I.bonus));
    }),
    (a.$$.update = () => {
      a.$$.dirty[0] & 480 &&
        t(
          10,
          (n = (() => {
            switch (D.selectionType) {
              case Qe.PLAYER:
                return H !== 0;
              case Qe.TEAM:
                return B !== 0;
              case Qe.COUNTRY:
                return R !== "";
              default:
                return !0;
            }
          })())
        );
    }),
    t(9, ($ = ce())),
    t(12, (l = S())),
    t(11, (r = O())),
    [g, y, w, k, G, D, B, H, R, $, n, r, l, q, le, V, j, ae, M, L]
  );
}
class js extends Ht {
  constructor(e) {
    super(),
      Ut(
        this,
        e,
        Us,
        Hs,
        jt,
        {
          fantasyTeam: 0,
          players: 1,
          teams: 2,
          activeGameweek: 15,
          showModal: 3,
          closeBonusModal: 4,
          bonus: 5,
        },
        null,
        [-1, -1]
      );
  }
}
function ja(a, e, t) {
  const l = a.slice();
  return (l[16] = e[t]), l;
}
function $a(a, e, t) {
  const l = a.slice();
  return (l[16] = e[t]), l;
}
function Ra(a) {
  let e, t;
  return (
    (e = new js({
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
        Se(e.$$.fragment);
      },
      l(l) {
        je(e.$$.fragment, l);
      },
      m(l, r) {
        Le(e, l, r), (t = !0);
      },
      p(l, r) {
        const n = {};
        r & 16 && (n.showModal = l[4]),
          r & 32 && (n.bonus = l[6][l[5] - 1]),
          r & 2 && (n.players = l[1]),
          r & 4 && (n.teams = l[2]),
          r & 1 && (n.fantasyTeam = l[0]),
          r & 8 && (n.activeGameweek = l[3]),
          e.$set(n);
      },
      i(l) {
        t || (te(e.$$.fragment, l), (t = !0));
      },
      o(l) {
        oe(e.$$.fragment, l), (t = !1);
      },
      d(l) {
        He(e, l);
      },
    }
  );
}
function $s(a) {
  let e, t, l;
  return {
    c() {
      (e = _("div")), (t = _("p")), (l = C("1 Per Week")), this.h();
    },
    l(r) {
      e = p(r, "DIV", { class: !0 });
      var n = d(e);
      t = p(n, "P", { class: !0 });
      var m = d(t);
      (l = T(m, "1 Per Week")), m.forEach(i), n.forEach(i), this.h();
    },
    h() {
      o(t, "class", "text-center text-xxs md:text-base xl:text-xs xl:mt-1"),
        o(e, "class", "w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]");
    },
    m(r, n) {
      X(r, e, n), s(e, t), s(t, l);
    },
    p: Ne,
    d(r) {
      r && i(e);
    },
  };
}
function Rs(a) {
  let e, t, l, r, n;
  function m() {
    return a[13](a[16]);
  }
  return {
    c() {
      (e = _("div")), (t = _("button")), (l = C("Use")), this.h();
    },
    l(f) {
      e = p(f, "DIV", { class: !0 });
      var c = d(e);
      t = p(c, "BUTTON", { class: !0 });
      var u = d(t);
      (l = T(u, "Use")), u.forEach(i), c.forEach(i), this.h();
    },
    h() {
      o(
        t,
        "class",
        "fpl-purple-btn rounded-md w-full text-xs py-1 min-h-[30px] md:text-base"
      ),
        o(e, "class", "w-full px-1 sm:px-4 mb-2 sm:mb-4");
    },
    m(f, c) {
      X(f, e, c), s(e, t), s(t, l), r || ((n = ke(t, "click", m)), (r = !0));
    },
    p(f, c) {
      a = f;
    },
    d(f) {
      f && i(e), (r = !1), n();
    },
  };
}
function Ys(a) {
  let e,
    t,
    l,
    r = a[11](a[16].id) + "",
    n;
  return {
    c() {
      (e = _("div")), (t = _("p")), (l = C("Used GW")), (n = C(r)), this.h();
    },
    l(m) {
      e = p(m, "DIV", { class: !0 });
      var f = d(e);
      t = p(f, "P", { class: !0 });
      var c = d(t);
      (l = T(c, "Used GW")),
        (n = T(c, r)),
        c.forEach(i),
        f.forEach(i),
        this.h();
    },
    h() {
      o(t, "class", "text-center text-xxs md:text-base xl:text-xs xl:mt-1"),
        o(e, "class", "w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]");
    },
    m(m, f) {
      X(m, e, f), s(e, t), s(t, l), s(t, n);
    },
    p: Ne,
    d(m) {
      m && i(e);
    },
  };
}
function Ya(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c = a[16].name + "",
    u,
    h,
    v;
  function b(g, y) {
    return g[11](g[16].id) ? Ys : g[12]() ? $s : Rs;
  }
  let x = b(a)(a);
  return {
    c() {
      (e = _("div")),
        (t = _("div")),
        (l = _("img")),
        (n = P()),
        (m = _("div")),
        (f = _("p")),
        (u = C(c)),
        (h = P()),
        x.c(),
        (v = P()),
        this.h();
    },
    l(g) {
      e = p(g, "DIV", { class: !0 });
      var y = d(e);
      t = p(y, "DIV", { class: !0 });
      var w = d(t);
      (l = p(w, "IMG", { alt: !0, src: !0, class: !0 })),
        (n = N(w)),
        (m = p(w, "DIV", { class: !0 }));
      var V = d(m);
      f = p(V, "P", { class: !0 });
      var k = d(f);
      (u = T(k, c)),
        k.forEach(i),
        V.forEach(i),
        (h = N(w)),
        x.l(w),
        w.forEach(i),
        (v = N(y)),
        y.forEach(i),
        this.h();
    },
    h() {
      o(l, "alt", a[16].name),
        cl(l.src, (r = a[16].image)) || o(l, "src", r),
        o(l, "class", "h-12 m-2 mt-4 md:h-24 xl:h-20"),
        o(
          f,
          "class",
          "text-center text-xxs sm:text-xs md:text-base font-bold xl:text-sm xl:min-h-[40px]"
        ),
        o(
          m,
          "class",
          "mt-1 mb-1 lg:p-2 p-1 lg:px-4 rounded-md min-h-[40px] flex items-center"
        ),
        o(
          t,
          "class",
          Is("flex flex-col justify-center items-center flex-1") +
            " svelte-fqxxu5"
        ),
        o(
          e,
          "class",
          "flex items-center w-1/5 bonus-panel-inner m-1 mt-2 rounded-lg border border-gray-700 svelte-fqxxu5"
        );
    },
    m(g, y) {
      X(g, e, y),
        s(e, t),
        s(t, l),
        s(t, n),
        s(t, m),
        s(m, f),
        s(f, u),
        s(t, h),
        x.m(t, null),
        s(e, v);
    },
    p(g, y) {
      x.p(g, y);
    },
    d(g) {
      g && i(e), x.d();
    },
  };
}
function Ws(a) {
  let e, t, l;
  return {
    c() {
      (e = _("div")), (t = _("p")), (l = C("1 Per Week")), this.h();
    },
    l(r) {
      e = p(r, "DIV", { class: !0 });
      var n = d(e);
      t = p(n, "P", { class: !0 });
      var m = d(t);
      (l = T(m, "1 Per Week")), m.forEach(i), n.forEach(i), this.h();
    },
    h() {
      o(t, "class", "text-center text-xxs md:text-base xl:text-xs xl:mt-1"),
        o(e, "class", "w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]");
    },
    m(r, n) {
      X(r, e, n), s(e, t), s(t, l);
    },
    p: Ne,
    d(r) {
      r && i(e);
    },
  };
}
function Zs(a) {
  let e, t, l, r, n;
  function m() {
    return a[14](a[16]);
  }
  return {
    c() {
      (e = _("div")), (t = _("button")), (l = C("Use")), this.h();
    },
    l(f) {
      e = p(f, "DIV", { class: !0 });
      var c = d(e);
      t = p(c, "BUTTON", { class: !0 });
      var u = d(t);
      (l = T(u, "Use")), u.forEach(i), c.forEach(i), this.h();
    },
    h() {
      o(
        t,
        "class",
        "fpl-purple-btn rounded-md w-full text-xs py-1 min-h-[30px] md:text-base"
      ),
        o(e, "class", "w-full px-1 sm:px-4 mb-2 sm:mb-4");
    },
    m(f, c) {
      X(f, e, c), s(e, t), s(t, l), r || ((n = ke(t, "click", m)), (r = !0));
    },
    p(f, c) {
      a = f;
    },
    d(f) {
      f && i(e), (r = !1), n();
    },
  };
}
function qs(a) {
  let e, t, l;
  return {
    c() {
      (e = _("div")), (t = _("p")), (l = C("Coming Soon")), this.h();
    },
    l(r) {
      e = p(r, "DIV", { class: !0 });
      var n = d(e);
      t = p(n, "P", { class: !0 });
      var m = d(t);
      (l = T(m, "Coming Soon")), m.forEach(i), n.forEach(i), this.h();
    },
    h() {
      o(t, "class", "text-center text-xxs md:text-base xl:text-xs xl:mt-1"),
        o(e, "class", "w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]");
    },
    m(r, n) {
      X(r, e, n), s(e, t), s(t, l);
    },
    p: Ne,
    d(r) {
      r && i(e);
    },
  };
}
function Xs(a) {
  let e,
    t,
    l,
    r = a[11](a[16].id) + "",
    n;
  return {
    c() {
      (e = _("div")), (t = _("p")), (l = C("Used GW")), (n = C(r)), this.h();
    },
    l(m) {
      e = p(m, "DIV", { class: !0 });
      var f = d(e);
      t = p(f, "P", { class: !0 });
      var c = d(t);
      (l = T(c, "Used GW")),
        (n = T(c, r)),
        c.forEach(i),
        f.forEach(i),
        this.h();
    },
    h() {
      o(t, "class", "text-center text-xxs md:text-base xl:text-xs xl:mt-1"),
        o(e, "class", "w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]");
    },
    m(m, f) {
      X(m, e, f), s(e, t), s(t, l), s(t, n);
    },
    p: Ne,
    d(m) {
      m && i(e);
    },
  };
}
function Wa(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c = a[16].name + "",
    u,
    h,
    v;
  function b(g, y) {
    return g[11](g[16].id)
      ? Xs
      : g[16].id == 7 || g[16].id == 8
      ? qs
      : g[12]()
      ? Ws
      : Zs;
  }
  let x = b(a)(a);
  return {
    c() {
      (e = _("div")),
        (t = _("div")),
        (l = _("img")),
        (n = P()),
        (m = _("div")),
        (f = _("p")),
        (u = C(c)),
        (h = P()),
        x.c(),
        (v = P()),
        this.h();
    },
    l(g) {
      e = p(g, "DIV", { class: !0 });
      var y = d(e);
      t = p(y, "DIV", { class: !0 });
      var w = d(t);
      (l = p(w, "IMG", { alt: !0, src: !0, class: !0 })),
        (n = N(w)),
        (m = p(w, "DIV", { class: !0 }));
      var V = d(m);
      f = p(V, "P", { class: !0 });
      var k = d(f);
      (u = T(k, c)),
        k.forEach(i),
        V.forEach(i),
        (h = N(w)),
        x.l(w),
        w.forEach(i),
        (v = N(y)),
        y.forEach(i),
        this.h();
    },
    h() {
      o(l, "alt", a[16].name),
        cl(l.src, (r = a[16].image)) || o(l, "src", r),
        o(l, "class", "h-12 m-2 mt-4 md:h-24 xl:h-20"),
        o(
          f,
          "class",
          "text-center text-xxs sm:text-xs md:text-base font-bold xl:text-sm xl:min-h-[40px]"
        ),
        o(
          m,
          "class",
          "mt-1 mb-1 lg:p-2 p-1 lg:px-4 rounded-md min-h-[40px] flex items-center"
        ),
        o(
          t,
          "class",
          Is("flex flex-col justify-center items-center flex-1") +
            " svelte-fqxxu5"
        ),
        o(
          e,
          "class",
          "flex items-center w-1/5 bonus-panel-inner m-1 rounded-lg border border-gray-700 svelte-fqxxu5"
        );
    },
    m(g, y) {
      X(g, e, y),
        s(e, t),
        s(t, l),
        s(t, n),
        s(t, m),
        s(m, f),
        s(f, u),
        s(t, h),
        x.m(t, null),
        s(e, v);
    },
    p(g, y) {
      x.p(g, y);
    },
    d(g) {
      g && i(e), x.d();
    },
  };
}
function Ks(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c,
    u,
    h,
    v,
    b = a[5] > 0 && Ra(a),
    E = a[7],
    x = [];
  for (let w = 0; w < E.length; w += 1) x[w] = Ya($a(a, E, w));
  let g = a[8],
    y = [];
  for (let w = 0; w < g.length; w += 1) y[w] = Wa(ja(a, g, w));
  return {
    c() {
      (e = _("div")),
        b && b.c(),
        (t = P()),
        (l = _("div")),
        (r = _("h1")),
        (n = C("Bonuses")),
        (m = P()),
        (f = _("div")),
        (c = _("div"));
      for (let w = 0; w < x.length; w += 1) x[w].c();
      (u = P()), (h = _("div"));
      for (let w = 0; w < y.length; w += 1) y[w].c();
      this.h();
    },
    l(w) {
      e = p(w, "DIV", { class: !0 });
      var V = d(e);
      b && b.l(V), (t = N(V)), (l = p(V, "DIV", { class: !0 }));
      var k = d(l);
      r = p(k, "H1", { class: !0 });
      var G = d(r);
      (n = T(G, "Bonuses")),
        G.forEach(i),
        k.forEach(i),
        (m = N(V)),
        (f = p(V, "DIV", { class: !0 }));
      var D = d(f);
      c = p(D, "DIV", { class: !0 });
      var $ = d(c);
      for (let H = 0; H < x.length; H += 1) x[H].l($);
      $.forEach(i), (u = N(D)), (h = p(D, "DIV", { class: !0 }));
      var B = d(h);
      for (let H = 0; H < y.length; H += 1) y[H].l(B);
      B.forEach(i), D.forEach(i), V.forEach(i), this.h();
    },
    h() {
      o(r, "class", "m-3 md:m-4 font-bold"),
        o(
          l,
          "class",
          "flex flex-col md:flex-row bonus-panel-inner svelte-fqxxu5"
        ),
        o(c, "class", "flex items-center w-100 xl:w-1/2"),
        o(h, "class", "flex items-center w-100 xl:w-1/2"),
        o(f, "class", "flex flex-col xl:flex-row md:mx-2"),
        o(
          e,
          "class",
          "bonus-panel rounded-md mx-4 flex-1 mb-2 lg:mb-0 svelte-fqxxu5"
        );
    },
    m(w, V) {
      X(w, e, V),
        b && b.m(e, null),
        s(e, t),
        s(e, l),
        s(l, r),
        s(r, n),
        s(e, m),
        s(e, f),
        s(f, c);
      for (let k = 0; k < x.length; k += 1) x[k] && x[k].m(c, null);
      s(f, u), s(f, h);
      for (let k = 0; k < y.length; k += 1) y[k] && y[k].m(h, null);
      v = !0;
    },
    p(w, [V]) {
      if (
        (w[5] > 0
          ? b
            ? (b.p(w, V), V & 32 && te(b, 1))
            : ((b = Ra(w)), b.c(), te(b, 1), b.m(e, t))
          : b &&
            (rt(),
            oe(b, 1, 1, () => {
              b = null;
            }),
            nt()),
        V & 6784)
      ) {
        E = w[7];
        let k;
        for (k = 0; k < E.length; k += 1) {
          const G = $a(w, E, k);
          x[k] ? x[k].p(G, V) : ((x[k] = Ya(G)), x[k].c(), x[k].m(c, null));
        }
        for (; k < x.length; k += 1) x[k].d(1);
        x.length = E.length;
      }
      if (V & 6912) {
        g = w[8];
        let k;
        for (k = 0; k < g.length; k += 1) {
          const G = ja(w, g, k);
          y[k] ? y[k].p(G, V) : ((y[k] = Wa(G)), y[k].c(), y[k].m(h, null));
        }
        for (; k < y.length; k += 1) y[k].d(1);
        y.length = g.length;
      }
    },
    i(w) {
      v || (te(b), (v = !0));
    },
    o(w) {
      oe(b), (v = !1);
    },
    d(w) {
      w && i(e), b && b.d(), It(x, w), It(y, w);
    },
  };
}
function zs(a, e, t) {
  let l,
    r = Ne,
    n = () => (r(), (r = al(m, (D) => t(15, (l = D)))), m);
  a.$$.on_destroy.push(() => r());
  let { fantasyTeam: m = it(null) } = e;
  n();
  let { players: f = it([]) } = e,
    { teams: c = it([]) } = e,
    { activeGameweek: u } = e,
    h = !1,
    v = 0,
    b = [
      {
        id: 1,
        name: "Goal Getter",
        image: "goal-getter.png",
        description:
          "Select a player you think will score in a game to receive a X3 mulitplier for each goal scored.",
        selectionType: Qe.PLAYER,
      },
      {
        id: 2,
        name: "Pass Master",
        image: "pass-master.png",
        description:
          "Select a player you think will assist in a game to receive a X3 mulitplier for each assist.",
        selectionType: Qe.PLAYER,
      },
      {
        id: 3,
        name: "No Entry",
        image: "no-entry.png",
        description:
          "Select a goalkeeper or defender you think will keep a clean sheet to receive a X3 multipler on their total score.",
        selectionType: Qe.PLAYER,
      },
      {
        id: 4,
        name: "Team Boost",
        image: "team-boost.png",
        description:
          "Receive a X2 multiplier from all players from a single club that are in your team.",
        selectionType: Qe.TEAM,
      },
      {
        id: 5,
        name: "Safe Hands",
        image: "safe-hands.png",
        description:
          "Receive a X3 multiplier on your goalkeeper if they make 5 saves in a match.",
        selectionType: Qe.AUTOMATIC,
      },
      {
        id: 6,
        name: "Captain Fantastic",
        image: "captain-fantastic.png",
        description:
          "Receive a X2 multiplier on your team captain's score if they score a goal in a match.",
        selectionType: Qe.AUTOMATIC,
      },
      {
        id: 7,
        name: "Prospects",
        image: "prospects.png",
        description: "Receive a X2 multiplier for players under the age of 21.",
        selectionType: Qe.AUTOMATIC,
      },
      {
        id: 8,
        name: "Countrymen",
        image: "countrymen.png",
        description:
          "Receive a X2 multiplier for players of a selected nationality.",
        selectionType: Qe.COUNTRY,
      },
      {
        id: 9,
        name: "Brace Bonus",
        image: "brace-bonus.png",
        description:
          "Receive a X2 multiplier on a player's score if they score 2 or more goals in a game. Applies to every player who scores a brace.",
        selectionType: Qe.AUTOMATIC,
      },
      {
        id: 10,
        name: "Hat-Trick Hero",
        image: "hat-trick-hero.png",
        description:
          "Receive a X3 multiplier on a player's score if they score 3 or more goals in a game. Applies to every player who scores a hat-trick.",
        selectionType: Qe.AUTOMATIC,
      },
    ],
    E = b.slice(0, 5),
    x = b.slice(5, 10);
  function g(D) {
    t(5, (v = D)), t(4, (h = !0));
  }
  function y() {
    t(4, (h = !1));
  }
  function w(D) {
    if (!l) return !1;
    switch (D) {
      case 1:
        return l.goalGetterGameweek && l.goalGetterGameweek > 0
          ? l.goalGetterGameweek
          : !1;
      case 2:
        return l.passMasterGameweek && l.passMasterGameweek > 0
          ? l.passMasterGameweek
          : !1;
      case 3:
        return l.noEntryGameweek && l.noEntryGameweek > 0
          ? l.noEntryGameweek
          : !1;
      case 4:
        return l.teamBoostGameweek && l.teamBoostGameweek > 0
          ? l.teamBoostGameweek
          : !1;
      case 5:
        return l.safeHandsGameweek && l.safeHandsGameweek > 0
          ? l.safeHandsGameweek
          : !1;
      case 6:
        return l.captainFantasticGameweek && l.captainFantasticGameweek > 0
          ? l.captainFantasticGameweek
          : !1;
      case 7:
        return !1;
      case 8:
        return !1;
      case 9:
        return l.braceBonusGameweek && l.braceBonusGameweek > 0
          ? l.braceBonusGameweek
          : !1;
      case 10:
        return l.hatTrickHeroGameweek && l.hatTrickHeroGameweek > 0
          ? l.hatTrickHeroGameweek
          : !1;
      default:
        return !1;
    }
  }
  function V() {
    return l
      ? l?.goalGetterGameweek == u ||
          l?.passMasterGameweek == u ||
          l?.noEntryGameweek == u ||
          l?.teamBoostGameweek == u ||
          l?.safeHandsGameweek == u ||
          l?.captainFantasticGameweek == u ||
          l?.braceBonusGameweek == u ||
          l?.hatTrickHeroGameweek == u
      : !1;
  }
  const k = (D) => g(D.id),
    G = (D) => g(D.id);
  return (
    (a.$$set = (D) => {
      "fantasyTeam" in D && n(t(0, (m = D.fantasyTeam))),
        "players" in D && t(1, (f = D.players)),
        "teams" in D && t(2, (c = D.teams)),
        "activeGameweek" in D && t(3, (u = D.activeGameweek));
    }),
    [m, f, c, u, h, v, b, E, x, g, y, w, V, k, G]
  );
}
class Js extends Ht {
  constructor(e) {
    super(),
      Ut(this, e, zs, Ks, jt, {
        fantasyTeam: 0,
        players: 1,
        teams: 2,
        activeGameweek: 3,
      });
  }
}
function Qs(a) {
  let e, t;
  return {
    c() {
      (e = pe("svg")), (t = pe("path")), this.h();
    },
    l(l) {
      e = ve(l, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var r = d(e);
      (t = ve(r, "path", { d: !0, fill: !0 })),
        d(t).forEach(i),
        r.forEach(i),
        this.h();
    },
    h() {
      o(
        t,
        "d",
        "M16 6.66667H9.33333V0H6.66667V6.66667H0V9.33333H6.66667V16H9.33333V9.33333H16V6.66667Z"
      ),
        o(t, "fill", "#FFFFFF"),
        o(e, "xmlns", "http://www.w3.org/2000/svg"),
        o(e, "class", a[0]),
        o(e, "fill", "currentColor"),
        o(e, "viewBox", "0 0 16 16");
    },
    m(l, r) {
      X(l, e, r), s(e, t);
    },
    p(l, [r]) {
      r & 1 && o(e, "class", l[0]);
    },
    i: Ne,
    o: Ne,
    d(l) {
      l && i(e);
    },
  };
}
function er(a, e, t) {
  let { className: l = "" } = e;
  return (
    (a.$$set = (r) => {
      "className" in r && t(0, (l = r.className));
    }),
    [l]
  );
}
class Ps extends Ht {
  constructor(e) {
    super(), Ut(this, e, er, Qs, jt, { className: 0 });
  }
}
function Za(a, e, t) {
  const l = a.slice();
  return (l[39] = e[t]), (l[41] = t), l;
}
function qa(a, e, t) {
  const l = a.slice();
  return (l[42] = e[t]), (l[41] = t), l;
}
function Xa(a, e, t) {
  const l = a.slice();
  return (l[44] = e[t]), l;
}
function Ka(a) {
  let e, t, l, r;
  const n = [lr, tr],
    m = [];
  function f(c, u) {
    return c[14] ? 0 : 1;
  }
  return (
    (e = f(a)),
    (t = m[e] = n[e](a)),
    {
      c() {
        t.c(), (l = Yt());
      },
      l(c) {
        t.l(c), (l = Yt());
      },
      m(c, u) {
        m[e].m(c, u), X(c, l, u), (r = !0);
      },
      p(c, u) {
        let h = e;
        (e = f(c)),
          e === h
            ? m[e].p(c, u)
            : (rt(),
              oe(m[h], 1, 1, () => {
                m[h] = null;
              }),
              nt(),
              (t = m[e]),
              t ? t.p(c, u) : ((t = m[e] = n[e](c)), t.c()),
              te(t, 1),
              t.m(l.parentNode, l));
      },
      i(c) {
        r || (te(t), (r = !0));
      },
      o(c) {
        oe(t), (r = !1);
      },
      d(c) {
        m[e].d(c), c && i(l);
      },
    }
  );
}
function tr(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c,
    u,
    h,
    v,
    b,
    E,
    x,
    g,
    y,
    w,
    V,
    k,
    G,
    D,
    $,
    B,
    H,
    R,
    ce,
    S,
    K,
    O,
    ne,
    q,
    le,
    j,
    ae,
    M,
    L,
    I,
    W,
    Q,
    _e,
    se,
    Ce,
    Y,
    U,
    ee,
    Ee,
    he,
    Be,
    me,
    F,
    be,
    ge,
    Ie,
    De,
    Ve,
    Te,
    We,
    $e = (a[17] / 4).toFixed(2) + "",
    Fe,
    Ze,
    et,
    tt,
    Ue,
    bt,
    Gt,
    Ct,
    gt,
    At,
    Tt,
    Nt,
    ct,
    A,
    Z,
    ie,
    re,
    fe,
    ue,
    xe,
    Ge,
    at,
    Xe,
    lt,
    Oe,
    qe,
    ft,
    Re,
    ut,
    sl,
    Wt,
    $t,
    el,
    Mt = a[16],
    Ke = [];
  for (let de = 0; de < Mt.length; de += 1) Ke[de] = za(Xa(a, Mt, de));
  let yt = a[13],
    Ae = [];
  for (let de = 0; de < yt.length; de += 1) Ae[de] = ls(qa(a, yt, de));
  const Pl = (de) =>
    oe(Ae[de], 1, 1, () => {
      Ae[de] = null;
    });
  let Vt = Array(Math.ceil(a[12].length / Yl)),
    Me = [];
  for (let de = 0; de < Vt.length; de += 1) Me[de] = as(Za(a, Vt, de));
  return {
    c() {
      (e = _("div")),
        (t = _("div")),
        (l = _("div")),
        (r = _("h3")),
        (n = C("Select Player")),
        (m = P()),
        (f = _("button")),
        (c = C("×")),
        (u = P()),
        (h = _("div")),
        (v = _("div")),
        (b = _("div")),
        (E = _("label")),
        (x = C("Filter by Team:")),
        (g = P()),
        (y = _("select")),
        (w = _("option")),
        (V = C("All"));
      for (let de = 0; de < Ke.length; de += 1) Ke[de].c();
      (k = P()),
        (G = _("div")),
        (D = _("label")),
        ($ = C("Filter by Position:")),
        (B = P()),
        (H = _("select")),
        (R = _("option")),
        (ce = C("All")),
        (S = _("option")),
        (K = C("Goalkeepers")),
        (O = _("option")),
        (ne = C("Defenders")),
        (q = _("option")),
        (le = C("Midfielders")),
        (j = _("option")),
        (ae = C("Forwards")),
        (M = P()),
        (L = _("div")),
        (I = _("div")),
        (W = _("label")),
        (Q = C("Min Value:")),
        (_e = P()),
        (se = _("input")),
        (Ce = P()),
        (Y = _("div")),
        (U = _("label")),
        (ee = C("Max Value:")),
        (Ee = P()),
        (he = _("input")),
        (Be = P()),
        (me = _("div")),
        (F = _("label")),
        (be = C("Search by Name:")),
        (ge = P()),
        (Ie = _("input")),
        (De = P()),
        (Ve = _("div")),
        (Te = _("label")),
        (We = C("Available Balance: £")),
        (Fe = C($e)),
        (Ze = C("m")),
        (et = P()),
        (tt = _("div")),
        (Ue = _("div")),
        (bt = _("div")),
        (Gt = C("Pos")),
        (Ct = P()),
        (gt = _("div")),
        (At = C("Player")),
        (Tt = P()),
        (Nt = _("div")),
        (ct = C("Team")),
        (A = P()),
        (Z = _("div")),
        (ie = C("Value")),
        (re = P()),
        (fe = _("div")),
        (ue = C("PTS")),
        (xe = P()),
        (Ge = _("div")),
        (at = C(" ")),
        (Xe = P());
      for (let de = 0; de < Ae.length; de += 1) Ae[de].c();
      (lt = P()), (Oe = _("div")), (qe = _("div"));
      for (let de = 0; de < Me.length; de += 1) Me[de].c();
      (ft = P()),
        (Re = _("div")),
        (ut = _("button")),
        (sl = C("Close")),
        this.h();
    },
    l(de) {
      e = p(de, "DIV", { class: !0 });
      var Pe = d(e);
      t = p(Pe, "DIV", { class: !0 });
      var J = d(t);
      l = p(J, "DIV", { class: !0 });
      var st = d(l);
      r = p(st, "H3", { class: !0 });
      var dl = d(r);
      (n = T(dl, "Select Player")),
        dl.forEach(i),
        (m = N(st)),
        (f = p(st, "BUTTON", { class: !0 }));
      var Bt = d(f);
      (c = T(Bt, "×")),
        Bt.forEach(i),
        st.forEach(i),
        (u = N(J)),
        (h = p(J, "DIV", { class: !0 }));
      var Dt = d(h);
      v = p(Dt, "DIV", { class: !0 });
      var Zt = d(v);
      b = p(Zt, "DIV", {});
      var tl = d(b);
      E = p(tl, "LABEL", { for: !0, class: !0 });
      var qt = d(E);
      (x = T(qt, "Filter by Team:")),
        qt.forEach(i),
        (g = N(tl)),
        (y = p(tl, "SELECT", { id: !0, class: !0 }));
      var Ft = d(y);
      w = p(Ft, "OPTION", {});
      var ml = d(w);
      (V = T(ml, "All")), ml.forEach(i);
      for (let z = 0; z < Ke.length; z += 1) Ke[z].l(Ft);
      Ft.forEach(i), tl.forEach(i), (k = N(Zt)), (G = p(Zt, "DIV", {}));
      var dt = d(G);
      D = p(dt, "LABEL", { for: !0, class: !0 });
      var hl = d(D);
      ($ = T(hl, "Filter by Position:")),
        hl.forEach(i),
        (B = N(dt)),
        (H = p(dt, "SELECT", { id: !0, class: !0 }));
      var mt = d(H);
      R = p(mt, "OPTION", {});
      var Pt = d(R);
      (ce = T(Pt, "All")), Pt.forEach(i), (S = p(mt, "OPTION", {}));
      var _l = d(S);
      (K = T(_l, "Goalkeepers")), _l.forEach(i), (O = p(mt, "OPTION", {}));
      var rl = d(O);
      (ne = T(rl, "Defenders")), rl.forEach(i), (q = p(mt, "OPTION", {}));
      var nl = d(q);
      (le = T(nl, "Midfielders")), nl.forEach(i), (j = p(mt, "OPTION", {}));
      var pl = d(j);
      (ae = T(pl, "Forwards")),
        pl.forEach(i),
        mt.forEach(i),
        dt.forEach(i),
        Zt.forEach(i),
        (M = N(Dt)),
        (L = p(Dt, "DIV", { class: !0 }));
      var ht = d(L);
      I = p(ht, "DIV", {});
      var ll = d(I);
      W = p(ll, "LABEL", { for: !0, class: !0 });
      var ol = d(W);
      (Q = T(ol, "Min Value:")),
        ol.forEach(i),
        (_e = N(ll)),
        (se = p(ll, "INPUT", { id: !0, type: !0, class: !0 })),
        ll.forEach(i),
        (Ce = N(ht)),
        (Y = p(ht, "DIV", {}));
      var Xt = d(Y);
      U = p(Xt, "LABEL", { for: !0, class: !0 });
      var vl = d(U);
      (ee = T(vl, "Max Value:")),
        vl.forEach(i),
        (Ee = N(Xt)),
        (he = p(Xt, "INPUT", { id: !0, type: !0, class: !0 })),
        Xt.forEach(i),
        ht.forEach(i),
        (Be = N(Dt)),
        (me = p(Dt, "DIV", { class: !0 }));
      var wt = d(me);
      F = p(wt, "LABEL", { for: !0, class: !0 });
      var _t = d(F);
      (be = T(_t, "Search by Name:")),
        _t.forEach(i),
        (ge = N(wt)),
        (Ie = p(wt, "INPUT", { id: !0, type: !0, class: !0, placeholder: !0 })),
        wt.forEach(i),
        (De = N(Dt)),
        (Ve = p(Dt, "DIV", { class: !0 }));
      var pt = d(Ve);
      Te = p(pt, "LABEL", { for: !0, class: !0 });
      var Kt = d(Te);
      (We = T(Kt, "Available Balance: £")),
        (Fe = T(Kt, $e)),
        (Ze = T(Kt, "m")),
        Kt.forEach(i),
        pt.forEach(i),
        Dt.forEach(i),
        (et = N(J)),
        (tt = p(J, "DIV", { class: !0 }));
      var Ot = d(tt);
      Ue = p(Ot, "DIV", { class: !0 });
      var ze = d(Ue);
      bt = p(ze, "DIV", { class: !0 });
      var bl = d(bt);
      (Gt = T(bl, "Pos")),
        bl.forEach(i),
        (Ct = N(ze)),
        (gt = p(ze, "DIV", { class: !0 }));
      var St = d(gt);
      (At = T(St, "Player")),
        St.forEach(i),
        (Tt = N(ze)),
        (Nt = p(ze, "DIV", { class: !0 }));
      var Ye = d(Nt);
      (ct = T(Ye, "Team")),
        Ye.forEach(i),
        (A = N(ze)),
        (Z = p(ze, "DIV", { class: !0 }));
      var gl = d(Z);
      (ie = T(gl, "Value")),
        gl.forEach(i),
        (re = N(ze)),
        (fe = p(ze, "DIV", { class: !0 }));
      var Nl = d(fe);
      (ue = T(Nl, "PTS")),
        Nl.forEach(i),
        (xe = N(ze)),
        (Ge = p(ze, "DIV", { class: !0 }));
      var zt = d(Ge);
      (at = T(zt, " ")), zt.forEach(i), ze.forEach(i), (Xe = N(Ot));
      for (let z = 0; z < Ae.length; z += 1) Ae[z].l(Ot);
      Ot.forEach(i), (lt = N(J)), (Oe = p(J, "DIV", { class: !0 }));
      var Je = d(Oe);
      qe = p(Je, "DIV", { class: !0 });
      var Dl = d(qe);
      for (let z = 0; z < Me.length; z += 1) Me[z].l(Dl);
      Dl.forEach(i),
        Je.forEach(i),
        (ft = N(J)),
        (Re = p(J, "DIV", { class: !0 }));
      var Lt = d(Re);
      ut = p(Lt, "BUTTON", { class: !0 });
      var Gl = d(ut);
      (sl = T(Gl, "Close")),
        Gl.forEach(i),
        Lt.forEach(i),
        J.forEach(i),
        Pe.forEach(i),
        this.h();
    },
    h() {
      o(r, "class", "text-xl font-semibold"),
        o(f, "class", "text-3xl leading-none"),
        o(l, "class", "flex justify-between items-center mb-4"),
        o(E, "for", "filterTeam"),
        o(E, "class", "text-sm"),
        (w.__value = -1),
        (w.value = w.__value),
        o(y, "id", "filterTeam"),
        o(
          y,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        a[7] === void 0 && ul(() => a[26].call(y)),
        o(D, "for", "filterPosition"),
        o(D, "class", "text-sm"),
        (R.__value = -1),
        (R.value = R.__value),
        (S.__value = 0),
        (S.value = S.__value),
        (O.__value = 1),
        (O.value = O.__value),
        (q.__value = 2),
        (q.value = q.__value),
        (j.__value = 3),
        (j.value = j.__value),
        o(H, "id", "filterPosition"),
        o(
          H,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        a[0] === void 0 && ul(() => a[27].call(H)),
        o(v, "class", "grid grid-cols-1 md:grid-cols-2 gap-4 mb-4"),
        o(W, "for", "minValue"),
        o(W, "class", "text-sm"),
        o(se, "id", "minValue"),
        o(se, "type", "number"),
        o(
          se,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        o(U, "for", "maxValue"),
        o(U, "class", "text-sm"),
        o(he, "id", "maxValue"),
        o(he, "type", "number"),
        o(
          he,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        o(L, "class", "grid grid-cols-1 md:grid-cols-2 gap-4 mb-4"),
        o(F, "for", "filterSurname"),
        o(F, "class", "text-sm"),
        o(Ie, "id", "filterSurname"),
        o(Ie, "type", "text"),
        o(
          Ie,
          "class",
          "mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
        ),
        o(Ie, "placeholder", "Enter"),
        o(me, "class", "mb-4"),
        o(Te, "for", "bankBalance"),
        o(Te, "class", "font-bold"),
        o(Ve, "class", "mb-4"),
        o(h, "class", "mb-4"),
        o(bt, "class", "w-1/12 text-center mx-4"),
        o(gt, "class", "w-4/12"),
        o(Nt, "class", "w-2/12"),
        o(Z, "class", "w-2/12"),
        o(fe, "class", "w-1/12"),
        o(Ge, "class", "w-2/12 text-center"),
        o(
          Ue,
          "class",
          "flex justify-between border border-gray-700 py-4 bg-light-gray"
        ),
        o(tt, "class", "overflow-x-auto flex-1 text-xs md:text-base"),
        o(qe, "class", "flex space-x-1 min-w-max"),
        o(Oe, "class", "justify-center mt-4 pb-4 overflow-x-auto"),
        o(ut, "class", "px-4 py-2 fpl-purple-btn rounded-md text-white"),
        o(Re, "class", "flex justify-end mt-4"),
        o(
          t,
          "class",
          "relative top-10 md:top-20 mx-auto p-5 border w-full max-w-4xl shadow-lg rounded-md bg-panel text-white"
        ),
        o(
          e,
          "class",
          "fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
        );
    },
    m(de, Pe) {
      X(de, e, Pe),
        s(e, t),
        s(t, l),
        s(l, r),
        s(r, n),
        s(l, m),
        s(l, f),
        s(f, c),
        s(t, u),
        s(t, h),
        s(h, v),
        s(v, b),
        s(b, E),
        s(E, x),
        s(b, g),
        s(b, y),
        s(y, w),
        s(w, V);
      for (let J = 0; J < Ke.length; J += 1) Ke[J] && Ke[J].m(y, null);
      Et(y, a[7], !0),
        s(v, k),
        s(v, G),
        s(G, D),
        s(D, $),
        s(G, B),
        s(G, H),
        s(H, R),
        s(R, ce),
        s(H, S),
        s(S, K),
        s(H, O),
        s(O, ne),
        s(H, q),
        s(q, le),
        s(H, j),
        s(j, ae),
        Et(H, a[0], !0),
        s(h, M),
        s(h, L),
        s(L, I),
        s(I, W),
        s(W, Q),
        s(I, _e),
        s(I, se),
        Cl(se, a[9]),
        s(L, Ce),
        s(L, Y),
        s(Y, U),
        s(U, ee),
        s(Y, Ee),
        s(Y, he),
        Cl(he, a[10]),
        s(h, Be),
        s(h, me),
        s(me, F),
        s(F, be),
        s(me, ge),
        s(me, Ie),
        Cl(Ie, a[8]),
        s(h, De),
        s(h, Ve),
        s(Ve, Te),
        s(Te, We),
        s(Te, Fe),
        s(Te, Ze),
        s(t, et),
        s(t, tt),
        s(tt, Ue),
        s(Ue, bt),
        s(bt, Gt),
        s(Ue, Ct),
        s(Ue, gt),
        s(gt, At),
        s(Ue, Tt),
        s(Ue, Nt),
        s(Nt, ct),
        s(Ue, A),
        s(Ue, Z),
        s(Z, ie),
        s(Ue, re),
        s(Ue, fe),
        s(fe, ue),
        s(Ue, xe),
        s(Ue, Ge),
        s(Ge, at),
        s(tt, Xe);
      for (let J = 0; J < Ae.length; J += 1) Ae[J] && Ae[J].m(tt, null);
      s(t, lt), s(t, Oe), s(Oe, qe);
      for (let J = 0; J < Me.length; J += 1) Me[J] && Me[J].m(qe, null);
      s(t, ft),
        s(t, Re),
        s(Re, ut),
        s(ut, sl),
        (Wt = !0),
        $t ||
          ((el = [
            ke(f, "click", function () {
              Tl(a[2]) && a[2].apply(this, arguments);
            }),
            ke(y, "change", a[26]),
            ke(H, "change", a[27]),
            ke(se, "input", a[28]),
            ke(he, "input", a[29]),
            ke(Ie, "input", a[30]),
            ke(ut, "click", function () {
              Tl(a[2]) && a[2].apply(this, arguments);
            }),
            ke(t, "click", Kl(a[24])),
            ke(t, "keydown", Kl(a[25])),
            ke(e, "click", function () {
              Tl(a[2]) && a[2].apply(this, arguments);
            }),
            ke(e, "keydown", function () {
              Tl(a[2]) && a[2].apply(this, arguments);
            }),
          ]),
          ($t = !0));
    },
    p(de, Pe) {
      if (((a = de), Pe[0] & 65536)) {
        Mt = a[16];
        let J;
        for (J = 0; J < Mt.length; J += 1) {
          const st = Xa(a, Mt, J);
          Ke[J]
            ? Ke[J].p(st, Pe)
            : ((Ke[J] = za(st)), Ke[J].c(), Ke[J].m(y, null));
        }
        for (; J < Ke.length; J += 1) Ke[J].d(1);
        Ke.length = Mt.length;
      }
      if (
        (Pe[0] & 65664 && Et(y, a[7]),
        Pe[0] & 1 && Et(H, a[0]),
        Pe[0] & 512 && jl(se.value) !== a[9] && Cl(se, a[9]),
        Pe[0] & 1024 && jl(he.value) !== a[10] && Cl(he, a[10]),
        Pe[0] & 256 && Ie.value !== a[8] && Cl(Ie, a[8]),
        (!Wt || Pe[0] & 131072) &&
          $e !== ($e = (a[17] / 4).toFixed(2) + "") &&
          we(Fe, $e),
        Pe[0] & 565248)
      ) {
        yt = a[13];
        let J;
        for (J = 0; J < yt.length; J += 1) {
          const st = qa(a, yt, J);
          Ae[J]
            ? (Ae[J].p(st, Pe), te(Ae[J], 1))
            : ((Ae[J] = ls(st)), Ae[J].c(), te(Ae[J], 1), Ae[J].m(tt, null));
        }
        for (rt(), J = yt.length; J < Ae.length; J += 1) Pl(J);
        nt();
      }
      if (Pe[0] & 268288) {
        Vt = Array(Math.ceil(a[12].length / Yl));
        let J;
        for (J = 0; J < Vt.length; J += 1) {
          const st = Za(a, Vt, J);
          Me[J]
            ? Me[J].p(st, Pe)
            : ((Me[J] = as(st)), Me[J].c(), Me[J].m(qe, null));
        }
        for (; J < Me.length; J += 1) Me[J].d(1);
        Me.length = Vt.length;
      }
    },
    i(de) {
      if (!Wt) {
        for (let Pe = 0; Pe < yt.length; Pe += 1) te(Ae[Pe]);
        Wt = !0;
      }
    },
    o(de) {
      Ae = Ae.filter(Boolean);
      for (let Pe = 0; Pe < Ae.length; Pe += 1) oe(Ae[Pe]);
      Wt = !1;
    },
    d(de) {
      de && i(e), It(Ke, de), It(Ae, de), It(Me, de), ($t = !1), Wl(el);
    },
  };
}
function lr(a) {
  let e, t;
  return (
    (e = new Vs({})),
    {
      c() {
        Se(e.$$.fragment);
      },
      l(l) {
        je(e.$$.fragment, l);
      },
      m(l, r) {
        Le(e, l, r), (t = !0);
      },
      p: Ne,
      i(l) {
        t || (te(e.$$.fragment, l), (t = !0));
      },
      o(l) {
        oe(e.$$.fragment, l), (t = !1);
      },
      d(l) {
        He(e, l);
      },
    }
  );
}
function za(a) {
  let e,
    t = a[44].friendlyName + "",
    l,
    r;
  return {
    c() {
      (e = _("option")), (l = C(t)), this.h();
    },
    l(n) {
      e = p(n, "OPTION", {});
      var m = d(e);
      (l = T(m, t)), m.forEach(i), this.h();
    },
    h() {
      (e.__value = r = a[44].id), (e.value = e.__value);
    },
    m(n, m) {
      X(n, e, m), s(e, l);
    },
    p(n, m) {
      m[0] & 65536 && t !== (t = n[44].friendlyName + "") && we(l, t),
        m[0] & 65536 &&
          r !== (r = n[44].id) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(n) {
      n && i(e);
    },
  };
}
function Ja(a) {
  let e;
  return {
    c() {
      e = C("GK");
    },
    l(t) {
      e = T(t, "GK");
    },
    m(t, l) {
      X(t, e, l);
    },
    d(t) {
      t && i(e);
    },
  };
}
function Qa(a) {
  let e;
  return {
    c() {
      e = C("DF");
    },
    l(t) {
      e = T(t, "DF");
    },
    m(t, l) {
      X(t, e, l);
    },
    d(t) {
      t && i(e);
    },
  };
}
function es(a) {
  let e;
  return {
    c() {
      e = C("MF");
    },
    l(t) {
      e = T(t, "MF");
    },
    m(t, l) {
      X(t, e, l);
    },
    d(t) {
      t && i(e);
    },
  };
}
function ts(a) {
  let e;
  return {
    c() {
      e = C("FW");
    },
    l(t) {
      e = T(t, "FW");
    },
    m(t, l) {
      X(t, e, l);
    },
    d(t) {
      t && i(e);
    },
  };
}
function ar(a) {
  let e, t, l, r, n;
  t = new Ps({ props: { className: "w-6 h-6 p-2" } });
  function m() {
    return a[31](a[42]);
  }
  return {
    c() {
      (e = _("button")), Se(t.$$.fragment), this.h();
    },
    l(f) {
      e = p(f, "BUTTON", { class: !0 });
      var c = d(e);
      je(t.$$.fragment, c), c.forEach(i), this.h();
    },
    h() {
      o(e, "class", "text-xl rounded fpl-button flex items-center");
    },
    m(f, c) {
      X(f, e, c),
        Le(t, e, null),
        (l = !0),
        r || ((n = ke(e, "click", m)), (r = !0));
    },
    p(f, c) {
      a = f;
    },
    i(f) {
      l || (te(t.$$.fragment, f), (l = !0));
    },
    o(f) {
      oe(t.$$.fragment, f), (l = !1);
    },
    d(f) {
      f && i(e), He(t), (r = !1), n();
    },
  };
}
function sr(a) {
  let e,
    t = a[15][a[41]] + "",
    l;
  return {
    c() {
      (e = _("span")), (l = C(t)), this.h();
    },
    l(r) {
      e = p(r, "SPAN", { class: !0 });
      var n = d(e);
      (l = T(n, t)), n.forEach(i), this.h();
    },
    h() {
      o(e, "class", "text-xs text-center");
    },
    m(r, n) {
      X(r, e, n), s(e, l);
    },
    p(r, n) {
      n[0] & 32768 && t !== (t = r[15][r[41]] + "") && we(l, t);
    },
    i: Ne,
    o: Ne,
    d(r) {
      r && i(e);
    },
  };
}
function ls(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c = a[42].firstName + "",
    u,
    h,
    v = a[42].lastName + "",
    b,
    E,
    x,
    g,
    y,
    w,
    V = a[42].team?.abbreviatedName + "",
    k,
    G,
    D,
    $,
    B = (Number(a[42].value) / 4).toFixed(2) + "",
    H,
    R,
    ce,
    S,
    K = a[42].totalPoints + "",
    O,
    ne,
    q,
    le,
    j,
    ae,
    M,
    L = a[42].position === 0 && Ja(),
    I = a[42].position === 1 && Qa(),
    W = a[42].position === 2 && es(),
    Q = a[42].position === 3 && ts();
  y = new Ml({
    props: {
      className: "w-6 h-6 mr-2",
      primaryColour: a[42].team?.primaryColourHex,
      secondaryColour: a[42].team?.secondaryColourHex,
      thirdColour: a[42].team?.thirdColourHex,
    },
  });
  const _e = [sr, ar],
    se = [];
  function Ce(Y, U) {
    return Y[15][Y[41]] ? 0 : 1;
  }
  return (
    (le = Ce(a)),
    (j = se[le] = _e[le](a)),
    {
      c() {
        (e = _("div")),
          (t = _("div")),
          L && L.c(),
          (l = P()),
          I && I.c(),
          (r = P()),
          W && W.c(),
          (n = P()),
          Q && Q.c(),
          (m = P()),
          (f = _("div")),
          (u = C(c)),
          (h = P()),
          (b = C(v)),
          (E = P()),
          (x = _("div")),
          (g = _("p")),
          Se(y.$$.fragment),
          (w = P()),
          (k = C(V)),
          (G = P()),
          (D = _("div")),
          ($ = C("£")),
          (H = C(B)),
          (R = C("m")),
          (ce = P()),
          (S = _("div")),
          (O = C(K)),
          (ne = P()),
          (q = _("div")),
          j.c(),
          (ae = P()),
          this.h();
      },
      l(Y) {
        e = p(Y, "DIV", { class: !0 });
        var U = d(e);
        t = p(U, "DIV", { class: !0 });
        var ee = d(t);
        L && L.l(ee),
          (l = N(ee)),
          I && I.l(ee),
          (r = N(ee)),
          W && W.l(ee),
          (n = N(ee)),
          Q && Q.l(ee),
          ee.forEach(i),
          (m = N(U)),
          (f = p(U, "DIV", { class: !0 }));
        var Ee = d(f);
        (u = T(Ee, c)),
          (h = N(Ee)),
          (b = T(Ee, v)),
          Ee.forEach(i),
          (E = N(U)),
          (x = p(U, "DIV", { class: !0 }));
        var he = d(x);
        g = p(he, "P", { class: !0 });
        var Be = d(g);
        je(y.$$.fragment, Be),
          (w = N(Be)),
          (k = T(Be, V)),
          Be.forEach(i),
          he.forEach(i),
          (G = N(U)),
          (D = p(U, "DIV", { class: !0 }));
        var me = d(D);
        ($ = T(me, "£")),
          (H = T(me, B)),
          (R = T(me, "m")),
          me.forEach(i),
          (ce = N(U)),
          (S = p(U, "DIV", { class: !0 }));
        var F = d(S);
        (O = T(F, K)),
          F.forEach(i),
          (ne = N(U)),
          (q = p(U, "DIV", { class: !0 }));
        var be = d(q);
        j.l(be), be.forEach(i), (ae = N(U)), U.forEach(i), this.h();
      },
      h() {
        o(t, "class", "w-1/12 text-center mx-4"),
          o(f, "class", "w-4/12"),
          o(g, "class", "flex items-center"),
          o(x, "class", "w-2/12"),
          o(D, "class", "w-2/12"),
          o(S, "class", "w-1/12"),
          o(q, "class", "w-2/12 flex justify-center items-center"),
          o(
            e,
            "class",
            "flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer"
          );
      },
      m(Y, U) {
        X(Y, e, U),
          s(e, t),
          L && L.m(t, null),
          s(t, l),
          I && I.m(t, null),
          s(t, r),
          W && W.m(t, null),
          s(t, n),
          Q && Q.m(t, null),
          s(e, m),
          s(e, f),
          s(f, u),
          s(f, h),
          s(f, b),
          s(e, E),
          s(e, x),
          s(x, g),
          Le(y, g, null),
          s(g, w),
          s(g, k),
          s(e, G),
          s(e, D),
          s(D, $),
          s(D, H),
          s(D, R),
          s(e, ce),
          s(e, S),
          s(S, O),
          s(e, ne),
          s(e, q),
          se[le].m(q, null),
          s(e, ae),
          (M = !0);
      },
      p(Y, U) {
        Y[42].position === 0
          ? L || ((L = Ja()), L.c(), L.m(t, l))
          : L && (L.d(1), (L = null)),
          Y[42].position === 1
            ? I || ((I = Qa()), I.c(), I.m(t, r))
            : I && (I.d(1), (I = null)),
          Y[42].position === 2
            ? W || ((W = es()), W.c(), W.m(t, n))
            : W && (W.d(1), (W = null)),
          Y[42].position === 3
            ? Q || ((Q = ts()), Q.c(), Q.m(t, null))
            : Q && (Q.d(1), (Q = null)),
          (!M || U[0] & 8192) && c !== (c = Y[42].firstName + "") && we(u, c),
          (!M || U[0] & 8192) && v !== (v = Y[42].lastName + "") && we(b, v);
        const ee = {};
        U[0] & 8192 && (ee.primaryColour = Y[42].team?.primaryColourHex),
          U[0] & 8192 && (ee.secondaryColour = Y[42].team?.secondaryColourHex),
          U[0] & 8192 && (ee.thirdColour = Y[42].team?.thirdColourHex),
          y.$set(ee),
          (!M || U[0] & 8192) &&
            V !== (V = Y[42].team?.abbreviatedName + "") &&
            we(k, V),
          (!M || U[0] & 8192) &&
            B !== (B = (Number(Y[42].value) / 4).toFixed(2) + "") &&
            we(H, B),
          (!M || U[0] & 8192) && K !== (K = Y[42].totalPoints + "") && we(O, K);
        let Ee = le;
        (le = Ce(Y)),
          le === Ee
            ? se[le].p(Y, U)
            : (rt(),
              oe(se[Ee], 1, 1, () => {
                se[Ee] = null;
              }),
              nt(),
              (j = se[le]),
              j ? j.p(Y, U) : ((j = se[le] = _e[le](Y)), j.c()),
              te(j, 1),
              j.m(q, null));
      },
      i(Y) {
        M || (te(y.$$.fragment, Y), te(j), (M = !0));
      },
      o(Y) {
        oe(y.$$.fragment, Y), oe(j), (M = !1);
      },
      d(Y) {
        Y && i(e),
          L && L.d(),
          I && I.d(),
          W && W.d(),
          Q && Q.d(),
          He(y),
          se[le].d();
      },
    }
  );
}
function as(a) {
  let e,
    t = a[41] + 1 + "",
    l,
    r,
    n,
    m;
  function f() {
    return a[32](a[41]);
  }
  return {
    c() {
      (e = _("button")), (l = C(t)), (r = P()), this.h();
    },
    l(c) {
      e = p(c, "BUTTON", { class: !0 });
      var u = d(e);
      (l = T(u, t)), (r = N(u)), u.forEach(i), this.h();
    },
    h() {
      o(
        e,
        "class",
        "px-4 py-2 bg-gray-700 rounded-md text-white hover:bg-gray-600 svelte-1jqs3dw"
      ),
        Ia(e, "active", a[41] + 1 === a[11]);
    },
    m(c, u) {
      X(c, e, u), s(e, l), s(e, r), n || ((m = ke(e, "click", f)), (n = !0));
    },
    p(c, u) {
      (a = c), u[0] & 2048 && Ia(e, "active", a[41] + 1 === a[11]);
    },
    d(c) {
      c && i(e), (n = !1), m();
    },
  };
}
function rr(a) {
  let e,
    t,
    l = a[1] && Ka(a);
  return {
    c() {
      l && l.c(), (e = Yt());
    },
    l(r) {
      l && l.l(r), (e = Yt());
    },
    m(r, n) {
      l && l.m(r, n), X(r, e, n), (t = !0);
    },
    p(r, n) {
      r[1]
        ? l
          ? (l.p(r, n), n[0] & 2 && te(l, 1))
          : ((l = Ka(r)), l.c(), te(l, 1), l.m(e.parentNode, e))
        : l &&
          (rt(),
          oe(l, 1, 1, () => {
            l = null;
          }),
          nt());
    },
    i(r) {
      t || (te(l), (t = !0));
    },
    o(r) {
      oe(l), (t = !1);
    },
    d(r) {
      l && l.d(r), r && i(e);
    },
  };
}
const Yl = 10;
function nr(a, e, t) {
  let l,
    r,
    n,
    m,
    f,
    c = Ne,
    u = () => (c(), (c = al(S, (F) => t(16, (f = F)))), S),
    h,
    v = Ne,
    b = () => (v(), (v = al(ce, (F) => t(22, (h = F)))), ce),
    E,
    x = Ne,
    g = () => (x(), (x = al(R, (F) => t(17, (E = F)))), R),
    y,
    w = Ne,
    V = () => (w(), (w = al($, (F) => t(23, (y = F)))), $);
  a.$$.on_destroy.push(() => c()),
    a.$$.on_destroy.push(() => v()),
    a.$$.on_destroy.push(() => x()),
    a.$$.on_destroy.push(() => w());
  let { showAddPlayer: k } = e,
    { closeAddPlayerModal: G } = e,
    { handlePlayerSelection: D } = e,
    { fantasyTeam: $ = it(null) } = e;
  V();
  let { filterPosition: B = -1 } = e,
    { filterColumn: H = -1 } = e,
    { bankBalance: R = it(0) } = e;
  g();
  let { players: ce = it([]) } = e;
  b();
  let { teams: S = it([]) } = e;
  u();
  let K,
    O,
    ne = -1,
    q = "",
    le = 0,
    j = 0,
    ae = 1,
    M = !0;
  ea(async () => {
    try {
      await $l.sync(),
        await Vl.sync(),
        (K = Vl.subscribe((be) => {
          S.set(be);
        })),
        (O = $l.subscribe((be) => {
          ce.set(be);
        })),
        (n = L(y?.playerIds ?? []));
    } catch (F) {
      Ul.show("Error loading add player modal.", "error"),
        console.error("Error fetching homepage data:", F);
    } finally {
      t(14, (M = !1));
    }
  }),
    ta(() => {
      K?.(), O?.();
    });
  function L(F) {
    const be = {};
    return (
      F.forEach((ge) => {
        const Ie = h.find((De) => De.id === ge);
        Ie && (be[Ie.teamId] || (be[Ie.teamId] = 0), be[Ie.teamId]++);
      }),
      be
    );
  }
  function I(F) {
    if ((n[F.teamId] || 0) >= 2) return "Max 2 Per Team";
    let ge = y;
    if (!(E >= Number(F.value))) return "Over Budget";
    if (ge && ge.playerIds.includes(F.id)) return "Selected";
    const De = { 0: 0, 1: 0, 2: 0, 3: 0 };
    return (
      ge &&
        ge.playerIds.forEach((We) => {
          const $e = h.find((Fe) => Fe.id === We);
          $e && De[$e.position]++;
        }),
      De[F.position]++,
      ["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"].some(
        (We) => {
          const [$e, Fe, Ze] = We.split("-").map(Number),
            et = Math.max(0, $e - (De[1] || 0)),
            tt = Math.max(0, Fe - (De[2] || 0)),
            Ue = Math.max(0, Ze - (De[3] || 0)),
            bt = Math.max(0, 1 - (De[0] || 0)),
            Gt = et + tt + Ue + bt;
          return Object.values(De).reduce((gt, At) => gt + At, 0) + Gt <= 11;
        }
      )
        ? null
        : "Invalid Formation"
    );
  }
  function W(F) {
    return F.map((be) => {
      const ge = f.find((Ie) => Ie.id === be.teamId);
      return { ...be, team: ge };
    });
  }
  function Q(F) {
    t(11, (ae = F));
  }
  function _e(F) {
    D(F), G(), t(12, (l = []));
  }
  function se(F) {
    zl.call(this, a, F);
  }
  function Ce(F) {
    zl.call(this, a, F);
  }
  function Y() {
    (ne = fl(this)), t(7, ne);
  }
  function U() {
    (B = fl(this)), t(0, B);
  }
  function ee() {
    (le = jl(this.value)), t(9, le);
  }
  function Ee() {
    (j = jl(this.value)), t(10, j);
  }
  function he() {
    (q = this.value), t(8, q);
  }
  const Be = (F) => _e(F),
    me = (F) => Q(F + 1);
  return (
    (a.$$set = (F) => {
      "showAddPlayer" in F && t(1, (k = F.showAddPlayer)),
        "closeAddPlayerModal" in F && t(2, (G = F.closeAddPlayerModal)),
        "handlePlayerSelection" in F && t(20, (D = F.handlePlayerSelection)),
        "fantasyTeam" in F && V(t(3, ($ = F.fantasyTeam))),
        "filterPosition" in F && t(0, (B = F.filterPosition)),
        "filterColumn" in F && t(21, (H = F.filterColumn)),
        "bankBalance" in F && g(t(4, (R = F.bankBalance))),
        "players" in F && b(t(5, (ce = F.players))),
        "teams" in F && u(t(6, (S = F.teams)));
    }),
    (a.$$.update = () => {
      a.$$.dirty[0] & 6293377 &&
        t(
          12,
          (l = h.filter(
            (F) =>
              (ne === -1 || F.teamId === ne) &&
              (B === -1 || F.position === B) &&
              H > -2 &&
              (le === 0 || F.value >= le) &&
              (j === 0 || F.value <= j) &&
              (q === "" || F.lastName.toLowerCase().includes(q.toLowerCase()))
          ))
        ),
        a.$$.dirty[0] & 10487681 &&
          (ne || B || H || le || j || q) &&
          ((n = L(y?.playerIds ?? [])), t(11, (ae = 1))),
        a.$$.dirty[0] & 6144 && t(13, (r = W(l.slice((ae - 1) * Yl, ae * Yl)))),
        a.$$.dirty[0] & 8388608 && (n = L(y?.playerIds ?? [])),
        a.$$.dirty[0] & 8192 && t(15, (m = r.map((F) => I(F))));
    }),
    [
      B,
      k,
      G,
      $,
      R,
      ce,
      S,
      ne,
      q,
      le,
      j,
      ae,
      l,
      r,
      M,
      m,
      f,
      E,
      Q,
      _e,
      D,
      H,
      h,
      y,
      se,
      Ce,
      Y,
      U,
      ee,
      Ee,
      he,
      Be,
      me,
    ]
  );
}
class or extends Ht {
  constructor(e) {
    super(),
      Ut(
        this,
        e,
        nr,
        rr,
        jt,
        {
          showAddPlayer: 1,
          closeAddPlayerModal: 2,
          handlePlayerSelection: 20,
          fantasyTeam: 3,
          filterPosition: 0,
          filterColumn: 21,
          bankBalance: 4,
          players: 5,
          teams: 6,
        },
        null,
        [-1, -1]
      );
  }
}
function ir(a) {
  let e, t, l, r, n, m, f, c, u, h, v, b, E, x, g;
  return {
    c() {
      (e = pe("svg")),
        (t = pe("defs")),
        (l = pe("linearGradient")),
        (r = pe("linearGradient")),
        (n = pe("stop")),
        (m = pe("stop")),
        (f = pe("linearGradient")),
        (c = pe("stop")),
        (u = pe("stop")),
        (h = pe("linearGradient")),
        (v = pe("linearGradient")),
        (b = pe("g")),
        (E = pe("path")),
        (x = pe("path")),
        (g = pe("circle")),
        this.h();
    },
    l(y) {
      e = ve(y, "svg", {
        viewBox: !0,
        class: !0,
        xmlns: !0,
        "xmlns:xlink": !0,
      });
      var w = d(e);
      t = ve(w, "defs", {});
      var V = d(t);
      (l = ve(V, "linearGradient", { id: !0 })),
        d(l).forEach(i),
        (r = ve(V, "linearGradient", { id: !0 }));
      var k = d(r);
      (n = ve(k, "stop", { style: !0, offset: !0 })),
        d(n).forEach(i),
        (m = ve(k, "stop", { style: !0, offset: !0 })),
        d(m).forEach(i),
        k.forEach(i),
        (f = ve(V, "linearGradient", { id: !0 }));
      var G = d(f);
      (c = ve(G, "stop", { style: !0, offset: !0 })),
        d(c).forEach(i),
        (u = ve(G, "stop", { style: !0, offset: !0 })),
        d(u).forEach(i),
        G.forEach(i),
        (h = ve(V, "linearGradient", {
          id: !0,
          gradientUnits: !0,
          x1: !0,
          y1: !0,
          x2: !0,
          y2: !0,
          gradientTransform: !0,
          "xlink:href": !0,
        })),
        d(h).forEach(i),
        (v = ve(V, "linearGradient", {
          id: !0,
          gradientUnits: !0,
          x1: !0,
          y1: !0,
          x2: !0,
          y2: !0,
          gradientTransform: !0,
          "xlink:href": !0,
        })),
        d(v).forEach(i),
        V.forEach(i),
        (b = ve(w, "g", { transform: !0 }));
      var D = d(b);
      (E = ve(D, "path", { d: !0, style: !0, transform: !0 })),
        d(E).forEach(i),
        (x = ve(D, "path", { style: !0, transform: !0, d: !0 })),
        d(x).forEach(i),
        (g = ve(D, "circle", { style: !0, cx: !0, cy: !0, r: !0 })),
        d(g).forEach(i),
        D.forEach(i),
        w.forEach(i),
        this.h();
    },
    h() {
      o(l, "id", "gradient-2"),
        ot(n, "stop-color", "rgb(251, 176, 59)"),
        o(n, "offset", "0"),
        ot(m, "stop-color", "rgb(240, 90, 36)"),
        o(m, "offset", "1"),
        o(r, "id", "gradient-5"),
        ot(c, "stop-color", "rgb(95, 37, 131)"),
        o(c, "offset", "0"),
        ot(u, "stop-color", "rgb(237, 30, 121)"),
        o(u, "offset", "1"),
        o(f, "id", "gradient-6"),
        o(h, "id", "gradient-6-1"),
        o(h, "gradientUnits", "userSpaceOnUse"),
        o(h, "x1", "973.216"),
        o(h, "y1", "100.665"),
        o(h, "x2", "973.216"),
        o(h, "y2", "388.077"),
        o(
          h,
          "gradientTransform",
          "matrix(0.974127, -0.22842, 0.310454, 1.352474, -95.300314, 85.515158)"
        ),
        Ca(h, "xlink:href", "#gradient-6"),
        o(v, "id", "gradient-5-0"),
        o(v, "gradientUnits", "userSpaceOnUse"),
        o(v, "x1", "188.919"),
        o(v, "y1", "1.638"),
        o(v, "x2", "188.919"),
        o(v, "y2", "361.638"),
        o(
          v,
          "gradientTransform",
          "matrix(-0.999999, 0.0016, -0.002016, -1.25907, 376.779907, 357.264557)"
        ),
        Ca(v, "xlink:href", "#gradient-5"),
        o(
          E,
          "d",
          "M 188.919 181.638 m -180 0 a 180 180 0 1 0 360 0 a 180 180 0 1 0 -360 0 Z M 188.919 181.638 m -100 0 a 100 100 0 0 1 200 0 a 100 100 0 0 1 -200 0 Z"
        ),
        ot(E, "fill", "url(#gradient-5-0)"),
        o(
          E,
          "transform",
          "matrix(1, 0.000074, -0.000074, 1, 61.094498, 68.347626)"
        ),
        ot(x, "stroke-width", "0px"),
        ot(x, "paint-order", "stroke"),
        ot(x, "fill", "url(#gradient-6-1)"),
        o(
          x,
          "transform",
          "matrix(1.031731, 0.000001, 0, 1.020801, -634.597351, 0.544882)"
        ),
        o(
          x,
          "d",
          "M 958.327234958 100.664699414 A 175.433 175.433 0 0 1 958.327234958 388.077300586 L 913.296322517 323.766492741 A 96.924 96.924 0 0 0 913.296322517 164.975507259 Z"
        ),
        ot(g, "fill", "rgb(25, 25, 25)"),
        o(g, "cx", "250"),
        o(g, "cy", "250"),
        o(g, "r", "100"),
        o(b, "transform", "matrix(1, 0, 0, 1, -69.98674, -69.986298)"),
        o(e, "viewBox", "0 0 361 361"),
        o(e, "class", a[0]),
        o(e, "xmlns", "http://www.w3.org/2000/svg"),
        o(e, "xmlns:xlink", "http://www.w3.org/1999/xlink");
    },
    m(y, w) {
      X(y, e, w),
        s(e, t),
        s(t, l),
        s(t, r),
        s(r, n),
        s(r, m),
        s(t, f),
        s(f, c),
        s(f, u),
        s(t, h),
        s(t, v),
        s(e, b),
        s(b, E),
        s(b, x),
        s(b, g);
    },
    p(y, [w]) {
      w & 1 && o(e, "class", y[0]);
    },
    i: Ne,
    o: Ne,
    d(y) {
      y && i(e);
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
class ss extends Ht {
  constructor(e) {
    super(), Ut(this, e, cr, ir, jt, { className: 0 });
  }
}
function rs(a, e, t) {
  const l = a.slice();
  return (l[16] = e[t][0]), (l[2] = e[t][1]), l;
}
function ns(a, e, t) {
  const l = a.slice();
  return (
    (l[19] = e[t].fixture), (l[20] = e[t].homeTeam), (l[21] = e[t].awayTeam), l
  );
}
function os(a, e, t) {
  const l = a.slice();
  return (l[24] = e[t]), l;
}
function is(a) {
  let e,
    t,
    l = a[24] + "",
    r;
  return {
    c() {
      (e = _("option")), (t = C("Gameweek ")), (r = C(l)), this.h();
    },
    l(n) {
      e = p(n, "OPTION", {});
      var m = d(e);
      (t = T(m, "Gameweek ")), (r = T(m, l)), m.forEach(i), this.h();
    },
    h() {
      (e.__value = a[24]), (e.value = e.__value);
    },
    m(n, m) {
      X(n, e, m), s(e, t), s(e, r);
    },
    p: Ne,
    d(n) {
      n && i(e);
    },
  };
}
function cs(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c,
    u,
    h,
    v,
    b,
    E,
    x,
    g,
    y,
    w,
    V,
    k = Ql(Number(a[19].kickOff)) + "",
    G,
    D,
    $,
    B,
    H,
    R = (a[20] ? a[20].friendlyName : "") + "",
    ce,
    S,
    K,
    O,
    ne = (a[21] ? a[21].friendlyName : "") + "",
    q,
    le,
    j,
    ae,
    M,
    L = (a[19].status === 0 ? "-" : a[19].homeGoals) + "",
    I,
    W,
    Q,
    _e = (a[19].status === 0 ? "-" : a[19].awayGoals) + "",
    se,
    Ce,
    Y;
  return (
    (m = new Ml({
      props: {
        primaryColour: a[20] ? a[20].primaryColourHex : "",
        secondaryColour: a[20] ? a[20].secondaryColourHex : "",
        thirdColour: a[20] ? a[20].thirdColourHex : "",
      },
    })),
    (x = new Ml({
      props: {
        primaryColour: a[21] ? a[21].primaryColourHex : "",
        secondaryColour: a[21] ? a[21].secondaryColourHex : "",
        thirdColour: a[21] ? a[21].thirdColourHex : "",
      },
    })),
    {
      c() {
        (e = _("div")),
          (t = _("div")),
          (l = _("div")),
          (r = _("div")),
          (n = _("a")),
          Se(m.$$.fragment),
          (c = P()),
          (u = _("span")),
          (h = C("v")),
          (v = P()),
          (b = _("div")),
          (E = _("a")),
          Se(x.$$.fragment),
          (y = P()),
          (w = _("div")),
          (V = _("span")),
          (G = C(k)),
          (D = P()),
          ($ = _("div")),
          (B = _("div")),
          (H = _("a")),
          (ce = C(R)),
          (K = P()),
          (O = _("a")),
          (q = C(ne)),
          (j = P()),
          (ae = _("div")),
          (M = _("span")),
          (I = C(L)),
          (W = P()),
          (Q = _("span")),
          (se = C(_e)),
          this.h();
      },
      l(U) {
        e = p(U, "DIV", { class: !0 });
        var ee = d(e);
        t = p(ee, "DIV", { class: !0 });
        var Ee = d(t);
        l = p(Ee, "DIV", { class: !0 });
        var he = d(l);
        r = p(he, "DIV", { class: !0 });
        var Be = d(r);
        n = p(Be, "A", { href: !0 });
        var me = d(n);
        je(m.$$.fragment, me),
          me.forEach(i),
          Be.forEach(i),
          (c = N(he)),
          (u = p(he, "SPAN", { class: !0 }));
        var F = d(u);
        (h = T(F, "v")),
          F.forEach(i),
          (v = N(he)),
          (b = p(he, "DIV", { class: !0 }));
        var be = d(b);
        E = p(be, "A", { href: !0 });
        var ge = d(E);
        je(x.$$.fragment, ge),
          ge.forEach(i),
          be.forEach(i),
          he.forEach(i),
          (y = N(Ee)),
          (w = p(Ee, "DIV", { class: !0 }));
        var Ie = d(w);
        V = p(Ie, "SPAN", { class: !0 });
        var De = d(V);
        (G = T(De, k)),
          De.forEach(i),
          Ie.forEach(i),
          Ee.forEach(i),
          (D = N(ee)),
          ($ = p(ee, "DIV", { class: !0 }));
        var Ve = d($);
        B = p(Ve, "DIV", { class: !0 });
        var Te = d(B);
        H = p(Te, "A", { class: !0, href: !0 });
        var We = d(H);
        (ce = T(We, R)),
          We.forEach(i),
          (K = N(Te)),
          (O = p(Te, "A", { class: !0, href: !0 }));
        var $e = d(O);
        (q = T($e, ne)),
          $e.forEach(i),
          Te.forEach(i),
          (j = N(Ve)),
          (ae = p(Ve, "DIV", { class: !0 }));
        var Fe = d(ae);
        M = p(Fe, "SPAN", {});
        var Ze = d(M);
        (I = T(Ze, L)), Ze.forEach(i), (W = N(Fe)), (Q = p(Fe, "SPAN", {}));
        var et = d(Q);
        (se = T(et, _e)),
          et.forEach(i),
          Fe.forEach(i),
          Ve.forEach(i),
          ee.forEach(i),
          this.h();
      },
      h() {
        o(n, "href", (f = `/club?id=${a[19].homeTeamId}`)),
          o(r, "class", "w-8 items-center justify-center"),
          o(u, "class", "font-bold text-lg"),
          o(E, "href", (g = `/club?id=${a[19].awayTeamId}`)),
          o(b, "class", "w-8 items-center justify-center"),
          o(l, "class", "flex w-1/2 space-x-4 justify-center"),
          o(V, "class", "text-sm ml-4 md:ml-0 text-left"),
          o(w, "class", "flex w-1/2 md:justify-center"),
          o(t, "class", "flex items-center w-1/2 ml-4"),
          o(H, "class", "my-1"),
          o(H, "href", (S = `/club?id=${a[19].homeTeamId}`)),
          o(O, "class", "my-1"),
          o(O, "href", (le = `/club?id=${a[19].awayTeamId}`)),
          o(
            B,
            "class",
            "flex flex-col min-w-[120px] md:min-w-[200px] text-xs 3xl:text-base"
          ),
          o(ae, "class", "flex flex-col items-center text-xs"),
          o($, "class", "flex items-center space-x-10 w-1/2 md:justify-center"),
          o(
            e,
            "class",
            (Ce = `flex items-center justify-between py-2 border-b border-gray-700  
              ${a[19].status === 0 ? "text-gray-400" : "text-white"}`)
          );
      },
      m(U, ee) {
        X(U, e, ee),
          s(e, t),
          s(t, l),
          s(l, r),
          s(r, n),
          Le(m, n, null),
          s(l, c),
          s(l, u),
          s(u, h),
          s(l, v),
          s(l, b),
          s(b, E),
          Le(x, E, null),
          s(t, y),
          s(t, w),
          s(w, V),
          s(V, G),
          s(e, D),
          s(e, $),
          s($, B),
          s(B, H),
          s(H, ce),
          s(B, K),
          s(B, O),
          s(O, q),
          s($, j),
          s($, ae),
          s(ae, M),
          s(M, I),
          s(ae, W),
          s(ae, Q),
          s(Q, se),
          (Y = !0);
      },
      p(U, ee) {
        const Ee = {};
        ee & 2 && (Ee.primaryColour = U[20] ? U[20].primaryColourHex : ""),
          ee & 2 &&
            (Ee.secondaryColour = U[20] ? U[20].secondaryColourHex : ""),
          ee & 2 && (Ee.thirdColour = U[20] ? U[20].thirdColourHex : ""),
          m.$set(Ee),
          (!Y || (ee & 2 && f !== (f = `/club?id=${U[19].homeTeamId}`))) &&
            o(n, "href", f);
        const he = {};
        ee & 2 && (he.primaryColour = U[21] ? U[21].primaryColourHex : ""),
          ee & 2 &&
            (he.secondaryColour = U[21] ? U[21].secondaryColourHex : ""),
          ee & 2 && (he.thirdColour = U[21] ? U[21].thirdColourHex : ""),
          x.$set(he),
          (!Y || (ee & 2 && g !== (g = `/club?id=${U[19].awayTeamId}`))) &&
            o(E, "href", g),
          (!Y || ee & 2) &&
            k !== (k = Ql(Number(U[19].kickOff)) + "") &&
            we(G, k),
          (!Y || ee & 2) &&
            R !== (R = (U[20] ? U[20].friendlyName : "") + "") &&
            we(ce, R),
          (!Y || (ee & 2 && S !== (S = `/club?id=${U[19].homeTeamId}`))) &&
            o(H, "href", S),
          (!Y || ee & 2) &&
            ne !== (ne = (U[21] ? U[21].friendlyName : "") + "") &&
            we(q, ne),
          (!Y || (ee & 2 && le !== (le = `/club?id=${U[19].awayTeamId}`))) &&
            o(O, "href", le),
          (!Y || ee & 2) &&
            L !== (L = (U[19].status === 0 ? "-" : U[19].homeGoals) + "") &&
            we(I, L),
          (!Y || ee & 2) &&
            _e !== (_e = (U[19].status === 0 ? "-" : U[19].awayGoals) + "") &&
            we(se, _e),
          (!Y ||
            (ee & 2 &&
              Ce !==
                (Ce = `flex items-center justify-between py-2 border-b border-gray-700  
              ${U[19].status === 0 ? "text-gray-400" : "text-white"}`))) &&
            o(e, "class", Ce);
      },
      i(U) {
        Y || (te(m.$$.fragment, U), te(x.$$.fragment, U), (Y = !0));
      },
      o(U) {
        oe(m.$$.fragment, U), oe(x.$$.fragment, U), (Y = !1);
      },
      d(U) {
        U && i(e), He(m), He(x);
      },
    }
  );
}
function fs(a) {
  let e,
    t,
    l,
    r = a[16] + "",
    n,
    m,
    f,
    c,
    u = a[2],
    h = [];
  for (let b = 0; b < u.length; b += 1) h[b] = cs(ns(a, u, b));
  const v = (b) =>
    oe(h[b], 1, 1, () => {
      h[b] = null;
    });
  return {
    c() {
      (e = _("div")), (t = _("div")), (l = _("h2")), (n = C(r)), (m = P());
      for (let b = 0; b < h.length; b += 1) h[b].c();
      (f = P()), this.h();
    },
    l(b) {
      e = p(b, "DIV", {});
      var E = d(e);
      t = p(E, "DIV", { class: !0 });
      var x = d(t);
      l = p(x, "H2", { class: !0 });
      var g = d(l);
      (n = T(g, r)), g.forEach(i), x.forEach(i), (m = N(E));
      for (let y = 0; y < h.length; y += 1) h[y].l(E);
      (f = N(E)), E.forEach(i), this.h();
    },
    h() {
      o(l, "class", "date-header ml-4 text-xs"),
        o(
          t,
          "class",
          "flex items-center justify-between border border-gray-700 py-2 bg-light-gray"
        );
    },
    m(b, E) {
      X(b, e, E), s(e, t), s(t, l), s(l, n), s(e, m);
      for (let x = 0; x < h.length; x += 1) h[x] && h[x].m(e, null);
      s(e, f), (c = !0);
    },
    p(b, E) {
      if (((!c || E & 2) && r !== (r = b[16] + "") && we(n, r), E & 2)) {
        u = b[2];
        let x;
        for (x = 0; x < u.length; x += 1) {
          const g = ns(b, u, x);
          h[x]
            ? (h[x].p(g, E), te(h[x], 1))
            : ((h[x] = cs(g)), h[x].c(), te(h[x], 1), h[x].m(e, f));
        }
        for (rt(), x = u.length; x < h.length; x += 1) v(x);
        nt();
      }
    },
    i(b) {
      if (!c) {
        for (let E = 0; E < u.length; E += 1) te(h[E]);
        c = !0;
      }
    },
    o(b) {
      h = h.filter(Boolean);
      for (let E = 0; E < h.length; E += 1) oe(h[E]);
      c = !1;
    },
    d(b) {
      b && i(e), It(h, b);
    },
  };
}
function fr(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c,
    u,
    h,
    v,
    b,
    E,
    x,
    g,
    y,
    w,
    V,
    k,
    G,
    D,
    $ = a[3],
    B = [];
  for (let S = 0; S < $.length; S += 1) B[S] = is(os(a, $, S));
  let H = Object.entries(a[1]),
    R = [];
  for (let S = 0; S < H.length; S += 1) R[S] = fs(rs(a, H, S));
  const ce = (S) =>
    oe(R[S], 1, 1, () => {
      R[S] = null;
    });
  return {
    c() {
      (e = _("div")),
        (t = _("div")),
        (l = _("div")),
        (r = _("h1")),
        (n = C("Fixtures")),
        (m = P()),
        (f = _("div")),
        (c = _("button")),
        (u = C("<")),
        (v = P()),
        (b = _("select"));
      for (let S = 0; S < B.length; S += 1) B[S].c();
      (E = P()), (x = _("button")), (g = C(">")), (w = P()), (V = _("div"));
      for (let S = 0; S < R.length; S += 1) R[S].c();
      this.h();
    },
    l(S) {
      e = p(S, "DIV", { class: !0 });
      var K = d(e);
      t = p(K, "DIV", { class: !0 });
      var O = d(t);
      l = p(O, "DIV", { class: !0 });
      var ne = d(l);
      r = p(ne, "H1", { class: !0 });
      var q = d(r);
      (n = T(q, "Fixtures")),
        q.forEach(i),
        ne.forEach(i),
        (m = N(O)),
        (f = p(O, "DIV", { class: !0 }));
      var le = d(f);
      c = p(le, "BUTTON", { class: !0 });
      var j = d(c);
      (u = T(j, "<")),
        j.forEach(i),
        (v = N(le)),
        (b = p(le, "SELECT", { class: !0 }));
      var ae = d(b);
      for (let I = 0; I < B.length; I += 1) B[I].l(ae);
      ae.forEach(i), (E = N(le)), (x = p(le, "BUTTON", { class: !0 }));
      var M = d(x);
      (g = T(M, ">")),
        M.forEach(i),
        le.forEach(i),
        (w = N(O)),
        (V = p(O, "DIV", {}));
      var L = d(V);
      for (let I = 0; I < R.length; I += 1) R[I].l(L);
      L.forEach(i), O.forEach(i), K.forEach(i), this.h();
    },
    h() {
      o(r, "class", "mx-4 m-2 font-bold"),
        o(l, "class", "flex items-center justify-between py-2 bg-light-gray"),
        o(
          c,
          "class",
          "text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
        ),
        (c.disabled = h = a[0] === 1),
        o(
          b,
          "class",
          "p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]"
        ),
        a[0] === void 0 && ul(() => a[8].call(b)),
        o(
          x,
          "class",
          "text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
        ),
        (x.disabled = y = a[0] === 38),
        o(f, "class", "flex items-center space-x-2 m-3 mx-4"),
        o(t, "class", "container-fluid"),
        o(e, "class", "bg-panel rounded-md m-4 flex-1");
    },
    m(S, K) {
      X(S, e, K),
        s(e, t),
        s(t, l),
        s(l, r),
        s(r, n),
        s(t, m),
        s(t, f),
        s(f, c),
        s(c, u),
        s(f, v),
        s(f, b);
      for (let O = 0; O < B.length; O += 1) B[O] && B[O].m(b, null);
      Et(b, a[0], !0), s(f, E), s(f, x), s(x, g), s(t, w), s(t, V);
      for (let O = 0; O < R.length; O += 1) R[O] && R[O].m(V, null);
      (k = !0),
        G ||
          ((D = [
            ke(c, "click", a[7]),
            ke(b, "change", a[8]),
            ke(x, "click", a[9]),
          ]),
          (G = !0));
    },
    p(S, [K]) {
      if (
        ((!k || (K & 9 && h !== (h = S[0] === 1))) && (c.disabled = h), K & 8)
      ) {
        $ = S[3];
        let O;
        for (O = 0; O < $.length; O += 1) {
          const ne = os(S, $, O);
          B[O] ? B[O].p(ne, K) : ((B[O] = is(ne)), B[O].c(), B[O].m(b, null));
        }
        for (; O < B.length; O += 1) B[O].d(1);
        B.length = $.length;
      }
      if (
        (K & 9 && Et(b, S[0]),
        (!k || (K & 9 && y !== (y = S[0] === 38))) && (x.disabled = y),
        K & 2)
      ) {
        H = Object.entries(S[1]);
        let O;
        for (O = 0; O < H.length; O += 1) {
          const ne = rs(S, H, O);
          R[O]
            ? (R[O].p(ne, K), te(R[O], 1))
            : ((R[O] = fs(ne)), R[O].c(), te(R[O], 1), R[O].m(V, null));
        }
        for (rt(), O = H.length; O < R.length; O += 1) ce(O);
        nt();
      }
    },
    i(S) {
      if (!k) {
        for (let K = 0; K < H.length; K += 1) te(R[K]);
        k = !0;
      }
    },
    o(S) {
      R = R.filter(Boolean);
      for (let K = 0; K < R.length; K += 1) oe(R[K]);
      k = !1;
    },
    d(S) {
      S && i(e), It(B, S), It(R, S), (G = !1), Wl(D);
    },
  };
}
function ur(a, e, t) {
  let l,
    r,
    n = [],
    m = [],
    f = [],
    c = 1,
    u = Array.from({ length: 38 }, (V, k) => k + 1),
    h,
    v,
    b;
  ea(async () => {
    await Vl.sync(),
      await Jl.sync(),
      await Rl.sync(),
      (h = Vl.subscribe((V) => {
        n = V;
      })),
      (v = Jl.subscribe((V) => {
        t(2, (m = V)),
          t(
            5,
            (f = m.map((k) => ({
              fixture: k,
              homeTeam: x(k.homeTeamId),
              awayTeam: x(k.awayTeamId),
            })))
          );
      })),
      (b = Rl.subscribe((V) => {}));
  }),
    ta(() => {
      h?.(), v?.(), b?.();
    });
  const E = (V) => {
    t(0, (c = Math.max(1, Math.min(38, c + V))));
  };
  function x(V) {
    return n.find((k) => k.id === V);
  }
  const g = () => E(-1);
  function y() {
    (c = fl(this)), t(0, c), t(3, u);
  }
  const w = () => E(1);
  return (
    (a.$$.update = () => {
      a.$$.dirty & 33 &&
        t(6, (l = f.filter(({ fixture: V }) => V.gameweek === c))),
        a.$$.dirty & 64 &&
          t(
            1,
            (r = l.reduce((V, k) => {
              const G = new Date(Number(k.fixture.kickOff) / 1e6),
                $ = new Intl.DateTimeFormat("en-GB", {
                  weekday: "long",
                  day: "numeric",
                  month: "long",
                  year: "numeric",
                }).format(G);
              return V[$] || (V[$] = []), V[$].push(k), V;
            }, {}))
          );
    }),
    [c, r, m, u, E, f, l, g, y, w]
  );
}
class dr extends Ht {
  constructor(e) {
    super(), Ut(this, e, ur, fr, jt, {});
  }
}
function mr(a) {
  let e, t, l, r, n, m, f, c, u, h, v, b, E, x, g, y, w;
  return {
    c() {
      (e = pe("svg")),
        (t = pe("g")),
        (l = pe("path")),
        (r = pe("path")),
        (n = pe("path")),
        (m = pe("g")),
        (f = pe("path")),
        (c = pe("defs")),
        (u = pe("filter")),
        (h = pe("feFlood")),
        (v = pe("feColorMatrix")),
        (b = pe("feOffset")),
        (E = pe("feGaussianBlur")),
        (x = pe("feComposite")),
        (g = pe("feColorMatrix")),
        (y = pe("feBlend")),
        (w = pe("feBlend")),
        this.h();
    },
    l(V) {
      e = ve(V, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var k = d(e);
      t = ve(k, "g", { filter: !0 });
      var G = d(t);
      (l = ve(G, "path", { d: !0, fill: !0 })),
        d(l).forEach(i),
        (r = ve(G, "path", { d: !0, fill: !0 })),
        d(r).forEach(i),
        (n = ve(G, "path", { d: !0, fill: !0 })),
        d(n).forEach(i),
        G.forEach(i),
        (m = ve(k, "g", { transform: !0 }));
      var D = d(m);
      (f = ve(D, "path", { d: !0, fill: !0 })),
        d(f).forEach(i),
        D.forEach(i),
        (c = ve(k, "defs", {}));
      var $ = d(c);
      u = ve($, "filter", {
        id: !0,
        x: !0,
        y: !0,
        width: !0,
        height: !0,
        filterUnits: !0,
      });
      var B = d(u);
      (h = ve(B, "feFlood", { "flood-opacity": !0, result: !0 })),
        d(h).forEach(i),
        (v = ve(B, "feColorMatrix", {
          in: !0,
          type: !0,
          values: !0,
          result: !0,
        })),
        d(v).forEach(i),
        (b = ve(B, "feOffset", { dy: !0 })),
        d(b).forEach(i),
        (E = ve(B, "feGaussianBlur", { stdDeviation: !0 })),
        d(E).forEach(i),
        (x = ve(B, "feComposite", { in2: !0, operator: !0 })),
        d(x).forEach(i),
        (g = ve(B, "feColorMatrix", { type: !0, values: !0 })),
        d(g).forEach(i),
        (y = ve(B, "feBlend", { mode: !0, in2: !0, result: !0 })),
        d(y).forEach(i),
        (w = ve(B, "feBlend", { mode: !0, in: !0, in2: !0, result: !0 })),
        d(w).forEach(i),
        B.forEach(i),
        $.forEach(i),
        k.forEach(i),
        this.h();
    },
    h() {
      o(
        l,
        "d",
        "M65.9308 38.3253L63.5966 33.0215L63.642 33.2129C63.5966 34.2107 63.5603 35.2633 63.533 36.366C63.4831 38.3299 63.4604 40.4442 63.4604 42.6587C63.4604 54.9386 64.1597 70.308 64.8727 79.9999H21.1266C21.835 70.2989 22.5389 54.9159 22.5389 42.6313C22.5389 40.4214 22.5162 38.3162 22.4663 36.3569C22.439 35.2542 22.4027 34.2062 22.3573 33.2129L22.3982 33.0215L20.0685 38.3253L9.30566 33.3131L20.5453 10.6213L20.5862 10.5438L20.6271 10.4573C20.6271 10.4573 31.6578 6.72087 32.0166 6.3609C32.0983 6.27889 32.2346 6.09662 32.3935 5.86424C34.2554 8.43871 36.6668 10.6122 39.4688 12.2252C40.2726 12.69 41.1037 13.1046 41.971 13.4737C42.3026 13.615 42.6432 13.7517 42.9883 13.8747V13.8838C42.9883 13.8838 42.9928 13.8838 42.9974 13.8793C43.0019 13.8838 43.0065 13.8838 43.011 13.8838V13.8747C43.3516 13.7517 43.6922 13.615 44.0237 13.4737C44.8865 13.1092 45.7267 12.69 46.5305 12.2252C49.3324 10.6122 51.7439 8.43871 53.6058 5.85968C53.7647 6.09662 53.901 6.27889 53.9827 6.3609C54.3415 6.72087 65.3722 10.4573 65.3722 10.4573L65.4131 10.5438L65.454 10.6213L76.6891 33.3131L65.9308 38.3253Z"
      ),
        o(l, "fill", a[1]),
        o(
          r,
          "d",
          "M51.2756 3.04364C51.1348 3.26691 50.985 3.48563 50.8351 3.69979C49.0504 6.26059 46.7298 8.43864 44.0232 10.0881C43.6917 10.2932 43.3556 10.4845 43.0105 10.6714C43.0105 10.6714 43.0059 10.6759 43.0014 10.6759C42.9969 10.6759 42.9923 10.6714 42.9878 10.6714C42.6426 10.4845 42.302 10.2886 41.9705 10.0836C39.2685 8.43864 36.9479 6.26059 35.1632 3.69979C35.0133 3.48563 34.8634 3.26691 34.7227 3.04364H51.2756Z"
        ),
        o(r, "fill", a[2]),
        o(
          n,
          "d",
          "M68.5512 8.58005L68.265 8.00136C68.265 8.00136 68.2514 7.99681 68.2287 7.98769C67.5294 7.75075 57.3478 4.29686 55.1726 3.35365C54.9546 3.25796 54.8138 3.18505 54.7775 3.1486C54.7502 3.12126 54.7184 3.08936 54.6866 3.0438C54.2416 2.49701 53.1699 0.715384 52.8429 0.164037C52.7793 0.0592356 52.743 0 52.743 0H33.2564C33.2564 0 33.22 0.0592356 33.1565 0.164037C32.8295 0.715384 31.7578 2.49701 31.3173 3.0438C31.2809 3.08936 31.2491 3.12126 31.2219 3.1486C31.1856 3.18505 31.0448 3.25796 30.8223 3.35365C28.6424 4.29686 18.4654 7.75075 17.7706 7.98769C17.7479 7.99681 17.7343 8.00136 17.7343 8.00136L17.4482 8.5846L4.33301 35.0629L18.5835 41.7019L20.0685 38.3254L9.3057 33.3132L20.5454 10.6214L20.5862 10.5439L20.6271 10.4574C20.6271 10.4574 31.6578 6.72096 32.0166 6.36099C32.0984 6.27897 32.2346 6.09671 32.3935 5.86432C34.2555 8.43879 36.6669 10.6123 39.4688 12.2253C40.2726 12.6901 41.1037 13.1047 41.9711 13.4738C42.3026 13.6151 42.6432 13.7518 42.9883 13.8748C42.9883 13.8748 42.9914 13.8763 42.9974 13.8794C42.9974 13.8794 43.0065 13.8794 43.011 13.8748C43.3516 13.7518 43.6922 13.6151 44.0237 13.4738C44.8866 13.1093 45.7267 12.6901 46.5305 12.2253C49.3325 10.6123 51.7439 8.43879 53.6058 5.85977C53.7648 6.09671 53.901 6.27897 53.9827 6.36099C54.3415 6.72096 65.3723 10.4574 65.3723 10.4574L65.4131 10.5439L65.454 10.6214L76.6891 33.3132L65.9308 38.3254L67.4158 41.7019L81.6663 35.0629L68.5512 8.58005ZM50.8356 3.69995C49.0509 6.26075 46.7303 8.43879 44.0237 10.0883C43.6922 10.2933 43.3562 10.4847 43.011 10.6715V10.6806H43.0019C42.9974 10.6806 42.9929 10.6806 42.9883 10.6806V10.6715C42.6432 10.4847 42.3026 10.2888 41.9711 10.0837C39.269 8.43879 36.9484 6.26075 35.1637 3.69995C35.0138 3.48579 34.864 3.26707 34.7232 3.0438H51.2761C51.1354 3.26707 50.9855 3.48579 50.8356 3.69995Z"
        ),
        o(n, "fill", a[3]),
        o(t, "filter", "url(#filter0_d_354_581)"),
        o(
          f,
          "d",
          "M16 6.66667H9.33333V0H6.66667V6.66667H0V9.33333H6.66667V16H9.33333V9.33333H16V6.66667Z"
        ),
        o(f, "fill", "#FFFFF"),
        o(m, "transform", "translate(36 30)"),
        o(h, "flood-opacity", "0"),
        o(h, "result", "BackgroundImageFix"),
        o(v, "in", "SourceAlpha"),
        o(v, "type", "matrix"),
        o(v, "values", "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"),
        o(v, "result", "hardAlpha"),
        o(b, "dy", "4"),
        o(E, "stdDeviation", "2"),
        o(x, "in2", "hardAlpha"),
        o(x, "operator", "out"),
        o(g, "type", "matrix"),
        o(g, "values", "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0"),
        o(y, "mode", "normal"),
        o(y, "in2", "BackgroundImageFix"),
        o(y, "result", "effect1_dropShadow_354_581"),
        o(w, "mode", "normal"),
        o(w, "in", "SourceGraphic"),
        o(w, "in2", "effect1_dropShadow_354_581"),
        o(w, "result", "shape"),
        o(u, "id", "filter0_d_354_581"),
        o(u, "x", "0.333008"),
        o(u, "y", "0"),
        o(u, "width", "85.333"),
        o(u, "height", "87.9999"),
        o(u, "filterUnits", "userSpaceOnUse"),
        o(e, "xmlns", "http://www.w3.org/2000/svg"),
        o(e, "class", a[0]),
        o(e, "fill", "currentColor"),
        o(e, "viewBox", "0 0 86 88");
    },
    m(V, k) {
      X(V, e, k),
        s(e, t),
        s(t, l),
        s(t, r),
        s(t, n),
        s(e, m),
        s(m, f),
        s(e, c),
        s(c, u),
        s(u, h),
        s(u, v),
        s(u, b),
        s(u, E),
        s(u, x),
        s(u, g),
        s(u, y),
        s(u, w);
    },
    p(V, [k]) {
      k & 2 && o(l, "fill", V[1]),
        k & 4 && o(r, "fill", V[2]),
        k & 8 && o(n, "fill", V[3]),
        k & 1 && o(e, "class", V[0]);
    },
    i: Ne,
    o: Ne,
    d(V) {
      V && i(e);
    },
  };
}
function hr(a, e, t) {
  let { className: l = "" } = e,
    { primaryColour: r = "#2CE3A6" } = e,
    { secondaryColour: n = "#777777" } = e,
    { thirdColour: m = "#FFFFFF" } = e;
  return (
    (a.$$set = (f) => {
      "className" in f && t(0, (l = f.className)),
        "primaryColour" in f && t(1, (r = f.primaryColour)),
        "secondaryColour" in f && t(2, (n = f.secondaryColour)),
        "thirdColour" in f && t(3, (m = f.thirdColour));
    }),
    [l, r, n, m]
  );
}
class _r extends Ht {
  constructor(e) {
    super(),
      Ut(this, e, hr, mr, jt, {
        className: 0,
        primaryColour: 1,
        secondaryColour: 2,
        thirdColour: 3,
      });
  }
}
function pr(a) {
  let e, t;
  return {
    c() {
      (e = pe("svg")), (t = pe("path")), this.h();
    },
    l(l) {
      e = ve(l, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var r = d(e);
      (t = ve(r, "path", { d: !0, fill: !0 })),
        d(t).forEach(i),
        r.forEach(i),
        this.h();
    },
    h() {
      o(
        t,
        "d",
        "M14.5979 8.93594L14.6033 8.89794V8.89927C14.6193 8.7806 14.6326 8.66127 14.6419 8.54127C14.6579 8.33994 14.5159 8.0006 14.1426 8.0006C13.8819 8.0006 13.6659 8.2006 13.6446 8.4606C13.6326 8.60794 13.6153 8.75394 13.5926 8.89794C13.1626 11.5986 10.8206 13.6666 7.99859 13.6666C5.97392 13.6666 4.19592 12.6019 3.19459 11.0033L4.52192 10.9999C4.79792 10.9999 5.02192 10.7759 5.02192 10.4999C5.02192 10.2239 4.79792 9.99994 4.52192 9.99994H1.83325C1.55725 9.99994 1.33325 10.2239 1.33325 10.4999V13.1993C1.33325 13.4753 1.55725 13.6993 1.83325 13.6993C2.10925 13.6993 2.33325 13.4759 2.33325 13.1993L2.33525 11.5159C3.51192 13.4066 5.60925 14.6666 7.99859 14.6666C11.3599 14.6666 14.1433 12.1726 14.5979 8.93594ZM1.41525 6.95327L1.40925 6.9906V6.98927C1.38592 7.1446 1.36725 7.30194 1.35459 7.46127C1.33859 7.6626 1.48059 8.00194 1.85392 8.00194C2.11459 8.00194 2.33059 7.80194 2.35192 7.54194C2.36659 7.35527 2.39059 7.17127 2.42325 6.9906C2.90059 4.34527 5.21592 2.33594 7.99792 2.33594C10.0226 2.33594 11.8006 3.4006 12.8019 4.99927L11.4746 5.0026C11.1986 5.0026 10.9746 5.2266 10.9746 5.5026C10.9746 5.7786 11.1986 6.0026 11.4746 6.0026H14.1633C14.4393 6.0026 14.6633 5.7786 14.6633 5.5026V2.80327C14.6633 2.52727 14.4393 2.30327 14.1633 2.30327C13.8873 2.30327 13.6633 2.5266 13.6633 2.80327L13.6613 4.4866C12.4846 2.59594 10.3873 1.33594 7.99792 1.33594C4.67525 1.33594 1.91792 3.77194 1.41525 6.95327Z"
      ),
        o(t, "fill", "white"),
        o(e, "xmlns", "http://www.w3.org/2000/svg"),
        o(e, "class", a[0]),
        o(e, "fill", "currentColor"),
        o(e, "viewBox", "0 0 16 16");
    },
    m(l, r) {
      X(l, e, r), s(e, t);
    },
    p(l, [r]) {
      r & 1 && o(e, "class", l[0]);
    },
    i: Ne,
    o: Ne,
    d(l) {
      l && i(e);
    },
  };
}
function vr(a, e, t) {
  let { className: l = "" } = e;
  return (
    (a.$$set = (r) => {
      "className" in r && t(0, (l = r.className));
    }),
    [l]
  );
}
class Ns extends Ht {
  constructor(e) {
    super(), Ut(this, e, vr, pr, jt, { className: 0 });
  }
}
function br(a) {
  let e, t, l;
  return {
    c() {
      (e = pe("svg")), (t = pe("circle")), (l = pe("path")), this.h();
    },
    l(r) {
      e = ve(r, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var n = d(e);
      (t = ve(n, "circle", {
        cx: !0,
        cy: !0,
        r: !0,
        fill: !0,
        "fill-opacity": !0,
      })),
        d(t).forEach(i),
        (l = ve(n, "path", { transform: !0, d: !0, fill: !0 })),
        d(l).forEach(i),
        n.forEach(i),
        this.h();
    },
    h() {
      o(t, "cx", "11.5"),
        o(t, "cy", "11"),
        o(t, "r", "11"),
        o(t, "fill", "#242529"),
        o(t, "fill-opacity", "0.9"),
        o(l, "transform", "translate(4.7,4) scale(0.8,0.8)"),
        o(
          l,
          "d",
          "M8.39289 1.61501C8.47689 1.44234 8.65289 1.33301 8.84489 1.33301C9.03756 1.33301 9.21289 1.44234 9.29689 1.61501C9.94622 2.94701 11.0636 5.24167 11.0636 5.24167C11.0636 5.24167 13.6042 5.59101 15.0782 5.79434C15.3469 5.83101 15.5116 6.05834 15.5116 6.29234C15.5116 6.41901 15.4636 6.54767 15.3576 6.64967C14.2842 7.67501 12.4362 9.44368 12.4362 9.44368C12.4362 9.44368 12.8876 11.955 13.1489 13.4117C13.2042 13.7197 12.9656 13.9997 12.6542 13.9997C12.5729 13.9997 12.4916 13.9803 12.4176 13.9403C11.1056 13.2417 8.84489 12.0397 8.84489 12.0397C8.84489 12.0397 6.58422 13.2417 5.27222 13.9403C5.19822 13.9803 5.11622 13.9997 5.03489 13.9997C4.72489 13.9997 4.48489 13.719 4.54089 13.4117C4.80289 11.955 5.25422 9.44368 5.25422 9.44368C5.25422 9.44368 3.40556 7.67501 2.33289 6.64967C2.22622 6.54767 2.17822 6.41901 2.17822 6.29301C2.17822 6.05834 2.34422 5.83034 2.61222 5.79434C4.08622 5.59101 6.62622 5.24167 6.62622 5.24167C6.62622 5.24167 7.74422 2.94701 8.39289 1.61501ZM8.84489 2.97034L7.27089 6.16501L3.77356 6.64434L6.33889 9.07301L5.70689 12.5763L8.84489 10.9063L11.9829 12.5763L11.3489 9.08567L13.9162 6.64434L10.3736 6.14034L8.84489 2.97034Z"
        ),
        o(l, "fill", "#2CE3A6"),
        o(e, "xmlns", "http://www.w3.org/2000/svg"),
        o(e, "class", a[0]),
        o(e, "fill", "currentColor"),
        o(e, "viewBox", "0 0 23 22");
    },
    m(r, n) {
      X(r, e, n), s(e, t), s(e, l);
    },
    p(r, [n]) {
      n & 1 && o(e, "class", r[0]);
    },
    i: Ne,
    o: Ne,
    d(r) {
      r && i(e);
    },
  };
}
function gr(a, e, t) {
  let { className: l = "" } = e;
  return (
    (a.$$set = (r) => {
      "className" in r && t(0, (l = r.className));
    }),
    [l]
  );
}
class Ds extends Ht {
  constructor(e) {
    super(), Ut(this, e, gr, br, jt, { className: 0 });
  }
}
function yr(a) {
  let e, t, l;
  return {
    c() {
      (e = pe("svg")), (t = pe("circle")), (l = pe("path")), this.h();
    },
    l(r) {
      e = ve(r, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var n = d(e);
      (t = ve(n, "circle", {
        cx: !0,
        cy: !0,
        r: !0,
        fill: !0,
        fillopacity: !0,
      })),
        d(t).forEach(i),
        (l = ve(n, "path", { transform: !0, d: !0, fill: !0 })),
        d(l).forEach(i),
        n.forEach(i),
        this.h();
    },
    h() {
      o(t, "cx", "11.5"),
        o(t, "cy", "11"),
        o(t, "r", "11"),
        o(t, "fill", "#242529"),
        o(t, "fillopacity", "0.9"),
        o(l, "transform", "translate(4.7,4) scale(0.8,0.8)"),
        o(
          l,
          "d",
          "M8.39289 1.61501C8.47689 1.44234 8.65289 1.33301 8.84489 1.33301C9.03756 1.33301 9.21289 1.44234 9.29689 1.61501C9.94622 2.94701 11.0636 5.24167 11.0636 5.24167C11.0636 5.24167 13.6042 5.59101 15.0782 5.79434C15.3469 5.83101 15.5116 6.05834 15.5116 6.29234C15.5116 6.41901 15.4636 6.54767 15.3576 6.64967C14.2842 7.67501 12.4362 9.44368 12.4362 9.44368C12.4362 9.44368 12.8876 11.955 13.1489 13.4117C13.2042 13.7197 12.9656 13.9997 12.6542 13.9997C12.5729 13.9997 12.4916 13.9803 12.4176 13.9403C11.1056 13.2417 8.84489 12.0397 8.84489 12.0397C8.84489 12.0397 6.58422 13.2417 5.27222 13.9403C5.19822 13.9803 5.11622 13.9997 5.03489 13.9997C4.72489 13.9997 4.48489 13.719 4.54089 13.4117C4.80289 11.955 5.25422 9.44368 5.25422 9.44368C5.25422 9.44368 3.40556 7.67501 2.33289 6.64967C2.22622 6.54767 2.17822 6.41901 2.17822 6.29301C2.17822 6.05834 2.34422 5.83034 2.61222 5.79434C4.08622 5.59101 6.62622 5.24167 6.62622 5.24167C6.62622 5.24167 7.74422 2.94701 8.39289 1.61501Z"
        ),
        o(l, "fill", "#2CE3A6"),
        o(e, "xmlns", "http://www.w3.org/2000/svg"),
        o(e, "class", a[0]),
        o(e, "fill", "currentColor"),
        o(e, "viewBox", "0 0 23 22");
    },
    m(r, n) {
      X(r, e, n), s(e, t), s(e, l);
    },
    p(r, [n]) {
      n & 1 && o(e, "class", r[0]);
    },
    i: Ne,
    o: Ne,
    d(r) {
      r && i(e);
    },
  };
}
function wr(a, e, t) {
  let { className: l = "" } = e;
  return (
    (a.$$set = (r) => {
      "className" in r && t(0, (l = r.className));
    }),
    [l]
  );
}
class Gs extends Ht {
  constructor(e) {
    super(), Ut(this, e, wr, yr, jt, { className: 0 });
  }
}
const { Map: As } = Ms;
function us(a, e, t) {
  const l = a.slice();
  return (l[69] = e[t]), (l[71] = t), l;
}
function ds(a, e, t) {
  const l = a.slice();
  (l[72] = e[t]), (l[78] = t);
  const r = l[34](l[71], l[78]);
  l[73] = r;
  const n = l[3]?.playerIds ?? [];
  l[74] = n;
  const m = l[74][l[73]];
  l[75] = m;
  const f = l[4].find(function (...h) {
    return a[49](l[75], ...h);
  });
  l[76] = f;
  const c = l[5].find(function (...h) {
    return a[50](l[76], ...h);
  });
  return (l[79] = c), l;
}
function ms(a, e, t) {
  const l = a.slice();
  return (l[69] = e[t]), (l[71] = t), l;
}
function hs(a, e, t) {
  const l = a.slice();
  (l[72] = e[t]), (l[78] = t);
  const r = l[34](l[71], l[78]);
  l[73] = r;
  const n = l[3]?.playerIds ?? [];
  l[74] = n;
  const m = l[74][l[73]];
  l[75] = m;
  const f = l[4].find(function (...u) {
    return a[45](l[75], ...u);
  });
  return (l[76] = f), l;
}
function xr(a) {
  const e = a.slice(),
    t = e[5].find(function (...r) {
      return a[41](e[76], ...r);
    });
  return (e[79] = t), e;
}
function _s(a, e, t) {
  const l = a.slice();
  return (l[82] = e[t]), l;
}
function kr(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c,
    u,
    h,
    v,
    b,
    E,
    x,
    g,
    y,
    w,
    V,
    k,
    G,
    D,
    $,
    B,
    H,
    R,
    ce,
    S,
    K,
    O,
    ne,
    q,
    le,
    j,
    ae,
    M,
    L,
    I,
    W,
    Q,
    _e,
    se,
    Ce,
    Y,
    U,
    ee,
    Ee,
    he,
    Be = a[3]?.playerIds.filter(xs).length + "",
    me,
    F,
    be,
    ge,
    Ie,
    De,
    Ve,
    Te,
    We,
    $e,
    Fe,
    Ze,
    et,
    tt = a[15].toFixed(2) + "",
    Ue,
    bt,
    Gt,
    Ct,
    gt,
    At,
    Tt,
    Nt,
    ct,
    A,
    Z,
    ie,
    re,
    fe,
    ue = (a[19] / 4).toFixed(2) + "",
    xe,
    Ge,
    at,
    Xe,
    lt,
    Oe,
    qe,
    ft,
    Re,
    ut,
    sl,
    Wt,
    $t,
    el = (a[20] === 1 / 0 ? "Unlimited" : a[20]) + "",
    Mt,
    Ke,
    yt,
    Ae,
    Pl,
    Vt,
    Me,
    de,
    Pe,
    J,
    st,
    dl,
    Bt,
    Dt,
    Zt,
    tl,
    qt,
    Ft,
    ml,
    dt,
    hl,
    mt,
    Pt,
    _l,
    rl,
    nl,
    pl,
    ht,
    ll,
    ol,
    Xt,
    vl,
    wt,
    _t,
    pt,
    Kt,
    Ot,
    ze,
    bl,
    St,
    Ye,
    gl,
    Nl;
  e = new or({
    props: {
      handlePlayerSelection: a[33],
      filterPosition: a[11],
      filterColumn: a[12],
      showAddPlayer: a[14],
      closeAddPlayerModal: a[32],
      fantasyTeam: a[26],
      bankBalance: a[28],
      players: a[24],
      teams: a[23],
    },
  });
  let zt = a[21],
    Je = [];
  for (let z = 0; z < zt.length; z += 1) Je[z] = ps(_s(a, zt, z));
  const Dl = [Cr, Ir],
    Lt = [];
  function Gl(z, ye) {
    return z[13] ? 0 : 1;
  }
  return (
    (_t = Gl(a)),
    (pt = Lt[_t] = Dl[_t](a)),
    (ze = new dr({})),
    (St = new Js({
      props: {
        fantasyTeam: a[26],
        teams: a[23],
        players: a[24],
        activeGameweek: a[1],
      },
    })),
    {
      c() {
        Se(e.$$.fragment),
          (t = P()),
          (l = _("div")),
          (r = _("div")),
          (n = _("div")),
          (m = _("div")),
          (f = _("p")),
          (c = C("Gameweek")),
          (u = P()),
          (h = _("p")),
          (v = C(a[1])),
          (b = P()),
          (E = _("p")),
          (x = C(a[0])),
          (g = P()),
          (y = _("div")),
          (w = P()),
          (V = _("div")),
          (k = _("p")),
          (G = C("Kick Off:")),
          (D = P()),
          ($ = _("div")),
          (B = _("p")),
          (H = C(a[8])),
          (R = _("span")),
          (ce = C("d")),
          (S = C(`
                : `)),
          (K = C(a[9])),
          (O = _("span")),
          (ne = C("h")),
          (q = C(`
                : `)),
          (le = C(a[10])),
          (j = _("span")),
          (ae = C("m")),
          (M = P()),
          (L = _("p")),
          (I = C(a[6])),
          (W = C(" | ")),
          (Q = C(a[7])),
          (_e = P()),
          (se = _("div")),
          (Ce = P()),
          (Y = _("div")),
          (U = _("p")),
          (ee = C("Players")),
          (Ee = P()),
          (he = _("p")),
          (me = C(Be)),
          (F = C("/11")),
          (be = P()),
          (ge = _("p")),
          (Ie = C("Selected")),
          (De = P()),
          (Ve = _("div")),
          (Te = _("div")),
          (We = _("p")),
          ($e = C("Team Value")),
          (Fe = P()),
          (Ze = _("p")),
          (et = C("£")),
          (Ue = C(tt)),
          (bt = C("m")),
          (Gt = P()),
          (Ct = _("p")),
          (gt = C("GBP")),
          (At = P()),
          (Tt = _("div")),
          (Nt = P()),
          (ct = _("div")),
          (A = _("p")),
          (Z = C("Bank Balance")),
          (ie = P()),
          (re = _("p")),
          (fe = C("£")),
          (xe = C(ue)),
          (Ge = C("m")),
          (at = P()),
          (Xe = _("p")),
          (lt = C("GBP")),
          (Oe = P()),
          (qe = _("div")),
          (ft = P()),
          (Re = _("div")),
          (ut = _("p")),
          (sl = C("Transfers")),
          (Wt = P()),
          ($t = _("p")),
          (Mt = C(el)),
          (Ke = P()),
          (yt = _("p")),
          (Ae = C("Available")),
          (Pl = P()),
          (Vt = _("div")),
          (Me = _("div")),
          (de = _("div")),
          (Pe = _("button")),
          (J = C("Pitch View")),
          (dl = P()),
          (Bt = _("button")),
          (Dt = C("List View")),
          (tl = P()),
          (qt = _("div")),
          (Ft = _("span")),
          (ml = C(`Formation:
              `)),
          (dt = _("select"));
        for (let z = 0; z < Je.length; z += 1) Je[z].c();
        (hl = P()),
          (mt = _("div")),
          (Pt = _("button")),
          (_l = C("Auto Fill")),
          (pl = P()),
          (ht = _("button")),
          (ll = C("Save Team")),
          (vl = P()),
          (wt = _("div")),
          pt.c(),
          (Kt = P()),
          (Ot = _("div")),
          Se(ze.$$.fragment),
          (bl = P()),
          Se(St.$$.fragment),
          this.h();
      },
      l(z) {
        je(e.$$.fragment, z), (t = N(z)), (l = p(z, "DIV", { class: !0 }));
        var ye = d(l);
        r = p(ye, "DIV", { class: !0 });
        var xt = d(r);
        n = p(xt, "DIV", { class: !0 });
        var kt = d(n);
        m = p(kt, "DIV", { class: !0 });
        var Jt = d(m);
        f = p(Jt, "P", { class: !0 });
        var vt = d(f);
        (c = T(vt, "Gameweek")),
          vt.forEach(i),
          (u = N(Jt)),
          (h = p(Jt, "P", { class: !0 }));
        var Al = d(h);
        (v = T(Al, a[1])),
          Al.forEach(i),
          (b = N(Jt)),
          (E = p(Jt, "P", { class: !0 }));
        var la = d(E);
        (x = T(la, a[0])),
          la.forEach(i),
          Jt.forEach(i),
          (g = N(kt)),
          (y = p(kt, "DIV", { class: !0, style: !0 })),
          d(y).forEach(i),
          (w = N(kt)),
          (V = p(kt, "DIV", { class: !0 }));
        var yl = d(V);
        k = p(yl, "P", { class: !0 });
        var aa = d(k);
        (G = T(aa, "Kick Off:")),
          aa.forEach(i),
          (D = N(yl)),
          ($ = p(yl, "DIV", { class: !0 }));
        var sa = d($);
        B = p(sa, "P", { class: !0 });
        var Qt = d(B);
        (H = T(Qt, a[8])), (R = p(Qt, "SPAN", { class: !0 }));
        var ra = d(R);
        (ce = T(ra, "d")),
          ra.forEach(i),
          (S = T(
            Qt,
            `
                : `
          )),
          (K = T(Qt, a[9])),
          (O = p(Qt, "SPAN", { class: !0 }));
        var na = d(O);
        (ne = T(na, "h")),
          na.forEach(i),
          (q = T(
            Qt,
            `
                : `
          )),
          (le = T(Qt, a[10])),
          (j = p(Qt, "SPAN", { class: !0 }));
        var oa = d(j);
        (ae = T(oa, "m")),
          oa.forEach(i),
          Qt.forEach(i),
          sa.forEach(i),
          (M = N(yl)),
          (L = p(yl, "P", { class: !0 }));
        var Bl = d(L);
        (I = T(Bl, a[6])),
          (W = T(Bl, " | ")),
          (Q = T(Bl, a[7])),
          Bl.forEach(i),
          yl.forEach(i),
          (_e = N(kt)),
          (se = p(kt, "DIV", { class: !0, style: !0 })),
          d(se).forEach(i),
          (Ce = N(kt)),
          (Y = p(kt, "DIV", { class: !0 }));
        var wl = d(Y);
        U = p(wl, "P", { class: !0 });
        var ia = d(U);
        (ee = T(ia, "Players")),
          ia.forEach(i),
          (Ee = N(wl)),
          (he = p(wl, "P", { class: !0 }));
        var Zl = d(he);
        (me = T(Zl, Be)),
          (F = T(Zl, "/11")),
          Zl.forEach(i),
          (be = N(wl)),
          (ge = p(wl, "P", { class: !0 }));
        var ca = d(ge);
        (Ie = T(ca, "Selected")),
          ca.forEach(i),
          wl.forEach(i),
          kt.forEach(i),
          (De = N(xt)),
          (Ve = p(xt, "DIV", { class: !0 }));
        var Rt = d(Ve);
        Te = p(Rt, "DIV", { class: !0 });
        var xl = d(Te);
        We = p(xl, "P", { class: !0 });
        var fa = d(We);
        ($e = T(fa, "Team Value")),
          fa.forEach(i),
          (Fe = N(xl)),
          (Ze = p(xl, "P", { class: !0 }));
        var Fl = d(Ze);
        (et = T(Fl, "£")),
          (Ue = T(Fl, tt)),
          (bt = T(Fl, "m")),
          Fl.forEach(i),
          (Gt = N(xl)),
          (Ct = p(xl, "P", { class: !0 }));
        var ua = d(Ct);
        (gt = T(ua, "GBP")),
          ua.forEach(i),
          xl.forEach(i),
          (At = N(Rt)),
          (Tt = p(Rt, "DIV", { class: !0, style: !0 })),
          d(Tt).forEach(i),
          (Nt = N(Rt)),
          (ct = p(Rt, "DIV", { class: !0 }));
        var kl = d(ct);
        A = p(kl, "P", { class: !0 });
        var da = d(A);
        (Z = T(da, "Bank Balance")),
          da.forEach(i),
          (ie = N(kl)),
          (re = p(kl, "P", { class: !0 }));
        var Ol = d(re);
        (fe = T(Ol, "£")),
          (xe = T(Ol, ue)),
          (Ge = T(Ol, "m")),
          Ol.forEach(i),
          (at = N(kl)),
          (Xe = p(kl, "P", { class: !0 }));
        var ma = d(Xe);
        (lt = T(ma, "GBP")),
          ma.forEach(i),
          kl.forEach(i),
          (Oe = N(Rt)),
          (qe = p(Rt, "DIV", { class: !0, style: !0 })),
          d(qe).forEach(i),
          (ft = N(Rt)),
          (Re = p(Rt, "DIV", { class: !0 }));
        var El = d(Re);
        ut = p(El, "P", { class: !0 });
        var ha = d(ut);
        (sl = T(ha, "Transfers")),
          ha.forEach(i),
          (Wt = N(El)),
          ($t = p(El, "P", { class: !0 }));
        var _a = d($t);
        (Mt = T(_a, el)),
          _a.forEach(i),
          (Ke = N(El)),
          (yt = p(El, "P", { class: !0 }));
        var pa = d(yt);
        (Ae = T(pa, "Available")),
          pa.forEach(i),
          El.forEach(i),
          Rt.forEach(i),
          xt.forEach(i),
          (Pl = N(ye)),
          (Vt = p(ye, "DIV", { class: !0 }));
        var va = d(Vt);
        Me = p(va, "DIV", { class: !0 });
        var Il = d(Me);
        de = p(Il, "DIV", { class: !0 });
        var Sl = d(de);
        Pe = p(Sl, "BUTTON", { class: !0 });
        var ba = d(Pe);
        (J = T(ba, "Pitch View")),
          ba.forEach(i),
          (dl = N(Sl)),
          (Bt = p(Sl, "BUTTON", { class: !0 }));
        var ga = d(Bt);
        (Dt = T(ga, "List View")),
          ga.forEach(i),
          Sl.forEach(i),
          (tl = N(Il)),
          (qt = p(Il, "DIV", { class: !0 }));
        var ya = d(qt);
        Ft = p(ya, "SPAN", { class: !0 });
        var ql = d(Ft);
        (ml = T(
          ql,
          `Formation:
              `
        )),
          (dt = p(ql, "SELECT", { class: !0 }));
        var wa = d(dt);
        for (let Xl = 0; Xl < Je.length; Xl += 1) Je[Xl].l(wa);
        wa.forEach(i),
          ql.forEach(i),
          ya.forEach(i),
          (hl = N(Il)),
          (mt = p(Il, "DIV", { class: !0 }));
        var Ll = d(mt);
        Pt = p(Ll, "BUTTON", { class: !0 });
        var xa = d(Pt);
        (_l = T(xa, "Auto Fill")),
          xa.forEach(i),
          (pl = N(Ll)),
          (ht = p(Ll, "BUTTON", { class: !0 }));
        var ka = d(ht);
        (ll = T(ka, "Save Team")),
          ka.forEach(i),
          Ll.forEach(i),
          Il.forEach(i),
          va.forEach(i),
          (vl = N(ye)),
          (wt = p(ye, "DIV", { class: !0 }));
        var Hl = d(wt);
        pt.l(Hl), (Kt = N(Hl)), (Ot = p(Hl, "DIV", { class: !0 }));
        var Ea = d(Ot);
        je(ze.$$.fragment, Ea),
          Ea.forEach(i),
          Hl.forEach(i),
          (bl = N(ye)),
          je(St.$$.fragment, ye),
          ye.forEach(i),
          this.h();
      },
      h() {
        o(f, "class", "text-gray-300 text-xs"),
          o(h, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
          o(E, "class", "text-gray-300 text-xs"),
          o(m, "class", "flex-grow mb-4 xl:mb-0"),
          o(
            y,
            "class",
            "h-px bg-gray-400 w-full xl:w-px xl:h-full xl:self-stretch"
          ),
          ot(y, "min-height", "2px"),
          ot(y, "min-width", "2px"),
          o(k, "class", "text-gray-300 text-xs mt-4 xl:mt-0"),
          o(R, "class", "text-gray-300 text-xs ml-1"),
          o(O, "class", "text-gray-300 text-xs ml-1"),
          o(j, "class", "text-gray-300 text-xs ml-1"),
          o(B, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
          o($, "class", "flex"),
          o(L, "class", "text-gray-300 text-xs"),
          o(V, "class", "flex-grow mb-4 xl:mb-0"),
          o(
            se,
            "class",
            "h-px bg-gray-400 w-full xl:w-px xl:h-full xl:self-stretch"
          ),
          ot(se, "min-height", "2px"),
          ot(se, "min-width", "2px"),
          o(U, "class", "text-gray-300 text-xs"),
          o(
            he,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          o(ge, "class", "text-gray-300 text-xs"),
          o(Y, "class", "flex-grow mb-0 mt-4 xl:mt-0"),
          o(
            n,
            "class",
            "flex flex-col xl:flex-row justify-start xl:items-center text-white space-x-0 xl:space-x-4 flex-grow mx-4 my-2 xl:m-4 bg-panel p-4 rounded-md"
          ),
          o(We, "class", "text-gray-300 text-xs"),
          o(
            Ze,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          o(Ct, "class", "text-gray-300 text-xs"),
          o(Te, "class", "flex-grow mb-4 xl:mb-0"),
          o(
            Tt,
            "class",
            "h-px bg-gray-400 w-full xl:w-px xl:h-full xl:self-stretch"
          ),
          ot(Tt, "min-height", "2px"),
          ot(Tt, "min-width", "2px"),
          o(A, "class", "text-gray-300 text-xs"),
          o(
            re,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          o(Xe, "class", "text-gray-300 text-xs"),
          o(ct, "class", "flex-grow mb-4 xl:mb-0 mt-4 xl:mt-0"),
          o(
            qe,
            "class",
            "h-px bg-gray-400 w-full xl:w-px xl:h-full xl:self-stretch"
          ),
          ot(qe, "min-height", "2px"),
          ot(qe, "min-width", "2px"),
          o(ut, "class", "text-gray-300 text-xs"),
          o(
            $t,
            "class",
            "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"
          ),
          o(yt, "class", "text-gray-300 text-xs"),
          o(Re, "class", "flex-grow mb-4 xl:mb-0 mt-4 xl:mt-0"),
          o(
            Ve,
            "class",
            "flex flex-col xl:flex-row justify-start xl:items-center text-white space-x-0 xl:space-x-4 flex-grow mx-4 my-1 xl:m-4 bg-panel py-2 px-4 lg:py-4 rounded-md"
          ),
          o(r, "class", "flex flex-col sm:flex-row"),
          o(
            Pe,
            "class",
            (st = `btn ${
              a[13] ? "fpl-button" : "inactive-btn"
            } px-4 py-2 rounded-l-md font-bold md:text-xs xl:text-base min-w-[100px] lg:min-w-[125px] my-4`)
          ),
          o(
            Bt,
            "class",
            (Zt = `btn ${
              a[13] ? "inactive-btn" : "fpl-button"
            } px-4 py-2 rounded-r-md font-bold md:text-xs xl:text-base min-w-[100px] lg:min-w-[125px] my-4`)
          ),
          o(
            de,
            "class",
            "flex flex-row justify-between md:justify-start flex-grow ml-4 order-3 md:order-1"
          ),
          o(dt, "class", "p-2 fpl-dropdown xl:text-lg text-center"),
          a[2] === void 0 && ul(() => a[40].call(dt)),
          o(Ft, "class", "text-lg"),
          o(
            qt,
            "class",
            "text-center md:text-left w-full mt-0 md:ml-8 order-2 mt-4 md:mt-0"
          ),
          (Pt.disabled = rl =
            a[3]?.playerIds ? a[3]?.playerIds.filter(ks).length === 0 : !0),
          o(
            Pt,
            "class",
            (nl = `btn w-full md:w-auto md:text-xs xl:text-base px-4 py-2 rounded  
              ${
                a[3]?.playerIds && a[3]?.playerIds.filter(Es).length > 0
                  ? "fpl-purple-btn"
                  : "bg-gray-500"
              } text-white min-w-[125px]`)
          ),
          (ht.disabled = ol = !a[18]),
          o(
            ht,
            "class",
            (Xt = `btn w-full md:w-auto md:text-xs xl:text-base px-4 py-2 rounded ${
              a[18] ? "fpl-purple-btn" : "bg-gray-500"
            } text-white min-w-[125px]`)
          ),
          o(
            mt,
            "class",
            "flex flex-col md:flex-row w-full md:justify-end gap-4 mr-0 md:mr-4 order-1 md:order-3 mt-2 md:mt-0"
          ),
          o(
            Me,
            "class",
            "flex flex-col md:flex-row justify-between items-center text-white mx-4 my-2 xl:m-4 bg-panel p-2 xl:p-4 rounded-md md:w-full"
          ),
          o(Vt, "class", "flex flex-col md:flex-row"),
          o(Ot, "class", "flex w-100 xl:w-1/2"),
          o(wt, "class", "flex flex-col xl:flex-row"),
          o(l, "class", "sm:m-1 md:m-2 lg:m-3 xl:m-4");
      },
      m(z, ye) {
        Le(e, z, ye),
          X(z, t, ye),
          X(z, l, ye),
          s(l, r),
          s(r, n),
          s(n, m),
          s(m, f),
          s(f, c),
          s(m, u),
          s(m, h),
          s(h, v),
          s(m, b),
          s(m, E),
          s(E, x),
          s(n, g),
          s(n, y),
          s(n, w),
          s(n, V),
          s(V, k),
          s(k, G),
          s(V, D),
          s(V, $),
          s($, B),
          s(B, H),
          s(B, R),
          s(R, ce),
          s(B, S),
          s(B, K),
          s(B, O),
          s(O, ne),
          s(B, q),
          s(B, le),
          s(B, j),
          s(j, ae),
          s(V, M),
          s(V, L),
          s(L, I),
          s(L, W),
          s(L, Q),
          s(n, _e),
          s(n, se),
          s(n, Ce),
          s(n, Y),
          s(Y, U),
          s(U, ee),
          s(Y, Ee),
          s(Y, he),
          s(he, me),
          s(he, F),
          s(Y, be),
          s(Y, ge),
          s(ge, Ie),
          s(r, De),
          s(r, Ve),
          s(Ve, Te),
          s(Te, We),
          s(We, $e),
          s(Te, Fe),
          s(Te, Ze),
          s(Ze, et),
          s(Ze, Ue),
          s(Ze, bt),
          s(Te, Gt),
          s(Te, Ct),
          s(Ct, gt),
          s(Ve, At),
          s(Ve, Tt),
          s(Ve, Nt),
          s(Ve, ct),
          s(ct, A),
          s(A, Z),
          s(ct, ie),
          s(ct, re),
          s(re, fe),
          s(re, xe),
          s(re, Ge),
          s(ct, at),
          s(ct, Xe),
          s(Xe, lt),
          s(Ve, Oe),
          s(Ve, qe),
          s(Ve, ft),
          s(Ve, Re),
          s(Re, ut),
          s(ut, sl),
          s(Re, Wt),
          s(Re, $t),
          s($t, Mt),
          s(Re, Ke),
          s(Re, yt),
          s(yt, Ae),
          s(l, Pl),
          s(l, Vt),
          s(Vt, Me),
          s(Me, de),
          s(de, Pe),
          s(Pe, J),
          s(de, dl),
          s(de, Bt),
          s(Bt, Dt),
          s(Me, tl),
          s(Me, qt),
          s(qt, Ft),
          s(Ft, ml),
          s(Ft, dt);
        for (let xt = 0; xt < Je.length; xt += 1) Je[xt] && Je[xt].m(dt, null);
        Et(dt, a[2], !0),
          s(Me, hl),
          s(Me, mt),
          s(mt, Pt),
          s(Pt, _l),
          s(mt, pl),
          s(mt, ht),
          s(ht, ll),
          s(l, vl),
          s(l, wt),
          Lt[_t].m(wt, null),
          s(wt, Kt),
          s(wt, Ot),
          Le(ze, Ot, null),
          s(l, bl),
          Le(St, l, null),
          (Ye = !0),
          gl ||
            ((Nl = [
              ke(Pe, "click", a[29]),
              ke(Bt, "click", a[30]),
              ke(dt, "change", a[40]),
              ke(Pt, "click", a[37]),
              ke(ht, "click", a[38]),
            ]),
            (gl = !0));
      },
      p(z, ye) {
        const xt = {};
        if (
          (ye[0] & 2048 && (xt.filterPosition = z[11]),
          ye[0] & 4096 && (xt.filterColumn = z[12]),
          ye[0] & 16384 && (xt.showAddPlayer = z[14]),
          e.$set(xt),
          (!Ye || ye[0] & 2) && we(v, z[1]),
          (!Ye || ye[0] & 1) && we(x, z[0]),
          (!Ye || ye[0] & 256) && we(H, z[8]),
          (!Ye || ye[0] & 512) && we(K, z[9]),
          (!Ye || ye[0] & 1024) && we(le, z[10]),
          (!Ye || ye[0] & 64) && we(I, z[6]),
          (!Ye || ye[0] & 128) && we(Q, z[7]),
          (!Ye || ye[0] & 8) &&
            Be !== (Be = z[3]?.playerIds.filter(xs).length + "") &&
            we(me, Be),
          (!Ye || ye[0] & 32768) &&
            tt !== (tt = z[15].toFixed(2) + "") &&
            we(Ue, tt),
          (!Ye || ye[0] & 524288) &&
            ue !== (ue = (z[19] / 4).toFixed(2) + "") &&
            we(xe, ue),
          (!Ye || ye[0] & 1048576) &&
            el !== (el = (z[20] === 1 / 0 ? "Unlimited" : z[20]) + "") &&
            we(Mt, el),
          (!Ye ||
            (ye[0] & 8192 &&
              st !==
                (st = `btn ${
                  z[13] ? "fpl-button" : "inactive-btn"
                } px-4 py-2 rounded-l-md font-bold md:text-xs xl:text-base min-w-[100px] lg:min-w-[125px] my-4`))) &&
            o(Pe, "class", st),
          (!Ye ||
            (ye[0] & 8192 &&
              Zt !==
                (Zt = `btn ${
                  z[13] ? "inactive-btn" : "fpl-button"
                } px-4 py-2 rounded-r-md font-bold md:text-xs xl:text-base min-w-[100px] lg:min-w-[125px] my-4`))) &&
            o(Bt, "class", Zt),
          ye[0] & 2097152)
        ) {
          zt = z[21];
          let vt;
          for (vt = 0; vt < zt.length; vt += 1) {
            const Al = _s(z, zt, vt);
            Je[vt]
              ? Je[vt].p(Al, ye)
              : ((Je[vt] = ps(Al)), Je[vt].c(), Je[vt].m(dt, null));
          }
          for (; vt < Je.length; vt += 1) Je[vt].d(1);
          Je.length = zt.length;
        }
        ye[0] & 2097156 && Et(dt, z[2]),
          (!Ye ||
            (ye[0] & 8 &&
              rl !==
                (rl = z[3]?.playerIds
                  ? z[3]?.playerIds.filter(ks).length === 0
                  : !0))) &&
            (Pt.disabled = rl),
          (!Ye ||
            (ye[0] & 8 &&
              nl !==
                (nl = `btn w-full md:w-auto md:text-xs xl:text-base px-4 py-2 rounded  
              ${
                z[3]?.playerIds && z[3]?.playerIds.filter(Es).length > 0
                  ? "fpl-purple-btn"
                  : "bg-gray-500"
              } text-white min-w-[125px]`))) &&
            o(Pt, "class", nl),
          (!Ye || (ye[0] & 262144 && ol !== (ol = !z[18]))) &&
            (ht.disabled = ol),
          (!Ye ||
            (ye[0] & 262144 &&
              Xt !==
                (Xt = `btn w-full md:w-auto md:text-xs xl:text-base px-4 py-2 rounded ${
                  z[18] ? "fpl-purple-btn" : "bg-gray-500"
                } text-white min-w-[125px]`))) &&
            o(ht, "class", Xt);
        let kt = _t;
        (_t = Gl(z)),
          _t === kt
            ? Lt[_t].p(z, ye)
            : (rt(),
              oe(Lt[kt], 1, 1, () => {
                Lt[kt] = null;
              }),
              nt(),
              (pt = Lt[_t]),
              pt ? pt.p(z, ye) : ((pt = Lt[_t] = Dl[_t](z)), pt.c()),
              te(pt, 1),
              pt.m(wt, Kt));
        const Jt = {};
        ye[0] & 2 && (Jt.activeGameweek = z[1]), St.$set(Jt);
      },
      i(z) {
        Ye ||
          (te(e.$$.fragment, z),
          te(pt),
          te(ze.$$.fragment, z),
          te(St.$$.fragment, z),
          (Ye = !0));
      },
      o(z) {
        oe(e.$$.fragment, z),
          oe(pt),
          oe(ze.$$.fragment, z),
          oe(St.$$.fragment, z),
          (Ye = !1);
      },
      d(z) {
        He(e, z),
          z && i(t),
          z && i(l),
          It(Je, z),
          Lt[_t].d(),
          He(ze),
          He(St),
          (gl = !1),
          Wl(Nl);
      },
    }
  );
}
function Er(a) {
  let e, t;
  return (
    (e = new Vs({})),
    {
      c() {
        Se(e.$$.fragment);
      },
      l(l) {
        je(e.$$.fragment, l);
      },
      m(l, r) {
        Le(e, l, r), (t = !0);
      },
      p: Ne,
      i(l) {
        t || (te(e.$$.fragment, l), (t = !0));
      },
      o(l) {
        oe(e.$$.fragment, l), (t = !1);
      },
      d(l) {
        He(e, l);
      },
    }
  );
}
function ps(a) {
  let e,
    t = a[82] + "",
    l,
    r;
  return {
    c() {
      (e = _("option")), (l = C(t)), this.h();
    },
    l(n) {
      e = p(n, "OPTION", {});
      var m = d(e);
      (l = T(m, t)), m.forEach(i), this.h();
    },
    h() {
      (e.__value = r = a[82]), (e.value = e.__value);
    },
    m(n, m) {
      X(n, e, m), s(e, l);
    },
    p(n, m) {
      m[0] & 2097152 && t !== (t = n[82] + "") && we(l, t),
        m[0] & 2097152 &&
          r !== (r = n[82]) &&
          ((e.__value = r), (e.value = e.__value));
    },
    d(n) {
      n && i(e);
    },
  };
}
function Ir(a) {
  let e,
    t,
    l,
    r = a[17],
    n = [];
  for (let f = 0; f < r.length; f += 1) n[f] = bs(us(a, r, f));
  const m = (f) =>
    oe(n[f], 1, 1, () => {
      n[f] = null;
    });
  return {
    c() {
      (e = _("div")), (t = _("div"));
      for (let f = 0; f < n.length; f += 1) n[f].c();
      this.h();
    },
    l(f) {
      e = p(f, "DIV", { class: !0 });
      var c = d(e);
      t = p(c, "DIV", { class: !0 });
      var u = d(t);
      for (let h = 0; h < n.length; h += 1) n[h].l(u);
      u.forEach(i), c.forEach(i), this.h();
    },
    h() {
      o(t, "class", "container-fluid"),
        o(e, "class", "bg-panel rounded-md m-4 flex-1");
    },
    m(f, c) {
      X(f, e, c), s(e, t);
      for (let u = 0; u < n.length; u += 1) n[u] && n[u].m(t, null);
      l = !0;
    },
    p(f, c) {
      if ((c[0] & 131128) | (c[1] & 57)) {
        r = f[17];
        let u;
        for (u = 0; u < r.length; u += 1) {
          const h = us(f, r, u);
          n[u]
            ? (n[u].p(h, c), te(n[u], 1))
            : ((n[u] = bs(h)), n[u].c(), te(n[u], 1), n[u].m(t, null));
        }
        for (rt(), u = r.length; u < n.length; u += 1) m(u);
        nt();
      }
    },
    i(f) {
      if (!l) {
        for (let c = 0; c < r.length; c += 1) te(n[c]);
        l = !0;
      }
    },
    o(f) {
      n = n.filter(Boolean);
      for (let c = 0; c < n.length; c += 1) oe(n[c]);
      l = !1;
    },
    d(f) {
      f && i(e), It(n, f);
    },
  };
}
function Cr(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c,
    u,
    h,
    v,
    b,
    E,
    x,
    g,
    y,
    w,
    V,
    k,
    G,
    D,
    $,
    B,
    H,
    R,
    ce,
    S,
    K,
    O;
  (E = new ss({ props: { className: "h-4 md:h-6 mr-1 md:mr-2" } })),
    (H = new ss({ props: { className: "h-4 md:h-6 mr-1 md:mr-2" } }));
  let ne = a[17],
    q = [];
  for (let j = 0; j < ne.length; j += 1) q[j] = ys(ms(a, ne, j));
  const le = (j) =>
    oe(q[j], 1, 1, () => {
      q[j] = null;
    });
  return {
    c() {
      (e = _("div")),
        (t = _("img")),
        (r = P()),
        (n = _("div")),
        (m = _("div")),
        (f = _("div")),
        (c = _("img")),
        (h = P()),
        (v = _("div")),
        (b = _("a")),
        Se(E.$$.fragment),
        (x = P()),
        (g = _("span")),
        (y = C("OpenChat")),
        (w = P()),
        (V = _("div")),
        (k = _("img")),
        (D = P()),
        ($ = _("div")),
        (B = _("a")),
        Se(H.$$.fragment),
        (R = P()),
        (ce = _("span")),
        (S = C("OpenChat")),
        (K = P());
      for (let j = 0; j < q.length; j += 1) q[j].c();
      this.h();
    },
    l(j) {
      e = p(j, "DIV", { class: !0 });
      var ae = d(e);
      (t = p(ae, "IMG", { src: !0, alt: !0, class: !0 })),
        (r = N(ae)),
        (n = p(ae, "DIV", { class: !0 }));
      var M = d(n);
      m = p(M, "DIV", { class: !0 });
      var L = d(m);
      f = p(L, "DIV", { class: !0 });
      var I = d(f);
      (c = p(I, "IMG", { class: !0, src: !0, alt: !0 })),
        (h = N(I)),
        (v = p(I, "DIV", { class: !0 }));
      var W = d(v);
      b = p(W, "A", { class: !0, target: !0, href: !0 });
      var Q = d(b);
      je(E.$$.fragment, Q), (x = N(Q)), (g = p(Q, "SPAN", { class: !0 }));
      var _e = d(g);
      (y = T(_e, "OpenChat")),
        _e.forEach(i),
        Q.forEach(i),
        W.forEach(i),
        I.forEach(i),
        (w = N(L)),
        (V = p(L, "DIV", { class: !0 }));
      var se = d(V);
      (k = p(se, "IMG", { class: !0, src: !0, alt: !0 })),
        (D = N(se)),
        ($ = p(se, "DIV", { class: !0 }));
      var Ce = d($);
      B = p(Ce, "A", { class: !0, target: !0, href: !0 });
      var Y = d(B);
      je(H.$$.fragment, Y), (R = N(Y)), (ce = p(Y, "SPAN", { class: !0 }));
      var U = d(ce);
      (S = T(U, "OpenChat")),
        U.forEach(i),
        Y.forEach(i),
        Ce.forEach(i),
        se.forEach(i),
        L.forEach(i),
        (K = N(M));
      for (let ee = 0; ee < q.length; ee += 1) q[ee].l(M);
      M.forEach(i), ae.forEach(i), this.h();
    },
    h() {
      cl(t.src, (l = "pitch.png")) || o(t, "src", l),
        o(t, "alt", "pitch"),
        o(t, "class", "w-full"),
        o(c, "class", "h-6 sm:h-8 md:h-12 m-0 md:m-1"),
        cl(c.src, (u = "board.png")) || o(c, "src", u),
        o(c, "alt", "OpenChat"),
        o(g, "class", "text-white text-xs md:text-xl mr-4 oc-logo"),
        o(
          b,
          "class",
          "flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
        ),
        o(b, "target", "_blank"),
        o(
          b,
          "href",
          "https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
        ),
        o(v, "class", "absolute top-0 left-0 w-full h-full"),
        o(f, "class", "relative inline-block"),
        o(k, "class", "h-6 sm:h-8 md:h-12 m-0 md:m-1"),
        cl(k.src, (G = "board.png")) || o(k, "src", G),
        o(k, "alt", "OpenChat"),
        o(ce, "class", "text-white text-xs md:text-xl mr-4 oc-logo"),
        o(
          B,
          "class",
          "flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
        ),
        o(B, "target", "_blank"),
        o(
          B,
          "href",
          "https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
        ),
        o($, "class", "absolute top-0 left-0 w-full h-full"),
        o(V, "class", "relative inline-block"),
        o(m, "class", "flex justify-around w-full h-auto"),
        o(n, "class", "absolute top-0 left-0 right-0 bottom-0"),
        o(e, "class", "relative w-full xl:w-1/2 mt-4");
    },
    m(j, ae) {
      X(j, e, ae),
        s(e, t),
        s(e, r),
        s(e, n),
        s(n, m),
        s(m, f),
        s(f, c),
        s(f, h),
        s(f, v),
        s(v, b),
        Le(E, b, null),
        s(b, x),
        s(b, g),
        s(g, y),
        s(m, w),
        s(m, V),
        s(V, k),
        s(V, D),
        s(V, $),
        s($, B),
        Le(H, B, null),
        s(B, R),
        s(B, ce),
        s(ce, S),
        s(n, K);
      for (let M = 0; M < q.length; M += 1) q[M] && q[M].m(n, null);
      O = !0;
    },
    p(j, ae) {
      if ((ae[0] & 131128) | (ae[1] & 57)) {
        ne = j[17];
        let M;
        for (M = 0; M < ne.length; M += 1) {
          const L = ms(j, ne, M);
          q[M]
            ? (q[M].p(L, ae), te(q[M], 1))
            : ((q[M] = ys(L)), q[M].c(), te(q[M], 1), q[M].m(n, null));
        }
        for (rt(), M = ne.length; M < q.length; M += 1) le(M);
        nt();
      }
    },
    i(j) {
      if (!O) {
        te(E.$$.fragment, j), te(H.$$.fragment, j);
        for (let ae = 0; ae < ne.length; ae += 1) te(q[ae]);
        O = !0;
      }
    },
    o(j) {
      oe(E.$$.fragment, j), oe(H.$$.fragment, j), (q = q.filter(Boolean));
      for (let ae = 0; ae < q.length; ae += 1) oe(q[ae]);
      O = !1;
    },
    d(j) {
      j && i(e), He(E), He(H), It(q, j);
    },
  };
}
function Tr(a) {
  let e, t, l, r, n, m, f, c, u, h, v, b, E, x, g;
  return {
    c() {
      (e = _("div")),
        (t = _("div")),
        (l = C("Goalkeeper")),
        (r = P()),
        (n = _("div")),
        (m = C("(c)")),
        (f = P()),
        (c = _("div")),
        (u = C("Team")),
        (h = P()),
        (v = _("div")),
        (b = C("Value")),
        (E = P()),
        (x = _("div")),
        (g = C(" ")),
        this.h();
    },
    l(y) {
      e = p(y, "DIV", { class: !0 });
      var w = d(e);
      t = p(w, "DIV", { class: !0 });
      var V = d(t);
      (l = T(V, "Goalkeeper")),
        V.forEach(i),
        (r = N(w)),
        (n = p(w, "DIV", { class: !0 }));
      var k = d(n);
      (m = T(k, "(c)")),
        k.forEach(i),
        (f = N(w)),
        (c = p(w, "DIV", { class: !0 }));
      var G = d(c);
      (u = T(G, "Team")),
        G.forEach(i),
        (h = N(w)),
        (v = p(w, "DIV", { class: !0 }));
      var D = d(v);
      (b = T(D, "Value")),
        D.forEach(i),
        (E = N(w)),
        (x = p(w, "DIV", { class: !0 }));
      var $ = d(x);
      (g = T($, " ")), $.forEach(i), w.forEach(i), this.h();
    },
    h() {
      o(t, "class", "w-1/3"),
        o(n, "class", "w-1/6"),
        o(c, "class", "w-1/3"),
        o(v, "class", "w-1/6"),
        o(x, "class", "w-1/6"),
        o(
          e,
          "class",
          "flex items-center justify-between py-2 bg-light-gray px-4"
        );
    },
    m(y, w) {
      X(y, e, w),
        s(e, t),
        s(t, l),
        s(e, r),
        s(e, n),
        s(n, m),
        s(e, f),
        s(e, c),
        s(c, u),
        s(e, h),
        s(e, v),
        s(v, b),
        s(e, E),
        s(e, x),
        s(x, g);
    },
    d(y) {
      y && i(e);
    },
  };
}
function Vr(a) {
  let e, t, l, r, n, m, f, c, u, h, v, b, E, x, g;
  return {
    c() {
      (e = _("div")),
        (t = _("div")),
        (l = C("Defenders")),
        (r = P()),
        (n = _("div")),
        (m = C("(c)")),
        (f = P()),
        (c = _("div")),
        (u = C("Team")),
        (h = P()),
        (v = _("div")),
        (b = C("Value")),
        (E = P()),
        (x = _("div")),
        (g = C(" ")),
        this.h();
    },
    l(y) {
      e = p(y, "DIV", { class: !0 });
      var w = d(e);
      t = p(w, "DIV", { class: !0 });
      var V = d(t);
      (l = T(V, "Defenders")),
        V.forEach(i),
        (r = N(w)),
        (n = p(w, "DIV", { class: !0 }));
      var k = d(n);
      (m = T(k, "(c)")),
        k.forEach(i),
        (f = N(w)),
        (c = p(w, "DIV", { class: !0 }));
      var G = d(c);
      (u = T(G, "Team")),
        G.forEach(i),
        (h = N(w)),
        (v = p(w, "DIV", { class: !0 }));
      var D = d(v);
      (b = T(D, "Value")),
        D.forEach(i),
        (E = N(w)),
        (x = p(w, "DIV", { class: !0 }));
      var $ = d(x);
      (g = T($, " ")), $.forEach(i), w.forEach(i), this.h();
    },
    h() {
      o(t, "class", "w-1/3"),
        o(n, "class", "w-1/6"),
        o(c, "class", "w-1/3"),
        o(v, "class", "w-1/6"),
        o(x, "class", "w-1/6"),
        o(
          e,
          "class",
          "flex items-center justify-between py-2 bg-light-gray px-4"
        );
    },
    m(y, w) {
      X(y, e, w),
        s(e, t),
        s(t, l),
        s(e, r),
        s(e, n),
        s(n, m),
        s(e, f),
        s(e, c),
        s(c, u),
        s(e, h),
        s(e, v),
        s(v, b),
        s(e, E),
        s(e, x),
        s(x, g);
    },
    d(y) {
      y && i(e);
    },
  };
}
function Pr(a) {
  let e, t, l, r, n, m, f, c, u, h, v, b, E, x, g;
  return {
    c() {
      (e = _("div")),
        (t = _("div")),
        (l = C("Midfielders")),
        (r = P()),
        (n = _("div")),
        (m = C("(c)")),
        (f = P()),
        (c = _("div")),
        (u = C("Team")),
        (h = P()),
        (v = _("div")),
        (b = C("Value")),
        (E = P()),
        (x = _("div")),
        (g = C(" ")),
        this.h();
    },
    l(y) {
      e = p(y, "DIV", { class: !0 });
      var w = d(e);
      t = p(w, "DIV", { class: !0 });
      var V = d(t);
      (l = T(V, "Midfielders")),
        V.forEach(i),
        (r = N(w)),
        (n = p(w, "DIV", { class: !0 }));
      var k = d(n);
      (m = T(k, "(c)")),
        k.forEach(i),
        (f = N(w)),
        (c = p(w, "DIV", { class: !0 }));
      var G = d(c);
      (u = T(G, "Team")),
        G.forEach(i),
        (h = N(w)),
        (v = p(w, "DIV", { class: !0 }));
      var D = d(v);
      (b = T(D, "Value")),
        D.forEach(i),
        (E = N(w)),
        (x = p(w, "DIV", { class: !0 }));
      var $ = d(x);
      (g = T($, " ")), $.forEach(i), w.forEach(i), this.h();
    },
    h() {
      o(t, "class", "w-1/3"),
        o(n, "class", "w-1/6"),
        o(c, "class", "w-1/3"),
        o(v, "class", "w-1/6"),
        o(x, "class", "w-1/6"),
        o(
          e,
          "class",
          "flex items-center justify-between py-2 bg-light-gray px-4"
        );
    },
    m(y, w) {
      X(y, e, w),
        s(e, t),
        s(t, l),
        s(e, r),
        s(e, n),
        s(n, m),
        s(e, f),
        s(e, c),
        s(c, u),
        s(e, h),
        s(e, v),
        s(v, b),
        s(e, E),
        s(e, x),
        s(x, g);
    },
    d(y) {
      y && i(e);
    },
  };
}
function Nr(a) {
  let e, t, l, r, n, m, f, c, u, h, v, b, E, x, g;
  return {
    c() {
      (e = _("div")),
        (t = _("div")),
        (l = C("Forwards")),
        (r = P()),
        (n = _("div")),
        (m = C("(c)")),
        (f = P()),
        (c = _("div")),
        (u = C("Team")),
        (h = P()),
        (v = _("div")),
        (b = C("Value")),
        (E = P()),
        (x = _("div")),
        (g = C(" ")),
        this.h();
    },
    l(y) {
      e = p(y, "DIV", { class: !0 });
      var w = d(e);
      t = p(w, "DIV", { class: !0 });
      var V = d(t);
      (l = T(V, "Forwards")),
        V.forEach(i),
        (r = N(w)),
        (n = p(w, "DIV", { class: !0 }));
      var k = d(n);
      (m = T(k, "(c)")),
        k.forEach(i),
        (f = N(w)),
        (c = p(w, "DIV", { class: !0 }));
      var G = d(c);
      (u = T(G, "Team")),
        G.forEach(i),
        (h = N(w)),
        (v = p(w, "DIV", { class: !0 }));
      var D = d(v);
      (b = T(D, "Value")),
        D.forEach(i),
        (E = N(w)),
        (x = p(w, "DIV", { class: !0 }));
      var $ = d(x);
      (g = T($, " ")), $.forEach(i), w.forEach(i), this.h();
    },
    h() {
      o(t, "class", "w-1/3"),
        o(n, "class", "w-1/6"),
        o(c, "class", "w-1/3"),
        o(v, "class", "w-1/6"),
        o(x, "class", "w-1/6"),
        o(
          e,
          "class",
          "flex items-center justify-between py-2 bg-light-gray px-4"
        );
    },
    m(y, w) {
      X(y, e, w),
        s(e, t),
        s(t, l),
        s(e, r),
        s(e, n),
        s(n, m),
        s(e, f),
        s(e, c),
        s(c, u),
        s(e, h),
        s(e, v),
        s(v, b),
        s(e, E),
        s(e, x),
        s(x, g);
    },
    d(y) {
      y && i(e);
    },
  };
}
function Dr(a) {
  let e, t, l, r, n, m, f, c, u, h, v, b, E, x, g, y, w, V;
  g = new Ps({ props: { className: "w-6 h-6 p-2" } });
  function k() {
    return a[48](a[71], a[78]);
  }
  return {
    c() {
      (e = _("div")),
        (t = C("-")),
        (l = P()),
        (r = _("div")),
        (n = C("-")),
        (m = P()),
        (f = _("div")),
        (c = C("-")),
        (u = P()),
        (h = _("div")),
        (v = C("-")),
        (b = P()),
        (E = _("div")),
        (x = _("button")),
        Se(g.$$.fragment),
        this.h();
    },
    l(G) {
      e = p(G, "DIV", { class: !0 });
      var D = d(e);
      (t = T(D, "-")),
        D.forEach(i),
        (l = N(G)),
        (r = p(G, "DIV", { class: !0 }));
      var $ = d(r);
      (n = T($, "-")),
        $.forEach(i),
        (m = N(G)),
        (f = p(G, "DIV", { class: !0 }));
      var B = d(f);
      (c = T(B, "-")),
        B.forEach(i),
        (u = N(G)),
        (h = p(G, "DIV", { class: !0 }));
      var H = d(h);
      (v = T(H, "-")),
        H.forEach(i),
        (b = N(G)),
        (E = p(G, "DIV", { class: !0 }));
      var R = d(E);
      x = p(R, "BUTTON", { class: !0 });
      var ce = d(x);
      je(g.$$.fragment, ce), ce.forEach(i), R.forEach(i), this.h();
    },
    h() {
      o(e, "class", "w-1/3"),
        o(r, "class", "w-1/6"),
        o(f, "class", "w-1/3"),
        o(h, "class", "w-1/6"),
        o(x, "class", "text-xl rounded fpl-button flex items-center"),
        o(E, "class", "w-1/6 flex items-center");
    },
    m(G, D) {
      X(G, e, D),
        s(e, t),
        X(G, l, D),
        X(G, r, D),
        s(r, n),
        X(G, m, D),
        X(G, f, D),
        s(f, c),
        X(G, u, D),
        X(G, h, D),
        s(h, v),
        X(G, b, D),
        X(G, E, D),
        s(E, x),
        Le(g, x, null),
        (y = !0),
        w || ((V = ke(x, "click", k)), (w = !0));
    },
    p(G, D) {
      a = G;
    },
    i(G) {
      y || (te(g.$$.fragment, G), (y = !0));
    },
    o(G) {
      oe(g.$$.fragment, G), (y = !1);
    },
    d(G) {
      G && i(e),
        G && i(l),
        G && i(r),
        G && i(m),
        G && i(f),
        G && i(u),
        G && i(h),
        G && i(b),
        G && i(E),
        He(g),
        (w = !1),
        V();
    },
  };
}
function Gr(a) {
  let e,
    t = a[76].firstName + "",
    l,
    r,
    n = a[76].lastName + "",
    m,
    f,
    c,
    u,
    h,
    v,
    b,
    E,
    x,
    g,
    y = a[79]?.name + "",
    w,
    V,
    k,
    G,
    D = (Number(a[76].value) / 4).toFixed(2) + "",
    $,
    B,
    H,
    R,
    ce,
    S,
    K,
    O,
    ne;
  const q = [Mr, Ar],
    le = [];
  function j(M, L) {
    return M[3]?.captainId === M[75] ? 0 : 1;
  }
  (u = j(a)),
    (h = le[u] = q[u](a)),
    (E = new Ml({
      props: {
        className: "h-5 w-5 mr-2",
        primaryColour: a[79]?.primaryColourHex,
        secondaryColour: a[79]?.secondaryColourHex,
        thirdColour: a[79]?.thirdColourHex,
      },
    })),
    (S = new Ns({ props: { className: "w-6 h-6 p-2" } }));
  function ae() {
    return a[47](a[76]);
  }
  return {
    c() {
      (e = _("div")),
        (l = C(t)),
        (r = P()),
        (m = C(n)),
        (f = P()),
        (c = _("div")),
        h.c(),
        (v = P()),
        (b = _("div")),
        Se(E.$$.fragment),
        (x = P()),
        (g = _("p")),
        (w = C(y)),
        (V = P()),
        (k = _("div")),
        (G = C("£")),
        ($ = C(D)),
        (B = C("m")),
        (H = P()),
        (R = _("div")),
        (ce = _("button")),
        Se(S.$$.fragment),
        this.h();
    },
    l(M) {
      e = p(M, "DIV", { class: !0 });
      var L = d(e);
      (l = T(L, t)),
        (r = N(L)),
        (m = T(L, n)),
        L.forEach(i),
        (f = N(M)),
        (c = p(M, "DIV", { class: !0 }));
      var I = d(c);
      h.l(I), I.forEach(i), (v = N(M)), (b = p(M, "DIV", { class: !0 }));
      var W = d(b);
      je(E.$$.fragment, W), (x = N(W)), (g = p(W, "P", {}));
      var Q = d(g);
      (w = T(Q, y)),
        Q.forEach(i),
        W.forEach(i),
        (V = N(M)),
        (k = p(M, "DIV", { class: !0 }));
      var _e = d(k);
      (G = T(_e, "£")),
        ($ = T(_e, D)),
        (B = T(_e, "m")),
        _e.forEach(i),
        (H = N(M)),
        (R = p(M, "DIV", { class: !0 }));
      var se = d(R);
      ce = p(se, "BUTTON", { class: !0 });
      var Ce = d(ce);
      je(S.$$.fragment, Ce), Ce.forEach(i), se.forEach(i), this.h();
    },
    h() {
      o(e, "class", "w-1/3"),
        o(c, "class", "w-1/6 flex items-center"),
        o(b, "class", "flex w-1/3 items-center"),
        o(k, "class", "w-1/6"),
        o(ce, "class", "bg-red-600 mb-1 rounded-sm"),
        o(R, "class", "w-1/6 flex items-center");
    },
    m(M, L) {
      X(M, e, L),
        s(e, l),
        s(e, r),
        s(e, m),
        X(M, f, L),
        X(M, c, L),
        le[u].m(c, null),
        X(M, v, L),
        X(M, b, L),
        Le(E, b, null),
        s(b, x),
        s(b, g),
        s(g, w),
        X(M, V, L),
        X(M, k, L),
        s(k, G),
        s(k, $),
        s(k, B),
        X(M, H, L),
        X(M, R, L),
        s(R, ce),
        Le(S, ce, null),
        (K = !0),
        O || ((ne = ke(ce, "click", ae)), (O = !0));
    },
    p(M, L) {
      (a = M),
        (!K || L[0] & 131096) && t !== (t = a[76].firstName + "") && we(l, t),
        (!K || L[0] & 131096) && n !== (n = a[76].lastName + "") && we(m, n);
      let I = u;
      (u = j(a)),
        u === I
          ? le[u].p(a, L)
          : (rt(),
            oe(le[I], 1, 1, () => {
              le[I] = null;
            }),
            nt(),
            (h = le[u]),
            h ? h.p(a, L) : ((h = le[u] = q[u](a)), h.c()),
            te(h, 1),
            h.m(c, null));
      const W = {};
      L[0] & 131128 && (W.primaryColour = a[79]?.primaryColourHex),
        L[0] & 131128 && (W.secondaryColour = a[79]?.secondaryColourHex),
        L[0] & 131128 && (W.thirdColour = a[79]?.thirdColourHex),
        E.$set(W),
        (!K || L[0] & 131128) && y !== (y = a[79]?.name + "") && we(w, y),
        (!K || L[0] & 131096) &&
          D !== (D = (Number(a[76].value) / 4).toFixed(2) + "") &&
          we($, D);
    },
    i(M) {
      K || (te(h), te(E.$$.fragment, M), te(S.$$.fragment, M), (K = !0));
    },
    o(M) {
      oe(h), oe(E.$$.fragment, M), oe(S.$$.fragment, M), (K = !1);
    },
    d(M) {
      M && i(e),
        M && i(f),
        M && i(c),
        le[u].d(),
        M && i(v),
        M && i(b),
        He(E),
        M && i(V),
        M && i(k),
        M && i(H),
        M && i(R),
        He(S),
        (O = !1),
        ne();
    },
  };
}
function Ar(a) {
  let e, t, l, r, n;
  t = new Ds({ props: { className: "w-6 h-6" } });
  function m() {
    return a[46](a[76]);
  }
  return {
    c() {
      (e = _("button")), Se(t.$$.fragment);
    },
    l(f) {
      e = p(f, "BUTTON", {});
      var c = d(e);
      je(t.$$.fragment, c), c.forEach(i);
    },
    m(f, c) {
      X(f, e, c),
        Le(t, e, null),
        (l = !0),
        r || ((n = ke(e, "click", m)), (r = !0));
    },
    p(f, c) {
      a = f;
    },
    i(f) {
      l || (te(t.$$.fragment, f), (l = !0));
    },
    o(f) {
      oe(t.$$.fragment, f), (l = !1);
    },
    d(f) {
      f && i(e), He(t), (r = !1), n();
    },
  };
}
function Mr(a) {
  let e, t, l;
  return (
    (t = new Gs({ props: { className: "w-6 h-6" } })),
    {
      c() {
        (e = _("span")), Se(t.$$.fragment);
      },
      l(r) {
        e = p(r, "SPAN", {});
        var n = d(e);
        je(t.$$.fragment, n), n.forEach(i);
      },
      m(r, n) {
        X(r, e, n), Le(t, e, null), (l = !0);
      },
      p: Ne,
      i(r) {
        l || (te(t.$$.fragment, r), (l = !0));
      },
      o(r) {
        oe(t.$$.fragment, r), (l = !1);
      },
      d(r) {
        r && i(e), He(t);
      },
    }
  );
}
function vs(a, e) {
  let t, l, r, n, m;
  const f = [Gr, Dr],
    c = [];
  function u(h, v) {
    return h[75] > 0 && h[76] ? 0 : 1;
  }
  return (
    (l = u(e)),
    (r = c[l] = f[l](e)),
    {
      key: a,
      first: null,
      c() {
        (t = _("div")), r.c(), (n = P()), this.h();
      },
      l(h) {
        t = p(h, "DIV", { class: !0 });
        var v = d(t);
        r.l(v), (n = N(v)), v.forEach(i), this.h();
      },
      h() {
        o(t, "class", "flex items-center justify-between py-2 px-4"),
          (this.first = t);
      },
      m(h, v) {
        X(h, t, v), c[l].m(t, null), s(t, n), (m = !0);
      },
      p(h, v) {
        e = h;
        let b = l;
        (l = u(e)),
          l === b
            ? c[l].p(e, v)
            : (rt(),
              oe(c[b], 1, 1, () => {
                c[b] = null;
              }),
              nt(),
              (r = c[l]),
              r ? r.p(e, v) : ((r = c[l] = f[l](e)), r.c()),
              te(r, 1),
              r.m(t, n));
      },
      i(h) {
        m || (te(r), (m = !0));
      },
      o(h) {
        oe(r), (m = !1);
      },
      d(h) {
        h && i(t), c[l].d();
      },
    }
  );
}
function bs(a) {
  let e,
    t,
    l,
    r,
    n = [],
    m = new As(),
    f,
    c,
    u = a[71] === 0 && Tr(),
    h = a[71] === 1 && Vr(),
    v = a[71] === 2 && Pr(),
    b = a[71] === 3 && Nr(),
    E = a[69];
  const x = (g) => g[78];
  for (let g = 0; g < E.length; g += 1) {
    let y = ds(a, E, g),
      w = x(y);
    m.set(w, (n[g] = vs(w, y)));
  }
  return {
    c() {
      u && u.c(),
        (e = P()),
        h && h.c(),
        (t = P()),
        v && v.c(),
        (l = P()),
        b && b.c(),
        (r = P());
      for (let g = 0; g < n.length; g += 1) n[g].c();
      f = Yt();
    },
    l(g) {
      u && u.l(g),
        (e = N(g)),
        h && h.l(g),
        (t = N(g)),
        v && v.l(g),
        (l = N(g)),
        b && b.l(g),
        (r = N(g));
      for (let y = 0; y < n.length; y += 1) n[y].l(g);
      f = Yt();
    },
    m(g, y) {
      u && u.m(g, y),
        X(g, e, y),
        h && h.m(g, y),
        X(g, t, y),
        v && v.m(g, y),
        X(g, l, y),
        b && b.m(g, y),
        X(g, r, y);
      for (let w = 0; w < n.length; w += 1) n[w] && n[w].m(g, y);
      X(g, f, y), (c = !0);
    },
    p(g, y) {
      (y[0] & 131128) | (y[1] & 57) &&
        ((E = g[69]),
        rt(),
        (n = Cs(n, y, x, 1, g, E, m, f.parentNode, Ts, vs, f, ds)),
        nt());
    },
    i(g) {
      if (!c) {
        for (let y = 0; y < E.length; y += 1) te(n[y]);
        c = !0;
      }
    },
    o(g) {
      for (let y = 0; y < n.length; y += 1) oe(n[y]);
      c = !1;
    },
    d(g) {
      u && u.d(g),
        g && i(e),
        h && h.d(g),
        g && i(t),
        v && v.d(g),
        g && i(l),
        b && b.d(g),
        g && i(r);
      for (let y = 0; y < n.length; y += 1) n[y].d(g);
      g && i(f);
    },
  };
}
function Br(a) {
  let e, t, l, r, n;
  t = new _r({
    props: { className: "h-12 sm:h-16 md:h-20 lg:h-24 xl:h-16 2xl:h-20" },
  });
  function m() {
    return a[44](a[71], a[78]);
  }
  return {
    c() {
      (e = _("button")), Se(t.$$.fragment), this.h();
    },
    l(f) {
      e = p(f, "BUTTON", { class: !0 });
      var c = d(e);
      je(t.$$.fragment, c), c.forEach(i), this.h();
    },
    h() {
      o(e, "class", "flex items-center");
    },
    m(f, c) {
      X(f, e, c),
        Le(t, e, null),
        (l = !0),
        r || ((n = ke(e, "click", m)), (r = !0));
    },
    p(f, c) {
      a = f;
    },
    i(f) {
      l || (te(t.$$.fragment, f), (l = !0));
    },
    o(f) {
      oe(t.$$.fragment, f), (l = !1);
    },
    d(f) {
      f && i(e), He(t), (r = !1), n();
    },
  };
}
function Fr(a) {
  let e,
    t,
    l,
    r,
    n,
    m,
    f,
    c,
    u,
    h,
    v,
    b,
    E,
    x,
    g,
    y = Pa(a[76].position) + "",
    w,
    V,
    k,
    G,
    D,
    $ = a[76].firstName.length > 2 ? a[76].firstName.substring(0, 1) + "." : "",
    B,
    H,
    R = a[76].lastName + "",
    ce,
    S,
    K,
    O,
    ne = a[79]?.abbreviatedName + "",
    q,
    le,
    j,
    ae,
    M,
    L,
    I = (Number(a[76].value) / 4).toFixed(2) + "",
    W,
    Q,
    _e,
    se,
    Ce;
  n = new Ns({ props: { className: "w-4 h-4 sm:w-6 sm:h-6 p-1" } });
  function Y() {
    return a[42](a[76]);
  }
  c = new Ls({
    props: {
      className: "h-8 sm:h-12 md:h-16 lg:h-20 xl:h-12 2xl:h-16",
      primaryColour: a[79]?.primaryColourHex,
      secondaryColour: a[79]?.secondaryColourHex,
      thirdColour: a[79]?.thirdColourHex,
    },
  });
  const U = [Sr, Or],
    ee = [];
  function Ee(me, F) {
    return me[3]?.captainId === me[75] ? 0 : 1;
  }
  (h = Ee(a)), (v = ee[h] = U[h](a));
  var he = Na(a[76].nationality);
  function Be(me) {
    return {
      props: { class: "h-2 w-2 mr-1 sm:h-4 sm:w-4 sm:mx-2 min-w-[15px]" },
    };
  }
  return (
    he && (k = Ta(he, Be())),
    (j = new Ml({
      props: {
        className: "h-4 w-4 sm:mx-1 min-w-[15px]",
        primaryColour: a[79]?.primaryColourHex,
        secondaryColour: a[79]?.secondaryColourHex,
        thirdColour: a[79]?.thirdColourHex,
      },
    })),
    {
      c() {
        (e = _("div")),
          (t = _("div")),
          (l = _("div")),
          (r = _("button")),
          Se(n.$$.fragment),
          (m = P()),
          (f = _("div")),
          Se(c.$$.fragment),
          (u = P()),
          v.c(),
          (b = P()),
          (E = _("div")),
          (x = _("div")),
          (g = _("p")),
          (w = C(y)),
          (V = P()),
          k && Se(k.$$.fragment),
          (G = P()),
          (D = _("p")),
          (B = C($)),
          (H = P()),
          (ce = C(R)),
          (S = P()),
          (K = _("div")),
          (O = _("p")),
          (q = C(ne)),
          (le = P()),
          Se(j.$$.fragment),
          (ae = P()),
          (M = _("p")),
          (L = C("£")),
          (W = C(I)),
          (Q = C("m")),
          this.h();
      },
      l(me) {
        e = p(me, "DIV", { class: !0 });
        var F = d(e);
        t = p(F, "DIV", { class: !0 });
        var be = d(t);
        l = p(be, "DIV", { class: !0 });
        var ge = d(l);
        r = p(ge, "BUTTON", { class: !0 });
        var Ie = d(r);
        je(n.$$.fragment, Ie),
          Ie.forEach(i),
          (m = N(ge)),
          (f = p(ge, "DIV", { class: !0 }));
        var De = d(f);
        je(c.$$.fragment, De),
          De.forEach(i),
          (u = N(ge)),
          v.l(ge),
          ge.forEach(i),
          be.forEach(i),
          (b = N(F)),
          (E = p(F, "DIV", { class: !0 }));
        var Ve = d(E);
        x = p(Ve, "DIV", { class: !0 });
        var Te = d(x);
        g = p(Te, "P", { class: !0 });
        var We = d(g);
        (w = T(We, y)),
          We.forEach(i),
          (V = N(Te)),
          k && je(k.$$.fragment, Te),
          (G = N(Te)),
          (D = p(Te, "P", { class: !0 }));
        var $e = d(D);
        (B = T($e, $)),
          (H = N($e)),
          (ce = T($e, R)),
          $e.forEach(i),
          Te.forEach(i),
          (S = N(Ve)),
          (K = p(Ve, "DIV", { class: !0 }));
        var Fe = d(K);
        O = p(Fe, "P", { class: !0 });
        var Ze = d(O);
        (q = T(Ze, ne)),
          Ze.forEach(i),
          (le = N(Fe)),
          je(j.$$.fragment, Fe),
          (ae = N(Fe)),
          (M = p(Fe, "P", { class: !0 }));
        var et = d(M);
        (L = T(et, "£")),
          (W = T(et, I)),
          (Q = T(et, "m")),
          et.forEach(i),
          Fe.forEach(i),
          Ve.forEach(i),
          F.forEach(i),
          this.h();
      },
      h() {
        o(r, "class", "bg-red-600 mb-1 rounded-sm"),
          o(f, "class", "flex justify-center items-center flex-grow"),
          o(l, "class", "flex justify-between items-end w-full"),
          o(t, "class", "flex justify-center items-center"),
          o(g, "class", "collapse sm:visible sm:min-w-[15px]"),
          o(D, "class", "truncate min-w-[50px] max-w-[50px]"),
          o(
            x,
            "class",
            "flex justify-center items-center bg-gray-700 md:px-2 py-1 rounded-t-md min-w-[80px] max-w-[80px] sm:min-w-[120px] sm:max-w-[120px]"
          ),
          o(O, "class", "collapse sm:visible sm:min-w-[20px]"),
          o(M, "class", "truncate min-w-[50px] max-w-[50px]"),
          o(
            K,
            "class",
            "flex justify-center items-center bg-white text-black md:px-2 py-1 rounded-b-md min-w-[80px] max-w-[80px] sm:min-w-[120px] sm:max-w-[120px]"
          ),
          o(E, "class", "flex flex-col justify-center items-center text-xs"),
          o(e, "class", "flex flex-col items-center text-center");
      },
      m(me, F) {
        X(me, e, F),
          s(e, t),
          s(t, l),
          s(l, r),
          Le(n, r, null),
          s(l, m),
          s(l, f),
          Le(c, f, null),
          s(l, u),
          ee[h].m(l, null),
          s(e, b),
          s(e, E),
          s(E, x),
          s(x, g),
          s(g, w),
          s(x, V),
          k && Le(k, x, null),
          s(x, G),
          s(x, D),
          s(D, B),
          s(D, H),
          s(D, ce),
          s(E, S),
          s(E, K),
          s(K, O),
          s(O, q),
          s(K, le),
          Le(j, K, null),
          s(K, ae),
          s(K, M),
          s(M, L),
          s(M, W),
          s(M, Q),
          (_e = !0),
          se || ((Ce = ke(r, "click", Y)), (se = !0));
      },
      p(me, F) {
        a = me;
        const be = {};
        F[0] & 131128 && (be.primaryColour = a[79]?.primaryColourHex),
          F[0] & 131128 && (be.secondaryColour = a[79]?.secondaryColourHex),
          F[0] & 131128 && (be.thirdColour = a[79]?.thirdColourHex),
          c.$set(be);
        let ge = h;
        if (
          ((h = Ee(a)),
          h === ge
            ? ee[h].p(a, F)
            : (rt(),
              oe(ee[ge], 1, 1, () => {
                ee[ge] = null;
              }),
              nt(),
              (v = ee[h]),
              v ? v.p(a, F) : ((v = ee[h] = U[h](a)), v.c()),
              te(v, 1),
              v.m(l, null)),
          (!_e || F[0] & 131096) &&
            y !== (y = Pa(a[76].position) + "") &&
            we(w, y),
          F[0] & 131096 && he !== (he = Na(a[76].nationality)))
        ) {
          if (k) {
            rt();
            const De = k;
            oe(De.$$.fragment, 1, 0, () => {
              He(De, 1);
            }),
              nt();
          }
          he
            ? ((k = Ta(he, Be())),
              Se(k.$$.fragment),
              te(k.$$.fragment, 1),
              Le(k, x, G))
            : (k = null);
        }
        (!_e || F[0] & 131096) &&
          $ !==
            ($ =
              a[76].firstName.length > 2
                ? a[76].firstName.substring(0, 1) + "."
                : "") &&
          we(B, $),
          (!_e || F[0] & 131096) &&
            R !== (R = a[76].lastName + "") &&
            we(ce, R),
          (!_e || F[0] & 131128) &&
            ne !== (ne = a[79]?.abbreviatedName + "") &&
            we(q, ne);
        const Ie = {};
        F[0] & 131128 && (Ie.primaryColour = a[79]?.primaryColourHex),
          F[0] & 131128 && (Ie.secondaryColour = a[79]?.secondaryColourHex),
          F[0] & 131128 && (Ie.thirdColour = a[79]?.thirdColourHex),
          j.$set(Ie),
          (!_e || F[0] & 131096) &&
            I !== (I = (Number(a[76].value) / 4).toFixed(2) + "") &&
            we(W, I);
      },
      i(me) {
        _e ||
          (te(n.$$.fragment, me),
          te(c.$$.fragment, me),
          te(v),
          k && te(k.$$.fragment, me),
          te(j.$$.fragment, me),
          (_e = !0));
      },
      o(me) {
        oe(n.$$.fragment, me),
          oe(c.$$.fragment, me),
          oe(v),
          k && oe(k.$$.fragment, me),
          oe(j.$$.fragment, me),
          (_e = !1);
      },
      d(me) {
        me && i(e), He(n), He(c), ee[h].d(), k && He(k), He(j), (se = !1), Ce();
      },
    }
  );
}
function Or(a) {
  let e, t, l, r, n;
  t = new Ds({ props: { className: "w-4 h-4 sm:w-7 sm:h-7 md:w-6 md:h-6" } });
  function m() {
    return a[43](a[76]);
  }
  return {
    c() {
      (e = _("button")), Se(t.$$.fragment), this.h();
    },
    l(f) {
      e = p(f, "BUTTON", { class: !0 });
      var c = d(e);
      je(t.$$.fragment, c), c.forEach(i), this.h();
    },
    h() {
      o(e, "class", "mb-1");
    },
    m(f, c) {
      X(f, e, c),
        Le(t, e, null),
        (l = !0),
        r || ((n = ke(e, "click", m)), (r = !0));
    },
    p(f, c) {
      a = f;
    },
    i(f) {
      l || (te(t.$$.fragment, f), (l = !0));
    },
    o(f) {
      oe(t.$$.fragment, f), (l = !1);
    },
    d(f) {
      f && i(e), He(t), (r = !1), n();
    },
  };
}
function Sr(a) {
  let e, t, l;
  return (
    (t = new Gs({
      props: { className: "w-4 h-4 sm:w-7 sm:h-7 md:w-6 md:h-6" },
    })),
    {
      c() {
        (e = _("span")), Se(t.$$.fragment), this.h();
      },
      l(r) {
        e = p(r, "SPAN", { class: !0 });
        var n = d(e);
        je(t.$$.fragment, n), n.forEach(i), this.h();
      },
      h() {
        o(e, "class", "mb-1");
      },
      m(r, n) {
        X(r, e, n), Le(t, e, null), (l = !0);
      },
      p: Ne,
      i(r) {
        l || (te(t.$$.fragment, r), (l = !0));
      },
      o(r) {
        oe(t.$$.fragment, r), (l = !1);
      },
      d(r) {
        r && i(e), He(t);
      },
    }
  );
}
function gs(a, e) {
  let t, l, r, n;
  const m = [Fr, Br],
    f = [];
  function c(h, v) {
    return h[75] > 0 && h[76] ? 0 : 1;
  }
  function u(h, v) {
    return v === 0 ? xr(h) : h;
  }
  return (
    (l = c(e)),
    (r = f[l] = m[l](u(e, l))),
    {
      key: a,
      first: null,
      c() {
        (t = _("div")), r.c(), this.h();
      },
      l(h) {
        t = p(h, "DIV", { class: !0 });
        var v = d(t);
        r.l(v), v.forEach(i), this.h();
      },
      h() {
        o(
          t,
          "class",
          "flex flex-col justify-center items-center flex-1 mt-2 mb-2 sm:mb-6 md:mb-12 lg:mb-16 xl:mb-6 2xl:mb-12"
        ),
          (this.first = t);
      },
      m(h, v) {
        X(h, t, v), f[l].m(t, null), (n = !0);
      },
      p(h, v) {
        e = h;
        let b = l;
        (l = c(e)),
          l === b
            ? f[l].p(u(e, l), v)
            : (rt(),
              oe(f[b], 1, 1, () => {
                f[b] = null;
              }),
              nt(),
              (r = f[l]),
              r ? r.p(u(e, l), v) : ((r = f[l] = m[l](u(e, l))), r.c()),
              te(r, 1),
              r.m(t, null));
      },
      i(h) {
        n || (te(r), (n = !0));
      },
      o(h) {
        oe(r), (n = !1);
      },
      d(h) {
        h && i(t), f[l].d();
      },
    }
  );
}
function ys(a) {
  let e,
    t = [],
    l = new As(),
    r,
    n,
    m = a[69];
  const f = (c) => c[78];
  for (let c = 0; c < m.length; c += 1) {
    let u = hs(a, m, c),
      h = f(u);
    l.set(h, (t[c] = gs(h, u)));
  }
  return {
    c() {
      e = _("div");
      for (let c = 0; c < t.length; c += 1) t[c].c();
      (r = P()), this.h();
    },
    l(c) {
      e = p(c, "DIV", { class: !0 });
      var u = d(e);
      for (let h = 0; h < t.length; h += 1) t[h].l(u);
      (r = N(u)), u.forEach(i), this.h();
    },
    h() {
      o(e, "class", "flex justify-around items-center w-full");
    },
    m(c, u) {
      X(c, e, u);
      for (let h = 0; h < t.length; h += 1) t[h] && t[h].m(e, null);
      s(e, r), (n = !0);
    },
    p(c, u) {
      (u[0] & 131128) | (u[1] & 57) &&
        ((m = c[69]),
        rt(),
        (t = Cs(t, u, f, 1, c, m, l, e, Ts, gs, r, hs)),
        nt());
    },
    i(c) {
      if (!n) {
        for (let u = 0; u < m.length; u += 1) te(t[u]);
        n = !0;
      }
    },
    o(c) {
      for (let u = 0; u < t.length; u += 1) oe(t[u]);
      n = !1;
    },
    d(c) {
      c && i(e);
      for (let u = 0; u < t.length; u += 1) t[u].d();
    },
  };
}
function Lr(a) {
  let e, t, l, r;
  const n = [Er, kr],
    m = [];
  function f(c, u) {
    return c[16] ? 0 : 1;
  }
  return (
    (e = f(a)),
    (t = m[e] = n[e](a)),
    {
      c() {
        t.c(), (l = Yt());
      },
      l(c) {
        t.l(c), (l = Yt());
      },
      m(c, u) {
        m[e].m(c, u), X(c, l, u), (r = !0);
      },
      p(c, u) {
        let h = e;
        (e = f(c)),
          e === h
            ? m[e].p(c, u)
            : (rt(),
              oe(m[h], 1, 1, () => {
                m[h] = null;
              }),
              nt(),
              (t = m[e]),
              t ? t.p(c, u) : ((t = m[e] = n[e](c)), t.c()),
              te(t, 1),
              t.m(l.parentNode, l));
      },
      i(c) {
        r || (te(t), (r = !0));
      },
      o(c) {
        oe(t), (r = !1);
      },
      d(c) {
        m[e].d(c), c && i(l);
      },
    }
  );
}
function Hr(a) {
  let e, t;
  return (
    (e = new Bs({
      props: { $$slots: { default: [Lr] }, $$scope: { ctx: a } },
    })),
    {
      c() {
        Se(e.$$.fragment);
      },
      l(l) {
        je(e.$$.fragment, l);
      },
      m(l, r) {
        Le(e, l, r), (t = !0);
      },
      p(l, r) {
        const n = {};
        (r[0] & 4194303) | (r[2] & 8388608) &&
          (n.$$scope = { dirty: r, ctx: l }),
          e.$set(n);
      },
      i(l) {
        t || (te(e.$$.fragment, l), (t = !0));
      },
      o(l) {
        oe(e.$$.fragment, l), (t = !1);
      },
      d(l) {
        He(e, l);
      },
    }
  );
}
function ws(a) {
  const e = a.split("-").map(Number);
  return [
    [1],
    ...e.map((l) =>
      Array(l)
        .fill(0)
        .map((r, n) => n + 1)
    ),
  ];
}
function Ur(a) {
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
const xs = (a) => a > 0,
  ks = (a) => a === 0,
  Es = (a) => a === 0;
function jr(a, e, t) {
  let l, r, n, m, f, c, u, h, v;
  const b = {
      "3-4-3": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3] },
      "3-5-2": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3] },
      "4-3-3": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3] },
      "4-4-2": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3] },
      "4-5-1": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3] },
      "5-4-1": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3] },
      "5-3-2": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3] },
    },
    E = it(["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"]);
  il(a, E, (A) => t(21, (v = A)));
  let x = "-",
    g = -1,
    y = "-",
    w = "-",
    V = "00",
    k = "00",
    G = "00",
    D = "4-4-2",
    $ = -1,
    B = -1,
    H = !0,
    R = !1,
    ce = 0,
    S = !0,
    K = it([]);
  il(a, K, (A) => t(5, (h = A)));
  let O = it([]);
  il(a, O, (A) => t(4, (m = A)));
  let ne = it(null);
  il(a, ne, (A) => t(39, (u = A)));
  let q = [],
    le,
    j,
    ae;
  const M = it(null);
  il(a, M, (A) => t(3, (n = A)));
  const L = it(S ? 1 / 0 : 3);
  il(a, L, (A) => t(20, (c = A)));
  const I = it(1200);
  il(a, I, (A) => t(19, (f = A)));
  let W = !0;
  ea(async () => {
    try {
      await Rl.sync(),
        await Vl.sync(),
        await $l.sync(),
        (le = Rl.subscribe((ue) => {
          ne.set(ue);
        })),
        (j = Vl.subscribe((ue) => {
          K.set(ue);
        })),
        (ae = $l.subscribe((ue) => {
          O.set(ue);
        }));
      const A = localStorage.getItem("viewMode");
      A && t(13, (H = A === "pitch"));
      let Z = await Jl.getNextFixture(),
        ie = await Da.getFantasyTeam();
      M.set(ie);
      let re = n?.principalId ?? "";
      re.length > 0 && ((S = !1), I.set(Number(ie.bankBalance))),
        g > 1 && re.length > 0 && L.set(ie.transfersAvailable),
        M.update((ue) =>
          ue && (!ue.playerIds || ue.playerIds.length !== 11)
            ? { ...ue, playerIds: new Uint16Array(11).fill(0) }
            : ue
        ),
        t(6, (y = Fs(Number(Z?.kickOff)))),
        t(7, (w = Ql(Number(Z?.kickOff))));
      let fe = Os(Number(Z?.kickOff));
      t(8, (V = fe.days.toString())),
        t(9, (k = fe.hours.toString())),
        t(10, (G = fe.minutes.toString()));
    } catch (A) {
      Ul.show("Error fetching team details.", "error"),
        console.error("Error fetching team details:", A);
    } finally {
      t(16, (W = !1));
    }
  }),
    ta(() => {
      j?.(), ae?.(), le?.();
    });
  function Q(A) {
    const Z = { 0: 0, 1: 0, 2: 0, 3: 0 };
    A.playerIds.forEach((ie) => {
      const re = m.find((fe) => fe.id === ie);
      re && Z[re.position]++;
    });
    for (const ie of Object.keys(b)) {
      const re = b[ie].positions;
      let fe = !0;
      const ue = re.reduce((xe, Ge) => ((xe[Ge] = (xe[Ge] || 0) + 1), xe), {});
      for (const xe in ue)
        if (ue[xe] !== Z[xe]) {
          fe = !1;
          break;
        }
      if (fe) return ie;
    }
    return console.error("No valid formation found for the team"), D;
  }
  function _e() {
    t(13, (H = !0)), localStorage.setItem("viewMode", "pitch");
  }
  function se() {
    t(13, (H = !1)), localStorage.setItem("viewMode", "list");
  }
  function Ce(A, Z) {
    t(11, ($ = A)), t(12, (B = Z)), t(14, (R = !0));
  }
  function Y() {
    t(14, (R = !1));
  }
  function U(A) {
    if (n) {
      if (ee(A, n, D)) Ee(A, n, D);
      else {
        const Z = Be(n, A);
        me(n, Z), t(2, (D = Z)), Ee(A, n, Z);
      }
      !S && g > 1 && L.update((Z) => (Z > 0 ? Z - 1 : 0)),
        I.update((Z) => (Z - Number(A.value) > 0 ? Z - Number(A.value) : Z)),
        n.playerIds.includes(A.id) || q.push(A.id);
    }
  }
  function ee(A, Z, ie) {
    const re = { 0: 0, 1: 0, 2: 0, 3: 0 };
    Z.playerIds.forEach((ft) => {
      const Re = m.find((ut) => ut.id === ft);
      Re && re[Re.position]++;
    }),
      re[A.position]++;
    const [fe, ue, xe] = ie.split("-").map(Number),
      Ge = Math.max(0, fe - (re[1] || 0)),
      at = Math.max(0, ue - (re[2] || 0)),
      Xe = Math.max(0, xe - (re[3] || 0)),
      lt = Math.max(0, 1 - (re[0] || 0)),
      Oe = Ge + at + Xe + lt;
    return Object.values(re).reduce((ft, Re) => ft + Re, 0) + Oe <= 11;
  }
  function Ee(A, Z, ie) {
    const re = he(A.position, Z, ie);
    if (re === -1) {
      console.error("No available position to add the player.");
      return;
    }
    M.update((fe) => {
      if (!fe) return null;
      const ue = Uint16Array.from(fe.playerIds);
      return re < ue.length
        ? ((ue[re] = A.id), { ...fe, playerIds: ue })
        : (console.error(
            "Index out of bounds when attempting to add player to team."
          ),
          fe);
    }),
      Ie(n);
  }
  function he(A, Z, ie) {
    const re = b[ie].positions;
    for (let fe = 0; fe < re.length; fe++)
      if (re[fe] === A && Z.playerIds[fe] === 0) return fe;
    return -1;
  }
  function Be(A, Z) {
    const ie = { 0: 0, 1: 0, 2: 0, 3: 0 };
    A.playerIds.forEach((ue) => {
      const xe = m.find((Ge) => Ge.id === ue);
      xe && ie[xe.position]++;
    }),
      ie[Z.position]++;
    let re = null,
      fe = Number.MAX_SAFE_INTEGER;
    for (const ue of Object.keys(b)) {
      if (ue === D) continue;
      const xe = b[ue].positions;
      let Ge = { 0: 0, 1: 0, 2: 0, 3: 0 };
      xe.forEach((Xe) => {
        Ge[Xe]++;
      });
      const at = Object.keys(Ge).reduce((Xe, lt) => {
        const Oe = parseInt(lt);
        return Xe + Math.max(0, Ge[Oe] - ie[Oe]);
      }, 0);
      at < fe && Ge[Z.position] > ie[Z.position] - 1 && ((re = ue), (fe = at));
    }
    return re || (console.error("No valid formation found for the player"), D);
  }
  function me(A, Z) {
    const ie = b[Z].positions;
    let re = new Array(11).fill(0);
    A.playerIds.forEach((fe) => {
      const ue = m.find((xe) => xe.id === fe);
      if (ue) {
        for (let xe = 0; xe < ie.length; xe++)
          if (ie[xe] === ue.position && re[xe] === 0) {
            re[xe] = fe;
            break;
          }
      }
    }),
      (A.playerIds = re);
  }
  function F(A, Z) {
    return l.slice(0, A).reduce((re, fe) => re + fe.length, 0) + Z;
  }
  function be(A) {
    t(11, ($ = -1)),
      t(12, (B = -1)),
      M.update((Z) => {
        if (!Z) return null;
        const ie = Z.playerIds.indexOf(A);
        if (ie === -1) return console.error("Player not found in the team."), Z;
        const re = Uint16Array.from(Z.playerIds);
        return (
          (re[ie] = 0),
          q.includes(A) &&
            (!S && g > 1 && L.update((fe) => fe + 1),
            (q = q.filter((fe) => fe !== A))),
          I.update((fe) => fe + Number(m.find((ue) => ue.id === A)?.value)),
          { ...Z, playerIds: re }
        );
      }),
      Ie(n);
  }
  function ge(A) {
    t(11, ($ = -1)),
      t(12, (B = -1)),
      M.update((Z) => (Z ? { ...Z, captainId: A } : null));
  }
  function Ie(A) {
    if (
      !A.captainId ||
      A.captainId === 0 ||
      !A.playerIds.includes(A.captainId)
    ) {
      const Z = De(A);
      ge(Z);
    }
  }
  function De(A) {
    let Z = 0,
      ie = 0;
    return (
      A.playerIds.forEach((re) => {
        const fe = m.find((ue) => ue.id === re);
        fe && Number(fe.value) > Z && ((Z = Number(fe.value)), (ie = re));
      }),
      ie
    );
  }
  function Ve() {
    if (!n || !n.playerIds) return;
    const A = Ss(m, n);
    E.set(A);
  }
  function Te() {
    const A = n;
    if (A) {
      let Z = 0;
      A.playerIds.forEach((ie) => {
        const re = m.find((fe) => fe.id === ie);
        re && (Z += Number(re.value));
      }),
        t(15, (ce = Z / 4));
    }
  }
  function We() {
    const A = new Map();
    for (const Z of n?.playerIds || [])
      if (Z > 0) {
        const ie = m.find((re) => re.id === Z);
        if (
          ie &&
          (A.set(ie.teamId, (A.get(ie.teamId) || 0) + 1), A.get(ie.teamId) > 2)
        )
          return !1;
      }
    return !(
      !Ur(n) ||
      n?.playerIds.filter((Z) => Z > 0).length !== 11 ||
      f < 0 ||
      c < 0 ||
      !$e(n, D)
    );
  }
  function $e(A, Z) {
    const ie = { 0: 0, 1: 0, 2: 0, 3: 0 };
    A.playerIds.forEach((qe) => {
      const ft = m.find((Re) => Re.id === qe);
      ft && ie[ft.position]++;
    });
    const [re, fe, ue] = Z.split("-").map(Number),
      xe = Math.max(0, re - (ie[1] || 0)),
      Ge = Math.max(0, fe - (ie[2] || 0)),
      at = Math.max(0, ue - (ie[3] || 0)),
      Xe = Math.max(0, 1 - (ie[0] || 0)),
      lt = xe + Ge + at + Xe;
    return Object.values(ie).reduce((qe, ft) => qe + ft, 0) + lt <= 11;
  }
  function Fe() {
    if (!n || !m) return;
    let A = { ...n, playerIds: new Uint16Array(11) },
      Z = f;
    const ie = new Map();
    A.playerIds.forEach((ue) => {
      if (ue > 0) {
        const xe = m.find((Ge) => Ge.id === ue);
        xe && ie.set(xe.teamId, (ie.get(xe.teamId) || 0) + 1);
      }
    });
    let re = Array.from(new Set(m.map((ue) => ue.teamId))).filter(
      (ue) => ue > 0
    );
    re.sort(() => Math.random() - 0.5),
      b[D].positions.forEach((ue, xe) => {
        if (Z <= 0 || re.length === 0) return;
        const Ge = re.shift();
        if (Ge === void 0) return;
        const at = m.filter(
          (Oe) =>
            Oe.position === ue &&
            Oe.teamId === Ge &&
            !A.playerIds.includes(Oe.id) &&
            (ie.get(Oe.teamId) || 0) < 1
        );
        at.sort((Oe, qe) => Number(Oe.value) - Number(qe.value));
        const Xe = at.slice(0, Math.ceil(at.length / 2)),
          lt = Xe[Math.floor(Math.random() * Xe.length)];
        if (lt) {
          const Oe = Z - Number(lt.value);
          if (Oe < 0) return;
          (A.playerIds[xe] = lt.id),
            (Z = Oe),
            ie.set(lt.teamId, (ie.get(lt.teamId) || 0) + 1);
        }
      }),
      Z >= 0 && (M.set(A), I.set(Z));
  }
  async function Ze() {
    Va.set("Saving Fantasy Team"), t(16, (W = !0));
    let A = n;
    (A?.captainId === 0 || !A?.playerIds.includes(A?.captainId)) &&
      (A.captainId = De(A)),
      A?.safeHandsGameweek === g &&
        A?.safeHandsPlayerId !== A?.playerIds[0] &&
        (A.safeHandsPlayerId = A?.playerIds[0]),
      A?.captainFantasticGameweek === g &&
        A?.captainFantasticPlayerId !== A?.captainId &&
        (A.captainFantasticPlayerId = A?.captainId);
    try {
      await Da.saveFantasyTeam(A, g),
        Ul.show("Team saved successully!", "success");
    } catch (Z) {
      Ul.show("Error saving team.", "error"),
        console.error("Error saving team:", Z);
    } finally {
      t(16, (W = !1)), Va.set("Loading");
    }
  }
  function et() {
    (D = fl(this)), t(2, D), t(3, n);
  }
  const tt = (A, Z) => Z.id === A.teamId,
    Ue = (A) => be(A.id),
    bt = (A) => ge(A.id),
    Gt = (A, Z) => Ce(A, Z),
    Ct = (A, Z) => Z.id === A,
    gt = (A) => ge(A.id),
    At = (A) => be(A.id),
    Tt = (A, Z) => Ce(A, Z),
    Nt = (A, Z) => Z.id === A,
    ct = (A, Z) => Z.id === A?.teamId;
  return (
    (a.$$.update = () => {
      if (a.$$.dirty[0] & 12 && n) {
        ws(D);
        const A = Q(n);
        t(2, (D = A));
      }
      a.$$.dirty[0] & 4 && t(17, (l = ws(D))),
        a.$$.dirty[0] & 8 && O && n && (Ve(), Te()),
        (a.$$.dirty[0] & 56) | (a.$$.dirty[1] & 256) &&
          t(18, (r = u && h && m && n ? We() : !1)),
        (a.$$.dirty[0] & 3) | (a.$$.dirty[1] & 256) &&
          u &&
          (t(0, (x = u?.activeSeason.name ?? x)),
          t(1, (g = u?.activeGameweek ?? g)));
    }),
    [
      x,
      g,
      D,
      n,
      m,
      h,
      y,
      w,
      V,
      k,
      G,
      $,
      B,
      H,
      R,
      ce,
      W,
      l,
      r,
      f,
      c,
      v,
      E,
      K,
      O,
      ne,
      M,
      L,
      I,
      _e,
      se,
      Ce,
      Y,
      U,
      F,
      be,
      ge,
      Fe,
      Ze,
      u,
      et,
      tt,
      Ue,
      bt,
      Gt,
      Ct,
      gt,
      At,
      Tt,
      Nt,
      ct,
    ]
  );
}
class Xr extends Ht {
  constructor(e) {
    super(), Ut(this, e, jr, Hr, jt, {}, null, [-1, -1, -1]);
  }
}
export { Xr as component };