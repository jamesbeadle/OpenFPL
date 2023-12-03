import {
  v as $e,
  H as be,
  R as bt,
  U as ct,
  B as De,
  Y as dt,
  $ as Et,
  f as et,
  l as f,
  K as ft,
  r as H,
  a0 as He,
  h as i,
  J as It,
  s as je,
  d as le,
  a2 as lt,
  m,
  c as M,
  y as Me,
  P as Mt,
  b as ne,
  n as o,
  p as Oe,
  z as Pe,
  w as Pt,
  L as Q,
  i as qe,
  Q as Qe,
  S as Re,
  G as s,
  q as S,
  o as st,
  a as T,
  e as Te,
  g as te,
  a1 as tt,
  M as Tt,
  k as u,
  A as Ue,
  V as ut,
  u as We,
  T as wt,
  N as Xe,
  I as Ye,
  O as yt,
} from "../chunks/index.a8c54947.js";
import {
  k as Dt,
  a as Ie,
  L as kt,
  s as mt,
  m as Se,
  x as ue,
  e as Ut,
  t as Ze,
} from "../chunks/Layout.0e76e124.js";
import { M as Ct } from "../chunks/manager-gameweeks.a53f4a02.js";
import { w as at } from "../chunks/singletons.fdfa7ed0.js";
function Lt(a) {
  let t, e, l, n, c, d;
  return {
    c() {
      (t = tt("svg")), (e = tt("path")), (l = tt("path")), this.h();
    },
    l(p) {
      t = lt(p, "svg", {
        xmlns: !0,
        "aria-hidden": !0,
        class: !0,
        fill: !0,
        viewBox: !0,
        style: !0,
      });
      var r = m(t);
      (e = lt(r, "path", { d: !0 })),
        m(e).forEach(i),
        (l = lt(r, "path", { d: !0 })),
        m(l).forEach(i),
        r.forEach(i),
        this.h();
    },
    h() {
      o(
        e,
        "d",
        "M12.136.326A1.5 1.5 0 0 1 14 1.78V3h.5A1.5 1.5 0 0 1 16 4.5v9a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 13.5v-9a1.5 1.5 0 0 1 1.432-1.499L12.136.326zM5.562 3H13V1.78a.5.5 0 0 0-.621-.484L5.562 3zM1.5 4a.5.5 0 0 0-.5.5v9a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-13z"
      ),
        o(
          l,
          "d",
          "M3.5 2a.5.5 0 0 0-.5.5v10a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5v-10a.5.5 0 0 0-.5-.5h-9zM2 2.5A1.5 1.5 0 0 1 3.5 1h9A1.5 1.5 0 0 1 14 2.5v10a1.5 1.5 0 0 1-1.5 1.5h-9A1.5 1.5 0 0 1 2 12.5v-10zm9.5 3A1.5 1.5 0 0 1 13 7h1.5V3.5a1.5 1.5 0 0 0-1.5-1.5H9V4a1.5 1.5 0 0 1 1.5 1.5v1zm0 1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1z"
        ),
        o(t, "xmlns", "http://www.w3.org/2000/svg"),
        o(t, "aria-hidden", "true"),
        o(t, "class", (n = ct(a[0]) + " svelte-1qbujws")),
        o(t, "fill", "currentColor"),
        o(t, "viewBox", "0 0 16 16"),
        Oe(t, "--hover-color", a[3]),
        Oe(t, "cursor", "'pointer'");
    },
    m(p, r) {
      ne(p, t, r), s(t, e), s(t, l), c || ((d = Q(t, "click", a[4])), (c = !0));
    },
    p(p, [r]) {
      r & 1 && n !== (n = ct(p[0]) + " svelte-1qbujws") && o(t, "class", n),
        r & 8 && Oe(t, "--hover-color", p[3]);
    },
    i: be,
    o: be,
    d(p) {
      p && i(t), (c = !1), d();
    },
  };
}
function Vt(a, t, e) {
  let { className: l = "" } = t,
    { principalId: n = "" } = t,
    { onClick: c } = t,
    { hoverColor: d = "red" } = t;
  const p = () => c(n);
  return (
    (a.$$set = (r) => {
      "className" in r && e(0, (l = r.className)),
        "principalId" in r && e(1, (n = r.principalId)),
        "onClick" in r && e(2, (c = r.onClick)),
        "hoverColor" in r && e(3, (d = r.hoverColor));
    }),
    [l, n, c, d, p]
  );
}
class Nt extends Re {
  constructor(t) {
    super(),
      qe(this, t, Vt, Lt, je, {
        className: 0,
        principalId: 1,
        onClick: 2,
        hoverColor: 3,
      });
  }
}
function pt(a) {
  let t, e, l, n, c, d, p, r, h, b, g, k, w, y, v, E, P, z, N;
  return {
    c() {
      (t = u("div")),
        (e = u("div")),
        (l = u("div")),
        (n = u("h3")),
        (c = S("Update Display Name")),
        (d = T()),
        (p = u("form")),
        (r = u("div")),
        (h = u("input")),
        (b = T()),
        (g = u("div")),
        (k = u("button")),
        (w = S("Cancel")),
        (y = T()),
        (v = u("button")),
        (E = S("Update")),
        this.h();
    },
    l(F) {
      t = f(F, "DIV", { class: !0 });
      var R = m(t);
      e = f(R, "DIV", { class: !0 });
      var C = m(e);
      l = f(C, "DIV", { class: !0 });
      var B = m(l);
      n = f(B, "H3", { class: !0 });
      var U = m(n);
      (c = H(U, "Update Display Name")),
        U.forEach(i),
        (d = M(B)),
        (p = f(B, "FORM", {}));
      var D = m(p);
      r = f(D, "DIV", { class: !0 });
      var A = m(r);
      (h = f(A, "INPUT", { type: !0, class: !0, placeholder: !0 })),
        A.forEach(i),
        (b = M(D)),
        (g = f(D, "DIV", { class: !0 }));
      var q = m(g);
      k = f(q, "BUTTON", { class: !0 });
      var j = m(k);
      (w = H(j, "Cancel")),
        j.forEach(i),
        (y = M(q)),
        (v = f(q, "BUTTON", { class: !0, type: !0 }));
      var L = m(v);
      (E = H(L, "Update")),
        L.forEach(i),
        q.forEach(i),
        D.forEach(i),
        B.forEach(i),
        C.forEach(i),
        R.forEach(i),
        this.h();
    },
    h() {
      o(n, "class", "text-lg leading-6 font-medium mb-2"),
        o(h, "type", "text"),
        o(
          h,
          "class",
          "w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
        ),
        o(h, "placeholder", "New Username"),
        o(r, "class", "mt-4"),
        o(
          k,
          "class",
          "px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        ),
        o(
          v,
          "class",
          (P = `px-4 py-2 ${
            a[3] ? "bg-gray-500" : "fpl-purple-btn"
          } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`)
        ),
        o(v, "type", "submit"),
        (v.disabled = a[3]),
        o(g, "class", "items-center py-3 flex space-x-4"),
        o(l, "class", "mt-3 text-center"),
        o(
          e,
          "class",
          "relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
        ),
        o(
          t,
          "class",
          "fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
        );
    },
    m(F, R) {
      ne(F, t, R),
        s(t, e),
        s(e, l),
        s(l, n),
        s(n, c),
        s(l, d),
        s(l, p),
        s(p, r),
        s(r, h),
        ut(h, a[0]),
        s(p, b),
        s(p, g),
        s(g, k),
        s(k, w),
        s(g, y),
        s(g, v),
        s(v, E),
        z ||
          ((N = [
            Q(h, "input", a[9]),
            Q(k, "click", function () {
              Qe(a[2]) && a[2].apply(this, arguments);
            }),
            Q(p, "submit", Et(a[4])),
            Q(e, "click", bt(a[8])),
            Q(e, "keydown", a[5]),
            Q(t, "click", function () {
              Qe(a[2]) && a[2].apply(this, arguments);
            }),
            Q(t, "keydown", a[5]),
          ]),
          (z = !0));
    },
    p(F, R) {
      (a = F),
        R & 1 && h.value !== a[0] && ut(h, a[0]),
        R & 8 &&
          P !==
            (P = `px-4 py-2 ${
              a[3] ? "bg-gray-500" : "fpl-purple-btn"
            } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`) &&
          o(v, "class", P),
        R & 8 && (v.disabled = a[3]);
    },
    d(F) {
      F && i(t), (z = !1), Xe(N);
    },
  };
}
function Ft(a) {
  let t,
    e = a[1] && pt(a);
  return {
    c() {
      e && e.c(), (t = Te());
    },
    l(l) {
      e && e.l(l), (t = Te());
    },
    m(l, n) {
      e && e.m(l, n), ne(l, t, n);
    },
    p(l, [n]) {
      l[1]
        ? e
          ? e.p(l, n)
          : ((e = pt(l)), e.c(), e.m(t.parentNode, t))
        : e && (e.d(1), (e = null));
    },
    i: be,
    o: be,
    d(l) {
      e && e.d(l), l && i(t);
    },
  };
}
function Bt(a) {
  return a.length < 3 || a.length > 20 ? !1 : /^[a-zA-Z0-9 ]+$/.test(a);
}
function Ot(a, t, e) {
  let l,
    { showModal: n } = t,
    { closeModal: c } = t,
    { cancelModal: d } = t,
    { newUsername: p = "" } = t,
    { isLoading: r } = t;
  async function h() {
    e(6, (r = !0)), Se.set("Updating Display Name");
    try {
      await ue.updateUsername(p),
        ue.sync(),
        await c(),
        Ie.show("Display name updated.", "success");
    } catch (w) {
      Ie.show("Error updating username.", "error"),
        console.error("Error updating username:", w),
        d();
    } finally {
      e(6, (r = !1)), Se.set("Loading");
    }
  }
  function b(w) {
    !(w.target instanceof HTMLInputElement) && w.key === "Escape" && c();
  }
  function g(w) {
    wt.call(this, a, w);
  }
  function k() {
    (p = this.value), e(0, p);
  }
  return (
    (a.$$set = (w) => {
      "showModal" in w && e(1, (n = w.showModal)),
        "closeModal" in w && e(7, (c = w.closeModal)),
        "cancelModal" in w && e(2, (d = w.cancelModal)),
        "newUsername" in w && e(0, (p = w.newUsername)),
        "isLoading" in w && e(6, (r = w.isLoading));
    }),
    (a.$$.update = () => {
      a.$$.dirty & 1 && e(3, (l = !Bt(p)));
    }),
    [p, n, d, l, h, b, r, c, g, k]
  );
}
class St extends Re {
  constructor(t) {
    super(),
      qe(this, t, Ot, Ft, je, {
        showModal: 1,
        closeModal: 7,
        cancelModal: 2,
        newUsername: 0,
        isLoading: 6,
      });
  }
}
function _t(a, t, e) {
  const l = a.slice();
  return (l[12] = t[e]), l;
}
function ht(a) {
  let t,
    e,
    l,
    n,
    c,
    d,
    p,
    r,
    h,
    b,
    g,
    k,
    w,
    y,
    v,
    E,
    P,
    z,
    N,
    F,
    R,
    C,
    B,
    U,
    D,
    A,
    q,
    j = a[4],
    L = [];
  for (let O = 0; O < j.length; O += 1) L[O] = vt(_t(a, j, O));
  return {
    c() {
      (t = u("div")),
        (e = u("div")),
        (l = u("div")),
        (n = u("h3")),
        (c = S("Update Favourite Team")),
        (d = T()),
        (p = u("div")),
        (r = u("select")),
        (h = u("option")),
        (b = S("Select Team"));
      for (let O = 0; O < L.length; O += 1) L[O].c();
      (g = T()),
        (k = u("div")),
        (w = u("p")),
        (y = S("Warning")),
        (v = T()),
        (E = u("p")),
        (P = S("You can only set your favourite team once per season.")),
        (z = T()),
        (N = u("div")),
        (F = u("button")),
        (R = S("Cancel")),
        (C = T()),
        (B = u("button")),
        (U = S("Update")),
        this.h();
    },
    l(O) {
      t = f(O, "DIV", { class: !0 });
      var G = m(t);
      e = f(G, "DIV", { class: !0 });
      var _ = m(e);
      l = f(_, "DIV", { class: !0 });
      var V = m(l);
      n = f(V, "H3", { class: !0 });
      var Z = m(n);
      (c = H(Z, "Update Favourite Team")),
        Z.forEach(i),
        (d = M(V)),
        (p = f(V, "DIV", { class: !0 }));
      var ie = m(p);
      r = f(ie, "SELECT", { class: !0 });
      var fe = m(r);
      h = f(fe, "OPTION", {});
      var ae = m(h);
      (b = H(ae, "Select Team")), ae.forEach(i);
      for (let Y = 0; Y < L.length; Y += 1) L[Y].l(fe);
      fe.forEach(i),
        ie.forEach(i),
        V.forEach(i),
        (g = M(_)),
        (k = f(_, "DIV", { class: !0, role: !0 }));
      var X = m(k);
      w = f(X, "P", { class: !0 });
      var me = m(w);
      (y = H(me, "Warning")),
        me.forEach(i),
        (v = M(X)),
        (E = f(X, "P", { class: !0 }));
      var pe = m(E);
      (P = H(pe, "You can only set your favourite team once per season.")),
        pe.forEach(i),
        X.forEach(i),
        (z = M(_)),
        (N = f(_, "DIV", { class: !0 }));
      var ee = m(N);
      F = f(ee, "BUTTON", { class: !0 });
      var _e = m(F);
      (R = H(_e, "Cancel")),
        _e.forEach(i),
        (C = M(ee)),
        (B = f(ee, "BUTTON", { class: !0 }));
      var he = m(B);
      (U = H(he, "Update")),
        he.forEach(i),
        ee.forEach(i),
        _.forEach(i),
        G.forEach(i),
        this.h();
    },
    h() {
      o(n, "class", "text-lg leading-6 font-medium mb-2"),
        (h.__value = 0),
        (h.value = h.__value),
        o(r, "class", "w-full p-2 rounded-md fpl-dropdown"),
        a[0] === void 0 && It(() => a[10].call(r)),
        o(p, "class", "w-full border border-gray-500 mt-4 mb-2"),
        o(l, "class", "mt-3 text-center"),
        o(w, "class", "font-bold text-sm"),
        o(E, "class", "font-bold text-xs"),
        o(
          k,
          "class",
          "bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-1 mt-4"
        ),
        o(k, "role", "alert"),
        o(
          F,
          "class",
          "px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        ),
        o(
          B,
          "class",
          (D = `px-4 py-2 ${
            a[3] ? "bg-gray-500" : "fpl-purple-btn"
          } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`)
        ),
        (B.disabled = a[3]),
        o(N, "class", "items-center py-3 flex space-x-4"),
        o(
          e,
          "class",
          "relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
        ),
        o(
          t,
          "class",
          "fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
        );
    },
    m(O, G) {
      ne(O, t, G),
        s(t, e),
        s(e, l),
        s(l, n),
        s(n, c),
        s(l, d),
        s(l, p),
        s(p, r),
        s(r, h),
        s(h, b);
      for (let _ = 0; _ < L.length; _ += 1) L[_] && L[_].m(r, null);
      ft(r, a[0], !0),
        s(e, g),
        s(e, k),
        s(k, w),
        s(w, y),
        s(k, v),
        s(k, E),
        s(E, P),
        s(e, z),
        s(e, N),
        s(N, F),
        s(F, R),
        s(N, C),
        s(N, B),
        s(B, U),
        A ||
          ((q = [
            Q(r, "change", a[10]),
            Q(F, "click", function () {
              Qe(a[2]) && a[2].apply(this, arguments);
            }),
            Q(B, "click", a[5]),
            Q(e, "click", bt(a[9])),
            Q(e, "keydown", a[6]),
            Q(t, "click", function () {
              Qe(a[2]) && a[2].apply(this, arguments);
            }),
            Q(t, "keydown", a[6]),
          ]),
          (A = !0));
    },
    p(O, G) {
      if (((a = O), G & 16)) {
        j = a[4];
        let _;
        for (_ = 0; _ < j.length; _ += 1) {
          const V = _t(a, j, _);
          L[_] ? L[_].p(V, G) : ((L[_] = vt(V)), L[_].c(), L[_].m(r, null));
        }
        for (; _ < L.length; _ += 1) L[_].d(1);
        L.length = j.length;
      }
      G & 17 && ft(r, a[0]),
        G & 8 &&
          D !==
            (D = `px-4 py-2 ${
              a[3] ? "bg-gray-500" : "fpl-purple-btn"
            } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`) &&
          o(B, "class", D),
        G & 8 && (B.disabled = a[3]);
    },
    d(O) {
      O && i(t), Tt(L, O), (A = !1), Xe(q);
    },
  };
}
function vt(a) {
  let t,
    e = a[12].friendlyName + "",
    l,
    n;
  return {
    c() {
      (t = u("option")), (l = S(e)), this.h();
    },
    l(c) {
      t = f(c, "OPTION", {});
      var d = m(t);
      (l = H(d, e)), d.forEach(i), this.h();
    },
    h() {
      (t.__value = n = a[12].id), (t.value = t.__value);
    },
    m(c, d) {
      ne(c, t, d), s(t, l);
    },
    p(c, d) {
      d & 16 && e !== (e = c[12].friendlyName + "") && We(l, e),
        d & 16 &&
          n !== (n = c[12].id) &&
          ((t.__value = n), (t.value = t.__value));
    },
    d(c) {
      c && i(t);
    },
  };
}
function Ht(a) {
  let t,
    e = a[1] && ht(a);
  return {
    c() {
      e && e.c(), (t = Te());
    },
    l(l) {
      e && e.l(l), (t = Te());
    },
    m(l, n) {
      e && e.m(l, n), ne(l, t, n);
    },
    p(l, [n]) {
      l[1]
        ? e
          ? e.p(l, n)
          : ((e = ht(l)), e.c(), e.m(t.parentNode, t))
        : e && (e.d(1), (e = null));
    },
    i: be,
    o: be,
    d(l) {
      e && e.d(l), l && i(t);
    },
  };
}
function At(a, t, e) {
  let { showModal: l } = t,
    { closeModal: n } = t,
    { cancelModal: c } = t,
    { newFavouriteTeam: d = 0 } = t,
    { isLoading: p } = t,
    r = !0,
    h,
    b;
  st(async () => {
    await ue.sync(),
      await Ze.sync(),
      (b = Ze.subscribe((v) => {
        e(4, (h = v));
      }));
  }),
    yt(() => {
      b?.();
    });
  async function g() {
    e(7, (p = !0)), Se.set("Updating Favourite Club");
    try {
      await ue.updateFavouriteTeam(d),
        ue.sync(),
        await n(),
        Ie.show("Favourite team updated.", "success");
    } catch (v) {
      Ie.show("Error updating favourite team.", "error"),
        console.error("Error updating favourite team:", v),
        c();
    } finally {
      e(7, (p = !1)), Se.set("Loading");
    }
  }
  function k(v) {
    !(v.target instanceof HTMLInputElement) && v.key === "Escape" && n();
  }
  function w(v) {
    wt.call(this, a, v);
  }
  function y() {
    (d = Mt(this)), e(0, d), e(4, h);
  }
  return (
    (a.$$set = (v) => {
      "showModal" in v && e(1, (l = v.showModal)),
        "closeModal" in v && e(8, (n = v.closeModal)),
        "cancelModal" in v && e(2, (c = v.cancelModal)),
        "newFavouriteTeam" in v && e(0, (d = v.newFavouriteTeam)),
        "isLoading" in v && e(7, (p = v.isLoading));
    }),
    (a.$$.update = () => {
      a.$$.dirty & 1 && e(3, (r = d <= 0));
    }),
    [d, l, c, r, h, g, k, p, n, w, y]
  );
}
class zt extends Re {
  constructor(t) {
    super(),
      qe(this, t, At, Ht, je, {
        showModal: 1,
        closeModal: 8,
        cancelModal: 2,
        newFavouriteTeam: 0,
        isLoading: 7,
      });
  }
}
function Gt(a) {
  let t,
    e,
    l,
    n,
    c,
    d,
    p,
    r,
    h,
    b,
    g,
    k,
    w,
    y,
    v,
    E,
    P,
    z,
    N,
    F,
    R,
    C,
    B,
    U,
    D,
    A,
    q,
    j,
    L,
    O,
    G,
    _,
    V,
    Z,
    ie,
    fe,
    ae,
    X,
    me,
    pe,
    ee,
    _e,
    he,
    Y,
    re,
    ye,
    ke,
    ce,
    se,
    oe,
    Ce,
    Ee,
    W,
    $;
  (t = new St({
    props: {
      newUsername: a[0] ? a[0].displayName : "",
      showModal: a[1],
      closeModal: a[12],
      cancelModal: a[13],
      isLoading: a[5],
    },
  })),
    (l = new zt({
      props: {
        newFavouriteTeam: a[0] ? a[0].favouriteTeamId : 0,
        showModal: a[2],
        closeModal: a[15],
        cancelModal: a[16],
        isLoading: a[5],
      },
    }));
  let x = a[0] && gt(a);
  return {
    c() {
      Me(t.$$.fragment),
        (e = T()),
        Me(l.$$.fragment),
        (n = T()),
        (c = u("div")),
        x && x.c(),
        (d = T()),
        (p = u("div")),
        (r = u("div")),
        (h = u("div")),
        (b = u("div")),
        (g = u("div")),
        (k = u("img")),
        (y = T()),
        (v = u("div")),
        (E = u("p")),
        (P = S("ICP")),
        (z = T()),
        (N = u("p")),
        (F = S("0.00 ICP")),
        (R = T()),
        (C = u("div")),
        (B = u("img")),
        (D = T()),
        (A = u("div")),
        (q = u("p")),
        (j = S("FPL")),
        (L = T()),
        (O = u("p")),
        (G = S("0.00 FPL")),
        (_ = T()),
        (V = u("div")),
        (Z = u("img")),
        (fe = T()),
        (ae = u("div")),
        (X = u("p")),
        (me = S("ckBTC")),
        (pe = T()),
        (ee = u("p")),
        (_e = S("0.00 ckBTC")),
        (he = T()),
        (Y = u("div")),
        (re = u("img")),
        (ke = T()),
        (ce = u("div")),
        (se = u("p")),
        (oe = S("ckETH")),
        (Ce = T()),
        (Ee = u("p")),
        (W = S("0.00 ckETH")),
        this.h();
    },
    l(I) {
      Pe(t.$$.fragment, I),
        (e = M(I)),
        Pe(l.$$.fragment, I),
        (n = M(I)),
        (c = f(I, "DIV", { class: !0 }));
      var K = m(c);
      x && x.l(K), (d = M(K)), (p = f(K, "DIV", { class: !0 }));
      var ve = m(p);
      r = f(ve, "DIV", { class: !0 });
      var ge = m(r);
      h = f(ge, "DIV", { class: !0 });
      var J = m(h);
      b = f(J, "DIV", { class: !0 });
      var de = m(b);
      g = f(de, "DIV", { class: !0 });
      var Le = m(g);
      (k = f(Le, "IMG", { src: !0, alt: !0, class: !0 })),
        (y = M(Le)),
        (v = f(Le, "DIV", { class: !0 }));
      var Ve = m(v);
      E = f(Ve, "P", { class: !0 });
      var Ae = m(E);
      (P = H(Ae, "ICP")), Ae.forEach(i), (z = M(Ve)), (N = f(Ve, "P", {}));
      var ze = m(N);
      (F = H(ze, "0.00 ICP")),
        ze.forEach(i),
        Ve.forEach(i),
        Le.forEach(i),
        (R = M(de)),
        (C = f(de, "DIV", { class: !0 }));
      var Ne = m(C);
      (B = f(Ne, "IMG", { src: !0, alt: !0, class: !0 })),
        (D = M(Ne)),
        (A = f(Ne, "DIV", { class: !0 }));
      var Fe = m(A);
      q = f(Fe, "P", { class: !0 });
      var Ge = m(q);
      (j = H(Ge, "FPL")), Ge.forEach(i), (L = M(Fe)), (O = f(Fe, "P", {}));
      var xe = m(O);
      (G = H(xe, "0.00 FPL")),
        xe.forEach(i),
        Fe.forEach(i),
        Ne.forEach(i),
        (_ = M(de)),
        (V = f(de, "DIV", { class: !0 }));
      var we = m(V);
      (Z = f(we, "IMG", { src: !0, alt: !0, class: !0 })),
        (fe = M(we)),
        (ae = f(we, "DIV", { class: !0 }));
      var Be = m(ae);
      X = f(Be, "P", { class: !0 });
      var rt = m(X);
      (me = H(rt, "ckBTC")), rt.forEach(i), (pe = M(Be)), (ee = f(Be, "P", {}));
      var ot = m(ee);
      (_e = H(ot, "0.00 ckBTC")),
        ot.forEach(i),
        Be.forEach(i),
        we.forEach(i),
        (he = M(de)),
        (Y = f(de, "DIV", { class: !0 }));
      var Ke = m(Y);
      (re = f(Ke, "IMG", { src: !0, alt: !0, class: !0 })),
        (ke = M(Ke)),
        (ce = f(Ke, "DIV", { class: !0 }));
      var Je = m(ce);
      se = f(Je, "P", { class: !0 });
      var nt = m(se);
      (oe = H(nt, "ckETH")), nt.forEach(i), (Ce = M(Je)), (Ee = f(Je, "P", {}));
      var it = m(Ee);
      (W = H(it, "0.00 ckETH")),
        it.forEach(i),
        Je.forEach(i),
        Ke.forEach(i),
        de.forEach(i),
        J.forEach(i),
        ge.forEach(i),
        ve.forEach(i),
        K.forEach(i),
        this.h();
    },
    h() {
      He(k.src, (w = "ICPCoin.png")) || o(k, "src", w),
        o(k, "alt", "ICP"),
        o(k, "class", "h-12 w-12"),
        o(E, "class", "font-bold"),
        o(v, "class", "ml-4"),
        o(
          g,
          "class",
          "flex items-center p-4 rounded-lg shadow-md border border-gray-700"
        ),
        He(B.src, (U = "FPLCoin.png")) || o(B, "src", U),
        o(B, "alt", "FPL"),
        o(B, "class", "h-12 w-12"),
        o(q, "class", "font-bold"),
        o(A, "class", "ml-4"),
        o(
          C,
          "class",
          "flex items-center p-4 rounded-lg shadow-md border border-gray-700"
        ),
        He(Z.src, (ie = "ckBTCCoin.png")) || o(Z, "src", ie),
        o(Z, "alt", "ICP"),
        o(Z, "class", "h-12 w-12"),
        o(X, "class", "font-bold"),
        o(ae, "class", "ml-4"),
        o(
          V,
          "class",
          "flex items-center p-4 rounded-lg shadow-md border border-gray-700"
        ),
        He(re.src, (ye = "ckETHCoin.png")) || o(re, "src", ye),
        o(re, "alt", "ICP"),
        o(re, "class", "h-12 w-12"),
        o(se, "class", "font-bold"),
        o(ce, "class", "ml-4"),
        o(
          Y,
          "class",
          "flex items-center p-4 rounded-lg shadow-md border border-gray-700"
        ),
        o(b, "class", "grid grid-cols-1 md:grid-cols-4 gap-4"),
        o(h, "class", "mt-4 px-2"),
        o(r, "class", "w-full px-2 mb-4"),
        o(p, "class", "flex flex-wrap -mx-2 mt-4"),
        o(c, "class", "container mx-auto p-4");
    },
    m(I, K) {
      Ue(t, I, K),
        ne(I, e, K),
        Ue(l, I, K),
        ne(I, n, K),
        ne(I, c, K),
        x && x.m(c, null),
        s(c, d),
        s(c, p),
        s(p, r),
        s(r, h),
        s(h, b),
        s(b, g),
        s(g, k),
        s(g, y),
        s(g, v),
        s(v, E),
        s(E, P),
        s(v, z),
        s(v, N),
        s(N, F),
        s(b, R),
        s(b, C),
        s(C, B),
        s(C, D),
        s(C, A),
        s(A, q),
        s(q, j),
        s(A, L),
        s(A, O),
        s(O, G),
        s(b, _),
        s(b, V),
        s(V, Z),
        s(V, fe),
        s(V, ae),
        s(ae, X),
        s(X, me),
        s(ae, pe),
        s(ae, ee),
        s(ee, _e),
        s(b, he),
        s(b, Y),
        s(Y, re),
        s(Y, ke),
        s(Y, ce),
        s(ce, se),
        s(se, oe),
        s(ce, Ce),
        s(ce, Ee),
        s(Ee, W),
        ($ = !0);
    },
    p(I, K) {
      const ve = {};
      K & 1 && (ve.newUsername = I[0] ? I[0].displayName : ""),
        K & 2 && (ve.showModal = I[1]),
        K & 32 && (ve.isLoading = I[5]),
        t.$set(ve);
      const ge = {};
      K & 1 && (ge.newFavouriteTeam = I[0] ? I[0].favouriteTeamId : 0),
        K & 4 && (ge.showModal = I[2]),
        K & 32 && (ge.isLoading = I[5]),
        l.$set(ge),
        I[0]
          ? x
            ? (x.p(I, K), K & 1 && te(x, 1))
            : ((x = gt(I)), x.c(), te(x, 1), x.m(c, d))
          : x &&
            ($e(),
            le(x, 1, 1, () => {
              x = null;
            }),
            et());
    },
    i(I) {
      $ || (te(t.$$.fragment, I), te(l.$$.fragment, I), te(x), ($ = !0));
    },
    o(I) {
      le(t.$$.fragment, I), le(l.$$.fragment, I), le(x), ($ = !1);
    },
    d(I) {
      De(t, I), I && i(e), De(l, I), I && i(n), I && i(c), x && x.d();
    },
  };
}
function xt(a) {
  let t, e;
  return (
    (t = new kt({})),
    {
      c() {
        Me(t.$$.fragment);
      },
      l(l) {
        Pe(t.$$.fragment, l);
      },
      m(l, n) {
        Ue(t, l, n), (e = !0);
      },
      p: be,
      i(l) {
        e || (te(t.$$.fragment, l), (e = !0));
      },
      o(l) {
        le(t.$$.fragment, l), (e = !1);
      },
      d(l) {
        De(t, l);
      },
    }
  );
}
function gt(a) {
  let t,
    e,
    l,
    n,
    c,
    d,
    p,
    r,
    h,
    b,
    g,
    k,
    w,
    y,
    v,
    E,
    P,
    z,
    N = a[0]?.displayName + "",
    F,
    R,
    C,
    B,
    U,
    D,
    A,
    q,
    j,
    L,
    O,
    G,
    _,
    V,
    Z,
    ie,
    fe,
    ae,
    X,
    me,
    pe,
    ee,
    _e,
    he,
    Y,
    re,
    ye = a[0]?.principalId + "",
    ke,
    ce,
    se,
    oe,
    Ce,
    Ee;
  return (
    (se = new Nt({
      props: {
        onClick: a[17],
        principalId: a[0]?.principalId,
        className: "ml-2 w-4 h-4",
      },
    })),
    {
      c() {
        (t = u("div")),
          (e = u("div")),
          (l = u("div")),
          (n = u("img")),
          (d = T()),
          (p = u("div")),
          (r = u("button")),
          (h = S("Upload Photo")),
          (b = T()),
          (g = u("input")),
          (k = T()),
          (w = u("div")),
          (y = u("div")),
          (v = u("p")),
          (E = S("Display Name:")),
          (P = T()),
          (z = u("h2")),
          (F = S(N)),
          (R = T()),
          (C = u("button")),
          (B = S("Update")),
          (U = T()),
          (D = u("p")),
          (A = S("Favourite Team:")),
          (q = T()),
          (j = u("h2")),
          (L = S(a[7])),
          (O = T()),
          (G = u("button")),
          (_ = S("Update")),
          (Z = T()),
          (ie = u("p")),
          (fe = S("Joined:")),
          (ae = T()),
          (X = u("h2")),
          (me = S("August 2023")),
          (pe = T()),
          (ee = u("p")),
          (_e = S("Principal:")),
          (he = T()),
          (Y = u("div")),
          (re = u("h2")),
          (ke = S(ye)),
          (ce = T()),
          Me(se.$$.fragment),
          this.h();
      },
      l(W) {
        t = f(W, "DIV", { class: !0 });
        var $ = m(t);
        e = f($, "DIV", { class: !0 });
        var x = m(e);
        l = f(x, "DIV", { class: !0 });
        var I = m(l);
        (n = f(I, "IMG", { src: !0, alt: !0, class: !0 })),
          (d = M(I)),
          (p = f(I, "DIV", { class: !0 }));
        var K = m(p);
        r = f(K, "BUTTON", { class: !0 });
        var ve = m(r);
        (h = H(ve, "Upload Photo")),
          ve.forEach(i),
          (b = M(K)),
          (g = f(K, "INPUT", {
            type: !0,
            id: !0,
            accept: !0,
            style: !0,
            class: !0,
          })),
          K.forEach(i),
          I.forEach(i),
          x.forEach(i),
          (k = M($)),
          (w = f($, "DIV", { class: !0 }));
        var ge = m(w);
        y = f(ge, "DIV", { class: !0 });
        var J = m(y);
        v = f(J, "P", { class: !0 });
        var de = m(v);
        (E = H(de, "Display Name:")),
          de.forEach(i),
          (P = M(J)),
          (z = f(J, "H2", { class: !0 }));
        var Le = m(z);
        (F = H(Le, N)),
          Le.forEach(i),
          (R = M(J)),
          (C = f(J, "BUTTON", { class: !0 }));
        var Ve = m(C);
        (B = H(Ve, "Update")),
          Ve.forEach(i),
          (U = M(J)),
          (D = f(J, "P", { class: !0 }));
        var Ae = m(D);
        (A = H(Ae, "Favourite Team:")),
          Ae.forEach(i),
          (q = M(J)),
          (j = f(J, "H2", { class: !0 }));
        var ze = m(j);
        (L = H(ze, a[7])),
          ze.forEach(i),
          (O = M(J)),
          (G = f(J, "BUTTON", { class: !0 }));
        var Ne = m(G);
        (_ = H(Ne, "Update")),
          Ne.forEach(i),
          (Z = M(J)),
          (ie = f(J, "P", { class: !0 }));
        var Fe = m(ie);
        (fe = H(Fe, "Joined:")),
          Fe.forEach(i),
          (ae = M(J)),
          (X = f(J, "H2", { class: !0 }));
        var Ge = m(X);
        (me = H(Ge, "August 2023")),
          Ge.forEach(i),
          (pe = M(J)),
          (ee = f(J, "P", { class: !0 }));
        var xe = m(ee);
        (_e = H(xe, "Principal:")),
          xe.forEach(i),
          (he = M(J)),
          (Y = f(J, "DIV", { class: !0 }));
        var we = m(Y);
        re = f(we, "H2", { class: !0 });
        var Be = m(re);
        (ke = H(Be, ye)),
          Be.forEach(i),
          (ce = M(we)),
          Pe(se.$$.fragment, we),
          we.forEach(i),
          J.forEach(i),
          ge.forEach(i),
          $.forEach(i),
          this.h();
      },
      h() {
        He(n.src, (c = a[6])) || o(n, "src", c),
          o(n, "alt", "Profile"),
          o(n, "class", "w-100 md:w-80 mb-1 rounded-lg"),
          o(r, "class", "btn-file-upload fpl-button svelte-e6um5o"),
          o(g, "type", "file"),
          o(g, "id", "profile-image"),
          o(g, "accept", "image/*"),
          Oe(g, "opacity", "0"),
          Oe(g, "position", "absolute"),
          Oe(g, "left", "0"),
          Oe(g, "top", "0"),
          o(g, "class", "svelte-e6um5o"),
          o(p, "class", "file-upload-wrapper mt-4 svelte-e6um5o"),
          o(l, "class", "group"),
          o(e, "class", "w-full md:w-auto px-2 ml-4 md:ml-0"),
          o(v, "class", "text-xs mb-2"),
          o(z, "class", "text-2xl font-bold mb-2"),
          o(C, "class", "p-2 px-4 rounded fpl-button"),
          o(D, "class", "text-xs mb-2 mt-4"),
          o(j, "class", "text-2xl font-bold mb-2"),
          o(G, "class", "p-2 px-4 rounded fpl-button"),
          (G.disabled = V = a[4] > 1 && (a[0]?.favouriteTeamId ?? 0) > 0),
          o(ie, "class", "text-xs mb-2 mt-4"),
          o(X, "class", "text-2xl font-bold mb-2"),
          o(ee, "class", "text-xs mb-2 mt-4"),
          o(re, "class", "text-xs font-bold"),
          o(Y, "class", "flex items-center"),
          o(y, "class", "ml-4 p-4 rounded-lg"),
          o(w, "class", "w-full md:w-3/4 px-2 mb-4"),
          o(t, "class", "flex flex-wrap");
      },
      m(W, $) {
        ne(W, t, $),
          s(t, e),
          s(e, l),
          s(l, n),
          s(l, d),
          s(l, p),
          s(p, r),
          s(r, h),
          s(p, b),
          s(p, g),
          a[22](g),
          s(t, k),
          s(t, w),
          s(w, y),
          s(y, v),
          s(v, E),
          s(y, P),
          s(y, z),
          s(z, F),
          s(y, R),
          s(y, C),
          s(C, B),
          s(y, U),
          s(y, D),
          s(D, A),
          s(y, q),
          s(y, j),
          s(j, L),
          s(y, O),
          s(y, G),
          s(G, _),
          s(y, Z),
          s(y, ie),
          s(ie, fe),
          s(y, ae),
          s(y, X),
          s(X, me),
          s(y, pe),
          s(y, ee),
          s(ee, _e),
          s(y, he),
          s(y, Y),
          s(Y, re),
          s(re, ke),
          s(Y, ce),
          Ue(se, Y, null),
          (oe = !0),
          Ce ||
            ((Ee = [
              Q(r, "click", a[18]),
              Q(g, "change", a[19]),
              Q(C, "click", a[11]),
              Q(G, "click", a[14]),
            ]),
            (Ce = !0));
      },
      p(W, $) {
        (!oe || ($ & 64 && !He(n.src, (c = W[6])))) && o(n, "src", c),
          (!oe || $ & 1) && N !== (N = W[0]?.displayName + "") && We(F, N),
          (!oe || $ & 128) && We(L, W[7]),
          (!oe ||
            ($ & 17 &&
              V !== (V = W[4] > 1 && (W[0]?.favouriteTeamId ?? 0) > 0))) &&
            (G.disabled = V),
          (!oe || $ & 1) && ye !== (ye = W[0]?.principalId + "") && We(ke, ye);
        const x = {};
        $ & 1 && (x.principalId = W[0]?.principalId), se.$set(x);
      },
      i(W) {
        oe || (te(se.$$.fragment, W), (oe = !0));
      },
      o(W) {
        le(se.$$.fragment, W), (oe = !1);
      },
      d(W) {
        W && i(t), a[22](null), De(se), (Ce = !1), Xe(Ee);
      },
    }
  );
}
function Rt(a) {
  let t, e, l, n;
  const c = [xt, Gt],
    d = [];
  function p(r, h) {
    return r[5] ? 0 : 1;
  }
  return (
    (t = p(a)),
    (e = d[t] = c[t](a)),
    {
      c() {
        e.c(), (l = Te());
      },
      l(r) {
        e.l(r), (l = Te());
      },
      m(r, h) {
        d[t].m(r, h), ne(r, l, h), (n = !0);
      },
      p(r, [h]) {
        let b = t;
        (t = p(r)),
          t === b
            ? d[t].p(r, h)
            : ($e(),
              le(d[b], 1, 1, () => {
                d[b] = null;
              }),
              et(),
              (e = d[t]),
              e ? e.p(r, h) : ((e = d[t] = c[t](r)), e.c()),
              te(e, 1),
              e.m(l.parentNode, l));
      },
      i(r) {
        n || (te(e), (n = !0));
      },
      o(r) {
        le(e), (n = !1);
      },
      d(r) {
        d[t].d(r), r && i(l);
      },
    }
  );
}
function qt(a, t, e) {
  let l, n, c, d, p, r;
  Ye(a, Se, (_) => e(26, (c = _)));
  let h = at([]);
  Ye(a, h, (_) => e(20, (p = _)));
  let b = at(null);
  Ye(a, b, (_) => e(21, (r = _)));
  let g = at(null);
  Ye(a, g, (_) => e(0, (d = _)));
  let k = !1,
    w = !1,
    y,
    v = 1,
    E,
    P,
    z,
    N = !0;
  st(async () => {
    try {
      await Ze.sync(),
        await mt.sync(),
        await ue.sync(),
        (E = Ze.subscribe((_) => {
          h.set(_);
        })),
        (P = mt.subscribe((_) => {
          b.set(_);
        })),
        (z = ue.subscribe((_) => {
          F(_);
        }));
    } catch (_) {
      Ie.show("Error fetching profile detail.", "error"),
        console.error("Error fetching profile detail:", _);
    } finally {
      e(5, (N = !1));
    }
  }),
    yt(() => {
      E?.(), P?.();
    });
  function F(_) {
    _ && g.set(_);
  }
  function R() {
    e(1, (k = !0));
  }
  async function C() {
    const _ = await ue.getProfile();
    F(_), e(1, (k = !1));
  }
  function B() {
    e(1, (k = !1));
  }
  function U() {
    e(2, (w = !0));
  }
  async function D() {
    const _ = await ue.getProfile();
    F(_), e(2, (w = !1));
  }
  function A() {
    e(2, (w = !1));
  }
  function q(_) {
    navigator.clipboard.writeText(_).then(() => {
      Ie.show("Copied!", "success");
    });
  }
  function j() {
    y.click();
  }
  function L(_) {
    const V = _.target;
    if (V.files && V.files[0]) {
      const Z = V.files[0];
      if (Z.size > 1e3 * 1024) {
        alert("File size exceeds 1000KB");
        return;
      }
      O(Z);
    }
  }
  async function O(_) {
    dt(Se, (c = "Uploading Profile Image"), c), e(5, (N = !0));
    try {
      await ue.updateProfilePicture(_), ue.sync();
      const V = await ue.getProfile();
      if ((F(V), V && V.profilePicture && V.profilePicture.length > 0)) {
        const Z = new Blob([new Uint8Array(V.profilePicture)]);
        e(6, (l = URL.createObjectURL(Z)));
      }
      Ie.show("Profile image updated.", "success");
    } catch (V) {
      Ie.show("Error updating profile image", "error"),
        console.error("Error updating profile image", V);
    } finally {
      e(5, (N = !1)), dt(Se, (c = "Loading"), c);
    }
  }
  function G(_) {
    Pt[_ ? "unshift" : "push"](() => {
      (y = _), e(3, y);
    });
  }
  return (
    (a.$$.update = () => {
      a.$$.dirty & 1 &&
        e(
          6,
          (l =
            d && d?.profilePicture && d?.profilePicture?.length > 0
              ? URL.createObjectURL(
                  new Blob([new Uint8Array(d.profilePicture)])
                )
              : "profile_placeholder.png")
        ),
        a.$$.dirty & 2097152 && e(4, (v = r?.activeGameweek ?? 1)),
        a.$$.dirty & 1048577 &&
          e(
            7,
            (n =
              p.find((_) => _.id == d?.favouriteTeamId)?.friendlyName ??
              "Not Set")
          );
    }),
    [d, k, w, y, v, N, l, n, h, b, g, R, C, B, U, D, A, q, j, L, p, r, G]
  );
}
class jt extends Re {
  constructor(t) {
    super(), qe(this, t, qt, Rt, je, {});
  }
}
function Kt(a) {
  let t, e, l, n, c, d, p, r, h, b, g, k, w, y, v, E, P, z, N, F;
  const R = [Wt, Yt],
    C = [];
  function B(U, D) {
    return U[0] === "details" ? 0 : U[0] === "gameweeks" ? 1 : -1;
  }
  return (
    ~(E = B(a)) && (P = C[E] = R[E](a)),
    {
      c() {
        (t = u("div")),
          (e = u("div")),
          (l = u("ul")),
          (n = u("li")),
          (c = u("button")),
          (d = S("Details")),
          (h = T()),
          (b = u("li")),
          (g = u("button")),
          (k = S("Gameweeks")),
          (v = T()),
          P && P.c(),
          this.h();
      },
      l(U) {
        t = f(U, "DIV", { class: !0 });
        var D = m(t);
        e = f(D, "DIV", { class: !0 });
        var A = m(e);
        l = f(A, "UL", { class: !0 });
        var q = m(l);
        n = f(q, "LI", { class: !0 });
        var j = m(n);
        c = f(j, "BUTTON", { class: !0 });
        var L = m(c);
        (d = H(L, "Details")),
          L.forEach(i),
          j.forEach(i),
          (h = M(q)),
          (b = f(q, "LI", { class: !0 }));
        var O = m(b);
        g = f(O, "BUTTON", { class: !0 });
        var G = m(g);
        (k = H(G, "Gameweeks")),
          G.forEach(i),
          O.forEach(i),
          q.forEach(i),
          (v = M(A)),
          P && P.l(A),
          A.forEach(i),
          D.forEach(i),
          this.h();
      },
      h() {
        o(
          c,
          "class",
          (p = `p-2 ${a[0] === "details" ? "text-white" : "text-gray-400"}`)
        ),
          o(
            n,
            "class",
            (r = `mr-4 text-xs md:text-base ${
              a[0] === "details" ? "active-tab" : ""
            }`)
          ),
          o(
            g,
            "class",
            (w = `p-2 ${a[0] === "gameweeks" ? "text-white" : "text-gray-400"}`)
          ),
          o(
            b,
            "class",
            (y = `mr-4 text-xs md:text-base ${
              a[0] === "gameweeks" ? "active-tab" : ""
            }`)
          ),
          o(l, "class", "flex rounded-t-lg bg-light-gray px-4 pt-2"),
          o(e, "class", "bg-panel rounded-lg m-4"),
          o(t, "class", "m-4");
      },
      m(U, D) {
        ne(U, t, D),
          s(t, e),
          s(e, l),
          s(l, n),
          s(n, c),
          s(c, d),
          s(l, h),
          s(l, b),
          s(b, g),
          s(g, k),
          s(e, v),
          ~E && C[E].m(e, null),
          (z = !0),
          N || ((F = [Q(c, "click", a[4]), Q(g, "click", a[5])]), (N = !0));
      },
      p(U, D) {
        (!z ||
          (D & 1 &&
            p !==
              (p = `p-2 ${
                U[0] === "details" ? "text-white" : "text-gray-400"
              }`))) &&
          o(c, "class", p),
          (!z ||
            (D & 1 &&
              r !==
                (r = `mr-4 text-xs md:text-base ${
                  U[0] === "details" ? "active-tab" : ""
                }`))) &&
            o(n, "class", r),
          (!z ||
            (D & 1 &&
              w !==
                (w = `p-2 ${
                  U[0] === "gameweeks" ? "text-white" : "text-gray-400"
                }`))) &&
            o(g, "class", w),
          (!z ||
            (D & 1 &&
              y !==
                (y = `mr-4 text-xs md:text-base ${
                  U[0] === "gameweeks" ? "active-tab" : ""
                }`))) &&
            o(b, "class", y);
        let A = E;
        (E = B(U)),
          E === A
            ? ~E && C[E].p(U, D)
            : (P &&
                ($e(),
                le(C[A], 1, 1, () => {
                  C[A] = null;
                }),
                et()),
              ~E
                ? ((P = C[E]),
                  P ? P.p(U, D) : ((P = C[E] = R[E](U)), P.c()),
                  te(P, 1),
                  P.m(e, null))
                : (P = null));
      },
      i(U) {
        z || (te(P), (z = !0));
      },
      o(U) {
        le(P), (z = !1);
      },
      d(U) {
        U && i(t), ~E && C[E].d(), (N = !1), Xe(F);
      },
    }
  );
}
function Jt(a) {
  let t, e;
  return (
    (t = new kt({})),
    {
      c() {
        Me(t.$$.fragment);
      },
      l(l) {
        Pe(t.$$.fragment, l);
      },
      m(l, n) {
        Ue(t, l, n), (e = !0);
      },
      p: be,
      i(l) {
        e || (te(t.$$.fragment, l), (e = !0));
      },
      o(l) {
        le(t.$$.fragment, l), (e = !1);
      },
      d(l) {
        De(t, l);
      },
    }
  );
}
function Yt(a) {
  let t, e;
  return (
    (t = new Ct({ props: { viewGameweekDetail: a[3] } })),
    {
      c() {
        Me(t.$$.fragment);
      },
      l(l) {
        Pe(t.$$.fragment, l);
      },
      m(l, n) {
        Ue(t, l, n), (e = !0);
      },
      p: be,
      i(l) {
        e || (te(t.$$.fragment, l), (e = !0));
      },
      o(l) {
        le(t.$$.fragment, l), (e = !1);
      },
      d(l) {
        De(t, l);
      },
    }
  );
}
function Wt(a) {
  let t, e;
  return (
    (t = new jt({})),
    {
      c() {
        Me(t.$$.fragment);
      },
      l(l) {
        Pe(t.$$.fragment, l);
      },
      m(l, n) {
        Ue(t, l, n), (e = !0);
      },
      p: be,
      i(l) {
        e || (te(t.$$.fragment, l), (e = !0));
      },
      o(l) {
        le(t.$$.fragment, l), (e = !1);
      },
      d(l) {
        De(t, l);
      },
    }
  );
}
function Qt(a) {
  let t, e, l, n;
  const c = [Jt, Kt],
    d = [];
  function p(r, h) {
    return r[1] ? 0 : 1;
  }
  return (
    (t = p(a)),
    (e = d[t] = c[t](a)),
    {
      c() {
        e.c(), (l = Te());
      },
      l(r) {
        e.l(r), (l = Te());
      },
      m(r, h) {
        d[t].m(r, h), ne(r, l, h), (n = !0);
      },
      p(r, h) {
        let b = t;
        (t = p(r)),
          t === b
            ? d[t].p(r, h)
            : ($e(),
              le(d[b], 1, 1, () => {
                d[b] = null;
              }),
              et(),
              (e = d[t]),
              e ? e.p(r, h) : ((e = d[t] = c[t](r)), e.c()),
              te(e, 1),
              e.m(l.parentNode, l));
      },
      i(r) {
        n || (te(e), (n = !0));
      },
      o(r) {
        le(e), (n = !1);
      },
      d(r) {
        d[t].d(r), r && i(l);
      },
    }
  );
}
function Zt(a) {
  let t, e;
  return (
    (t = new Ut({
      props: { $$slots: { default: [Qt] }, $$scope: { ctx: a } },
    })),
    {
      c() {
        Me(t.$$.fragment);
      },
      l(l) {
        Pe(t.$$.fragment, l);
      },
      m(l, n) {
        Ue(t, l, n), (e = !0);
      },
      p(l, [n]) {
        const c = {};
        n & 67 && (c.$$scope = { dirty: n, ctx: l }), t.$set(c);
      },
      i(l) {
        e || (te(t.$$.fragment, l), (e = !0));
      },
      o(l) {
        le(t.$$.fragment, l), (e = !1);
      },
      d(l) {
        De(t, l);
      },
    }
  );
}
function Xt(a, t, e) {
  let l = "details",
    n = !0;
  st(async () => {
    e(1, (n = !1));
  });
  function c(h) {
    e(0, (l = h));
  }
  function d(h, b) {
    Dt(`/manager?id=${h}&gw=${b}`);
  }
  return [l, n, c, d, () => c("details"), () => c("gameweeks")];
}
class al extends Re {
  constructor(t) {
    super(), qe(this, t, Xt, Zt, je, {});
  }
}
export { al as component };