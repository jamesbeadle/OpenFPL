import { B as Os } from "../chunks/BadgeIcon.ac2d82f5.js";
import {
  p as Es,
  d as Is,
  e as Rs,
  s as Wt,
  t as Xt,
  g as ks,
  L as qs,
  a as ts,
  j as xs,
} from "../chunks/Layout.0e76e124.js";
import {
  i as As,
  f as At,
  J as Bs,
  H as Ct,
  z as Et,
  s as Fs,
  S as Gs,
  v as Gt,
  o as Hs,
  N as Ls,
  O as Ms,
  L as Nt,
  b as Tt,
  u as U,
  P as Us,
  d as Ve,
  X as Yt,
  n as a,
  x as bs,
  A as bt,
  m as c,
  g as de,
  G as e,
  a as f,
  M as gs,
  y as gt,
  l as i,
  I as js,
  r as m,
  h as n,
  k as o,
  K as ps,
  p as pt,
  c as u,
  q as v,
  e as ws,
  B as wt,
  a0 as ys,
} from "../chunks/index.a8c54947.js";
import { M as Ys } from "../chunks/manager-gameweeks.a53f4a02.js";
import { m as Ks } from "../chunks/manager-store.ef17e835.js";
import { w as zt } from "../chunks/singletons.fdfa7ed0.js";
import { p as Js } from "../chunks/stores.95126db5.js";
function Ds(s, t, r) {
  const l = s.slice();
  l[21] = t[r];
  const _ = l[8](l[21].player.id);
  l[22] = _;
  const p = l[9](l[21].player.teamId);
  return (l[23] = p), l;
}
function Ps(s, t, r) {
  const l = s.slice();
  return (l[26] = t[r]), l;
}
function Ss(s) {
  let t,
    r,
    l = s[26] + "",
    _;
  return {
    c() {
      (t = o("option")), (r = v("Gameweek ")), (_ = v(l)), this.h();
    },
    l(p) {
      t = i(p, "OPTION", {});
      var w = c(t);
      (r = m(w, "Gameweek ")), (_ = m(w, l)), w.forEach(n), this.h();
    },
    h() {
      (t.__value = s[26]), (t.value = t.__value);
    },
    m(p, w) {
      Tt(p, t, w), e(t, r), e(t, _);
    },
    p: Ct,
    d(p) {
      p && n(t);
    },
  };
}
function Vs(s) {
  let t,
    r,
    l = Is(s[21].player.position) + "",
    _,
    p,
    w,
    P,
    E,
    L =
      s[22] && s[22].firstName.length > 2
        ? s[22].firstName.substring(0, 1) + "." + s[22].lastName
        : "",
    S,
    ee,
    j,
    G,
    q,
    A = s[23]?.friendlyName + "",
    N,
    M,
    k,
    J,
    X = s[21].appearance + "",
    Q,
    ve,
    D,
    O,
    ne = (s[21].highestScoringPlayerId === s[22]?.id ? 1 : 0) + "",
    I,
    K,
    R,
    me,
    te = s[21].goals + "",
    $e,
    y,
    Y,
    _e,
    Fe = s[21].assists + "",
    Ce,
    z,
    fe,
    Z,
    Re = s[21].penaltySaves + "",
    Qe,
    se,
    qe,
    ye,
    xe = s[21].cleanSheets + "",
    he,
    Ze,
    Ee,
    Ie,
    Ke = s[21].saves + "",
    Te,
    Ne,
    rt,
    ue,
    pe = s[21].yellowCards + "",
    et,
    W,
    Le,
    ge,
    be = s[21].ownGoals + "",
    tt,
    we,
    ke,
    De,
    Ye = s[21].goalsConceded + "",
    le,
    st,
    lt,
    oe,
    B = s[21].redCards + "",
    Pe,
    V,
    ft,
    g,
    $ = s[21].bonusPoints + "",
    b,
    H,
    ze,
    We,
    at = s[21].points + "",
    Se,
    He,
    x;
  var Xe = ks(s[22]?.nationality ?? "");
  function Me(h) {
    return { props: { class: "w-4 h-4 mr-1", size: "100" } };
  }
  return (
    Xe && (P = bs(Xe, Me())),
    (G = new Os({
      props: {
        primaryColour: s[23]?.primaryColourHex,
        secondaryColour: s[23]?.secondaryColourHex,
        thirdColour: s[23]?.thirdColourHex,
        className: "w-6 h-6 mr-2",
      },
    })),
    {
      c() {
        (t = o("div")),
          (r = o("div")),
          (_ = v(l)),
          (p = f()),
          (w = o("div")),
          P && gt(P.$$.fragment),
          (E = f()),
          (S = v(L)),
          (ee = f()),
          (j = o("div")),
          gt(G.$$.fragment),
          (q = f()),
          (N = v(A)),
          (M = f()),
          (k = o("div")),
          (J = o("div")),
          (Q = v(X)),
          (D = f()),
          (O = o("div")),
          (I = v(ne)),
          (R = f()),
          (me = o("div")),
          ($e = v(te)),
          (Y = f()),
          (_e = o("div")),
          (Ce = v(Fe)),
          (fe = f()),
          (Z = o("div")),
          (Qe = v(Re)),
          (qe = f()),
          (ye = o("div")),
          (he = v(xe)),
          (Ee = f()),
          (Ie = o("div")),
          (Te = v(Ke)),
          (rt = f()),
          (ue = o("div")),
          (et = v(pe)),
          (Le = f()),
          (ge = o("div")),
          (tt = v(be)),
          (ke = f()),
          (De = o("div")),
          (le = v(Ye)),
          (lt = f()),
          (oe = o("div")),
          (Pe = v(B)),
          (ft = f()),
          (g = o("div")),
          (b = v($)),
          (ze = f()),
          (We = o("div")),
          (Se = v(at)),
          (He = f()),
          this.h();
      },
      l(h) {
        t = i(h, "DIV", { class: !0 });
        var d = c(t);
        r = i(d, "DIV", { class: !0 });
        var Ge = c(r);
        (_ = m(Ge, l)),
          Ge.forEach(n),
          (p = u(d)),
          (w = i(d, "DIV", { class: !0 }));
        var Oe = c(w);
        P && Et(P.$$.fragment, Oe),
          (E = u(Oe)),
          (S = m(Oe, L)),
          Oe.forEach(n),
          (ee = u(d)),
          (j = i(d, "DIV", { class: !0 }));
        var nt = c(j);
        Et(G.$$.fragment, nt),
          (q = u(nt)),
          (N = m(nt, A)),
          nt.forEach(n),
          (M = u(d)),
          (k = i(d, "DIV", { class: !0 }));
        var T = c(k);
        J = i(T, "DIV", { class: !0 });
        var ut = c(J);
        (Q = m(ut, X)),
          ut.forEach(n),
          (D = u(T)),
          (O = i(T, "DIV", { class: !0 }));
        var vt = c(O);
        (I = m(vt, ne)),
          vt.forEach(n),
          (R = u(T)),
          (me = i(T, "DIV", { class: !0 }));
        var Be = c(me);
        ($e = m(Be, te)),
          Be.forEach(n),
          (Y = u(T)),
          (_e = i(T, "DIV", { class: !0 }));
        var Ue = c(_e);
        (Ce = m(Ue, Fe)),
          Ue.forEach(n),
          (fe = u(T)),
          (Z = i(T, "DIV", { class: !0 }));
        var je = c(Z);
        (Qe = m(je, Re)),
          je.forEach(n),
          (qe = u(T)),
          (ye = i(T, "DIV", { class: !0 }));
        var Je = c(ye);
        (he = m(Je, xe)),
          Je.forEach(n),
          (Ee = u(T)),
          (Ie = i(T, "DIV", { class: !0 }));
        var mt = c(Ie);
        (Te = m(mt, Ke)),
          mt.forEach(n),
          (rt = u(T)),
          (ue = i(T, "DIV", { class: !0 }));
        var ot = c(ue);
        (et = m(ot, pe)),
          ot.forEach(n),
          (Le = u(T)),
          (ge = i(T, "DIV", { class: !0 }));
        var _t = c(ge);
        (tt = m(_t, be)),
          _t.forEach(n),
          (ke = u(T)),
          (De = i(T, "DIV", { class: !0 }));
        var ie = c(De);
        (le = m(ie, Ye)),
          ie.forEach(n),
          (lt = u(T)),
          (oe = i(T, "DIV", { class: !0 }));
        var It = c(oe);
        (Pe = m(It, B)),
          It.forEach(n),
          (ft = u(T)),
          (g = i(T, "DIV", { class: !0 }));
        var yt = c(g);
        (b = m(yt, $)),
          yt.forEach(n),
          T.forEach(n),
          (ze = u(d)),
          (We = i(d, "DIV", { class: !0 }));
        var kt = c(We);
        (Se = m(kt, at)), kt.forEach(n), (He = u(d)), d.forEach(n), this.h();
      },
      h() {
        a(r, "class", "w-1/12 text-center mx-4"),
          a(w, "class", "w-2/12"),
          a(j, "class", "w-2/12 text-center flex items-center"),
          a(
            J,
            "class",
            (ve = `w-1/12 text-center ${
              s[21].appearance > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(
            O,
            "class",
            (K = `w-1/12 text-center ${
              s[21].highestScoringPlayerId === s[22]?.id ? "" : "text-gray-500"
            }`)
          ),
          a(
            me,
            "class",
            (y = `w-1/12 text-center ${s[21].goals > 0 ? "" : "text-gray-500"}`)
          ),
          a(
            _e,
            "class",
            (z = `w-1/12 text-center ${
              s[21].assists > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(
            Z,
            "class",
            (se = `w-1/12 text-center ${
              s[21].penaltySaves > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(
            ye,
            "class",
            (Ze = `w-1/12 text-center ${
              s[21].cleanSheets > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(
            Ie,
            "class",
            (Ne = `w-1/12 text-center ${
              s[21].saves > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(
            ue,
            "class",
            (W = `w-1/12 text-center ${
              s[21].yellowCards > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(
            ge,
            "class",
            (we = `w-1/12 text-center ${
              s[21].ownGoals > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(
            De,
            "class",
            (st = `w-1/12 text-center ${
              s[21].goalsConceded > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(
            oe,
            "class",
            (V = `w-1/12 text-center ${
              s[21].redCards > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(
            g,
            "class",
            (H = `w-1/12 text-center ${
              s[21].bonusPoints > 0 ? "" : "text-gray-500"
            }`)
          ),
          a(k, "class", "w-1/2 flex"),
          a(We, "class", "w-1/12 text-center"),
          a(
            t,
            "class",
            "flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer"
          );
      },
      m(h, d) {
        Tt(h, t, d),
          e(t, r),
          e(r, _),
          e(t, p),
          e(t, w),
          P && bt(P, w, null),
          e(w, E),
          e(w, S),
          e(t, ee),
          e(t, j),
          bt(G, j, null),
          e(j, q),
          e(j, N),
          e(t, M),
          e(t, k),
          e(k, J),
          e(J, Q),
          e(k, D),
          e(k, O),
          e(O, I),
          e(k, R),
          e(k, me),
          e(me, $e),
          e(k, Y),
          e(k, _e),
          e(_e, Ce),
          e(k, fe),
          e(k, Z),
          e(Z, Qe),
          e(k, qe),
          e(k, ye),
          e(ye, he),
          e(k, Ee),
          e(k, Ie),
          e(Ie, Te),
          e(k, rt),
          e(k, ue),
          e(ue, et),
          e(k, Le),
          e(k, ge),
          e(ge, tt),
          e(k, ke),
          e(k, De),
          e(De, le),
          e(k, lt),
          e(k, oe),
          e(oe, Pe),
          e(k, ft),
          e(k, g),
          e(g, b),
          e(t, ze),
          e(t, We),
          e(We, Se),
          e(t, He),
          (x = !0);
      },
      p(h, d) {
        if (
          ((!x || d & 32) &&
            l !== (l = Is(h[21].player.position) + "") &&
            U(_, l),
          d & 32 && Xe !== (Xe = ks(h[22]?.nationality ?? "")))
        ) {
          if (P) {
            Gt();
            const Oe = P;
            Ve(Oe.$$.fragment, 1, 0, () => {
              wt(Oe, 1);
            }),
              At();
          }
          Xe
            ? ((P = bs(Xe, Me())),
              gt(P.$$.fragment),
              de(P.$$.fragment, 1),
              bt(P, w, E))
            : (P = null);
        }
        (!x || d & 32) &&
          L !==
            (L =
              h[22] && h[22].firstName.length > 2
                ? h[22].firstName.substring(0, 1) + "." + h[22].lastName
                : "") &&
          U(S, L);
        const Ge = {};
        d & 32 && (Ge.primaryColour = h[23]?.primaryColourHex),
          d & 32 && (Ge.secondaryColour = h[23]?.secondaryColourHex),
          d & 32 && (Ge.thirdColour = h[23]?.thirdColourHex),
          G.$set(Ge),
          (!x || d & 32) && A !== (A = h[23]?.friendlyName + "") && U(N, A),
          (!x || d & 32) && X !== (X = h[21].appearance + "") && U(Q, X),
          (!x ||
            (d & 32 &&
              ve !==
                (ve = `w-1/12 text-center ${
                  h[21].appearance > 0 ? "" : "text-gray-500"
                }`))) &&
            a(J, "class", ve),
          (!x || d & 32) &&
            ne !==
              (ne =
                (h[21].highestScoringPlayerId === h[22]?.id ? 1 : 0) + "") &&
            U(I, ne),
          (!x ||
            (d & 32 &&
              K !==
                (K = `w-1/12 text-center ${
                  h[21].highestScoringPlayerId === h[22]?.id
                    ? ""
                    : "text-gray-500"
                }`))) &&
            a(O, "class", K),
          (!x || d & 32) && te !== (te = h[21].goals + "") && U($e, te),
          (!x ||
            (d & 32 &&
              y !==
                (y = `w-1/12 text-center ${
                  h[21].goals > 0 ? "" : "text-gray-500"
                }`))) &&
            a(me, "class", y),
          (!x || d & 32) && Fe !== (Fe = h[21].assists + "") && U(Ce, Fe),
          (!x ||
            (d & 32 &&
              z !==
                (z = `w-1/12 text-center ${
                  h[21].assists > 0 ? "" : "text-gray-500"
                }`))) &&
            a(_e, "class", z),
          (!x || d & 32) && Re !== (Re = h[21].penaltySaves + "") && U(Qe, Re),
          (!x ||
            (d & 32 &&
              se !==
                (se = `w-1/12 text-center ${
                  h[21].penaltySaves > 0 ? "" : "text-gray-500"
                }`))) &&
            a(Z, "class", se),
          (!x || d & 32) && xe !== (xe = h[21].cleanSheets + "") && U(he, xe),
          (!x ||
            (d & 32 &&
              Ze !==
                (Ze = `w-1/12 text-center ${
                  h[21].cleanSheets > 0 ? "" : "text-gray-500"
                }`))) &&
            a(ye, "class", Ze),
          (!x || d & 32) && Ke !== (Ke = h[21].saves + "") && U(Te, Ke),
          (!x ||
            (d & 32 &&
              Ne !==
                (Ne = `w-1/12 text-center ${
                  h[21].saves > 0 ? "" : "text-gray-500"
                }`))) &&
            a(Ie, "class", Ne),
          (!x || d & 32) && pe !== (pe = h[21].yellowCards + "") && U(et, pe),
          (!x ||
            (d & 32 &&
              W !==
                (W = `w-1/12 text-center ${
                  h[21].yellowCards > 0 ? "" : "text-gray-500"
                }`))) &&
            a(ue, "class", W),
          (!x || d & 32) && be !== (be = h[21].ownGoals + "") && U(tt, be),
          (!x ||
            (d & 32 &&
              we !==
                (we = `w-1/12 text-center ${
                  h[21].ownGoals > 0 ? "" : "text-gray-500"
                }`))) &&
            a(ge, "class", we),
          (!x || d & 32) && Ye !== (Ye = h[21].goalsConceded + "") && U(le, Ye),
          (!x ||
            (d & 32 &&
              st !==
                (st = `w-1/12 text-center ${
                  h[21].goalsConceded > 0 ? "" : "text-gray-500"
                }`))) &&
            a(De, "class", st),
          (!x || d & 32) && B !== (B = h[21].redCards + "") && U(Pe, B),
          (!x ||
            (d & 32 &&
              V !==
                (V = `w-1/12 text-center ${
                  h[21].redCards > 0 ? "" : "text-gray-500"
                }`))) &&
            a(oe, "class", V),
          (!x || d & 32) && $ !== ($ = h[21].bonusPoints + "") && U(b, $),
          (!x ||
            (d & 32 &&
              H !==
                (H = `w-1/12 text-center ${
                  h[21].bonusPoints > 0 ? "" : "text-gray-500"
                }`))) &&
            a(g, "class", H),
          (!x || d & 32) && at !== (at = h[21].points + "") && U(Se, at);
      },
      i(h) {
        x || (P && de(P.$$.fragment, h), de(G.$$.fragment, h), (x = !0));
      },
      o(h) {
        P && Ve(P.$$.fragment, h), Ve(G.$$.fragment, h), (x = !1);
      },
      d(h) {
        h && n(t), P && wt(P), wt(G);
      },
    }
  );
}
function zs(s) {
  let t,
    r,
    l,
    _,
    p,
    w,
    P,
    E,
    L,
    S,
    ee,
    j,
    G,
    q,
    A,
    N,
    M,
    k,
    J,
    X,
    Q,
    ve,
    D,
    O,
    ne,
    I,
    K,
    R,
    me,
    te,
    $e,
    y,
    Y,
    _e,
    Fe,
    Ce,
    z,
    fe,
    Z,
    Re,
    Qe,
    se,
    qe,
    ye,
    xe,
    he,
    Ze,
    Ee,
    Ie,
    Ke,
    Te,
    Ne,
    rt,
    ue,
    pe,
    et,
    W,
    Le,
    ge,
    be,
    tt,
    we,
    ke,
    De,
    Ye,
    le,
    st,
    lt,
    oe = s[6],
    B = [];
  for (let g = 0; g < oe.length; g += 1) B[g] = Ss(Ps(s, oe, g));
  let Pe = s[5],
    V = [];
  for (let g = 0; g < Pe.length; g += 1) V[g] = Vs(Ds(s, Pe, g));
  const ft = (g) =>
    Ve(V[g], 1, 1, () => {
      V[g] = null;
    });
  return {
    c() {
      (t = o("div")),
        (r = o("div")),
        (l = o("div")),
        (_ = o("button")),
        (p = v("<")),
        (P = f()),
        (E = o("select"));
      for (let g = 0; g < B.length; g += 1) B[g].c();
      (L = f()),
        (S = o("button")),
        (ee = v(">")),
        (G = f()),
        (q = o("div")),
        (A = o("div")),
        (N = o("div")),
        (M = o("div")),
        (k = v("Position")),
        (J = f()),
        (X = o("div")),
        (Q = v("Player")),
        (ve = f()),
        (D = o("div")),
        (O = v("Team")),
        (ne = f()),
        (I = o("div")),
        (K = o("div")),
        (R = v("A")),
        (me = f()),
        (te = o("div")),
        ($e = v("HSP")),
        (y = f()),
        (Y = o("div")),
        (_e = v("GS")),
        (Fe = f()),
        (Ce = o("div")),
        (z = v("GA")),
        (fe = f()),
        (Z = o("div")),
        (Re = v("PS")),
        (Qe = f()),
        (se = o("div")),
        (qe = v("CS")),
        (ye = f()),
        (xe = o("div")),
        (he = v("KS")),
        (Ze = f()),
        (Ee = o("div")),
        (Ie = v("YC")),
        (Ke = f()),
        (Te = o("div")),
        (Ne = v("OG")),
        (rt = f()),
        (ue = o("div")),
        (pe = v("GC")),
        (et = f()),
        (W = o("div")),
        (Le = v("RC")),
        (ge = f()),
        (be = o("div")),
        (tt = v("B")),
        (we = f()),
        (ke = o("div")),
        (De = v("PTS")),
        (Ye = f());
      for (let g = 0; g < V.length; g += 1) V[g].c();
      this.h();
    },
    l(g) {
      t = i(g, "DIV", { class: !0 });
      var $ = c(t);
      r = i($, "DIV", { class: !0 });
      var b = c(r);
      l = i(b, "DIV", { class: !0 });
      var H = c(l);
      _ = i(H, "BUTTON", { class: !0 });
      var ze = c(_);
      (p = m(ze, "<")),
        ze.forEach(n),
        (P = u(H)),
        (E = i(H, "SELECT", { class: !0 }));
      var We = c(E);
      for (let ie = 0; ie < B.length; ie += 1) B[ie].l(We);
      We.forEach(n), (L = u(H)), (S = i(H, "BUTTON", { class: !0 }));
      var at = c(S);
      (ee = m(at, ">")),
        at.forEach(n),
        H.forEach(n),
        b.forEach(n),
        (G = u($)),
        (q = i($, "DIV", { class: !0 }));
      var Se = c(q);
      A = i(Se, "DIV", { class: !0 });
      var He = c(A);
      N = i(He, "DIV", { class: !0 });
      var x = c(N);
      M = i(x, "DIV", { class: !0 });
      var Xe = c(M);
      (k = m(Xe, "Position")),
        Xe.forEach(n),
        (J = u(x)),
        (X = i(x, "DIV", { class: !0 }));
      var Me = c(X);
      (Q = m(Me, "Player")),
        Me.forEach(n),
        (ve = u(x)),
        (D = i(x, "DIV", { class: !0 }));
      var h = c(D);
      (O = m(h, "Team")),
        h.forEach(n),
        (ne = u(x)),
        (I = i(x, "DIV", { class: !0 }));
      var d = c(I);
      K = i(d, "DIV", { class: !0 });
      var Ge = c(K);
      (R = m(Ge, "A")),
        Ge.forEach(n),
        (me = u(d)),
        (te = i(d, "DIV", { class: !0 }));
      var Oe = c(te);
      ($e = m(Oe, "HSP")),
        Oe.forEach(n),
        (y = u(d)),
        (Y = i(d, "DIV", { class: !0 }));
      var nt = c(Y);
      (_e = m(nt, "GS")),
        nt.forEach(n),
        (Fe = u(d)),
        (Ce = i(d, "DIV", { class: !0 }));
      var T = c(Ce);
      (z = m(T, "GA")),
        T.forEach(n),
        (fe = u(d)),
        (Z = i(d, "DIV", { class: !0 }));
      var ut = c(Z);
      (Re = m(ut, "PS")),
        ut.forEach(n),
        (Qe = u(d)),
        (se = i(d, "DIV", { class: !0 }));
      var vt = c(se);
      (qe = m(vt, "CS")),
        vt.forEach(n),
        (ye = u(d)),
        (xe = i(d, "DIV", { class: !0 }));
      var Be = c(xe);
      (he = m(Be, "KS")),
        Be.forEach(n),
        (Ze = u(d)),
        (Ee = i(d, "DIV", { class: !0 }));
      var Ue = c(Ee);
      (Ie = m(Ue, "YC")),
        Ue.forEach(n),
        (Ke = u(d)),
        (Te = i(d, "DIV", { class: !0 }));
      var je = c(Te);
      (Ne = m(je, "OG")),
        je.forEach(n),
        (rt = u(d)),
        (ue = i(d, "DIV", { class: !0 }));
      var Je = c(ue);
      (pe = m(Je, "GC")),
        Je.forEach(n),
        (et = u(d)),
        (W = i(d, "DIV", { class: !0 }));
      var mt = c(W);
      (Le = m(mt, "RC")),
        mt.forEach(n),
        (ge = u(d)),
        (be = i(d, "DIV", { class: !0 }));
      var ot = c(be);
      (tt = m(ot, "B")),
        ot.forEach(n),
        d.forEach(n),
        (we = u(x)),
        (ke = i(x, "DIV", { class: !0 }));
      var _t = c(ke);
      (De = m(_t, "PTS")), _t.forEach(n), x.forEach(n), (Ye = u(He));
      for (let ie = 0; ie < V.length; ie += 1) V[ie].l(He);
      He.forEach(n), Se.forEach(n), $.forEach(n), this.h();
    },
    h() {
      a(
        _,
        "class",
        "text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
      ),
        (_.disabled = w = s[0] === 1),
        a(
          E,
          "class",
          "p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]"
        ),
        s[0] === void 0 && Bs(() => s[13].call(E)),
        a(
          S,
          "class",
          "text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
        ),
        (S.disabled = j = s[0] === 38),
        a(l, "class", "flex items-center space-x-2"),
        a(r, "class", "flex flex-col sm:flex-row gap-4 sm:gap-8"),
        a(M, "class", "w-1/12 text-center mx-4"),
        a(X, "class", "w-2/12"),
        a(D, "class", "w-2/12 text-center"),
        a(K, "class", "w-1/12 text-center"),
        a(te, "class", "w-1/12 text-center"),
        a(Y, "class", "w-1/12 text-center"),
        a(Ce, "class", "w-1/12 text-center"),
        a(Z, "class", "w-1/12 text-center"),
        a(se, "class", "w-1/12 text-center"),
        a(xe, "class", "w-1/12 text-center"),
        a(Ee, "class", "w-1/12 text-center"),
        a(Te, "class", "w-1/12 text-center"),
        a(ue, "class", "w-1/12 text-center"),
        a(W, "class", "w-1/12 text-center"),
        a(be, "class", "w-1/12 text-center"),
        a(I, "class", "w-1/2 flex"),
        a(ke, "class", "w-1/12 text-center"),
        a(
          N,
          "class",
          "flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
        ),
        a(A, "class", "overflow-x-auto flex-1"),
        a(q, "class", "flex flex-col space-y-4 mt-4 text-lg"),
        a(t, "class", "mx-5 my-4");
    },
    m(g, $) {
      Tt(g, t, $), e(t, r), e(r, l), e(l, _), e(_, p), e(l, P), e(l, E);
      for (let b = 0; b < B.length; b += 1) B[b] && B[b].m(E, null);
      ps(E, s[0], !0),
        e(l, L),
        e(l, S),
        e(S, ee),
        e(t, G),
        e(t, q),
        e(q, A),
        e(A, N),
        e(N, M),
        e(M, k),
        e(N, J),
        e(N, X),
        e(X, Q),
        e(N, ve),
        e(N, D),
        e(D, O),
        e(N, ne),
        e(N, I),
        e(I, K),
        e(K, R),
        e(I, me),
        e(I, te),
        e(te, $e),
        e(I, y),
        e(I, Y),
        e(Y, _e),
        e(I, Fe),
        e(I, Ce),
        e(Ce, z),
        e(I, fe),
        e(I, Z),
        e(Z, Re),
        e(I, Qe),
        e(I, se),
        e(se, qe),
        e(I, ye),
        e(I, xe),
        e(xe, he),
        e(I, Ze),
        e(I, Ee),
        e(Ee, Ie),
        e(I, Ke),
        e(I, Te),
        e(Te, Ne),
        e(I, rt),
        e(I, ue),
        e(ue, pe),
        e(I, et),
        e(I, W),
        e(W, Le),
        e(I, ge),
        e(I, be),
        e(be, tt),
        e(N, we),
        e(N, ke),
        e(ke, De),
        e(A, Ye);
      for (let b = 0; b < V.length; b += 1) V[b] && V[b].m(A, null);
      (le = !0),
        st ||
          ((lt = [
            Nt(_, "click", s[12]),
            Nt(E, "change", s[13]),
            Nt(S, "click", s[14]),
          ]),
          (st = !0));
    },
    p(g, [$]) {
      if (
        ((!le || ($ & 65 && w !== (w = g[0] === 1))) && (_.disabled = w),
        $ & 64)
      ) {
        oe = g[6];
        let b;
        for (b = 0; b < oe.length; b += 1) {
          const H = Ps(g, oe, b);
          B[b] ? B[b].p(H, $) : ((B[b] = Ss(H)), B[b].c(), B[b].m(E, null));
        }
        for (; b < B.length; b += 1) B[b].d(1);
        B.length = oe.length;
      }
      if (
        ($ & 65 && ps(E, g[0]),
        (!le || ($ & 65 && j !== (j = g[0] === 38))) && (S.disabled = j),
        $ & 800)
      ) {
        Pe = g[5];
        let b;
        for (b = 0; b < Pe.length; b += 1) {
          const H = Ds(g, Pe, b);
          V[b]
            ? (V[b].p(H, $), de(V[b], 1))
            : ((V[b] = Vs(H)), V[b].c(), de(V[b], 1), V[b].m(A, null));
        }
        for (Gt(), b = Pe.length; b < V.length; b += 1) ft(b);
        At();
      }
    },
    i(g) {
      if (!le) {
        for (let $ = 0; $ < Pe.length; $ += 1) de(V[$]);
        le = !0;
      }
    },
    o(g) {
      V = V.filter(Boolean);
      for (let $ = 0; $ < V.length; $ += 1) Ve(V[$]);
      le = !1;
    },
    d(g) {
      g && n(t), gs(B, g), gs(V, g), (st = !1), Ls(lt);
    },
  };
}
function Ws(s, t, r) {
  let l,
    _ = Ct,
    p = () => (_(), (_ = Yt(A, (y) => r(18, (l = y)))), A),
    w,
    P = Ct,
    E = () => (P(), (P = Yt(N, (y) => r(19, (w = y)))), N),
    L,
    S = Ct,
    ee = () => (S(), (S = Yt(O, (y) => r(10, (L = y)))), O),
    j,
    G = Ct,
    q = () => (G(), (G = Yt(M, (y) => r(11, (j = y)))), M);
  s.$$.on_destroy.push(() => _()),
    s.$$.on_destroy.push(() => P()),
    s.$$.on_destroy.push(() => S()),
    s.$$.on_destroy.push(() => G());
  let { teams: A = zt([]) } = t;
  p();
  let { players: N = zt([]) } = t;
  E();
  let { systemState: M = zt(null) } = t;
  q();
  let k,
    J,
    X,
    Q = [],
    ve = Array.from({ length: 38 }, (y, Y) => Y + 1),
    { selectedGameweek: D } = t,
    { fantasyTeam: O } = t;
  ee(),
    Hs(async () => {
      try {
        await Wt.sync(),
          await Xt.sync(),
          await xs.sync(),
          await Es.sync(),
          (k = Wt.subscribe((y) => {
            M.set(y);
          })),
          (J = Xt.subscribe((y) => {
            A.set(y);
          })),
          (X = xs.subscribe((y) => {
            N.set(y);
          }));
      } catch (y) {
        ts.show("Error fetching manager gameweek detail.", "error"),
          console.error("Error fetching manager gameweek detail:", y);
      }
    });
  async function ne() {
    try {
      r(5, (Q = await Es.getGameweekPlayers(L, D)));
    } catch (y) {
      ts.show("Error updating gameweek players.", "error"),
        console.error("Error updating gameweek players:", y);
    }
  }
  Ms(() => {
    J?.(), X?.(), k?.();
  });
  const I = (y) => {
    r(0, (D = Math.max(1, Math.min(38, D + y))));
  };
  function K(y) {
    return w.find((Y) => Y.id === y) ?? null;
  }
  function R(y) {
    return l.find((Y) => Y.id === y) ?? null;
  }
  const me = () => I(-1);
  function te() {
    (D = Us(this)), r(0, D), r(11, j), r(6, ve);
  }
  const $e = () => I(1);
  return (
    (s.$$set = (y) => {
      "teams" in y && p(r(1, (A = y.teams))),
        "players" in y && E(r(2, (N = y.players))),
        "systemState" in y && q(r(3, (M = y.systemState))),
        "selectedGameweek" in y && r(0, (D = y.selectedGameweek)),
        "fantasyTeam" in y && ee(r(4, (O = y.fantasyTeam)));
    }),
    (s.$$.update = () => {
      s.$$.dirty & 2049 && j && r(0, (D = j?.activeGameweek ?? D)),
        s.$$.dirty & 1024 && L && ne();
    }),
    [D, A, N, M, O, Q, ve, I, K, R, L, j, me, te, $e]
  );
}
class Xs extends Gs {
  constructor(t) {
    super(),
      As(this, t, Ws, zs, Fs, {
        teams: 1,
        players: 2,
        systemState: 3,
        selectedGameweek: 0,
        fantasyTeam: 4,
      });
  }
}
function Qs(s) {
  let t,
    r,
    l,
    _,
    p,
    w,
    P,
    E,
    L,
    S,
    ee,
    j,
    G,
    q,
    A,
    N,
    M,
    k,
    J,
    X,
    Q,
    ve,
    D,
    O,
    ne,
    I,
    K,
    R,
    me,
    te = (s[3]?.abbreviatedName ?? "-") + "",
    $e,
    y,
    Y,
    _e = (s[3]?.name ?? "Not Set") + "",
    Fe,
    Ce,
    z,
    fe,
    Z,
    Re,
    Qe,
    se,
    qe = s[1].weeklyPositionText + "",
    ye,
    xe,
    he,
    Ze,
    Ee = s[1].weeklyPoints.toLocaleString() + "",
    Ie,
    Ke,
    Te,
    Ne,
    rt,
    ue,
    pe,
    et,
    W,
    Le,
    ge = (s[3]?.friendlyName ?? "Not Entered") + "",
    be,
    tt,
    we,
    ke = s[1].monthlyPositionText + "",
    De,
    Ye,
    le,
    st,
    lt = (s[3] ? s[1].monthlyPoints.toLocaleString() : "-") + "",
    oe,
    B,
    Pe,
    V,
    ft,
    g,
    $,
    b,
    H,
    ze,
    We,
    at,
    Se,
    He = s[1].seasonPositionText + "",
    x,
    Xe,
    Me,
    h,
    d = s[1].seasonPoints.toLocaleString() + "",
    Ge,
    Oe,
    nt,
    T,
    ut,
    vt,
    Be,
    Ue,
    je,
    Je,
    mt,
    ot,
    _t,
    ie,
    It,
    yt,
    kt,
    xt,
    Qt,
    it,
    Ft,
    ce,
    Zt,
    ss;
  R = new Os({
    props: {
      className: "w-7 mr-2",
      primaryColour: s[3]?.primaryColourHex ?? "#2CE3A6",
      secondaryColour: s[3]?.secondaryColourHex ?? "#FFFFFF",
      thirdColour: s[3]?.thirdColourHex ?? "#000000",
    },
  });
  let Ae = s[0] === "details" && $s(),
    ae = s[0] === "details" && Cs(s),
    re = s[0] === "gameweeks" && Ts(s);
  return {
    c() {
      (t = o("div")),
        (r = o("div")),
        (l = o("div")),
        (_ = o("div")),
        (p = o("img")),
        (P = f()),
        (E = o("div")),
        (L = f()),
        (S = o("div")),
        (ee = o("p")),
        (j = v("Manager")),
        (G = f()),
        (q = o("p")),
        (A = v(s[2])),
        (N = f()),
        (M = o("p")),
        (k = v("Joined: ")),
        (J = v(s[4])),
        (X = f()),
        (Q = o("div")),
        (ve = f()),
        (D = o("div")),
        (O = o("p")),
        (ne = v("Favourite Team")),
        (I = f()),
        (K = o("p")),
        gt(R.$$.fragment),
        (me = f()),
        ($e = v(te)),
        (y = f()),
        (Y = o("p")),
        (Fe = v(_e)),
        (Ce = f()),
        (z = o("div")),
        (fe = o("div")),
        (Z = o("p")),
        (Re = v("Leaderboards")),
        (Qe = f()),
        (se = o("p")),
        (ye = v(qe)),
        (xe = f()),
        (he = o("span")),
        (Ze = v("(")),
        (Ie = v(Ee)),
        (Ke = v(")")),
        (Te = f()),
        (Ne = o("p")),
        (rt = v("Weekly")),
        (ue = f()),
        (pe = o("div")),
        (et = f()),
        (W = o("div")),
        (Le = o("p")),
        (be = v(ge)),
        (tt = f()),
        (we = o("p")),
        (De = v(ke)),
        (Ye = f()),
        (le = o("span")),
        (st = v("(")),
        (oe = v(lt)),
        (B = v(")")),
        (Pe = f()),
        (V = o("p")),
        (ft = v("Club")),
        (g = f()),
        ($ = o("div")),
        (b = f()),
        (H = o("div")),
        (ze = o("p")),
        (We = v(Ns)),
        (at = f()),
        (Se = o("p")),
        (x = v(He)),
        (Xe = f()),
        (Me = o("span")),
        (h = v("(")),
        (Ge = v(d)),
        (Oe = v(")")),
        (nt = f()),
        (T = o("p")),
        (ut = v("Season")),
        (vt = f()),
        (Be = o("div")),
        (Ue = o("div")),
        (je = o("div")),
        (Je = o("button")),
        (mt = v("Details")),
        (_t = f()),
        (ie = o("button")),
        (It = v("Gameweeks")),
        (kt = f()),
        (xt = o("div")),
        Ae && Ae.c(),
        (Qt = f()),
        (it = o("div")),
        ae && ae.c(),
        (Ft = f()),
        re && re.c(),
        this.h();
    },
    l(C) {
      t = i(C, "DIV", { class: !0 });
      var F = c(t);
      r = i(F, "DIV", { class: !0 });
      var ht = c(r);
      l = i(ht, "DIV", { class: !0 });
      var ct = c(l);
      _ = i(ct, "DIV", { class: !0 });
      var ls = c(_);
      (p = i(ls, "IMG", { class: !0, src: !0, alt: !0 })),
        ls.forEach(n),
        (P = u(ct)),
        (E = i(ct, "DIV", { class: !0, style: !0 })),
        c(E).forEach(n),
        (L = u(ct)),
        (S = i(ct, "DIV", { class: !0 }));
      var Dt = c(S);
      ee = i(Dt, "P", { class: !0 });
      var as = c(ee);
      (j = m(as, "Manager")),
        as.forEach(n),
        (G = u(Dt)),
        (q = i(Dt, "P", { class: !0 }));
      var rs = c(q);
      (A = m(rs, s[2])),
        rs.forEach(n),
        (N = u(Dt)),
        (M = i(Dt, "P", { class: !0 }));
      var es = c(M);
      (k = m(es, "Joined: ")),
        (J = m(es, s[4])),
        es.forEach(n),
        Dt.forEach(n),
        (X = u(ct)),
        (Q = i(ct, "DIV", { class: !0, style: !0 })),
        c(Q).forEach(n),
        (ve = u(ct)),
        (D = i(ct, "DIV", { class: !0 }));
      var Pt = c(D);
      O = i(Pt, "P", { class: !0 });
      var ns = c(O);
      (ne = m(ns, "Favourite Team")),
        ns.forEach(n),
        (I = u(Pt)),
        (K = i(Pt, "P", { class: !0 }));
      var Lt = c(K);
      Et(R.$$.fragment, Lt),
        (me = u(Lt)),
        ($e = m(Lt, te)),
        Lt.forEach(n),
        (y = u(Pt)),
        (Y = i(Pt, "P", { class: !0 }));
      var os = c(Y);
      (Fe = m(os, _e)),
        os.forEach(n),
        Pt.forEach(n),
        ct.forEach(n),
        (Ce = u(ht)),
        (z = i(ht, "DIV", { class: !0 }));
      var dt = c(z);
      fe = i(dt, "DIV", { class: !0 });
      var St = c(fe);
      Z = i(St, "P", { class: !0 });
      var is = c(Z);
      (Re = m(is, "Leaderboards")),
        is.forEach(n),
        (Qe = u(St)),
        (se = i(St, "P", { class: !0 }));
      var Ht = c(se);
      (ye = m(Ht, qe)), (xe = u(Ht)), (he = i(Ht, "SPAN", { class: !0 }));
      var Mt = c(he);
      (Ze = m(Mt, "(")),
        (Ie = m(Mt, Ee)),
        (Ke = m(Mt, ")")),
        Mt.forEach(n),
        Ht.forEach(n),
        (Te = u(St)),
        (Ne = i(St, "P", { class: !0 }));
      var cs = c(Ne);
      (rt = m(cs, "Weekly")),
        cs.forEach(n),
        St.forEach(n),
        (ue = u(dt)),
        (pe = i(dt, "DIV", { class: !0, style: !0 })),
        c(pe).forEach(n),
        (et = u(dt)),
        (W = i(dt, "DIV", { class: !0 }));
      var Vt = c(W);
      Le = i(Vt, "P", { class: !0 });
      var ds = c(Le);
      (be = m(ds, ge)),
        ds.forEach(n),
        (tt = u(Vt)),
        (we = i(Vt, "P", { class: !0 }));
      var Ot = c(we);
      (De = m(Ot, ke)), (Ye = u(Ot)), (le = i(Ot, "SPAN", { class: !0 }));
      var Bt = c(le);
      (st = m(Bt, "(")),
        (oe = m(Bt, lt)),
        (B = m(Bt, ")")),
        Bt.forEach(n),
        Ot.forEach(n),
        (Pe = u(Vt)),
        (V = i(Vt, "P", { class: !0 }));
      var fs = c(V);
      (ft = m(fs, "Club")),
        fs.forEach(n),
        Vt.forEach(n),
        (g = u(dt)),
        ($ = i(dt, "DIV", { class: !0, style: !0 })),
        c($).forEach(n),
        (b = u(dt)),
        (H = i(dt, "DIV", { class: !0 }));
      var $t = c(H);
      ze = i($t, "P", { class: !0 });
      var us = c(ze);
      (We = m(us, Ns)),
        us.forEach(n),
        (at = u($t)),
        (Se = i($t, "P", { class: !0 }));
      var Ut = c(Se);
      (x = m(Ut, He)), (Xe = u(Ut)), (Me = i(Ut, "SPAN", { class: !0 }));
      var jt = c(Me);
      (h = m(jt, "(")),
        (Ge = m(jt, d)),
        (Oe = m(jt, ")")),
        jt.forEach(n),
        Ut.forEach(n),
        (nt = u($t)),
        (T = i($t, "P", { class: !0 }));
      var vs = c(T);
      (ut = m(vs, "Season")),
        vs.forEach(n),
        $t.forEach(n),
        dt.forEach(n),
        ht.forEach(n),
        (vt = u(F)),
        (Be = i(F, "DIV", { class: !0 }));
      var Jt = c(Be);
      Ue = i(Jt, "DIV", { class: !0 });
      var Rt = c(Ue);
      je = i(Rt, "DIV", { class: !0 });
      var qt = c(je);
      Je = i(qt, "BUTTON", { class: !0 });
      var ms = c(Je);
      (mt = m(ms, "Details")),
        ms.forEach(n),
        (_t = u(qt)),
        (ie = i(qt, "BUTTON", { class: !0 }));
      var _s = c(ie);
      (It = m(_s, "Gameweeks")),
        _s.forEach(n),
        qt.forEach(n),
        (kt = u(Rt)),
        (xt = i(Rt, "DIV", { class: !0 }));
      var hs = c(xt);
      Ae && Ae.l(hs),
        hs.forEach(n),
        Rt.forEach(n),
        (Qt = u(Jt)),
        (it = i(Jt, "DIV", { class: !0 }));
      var Kt = c(it);
      ae && ae.l(Kt),
        (Ft = u(Kt)),
        re && re.l(Kt),
        Kt.forEach(n),
        Jt.forEach(n),
        F.forEach(n),
        this.h();
    },
    h() {
      a(p, "class", "w-20"),
        ys(p.src, (w = s[5])) || a(p, "src", w),
        a(p, "alt", s[2]),
        a(_, "class", "flex"),
        a(E, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
        pt(E, "min-width", "2px"),
        pt(E, "min-height", "50px"),
        a(ee, "class", "text-gray-300 text-xs"),
        a(q, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
        a(M, "class", "text-gray-300 text-xs"),
        a(S, "class", "flex-grow"),
        a(Q, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
        pt(Q, "min-width", "2px"),
        pt(Q, "min-height", "50px"),
        a(O, "class", "text-gray-300 text-xs"),
        a(
          K,
          "class",
          "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold flex items-center"
        ),
        a(Y, "class", "text-gray-300 text-xs"),
        a(D, "class", "flex-grow"),
        a(
          l,
          "class",
          "flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        ),
        a(Z, "class", "text-gray-300 text-xs"),
        a(he, "class", "text-xs"),
        a(se, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
        a(Ne, "class", "text-gray-300 text-xs"),
        a(fe, "class", "flex-grow"),
        a(pe, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
        pt(pe, "min-width", "2px"),
        pt(pe, "min-height", "50px"),
        a(Le, "class", "text-gray-300 text-xs"),
        a(le, "class", "text-xs"),
        a(we, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
        a(V, "class", "text-gray-300 text-xs"),
        a(W, "class", "flex-grow"),
        a($, "class", "flex-shrink-0 w-px bg-gray-400 self-stretch"),
        pt($, "min-width", "2px"),
        pt($, "min-height", "50px"),
        a(ze, "class", "text-gray-300 text-xs"),
        a(Me, "class", "text-xs"),
        a(Se, "class", "text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"),
        a(T, "class", "text-gray-300 text-xs"),
        a(H, "class", "flex-grow"),
        a(
          z,
          "class",
          "flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        ),
        a(r, "class", "flex flex-col md:flex-row"),
        a(
          Je,
          "class",
          (ot = `btn ${
            s[0] === "details" ? "fpl-button" : "inactive-btn"
          } px-4 py-2 rounded-l-md font-bold text-md min-w-[125px]`)
        ),
        a(
          ie,
          "class",
          (yt = `btn ${
            s[0] === "gameweeks" ? "fpl-button" : "inactive-btn"
          } px-4 py-2 rounded-r-md font-bold text-md min-w-[125px]`)
        ),
        a(je, "class", "flex"),
        a(xt, "class", "px-4"),
        a(
          Ue,
          "class",
          "flex justify-between items-center text-white px-4 pt-4 rounded-md w-full"
        ),
        a(it, "class", "w-full"),
        a(Be, "class", "flex flex-col bg-panel m-4 rounded-md"),
        a(t, "class", "m-4");
    },
    m(C, F) {
      Tt(C, t, F),
        e(t, r),
        e(r, l),
        e(l, _),
        e(_, p),
        e(l, P),
        e(l, E),
        e(l, L),
        e(l, S),
        e(S, ee),
        e(ee, j),
        e(S, G),
        e(S, q),
        e(q, A),
        e(S, N),
        e(S, M),
        e(M, k),
        e(M, J),
        e(l, X),
        e(l, Q),
        e(l, ve),
        e(l, D),
        e(D, O),
        e(O, ne),
        e(D, I),
        e(D, K),
        bt(R, K, null),
        e(K, me),
        e(K, $e),
        e(D, y),
        e(D, Y),
        e(Y, Fe),
        e(r, Ce),
        e(r, z),
        e(z, fe),
        e(fe, Z),
        e(Z, Re),
        e(fe, Qe),
        e(fe, se),
        e(se, ye),
        e(se, xe),
        e(se, he),
        e(he, Ze),
        e(he, Ie),
        e(he, Ke),
        e(fe, Te),
        e(fe, Ne),
        e(Ne, rt),
        e(z, ue),
        e(z, pe),
        e(z, et),
        e(z, W),
        e(W, Le),
        e(Le, be),
        e(W, tt),
        e(W, we),
        e(we, De),
        e(we, Ye),
        e(we, le),
        e(le, st),
        e(le, oe),
        e(le, B),
        e(W, Pe),
        e(W, V),
        e(V, ft),
        e(z, g),
        e(z, $),
        e(z, b),
        e(z, H),
        e(H, ze),
        e(ze, We),
        e(H, at),
        e(H, Se),
        e(Se, x),
        e(Se, Xe),
        e(Se, Me),
        e(Me, h),
        e(Me, Ge),
        e(Me, Oe),
        e(H, nt),
        e(H, T),
        e(T, ut),
        e(t, vt),
        e(t, Be),
        e(Be, Ue),
        e(Ue, je),
        e(je, Je),
        e(Je, mt),
        e(je, _t),
        e(je, ie),
        e(ie, It),
        e(Ue, kt),
        e(Ue, xt),
        Ae && Ae.m(xt, null),
        e(Be, Qt),
        e(Be, it),
        ae && ae.m(it, null),
        e(it, Ft),
        re && re.m(it, null),
        (ce = !0),
        Zt ||
          ((ss = [Nt(Je, "click", s[13]), Nt(ie, "click", s[14])]), (Zt = !0));
    },
    p(C, F) {
      (!ce || (F & 32 && !ys(p.src, (w = C[5])))) && a(p, "src", w),
        (!ce || F & 4) && a(p, "alt", C[2]),
        (!ce || F & 4) && U(A, C[2]),
        (!ce || F & 16) && U(J, C[4]);
      const ht = {};
      F & 8 && (ht.primaryColour = C[3]?.primaryColourHex ?? "#2CE3A6"),
        F & 8 && (ht.secondaryColour = C[3]?.secondaryColourHex ?? "#FFFFFF"),
        F & 8 && (ht.thirdColour = C[3]?.thirdColourHex ?? "#000000"),
        R.$set(ht),
        (!ce || F & 8) &&
          te !== (te = (C[3]?.abbreviatedName ?? "-") + "") &&
          U($e, te),
        (!ce || F & 8) &&
          _e !== (_e = (C[3]?.name ?? "Not Set") + "") &&
          U(Fe, _e),
        (!ce || F & 2) &&
          qe !== (qe = C[1].weeklyPositionText + "") &&
          U(ye, qe),
        (!ce || F & 2) &&
          Ee !== (Ee = C[1].weeklyPoints.toLocaleString() + "") &&
          U(Ie, Ee),
        (!ce || F & 8) &&
          ge !== (ge = (C[3]?.friendlyName ?? "Not Entered") + "") &&
          U(be, ge),
        (!ce || F & 2) &&
          ke !== (ke = C[1].monthlyPositionText + "") &&
          U(De, ke),
        (!ce || F & 10) &&
          lt !==
            (lt = (C[3] ? C[1].monthlyPoints.toLocaleString() : "-") + "") &&
          U(oe, lt),
        (!ce || F & 2) &&
          He !== (He = C[1].seasonPositionText + "") &&
          U(x, He),
        (!ce || F & 2) &&
          d !== (d = C[1].seasonPoints.toLocaleString() + "") &&
          U(Ge, d),
        (!ce ||
          (F & 1 &&
            ot !==
              (ot = `btn ${
                C[0] === "details" ? "fpl-button" : "inactive-btn"
              } px-4 py-2 rounded-l-md font-bold text-md min-w-[125px]`))) &&
          a(Je, "class", ot),
        (!ce ||
          (F & 1 &&
            yt !==
              (yt = `btn ${
                C[0] === "gameweeks" ? "fpl-button" : "inactive-btn"
              } px-4 py-2 rounded-r-md font-bold text-md min-w-[125px]`))) &&
          a(ie, "class", yt),
        C[0] === "details"
          ? Ae || ((Ae = $s()), Ae.c(), Ae.m(xt, null))
          : Ae && (Ae.d(1), (Ae = null)),
        C[0] === "details"
          ? ae
            ? (ae.p(C, F), F & 1 && de(ae, 1))
            : ((ae = Cs(C)), ae.c(), de(ae, 1), ae.m(it, Ft))
          : ae &&
            (Gt(),
            Ve(ae, 1, 1, () => {
              ae = null;
            }),
            At()),
        C[0] === "gameweeks"
          ? re
            ? (re.p(C, F), F & 1 && de(re, 1))
            : ((re = Ts(C)), re.c(), de(re, 1), re.m(it, null))
          : re &&
            (Gt(),
            Ve(re, 1, 1, () => {
              re = null;
            }),
            At());
    },
    i(C) {
      ce || (de(R.$$.fragment, C), de(ae), de(re), (ce = !0));
    },
    o(C) {
      Ve(R.$$.fragment, C), Ve(ae), Ve(re), (ce = !1);
    },
    d(C) {
      C && n(t),
        wt(R),
        Ae && Ae.d(),
        ae && ae.d(),
        re && re.d(),
        (Zt = !1),
        Ls(ss);
    },
  };
}
function Zs(s) {
  let t, r;
  return (
    (t = new qs({})),
    {
      c() {
        gt(t.$$.fragment);
      },
      l(l) {
        Et(t.$$.fragment, l);
      },
      m(l, _) {
        bt(t, l, _), (r = !0);
      },
      p: Ct,
      i(l) {
        r || (de(t.$$.fragment, l), (r = !0));
      },
      o(l) {
        Ve(t.$$.fragment, l), (r = !1);
      },
      d(l) {
        wt(t, l);
      },
    }
  );
}
function $s(s) {
  let t,
    r,
    l = "0",
    _;
  return {
    c() {
      (t = o("span")), (r = v("Total Points: ")), (_ = v(l)), this.h();
    },
    l(p) {
      t = i(p, "SPAN", { class: !0 });
      var w = c(t);
      (r = m(w, "Total Points: ")), (_ = m(w, l)), w.forEach(n), this.h();
    },
    h() {
      a(t, "class", "text-2xl");
    },
    m(p, w) {
      Tt(p, t, w), e(t, r), e(t, _);
    },
    d(p) {
      p && n(t);
    },
  };
}
function Cs(s) {
  let t, r;
  return (
    (t = new Xs({ props: { selectedGameweek: s[7], fantasyTeam: s[8] } })),
    {
      c() {
        gt(t.$$.fragment);
      },
      l(l) {
        Et(t.$$.fragment, l);
      },
      m(l, _) {
        bt(t, l, _), (r = !0);
      },
      p(l, _) {
        const p = {};
        _ & 128 && (p.selectedGameweek = l[7]), t.$set(p);
      },
      i(l) {
        r || (de(t.$$.fragment, l), (r = !0));
      },
      o(l) {
        Ve(t.$$.fragment, l), (r = !1);
      },
      d(l) {
        wt(t, l);
      },
    }
  );
}
function Ts(s) {
  let t, r;
  return (
    (t = new Ys({
      props: { viewGameweekDetail: s[10], principalId: s[1].principalId },
    })),
    {
      c() {
        gt(t.$$.fragment);
      },
      l(l) {
        Et(t.$$.fragment, l);
      },
      m(l, _) {
        bt(t, l, _), (r = !0);
      },
      p(l, _) {
        const p = {};
        _ & 2 && (p.principalId = l[1].principalId), t.$set(p);
      },
      i(l) {
        r || (de(t.$$.fragment, l), (r = !0));
      },
      o(l) {
        Ve(t.$$.fragment, l), (r = !1);
      },
      d(l) {
        wt(t, l);
      },
    }
  );
}
function el(s) {
  let t, r, l, _;
  const p = [Zs, Qs],
    w = [];
  function P(E, L) {
    return E[6] ? 0 : 1;
  }
  return (
    (t = P(s)),
    (r = w[t] = p[t](s)),
    {
      c() {
        r.c(), (l = ws());
      },
      l(E) {
        r.l(E), (l = ws());
      },
      m(E, L) {
        w[t].m(E, L), Tt(E, l, L), (_ = !0);
      },
      p(E, L) {
        let S = t;
        (t = P(E)),
          t === S
            ? w[t].p(E, L)
            : (Gt(),
              Ve(w[S], 1, 1, () => {
                w[S] = null;
              }),
              At(),
              (r = w[t]),
              r ? r.p(E, L) : ((r = w[t] = p[t](E)), r.c()),
              de(r, 1),
              r.m(l.parentNode, l));
      },
      i(E) {
        _ || (de(r), (_ = !0));
      },
      o(E) {
        Ve(r), (_ = !1);
      },
      d(E) {
        w[t].d(E), E && n(l);
      },
    }
  );
}
function tl(s) {
  let t, r;
  return (
    (t = new Rs({
      props: { $$slots: { default: [el] }, $$scope: { ctx: s } },
    })),
    {
      c() {
        gt(t.$$.fragment);
      },
      l(l) {
        Et(t.$$.fragment, l);
      },
      m(l, _) {
        bt(t, l, _), (r = !0);
      },
      p(l, [_]) {
        const p = {};
        _ & 1048831 && (p.$$scope = { dirty: _, ctx: l }), t.$set(p);
      },
      i(l) {
        r || (de(t.$$.fragment, l), (r = !0));
      },
      o(l) {
        Ve(t.$$.fragment, l), (r = !1);
      },
      d(l) {
        wt(t, l);
      },
    }
  );
}
let Ns = "";
function sl(s, t, r) {
  let l, _, p, w;
  js(s, Js, (D) => r(12, (w = D)));
  let P = "details",
    E,
    L = zt(null),
    S,
    ee,
    j,
    G,
    q = "",
    A = null,
    N = "",
    M,
    k = !0;
  Hs(async () => {
    try {
      await Wt.sync(),
        await Xt.sync(),
        (ee = Wt.subscribe((R) => {
          S = R;
        })),
        (j = Xt.subscribe((R) => {
          E = R;
        })),
        r(
          1,
          (G = await Ks.getManager(
            l ?? "",
            S?.activeSeason.id ?? 1,
            _ && _ > 0 ? _ : S?.activeGameweek ?? 1
          ))
        ),
        r(2, (q = G.displayName));
      const D = new Blob([new Uint8Array(G.profilePicture)]),
        O =
          G.profilePicture.length > 0
            ? URL.createObjectURL(D)
            : "profile_placeholder.png";
      r(5, (M = O));
      const ne = Number(G.createDate / 1000000n),
        I = new Date(ne);
      r(
        4,
        (N = `${
          [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
          ][I.getUTCMonth()]
        } ${I.getUTCFullYear()}`)
      ),
        r(
          3,
          (A =
            G.favouriteTeamId > 0
              ? E.find((R) => R.id == G.favouriteTeamId) ?? null
              : null)
        );
    } catch (D) {
      ts.show("Error fetching manager details.", "error"),
        console.error("Error fetching manager details:", D);
    } finally {
      r(6, (k = !1));
    }
  }),
    Ms(() => {
      j?.(), ee?.();
    });
  function J(D) {
    r(0, (P = D));
  }
  function X(D, O) {
    let ne = G.gameweeks.find((I) => I.gameweek === O);
    L.set(ne), J("details");
  }
  const Q = () => J("details"),
    ve = () => J("gameweeks");
  return (
    (s.$$.update = () => {
      s.$$.dirty & 4096 && (l = w.url.searchParams.get("id")),
        s.$$.dirty & 4096 &&
          r(11, (_ = Number(w.url.searchParams.get("gw")) ?? 0)),
        s.$$.dirty & 2048 && r(7, (p = _));
    }),
    [P, G, q, A, N, M, k, p, L, J, X, _, w, Q, ve]
  );
}
class dl extends Gs {
  constructor(t) {
    super(), As(this, t, sl, tl, Fs, {});
  }
}
export { dl as component };