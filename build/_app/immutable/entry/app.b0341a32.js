import {
  A,
  a as B,
  B as D,
  b as E,
  c as C,
  d as h,
  e as d,
  f as I,
  g,
  h as w,
  i as j,
  j as M,
  k as F,
  l as G,
  m as H,
  n as R,
  o as U,
  p,
  q as J,
  r as K,
  S,
  s as z,
  t as W,
  u as Q,
  v as P,
  w as V,
  x as v,
  y as k,
  z as L,
} from "../chunks/index.c7b38e5e.js";
import { _ as c } from "../chunks/preload-helper.a4192956.js";
const it = {};
function X(s) {
  let t, i, n;
  var r = s[1][0];
  function u(e) {
    return { props: { data: e[3], form: e[2] } };
  }
  return (
    r && ((t = v(r, u(s))), s[12](t)),
    {
      c() {
        t && k(t.$$.fragment), (i = d());
      },
      l(e) {
        t && L(t.$$.fragment, e), (i = d());
      },
      m(e, o) {
        t && A(t, e, o), E(e, i, o), (n = !0);
      },
      p(e, o) {
        const l = {};
        if (
          (o & 8 && (l.data = e[3]),
          o & 4 && (l.form = e[2]),
          o & 2 && r !== (r = e[1][0]))
        ) {
          if (t) {
            P();
            const a = t;
            h(a.$$.fragment, 1, 0, () => {
              D(a, 1);
            }),
              I();
          }
          r
            ? ((t = v(r, u(e))),
              e[12](t),
              k(t.$$.fragment),
              g(t.$$.fragment, 1),
              A(t, i.parentNode, i))
            : (t = null);
        } else r && t.$set(l);
      },
      i(e) {
        n || (t && g(t.$$.fragment, e), (n = !0));
      },
      o(e) {
        t && h(t.$$.fragment, e), (n = !1);
      },
      d(e) {
        s[12](null), e && w(i), t && D(t, e);
      },
    }
  );
}
function Y(s) {
  let t, i, n;
  var r = s[1][0];
  function u(e) {
    return {
      props: { data: e[3], $$slots: { default: [Z] }, $$scope: { ctx: e } },
    };
  }
  return (
    r && ((t = v(r, u(s))), s[11](t)),
    {
      c() {
        t && k(t.$$.fragment), (i = d());
      },
      l(e) {
        t && L(t.$$.fragment, e), (i = d());
      },
      m(e, o) {
        t && A(t, e, o), E(e, i, o), (n = !0);
      },
      p(e, o) {
        const l = {};
        if (
          (o & 8 && (l.data = e[3]),
          o & 8215 && (l.$$scope = { dirty: o, ctx: e }),
          o & 2 && r !== (r = e[1][0]))
        ) {
          if (t) {
            P();
            const a = t;
            h(a.$$.fragment, 1, 0, () => {
              D(a, 1);
            }),
              I();
          }
          r
            ? ((t = v(r, u(e))),
              e[11](t),
              k(t.$$.fragment),
              g(t.$$.fragment, 1),
              A(t, i.parentNode, i))
            : (t = null);
        } else r && t.$set(l);
      },
      i(e) {
        n || (t && g(t.$$.fragment, e), (n = !0));
      },
      o(e) {
        t && h(t.$$.fragment, e), (n = !1);
      },
      d(e) {
        s[11](null), e && w(i), t && D(t, e);
      },
    }
  );
}
function Z(s) {
  let t, i, n;
  var r = s[1][1];
  function u(e) {
    return { props: { data: e[4], form: e[2] } };
  }
  return (
    r && ((t = v(r, u(s))), s[10](t)),
    {
      c() {
        t && k(t.$$.fragment), (i = d());
      },
      l(e) {
        t && L(t.$$.fragment, e), (i = d());
      },
      m(e, o) {
        t && A(t, e, o), E(e, i, o), (n = !0);
      },
      p(e, o) {
        const l = {};
        if (
          (o & 16 && (l.data = e[4]),
          o & 4 && (l.form = e[2]),
          o & 2 && r !== (r = e[1][1]))
        ) {
          if (t) {
            P();
            const a = t;
            h(a.$$.fragment, 1, 0, () => {
              D(a, 1);
            }),
              I();
          }
          r
            ? ((t = v(r, u(e))),
              e[10](t),
              k(t.$$.fragment),
              g(t.$$.fragment, 1),
              A(t, i.parentNode, i))
            : (t = null);
        } else r && t.$set(l);
      },
      i(e) {
        n || (t && g(t.$$.fragment, e), (n = !0));
      },
      o(e) {
        t && h(t.$$.fragment, e), (n = !1);
      },
      d(e) {
        s[10](null), e && w(i), t && D(t, e);
      },
    }
  );
}
function O(s) {
  let t,
    i = s[6] && T(s);
  return {
    c() {
      (t = F("div")), i && i.c(), this.h();
    },
    l(n) {
      t = G(n, "DIV", {
        id: !0,
        "aria-live": !0,
        "aria-atomic": !0,
        style: !0,
      });
      var r = H(t);
      i && i.l(r), r.forEach(w), this.h();
    },
    h() {
      R(t, "id", "svelte-announcer"),
        R(t, "aria-live", "assertive"),
        R(t, "aria-atomic", "true"),
        p(t, "position", "absolute"),
        p(t, "left", "0"),
        p(t, "top", "0"),
        p(t, "clip", "rect(0 0 0 0)"),
        p(t, "clip-path", "inset(50%)"),
        p(t, "overflow", "hidden"),
        p(t, "white-space", "nowrap"),
        p(t, "width", "1px"),
        p(t, "height", "1px");
    },
    m(n, r) {
      E(n, t, r), i && i.m(t, null);
    },
    p(n, r) {
      n[6]
        ? i
          ? i.p(n, r)
          : ((i = T(n)), i.c(), i.m(t, null))
        : i && (i.d(1), (i = null));
    },
    d(n) {
      n && w(t), i && i.d();
    },
  };
}
function T(s) {
  let t;
  return {
    c() {
      t = J(s[7]);
    },
    l(i) {
      t = K(i, s[7]);
    },
    m(i, n) {
      E(i, t, n);
    },
    p(i, n) {
      n & 128 && Q(t, i[7]);
    },
    d(i) {
      i && w(t);
    },
  };
}
function $(s) {
  let t, i, n, r, u;
  const e = [Y, X],
    o = [];
  function l(_, m) {
    return _[1][1] ? 0 : 1;
  }
  (t = l(s)), (i = o[t] = e[t](s));
  let a = s[5] && O(s);
  return {
    c() {
      i.c(), (n = B()), a && a.c(), (r = d());
    },
    l(_) {
      i.l(_), (n = C(_)), a && a.l(_), (r = d());
    },
    m(_, m) {
      o[t].m(_, m), E(_, n, m), a && a.m(_, m), E(_, r, m), (u = !0);
    },
    p(_, [m]) {
      let b = t;
      (t = l(_)),
        t === b
          ? o[t].p(_, m)
          : (P(),
            h(o[b], 1, 1, () => {
              o[b] = null;
            }),
            I(),
            (i = o[t]),
            i ? i.p(_, m) : ((i = o[t] = e[t](_)), i.c()),
            g(i, 1),
            i.m(n.parentNode, n)),
        _[5]
          ? a
            ? a.p(_, m)
            : ((a = O(_)), a.c(), a.m(r.parentNode, r))
          : a && (a.d(1), (a = null));
    },
    i(_) {
      u || (g(i), (u = !0));
    },
    o(_) {
      h(i), (u = !1);
    },
    d(_) {
      o[t].d(_), _ && w(n), a && a.d(_), _ && w(r);
    },
  };
}
function x(s, t, i) {
  let { stores: n } = t,
    { page: r } = t,
    { constructors: u } = t,
    { components: e = [] } = t,
    { form: o } = t,
    { data_0: l = null } = t,
    { data_1: a = null } = t;
  M(n.page.notify);
  let _ = !1,
    m = !1,
    b = null;
  U(() => {
    const f = n.page.subscribe(() => {
      _ &&
        (i(6, (m = !0)),
        W().then(() => {
          i(7, (b = document.title || "untitled page"));
        }));
    });
    return i(5, (_ = !0)), f;
  });
  function y(f) {
    V[f ? "unshift" : "push"](() => {
      (e[1] = f), i(0, e);
    });
  }
  function N(f) {
    V[f ? "unshift" : "push"](() => {
      (e[0] = f), i(0, e);
    });
  }
  function q(f) {
    V[f ? "unshift" : "push"](() => {
      (e[0] = f), i(0, e);
    });
  }
  return (
    (s.$$set = (f) => {
      "stores" in f && i(8, (n = f.stores)),
        "page" in f && i(9, (r = f.page)),
        "constructors" in f && i(1, (u = f.constructors)),
        "components" in f && i(0, (e = f.components)),
        "form" in f && i(2, (o = f.form)),
        "data_0" in f && i(3, (l = f.data_0)),
        "data_1" in f && i(4, (a = f.data_1));
    }),
    (s.$$.update = () => {
      s.$$.dirty & 768 && n.page.set(r);
    }),
    [e, u, o, l, a, _, m, b, n, r, y, N, q]
  );
}
class nt extends S {
  constructor(t) {
    super(),
      j(this, t, x, $, z, {
        stores: 8,
        page: 9,
        constructors: 1,
        components: 0,
        form: 2,
        data_0: 3,
        data_1: 4,
      });
  }
}
const rt = [
    () =>
      c(
        () => import("../nodes/0.a8274f94.js"),
        ["../nodes/0.a8274f94.js", "../chunks/index.c7b38e5e.js"],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/1.e0435de1.js"),
        [
          "../nodes/1.e0435de1.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/index.8caf67b2.js",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/2.8eb92a00.js"),
        [
          "../nodes/2.8eb92a00.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/manager-store.58a33dc2.js",
          "../chunks/system-store.408d352e.js",
          "../chunks/team-store.a9afdac8.js",
          "../chunks/Layout.39e2a716.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../assets/Layout.1b44d07a.css",
          "../chunks/fixture-store.8fe042dd.js",
          "../chunks/BadgeIcon.5f1570c4.js",
          "../chunks/ViewDetailsIcon.98b59799.js",
          "../chunks/player-store.55a4cc5d.js",
          "../chunks/global-stores.803ba169.js",
          "../assets/2.8041c969.css",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/3.dd4df7c1.js"),
        [
          "../nodes/3.dd4df7c1.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/team-store.a9afdac8.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../chunks/fixture-store.8fe042dd.js",
          "../chunks/index.d7eb2526.js",
          "../chunks/control.f5b05b5f.js",
          "../chunks/Layout.39e2a716.js",
          "../assets/Layout.1b44d07a.css",
          "../chunks/governance-store.4e2c6360.js",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/4.4bd3a4d0.js"),
        [
          "../nodes/4.4bd3a4d0.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/team-store.a9afdac8.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../chunks/fixture-store.8fe042dd.js",
          "../chunks/player-store.55a4cc5d.js",
          "../chunks/system-store.408d352e.js",
          "../chunks/Layout.39e2a716.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../assets/Layout.1b44d07a.css",
          "../chunks/BadgeIcon.5f1570c4.js",
          "../chunks/ShirtIcon.cbb688e3.js",
          "../chunks/global-stores.803ba169.js",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/5.94003362.js"),
        [
          "../nodes/5.94003362.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/system-store.408d352e.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../chunks/team-store.a9afdac8.js",
          "../chunks/governance-store.4e2c6360.js",
          "../chunks/player-store.55a4cc5d.js",
          "../chunks/fixture-store.8fe042dd.js",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/6.2af14ec0.js"),
        [
          "../nodes/6.2af14ec0.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/Layout.39e2a716.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../assets/Layout.1b44d07a.css",
          "../assets/6.b3013d1d.css",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/7.ce9d9cb2.js"),
        [
          "../nodes/7.ce9d9cb2.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/Layout.39e2a716.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../assets/Layout.1b44d07a.css",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/8.f1e86b7a.js"),
        [
          "../nodes/8.f1e86b7a.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/team-store.a9afdac8.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../chunks/system-store.408d352e.js",
          "../chunks/manager-store.58a33dc2.js",
          "../chunks/Layout.39e2a716.js",
          "../assets/Layout.1b44d07a.css",
          "../chunks/player-store.55a4cc5d.js",
          "../chunks/fixture-store.8fe042dd.js",
          "../chunks/BadgeIcon.5f1570c4.js",
          "../chunks/manager-gameweeks.bd195a5b.js",
          "../chunks/ViewDetailsIcon.98b59799.js",
          "../chunks/global-stores.803ba169.js",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/9.c93c20b9.js"),
        [
          "../nodes/9.c93c20b9.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/Layout.39e2a716.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../assets/Layout.1b44d07a.css",
          "../chunks/system-store.408d352e.js",
          "../chunks/team-store.a9afdac8.js",
          "../chunks/global-stores.803ba169.js",
          "../chunks/fixture-store.8fe042dd.js",
          "../chunks/player-store.55a4cc5d.js",
          "../chunks/manager-store.58a33dc2.js",
          "../chunks/BadgeIcon.5f1570c4.js",
          "../chunks/ShirtIcon.cbb688e3.js",
          "../assets/9.336c70f6.css",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/10.bd060bff.js"),
        [
          "../nodes/10.bd060bff.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../chunks/global-stores.803ba169.js",
          "../chunks/system-store.408d352e.js",
          "../chunks/team-store.a9afdac8.js",
          "../chunks/Layout.39e2a716.js",
          "../assets/Layout.1b44d07a.css",
          "../chunks/fixture-store.8fe042dd.js",
          "../chunks/BadgeIcon.5f1570c4.js",
          "../chunks/ViewDetailsIcon.98b59799.js",
          "../chunks/player-store.55a4cc5d.js",
          "../chunks/ShirtIcon.cbb688e3.js",
          "../assets/10.7515d509.css",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/11.4f4a55d1.js"),
        [
          "../nodes/11.4f4a55d1.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/index.d7eb2526.js",
          "../chunks/control.f5b05b5f.js",
          "../chunks/manager-gameweeks.bd195a5b.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/system-store.408d352e.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../chunks/team-store.a9afdac8.js",
          "../chunks/manager-store.58a33dc2.js",
          "../chunks/ViewDetailsIcon.98b59799.js",
          "../chunks/Layout.39e2a716.js",
          "../assets/Layout.1b44d07a.css",
          "../chunks/global-stores.803ba169.js",
          "../assets/11.873b27b5.css",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/12.861b7e55.js"),
        [
          "../nodes/12.861b7e55.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/Layout.39e2a716.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../assets/Layout.1b44d07a.css",
        ],
        import.meta.url
      ),
    () =>
      c(
        () => import("../nodes/13.15f8138a.js"),
        [
          "../nodes/13.15f8138a.js",
          "../chunks/index.c7b38e5e.js",
          "../chunks/Layout.39e2a716.js",
          "../chunks/index.8caf67b2.js",
          "../chunks/stores.f0f38284.js",
          "../chunks/singletons.f40d3e23.js",
          "../chunks/toast-store.64ad2768.js",
          "../chunks/preload-helper.a4192956.js",
          "../assets/Layout.1b44d07a.css",
          "../assets/6.b3013d1d.css",
        ],
        import.meta.url
      ),
  ],
  ot = [],
  st = {
    "/": [2],
    "/add-fixture-data": [3],
    "/club": [4],
    "/fixture-validation": [5],
    "/gameplay-rules": [6],
    "/governance": [7],
    "/manager": [8],
    "/pick-team": [9],
    "/player": [10],
    "/profile": [11],
    "/terms": [12],
    "/whitepaper": [13],
  },
  _t = {
    handleError: ({ error: s }) => {
      console.error(s);
    },
  };
export {
  st as dictionary,
  _t as hooks,
  it as matchers,
  rt as nodes,
  nt as root,
  ot as server_loads,
};
