import { i as fe } from "../chunks/global-stores.803ba169.js";
import { w as zs } from "../chunks/index.8caf67b2.js";
import {
  $ as Ua,
  A as Ca,
  a as v,
  a0 as Ge,
  a1 as Ke,
  a6 as ks,
  B as Pa,
  b as X,
  c as D,
  d as Q,
  e as Ga,
  f as Fs,
  G as n,
  g as Z,
  h as c,
  H as ea,
  i as $a,
  J as js,
  K as Ds,
  k as l,
  l as m,
  L as V,
  m as d,
  M as qs,
  N as Se,
  n as t,
  O as Ls,
  o as ys,
  p as Ta,
  P as xs,
  Q as Be,
  q as P,
  r as R,
  R as Rs,
  s as Ja,
  S as Za,
  T as Os,
  U as He,
  u as pe,
  V as vs,
  v as ws,
  w as Vs,
  y as Aa,
  z as ha,
} from "../chunks/index.c7b38e5e.js";
import { r as Ws } from "../chunks/index.d7eb2526.js";
import { a as Gs, L as Us } from "../chunks/Layout.39e2a716.js";
import { M as Ms } from "../chunks/manager-gameweeks.bd195a5b.js";
import { s as Ts } from "../chunks/system-store.408d352e.js";
import { A as de, t as Ie } from "../chunks/team-store.a9afdac8.js";
import { a as _e, t as Qa } from "../chunks/toast-store.64ad2768.js";
function Ks() {
  const { subscribe: o, set: a, update: e } = zs(null);
  async function s(p) {
    try {
      return await (
        await de.createIdentityActor(_e, "bkyz2-fmaaa-aaaaa-qaaaq-cai")
      ).updateDisplayName(p);
    } catch (r) {
      throw (console.error("Error updating username:", r), r);
    }
  }
  async function i(p) {
    try {
      return await (
        await de.createIdentityActor(_e, "bkyz2-fmaaa-aaaaa-qaaaq-cai")
      ).updateFavouriteTeam(p);
    } catch (r) {
      throw (console.error("Error updating favourite team:", r), r);
    }
  }
  async function _() {
    try {
      const r = await (
        await de.createIdentityActor(_e, "bkyz2-fmaaa-aaaaa-qaaaq-cai")
      ).getProfileDTO();
      return a(r), r;
    } catch (p) {
      throw (console.error("Error getting profile:", p), p);
    }
  }
  async function f(p) {
    try {
      if (p.size > 1e3 * 1024) return null;
      const I = new FileReader();
      I.readAsArrayBuffer(p),
        (I.onloadend = async () => {
          const E = I.result,
            C = new Uint8Array(E);
          try {
            return await (
              await de.createIdentityActor(_e, "bkyz2-fmaaa-aaaaa-qaaaq-cai")
            ).updateProfilePicture(C);
          } catch (N) {
            console.error(N);
          }
        });
    } catch (r) {
      throw (console.error("Error updating username:", r), r);
    }
  }
  return {
    subscribe: o,
    updateUsername: s,
    updateFavouriteTeam: i,
    getProfile: _,
    updateProfilePicture: f,
  };
}
const Ne = Ks();
function Hs(o) {
  let a, e, s, i, _, f;
  return {
    c() {
      (a = Ge("svg")), (e = Ge("path")), (s = Ge("path")), this.h();
    },
    l(p) {
      a = Ke(p, "svg", {
        xmlns: !0,
        "aria-hidden": !0,
        class: !0,
        fill: !0,
        viewBox: !0,
        style: !0,
      });
      var r = d(a);
      (e = Ke(r, "path", { d: !0 })),
        d(e).forEach(c),
        (s = Ke(r, "path", { d: !0 })),
        d(s).forEach(c),
        r.forEach(c),
        this.h();
    },
    h() {
      t(
        e,
        "d",
        "M12.136.326A1.5 1.5 0 0 1 14 1.78V3h.5A1.5 1.5 0 0 1 16 4.5v9a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 13.5v-9a1.5 1.5 0 0 1 1.432-1.499L12.136.326zM5.562 3H13V1.78a.5.5 0 0 0-.621-.484L5.562 3zM1.5 4a.5.5 0 0 0-.5.5v9a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-13z"
      ),
        t(
          s,
          "d",
          "M3.5 2a.5.5 0 0 0-.5.5v10a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5v-10a.5.5 0 0 0-.5-.5h-9zM2 2.5A1.5 1.5 0 0 1 3.5 1h9A1.5 1.5 0 0 1 14 2.5v10a1.5 1.5 0 0 1-1.5 1.5h-9A1.5 1.5 0 0 1 2 12.5v-10zm9.5 3A1.5 1.5 0 0 1 13 7h1.5V3.5a1.5 1.5 0 0 0-1.5-1.5H9V4a1.5 1.5 0 0 1 1.5 1.5v1zm0 1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1z"
        ),
        t(a, "xmlns", "http://www.w3.org/2000/svg"),
        t(a, "aria-hidden", "true"),
        t(a, "class", (i = He(o[0]) + " svelte-1qfim5c")),
        t(a, "fill", "currentColor"),
        t(a, "viewBox", "0 0 16 16"),
        Ta(a, "--hover-color", o[3]),
        Ta(a, "cursor", "'pointer'");
    },
    m(p, r) {
      X(p, a, r), n(a, e), n(a, s), _ || ((f = V(a, "click", o[4])), (_ = !0));
    },
    p(p, [r]) {
      r & 1 && i !== (i = He(p[0]) + " svelte-1qfim5c") && t(a, "class", i),
        r & 8 && Ta(a, "--hover-color", p[3]);
    },
    i: ea,
    o: ea,
    d(p) {
      p && c(a), (_ = !1), f();
    },
  };
}
function Bs(o, a, e) {
  let { className: s = "" } = a,
    { principalId: i = "" } = a,
    { onClick: _ } = a,
    { hoverColor: f = "red" } = a;
  const p = () => _(i);
  return (
    (o.$$set = (r) => {
      "className" in r && e(0, (s = r.className)),
        "principalId" in r && e(1, (i = r.principalId)),
        "onClick" in r && e(2, (_ = r.onClick)),
        "hoverColor" in r && e(3, (f = r.hoverColor));
    }),
    [s, i, _, f, p]
  );
}
class Ys extends Za {
  constructor(a) {
    super(),
      $a(this, a, Bs, Hs, Ja, {
        className: 0,
        principalId: 1,
        onClick: 2,
        hoverColor: 3,
      });
  }
}
function As(o) {
  let a, e, s, i, _, f, p, r, I, E, C, N, O, M, K;
  return {
    c() {
      (a = l("div")),
        (e = l("div")),
        (s = l("div")),
        (i = l("h3")),
        (_ = P("Update Username")),
        (f = v()),
        (p = l("form")),
        (r = l("div")),
        (I = l("input")),
        (E = v()),
        (C = l("div")),
        (N = l("button")),
        (O = P("Update")),
        this.h();
    },
    l(S) {
      a = m(S, "DIV", { class: !0 });
      var T = d(a);
      e = m(T, "DIV", { class: !0 });
      var y = d(e);
      s = m(y, "DIV", { class: !0 });
      var b = d(s);
      i = m(b, "H3", { class: !0 });
      var F = d(i);
      (_ = R(F, "Update Username")),
        F.forEach(c),
        (f = D(b)),
        (p = m(b, "FORM", {}));
      var G = d(p);
      r = m(G, "DIV", { class: !0 });
      var k = d(r);
      (I = m(k, "INPUT", { type: !0, class: !0, placeholder: !0 })),
        k.forEach(c),
        (E = D(G)),
        (C = m(G, "DIV", { class: !0 }));
      var j = d(C);
      N = m(j, "BUTTON", { type: !0, class: !0 });
      var u = d(N);
      (O = R(u, "Update")),
        u.forEach(c),
        j.forEach(c),
        G.forEach(c),
        b.forEach(c),
        y.forEach(c),
        T.forEach(c),
        this.h();
    },
    h() {
      t(i, "class", "text-lg leading-6 font-medium"),
        t(I, "type", "text"),
        t(
          I,
          "class",
          "w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
        ),
        t(I, "placeholder", "New Username"),
        t(r, "class", "mt-4"),
        t(N, "type", "submit"),
        t(
          N,
          "class",
          "px-4 py-2 bg-blue-500 hover:bg-blue-700 rounded-md text-white"
        ),
        t(C, "class", "mt-4"),
        t(s, "class", "mt-3 text-center"),
        t(
          e,
          "class",
          "relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
        ),
        t(
          a,
          "class",
          "fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop svelte-18qswye"
        );
    },
    m(S, T) {
      X(S, a, T),
        n(a, e),
        n(e, s),
        n(s, i),
        n(i, _),
        n(s, f),
        n(s, p),
        n(p, r),
        n(r, I),
        vs(I, o[0]),
        n(p, E),
        n(p, C),
        n(C, N),
        n(N, O),
        M ||
          ((K = [
            V(I, "input", o[6]),
            V(p, "submit", ks(o[3])),
            V(e, "click", Rs(o[5])),
            V(e, "keydown", o[4]),
            V(a, "click", function () {
              Be(o[2]) && o[2].apply(this, arguments);
            }),
            V(a, "keydown", o[4]),
          ]),
          (M = !0));
    },
    p(S, T) {
      (o = S), T & 1 && I.value !== o[0] && vs(I, o[0]);
    },
    d(S) {
      S && c(a), (M = !1), Se(K);
    },
  };
}
function Xs(o) {
  let a,
    e = o[1] && As(o);
  return {
    c() {
      e && e.c(), (a = Ga());
    },
    l(s) {
      e && e.l(s), (a = Ga());
    },
    m(s, i) {
      e && e.m(s, i), X(s, a, i);
    },
    p(s, [i]) {
      s[1]
        ? e
          ? e.p(s, i)
          : ((e = As(s)), e.c(), e.m(a.parentNode, a))
        : e && (e.d(1), (e = null));
    },
    i: ea,
    o: ea,
    d(s) {
      e && e.d(s), s && c(a);
    },
  };
}
function Qs(o, a, e) {
  let { showModal: s } = a,
    { closeModal: i } = a,
    { newUsername: _ } = a;
  async function f() {
    fe.set(!0);
    try {
      await Ne.updateUsername(_);
    } catch (E) {
      Qa.show("Error updating username.", "error"),
        console.error("Error updating username:", E);
    }
    fe.set(!0), i();
  }
  function p(E) {
    !(E.target instanceof HTMLInputElement) && E.key === "Escape" && i();
  }
  function r(E) {
    Os.call(this, o, E);
  }
  function I() {
    (_ = this.value), e(0, _);
  }
  return (
    (o.$$set = (E) => {
      "showModal" in E && e(1, (s = E.showModal)),
        "closeModal" in E && e(2, (i = E.closeModal)),
        "newUsername" in E && e(0, (_ = E.newUsername));
    }),
    [_, s, i, f, p, r, I]
  );
}
class Zs extends Za {
  constructor(a) {
    super(),
      $a(this, a, Qs, Xs, Ja, { showModal: 1, closeModal: 2, newUsername: 0 });
  }
}
function hs(o, a, e) {
  const s = o.slice();
  return (s[9] = a[e]), s;
}
function Cs(o) {
  let a,
    e,
    s,
    i,
    _,
    f,
    p,
    r,
    I,
    E,
    C,
    N,
    O,
    M,
    K,
    S,
    T,
    y,
    b,
    F,
    G,
    k,
    j,
    u,
    A,
    z,
    W = o[3],
    L = [];
  for (let w = 0; w < W.length; w += 1) L[w] = Ps(hs(o, W, w));
  return {
    c() {
      (a = l("div")),
        (e = l("div")),
        (s = l("div")),
        (i = l("h3")),
        (_ = P("Update Favourite Team")),
        (f = v()),
        (p = l("div")),
        (r = l("select")),
        (I = l("option")),
        (E = P("Select Team"));
      for (let w = 0; w < L.length; w += 1) L[w].c();
      (C = v()),
        (N = l("div")),
        (O = l("p")),
        (M = P("Warning")),
        (K = v()),
        (S = l("p")),
        (T = P("You can only set your favourite team once per season.")),
        (y = v()),
        (b = l("div")),
        (F = l("button")),
        (G = P("Cancel")),
        (k = v()),
        (j = l("button")),
        (u = P("Use")),
        this.h();
    },
    l(w) {
      a = m(w, "DIV", { class: !0 });
      var U = d(a);
      e = m(U, "DIV", { class: !0 });
      var h = d(e);
      s = m(h, "DIV", { class: !0 });
      var Y = d(s);
      i = m(Y, "H3", { class: !0 });
      var $ = d(i);
      (_ = R($, "Update Favourite Team")),
        $.forEach(c),
        (f = D(Y)),
        (p = m(Y, "DIV", { class: !0 }));
      var sa = d(p);
      r = m(sa, "SELECT", { class: !0 });
      var na = d(r);
      I = m(na, "OPTION", {});
      var Ra = d(I);
      (E = R(Ra, "Select Team")), Ra.forEach(c);
      for (let ua = 0; ua < L.length; ua += 1) L[ua].l(na);
      na.forEach(c),
        sa.forEach(c),
        Y.forEach(c),
        (C = D(h)),
        (N = m(h, "DIV", { class: !0, role: !0 }));
      var H = d(N);
      O = m(H, "P", { class: !0 });
      var Oa = d(O);
      (M = R(Oa, "Warning")),
        Oa.forEach(c),
        (K = D(H)),
        (S = m(H, "P", { class: !0 }));
      var Sa = d(S);
      (T = R(Sa, "You can only set your favourite team once per season.")),
        Sa.forEach(c),
        H.forEach(c),
        (y = D(h)),
        (b = m(h, "DIV", { class: !0 }));
      var oa = d(b);
      F = m(oa, "BUTTON", { class: !0 });
      var J = d(F);
      (G = R(J, "Cancel")),
        J.forEach(c),
        (k = D(oa)),
        (j = m(oa, "BUTTON", { class: !0 }));
      var ya = d(j);
      (u = R(ya, "Use")),
        ya.forEach(c),
        oa.forEach(c),
        h.forEach(c),
        U.forEach(c),
        this.h();
    },
    h() {
      t(i, "class", "text-lg leading-6 font-medium mb-2"),
        (I.__value = 0),
        (I.value = I.__value),
        t(r, "class", "w-full p-2 rounded-md fpl-dropdown"),
        o[0] === void 0 && js(() => o[7].call(r)),
        t(p, "class", "w-full border border-gray-500 mt-4 mb-2"),
        t(s, "class", "mt-3 text-center"),
        t(O, "class", "font-bold text-sm"),
        t(S, "class", "font-bold text-xs"),
        t(
          N,
          "class",
          "bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-1 mt-4"
        ),
        t(N, "role", "alert"),
        t(
          F,
          "class",
          "px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        ),
        t(
          j,
          "class",
          He(
            "px-4 py-2 fpl-purple-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
          ) + " svelte-18qswye"
        ),
        t(b, "class", "items-center py-3 flex space-x-4"),
        t(
          e,
          "class",
          "relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
        ),
        t(
          a,
          "class",
          "fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop svelte-18qswye"
        );
    },
    m(w, U) {
      X(w, a, U),
        n(a, e),
        n(e, s),
        n(s, i),
        n(i, _),
        n(s, f),
        n(s, p),
        n(p, r),
        n(r, I),
        n(I, E);
      for (let h = 0; h < L.length; h += 1) L[h] && L[h].m(r, null);
      Ds(r, o[0], !0),
        n(e, C),
        n(e, N),
        n(N, O),
        n(O, M),
        n(N, K),
        n(N, S),
        n(S, T),
        n(e, y),
        n(e, b),
        n(b, F),
        n(F, G),
        n(b, k),
        n(b, j),
        n(j, u),
        A ||
          ((z = [
            V(r, "change", o[7]),
            V(F, "click", function () {
              Be(o[2]) && o[2].apply(this, arguments);
            }),
            V(j, "click", o[4]),
            V(e, "click", Rs(o[6])),
            V(e, "keydown", o[5]),
            V(a, "click", function () {
              Be(o[2]) && o[2].apply(this, arguments);
            }),
            V(a, "keydown", o[5]),
          ]),
          (A = !0));
    },
    p(w, U) {
      if (((o = w), U & 8)) {
        W = o[3];
        let h;
        for (h = 0; h < W.length; h += 1) {
          const Y = hs(o, W, h);
          L[h] ? L[h].p(Y, U) : ((L[h] = Ps(Y)), L[h].c(), L[h].m(r, null));
        }
        for (; h < L.length; h += 1) L[h].d(1);
        L.length = W.length;
      }
      U & 9 && Ds(r, o[0]);
    },
    d(w) {
      w && c(a), qs(L, w), (A = !1), Se(z);
    },
  };
}
function Ps(o) {
  let a,
    e = o[9].friendlyName + "",
    s,
    i;
  return {
    c() {
      (a = l("option")), (s = P(e)), this.h();
    },
    l(_) {
      a = m(_, "OPTION", {});
      var f = d(a);
      (s = R(f, e)), f.forEach(c), this.h();
    },
    h() {
      (a.__value = i = o[9].id), (a.value = a.__value);
    },
    m(_, f) {
      X(_, a, f), n(a, s);
    },
    p(_, f) {
      f & 8 && e !== (e = _[9].friendlyName + "") && pe(s, e),
        f & 8 &&
          i !== (i = _[9].id) &&
          ((a.__value = i), (a.value = a.__value));
    },
    d(_) {
      _ && c(a);
    },
  };
}
function $s(o) {
  let a,
    e = o[1] && Cs(o);
  return {
    c() {
      e && e.c(), (a = Ga());
    },
    l(s) {
      e && e.l(s), (a = Ga());
    },
    m(s, i) {
      e && e.m(s, i), X(s, a, i);
    },
    p(s, [i]) {
      s[1]
        ? e
          ? e.p(s, i)
          : ((e = Cs(s)), e.c(), e.m(a.parentNode, a))
        : e && (e.d(1), (e = null));
    },
    i: ea,
    o: ea,
    d(s) {
      e && e.d(s), s && c(a);
    },
  };
}
function Js(o, a, e) {
  let { showModal: s } = a,
    { closeModal: i } = a,
    { newFavouriteTeam: _ } = a,
    f,
    p;
  ys(async () => {
    await Ie.sync(),
      (p = Ie.subscribe((N) => {
        e(3, (f = N));
      }));
  }),
    Ls(() => {
      p?.();
    });
  async function r() {
    fe.set(!0);
    try {
      await Ne.updateFavouriteTeam(_);
    } catch (N) {
      Qa.show("Error updating favourite team.", "error"),
        console.error("Error updating favourite team:", N);
    }
    fe.set(!1), i();
  }
  function I(N) {
    !(N.target instanceof HTMLInputElement) && N.key === "Escape" && i();
  }
  function E(N) {
    Os.call(this, o, N);
  }
  function C() {
    (_ = xs(this)), e(0, _), e(3, f);
  }
  return (
    (o.$$set = (N) => {
      "showModal" in N && e(1, (s = N.showModal)),
        "closeModal" in N && e(2, (i = N.closeModal)),
        "newFavouriteTeam" in N && e(0, (_ = N.newFavouriteTeam));
    }),
    [_, s, i, f, r, I, E, C]
  );
}
class an extends Za {
  constructor(a) {
    super(),
      $a(this, a, Js, $s, Ja, {
        showModal: 1,
        closeModal: 2,
        newFavouriteTeam: 0,
      });
  }
}
function en(o) {
  let a,
    e,
    s,
    i,
    _,
    f,
    p,
    r,
    I,
    E,
    C,
    N,
    O,
    M,
    K,
    S,
    T,
    y,
    b,
    F,
    G,
    k,
    j,
    u = o[1].displayName + "",
    A,
    z,
    W,
    L,
    w,
    U,
    h,
    Y,
    $,
    sa = o[0].find(o[16])?.friendlyName + "",
    na,
    Ra,
    H,
    Oa,
    Sa,
    oa,
    J,
    ya,
    ua,
    La,
    ue,
    Ee,
    wa,
    be,
    ge,
    ta,
    Fa,
    Ka = o[1].principalName + "",
    ae,
    ve,
    ra,
    De,
    ka,
    ja,
    qa,
    B,
    ia,
    Ea,
    Ye,
    Te,
    ca,
    xa,
    Ae,
    he,
    Ha,
    Ce,
    Pe,
    la,
    ba,
    Xe,
    Re,
    ma,
    Va,
    Oe,
    ye,
    Ba,
    Le,
    we,
    _a,
    ga,
    Qe,
    Fe,
    da,
    Wa,
    ke,
    je,
    Ya,
    qe,
    xe,
    pa,
    va,
    Ze,
    Ve,
    Ia,
    Ma,
    We,
    Me,
    Xa,
    ze,
    aa,
    Ue,
    $e;
  return (
    (a = new Zs({
      props: {
        newUsername: o[1].displayName,
        showModal: o[3],
        closeModal: o[9],
      },
    })),
    (s = new an({
      props: {
        newFavouriteTeam: o[1].favouriteTeamId,
        showModal: o[4],
        closeModal: o[11],
      },
    })),
    (ra = new Ys({
      props: {
        onClick: o[12],
        principalId: o[1].principalName,
        className: "ml-2 w-4 h-4",
      },
    })),
    {
      c() {
        Aa(a.$$.fragment),
          (e = v()),
          Aa(s.$$.fragment),
          (i = v()),
          (_ = l("div")),
          (f = l("div")),
          (p = l("div")),
          (r = l("div")),
          (I = l("img")),
          (C = v()),
          (N = l("div")),
          (O = l("button")),
          (M = P("Upload Photo")),
          (K = v()),
          (S = l("input")),
          (T = v()),
          (y = l("div")),
          (b = l("div")),
          (F = l("p")),
          (G = P("Display Name:")),
          (k = v()),
          (j = l("h2")),
          (A = P(u)),
          (z = v()),
          (W = l("button")),
          (L = P("Update")),
          (w = v()),
          (U = l("p")),
          (h = P("Favourite Team:")),
          (Y = v()),
          ($ = l("h2")),
          (na = P(sa)),
          (Ra = v()),
          (H = l("button")),
          (Oa = P("Update")),
          (oa = v()),
          (J = l("p")),
          (ya = P("Joined:")),
          (ua = v()),
          (La = l("h2")),
          (ue = P("August 2023")),
          (Ee = v()),
          (wa = l("p")),
          (be = P("Principal:")),
          (ge = v()),
          (ta = l("div")),
          (Fa = l("h2")),
          (ae = P(Ka)),
          (ve = v()),
          Aa(ra.$$.fragment),
          (De = v()),
          (ka = l("div")),
          (ja = l("div")),
          (qa = l("div")),
          (B = l("div")),
          (ia = l("div")),
          (Ea = l("img")),
          (Te = v()),
          (ca = l("div")),
          (xa = l("p")),
          (Ae = P("ICP")),
          (he = v()),
          (Ha = l("p")),
          (Ce = P("0.00 ICP")),
          (Pe = v()),
          (la = l("div")),
          (ba = l("img")),
          (Re = v()),
          (ma = l("div")),
          (Va = l("p")),
          (Oe = P("FPL")),
          (ye = v()),
          (Ba = l("p")),
          (Le = P("0.00 FPL")),
          (we = v()),
          (_a = l("div")),
          (ga = l("img")),
          (Fe = v()),
          (da = l("div")),
          (Wa = l("p")),
          (ke = P("ckBTC")),
          (je = v()),
          (Ya = l("p")),
          (qe = P("0.00 ckBTC")),
          (xe = v()),
          (pa = l("div")),
          (va = l("img")),
          (Ve = v()),
          (Ia = l("div")),
          (Ma = l("p")),
          (We = P("ckETH")),
          (Me = v()),
          (Xa = l("p")),
          (ze = P("0.00 ckETH")),
          this.h();
      },
      l(g) {
        ha(a.$$.fragment, g),
          (e = D(g)),
          ha(s.$$.fragment, g),
          (i = D(g)),
          (_ = m(g, "DIV", { class: !0 }));
        var q = d(_);
        f = m(q, "DIV", { class: !0 });
        var fa = d(f);
        p = m(fa, "DIV", { class: !0 });
        var za = d(p);
        r = m(za, "DIV", { class: !0 });
        var Da = d(r);
        (I = m(Da, "IMG", { src: !0, alt: !0, class: !0 })),
          (C = D(Da)),
          (N = m(Da, "DIV", { class: !0 }));
        var ee = d(N);
        O = m(ee, "BUTTON", { class: !0 });
        var Je = d(O);
        (M = R(Je, "Upload Photo")),
          Je.forEach(c),
          (K = D(ee)),
          (S = m(ee, "INPUT", {
            type: !0,
            id: !0,
            accept: !0,
            style: !0,
            class: !0,
          })),
          ee.forEach(c),
          Da.forEach(c),
          za.forEach(c),
          (T = D(fa)),
          (y = m(fa, "DIV", { class: !0 }));
        var as = d(y);
        b = m(as, "DIV", { class: !0 });
        var x = d(b);
        F = m(x, "P", { class: !0 });
        var es = d(F);
        (G = R(es, "Display Name:")),
          es.forEach(c),
          (k = D(x)),
          (j = m(x, "H2", { class: !0 }));
        var ss = d(j);
        (A = R(ss, u)),
          ss.forEach(c),
          (z = D(x)),
          (W = m(x, "BUTTON", { class: !0 }));
        var ns = d(W);
        (L = R(ns, "Update")),
          ns.forEach(c),
          (w = D(x)),
          (U = m(x, "P", { class: !0 }));
        var os = d(U);
        (h = R(os, "Favourite Team:")),
          os.forEach(c),
          (Y = D(x)),
          ($ = m(x, "H2", { class: !0 }));
        var ts = d($);
        (na = R(ts, sa)),
          ts.forEach(c),
          (Ra = D(x)),
          (H = m(x, "BUTTON", { class: !0 }));
        var rs = d(H);
        (Oa = R(rs, "Update")),
          rs.forEach(c),
          (oa = D(x)),
          (J = m(x, "P", { class: !0 }));
        var is = d(J);
        (ya = R(is, "Joined:")),
          is.forEach(c),
          (ua = D(x)),
          (La = m(x, "H2", { class: !0 }));
        var cs = d(La);
        (ue = R(cs, "August 2023")),
          cs.forEach(c),
          (Ee = D(x)),
          (wa = m(x, "P", { class: !0 }));
        var ls = d(wa);
        (be = R(ls, "Principal:")),
          ls.forEach(c),
          (ge = D(x)),
          (ta = m(x, "DIV", { class: !0 }));
        var se = d(ta);
        Fa = m(se, "H2", { class: !0 });
        var ms = d(Fa);
        (ae = R(ms, Ka)),
          ms.forEach(c),
          (ve = D(se)),
          ha(ra.$$.fragment, se),
          se.forEach(c),
          x.forEach(c),
          as.forEach(c),
          fa.forEach(c),
          (De = D(q)),
          (ka = m(q, "DIV", { class: !0 }));
        var _s = d(ka);
        ja = m(_s, "DIV", { class: !0 });
        var ds = d(ja);
        qa = m(ds, "DIV", { class: !0 });
        var ps = d(qa);
        B = m(ps, "DIV", { class: !0 });
        var Na = d(B);
        ia = m(Na, "DIV", { class: !0 });
        var ne = d(ia);
        (Ea = m(ne, "IMG", { src: !0, alt: !0, class: !0 })),
          (Te = D(ne)),
          (ca = m(ne, "DIV", { class: !0 }));
        var oe = d(ca);
        xa = m(oe, "P", { class: !0 });
        var Is = d(xa);
        (Ae = R(Is, "ICP")), Is.forEach(c), (he = D(oe)), (Ha = m(oe, "P", {}));
        var fs = d(Ha);
        (Ce = R(fs, "0.00 ICP")),
          fs.forEach(c),
          oe.forEach(c),
          ne.forEach(c),
          (Pe = D(Na)),
          (la = m(Na, "DIV", { class: !0 }));
        var te = d(la);
        (ba = m(te, "IMG", { src: !0, alt: !0, class: !0 })),
          (Re = D(te)),
          (ma = m(te, "DIV", { class: !0 }));
        var re = d(ma);
        Va = m(re, "P", { class: !0 });
        var Ns = d(Va);
        (Oe = R(Ns, "FPL")), Ns.forEach(c), (ye = D(re)), (Ba = m(re, "P", {}));
        var Ss = d(Ba);
        (Le = R(Ss, "0.00 FPL")),
          Ss.forEach(c),
          re.forEach(c),
          te.forEach(c),
          (we = D(Na)),
          (_a = m(Na, "DIV", { class: !0 }));
        var ie = d(_a);
        (ga = m(ie, "IMG", { src: !0, alt: !0, class: !0 })),
          (Fe = D(ie)),
          (da = m(ie, "DIV", { class: !0 }));
        var ce = d(da);
        Wa = m(ce, "P", { class: !0 });
        var us = d(Wa);
        (ke = R(us, "ckBTC")),
          us.forEach(c),
          (je = D(ce)),
          (Ya = m(ce, "P", {}));
        var Es = d(Ya);
        (qe = R(Es, "0.00 ckBTC")),
          Es.forEach(c),
          ce.forEach(c),
          ie.forEach(c),
          (xe = D(Na)),
          (pa = m(Na, "DIV", { class: !0 }));
        var le = d(pa);
        (va = m(le, "IMG", { src: !0, alt: !0, class: !0 })),
          (Ve = D(le)),
          (Ia = m(le, "DIV", { class: !0 }));
        var me = d(Ia);
        Ma = m(me, "P", { class: !0 });
        var bs = d(Ma);
        (We = R(bs, "ckETH")),
          bs.forEach(c),
          (Me = D(me)),
          (Xa = m(me, "P", {}));
        var gs = d(Xa);
        (ze = R(gs, "0.00 ckETH")),
          gs.forEach(c),
          me.forEach(c),
          le.forEach(c),
          Na.forEach(c),
          ps.forEach(c),
          ds.forEach(c),
          _s.forEach(c),
          q.forEach(c),
          this.h();
      },
      h() {
        Ua(I.src, (E = o[2])) || t(I, "src", E),
          t(I, "alt", "Profile"),
          t(I, "class", "w-48 md:w-80 mb-1 rounded-lg"),
          t(O, "class", "btn-file-upload fpl-button svelte-10w7xjk"),
          t(S, "type", "file"),
          t(S, "id", "profile-image"),
          t(S, "accept", "image/*"),
          Ta(S, "opacity", "0"),
          Ta(S, "position", "absolute"),
          Ta(S, "left", "0"),
          Ta(S, "top", "0"),
          t(S, "class", "svelte-10w7xjk"),
          t(N, "class", "file-upload-wrapper mt-4 svelte-10w7xjk"),
          t(r, "class", "group"),
          t(p, "class", "w-full md:w-auto px-2 ml-4 md:ml-0"),
          t(F, "class", "text-xs mb-2"),
          t(j, "class", "text-2xl font-bold mb-2"),
          t(W, "class", "p-2 px-4 rounded fpl-button"),
          t(U, "class", "text-xs mb-2 mt-4"),
          t($, "class", "text-2xl font-bold mb-2"),
          t(H, "class", "p-2 px-4 rounded fpl-button"),
          (H.disabled = Sa = o[6] > 1 && o[1].favouriteTeamId > 0),
          t(J, "class", "text-xs mb-2 mt-4"),
          t(La, "class", "text-2xl font-bold mb-2"),
          t(wa, "class", "text-xs mb-2 mt-4"),
          t(Fa, "class", "text-xs font-bold"),
          t(ta, "class", "flex items-center"),
          t(b, "class", "ml-4 p-4 rounded-lg"),
          t(y, "class", "w-full md:w-3/4 px-2 mb-4"),
          t(f, "class", "flex flex-wrap"),
          Ua(Ea.src, (Ye = "ICPCoin.png")) || t(Ea, "src", Ye),
          t(Ea, "alt", "ICP"),
          t(Ea, "class", "h-12 w-12"),
          t(xa, "class", "font-bold"),
          t(ca, "class", "ml-4"),
          t(
            ia,
            "class",
            "flex items-center p-4 rounded-lg shadow-md border border-gray-700"
          ),
          Ua(ba.src, (Xe = "FPLCoin.png")) || t(ba, "src", Xe),
          t(ba, "alt", "FPL"),
          t(ba, "class", "h-12 w-12"),
          t(Va, "class", "font-bold"),
          t(ma, "class", "ml-4"),
          t(
            la,
            "class",
            "flex items-center p-4 rounded-lg shadow-md border border-gray-700"
          ),
          Ua(ga.src, (Qe = "ckBTCCoin.png")) || t(ga, "src", Qe),
          t(ga, "alt", "ICP"),
          t(ga, "class", "h-12 w-12"),
          t(Wa, "class", "font-bold"),
          t(da, "class", "ml-4"),
          t(
            _a,
            "class",
            "flex items-center p-4 rounded-lg shadow-md border border-gray-700"
          ),
          Ua(va.src, (Ze = "ckETHCoin.png")) || t(va, "src", Ze),
          t(va, "alt", "ICP"),
          t(va, "class", "h-12 w-12"),
          t(Ma, "class", "font-bold"),
          t(Ia, "class", "ml-4"),
          t(
            pa,
            "class",
            "flex items-center p-4 rounded-lg shadow-md border border-gray-700"
          ),
          t(B, "class", "grid grid-cols-1 md:grid-cols-4 gap-4"),
          t(qa, "class", "mt-4 px-2"),
          t(ja, "class", "w-full px-2 mb-4"),
          t(ka, "class", "flex flex-wrap -mx-2 mt-4"),
          t(_, "class", "container mx-auto p-4");
      },
      m(g, q) {
        Ca(a, g, q),
          X(g, e, q),
          Ca(s, g, q),
          X(g, i, q),
          X(g, _, q),
          n(_, f),
          n(f, p),
          n(p, r),
          n(r, I),
          n(r, C),
          n(r, N),
          n(N, O),
          n(O, M),
          n(N, K),
          n(N, S),
          o[15](S),
          n(f, T),
          n(f, y),
          n(y, b),
          n(b, F),
          n(F, G),
          n(b, k),
          n(b, j),
          n(j, A),
          n(b, z),
          n(b, W),
          n(W, L),
          n(b, w),
          n(b, U),
          n(U, h),
          n(b, Y),
          n(b, $),
          n($, na),
          n(b, Ra),
          n(b, H),
          n(H, Oa),
          n(b, oa),
          n(b, J),
          n(J, ya),
          n(b, ua),
          n(b, La),
          n(La, ue),
          n(b, Ee),
          n(b, wa),
          n(wa, be),
          n(b, ge),
          n(b, ta),
          n(ta, Fa),
          n(Fa, ae),
          n(ta, ve),
          Ca(ra, ta, null),
          n(_, De),
          n(_, ka),
          n(ka, ja),
          n(ja, qa),
          n(qa, B),
          n(B, ia),
          n(ia, Ea),
          n(ia, Te),
          n(ia, ca),
          n(ca, xa),
          n(xa, Ae),
          n(ca, he),
          n(ca, Ha),
          n(Ha, Ce),
          n(B, Pe),
          n(B, la),
          n(la, ba),
          n(la, Re),
          n(la, ma),
          n(ma, Va),
          n(Va, Oe),
          n(ma, ye),
          n(ma, Ba),
          n(Ba, Le),
          n(B, we),
          n(B, _a),
          n(_a, ga),
          n(_a, Fe),
          n(_a, da),
          n(da, Wa),
          n(Wa, ke),
          n(da, je),
          n(da, Ya),
          n(Ya, qe),
          n(B, xe),
          n(B, pa),
          n(pa, va),
          n(pa, Ve),
          n(pa, Ia),
          n(Ia, Ma),
          n(Ma, We),
          n(Ia, Me),
          n(Ia, Xa),
          n(Xa, ze),
          (aa = !0),
          Ue ||
            (($e = [
              V(O, "click", o[13]),
              V(S, "change", o[14]),
              V(W, "click", o[8]),
              V(H, "click", o[10]),
            ]),
            (Ue = !0));
      },
      p(g, q) {
        const fa = {};
        q & 2 && (fa.newUsername = g[1].displayName),
          q & 8 && (fa.showModal = g[3]),
          a.$set(fa);
        const za = {};
        q & 2 && (za.newFavouriteTeam = g[1].favouriteTeamId),
          q & 16 && (za.showModal = g[4]),
          s.$set(za),
          (!aa || (q & 4 && !Ua(I.src, (E = g[2])))) && t(I, "src", E),
          (!aa || q & 2) && u !== (u = g[1].displayName + "") && pe(A, u),
          (!aa || q & 3) &&
            sa !== (sa = g[0].find(g[16])?.friendlyName + "") &&
            pe(na, sa),
          (!aa ||
            (q & 66 && Sa !== (Sa = g[6] > 1 && g[1].favouriteTeamId > 0))) &&
            (H.disabled = Sa),
          (!aa || q & 2) && Ka !== (Ka = g[1].principalName + "") && pe(ae, Ka);
        const Da = {};
        q & 2 && (Da.principalId = g[1].principalName), ra.$set(Da);
      },
      i(g) {
        aa ||
          (Z(a.$$.fragment, g),
          Z(s.$$.fragment, g),
          Z(ra.$$.fragment, g),
          (aa = !0));
      },
      o(g) {
        Q(a.$$.fragment, g),
          Q(s.$$.fragment, g),
          Q(ra.$$.fragment, g),
          (aa = !1);
      },
      d(g) {
        Pa(a, g),
          g && c(e),
          Pa(s, g),
          g && c(i),
          g && c(_),
          o[15](null),
          Pa(ra),
          (Ue = !1),
          Se($e);
      },
    }
  );
}
function sn(o) {
  let a, e;
  return (
    (a = new Us({})),
    {
      c() {
        Aa(a.$$.fragment);
      },
      l(s) {
        ha(a.$$.fragment, s);
      },
      m(s, i) {
        Ca(a, s, i), (e = !0);
      },
      p: ea,
      i(s) {
        e || (Z(a.$$.fragment, s), (e = !0));
      },
      o(s) {
        Q(a.$$.fragment, s), (e = !1);
      },
      d(s) {
        Pa(a, s);
      },
    }
  );
}
function nn(o) {
  let a, e, s, i;
  const _ = [sn, en],
    f = [];
  function p(r, I) {
    return r[7] ? 0 : 1;
  }
  return (
    (a = p(o)),
    (e = f[a] = _[a](o)),
    {
      c() {
        e.c(), (s = Ga());
      },
      l(r) {
        e.l(r), (s = Ga());
      },
      m(r, I) {
        f[a].m(r, I), X(r, s, I), (i = !0);
      },
      p(r, [I]) {
        let E = a;
        (a = p(r)),
          a === E
            ? f[a].p(r, I)
            : (ws(),
              Q(f[E], 1, 1, () => {
                f[E] = null;
              }),
              Fs(),
              (e = f[a]),
              e ? e.p(r, I) : ((e = f[a] = _[a](r)), e.c()),
              Z(e, 1),
              e.m(s.parentNode, s));
      },
      i(r) {
        i || (Z(e), (i = !0));
      },
      o(r) {
        Q(e), (i = !1);
      },
      d(r) {
        f[a].d(r), r && c(s);
      },
    }
  );
}
function on(o, a, e) {
  let s,
    i,
    _,
    f = "profile_placeholder.png",
    p = !1,
    r = !1,
    I,
    E = 1,
    C = !0,
    N,
    O;
  ys(async () => {
    try {
      await Ie.sync(),
        await Ts.sync(),
        (N = Ie.subscribe((A) => {
          e(0, (s = A));
        })),
        (O = Ts.subscribe((A) => {
          i = A;
        }));
      const u = await Ne.getProfile();
      if ((e(1, (_ = u)), _.profilePicture.length > 0)) {
        const A = new Blob([new Uint8Array(_.profilePicture)]);
        e(2, (f = URL.createObjectURL(A)));
      }
      e(6, (E = i?.activeGameweek ?? 1));
    } catch (u) {
      Qa.show("Error fetching profile detail.", "error"),
        console.error("Error fetching profile detail:", u);
    } finally {
      e(7, (C = !1));
    }
  }),
    Ls(() => {
      N?.(), O?.();
    });
  function M() {
    e(3, (p = !0));
  }
  function K() {
    e(3, (p = !1));
  }
  function S() {
    e(4, (r = !0));
  }
  function T() {
    e(4, (r = !1));
  }
  function y(u) {
    navigator.clipboard.writeText(u).then(() => {
      Qa.show("Copied!", "success");
    });
  }
  function b() {
    I.click();
  }
  function F(u) {
    const A = u.target;
    if (A.files && A.files[0]) {
      const z = A.files[0];
      if (z.size > 1e3 * 1024) {
        alert("File size exceeds 1000KB");
        return;
      }
      G(z);
    }
  }
  async function G(u) {
    try {
      await Ne.updateProfilePicture(u);
    } catch (A) {
      Qa.show("Error updating profile image", "error"),
        console.error("Error updating profile image", A);
    }
  }
  function k(u) {
    Vs[u ? "unshift" : "push"](() => {
      (I = u), e(5, I);
    });
  }
  return [
    s,
    _,
    f,
    p,
    r,
    I,
    E,
    C,
    M,
    K,
    S,
    T,
    y,
    b,
    F,
    k,
    (u) => u.id === _.favouriteTeamId,
  ];
}
class tn extends Za {
  constructor(a) {
    super(), $a(this, a, on, nn, Ja, {});
  }
}
function rn(o) {
  let a, e;
  return (
    (a = new Ms({ props: { viewGameweekDetail: o[2] } })),
    {
      c() {
        Aa(a.$$.fragment);
      },
      l(s) {
        ha(a.$$.fragment, s);
      },
      m(s, i) {
        Ca(a, s, i), (e = !0);
      },
      p: ea,
      i(s) {
        e || (Z(a.$$.fragment, s), (e = !0));
      },
      o(s) {
        Q(a.$$.fragment, s), (e = !1);
      },
      d(s) {
        Pa(a, s);
      },
    }
  );
}
function cn(o) {
  let a, e;
  return (
    (a = new tn({})),
    {
      c() {
        Aa(a.$$.fragment);
      },
      l(s) {
        ha(a.$$.fragment, s);
      },
      m(s, i) {
        Ca(a, s, i), (e = !0);
      },
      p: ea,
      i(s) {
        e || (Z(a.$$.fragment, s), (e = !0));
      },
      o(s) {
        Q(a.$$.fragment, s), (e = !1);
      },
      d(s) {
        Pa(a, s);
      },
    }
  );
}
function ln(o) {
  let a, e, s, i, _, f, p, r, I, E, C, N, O, M, K, S, T, y, b, F;
  const G = [cn, rn],
    k = [];
  function j(u, A) {
    return u[0] === "details" ? 0 : u[0] === "gameweeks" ? 1 : -1;
  }
  return (
    ~(S = j(o)) && (T = k[S] = G[S](o)),
    {
      c() {
        (a = l("div")),
          (e = l("div")),
          (s = l("ul")),
          (i = l("li")),
          (_ = l("button")),
          (f = P("Details")),
          (I = v()),
          (E = l("li")),
          (C = l("button")),
          (N = P("Gameweeks")),
          (K = v()),
          T && T.c(),
          this.h();
      },
      l(u) {
        a = m(u, "DIV", { class: !0 });
        var A = d(a);
        e = m(A, "DIV", { class: !0 });
        var z = d(e);
        s = m(z, "UL", { class: !0 });
        var W = d(s);
        i = m(W, "LI", { class: !0 });
        var L = d(i);
        _ = m(L, "BUTTON", { class: !0 });
        var w = d(_);
        (f = R(w, "Details")),
          w.forEach(c),
          L.forEach(c),
          (I = D(W)),
          (E = m(W, "LI", { class: !0 }));
        var U = d(E);
        C = m(U, "BUTTON", { class: !0 });
        var h = d(C);
        (N = R(h, "Gameweeks")),
          h.forEach(c),
          U.forEach(c),
          W.forEach(c),
          (K = D(z)),
          T && T.l(z),
          z.forEach(c),
          A.forEach(c),
          this.h();
      },
      h() {
        t(
          _,
          "class",
          (p = `p-2 ${o[0] === "details" ? "text-white" : "text-gray-400"}`)
        ),
          t(
            i,
            "class",
            (r = `mr-4 text-xs md:text-lg ${
              o[0] === "details" ? "active-tab" : ""
            }`)
          ),
          t(
            C,
            "class",
            (O = `p-2 ${o[0] === "gameweeks" ? "text-white" : "text-gray-400"}`)
          ),
          t(
            E,
            "class",
            (M = `mr-4 text-xs md:text-lg ${
              o[0] === "gameweeks" ? "active-tab" : ""
            }`)
          ),
          t(s, "class", "flex rounded-lg bg-light-gray px-4 pt-2"),
          t(e, "class", "bg-panel rounded-lg m-4"),
          t(a, "class", "m-4");
      },
      m(u, A) {
        X(u, a, A),
          n(a, e),
          n(e, s),
          n(s, i),
          n(i, _),
          n(_, f),
          n(s, I),
          n(s, E),
          n(E, C),
          n(C, N),
          n(e, K),
          ~S && k[S].m(e, null),
          (y = !0),
          b || ((F = [V(_, "click", o[3]), V(C, "click", o[4])]), (b = !0));
      },
      p(u, A) {
        (!y ||
          (A & 1 &&
            p !==
              (p = `p-2 ${
                u[0] === "details" ? "text-white" : "text-gray-400"
              }`))) &&
          t(_, "class", p),
          (!y ||
            (A & 1 &&
              r !==
                (r = `mr-4 text-xs md:text-lg ${
                  u[0] === "details" ? "active-tab" : ""
                }`))) &&
            t(i, "class", r),
          (!y ||
            (A & 1 &&
              O !==
                (O = `p-2 ${
                  u[0] === "gameweeks" ? "text-white" : "text-gray-400"
                }`))) &&
            t(C, "class", O),
          (!y ||
            (A & 1 &&
              M !==
                (M = `mr-4 text-xs md:text-lg ${
                  u[0] === "gameweeks" ? "active-tab" : ""
                }`))) &&
            t(E, "class", M);
        let z = S;
        (S = j(u)),
          S === z
            ? ~S && k[S].p(u, A)
            : (T &&
                (ws(),
                Q(k[z], 1, 1, () => {
                  k[z] = null;
                }),
                Fs()),
              ~S
                ? ((T = k[S]),
                  T ? T.p(u, A) : ((T = k[S] = G[S](u)), T.c()),
                  Z(T, 1),
                  T.m(e, null))
                : (T = null));
      },
      i(u) {
        y || (Z(T), (y = !0));
      },
      o(u) {
        Q(T), (y = !1);
      },
      d(u) {
        u && c(a), ~S && k[S].d(), (b = !1), Se(F);
      },
    }
  );
}
function mn(o) {
  let a, e;
  return (
    (a = new Gs({
      props: { $$slots: { default: [ln] }, $$scope: { ctx: o } },
    })),
    {
      c() {
        Aa(a.$$.fragment);
      },
      l(s) {
        ha(a.$$.fragment, s);
      },
      m(s, i) {
        Ca(a, s, i), (e = !0);
      },
      p(s, [i]) {
        const _ = {};
        i & 33 && (_.$$scope = { dirty: i, ctx: s }), a.$set(_);
      },
      i(s) {
        e || (Z(a.$$.fragment, s), (e = !0));
      },
      o(s) {
        Q(a.$$.fragment, s), (e = !1);
      },
      d(s) {
        Pa(a, s);
      },
    }
  );
}
function _n(o, a, e) {
  let s = "details";
  function i(r) {
    e(0, (s = r));
  }
  function _(r, I) {
    throw Ws(307, `/manager?id=${r}&gw=${I}`);
  }
  return [s, i, _, () => i("details"), () => i("gameweeks")];
}
class gn extends Za {
  constructor(a) {
    super(), $a(this, a, _n, mn, Ja, {});
  }
}
export { gn as component };
