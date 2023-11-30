function M() {}
function nt(t, e) {
  for (const n in e) t[n] = e[n];
  return t;
}
function K(t) {
  return t();
}
function W() {
  return Object.create(null);
}
function $(t) {
  t.forEach(K);
}
function Q(t) {
  return typeof t == "function";
}
function $t(t, e) {
  return t != t
    ? e == e
    : t !== e || (t && typeof t == "object") || typeof t == "function";
}
let N;
function kt(t, e) {
  return N || (N = document.createElement("a")), (N.href = e), t === N.href;
}
function it(t) {
  return Object.keys(t).length === 0;
}
function R(t, ...e) {
  if (t == null) return M;
  const n = t.subscribe(...e);
  return n.unsubscribe ? () => n.unsubscribe() : n;
}
function vt(t) {
  let e;
  return R(t, (n) => (e = n))(), e;
}
function Et(t, e, n) {
  t.$$.on_destroy.push(R(e, n));
}
function St(t, e, n, i) {
  if (t) {
    const r = U(t, e, n, i);
    return t[0](r);
  }
}
function U(t, e, n, i) {
  return t[1] && i ? nt(n.ctx.slice(), t[1](i(e))) : n.ctx;
}
function Nt(t, e, n, i) {
  if (t[2] && i) {
    const r = t[2](i(n));
    if (e.dirty === void 0) return r;
    if (typeof r == "object") {
      const l = [],
        s = Math.max(e.dirty.length, r.length);
      for (let c = 0; c < s; c += 1) l[c] = e.dirty[c] | r[c];
      return l;
    }
    return e.dirty | r;
  }
  return e.dirty;
}
function At(t, e, n, i, r, l) {
  if (r) {
    const s = U(e, n, i, l);
    t.p(s, r);
  }
}
function Mt(t) {
  if (t.ctx.length > 32) {
    const e = [],
      n = t.ctx.length / 32;
    for (let i = 0; i < n; i++) e[i] = -1;
    return e;
  }
  return -1;
}
function jt(t) {
  const e = {};
  for (const n in t) n[0] !== "$" && (e[n] = t[n]);
  return e;
}
function Ct(t, e) {
  const n = {};
  e = new Set(e);
  for (const i in t) !e.has(i) && i[0] !== "$" && (n[i] = t[i]);
  return n;
}
function Tt(t) {
  return t ?? "";
}
const qt =
  typeof window < "u" ? window : typeof globalThis < "u" ? globalThis : global;
let j = !1;
function rt() {
  j = !0;
}
function st() {
  j = !1;
}
function ot(t, e, n, i) {
  for (; t < e; ) {
    const r = t + ((e - t) >> 1);
    n(r) <= i ? (t = r + 1) : (e = r);
  }
  return t;
}
function ct(t) {
  if (t.hydrate_init) return;
  t.hydrate_init = !0;
  let e = t.childNodes;
  if (t.nodeName === "HEAD") {
    const o = [];
    for (let u = 0; u < e.length; u++) {
      const f = e[u];
      f.claim_order !== void 0 && o.push(f);
    }
    e = o;
  }
  const n = new Int32Array(e.length + 1),
    i = new Int32Array(e.length);
  n[0] = -1;
  let r = 0;
  for (let o = 0; o < e.length; o++) {
    const u = e[o].claim_order,
      f =
        (r > 0 && e[n[r]].claim_order <= u
          ? r + 1
          : ot(1, r, (_) => e[n[_]].claim_order, u)) - 1;
    i[o] = n[f] + 1;
    const d = f + 1;
    (n[d] = o), (r = Math.max(d, r));
  }
  const l = [],
    s = [];
  let c = e.length - 1;
  for (let o = n[r] + 1; o != 0; o = i[o - 1]) {
    for (l.push(e[o - 1]); c >= o; c--) s.push(e[c]);
    c--;
  }
  for (; c >= 0; c--) s.push(e[c]);
  l.reverse(), s.sort((o, u) => o.claim_order - u.claim_order);
  for (let o = 0, u = 0; o < s.length; o++) {
    for (; u < l.length && s[o].claim_order >= l[u].claim_order; ) u++;
    const f = u < l.length ? l[u] : null;
    t.insertBefore(s[o], f);
  }
}
function ut(t, e) {
  if (j) {
    for (
      ct(t),
        (t.actual_end_child === void 0 ||
          (t.actual_end_child !== null &&
            t.actual_end_child.parentNode !== t)) &&
          (t.actual_end_child = t.firstChild);
      t.actual_end_child !== null && t.actual_end_child.claim_order === void 0;

    )
      t.actual_end_child = t.actual_end_child.nextSibling;
    e !== t.actual_end_child
      ? (e.claim_order !== void 0 || e.parentNode !== t) &&
        t.insertBefore(e, t.actual_end_child)
      : (t.actual_end_child = e.nextSibling);
  } else (e.parentNode !== t || e.nextSibling !== null) && t.appendChild(e);
}
function Lt(t, e, n) {
  j && !n
    ? ut(t, e)
    : (e.parentNode !== t || e.nextSibling != n) &&
      t.insertBefore(e, n || null);
}
function lt(t) {
  t.parentNode && t.parentNode.removeChild(t);
}
function Ot(t, e) {
  for (let n = 0; n < t.length; n += 1) t[n] && t[n].d(e);
}
function at(t) {
  return document.createElement(t);
}
function ft(t) {
  return document.createElementNS("http://www.w3.org/2000/svg", t);
}
function I(t) {
  return document.createTextNode(t);
}
function Pt() {
  return I(" ");
}
function Bt() {
  return I("");
}
function Dt(t, e, n, i) {
  return t.addEventListener(e, n, i), () => t.removeEventListener(e, n, i);
}
function It(t) {
  return function (e) {
    return e.preventDefault(), t.call(this, e);
  };
}
function zt(t) {
  return function (e) {
    return e.stopPropagation(), t.call(this, e);
  };
}
function _t(t, e, n) {
  n == null
    ? t.removeAttribute(e)
    : t.getAttribute(e) !== n && t.setAttribute(e, n);
}
function Ft(t, e) {
  for (const n in e) _t(t, n, e[n]);
}
function Ht(t, e, n) {
  t.setAttributeNS("http://www.w3.org/1999/xlink", e, n);
}
function Wt(t) {
  return t === "" ? null : +t;
}
function dt(t) {
  return Array.from(t.childNodes);
}
function ht(t) {
  t.claim_info === void 0 &&
    (t.claim_info = { last_index: 0, total_claimed: 0 });
}
function V(t, e, n, i, r = !1) {
  ht(t);
  const l = (() => {
    for (let s = t.claim_info.last_index; s < t.length; s++) {
      const c = t[s];
      if (e(c)) {
        const o = n(c);
        return (
          o === void 0 ? t.splice(s, 1) : (t[s] = o),
          r || (t.claim_info.last_index = s),
          c
        );
      }
    }
    for (let s = t.claim_info.last_index - 1; s >= 0; s--) {
      const c = t[s];
      if (e(c)) {
        const o = n(c);
        return (
          o === void 0 ? t.splice(s, 1) : (t[s] = o),
          r
            ? o === void 0 && t.claim_info.last_index--
            : (t.claim_info.last_index = s),
          c
        );
      }
    }
    return i();
  })();
  return (
    (l.claim_order = t.claim_info.total_claimed),
    (t.claim_info.total_claimed += 1),
    l
  );
}
function X(t, e, n, i) {
  return V(
    t,
    (r) => r.nodeName === e,
    (r) => {
      const l = [];
      for (let s = 0; s < r.attributes.length; s++) {
        const c = r.attributes[s];
        n[c.name] || l.push(c.name);
      }
      l.forEach((s) => r.removeAttribute(s));
    },
    () => i(e)
  );
}
function Gt(t, e, n) {
  return X(t, e, n, at);
}
function Jt(t, e, n) {
  return X(t, e, n, ft);
}
function mt(t, e) {
  return V(
    t,
    (n) => n.nodeType === 3,
    (n) => {
      const i = "" + e;
      if (n.data.startsWith(i)) {
        if (n.data.length !== i.length) return n.splitText(i.length);
      } else n.data = i;
    },
    () => I(e),
    !0
  );
}
function Kt(t) {
  return mt(t, " ");
}
function Qt(t, e) {
  (e = "" + e), t.data !== e && (t.data = e);
}
function Rt(t, e) {
  t.value = e ?? "";
}
function Ut(t, e, n, i) {
  n == null
    ? t.style.removeProperty(e)
    : t.style.setProperty(e, n, i ? "important" : "");
}
function Vt(t, e, n) {
  for (let i = 0; i < t.options.length; i += 1) {
    const r = t.options[i];
    if (r.__value === e) {
      r.selected = !0;
      return;
    }
  }
  (!n || e !== void 0) && (t.selectedIndex = -1);
}
function Xt(t) {
  const e = t.querySelector(":checked");
  return e && e.__value;
}
function Yt(t, e, n) {
  t.classList[n ? "add" : "remove"](e);
}
function Zt(t, e) {
  return new t(e);
}
let v;
function k(t) {
  v = t;
}
function C() {
  if (!v) throw new Error("Function called outside component initialization");
  return v;
}
function te(t) {
  C().$$.on_mount.push(t);
}
function ee(t) {
  C().$$.after_update.push(t);
}
function ne(t) {
  C().$$.on_destroy.push(t);
}
function ie(t) {
  return C().$$.context.get(t);
}
function re(t, e) {
  const n = t.$$.callbacks[e.type];
  n && n.slice().forEach((i) => i.call(this, e));
}
const x = [],
  G = [];
let w = [];
const J = [],
  Y = Promise.resolve();
let B = !1;
function Z() {
  B || ((B = !0), Y.then(tt));
}
function se() {
  return Z(), Y;
}
function D(t) {
  w.push(t);
}
const P = new Set();
let b = 0;
function tt() {
  if (b !== 0) return;
  const t = v;
  do {
    try {
      for (; b < x.length; ) {
        const e = x[b];
        b++, k(e), pt(e.$$);
      }
    } catch (e) {
      throw ((x.length = 0), (b = 0), e);
    }
    for (k(null), x.length = 0, b = 0; G.length; ) G.pop()();
    for (let e = 0; e < w.length; e += 1) {
      const n = w[e];
      P.has(n) || (P.add(n), n());
    }
    w.length = 0;
  } while (x.length);
  for (; J.length; ) J.pop()();
  (B = !1), P.clear(), k(t);
}
function pt(t) {
  if (t.fragment !== null) {
    t.update(), $(t.before_update);
    const e = t.dirty;
    (t.dirty = [-1]),
      t.fragment && t.fragment.p(t.ctx, e),
      t.after_update.forEach(D);
  }
}
function yt(t) {
  const e = [],
    n = [];
  w.forEach((i) => (t.indexOf(i) === -1 ? e.push(i) : n.push(i))),
    n.forEach((i) => i()),
    (w = e);
}
const A = new Set();
let g;
function oe() {
  g = { r: 0, c: [], p: g };
}
function ce() {
  g.r || $(g.c), (g = g.p);
}
function et(t, e) {
  t && t.i && (A.delete(t), t.i(e));
}
function gt(t, e, n, i) {
  if (t && t.o) {
    if (A.has(t)) return;
    A.add(t),
      g.c.push(() => {
        A.delete(t), i && (n && t.d(1), i());
      }),
      t.o(e);
  } else i && i();
}
function ue(t, e) {
  t.d(1), e.delete(t.key);
}
function le(t, e) {
  gt(t, 1, 1, () => {
    e.delete(t.key);
  });
}
function ae(t, e, n, i, r, l, s, c, o, u, f, d) {
  let _ = t.length,
    m = l.length,
    h = _;
  const T = {};
  for (; h--; ) T[t[h].key] = h;
  const E = [],
    q = new Map(),
    L = new Map(),
    z = [];
  for (h = m; h--; ) {
    const a = d(r, l, h),
      p = n(a);
    let y = s.get(p);
    y ? i && z.push(() => y.p(a, e)) : ((y = u(p, a)), y.c()),
      q.set(p, (E[h] = y)),
      p in T && L.set(p, Math.abs(h - T[p]));
  }
  const F = new Set(),
    H = new Set();
  function O(a) {
    et(a, 1), a.m(c, f), s.set(a.key, a), (f = a.first), m--;
  }
  for (; _ && m; ) {
    const a = E[m - 1],
      p = t[_ - 1],
      y = a.key,
      S = p.key;
    a === p
      ? ((f = a.first), _--, m--)
      : q.has(S)
      ? !s.has(y) || F.has(y)
        ? O(a)
        : H.has(S)
        ? _--
        : L.get(y) > L.get(S)
        ? (H.add(y), O(a))
        : (F.add(S), _--)
      : (o(p, s), _--);
  }
  for (; _--; ) {
    const a = t[_];
    q.has(a.key) || o(a, s);
  }
  for (; m; ) O(E[m - 1]);
  return $(z), E;
}
function fe(t, e) {
  const n = {},
    i = {},
    r = { $$scope: 1 };
  let l = t.length;
  for (; l--; ) {
    const s = t[l],
      c = e[l];
    if (c) {
      for (const o in s) o in c || (i[o] = 1);
      for (const o in c) r[o] || ((n[o] = c[o]), (r[o] = 1));
      t[l] = c;
    } else for (const o in s) r[o] = 1;
  }
  for (const s in i) s in n || (n[s] = void 0);
  return n;
}
function _e(t) {
  t && t.c();
}
function de(t, e) {
  t && t.l(e);
}
function bt(t, e, n, i) {
  const { fragment: r, after_update: l } = t.$$;
  r && r.m(e, n),
    i ||
      D(() => {
        const s = t.$$.on_mount.map(K).filter(Q);
        t.$$.on_destroy ? t.$$.on_destroy.push(...s) : $(s),
          (t.$$.on_mount = []);
      }),
    l.forEach(D);
}
function xt(t, e) {
  const n = t.$$;
  n.fragment !== null &&
    (yt(n.after_update),
    $(n.on_destroy),
    n.fragment && n.fragment.d(e),
    (n.on_destroy = n.fragment = null),
    (n.ctx = []));
}
function wt(t, e) {
  t.$$.dirty[0] === -1 && (x.push(t), Z(), t.$$.dirty.fill(0)),
    (t.$$.dirty[(e / 31) | 0] |= 1 << e % 31);
}
function he(t, e, n, i, r, l, s, c = [-1]) {
  const o = v;
  k(t);
  const u = (t.$$ = {
    fragment: null,
    ctx: [],
    props: l,
    update: M,
    not_equal: r,
    bound: W(),
    on_mount: [],
    on_destroy: [],
    on_disconnect: [],
    before_update: [],
    after_update: [],
    context: new Map(e.context || (o ? o.$$.context : [])),
    callbacks: W(),
    dirty: c,
    skip_bound: !1,
    root: e.target || o.$$.root,
  });
  s && s(u.root);
  let f = !1;
  if (
    ((u.ctx = n
      ? n(t, e.props || {}, (d, _, ...m) => {
          const h = m.length ? m[0] : _;
          return (
            u.ctx &&
              r(u.ctx[d], (u.ctx[d] = h)) &&
              (!u.skip_bound && u.bound[d] && u.bound[d](h), f && wt(t, d)),
            _
          );
        })
      : []),
    u.update(),
    (f = !0),
    $(u.before_update),
    (u.fragment = i ? i(u.ctx) : !1),
    e.target)
  ) {
    if (e.hydrate) {
      rt();
      const d = dt(e.target);
      u.fragment && u.fragment.l(d), d.forEach(lt);
    } else u.fragment && u.fragment.c();
    e.intro && et(t.$$.fragment),
      bt(t, e.target, e.anchor, e.customElement),
      st(),
      tt();
  }
  k(o);
}
class me {
  $destroy() {
    xt(this, 1), (this.$destroy = M);
  }
  $on(e, n) {
    if (!Q(n)) return M;
    const i = this.$$.callbacks[e] || (this.$$.callbacks[e] = []);
    return (
      i.push(n),
      () => {
        const r = i.indexOf(n);
        r !== -1 && i.splice(r, 1);
      }
    );
  }
  $set(e) {
    this.$$set &&
      !it(e) &&
      ((this.$$.skip_bound = !0), this.$$set(e), (this.$$.skip_bound = !1));
  }
}
export {
  kt as $,
  bt as A,
  xt as B,
  St as C,
  At as D,
  Mt as E,
  Nt as F,
  ut as G,
  M as H,
  Et as I,
  D as J,
  Vt as K,
  Dt as L,
  Ot as M,
  $ as N,
  ne as O,
  Xt as P,
  Q,
  zt as R,
  me as S,
  re as T,
  Tt as U,
  Rt as V,
  Wt as W,
  R as X,
  vt as Y,
  ae as Z,
  ue as _,
  Pt as a,
  ft as a0,
  Jt as a1,
  Yt as a2,
  Ht as a3,
  le as a4,
  qt as a5,
  It as a6,
  nt as a7,
  Ft as a8,
  fe as a9,
  Ct as aa,
  ie as ab,
  jt as ac,
  Lt as b,
  Kt as c,
  gt as d,
  Bt as e,
  ce as f,
  et as g,
  lt as h,
  he as i,
  ee as j,
  at as k,
  Gt as l,
  dt as m,
  _t as n,
  te as o,
  Ut as p,
  I as q,
  mt as r,
  $t as s,
  se as t,
  Qt as u,
  oe as v,
  G as w,
  Zt as x,
  _e as y,
  de as z,
};
