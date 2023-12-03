import {
  b as $s,
  k as a,
  f as B1,
  n as c,
  G as e,
  L as ei,
  A as eo,
  d as Hs,
  c as i,
  N as j1,
  H as Jt,
  r as l,
  v as M1,
  l as n,
  a as o,
  s as Ql,
  q as r,
  m as s,
  g as Ss,
  h as t,
  B as to,
  i as Xl,
  y as Yl,
  S as zl,
  z as Zl,
} from "../chunks/index.a8c54947.js";
import { e as W1 } from "../chunks/Layout.0e76e124.js";
function U1(x) {
  let h,
    d,
    u,
    w,
    N,
    b,
    le,
    Z,
    L,
    Le,
    ke,
    y,
    J,
    oe,
    k,
    ie,
    xe,
    A,
    K,
    de,
    C,
    ee,
    Ae,
    $,
    V,
    Q,
    S,
    P,
    te,
    G,
    ce,
    ae,
    T,
    ye,
    De,
    R,
    Y,
    Pe,
    he,
    _e,
    Ue,
    ue,
    j,
    fe,
    pe,
    Ce,
    Fe,
    me,
    ve,
    p,
    D,
    Ee,
    Ne,
    ge,
    H,
    W,
    F,
    He,
    z,
    ne,
    we,
    Je,
    v,
    O,
    Oe,
    X,
    I,
    Re,
    se,
    Ke,
    Me,
    re,
    ze,
    Ie,
    be,
    f,
    $e,
    q,
    Qe,
    Se,
    Be;
  return {
    c() {
      (h = a("div")),
        (d = a("div")),
        (u = a("h1")),
        (w = r("System Architecture")),
        (N = o()),
        (b = a("p")),
        (le =
          r(`OpenFPL is being built as a progressive web application, it's curernt
      frontend is React but will be moved over to Svelte for the start of 2024.
      The OpenFPL backend is developed in Motoko. The Github is publicly
      available at github.com/jamesbeadle/openfpl. OpenFPL's architecture is
      designed for scalability and efficiency, ensuring robust performance even
      as user numbers grow. Here's how the system is structured:`)),
        (Z = o()),
        (L = a("h2")),
        (Le = r("Profile Data")),
        (ke = o()),
        (y = a("p")),
        (J =
          r(`OpenFPL allocates approximately 254 bytes for a profile record. This means
      that a single Profile Canister could hold more than 16m profiles, scaling
      to a size larger than the market leader.`)),
        (oe = o()),
        (k = a("p")),
        (ie =
          r(`Each profile record will hold a reference to the Profile Picture canister
      where their pfp is stored. We limit the size of profile pictures to 500KB,
      meaning you can store 8,000 images per Profile Picture canister. When the
      canister is full, a new Profile Picture canister is created to store the
      images.`)),
        (xe = o()),
        (A = a("h2")),
        (K = r("Fantasy Teams Data")),
        (de = o()),
        (C = a("p")),
        (ee =
          r(`OpenFPL allocates approximately 913 KB for a fantasy team with a lifetime
      of seasons history. Therefore we can store over 4,000 fantasy teams in
      each canister. When this limit is reached, a new canister is created. A
      reference to the user’s Fantasy Team canister is stored in the user
      profile record.`)),
        (Ae = o()),
        ($ = a("h2")),
        (V = r("Leaderboard Data")),
        (Q = o()),
        (S = a("p")),
        (P =
          r(`The size of the leaderboard data is very much dependent on the number of
      users on the site as each will create an entry in each leaderboard.
      Therefore we will create a new canister for each leaderboard. For each
      season there will be a Season Leaderboard canister, 38 Gameweek
      Leaderboard canisters and 12 Monthly Leaderboard canisters. This
      architecture will scale to 25m+ users, more than double the players of the
      market leading platform.`)),
        (te = o()),
        (G = a("h2")),
        (ce = r("Main Canister & Central Data Management")),
        (ae = o()),
        (T = a("p")),
        (ye =
          r(`Our system estimates the size of the main canister containing data for 100
      seasons as around 44MB. With around 1% of the 4GB canister being used,
      substantial room is available for additional growth and functionalities.
      The Main canister will contain the following key pieces of information:`)),
        (De = o()),
        (R = a("ul")),
        (Y = a("li")),
        (Pe = r("Data Cache Hashes")),
        (he = o()),
        (_e = a("li")),
        (Ue = r("Teams Data")),
        (ue = o()),
        (j = a("li")),
        (fe = r("Seasons Data")),
        (pe = o()),
        (Ce = a("li")),
        (Fe = r("Canister References")),
        (me = o()),
        (ve = a("h2")),
        (p = r("Player Canisters")),
        (D = o()),
        (Ee = a("p")),
        (Ne =
          r(`The player canisters container information on all Premier League football
      players. OpenFPL allocates approximately 30 KB for each Player record.
      With a single canister on the Internet Computer boasting a 4GB capacity,
      it will be able to store 100.000+ Premier League player entries. Each
      Premier League team could theoretically introduce up to 50 new players per
      team annually. However, this number implies a complete change of a team's
      squad, an eventuality that's exceedingly uncommon in the Premier League.
      Therefore, our projection of 1,000 new players across the league each year
      offers a deliberately conservative overestimation. Given these
      calculations, the following 3 canisters will be able to manage all the
      Premier League players for well over 100 years:`)),
        (ge = o()),
        (H = a("ul")),
        (W = a("li")),
        (F = r("Live Players Canister")),
        (He = o()),
        (z = a("li")),
        (ne = r("Former Players Canister")),
        (we = o()),
        (Je = a("li")),
        (v = r("Retired Players Canister")),
        (O = o()),
        (Oe = a("p")),
        (X =
          r(`Players will move from the live canister to and from the Former or Retired
      players canister when required.`)),
        (I = o()),
        (Re = a("h2")),
        (se = r("Cycle Dispenser")),
        (Ke = o()),
        (Me = a("p")),
        (re =
          r(`The cycle dispenser canister watches each canister in the OpenFPL
      ecosystem and tops it up with cycles when it reaches 20% of its top up
      value.`)),
        (ze = o()),
        (Ie = a("h2")),
        (be = r("Note on Architecture Evolution and Whitepaper Updates")),
        (f = o()),
        ($e = a("p")),
        (q =
          r(`As OpenFPL progresses through the SNS testflight phase, our architecture
      may undergo changes to optimize performance and scalability. We are
      committed to staying at the forefront of technological advancements,
      ensuring that our platform remains robust and efficient.`)),
        (Qe = o()),
        (Se = a("p")),
        (Be =
          r(`To keep our community and stakeholders informed, any significant changes
      to the architecture will be reflected in updated versions of this
      whitepaper. Each new version will be clearly marked to ensure transparency
      and ease of reference, maintaining our commitment to openness and
      communication with our users.`)),
        this.h();
    },
    l(qe) {
      h = n(qe, "DIV", { class: !0 });
      var je = s(h);
      d = n(je, "DIV", { class: !0 });
      var E = s(d);
      u = n(E, "H1", { class: !0 });
      var ut = s(u);
      (w = l(ut, "System Architecture")),
        ut.forEach(t),
        (N = i(E)),
        (b = n(E, "P", { class: !0 }));
      var at = s(b);
      (le = l(
        at,
        `OpenFPL is being built as a progressive web application, it's curernt
      frontend is React but will be moved over to Svelte for the start of 2024.
      The OpenFPL backend is developed in Motoko. The Github is publicly
      available at github.com/jamesbeadle/openfpl. OpenFPL's architecture is
      designed for scalability and efficiency, ensuring robust performance even
      as user numbers grow. Here's how the system is structured:`
      )),
        at.forEach(t),
        (Z = i(E)),
        (L = n(E, "H2", { class: !0 }));
      var Ye = s(L);
      (Le = l(Ye, "Profile Data")),
        Ye.forEach(t),
        (ke = i(E)),
        (y = n(E, "P", { class: !0 }));
      var ft = s(y);
      (J = l(
        ft,
        `OpenFPL allocates approximately 254 bytes for a profile record. This means
      that a single Profile Canister could hold more than 16m profiles, scaling
      to a size larger than the market leader.`
      )),
        ft.forEach(t),
        (oe = i(E)),
        (k = n(E, "P", { class: !0 }));
      var B = s(k);
      (ie = l(
        B,
        `Each profile record will hold a reference to the Profile Picture canister
      where their pfp is stored. We limit the size of profile pictures to 500KB,
      meaning you can store 8,000 images per Profile Picture canister. When the
      canister is full, a new Profile Picture canister is created to store the
      images.`
      )),
        B.forEach(t),
        (xe = i(E)),
        (A = n(E, "H2", { class: !0 }));
      var Ze = s(A);
      (K = l(Ze, "Fantasy Teams Data")),
        Ze.forEach(t),
        (de = i(E)),
        (C = n(E, "P", { class: !0 }));
      var g = s(C);
      (ee = l(
        g,
        `OpenFPL allocates approximately 913 KB for a fantasy team with a lifetime
      of seasons history. Therefore we can store over 4,000 fantasy teams in
      each canister. When this limit is reached, a new canister is created. A
      reference to the user’s Fantasy Team canister is stored in the user
      profile record.`
      )),
        g.forEach(t),
        (Ae = i(E)),
        ($ = n(E, "H2", { class: !0 }));
      var lt = s($);
      (V = l(lt, "Leaderboard Data")),
        lt.forEach(t),
        (Q = i(E)),
        (S = n(E, "P", { class: !0 }));
      var pt = s(S);
      (P = l(
        pt,
        `The size of the leaderboard data is very much dependent on the number of
      users on the site as each will create an entry in each leaderboard.
      Therefore we will create a new canister for each leaderboard. For each
      season there will be a Season Leaderboard canister, 38 Gameweek
      Leaderboard canisters and 12 Monthly Leaderboard canisters. This
      architecture will scale to 25m+ users, more than double the players of the
      market leading platform.`
      )),
        pt.forEach(t),
        (te = i(E)),
        (G = n(E, "H2", { class: !0 }));
      var m = s(G);
      (ce = l(m, "Main Canister & Central Data Management")),
        m.forEach(t),
        (ae = i(E)),
        (T = n(E, "P", { class: !0 }));
      var Lt = s(T);
      (ye = l(
        Lt,
        `Our system estimates the size of the main canister containing data for 100
      seasons as around 44MB. With around 1% of the 4GB canister being used,
      substantial room is available for additional growth and functionalities.
      The Main canister will contain the following key pieces of information:`
      )),
        Lt.forEach(t),
        (De = i(E)),
        (R = n(E, "UL", { class: !0 }));
      var et = s(R);
      Y = n(et, "LI", {});
      var Ge = s(Y);
      (Pe = l(Ge, "Data Cache Hashes")),
        Ge.forEach(t),
        (he = i(et)),
        (_e = n(et, "LI", {}));
      var mt = s(_e);
      (Ue = l(mt, "Teams Data")),
        mt.forEach(t),
        (ue = i(et)),
        (j = n(et, "LI", {}));
      var kt = s(j);
      (fe = l(kt, "Seasons Data")),
        kt.forEach(t),
        (pe = i(et)),
        (Ce = n(et, "LI", {}));
      var Dt = s(Ce);
      (Fe = l(Dt, "Canister References")),
        Dt.forEach(t),
        et.forEach(t),
        (me = i(E)),
        (ve = n(E, "H2", { class: !0 }));
      var Te = s(ve);
      (p = l(Te, "Player Canisters")),
        Te.forEach(t),
        (D = i(E)),
        (Ee = n(E, "P", { class: !0 }));
      var It = s(Ee);
      (Ne = l(
        It,
        `The player canisters container information on all Premier League football
      players. OpenFPL allocates approximately 30 KB for each Player record.
      With a single canister on the Internet Computer boasting a 4GB capacity,
      it will be able to store 100.000+ Premier League player entries. Each
      Premier League team could theoretically introduce up to 50 new players per
      team annually. However, this number implies a complete change of a team's
      squad, an eventuality that's exceedingly uncommon in the Premier League.
      Therefore, our projection of 1,000 new players across the league each year
      offers a deliberately conservative overestimation. Given these
      calculations, the following 3 canisters will be able to manage all the
      Premier League players for well over 100 years:`
      )),
        It.forEach(t),
        (ge = i(E)),
        (H = n(E, "UL", { class: !0 }));
      var xt = s(H);
      W = n(xt, "LI", {});
      var Zt = s(W);
      (F = l(Zt, "Live Players Canister")),
        Zt.forEach(t),
        (He = i(xt)),
        (z = n(xt, "LI", {}));
      var At = s(z);
      (ne = l(At, "Former Players Canister")),
        At.forEach(t),
        (we = i(xt)),
        (Je = n(xt, "LI", {}));
      var ia = s(Je);
      (v = l(ia, "Retired Players Canister")),
        ia.forEach(t),
        xt.forEach(t),
        (O = i(E)),
        (Oe = n(E, "P", { class: !0 }));
      var ea = s(Oe);
      (X = l(
        ea,
        `Players will move from the live canister to and from the Former or Retired
      players canister when required.`
      )),
        ea.forEach(t),
        (I = i(E)),
        (Re = n(E, "H2", { class: !0 }));
      var Ct = s(Re);
      (se = l(Ct, "Cycle Dispenser")),
        Ct.forEach(t),
        (Ke = i(E)),
        (Me = n(E, "P", { class: !0 }));
      var da = s(Me);
      (re = l(
        da,
        `The cycle dispenser canister watches each canister in the OpenFPL
      ecosystem and tops it up with cycles when it reaches 20% of its top up
      value.`
      )),
        da.forEach(t),
        (ze = i(E)),
        (Ie = n(E, "H2", { class: !0 }));
      var ta = s(Ie);
      (be = l(ta, "Note on Architecture Evolution and Whitepaper Updates")),
        ta.forEach(t),
        (f = i(E)),
        ($e = n(E, "P", { class: !0 }));
      var $t = s($e);
      (q = l(
        $t,
        `As OpenFPL progresses through the SNS testflight phase, our architecture
      may undergo changes to optimize performance and scalability. We are
      committed to staying at the forefront of technological advancements,
      ensuring that our platform remains robust and efficient.`
      )),
        $t.forEach(t),
        (Qe = i(E)),
        (Se = n(E, "P", { class: !0 }));
      var ca = s(Se);
      (Be = l(
        ca,
        `To keep our community and stakeholders informed, any significant changes
      to the architecture will be reflected in updated versions of this
      whitepaper. Each new version will be clearly marked to ensure transparency
      and ease of reference, maintaining our commitment to openness and
      communication with our users.`
      )),
        ca.forEach(t),
        E.forEach(t),
        je.forEach(t),
        this.h();
    },
    h() {
      c(u, "class", "text-3xl font-bold my-4"),
        c(b, "class", "my-2"),
        c(L, "class", "text-lg font-bold mt-4"),
        c(y, "class", "my-2"),
        c(k, "class", "my-2"),
        c(A, "class", "text-lg font-bold mt-4"),
        c(C, "class", "my-2"),
        c($, "class", "text-lg font-bold mt-4"),
        c(S, "class", "my-2"),
        c(G, "class", "text-lg font-bold mt-4"),
        c(T, "class", "my-2"),
        c(R, "class", "list-disc ml-4"),
        c(ve, "class", "text-lg font-bold mt-4"),
        c(Ee, "class", "my-2"),
        c(H, "class", "list-disc ml-4"),
        c(Oe, "class", "my-2"),
        c(Re, "class", "text-lg font-bold mt-4"),
        c(Me, "class", "my-2"),
        c(Ie, "class", "text-lg font-bold mt-4"),
        c($e, "class", "my-2"),
        c(Se, "class", "my-2"),
        c(d, "class", "m-4"),
        c(h, "class", "container-fluid mx-auto p-4");
    },
    m(qe, je) {
      $s(qe, h, je),
        e(h, d),
        e(d, u),
        e(u, w),
        e(d, N),
        e(d, b),
        e(b, le),
        e(d, Z),
        e(d, L),
        e(L, Le),
        e(d, ke),
        e(d, y),
        e(y, J),
        e(d, oe),
        e(d, k),
        e(k, ie),
        e(d, xe),
        e(d, A),
        e(A, K),
        e(d, de),
        e(d, C),
        e(C, ee),
        e(d, Ae),
        e(d, $),
        e($, V),
        e(d, Q),
        e(d, S),
        e(S, P),
        e(d, te),
        e(d, G),
        e(G, ce),
        e(d, ae),
        e(d, T),
        e(T, ye),
        e(d, De),
        e(d, R),
        e(R, Y),
        e(Y, Pe),
        e(R, he),
        e(R, _e),
        e(_e, Ue),
        e(R, ue),
        e(R, j),
        e(j, fe),
        e(R, pe),
        e(R, Ce),
        e(Ce, Fe),
        e(d, me),
        e(d, ve),
        e(ve, p),
        e(d, D),
        e(d, Ee),
        e(Ee, Ne),
        e(d, ge),
        e(d, H),
        e(H, W),
        e(W, F),
        e(H, He),
        e(H, z),
        e(z, ne),
        e(H, we),
        e(H, Je),
        e(Je, v),
        e(d, O),
        e(d, Oe),
        e(Oe, X),
        e(d, I),
        e(d, Re),
        e(Re, se),
        e(d, Ke),
        e(d, Me),
        e(Me, re),
        e(d, ze),
        e(d, Ie),
        e(Ie, be),
        e(d, f),
        e(d, $e),
        e($e, q),
        e(d, Qe),
        e(d, Se),
        e(Se, Be);
    },
    p: Jt,
    i: Jt,
    o: Jt,
    d(qe) {
      qe && t(h);
    },
  };
}
class N1 extends zl {
  constructor(h) {
    super(), Xl(this, h, null, U1, Ql, {});
  }
}
function G1(x) {
  let h,
    d,
    u,
    w,
    N,
    b,
    le,
    Z,
    L,
    Le,
    ke,
    y,
    J,
    oe,
    k,
    ie,
    xe,
    A,
    K,
    de,
    C,
    ee,
    Ae,
    $,
    V,
    Q,
    S,
    P,
    te,
    G,
    ce,
    ae,
    T,
    ye,
    De,
    R,
    Y,
    Pe,
    he,
    _e,
    Ue,
    ue,
    j,
    fe,
    pe,
    Ce,
    Fe,
    me,
    ve,
    p,
    D,
    Ee,
    Ne,
    ge,
    H,
    W,
    F,
    He,
    z,
    ne,
    we,
    Je,
    v,
    O,
    Oe,
    X,
    I,
    Re,
    se,
    Ke,
    Me,
    re,
    ze,
    Ie,
    be,
    f,
    $e,
    q,
    Qe,
    Se,
    Be,
    qe,
    je,
    E,
    ut,
    at,
    Ye,
    ft,
    B,
    Ze,
    g,
    lt,
    pt,
    m,
    Lt,
    et,
    Ge,
    mt,
    kt,
    Dt,
    Te,
    It,
    xt,
    Zt,
    At,
    ia,
    ea,
    Ct,
    da,
    ta,
    $t,
    ca,
    ha,
    ra,
    ya,
    ua,
    la,
    _a,
    gt,
    St,
    Xa,
    Qa,
    oa,
    Ya,
    as,
    Ve,
    on,
    dn,
    Za,
    U,
    Rs,
    cn,
    mn,
    Ms,
    We,
    tt,
    hn,
    Bs,
    vn,
    gn,
    ot,
    bn,
    yn,
    js,
    _n,
    En,
    Ws,
    wn,
    Tn,
    Us,
    vt,
    en,
    va,
    Ns,
    tn,
    Gs,
    qs,
    an,
    Vs,
    Js,
    Xe,
    Ks,
    zs,
    za,
    un,
    ns,
    Pn,
    rt,
    fn,
    Ln,
    Xs,
    kn,
    Dn,
    Qs,
    mr,
    Ht,
    vr,
    gr,
    ti,
    br,
    yr,
    ai,
    _r,
    Er,
    ni,
    wr,
    Tr,
    si,
    Pr,
    Lr,
    ri,
    kr,
    Dr,
    li,
    Fr,
    Ys,
    Zs,
    er,
    oi,
    tr,
    it,
    Or,
    ii,
    bt,
    Fn,
    di,
    ci,
    ss,
    hi,
    ui,
    rs,
    fi,
    pi,
    ls,
    mi,
    vi,
    os,
    gi,
    bi,
    is,
    yi,
    _i,
    ds,
    Ei,
    wi,
    yt,
    Ir,
    Ti,
    xr,
    Ar,
    Pi,
    _t,
    On,
    Li,
    ki,
    cs,
    Di,
    Fi,
    hs,
    Oi,
    Ii,
    us,
    xi,
    Ai,
    fs,
    Ci,
    $i,
    ps,
    Si,
    Hi,
    Et,
    Cr,
    Ri,
    $r,
    Sr,
    Mi,
    Hr,
    Rr,
    Bi,
    wt,
    In,
    ji,
    Wi,
    ms,
    Ui,
    Ni,
    vs,
    Gi,
    qi,
    gs,
    Vi,
    Ji,
    bs,
    Ki,
    zi,
    Tt,
    Mr,
    Xi,
    Br,
    jr,
    Qi,
    Wr,
    Ur,
    Yi,
    Nr,
    Gr,
    Zi,
    ar,
    pn,
    ao,
    ed,
    dt,
    nr,
    td,
    qr,
    Vr,
    ad,
    Jr,
    Kr,
    nd,
    Rt,
    ys,
    sd,
    rd,
    _s,
    ld,
    od,
    Es,
    id,
    dd,
    ws,
    cd,
    hd,
    Ts,
    ud,
    fd,
    Ps,
    pd,
    md,
    xn,
    Ls,
    no,
    zr,
    An,
    ks,
    Mt,
    Xr,
    Qr,
    vd,
    Yr,
    sr,
    gd,
    Zr,
    ct,
    Cn,
    Ds,
    bd,
    yd,
    Fs,
    _d,
    Ed,
    $n,
    rr,
    so,
    el,
    Sn,
    tl,
    al,
    wd,
    nl,
    Bt,
    sl,
    Hn,
    rl,
    ll,
    Td,
    ol,
    il,
    Pd,
    Rn,
    Os,
    Ld,
    kd,
    Is,
    Dd,
    Fd,
    nn,
    dl,
    Od,
    cl,
    hl,
    Id,
    ul,
    Mn,
    fl,
    jt,
    pl,
    ml,
    xd,
    vl,
    Bn,
    gl,
    bl,
    Ad,
    yl,
    _l,
    Cd,
    jn,
    xs,
    $d,
    Sd,
    As,
    Hd,
    Rd,
    sn,
    El,
    Md,
    wl,
    Tl,
    Bd,
    Wt,
    Wn,
    jd,
    Wd,
    Un,
    Ud,
    Nd,
    Nn,
    Gd,
    qd,
    ga,
    Pl,
    Vd,
    Ll,
    kl,
    Jd,
    Dl,
    Fl,
    Kd,
    Ol,
    Il,
    zd,
    xl,
    lr,
    Xd,
    Ut,
    Gn,
    Qd,
    Yd,
    qn,
    Zd,
    ec,
    Vn,
    tc,
    ac,
    Jn,
    nc,
    sc,
    Kn,
    rc,
    lc,
    ba,
    Al,
    oc,
    Cl,
    $l,
    ic,
    Sl,
    Hl,
    dc,
    Nt,
    Cs,
    cc,
    hc,
    zn,
    uc,
    fc,
    fa,
    Rl,
    pc,
    Ml,
    Bl,
    mc,
    jl,
    Wl,
    vc,
    Ul,
    Nl,
    gc,
    Gl,
    ql,
    bc,
    Vl,
    Xn,
    yc,
    ht,
    Jl,
    _c,
    Kl,
    or,
    _,
    Ec,
    ro,
    wc,
    pa,
    lo,
    Tc,
    Pc,
    oo,
    Lc,
    kc,
    io,
    Dc,
    Fc,
    co,
    Qn,
    Oc,
    ho,
    Ic,
    xc,
    Kt,
    Ea,
    Ac,
    Cc,
    uo,
    $c,
    Sc,
    fo,
    rn,
    Hc,
    po,
    Rc,
    Mc,
    mo,
    Bc,
    ln,
    vo,
    jc,
    Wc,
    go,
    Uc,
    Nc,
    bo,
    Yn,
    Gc,
    zt,
    yo,
    qc,
    Vc,
    nt,
    aa,
    Jc,
    _o,
    Kc,
    zc,
    Eo,
    Xc,
    Qc,
    wo,
    Yc,
    Zc,
    To,
    na,
    eh,
    Po,
    th,
    ah,
    Lo,
    nh,
    sh,
    Xt,
    ko,
    rh,
    lh,
    Do,
    oh,
    sa,
    Fo,
    ih,
    dh,
    Oo,
    ch,
    hh,
    Io,
    uh,
    fh,
    Gt,
    ph,
    mh,
    xo,
    vh,
    gh,
    Ao,
    bh,
    yh,
    Qt,
    qt,
    _h,
    Eh,
    Co,
    wh,
    Th,
    $o,
    Ph,
    Lh,
    So,
    kh,
    Dh,
    Vt,
    Fh,
    Oh,
    Ho,
    Ih,
    xh,
    Ro,
    Ah,
    Ch,
    Mo,
    $h,
    Sh,
    Ft,
    Bo,
    Hh,
    Rh,
    Pt,
    jo,
    Mh,
    Wo,
    Bh,
    jh,
    ir,
    Wh,
    Uh,
    dr,
    Nh,
    Gh,
    cr,
    qh,
    Vh,
    hr,
    Jh,
    Kh,
    ur,
    zh,
    Xh,
    Ot,
    Uo,
    Qh,
    No,
    Go,
    Yh,
    qo,
    Vo,
    Zh,
    eu,
    Jo,
    tu,
    Zn,
    Ko,
    au,
    nu,
    zo,
    su,
    ru,
    Xo,
    lu,
    ou,
    Qo,
    es,
    iu,
    Yt,
    Yo,
    du,
    cu,
    wa,
    hu,
    uu,
    Zo,
    fu,
    pu,
    fr,
    mu,
    Bu,
    Eu,
    ju,
    Wu,
    wu,
    Uu,
    Nu,
    Tu,
    Gu,
    qu,
    Pu,
    Vu,
    Ju,
    ma,
    Lu,
    Ku,
    zu,
    ku,
    Xu,
    Qu,
    Du,
    Yu,
    Zu,
    Fu,
    ef,
    tf,
    Ou,
    af,
    nf,
    Iu,
    sf,
    rf,
    xu,
    lf,
    of,
    Au,
    df,
    cf,
    vu,
    hf,
    uf,
    pr,
    Cu,
    ff,
    pf,
    $u,
    mf,
    vf,
    Su,
    gf,
    bf,
    gu,
    yf,
    _f,
    bu,
    Ef,
    wf,
    yu,
    Tf;
  return {
    c() {
      (h = a("div")),
        (d = a("div")),
        (u = a("h1")),
        (w = r("OpenFPL DAO")),
        (N = o()),
        (b = a("p")),
        (le =
          r(`OpenFPL functions entirely on-chain as a DAO, aspiring to operate under
      the Internet Computer’s Service Nervous System. The DAO is structured to
      run in parallel with the Premier League season, relying on input from its
      neuron holders who are rewarded for maintaining independence from
      third-party services.`)),
        (Z = o()),
        (L = a("h2")),
        (Le = r("DAO Reward Structure")),
        (ke = o()),
        (y = a("p")),
        (J =
          r(`The DAO incentivizes participation through monthly minting of new FPL
      tokens, calculated annually as 2.5% of the total $FPL supply as of August
      1st. These tokens are allocated to:`)),
        (oe = o()),
        (k = a("ul")),
        (ie = a("li")),
        (xe = r("Gameplay Rewards (75%)")),
        (A = o()),
        (K = a("li")),
        (de = r("Governance Rewards (25%)")),
        (C = o()),
        (ee = a("h2")),
        (Ae = r("Gameplay Rewards (75%)")),
        ($ = o()),
        (V = a("p")),
        (Q =
          r(`The DAO is designed to reward users for their expertise in fantasy
      football, with rewards distributed weekly, monthly, and annually based on
      performance. The rewards are tiered to encourage ongoing engagement.
      Here’s the breakdown:`)),
        (S = o()),
        (P = a("ul")),
        (te = a("li")),
        (G =
          r(`Global Season Leaderboard Rewards: 30% for the top 100 global season
        positions.`)),
        (ce = o()),
        (ae = a("li")),
        (T =
          r(`Club Monthly Leaderboard Rewards: 20% for the top 100 in each monthly
        club leaderboard, adjusted for the number of fans in each club.`)),
        (ye = o()),
        (De = a("li")),
        (R = r(
          "Global Weekly Leaderboard Rewards: 15% for the top 100 weekly positions."
        )),
        (Y = o()),
        (Pe = a("li")),
        (he =
          r(`Most Valuable Team Rewards: 10% for the top 100 most valuable teams at
        season's end.`)),
        (_e = o()),
        (Ue = a("li")),
        (ue =
          r(`Highest Scoring Match Player Rewards: 10% split among managers selecting
        the highest-scoring player in a fixture.`)),
        (j = o()),
        (fe = a("li")),
        (pe =
          r(`Weekly/Monthly/Season ATH Score Rewards: 5% each, reserved for breaking
        all-time high scores in respective categories.`)),
        (Ce = o()),
        (Fe = a("p")),
        (me =
          r(`A user is rewarded for their leaderboard position across the top 100
      positions. The following is a breakdown of the reward share for each
      position:`)),
        (ve = o()),
        (p = a("table")),
        (D = a("tr")),
        (Ee = a("th")),
        (Ne = r("Pos")),
        (ge = o()),
        (H = a("th")),
        (W = r("Share")),
        (F = o()),
        (He = a("th")),
        (z = r("Pos")),
        (ne = o()),
        (we = a("th")),
        (Je = r("Share")),
        (v = o()),
        (O = a("th")),
        (Oe = r("Pos")),
        (X = o()),
        (I = a("th")),
        (Re = r("Share")),
        (se = o()),
        (Ke = a("th")),
        (Me = r("Pos")),
        (re = o()),
        (ze = a("th")),
        (Ie = r("Share")),
        (be = o()),
        (f = a("tr")),
        ($e = a("td")),
        (q = r("1")),
        (Qe = o()),
        (Se = a("td")),
        (Be = r("36.09%")),
        (qe = o()),
        (je = a("td")),
        (E = r("26")),
        (ut = o()),
        (at = a("td")),
        (Ye = r("0.391%")),
        (ft = o()),
        (B = a("td")),
        (Ze = r("51")),
        (g = o()),
        (lt = a("td")),
        (pt = r("0.0662%")),
        (m = o()),
        (Lt = a("td")),
        (et = r("76")),
        (Ge = o()),
        (mt = a("td")),
        (kt = r("0.012%")),
        (Dt = o()),
        (Te = a("tr")),
        (It = a("td")),
        (xt = r("2")),
        (Zt = o()),
        (At = a("td")),
        (ia = r("18.91%")),
        (ea = o()),
        (Ct = a("td")),
        (da = r("27")),
        (ta = o()),
        ($t = a("td")),
        (ca = r("0.365%")),
        (ha = o()),
        (ra = a("td")),
        (ya = r("52")),
        (ua = o()),
        (la = a("td")),
        (_a = r("0.0627%")),
        (gt = o()),
        (St = a("td")),
        (Xa = r("77")),
        (Qa = o()),
        (oa = a("td")),
        (Ya = r("0.0112%")),
        (as = o()),
        (Ve = a("tr")),
        (on = a("td")),
        (dn = r("3")),
        (Za = o()),
        (U = a("td")),
        (Rs = r("10.32%")),
        (cn = o()),
        (mn = a("td")),
        (Ms = r("28")),
        (We = o()),
        (tt = a("td")),
        (hn = r("0.339%")),
        (Bs = o()),
        (vn = a("td")),
        (gn = r("53")),
        (ot = o()),
        (bn = a("td")),
        (yn = r("0.0593%")),
        (js = o()),
        (_n = a("td")),
        (En = r("78")),
        (Ws = o()),
        (wn = a("td")),
        (Tn = r("0.0103%")),
        (Us = o()),
        (vt = a("tr")),
        (en = a("td")),
        (va = r("4")),
        (Ns = o()),
        (tn = a("td")),
        (Gs = r("6.02%")),
        (qs = o()),
        (an = a("td")),
        (Vs = r("29")),
        (Js = o()),
        (Xe = a("td")),
        (Ks = r("0.314%")),
        (zs = o()),
        (za = a("td")),
        (un = r("54")),
        (ns = o()),
        (Pn = a("td")),
        (rt = r("0.0558%")),
        (fn = o()),
        (Ln = a("td")),
        (Xs = r("79")),
        (kn = o()),
        (Dn = a("td")),
        (Qs = r("0.0095%")),
        (mr = o()),
        (Ht = a("tr")),
        (vr = a("td")),
        (gr = r("5")),
        (ti = o()),
        (br = a("td")),
        (yr = r("3.87%")),
        (ai = o()),
        (_r = a("td")),
        (Er = r("30")),
        (ni = o()),
        (wr = a("td")),
        (Tr = r("0.288%")),
        (si = o()),
        (Pr = a("td")),
        (Lr = r("55")),
        (ri = o()),
        (kr = a("td")),
        (Dr = r("0.0524%")),
        (li = o()),
        (Fr = a("td")),
        (Ys = r("80")),
        (Zs = o()),
        (er = a("td")),
        (oi = r("0.0086%")),
        (tr = o()),
        (it = a("tr")),
        (Or = a("td")),
        (ii = r("6")),
        (bt = o()),
        (Fn = a("td")),
        (di = r("2.80%")),
        (ci = o()),
        (ss = a("td")),
        (hi = r("31")),
        (ui = o()),
        (rs = a("td")),
        (fi = r("0.262%")),
        (pi = o()),
        (ls = a("td")),
        (mi = r("56")),
        (vi = o()),
        (os = a("td")),
        (gi = r("0.0490%")),
        (bi = o()),
        (is = a("td")),
        (yi = r("81")),
        (_i = o()),
        (ds = a("td")),
        (Ei = r("0.0082%")),
        (wi = o()),
        (yt = a("tr")),
        (Ir = a("td")),
        (Ti = r("7")),
        (xr = o()),
        (Ar = a("td")),
        (Pi = r("2.26%")),
        (_t = o()),
        (On = a("td")),
        (Li = r("32")),
        (ki = o()),
        (cs = a("td")),
        (Di = r("0.248%")),
        (Fi = o()),
        (hs = a("td")),
        (Oi = r("57")),
        (Ii = o()),
        (us = a("td")),
        (xi = r("0.0455%")),
        (Ai = o()),
        (fs = a("td")),
        (Ci = r("82")),
        ($i = o()),
        (ps = a("td")),
        (Si = r("0.0077%")),
        (Hi = o()),
        (Et = a("tr")),
        (Cr = a("td")),
        (Ri = r("8")),
        ($r = o()),
        (Sr = a("td")),
        (Mi = r("1.83%")),
        (Hr = o()),
        (Rr = a("td")),
        (Bi = r("33")),
        (wt = o()),
        (In = a("td")),
        (ji = r("0.235%")),
        (Wi = o()),
        (ms = a("td")),
        (Ui = r("58")),
        (Ni = o()),
        (vs = a("td")),
        (Gi = r("0.0421%")),
        (qi = o()),
        (gs = a("td")),
        (Vi = r("83")),
        (Ji = o()),
        (bs = a("td")),
        (Ki = r("0.0073%")),
        (zi = o()),
        (Tt = a("tr")),
        (Mr = a("td")),
        (Xi = r("9")),
        (Br = o()),
        (jr = a("td")),
        (Qi = r("1.51%")),
        (Wr = o()),
        (Ur = a("td")),
        (Yi = r("34")),
        (Nr = o()),
        (Gr = a("td")),
        (Zi = r("0.221%")),
        (ar = o()),
        (pn = a("td")),
        (ao = r("59")),
        (ed = o()),
        (dt = a("td")),
        (nr = r("0.0387%")),
        (td = o()),
        (qr = a("td")),
        (Vr = r("84")),
        (ad = o()),
        (Jr = a("td")),
        (Kr = r("0.0069%")),
        (nd = o()),
        (Rt = a("tr")),
        (ys = a("td")),
        (sd = r("10")),
        (rd = o()),
        (_s = a("td")),
        (ld = r("1.30%")),
        (od = o()),
        (Es = a("td")),
        (id = r("35")),
        (dd = o()),
        (ws = a("td")),
        (cd = r("0.207%")),
        (hd = o()),
        (Ts = a("td")),
        (ud = r("60")),
        (fd = o()),
        (Ps = a("td")),
        (pd = r("0.0352%")),
        (md = o()),
        (xn = a("td")),
        (Ls = r("85")),
        (no = o()),
        (zr = a("td")),
        (An = r("0.0064%")),
        (ks = o()),
        (Mt = a("tr")),
        (Xr = a("td")),
        (Qr = r("11")),
        (vd = o()),
        (Yr = a("td")),
        (sr = r("1.19%")),
        (gd = o()),
        (Zr = a("td")),
        (ct = r("36")),
        (Cn = o()),
        (Ds = a("td")),
        (bd = r("0.193%")),
        (yd = o()),
        (Fs = a("td")),
        (_d = r("61")),
        (Ed = o()),
        ($n = a("td")),
        (rr = r("0.0335%")),
        (so = o()),
        (el = a("td")),
        (Sn = r("86")),
        (tl = o()),
        (al = a("td")),
        (wd = r("0.0060%")),
        (nl = o()),
        (Bt = a("tr")),
        (sl = a("td")),
        (Hn = r("12")),
        (rl = o()),
        (ll = a("td")),
        (Td = r("1.08%")),
        (ol = o()),
        (il = a("td")),
        (Pd = r("37")),
        (Rn = o()),
        (Os = a("td")),
        (Ld = r("0.180%")),
        (kd = o()),
        (Is = a("td")),
        (Dd = r("62")),
        (Fd = o()),
        (nn = a("td")),
        (dl = r("0.0318%")),
        (Od = o()),
        (cl = a("td")),
        (hl = r("87")),
        (Id = o()),
        (ul = a("td")),
        (Mn = r("0.0056%")),
        (fl = o()),
        (jt = a("tr")),
        (pl = a("td")),
        (ml = r("13")),
        (xd = o()),
        (vl = a("td")),
        (Bn = r("0.98%")),
        (gl = o()),
        (bl = a("td")),
        (Ad = r("38")),
        (yl = o()),
        (_l = a("td")),
        (Cd = r("0.166%")),
        (jn = o()),
        (xs = a("td")),
        ($d = r("63")),
        (Sd = o()),
        (As = a("td")),
        (Hd = r("0.0301%")),
        (Rd = o()),
        (sn = a("td")),
        (El = r("88")),
        (Md = o()),
        (wl = a("td")),
        (Tl = r("0.0052%")),
        (Bd = o()),
        (Wt = a("tr")),
        (Wn = a("td")),
        (jd = r("14")),
        (Wd = o()),
        (Un = a("td")),
        (Ud = r("0.87%")),
        (Nd = o()),
        (Nn = a("td")),
        (Gd = r("39")),
        (qd = o()),
        (ga = a("td")),
        (Pl = r("0.152%")),
        (Vd = o()),
        (Ll = a("td")),
        (kl = r("64")),
        (Jd = o()),
        (Dl = a("td")),
        (Fl = r("0.0284%")),
        (Kd = o()),
        (Ol = a("td")),
        (Il = r("89")),
        (zd = o()),
        (xl = a("td")),
        (lr = r("0.0047%")),
        (Xd = o()),
        (Ut = a("tr")),
        (Gn = a("td")),
        (Qd = r("15")),
        (Yd = o()),
        (qn = a("td")),
        (Zd = r("0.76%")),
        (ec = o()),
        (Vn = a("td")),
        (tc = r("40")),
        (ac = o()),
        (Jn = a("td")),
        (nc = r("0.138%")),
        (sc = o()),
        (Kn = a("td")),
        (rc = r("65")),
        (lc = o()),
        (ba = a("td")),
        (Al = r("0.0266%")),
        (oc = o()),
        (Cl = a("td")),
        ($l = r("90")),
        (ic = o()),
        (Sl = a("td")),
        (Hl = r("0.0043%")),
        (dc = o()),
        (Nt = a("tr")),
        (Cs = a("td")),
        (cc = r("16")),
        (hc = o()),
        (zn = a("td")),
        (uc = r("0.72%")),
        (fc = o()),
        (fa = a("td")),
        (Rl = r("41")),
        (pc = o()),
        (Ml = a("td")),
        (Bl = r("0.131%")),
        (mc = o()),
        (jl = a("td")),
        (Wl = r("66")),
        (vc = o()),
        (Ul = a("td")),
        (Nl = r("0.0249%")),
        (gc = o()),
        (Gl = a("td")),
        (ql = r("91")),
        (bc = o()),
        (Vl = a("td")),
        (Xn = r("0.0041%")),
        (yc = o()),
        (ht = a("tr")),
        (Jl = a("td")),
        (_c = r("17")),
        (Kl = o()),
        (or = a("td")),
        (_ = r("0.67%")),
        (Ec = o()),
        (ro = a("td")),
        (wc = r("42")),
        (pa = o()),
        (lo = a("td")),
        (Tc = r("0.125%")),
        (Pc = o()),
        (oo = a("td")),
        (Lc = r("67")),
        (kc = o()),
        (io = a("td")),
        (Dc = r("0.0232%")),
        (Fc = o()),
        (co = a("td")),
        (Qn = r("92")),
        (Oc = o()),
        (ho = a("td")),
        (Ic = r("0.0039%")),
        (xc = o()),
        (Kt = a("tr")),
        (Ea = a("td")),
        (Ac = r("18")),
        (Cc = o()),
        (uo = a("td")),
        ($c = r("0.63%")),
        (Sc = o()),
        (fo = a("td")),
        (rn = r("43")),
        (Hc = o()),
        (po = a("td")),
        (Rc = r("0.118%")),
        (Mc = o()),
        (mo = a("td")),
        (Bc = r("68")),
        (ln = o()),
        (vo = a("td")),
        (jc = r("0.0215%")),
        (Wc = o()),
        (go = a("td")),
        (Uc = r("93")),
        (Nc = o()),
        (bo = a("td")),
        (Yn = r("0.0037%")),
        (Gc = o()),
        (zt = a("tr")),
        (yo = a("td")),
        (qc = r("19")),
        (Vc = o()),
        (nt = a("td")),
        (aa = r("0.59%")),
        (Jc = o()),
        (_o = a("td")),
        (Kc = r("44")),
        (zc = o()),
        (Eo = a("td")),
        (Xc = r("0.111%")),
        (Qc = o()),
        (wo = a("td")),
        (Yc = r("69")),
        (Zc = o()),
        (To = a("td")),
        (na = r("0.0198%")),
        (eh = o()),
        (Po = a("td")),
        (th = r("94")),
        (ah = o()),
        (Lo = a("td")),
        (nh = r("0.0034%")),
        (sh = o()),
        (Xt = a("tr")),
        (ko = a("td")),
        (rh = r("20")),
        (lh = o()),
        (Do = a("td")),
        (oh = r("0.55%")),
        (sa = o()),
        (Fo = a("td")),
        (ih = r("45")),
        (dh = o()),
        (Oo = a("td")),
        (ch = r("0.104%")),
        (hh = o()),
        (Io = a("td")),
        (uh = r("70")),
        (fh = o()),
        (Gt = a("td")),
        (ph = r("0.0180%")),
        (mh = o()),
        (xo = a("td")),
        (vh = r("95")),
        (gh = o()),
        (Ao = a("td")),
        (bh = r("0.0032%")),
        (yh = o()),
        (Qt = a("tr")),
        (qt = a("td")),
        (_h = r("21")),
        (Eh = o()),
        (Co = a("td")),
        (wh = r("0.52%")),
        (Th = o()),
        ($o = a("td")),
        (Ph = r("46")),
        (Lh = o()),
        (So = a("td")),
        (kh = r("0.097%")),
        (Dh = o()),
        (Vt = a("td")),
        (Fh = r("71")),
        (Oh = o()),
        (Ho = a("td")),
        (Ih = r("0.0172%")),
        (xh = o()),
        (Ro = a("td")),
        (Ah = r("96")),
        (Ch = o()),
        (Mo = a("td")),
        ($h = r("0.0030%")),
        (Sh = o()),
        (Ft = a("tr")),
        (Bo = a("td")),
        (Hh = r("22")),
        (Rh = o()),
        (Pt = a("td")),
        (jo = r("0.49%")),
        (Mh = o()),
        (Wo = a("td")),
        (Bh = r("47")),
        (jh = o()),
        (ir = a("td")),
        (Wh = r("0.090%")),
        (Uh = o()),
        (dr = a("td")),
        (Nh = r("72")),
        (Gh = o()),
        (cr = a("td")),
        (qh = r("0.0155%")),
        (Vh = o()),
        (hr = a("td")),
        (Jh = r("97")),
        (Kh = o()),
        (ur = a("td")),
        (zh = r("0.0028%")),
        (Xh = o()),
        (Ot = a("tr")),
        (Uo = a("td")),
        (Qh = r("23")),
        (No = o()),
        (Go = a("td")),
        (Yh = r("0.47%")),
        (qo = o()),
        (Vo = a("td")),
        (Zh = r("48")),
        (eu = o()),
        (Jo = a("td")),
        (tu = r("0.083%")),
        (Zn = o()),
        (Ko = a("td")),
        (au = r("73")),
        (nu = o()),
        (zo = a("td")),
        (su = r("0.0146%")),
        (ru = o()),
        (Xo = a("td")),
        (lu = r("98")),
        (ou = o()),
        (Qo = a("td")),
        (es = r("0.0026%")),
        (iu = o()),
        (Yt = a("tr")),
        (Yo = a("td")),
        (du = r("24")),
        (cu = o()),
        (wa = a("td")),
        (hu = r("0.44%")),
        (uu = o()),
        (Zo = a("td")),
        (fu = r("49")),
        (pu = o()),
        (fr = a("td")),
        (mu = r("0.076%")),
        (Bu = o()),
        (Eu = a("td")),
        (ju = r("74")),
        (Wu = o()),
        (wu = a("td")),
        (Uu = r("0.0137%")),
        (Nu = o()),
        (Tu = a("td")),
        (Gu = r("99")),
        (qu = o()),
        (Pu = a("td")),
        (Vu = r("0.0024%")),
        (Ju = o()),
        (ma = a("tr")),
        (Lu = a("td")),
        (Ku = r("25")),
        (zu = o()),
        (ku = a("td")),
        (Xu = r("0.42%")),
        (Qu = o()),
        (Du = a("td")),
        (Yu = r("50")),
        (Zu = o()),
        (Fu = a("td")),
        (ef = r("0.070%")),
        (tf = o()),
        (Ou = a("td")),
        (af = r("75")),
        (nf = o()),
        (Iu = a("td")),
        (sf = r("0.0129%")),
        (rf = o()),
        (xu = a("td")),
        (lf = r("100")),
        (of = o()),
        (Au = a("td")),
        (df = r("0.0021%")),
        (cf = o()),
        (vu = a("p")),
        (hf =
          r(`To ensure rewards are paid for active participation, a user would need to
      do the following to qualify for the following OpenFPL gameplay rewards:`)),
        (uf = o()),
        (pr = a("ul")),
        (Cu = a("li")),
        (ff =
          r(`A user must have made at least 2 changes in a month to qualify for that
        month's club leaderboard rewards and monthly ATH record rewards.`)),
        (pf = o()),
        ($u = a("li")),
        (mf =
          r(`A user must have made at least 1 change in a gameweek to qualify for
        that week's leaderboard rewards, highest-scoring match player rewards
        and weekly ATH record rewards.`)),
        (vf = o()),
        (Su = a("li")),
        (gf =
          r(`Rewards for the season total, most valuable team have and annual ATH
        have no entry restrictions as it is based on the cumulative action of
        managers transfers throughout the season.`)),
        (bf = o()),
        (gu = a("h2")),
        (yf = r("Governance Rewards (25%)")),
        (_f = o()),
        (bu = a("p")),
        (Ef =
          r(`OpenFPL values neuron holders' contributions to maintaining up-to-date
      Premier League data. Rewards are given for raising and voting on essential
      proposals, such as scheduling, player transfers, and updating player
      information. Failed proposals incur a 10 $FPL cost, contributing to the
      DAO’s treasury.`)),
        (wf = o()),
        (yu = a("p")),
        (Tf =
          r(`The OpenFPL DAO is an innovative approach to fantasy football, combining
      real-time data accuracy with rewarding community involvement. By aligning
      rewards with active participation, OpenFPL ensures a vibrant, informed,
      and engaged user base.`)),
        this.h();
    },
    l(Hu) {
      h = n(Hu, "DIV", { class: !0 });
      var Ru = s(h);
      d = n(Ru, "DIV", { class: !0 });
      var st = s(d);
      u = n(st, "H1", { class: !0 });
      var Pf = s(u);
      (w = l(Pf, "OpenFPL DAO")),
        Pf.forEach(t),
        (N = i(st)),
        (b = n(st, "P", { class: !0 }));
      var Lf = s(b);
      (le = l(
        Lf,
        `OpenFPL functions entirely on-chain as a DAO, aspiring to operate under
      the Internet Computer’s Service Nervous System. The DAO is structured to
      run in parallel with the Premier League season, relying on input from its
      neuron holders who are rewarded for maintaining independence from
      third-party services.`
      )),
        Lf.forEach(t),
        (Z = i(st)),
        (L = n(st, "H2", { class: !0 }));
      var kf = s(L);
      (Le = l(kf, "DAO Reward Structure")),
        kf.forEach(t),
        (ke = i(st)),
        (y = n(st, "P", { class: !0 }));
      var Df = s(y);
      (J = l(
        Df,
        `The DAO incentivizes participation through monthly minting of new FPL
      tokens, calculated annually as 2.5% of the total $FPL supply as of August
      1st. These tokens are allocated to:`
      )),
        Df.forEach(t),
        (oe = i(st)),
        (k = n(st, "UL", { class: !0 }));
      var Mu = s(k);
      ie = n(Mu, "LI", {});
      var Ff = s(ie);
      (xe = l(Ff, "Gameplay Rewards (75%)")),
        Ff.forEach(t),
        (A = i(Mu)),
        (K = n(Mu, "LI", {}));
      var Of = s(K);
      (de = l(Of, "Governance Rewards (25%)")),
        Of.forEach(t),
        Mu.forEach(t),
        (C = i(st)),
        (ee = n(st, "H2", { class: !0 }));
      var If = s(ee);
      (Ae = l(If, "Gameplay Rewards (75%)")),
        If.forEach(t),
        ($ = i(st)),
        (V = n(st, "P", { class: !0 }));
      var xf = s(V);
      (Q = l(
        xf,
        `The DAO is designed to reward users for their expertise in fantasy
      football, with rewards distributed weekly, monthly, and annually based on
      performance. The rewards are tiered to encourage ongoing engagement.
      Here’s the breakdown:`
      )),
        xf.forEach(t),
        (S = i(st)),
        (P = n(st, "UL", { class: !0 }));
      var ts = s(P);
      te = n(ts, "LI", {});
      var Af = s(te);
      (G = l(
        Af,
        `Global Season Leaderboard Rewards: 30% for the top 100 global season
        positions.`
      )),
        Af.forEach(t),
        (ce = i(ts)),
        (ae = n(ts, "LI", {}));
      var Cf = s(ae);
      (T = l(
        Cf,
        `Club Monthly Leaderboard Rewards: 20% for the top 100 in each monthly
        club leaderboard, adjusted for the number of fans in each club.`
      )),
        Cf.forEach(t),
        (ye = i(ts)),
        (De = n(ts, "LI", {}));
      var $f = s(De);
      (R = l(
        $f,
        "Global Weekly Leaderboard Rewards: 15% for the top 100 weekly positions."
      )),
        $f.forEach(t),
        (Y = i(ts)),
        (Pe = n(ts, "LI", {}));
      var Sf = s(Pe);
      (he = l(
        Sf,
        `Most Valuable Team Rewards: 10% for the top 100 most valuable teams at
        season's end.`
      )),
        Sf.forEach(t),
        (_e = i(ts)),
        (Ue = n(ts, "LI", {}));
      var Hf = s(Ue);
      (ue = l(
        Hf,
        `Highest Scoring Match Player Rewards: 10% split among managers selecting
        the highest-scoring player in a fixture.`
      )),
        Hf.forEach(t),
        (j = i(ts)),
        (fe = n(ts, "LI", {}));
      var Rf = s(fe);
      (pe = l(
        Rf,
        `Weekly/Monthly/Season ATH Score Rewards: 5% each, reserved for breaking
        all-time high scores in respective categories.`
      )),
        Rf.forEach(t),
        ts.forEach(t),
        (Ce = i(st)),
        (Fe = n(st, "P", { class: !0 }));
      var Mf = s(Fe);
      (me = l(
        Mf,
        `A user is rewarded for their leaderboard position across the top 100
      positions. The following is a breakdown of the reward share for each
      position:`
      )),
        Mf.forEach(t),
        (ve = i(st)),
        (p = n(st, "TABLE", { class: !0 }));
      var M = s(p);
      D = n(M, "TR", { class: !0 });
      var Ta = s(D);
      Ee = n(Ta, "TH", {});
      var Bf = s(Ee);
      (Ne = l(Bf, "Pos")), Bf.forEach(t), (ge = i(Ta)), (H = n(Ta, "TH", {}));
      var jf = s(H);
      (W = l(jf, "Share")), jf.forEach(t), (F = i(Ta)), (He = n(Ta, "TH", {}));
      var Wf = s(He);
      (z = l(Wf, "Pos")), Wf.forEach(t), (ne = i(Ta)), (we = n(Ta, "TH", {}));
      var Uf = s(we);
      (Je = l(Uf, "Share")), Uf.forEach(t), (v = i(Ta)), (O = n(Ta, "TH", {}));
      var Nf = s(O);
      (Oe = l(Nf, "Pos")), Nf.forEach(t), (X = i(Ta)), (I = n(Ta, "TH", {}));
      var Gf = s(I);
      (Re = l(Gf, "Share")),
        Gf.forEach(t),
        (se = i(Ta)),
        (Ke = n(Ta, "TH", {}));
      var qf = s(Ke);
      (Me = l(qf, "Pos")), qf.forEach(t), (re = i(Ta)), (ze = n(Ta, "TH", {}));
      var Vf = s(ze);
      (Ie = l(Vf, "Share")),
        Vf.forEach(t),
        Ta.forEach(t),
        (be = i(M)),
        (f = n(M, "TR", { class: !0 }));
      var Pa = s(f);
      $e = n(Pa, "TD", {});
      var Jf = s($e);
      (q = l(Jf, "1")), Jf.forEach(t), (Qe = i(Pa)), (Se = n(Pa, "TD", {}));
      var Kf = s(Se);
      (Be = l(Kf, "36.09%")),
        Kf.forEach(t),
        (qe = i(Pa)),
        (je = n(Pa, "TD", {}));
      var zf = s(je);
      (E = l(zf, "26")), zf.forEach(t), (ut = i(Pa)), (at = n(Pa, "TD", {}));
      var Xf = s(at);
      (Ye = l(Xf, "0.391%")),
        Xf.forEach(t),
        (ft = i(Pa)),
        (B = n(Pa, "TD", {}));
      var Qf = s(B);
      (Ze = l(Qf, "51")), Qf.forEach(t), (g = i(Pa)), (lt = n(Pa, "TD", {}));
      var Yf = s(lt);
      (pt = l(Yf, "0.0662%")),
        Yf.forEach(t),
        (m = i(Pa)),
        (Lt = n(Pa, "TD", {}));
      var Zf = s(Lt);
      (et = l(Zf, "76")), Zf.forEach(t), (Ge = i(Pa)), (mt = n(Pa, "TD", {}));
      var ep = s(mt);
      (kt = l(ep, "0.012%")),
        ep.forEach(t),
        Pa.forEach(t),
        (Dt = i(M)),
        (Te = n(M, "TR", { class: !0 }));
      var La = s(Te);
      It = n(La, "TD", {});
      var tp = s(It);
      (xt = l(tp, "2")), tp.forEach(t), (Zt = i(La)), (At = n(La, "TD", {}));
      var ap = s(At);
      (ia = l(ap, "18.91%")),
        ap.forEach(t),
        (ea = i(La)),
        (Ct = n(La, "TD", {}));
      var np = s(Ct);
      (da = l(np, "27")), np.forEach(t), (ta = i(La)), ($t = n(La, "TD", {}));
      var sp = s($t);
      (ca = l(sp, "0.365%")),
        sp.forEach(t),
        (ha = i(La)),
        (ra = n(La, "TD", {}));
      var rp = s(ra);
      (ya = l(rp, "52")), rp.forEach(t), (ua = i(La)), (la = n(La, "TD", {}));
      var lp = s(la);
      (_a = l(lp, "0.0627%")),
        lp.forEach(t),
        (gt = i(La)),
        (St = n(La, "TD", {}));
      var op = s(St);
      (Xa = l(op, "77")), op.forEach(t), (Qa = i(La)), (oa = n(La, "TD", {}));
      var ip = s(oa);
      (Ya = l(ip, "0.0112%")),
        ip.forEach(t),
        La.forEach(t),
        (as = i(M)),
        (Ve = n(M, "TR", { class: !0 }));
      var ka = s(Ve);
      on = n(ka, "TD", {});
      var dp = s(on);
      (dn = l(dp, "3")), dp.forEach(t), (Za = i(ka)), (U = n(ka, "TD", {}));
      var cp = s(U);
      (Rs = l(cp, "10.32%")),
        cp.forEach(t),
        (cn = i(ka)),
        (mn = n(ka, "TD", {}));
      var hp = s(mn);
      (Ms = l(hp, "28")), hp.forEach(t), (We = i(ka)), (tt = n(ka, "TD", {}));
      var up = s(tt);
      (hn = l(up, "0.339%")),
        up.forEach(t),
        (Bs = i(ka)),
        (vn = n(ka, "TD", {}));
      var fp = s(vn);
      (gn = l(fp, "53")), fp.forEach(t), (ot = i(ka)), (bn = n(ka, "TD", {}));
      var pp = s(bn);
      (yn = l(pp, "0.0593%")),
        pp.forEach(t),
        (js = i(ka)),
        (_n = n(ka, "TD", {}));
      var mp = s(_n);
      (En = l(mp, "78")), mp.forEach(t), (Ws = i(ka)), (wn = n(ka, "TD", {}));
      var vp = s(wn);
      (Tn = l(vp, "0.0103%")),
        vp.forEach(t),
        ka.forEach(t),
        (Us = i(M)),
        (vt = n(M, "TR", { class: !0 }));
      var Da = s(vt);
      en = n(Da, "TD", {});
      var gp = s(en);
      (va = l(gp, "4")), gp.forEach(t), (Ns = i(Da)), (tn = n(Da, "TD", {}));
      var bp = s(tn);
      (Gs = l(bp, "6.02%")),
        bp.forEach(t),
        (qs = i(Da)),
        (an = n(Da, "TD", {}));
      var yp = s(an);
      (Vs = l(yp, "29")), yp.forEach(t), (Js = i(Da)), (Xe = n(Da, "TD", {}));
      var _p = s(Xe);
      (Ks = l(_p, "0.314%")),
        _p.forEach(t),
        (zs = i(Da)),
        (za = n(Da, "TD", {}));
      var Ep = s(za);
      (un = l(Ep, "54")), Ep.forEach(t), (ns = i(Da)), (Pn = n(Da, "TD", {}));
      var wp = s(Pn);
      (rt = l(wp, "0.0558%")),
        wp.forEach(t),
        (fn = i(Da)),
        (Ln = n(Da, "TD", {}));
      var Tp = s(Ln);
      (Xs = l(Tp, "79")), Tp.forEach(t), (kn = i(Da)), (Dn = n(Da, "TD", {}));
      var Pp = s(Dn);
      (Qs = l(Pp, "0.0095%")),
        Pp.forEach(t),
        Da.forEach(t),
        (mr = i(M)),
        (Ht = n(M, "TR", { class: !0 }));
      var Fa = s(Ht);
      vr = n(Fa, "TD", {});
      var Lp = s(vr);
      (gr = l(Lp, "5")), Lp.forEach(t), (ti = i(Fa)), (br = n(Fa, "TD", {}));
      var kp = s(br);
      (yr = l(kp, "3.87%")),
        kp.forEach(t),
        (ai = i(Fa)),
        (_r = n(Fa, "TD", {}));
      var Dp = s(_r);
      (Er = l(Dp, "30")), Dp.forEach(t), (ni = i(Fa)), (wr = n(Fa, "TD", {}));
      var Fp = s(wr);
      (Tr = l(Fp, "0.288%")),
        Fp.forEach(t),
        (si = i(Fa)),
        (Pr = n(Fa, "TD", {}));
      var Op = s(Pr);
      (Lr = l(Op, "55")), Op.forEach(t), (ri = i(Fa)), (kr = n(Fa, "TD", {}));
      var Ip = s(kr);
      (Dr = l(Ip, "0.0524%")),
        Ip.forEach(t),
        (li = i(Fa)),
        (Fr = n(Fa, "TD", {}));
      var xp = s(Fr);
      (Ys = l(xp, "80")), xp.forEach(t), (Zs = i(Fa)), (er = n(Fa, "TD", {}));
      var Ap = s(er);
      (oi = l(Ap, "0.0086%")),
        Ap.forEach(t),
        Fa.forEach(t),
        (tr = i(M)),
        (it = n(M, "TR", { class: !0 }));
      var Oa = s(it);
      Or = n(Oa, "TD", {});
      var Cp = s(Or);
      (ii = l(Cp, "6")), Cp.forEach(t), (bt = i(Oa)), (Fn = n(Oa, "TD", {}));
      var $p = s(Fn);
      (di = l($p, "2.80%")),
        $p.forEach(t),
        (ci = i(Oa)),
        (ss = n(Oa, "TD", {}));
      var Sp = s(ss);
      (hi = l(Sp, "31")), Sp.forEach(t), (ui = i(Oa)), (rs = n(Oa, "TD", {}));
      var Hp = s(rs);
      (fi = l(Hp, "0.262%")),
        Hp.forEach(t),
        (pi = i(Oa)),
        (ls = n(Oa, "TD", {}));
      var Rp = s(ls);
      (mi = l(Rp, "56")), Rp.forEach(t), (vi = i(Oa)), (os = n(Oa, "TD", {}));
      var Mp = s(os);
      (gi = l(Mp, "0.0490%")),
        Mp.forEach(t),
        (bi = i(Oa)),
        (is = n(Oa, "TD", {}));
      var Bp = s(is);
      (yi = l(Bp, "81")), Bp.forEach(t), (_i = i(Oa)), (ds = n(Oa, "TD", {}));
      var jp = s(ds);
      (Ei = l(jp, "0.0082%")),
        jp.forEach(t),
        Oa.forEach(t),
        (wi = i(M)),
        (yt = n(M, "TR", { class: !0 }));
      var Ia = s(yt);
      Ir = n(Ia, "TD", {});
      var Wp = s(Ir);
      (Ti = l(Wp, "7")), Wp.forEach(t), (xr = i(Ia)), (Ar = n(Ia, "TD", {}));
      var Up = s(Ar);
      (Pi = l(Up, "2.26%")),
        Up.forEach(t),
        (_t = i(Ia)),
        (On = n(Ia, "TD", {}));
      var Np = s(On);
      (Li = l(Np, "32")), Np.forEach(t), (ki = i(Ia)), (cs = n(Ia, "TD", {}));
      var Gp = s(cs);
      (Di = l(Gp, "0.248%")),
        Gp.forEach(t),
        (Fi = i(Ia)),
        (hs = n(Ia, "TD", {}));
      var qp = s(hs);
      (Oi = l(qp, "57")), qp.forEach(t), (Ii = i(Ia)), (us = n(Ia, "TD", {}));
      var Vp = s(us);
      (xi = l(Vp, "0.0455%")),
        Vp.forEach(t),
        (Ai = i(Ia)),
        (fs = n(Ia, "TD", {}));
      var Jp = s(fs);
      (Ci = l(Jp, "82")), Jp.forEach(t), ($i = i(Ia)), (ps = n(Ia, "TD", {}));
      var Kp = s(ps);
      (Si = l(Kp, "0.0077%")),
        Kp.forEach(t),
        Ia.forEach(t),
        (Hi = i(M)),
        (Et = n(M, "TR", { class: !0 }));
      var xa = s(Et);
      Cr = n(xa, "TD", {});
      var zp = s(Cr);
      (Ri = l(zp, "8")), zp.forEach(t), ($r = i(xa)), (Sr = n(xa, "TD", {}));
      var Xp = s(Sr);
      (Mi = l(Xp, "1.83%")),
        Xp.forEach(t),
        (Hr = i(xa)),
        (Rr = n(xa, "TD", {}));
      var Qp = s(Rr);
      (Bi = l(Qp, "33")), Qp.forEach(t), (wt = i(xa)), (In = n(xa, "TD", {}));
      var Yp = s(In);
      (ji = l(Yp, "0.235%")),
        Yp.forEach(t),
        (Wi = i(xa)),
        (ms = n(xa, "TD", {}));
      var Zp = s(ms);
      (Ui = l(Zp, "58")), Zp.forEach(t), (Ni = i(xa)), (vs = n(xa, "TD", {}));
      var em = s(vs);
      (Gi = l(em, "0.0421%")),
        em.forEach(t),
        (qi = i(xa)),
        (gs = n(xa, "TD", {}));
      var tm = s(gs);
      (Vi = l(tm, "83")), tm.forEach(t), (Ji = i(xa)), (bs = n(xa, "TD", {}));
      var am = s(bs);
      (Ki = l(am, "0.0073%")),
        am.forEach(t),
        xa.forEach(t),
        (zi = i(M)),
        (Tt = n(M, "TR", { class: !0 }));
      var Aa = s(Tt);
      Mr = n(Aa, "TD", {});
      var nm = s(Mr);
      (Xi = l(nm, "9")), nm.forEach(t), (Br = i(Aa)), (jr = n(Aa, "TD", {}));
      var sm = s(jr);
      (Qi = l(sm, "1.51%")),
        sm.forEach(t),
        (Wr = i(Aa)),
        (Ur = n(Aa, "TD", {}));
      var rm = s(Ur);
      (Yi = l(rm, "34")), rm.forEach(t), (Nr = i(Aa)), (Gr = n(Aa, "TD", {}));
      var lm = s(Gr);
      (Zi = l(lm, "0.221%")),
        lm.forEach(t),
        (ar = i(Aa)),
        (pn = n(Aa, "TD", {}));
      var om = s(pn);
      (ao = l(om, "59")), om.forEach(t), (ed = i(Aa)), (dt = n(Aa, "TD", {}));
      var im = s(dt);
      (nr = l(im, "0.0387%")),
        im.forEach(t),
        (td = i(Aa)),
        (qr = n(Aa, "TD", {}));
      var dm = s(qr);
      (Vr = l(dm, "84")), dm.forEach(t), (ad = i(Aa)), (Jr = n(Aa, "TD", {}));
      var cm = s(Jr);
      (Kr = l(cm, "0.0069%")),
        cm.forEach(t),
        Aa.forEach(t),
        (nd = i(M)),
        (Rt = n(M, "TR", { class: !0 }));
      var Ca = s(Rt);
      ys = n(Ca, "TD", {});
      var hm = s(ys);
      (sd = l(hm, "10")), hm.forEach(t), (rd = i(Ca)), (_s = n(Ca, "TD", {}));
      var um = s(_s);
      (ld = l(um, "1.30%")),
        um.forEach(t),
        (od = i(Ca)),
        (Es = n(Ca, "TD", {}));
      var fm = s(Es);
      (id = l(fm, "35")), fm.forEach(t), (dd = i(Ca)), (ws = n(Ca, "TD", {}));
      var pm = s(ws);
      (cd = l(pm, "0.207%")),
        pm.forEach(t),
        (hd = i(Ca)),
        (Ts = n(Ca, "TD", {}));
      var mm = s(Ts);
      (ud = l(mm, "60")), mm.forEach(t), (fd = i(Ca)), (Ps = n(Ca, "TD", {}));
      var vm = s(Ps);
      (pd = l(vm, "0.0352%")),
        vm.forEach(t),
        (md = i(Ca)),
        (xn = n(Ca, "TD", {}));
      var gm = s(xn);
      (Ls = l(gm, "85")), gm.forEach(t), (no = i(Ca)), (zr = n(Ca, "TD", {}));
      var bm = s(zr);
      (An = l(bm, "0.0064%")),
        bm.forEach(t),
        Ca.forEach(t),
        (ks = i(M)),
        (Mt = n(M, "TR", { class: !0 }));
      var $a = s(Mt);
      Xr = n($a, "TD", {});
      var ym = s(Xr);
      (Qr = l(ym, "11")), ym.forEach(t), (vd = i($a)), (Yr = n($a, "TD", {}));
      var _m = s(Yr);
      (sr = l(_m, "1.19%")),
        _m.forEach(t),
        (gd = i($a)),
        (Zr = n($a, "TD", {}));
      var Em = s(Zr);
      (ct = l(Em, "36")), Em.forEach(t), (Cn = i($a)), (Ds = n($a, "TD", {}));
      var wm = s(Ds);
      (bd = l(wm, "0.193%")),
        wm.forEach(t),
        (yd = i($a)),
        (Fs = n($a, "TD", {}));
      var Tm = s(Fs);
      (_d = l(Tm, "61")), Tm.forEach(t), (Ed = i($a)), ($n = n($a, "TD", {}));
      var Pm = s($n);
      (rr = l(Pm, "0.0335%")),
        Pm.forEach(t),
        (so = i($a)),
        (el = n($a, "TD", {}));
      var Lm = s(el);
      (Sn = l(Lm, "86")), Lm.forEach(t), (tl = i($a)), (al = n($a, "TD", {}));
      var km = s(al);
      (wd = l(km, "0.0060%")),
        km.forEach(t),
        $a.forEach(t),
        (nl = i(M)),
        (Bt = n(M, "TR", { class: !0 }));
      var Sa = s(Bt);
      sl = n(Sa, "TD", {});
      var Dm = s(sl);
      (Hn = l(Dm, "12")), Dm.forEach(t), (rl = i(Sa)), (ll = n(Sa, "TD", {}));
      var Fm = s(ll);
      (Td = l(Fm, "1.08%")),
        Fm.forEach(t),
        (ol = i(Sa)),
        (il = n(Sa, "TD", {}));
      var Om = s(il);
      (Pd = l(Om, "37")), Om.forEach(t), (Rn = i(Sa)), (Os = n(Sa, "TD", {}));
      var Im = s(Os);
      (Ld = l(Im, "0.180%")),
        Im.forEach(t),
        (kd = i(Sa)),
        (Is = n(Sa, "TD", {}));
      var xm = s(Is);
      (Dd = l(xm, "62")), xm.forEach(t), (Fd = i(Sa)), (nn = n(Sa, "TD", {}));
      var Am = s(nn);
      (dl = l(Am, "0.0318%")),
        Am.forEach(t),
        (Od = i(Sa)),
        (cl = n(Sa, "TD", {}));
      var Cm = s(cl);
      (hl = l(Cm, "87")), Cm.forEach(t), (Id = i(Sa)), (ul = n(Sa, "TD", {}));
      var $m = s(ul);
      (Mn = l($m, "0.0056%")),
        $m.forEach(t),
        Sa.forEach(t),
        (fl = i(M)),
        (jt = n(M, "TR", { class: !0 }));
      var Ha = s(jt);
      pl = n(Ha, "TD", {});
      var Sm = s(pl);
      (ml = l(Sm, "13")), Sm.forEach(t), (xd = i(Ha)), (vl = n(Ha, "TD", {}));
      var Hm = s(vl);
      (Bn = l(Hm, "0.98%")),
        Hm.forEach(t),
        (gl = i(Ha)),
        (bl = n(Ha, "TD", {}));
      var Rm = s(bl);
      (Ad = l(Rm, "38")), Rm.forEach(t), (yl = i(Ha)), (_l = n(Ha, "TD", {}));
      var Mm = s(_l);
      (Cd = l(Mm, "0.166%")),
        Mm.forEach(t),
        (jn = i(Ha)),
        (xs = n(Ha, "TD", {}));
      var Bm = s(xs);
      ($d = l(Bm, "63")), Bm.forEach(t), (Sd = i(Ha)), (As = n(Ha, "TD", {}));
      var jm = s(As);
      (Hd = l(jm, "0.0301%")),
        jm.forEach(t),
        (Rd = i(Ha)),
        (sn = n(Ha, "TD", {}));
      var Wm = s(sn);
      (El = l(Wm, "88")), Wm.forEach(t), (Md = i(Ha)), (wl = n(Ha, "TD", {}));
      var Um = s(wl);
      (Tl = l(Um, "0.0052%")),
        Um.forEach(t),
        Ha.forEach(t),
        (Bd = i(M)),
        (Wt = n(M, "TR", { class: !0 }));
      var Ra = s(Wt);
      Wn = n(Ra, "TD", {});
      var Nm = s(Wn);
      (jd = l(Nm, "14")), Nm.forEach(t), (Wd = i(Ra)), (Un = n(Ra, "TD", {}));
      var Gm = s(Un);
      (Ud = l(Gm, "0.87%")),
        Gm.forEach(t),
        (Nd = i(Ra)),
        (Nn = n(Ra, "TD", {}));
      var qm = s(Nn);
      (Gd = l(qm, "39")), qm.forEach(t), (qd = i(Ra)), (ga = n(Ra, "TD", {}));
      var Vm = s(ga);
      (Pl = l(Vm, "0.152%")),
        Vm.forEach(t),
        (Vd = i(Ra)),
        (Ll = n(Ra, "TD", {}));
      var Jm = s(Ll);
      (kl = l(Jm, "64")), Jm.forEach(t), (Jd = i(Ra)), (Dl = n(Ra, "TD", {}));
      var Km = s(Dl);
      (Fl = l(Km, "0.0284%")),
        Km.forEach(t),
        (Kd = i(Ra)),
        (Ol = n(Ra, "TD", {}));
      var zm = s(Ol);
      (Il = l(zm, "89")), zm.forEach(t), (zd = i(Ra)), (xl = n(Ra, "TD", {}));
      var Xm = s(xl);
      (lr = l(Xm, "0.0047%")),
        Xm.forEach(t),
        Ra.forEach(t),
        (Xd = i(M)),
        (Ut = n(M, "TR", { class: !0 }));
      var Ma = s(Ut);
      Gn = n(Ma, "TD", {});
      var Qm = s(Gn);
      (Qd = l(Qm, "15")), Qm.forEach(t), (Yd = i(Ma)), (qn = n(Ma, "TD", {}));
      var Ym = s(qn);
      (Zd = l(Ym, "0.76%")),
        Ym.forEach(t),
        (ec = i(Ma)),
        (Vn = n(Ma, "TD", {}));
      var Zm = s(Vn);
      (tc = l(Zm, "40")), Zm.forEach(t), (ac = i(Ma)), (Jn = n(Ma, "TD", {}));
      var ev = s(Jn);
      (nc = l(ev, "0.138%")),
        ev.forEach(t),
        (sc = i(Ma)),
        (Kn = n(Ma, "TD", {}));
      var tv = s(Kn);
      (rc = l(tv, "65")), tv.forEach(t), (lc = i(Ma)), (ba = n(Ma, "TD", {}));
      var av = s(ba);
      (Al = l(av, "0.0266%")),
        av.forEach(t),
        (oc = i(Ma)),
        (Cl = n(Ma, "TD", {}));
      var nv = s(Cl);
      ($l = l(nv, "90")), nv.forEach(t), (ic = i(Ma)), (Sl = n(Ma, "TD", {}));
      var sv = s(Sl);
      (Hl = l(sv, "0.0043%")),
        sv.forEach(t),
        Ma.forEach(t),
        (dc = i(M)),
        (Nt = n(M, "TR", { class: !0 }));
      var Ba = s(Nt);
      Cs = n(Ba, "TD", {});
      var rv = s(Cs);
      (cc = l(rv, "16")), rv.forEach(t), (hc = i(Ba)), (zn = n(Ba, "TD", {}));
      var lv = s(zn);
      (uc = l(lv, "0.72%")),
        lv.forEach(t),
        (fc = i(Ba)),
        (fa = n(Ba, "TD", {}));
      var ov = s(fa);
      (Rl = l(ov, "41")), ov.forEach(t), (pc = i(Ba)), (Ml = n(Ba, "TD", {}));
      var iv = s(Ml);
      (Bl = l(iv, "0.131%")),
        iv.forEach(t),
        (mc = i(Ba)),
        (jl = n(Ba, "TD", {}));
      var dv = s(jl);
      (Wl = l(dv, "66")), dv.forEach(t), (vc = i(Ba)), (Ul = n(Ba, "TD", {}));
      var cv = s(Ul);
      (Nl = l(cv, "0.0249%")),
        cv.forEach(t),
        (gc = i(Ba)),
        (Gl = n(Ba, "TD", {}));
      var hv = s(Gl);
      (ql = l(hv, "91")), hv.forEach(t), (bc = i(Ba)), (Vl = n(Ba, "TD", {}));
      var uv = s(Vl);
      (Xn = l(uv, "0.0041%")),
        uv.forEach(t),
        Ba.forEach(t),
        (yc = i(M)),
        (ht = n(M, "TR", { class: !0 }));
      var ja = s(ht);
      Jl = n(ja, "TD", {});
      var fv = s(Jl);
      (_c = l(fv, "17")), fv.forEach(t), (Kl = i(ja)), (or = n(ja, "TD", {}));
      var pv = s(or);
      (_ = l(pv, "0.67%")), pv.forEach(t), (Ec = i(ja)), (ro = n(ja, "TD", {}));
      var mv = s(ro);
      (wc = l(mv, "42")), mv.forEach(t), (pa = i(ja)), (lo = n(ja, "TD", {}));
      var vv = s(lo);
      (Tc = l(vv, "0.125%")),
        vv.forEach(t),
        (Pc = i(ja)),
        (oo = n(ja, "TD", {}));
      var gv = s(oo);
      (Lc = l(gv, "67")), gv.forEach(t), (kc = i(ja)), (io = n(ja, "TD", {}));
      var bv = s(io);
      (Dc = l(bv, "0.0232%")),
        bv.forEach(t),
        (Fc = i(ja)),
        (co = n(ja, "TD", {}));
      var yv = s(co);
      (Qn = l(yv, "92")), yv.forEach(t), (Oc = i(ja)), (ho = n(ja, "TD", {}));
      var _v = s(ho);
      (Ic = l(_v, "0.0039%")),
        _v.forEach(t),
        ja.forEach(t),
        (xc = i(M)),
        (Kt = n(M, "TR", { class: !0 }));
      var Wa = s(Kt);
      Ea = n(Wa, "TD", {});
      var Ev = s(Ea);
      (Ac = l(Ev, "18")), Ev.forEach(t), (Cc = i(Wa)), (uo = n(Wa, "TD", {}));
      var wv = s(uo);
      ($c = l(wv, "0.63%")),
        wv.forEach(t),
        (Sc = i(Wa)),
        (fo = n(Wa, "TD", {}));
      var Tv = s(fo);
      (rn = l(Tv, "43")), Tv.forEach(t), (Hc = i(Wa)), (po = n(Wa, "TD", {}));
      var Pv = s(po);
      (Rc = l(Pv, "0.118%")),
        Pv.forEach(t),
        (Mc = i(Wa)),
        (mo = n(Wa, "TD", {}));
      var Lv = s(mo);
      (Bc = l(Lv, "68")), Lv.forEach(t), (ln = i(Wa)), (vo = n(Wa, "TD", {}));
      var kv = s(vo);
      (jc = l(kv, "0.0215%")),
        kv.forEach(t),
        (Wc = i(Wa)),
        (go = n(Wa, "TD", {}));
      var Dv = s(go);
      (Uc = l(Dv, "93")), Dv.forEach(t), (Nc = i(Wa)), (bo = n(Wa, "TD", {}));
      var Fv = s(bo);
      (Yn = l(Fv, "0.0037%")),
        Fv.forEach(t),
        Wa.forEach(t),
        (Gc = i(M)),
        (zt = n(M, "TR", { class: !0 }));
      var Ua = s(zt);
      yo = n(Ua, "TD", {});
      var Ov = s(yo);
      (qc = l(Ov, "19")), Ov.forEach(t), (Vc = i(Ua)), (nt = n(Ua, "TD", {}));
      var Iv = s(nt);
      (aa = l(Iv, "0.59%")),
        Iv.forEach(t),
        (Jc = i(Ua)),
        (_o = n(Ua, "TD", {}));
      var xv = s(_o);
      (Kc = l(xv, "44")), xv.forEach(t), (zc = i(Ua)), (Eo = n(Ua, "TD", {}));
      var Av = s(Eo);
      (Xc = l(Av, "0.111%")),
        Av.forEach(t),
        (Qc = i(Ua)),
        (wo = n(Ua, "TD", {}));
      var Cv = s(wo);
      (Yc = l(Cv, "69")), Cv.forEach(t), (Zc = i(Ua)), (To = n(Ua, "TD", {}));
      var $v = s(To);
      (na = l($v, "0.0198%")),
        $v.forEach(t),
        (eh = i(Ua)),
        (Po = n(Ua, "TD", {}));
      var Sv = s(Po);
      (th = l(Sv, "94")), Sv.forEach(t), (ah = i(Ua)), (Lo = n(Ua, "TD", {}));
      var Hv = s(Lo);
      (nh = l(Hv, "0.0034%")),
        Hv.forEach(t),
        Ua.forEach(t),
        (sh = i(M)),
        (Xt = n(M, "TR", { class: !0 }));
      var Na = s(Xt);
      ko = n(Na, "TD", {});
      var Rv = s(ko);
      (rh = l(Rv, "20")), Rv.forEach(t), (lh = i(Na)), (Do = n(Na, "TD", {}));
      var Mv = s(Do);
      (oh = l(Mv, "0.55%")),
        Mv.forEach(t),
        (sa = i(Na)),
        (Fo = n(Na, "TD", {}));
      var Bv = s(Fo);
      (ih = l(Bv, "45")), Bv.forEach(t), (dh = i(Na)), (Oo = n(Na, "TD", {}));
      var jv = s(Oo);
      (ch = l(jv, "0.104%")),
        jv.forEach(t),
        (hh = i(Na)),
        (Io = n(Na, "TD", {}));
      var Wv = s(Io);
      (uh = l(Wv, "70")), Wv.forEach(t), (fh = i(Na)), (Gt = n(Na, "TD", {}));
      var Uv = s(Gt);
      (ph = l(Uv, "0.0180%")),
        Uv.forEach(t),
        (mh = i(Na)),
        (xo = n(Na, "TD", {}));
      var Nv = s(xo);
      (vh = l(Nv, "95")), Nv.forEach(t), (gh = i(Na)), (Ao = n(Na, "TD", {}));
      var Gv = s(Ao);
      (bh = l(Gv, "0.0032%")),
        Gv.forEach(t),
        Na.forEach(t),
        (yh = i(M)),
        (Qt = n(M, "TR", { class: !0 }));
      var Ga = s(Qt);
      qt = n(Ga, "TD", {});
      var qv = s(qt);
      (_h = l(qv, "21")), qv.forEach(t), (Eh = i(Ga)), (Co = n(Ga, "TD", {}));
      var Vv = s(Co);
      (wh = l(Vv, "0.52%")),
        Vv.forEach(t),
        (Th = i(Ga)),
        ($o = n(Ga, "TD", {}));
      var Jv = s($o);
      (Ph = l(Jv, "46")), Jv.forEach(t), (Lh = i(Ga)), (So = n(Ga, "TD", {}));
      var Kv = s(So);
      (kh = l(Kv, "0.097%")),
        Kv.forEach(t),
        (Dh = i(Ga)),
        (Vt = n(Ga, "TD", {}));
      var zv = s(Vt);
      (Fh = l(zv, "71")), zv.forEach(t), (Oh = i(Ga)), (Ho = n(Ga, "TD", {}));
      var Xv = s(Ho);
      (Ih = l(Xv, "0.0172%")),
        Xv.forEach(t),
        (xh = i(Ga)),
        (Ro = n(Ga, "TD", {}));
      var Qv = s(Ro);
      (Ah = l(Qv, "96")), Qv.forEach(t), (Ch = i(Ga)), (Mo = n(Ga, "TD", {}));
      var Yv = s(Mo);
      ($h = l(Yv, "0.0030%")),
        Yv.forEach(t),
        Ga.forEach(t),
        (Sh = i(M)),
        (Ft = n(M, "TR", { class: !0 }));
      var qa = s(Ft);
      Bo = n(qa, "TD", {});
      var Zv = s(Bo);
      (Hh = l(Zv, "22")), Zv.forEach(t), (Rh = i(qa)), (Pt = n(qa, "TD", {}));
      var e1 = s(Pt);
      (jo = l(e1, "0.49%")),
        e1.forEach(t),
        (Mh = i(qa)),
        (Wo = n(qa, "TD", {}));
      var t1 = s(Wo);
      (Bh = l(t1, "47")), t1.forEach(t), (jh = i(qa)), (ir = n(qa, "TD", {}));
      var a1 = s(ir);
      (Wh = l(a1, "0.090%")),
        a1.forEach(t),
        (Uh = i(qa)),
        (dr = n(qa, "TD", {}));
      var n1 = s(dr);
      (Nh = l(n1, "72")), n1.forEach(t), (Gh = i(qa)), (cr = n(qa, "TD", {}));
      var s1 = s(cr);
      (qh = l(s1, "0.0155%")),
        s1.forEach(t),
        (Vh = i(qa)),
        (hr = n(qa, "TD", {}));
      var r1 = s(hr);
      (Jh = l(r1, "97")), r1.forEach(t), (Kh = i(qa)), (ur = n(qa, "TD", {}));
      var l1 = s(ur);
      (zh = l(l1, "0.0028%")),
        l1.forEach(t),
        qa.forEach(t),
        (Xh = i(M)),
        (Ot = n(M, "TR", { class: !0 }));
      var Va = s(Ot);
      Uo = n(Va, "TD", {});
      var o1 = s(Uo);
      (Qh = l(o1, "23")), o1.forEach(t), (No = i(Va)), (Go = n(Va, "TD", {}));
      var i1 = s(Go);
      (Yh = l(i1, "0.47%")),
        i1.forEach(t),
        (qo = i(Va)),
        (Vo = n(Va, "TD", {}));
      var d1 = s(Vo);
      (Zh = l(d1, "48")), d1.forEach(t), (eu = i(Va)), (Jo = n(Va, "TD", {}));
      var c1 = s(Jo);
      (tu = l(c1, "0.083%")),
        c1.forEach(t),
        (Zn = i(Va)),
        (Ko = n(Va, "TD", {}));
      var h1 = s(Ko);
      (au = l(h1, "73")), h1.forEach(t), (nu = i(Va)), (zo = n(Va, "TD", {}));
      var u1 = s(zo);
      (su = l(u1, "0.0146%")),
        u1.forEach(t),
        (ru = i(Va)),
        (Xo = n(Va, "TD", {}));
      var f1 = s(Xo);
      (lu = l(f1, "98")), f1.forEach(t), (ou = i(Va)), (Qo = n(Va, "TD", {}));
      var p1 = s(Qo);
      (es = l(p1, "0.0026%")),
        p1.forEach(t),
        Va.forEach(t),
        (iu = i(M)),
        (Yt = n(M, "TR", { class: !0 }));
      var Ja = s(Yt);
      Yo = n(Ja, "TD", {});
      var m1 = s(Yo);
      (du = l(m1, "24")), m1.forEach(t), (cu = i(Ja)), (wa = n(Ja, "TD", {}));
      var v1 = s(wa);
      (hu = l(v1, "0.44%")),
        v1.forEach(t),
        (uu = i(Ja)),
        (Zo = n(Ja, "TD", {}));
      var g1 = s(Zo);
      (fu = l(g1, "49")), g1.forEach(t), (pu = i(Ja)), (fr = n(Ja, "TD", {}));
      var b1 = s(fr);
      (mu = l(b1, "0.076%")),
        b1.forEach(t),
        (Bu = i(Ja)),
        (Eu = n(Ja, "TD", {}));
      var y1 = s(Eu);
      (ju = l(y1, "74")), y1.forEach(t), (Wu = i(Ja)), (wu = n(Ja, "TD", {}));
      var _1 = s(wu);
      (Uu = l(_1, "0.0137%")),
        _1.forEach(t),
        (Nu = i(Ja)),
        (Tu = n(Ja, "TD", {}));
      var E1 = s(Tu);
      (Gu = l(E1, "99")), E1.forEach(t), (qu = i(Ja)), (Pu = n(Ja, "TD", {}));
      var w1 = s(Pu);
      (Vu = l(w1, "0.0024%")),
        w1.forEach(t),
        Ja.forEach(t),
        (Ju = i(M)),
        (ma = n(M, "TR", { class: !0 }));
      var Ka = s(ma);
      Lu = n(Ka, "TD", {});
      var T1 = s(Lu);
      (Ku = l(T1, "25")), T1.forEach(t), (zu = i(Ka)), (ku = n(Ka, "TD", {}));
      var P1 = s(ku);
      (Xu = l(P1, "0.42%")),
        P1.forEach(t),
        (Qu = i(Ka)),
        (Du = n(Ka, "TD", {}));
      var L1 = s(Du);
      (Yu = l(L1, "50")), L1.forEach(t), (Zu = i(Ka)), (Fu = n(Ka, "TD", {}));
      var k1 = s(Fu);
      (ef = l(k1, "0.070%")),
        k1.forEach(t),
        (tf = i(Ka)),
        (Ou = n(Ka, "TD", {}));
      var D1 = s(Ou);
      (af = l(D1, "75")), D1.forEach(t), (nf = i(Ka)), (Iu = n(Ka, "TD", {}));
      var F1 = s(Iu);
      (sf = l(F1, "0.0129%")),
        F1.forEach(t),
        (rf = i(Ka)),
        (xu = n(Ka, "TD", {}));
      var O1 = s(xu);
      (lf = l(O1, "100")), O1.forEach(t), (of = i(Ka)), (Au = n(Ka, "TD", {}));
      var I1 = s(Au);
      (df = l(I1, "0.0021%")),
        I1.forEach(t),
        Ka.forEach(t),
        M.forEach(t),
        (cf = i(st)),
        (vu = n(st, "P", { class: !0 }));
      var x1 = s(vu);
      (hf = l(
        x1,
        `To ensure rewards are paid for active participation, a user would need to
      do the following to qualify for the following OpenFPL gameplay rewards:`
      )),
        x1.forEach(t),
        (uf = i(st)),
        (pr = n(st, "UL", { class: !0 }));
      var _u = s(pr);
      Cu = n(_u, "LI", {});
      var A1 = s(Cu);
      (ff = l(
        A1,
        `A user must have made at least 2 changes in a month to qualify for that
        month's club leaderboard rewards and monthly ATH record rewards.`
      )),
        A1.forEach(t),
        (pf = i(_u)),
        ($u = n(_u, "LI", {}));
      var C1 = s($u);
      (mf = l(
        C1,
        `A user must have made at least 1 change in a gameweek to qualify for
        that week's leaderboard rewards, highest-scoring match player rewards
        and weekly ATH record rewards.`
      )),
        C1.forEach(t),
        (vf = i(_u)),
        (Su = n(_u, "LI", {}));
      var $1 = s(Su);
      (gf = l(
        $1,
        `Rewards for the season total, most valuable team have and annual ATH
        have no entry restrictions as it is based on the cumulative action of
        managers transfers throughout the season.`
      )),
        $1.forEach(t),
        _u.forEach(t),
        (bf = i(st)),
        (gu = n(st, "H2", { class: !0 }));
      var S1 = s(gu);
      (yf = l(S1, "Governance Rewards (25%)")),
        S1.forEach(t),
        (_f = i(st)),
        (bu = n(st, "P", { class: !0 }));
      var H1 = s(bu);
      (Ef = l(
        H1,
        `OpenFPL values neuron holders' contributions to maintaining up-to-date
      Premier League data. Rewards are given for raising and voting on essential
      proposals, such as scheduling, player transfers, and updating player
      information. Failed proposals incur a 10 $FPL cost, contributing to the
      DAO’s treasury.`
      )),
        H1.forEach(t),
        (wf = i(st)),
        (yu = n(st, "P", { class: !0 }));
      var R1 = s(yu);
      (Tf = l(
        R1,
        `The OpenFPL DAO is an innovative approach to fantasy football, combining
      real-time data accuracy with rewarding community involvement. By aligning
      rewards with active participation, OpenFPL ensures a vibrant, informed,
      and engaged user base.`
      )),
        R1.forEach(t),
        st.forEach(t),
        Ru.forEach(t),
        this.h();
    },
    h() {
      c(u, "class", "text-3xl font-bold"),
        c(b, "class", "my-4"),
        c(L, "class", "text-xl font-bold"),
        c(y, "class", "my-2"),
        c(k, "class", "list-disc ml-4"),
        c(ee, "class", "text-lg font-bold mt-4"),
        c(V, "class", "my-2"),
        c(P, "class", "list-disc ml-4"),
        c(Fe, "class", "my-2"),
        c(D, "class", "svelte-58jp75"),
        c(f, "class", "svelte-58jp75"),
        c(Te, "class", "svelte-58jp75"),
        c(Ve, "class", "svelte-58jp75"),
        c(vt, "class", "svelte-58jp75"),
        c(Ht, "class", "svelte-58jp75"),
        c(it, "class", "svelte-58jp75"),
        c(yt, "class", "svelte-58jp75"),
        c(Et, "class", "svelte-58jp75"),
        c(Tt, "class", "svelte-58jp75"),
        c(Rt, "class", "svelte-58jp75"),
        c(Mt, "class", "svelte-58jp75"),
        c(Bt, "class", "svelte-58jp75"),
        c(jt, "class", "svelte-58jp75"),
        c(Wt, "class", "svelte-58jp75"),
        c(Ut, "class", "svelte-58jp75"),
        c(Nt, "class", "svelte-58jp75"),
        c(ht, "class", "svelte-58jp75"),
        c(Kt, "class", "svelte-58jp75"),
        c(zt, "class", "svelte-58jp75"),
        c(Xt, "class", "svelte-58jp75"),
        c(Qt, "class", "svelte-58jp75"),
        c(Ft, "class", "svelte-58jp75"),
        c(Ot, "class", "svelte-58jp75"),
        c(Yt, "class", "svelte-58jp75"),
        c(ma, "class", "svelte-58jp75"),
        c(
          p,
          "class",
          "w-full text-center border-collapse striped mb-8 mt-8 svelte-58jp75"
        ),
        c(vu, "class", "my-2"),
        c(pr, "class", "list-disc ml-4"),
        c(gu, "class", "text-lg font-bold mt-4"),
        c(bu, "class", "my-2"),
        c(yu, "class", "my-4"),
        c(d, "class", "m-4"),
        c(h, "class", "container-fluid mx-auto p-4");
    },
    m(Hu, Ru) {
      $s(Hu, h, Ru),
        e(h, d),
        e(d, u),
        e(u, w),
        e(d, N),
        e(d, b),
        e(b, le),
        e(d, Z),
        e(d, L),
        e(L, Le),
        e(d, ke),
        e(d, y),
        e(y, J),
        e(d, oe),
        e(d, k),
        e(k, ie),
        e(ie, xe),
        e(k, A),
        e(k, K),
        e(K, de),
        e(d, C),
        e(d, ee),
        e(ee, Ae),
        e(d, $),
        e(d, V),
        e(V, Q),
        e(d, S),
        e(d, P),
        e(P, te),
        e(te, G),
        e(P, ce),
        e(P, ae),
        e(ae, T),
        e(P, ye),
        e(P, De),
        e(De, R),
        e(P, Y),
        e(P, Pe),
        e(Pe, he),
        e(P, _e),
        e(P, Ue),
        e(Ue, ue),
        e(P, j),
        e(P, fe),
        e(fe, pe),
        e(d, Ce),
        e(d, Fe),
        e(Fe, me),
        e(d, ve),
        e(d, p),
        e(p, D),
        e(D, Ee),
        e(Ee, Ne),
        e(D, ge),
        e(D, H),
        e(H, W),
        e(D, F),
        e(D, He),
        e(He, z),
        e(D, ne),
        e(D, we),
        e(we, Je),
        e(D, v),
        e(D, O),
        e(O, Oe),
        e(D, X),
        e(D, I),
        e(I, Re),
        e(D, se),
        e(D, Ke),
        e(Ke, Me),
        e(D, re),
        e(D, ze),
        e(ze, Ie),
        e(p, be),
        e(p, f),
        e(f, $e),
        e($e, q),
        e(f, Qe),
        e(f, Se),
        e(Se, Be),
        e(f, qe),
        e(f, je),
        e(je, E),
        e(f, ut),
        e(f, at),
        e(at, Ye),
        e(f, ft),
        e(f, B),
        e(B, Ze),
        e(f, g),
        e(f, lt),
        e(lt, pt),
        e(f, m),
        e(f, Lt),
        e(Lt, et),
        e(f, Ge),
        e(f, mt),
        e(mt, kt),
        e(p, Dt),
        e(p, Te),
        e(Te, It),
        e(It, xt),
        e(Te, Zt),
        e(Te, At),
        e(At, ia),
        e(Te, ea),
        e(Te, Ct),
        e(Ct, da),
        e(Te, ta),
        e(Te, $t),
        e($t, ca),
        e(Te, ha),
        e(Te, ra),
        e(ra, ya),
        e(Te, ua),
        e(Te, la),
        e(la, _a),
        e(Te, gt),
        e(Te, St),
        e(St, Xa),
        e(Te, Qa),
        e(Te, oa),
        e(oa, Ya),
        e(p, as),
        e(p, Ve),
        e(Ve, on),
        e(on, dn),
        e(Ve, Za),
        e(Ve, U),
        e(U, Rs),
        e(Ve, cn),
        e(Ve, mn),
        e(mn, Ms),
        e(Ve, We),
        e(Ve, tt),
        e(tt, hn),
        e(Ve, Bs),
        e(Ve, vn),
        e(vn, gn),
        e(Ve, ot),
        e(Ve, bn),
        e(bn, yn),
        e(Ve, js),
        e(Ve, _n),
        e(_n, En),
        e(Ve, Ws),
        e(Ve, wn),
        e(wn, Tn),
        e(p, Us),
        e(p, vt),
        e(vt, en),
        e(en, va),
        e(vt, Ns),
        e(vt, tn),
        e(tn, Gs),
        e(vt, qs),
        e(vt, an),
        e(an, Vs),
        e(vt, Js),
        e(vt, Xe),
        e(Xe, Ks),
        e(vt, zs),
        e(vt, za),
        e(za, un),
        e(vt, ns),
        e(vt, Pn),
        e(Pn, rt),
        e(vt, fn),
        e(vt, Ln),
        e(Ln, Xs),
        e(vt, kn),
        e(vt, Dn),
        e(Dn, Qs),
        e(p, mr),
        e(p, Ht),
        e(Ht, vr),
        e(vr, gr),
        e(Ht, ti),
        e(Ht, br),
        e(br, yr),
        e(Ht, ai),
        e(Ht, _r),
        e(_r, Er),
        e(Ht, ni),
        e(Ht, wr),
        e(wr, Tr),
        e(Ht, si),
        e(Ht, Pr),
        e(Pr, Lr),
        e(Ht, ri),
        e(Ht, kr),
        e(kr, Dr),
        e(Ht, li),
        e(Ht, Fr),
        e(Fr, Ys),
        e(Ht, Zs),
        e(Ht, er),
        e(er, oi),
        e(p, tr),
        e(p, it),
        e(it, Or),
        e(Or, ii),
        e(it, bt),
        e(it, Fn),
        e(Fn, di),
        e(it, ci),
        e(it, ss),
        e(ss, hi),
        e(it, ui),
        e(it, rs),
        e(rs, fi),
        e(it, pi),
        e(it, ls),
        e(ls, mi),
        e(it, vi),
        e(it, os),
        e(os, gi),
        e(it, bi),
        e(it, is),
        e(is, yi),
        e(it, _i),
        e(it, ds),
        e(ds, Ei),
        e(p, wi),
        e(p, yt),
        e(yt, Ir),
        e(Ir, Ti),
        e(yt, xr),
        e(yt, Ar),
        e(Ar, Pi),
        e(yt, _t),
        e(yt, On),
        e(On, Li),
        e(yt, ki),
        e(yt, cs),
        e(cs, Di),
        e(yt, Fi),
        e(yt, hs),
        e(hs, Oi),
        e(yt, Ii),
        e(yt, us),
        e(us, xi),
        e(yt, Ai),
        e(yt, fs),
        e(fs, Ci),
        e(yt, $i),
        e(yt, ps),
        e(ps, Si),
        e(p, Hi),
        e(p, Et),
        e(Et, Cr),
        e(Cr, Ri),
        e(Et, $r),
        e(Et, Sr),
        e(Sr, Mi),
        e(Et, Hr),
        e(Et, Rr),
        e(Rr, Bi),
        e(Et, wt),
        e(Et, In),
        e(In, ji),
        e(Et, Wi),
        e(Et, ms),
        e(ms, Ui),
        e(Et, Ni),
        e(Et, vs),
        e(vs, Gi),
        e(Et, qi),
        e(Et, gs),
        e(gs, Vi),
        e(Et, Ji),
        e(Et, bs),
        e(bs, Ki),
        e(p, zi),
        e(p, Tt),
        e(Tt, Mr),
        e(Mr, Xi),
        e(Tt, Br),
        e(Tt, jr),
        e(jr, Qi),
        e(Tt, Wr),
        e(Tt, Ur),
        e(Ur, Yi),
        e(Tt, Nr),
        e(Tt, Gr),
        e(Gr, Zi),
        e(Tt, ar),
        e(Tt, pn),
        e(pn, ao),
        e(Tt, ed),
        e(Tt, dt),
        e(dt, nr),
        e(Tt, td),
        e(Tt, qr),
        e(qr, Vr),
        e(Tt, ad),
        e(Tt, Jr),
        e(Jr, Kr),
        e(p, nd),
        e(p, Rt),
        e(Rt, ys),
        e(ys, sd),
        e(Rt, rd),
        e(Rt, _s),
        e(_s, ld),
        e(Rt, od),
        e(Rt, Es),
        e(Es, id),
        e(Rt, dd),
        e(Rt, ws),
        e(ws, cd),
        e(Rt, hd),
        e(Rt, Ts),
        e(Ts, ud),
        e(Rt, fd),
        e(Rt, Ps),
        e(Ps, pd),
        e(Rt, md),
        e(Rt, xn),
        e(xn, Ls),
        e(Rt, no),
        e(Rt, zr),
        e(zr, An),
        e(p, ks),
        e(p, Mt),
        e(Mt, Xr),
        e(Xr, Qr),
        e(Mt, vd),
        e(Mt, Yr),
        e(Yr, sr),
        e(Mt, gd),
        e(Mt, Zr),
        e(Zr, ct),
        e(Mt, Cn),
        e(Mt, Ds),
        e(Ds, bd),
        e(Mt, yd),
        e(Mt, Fs),
        e(Fs, _d),
        e(Mt, Ed),
        e(Mt, $n),
        e($n, rr),
        e(Mt, so),
        e(Mt, el),
        e(el, Sn),
        e(Mt, tl),
        e(Mt, al),
        e(al, wd),
        e(p, nl),
        e(p, Bt),
        e(Bt, sl),
        e(sl, Hn),
        e(Bt, rl),
        e(Bt, ll),
        e(ll, Td),
        e(Bt, ol),
        e(Bt, il),
        e(il, Pd),
        e(Bt, Rn),
        e(Bt, Os),
        e(Os, Ld),
        e(Bt, kd),
        e(Bt, Is),
        e(Is, Dd),
        e(Bt, Fd),
        e(Bt, nn),
        e(nn, dl),
        e(Bt, Od),
        e(Bt, cl),
        e(cl, hl),
        e(Bt, Id),
        e(Bt, ul),
        e(ul, Mn),
        e(p, fl),
        e(p, jt),
        e(jt, pl),
        e(pl, ml),
        e(jt, xd),
        e(jt, vl),
        e(vl, Bn),
        e(jt, gl),
        e(jt, bl),
        e(bl, Ad),
        e(jt, yl),
        e(jt, _l),
        e(_l, Cd),
        e(jt, jn),
        e(jt, xs),
        e(xs, $d),
        e(jt, Sd),
        e(jt, As),
        e(As, Hd),
        e(jt, Rd),
        e(jt, sn),
        e(sn, El),
        e(jt, Md),
        e(jt, wl),
        e(wl, Tl),
        e(p, Bd),
        e(p, Wt),
        e(Wt, Wn),
        e(Wn, jd),
        e(Wt, Wd),
        e(Wt, Un),
        e(Un, Ud),
        e(Wt, Nd),
        e(Wt, Nn),
        e(Nn, Gd),
        e(Wt, qd),
        e(Wt, ga),
        e(ga, Pl),
        e(Wt, Vd),
        e(Wt, Ll),
        e(Ll, kl),
        e(Wt, Jd),
        e(Wt, Dl),
        e(Dl, Fl),
        e(Wt, Kd),
        e(Wt, Ol),
        e(Ol, Il),
        e(Wt, zd),
        e(Wt, xl),
        e(xl, lr),
        e(p, Xd),
        e(p, Ut),
        e(Ut, Gn),
        e(Gn, Qd),
        e(Ut, Yd),
        e(Ut, qn),
        e(qn, Zd),
        e(Ut, ec),
        e(Ut, Vn),
        e(Vn, tc),
        e(Ut, ac),
        e(Ut, Jn),
        e(Jn, nc),
        e(Ut, sc),
        e(Ut, Kn),
        e(Kn, rc),
        e(Ut, lc),
        e(Ut, ba),
        e(ba, Al),
        e(Ut, oc),
        e(Ut, Cl),
        e(Cl, $l),
        e(Ut, ic),
        e(Ut, Sl),
        e(Sl, Hl),
        e(p, dc),
        e(p, Nt),
        e(Nt, Cs),
        e(Cs, cc),
        e(Nt, hc),
        e(Nt, zn),
        e(zn, uc),
        e(Nt, fc),
        e(Nt, fa),
        e(fa, Rl),
        e(Nt, pc),
        e(Nt, Ml),
        e(Ml, Bl),
        e(Nt, mc),
        e(Nt, jl),
        e(jl, Wl),
        e(Nt, vc),
        e(Nt, Ul),
        e(Ul, Nl),
        e(Nt, gc),
        e(Nt, Gl),
        e(Gl, ql),
        e(Nt, bc),
        e(Nt, Vl),
        e(Vl, Xn),
        e(p, yc),
        e(p, ht),
        e(ht, Jl),
        e(Jl, _c),
        e(ht, Kl),
        e(ht, or),
        e(or, _),
        e(ht, Ec),
        e(ht, ro),
        e(ro, wc),
        e(ht, pa),
        e(ht, lo),
        e(lo, Tc),
        e(ht, Pc),
        e(ht, oo),
        e(oo, Lc),
        e(ht, kc),
        e(ht, io),
        e(io, Dc),
        e(ht, Fc),
        e(ht, co),
        e(co, Qn),
        e(ht, Oc),
        e(ht, ho),
        e(ho, Ic),
        e(p, xc),
        e(p, Kt),
        e(Kt, Ea),
        e(Ea, Ac),
        e(Kt, Cc),
        e(Kt, uo),
        e(uo, $c),
        e(Kt, Sc),
        e(Kt, fo),
        e(fo, rn),
        e(Kt, Hc),
        e(Kt, po),
        e(po, Rc),
        e(Kt, Mc),
        e(Kt, mo),
        e(mo, Bc),
        e(Kt, ln),
        e(Kt, vo),
        e(vo, jc),
        e(Kt, Wc),
        e(Kt, go),
        e(go, Uc),
        e(Kt, Nc),
        e(Kt, bo),
        e(bo, Yn),
        e(p, Gc),
        e(p, zt),
        e(zt, yo),
        e(yo, qc),
        e(zt, Vc),
        e(zt, nt),
        e(nt, aa),
        e(zt, Jc),
        e(zt, _o),
        e(_o, Kc),
        e(zt, zc),
        e(zt, Eo),
        e(Eo, Xc),
        e(zt, Qc),
        e(zt, wo),
        e(wo, Yc),
        e(zt, Zc),
        e(zt, To),
        e(To, na),
        e(zt, eh),
        e(zt, Po),
        e(Po, th),
        e(zt, ah),
        e(zt, Lo),
        e(Lo, nh),
        e(p, sh),
        e(p, Xt),
        e(Xt, ko),
        e(ko, rh),
        e(Xt, lh),
        e(Xt, Do),
        e(Do, oh),
        e(Xt, sa),
        e(Xt, Fo),
        e(Fo, ih),
        e(Xt, dh),
        e(Xt, Oo),
        e(Oo, ch),
        e(Xt, hh),
        e(Xt, Io),
        e(Io, uh),
        e(Xt, fh),
        e(Xt, Gt),
        e(Gt, ph),
        e(Xt, mh),
        e(Xt, xo),
        e(xo, vh),
        e(Xt, gh),
        e(Xt, Ao),
        e(Ao, bh),
        e(p, yh),
        e(p, Qt),
        e(Qt, qt),
        e(qt, _h),
        e(Qt, Eh),
        e(Qt, Co),
        e(Co, wh),
        e(Qt, Th),
        e(Qt, $o),
        e($o, Ph),
        e(Qt, Lh),
        e(Qt, So),
        e(So, kh),
        e(Qt, Dh),
        e(Qt, Vt),
        e(Vt, Fh),
        e(Qt, Oh),
        e(Qt, Ho),
        e(Ho, Ih),
        e(Qt, xh),
        e(Qt, Ro),
        e(Ro, Ah),
        e(Qt, Ch),
        e(Qt, Mo),
        e(Mo, $h),
        e(p, Sh),
        e(p, Ft),
        e(Ft, Bo),
        e(Bo, Hh),
        e(Ft, Rh),
        e(Ft, Pt),
        e(Pt, jo),
        e(Ft, Mh),
        e(Ft, Wo),
        e(Wo, Bh),
        e(Ft, jh),
        e(Ft, ir),
        e(ir, Wh),
        e(Ft, Uh),
        e(Ft, dr),
        e(dr, Nh),
        e(Ft, Gh),
        e(Ft, cr),
        e(cr, qh),
        e(Ft, Vh),
        e(Ft, hr),
        e(hr, Jh),
        e(Ft, Kh),
        e(Ft, ur),
        e(ur, zh),
        e(p, Xh),
        e(p, Ot),
        e(Ot, Uo),
        e(Uo, Qh),
        e(Ot, No),
        e(Ot, Go),
        e(Go, Yh),
        e(Ot, qo),
        e(Ot, Vo),
        e(Vo, Zh),
        e(Ot, eu),
        e(Ot, Jo),
        e(Jo, tu),
        e(Ot, Zn),
        e(Ot, Ko),
        e(Ko, au),
        e(Ot, nu),
        e(Ot, zo),
        e(zo, su),
        e(Ot, ru),
        e(Ot, Xo),
        e(Xo, lu),
        e(Ot, ou),
        e(Ot, Qo),
        e(Qo, es),
        e(p, iu),
        e(p, Yt),
        e(Yt, Yo),
        e(Yo, du),
        e(Yt, cu),
        e(Yt, wa),
        e(wa, hu),
        e(Yt, uu),
        e(Yt, Zo),
        e(Zo, fu),
        e(Yt, pu),
        e(Yt, fr),
        e(fr, mu),
        e(Yt, Bu),
        e(Yt, Eu),
        e(Eu, ju),
        e(Yt, Wu),
        e(Yt, wu),
        e(wu, Uu),
        e(Yt, Nu),
        e(Yt, Tu),
        e(Tu, Gu),
        e(Yt, qu),
        e(Yt, Pu),
        e(Pu, Vu),
        e(p, Ju),
        e(p, ma),
        e(ma, Lu),
        e(Lu, Ku),
        e(ma, zu),
        e(ma, ku),
        e(ku, Xu),
        e(ma, Qu),
        e(ma, Du),
        e(Du, Yu),
        e(ma, Zu),
        e(ma, Fu),
        e(Fu, ef),
        e(ma, tf),
        e(ma, Ou),
        e(Ou, af),
        e(ma, nf),
        e(ma, Iu),
        e(Iu, sf),
        e(ma, rf),
        e(ma, xu),
        e(xu, lf),
        e(ma, of),
        e(ma, Au),
        e(Au, df),
        e(d, cf),
        e(d, vu),
        e(vu, hf),
        e(d, uf),
        e(d, pr),
        e(pr, Cu),
        e(Cu, ff),
        e(pr, pf),
        e(pr, $u),
        e($u, mf),
        e(pr, vf),
        e(pr, Su),
        e(Su, gf),
        e(d, bf),
        e(d, gu),
        e(gu, yf),
        e(d, _f),
        e(d, bu),
        e(bu, Ef),
        e(d, wf),
        e(d, yu),
        e(yu, Tf);
    },
    p: Jt,
    i: Jt,
    o: Jt,
    d(Hu) {
      Hu && t(h);
    },
  };
}
class q1 extends zl {
  constructor(h) {
    super(), Xl(this, h, null, G1, Ql, {});
  }
}
function V1(x) {
  let h,
    d,
    u,
    w,
    N,
    b,
    le,
    Z,
    L,
    Le,
    ke,
    y,
    J,
    oe,
    k,
    ie,
    xe,
    A,
    K,
    de,
    C,
    ee,
    Ae,
    $,
    V,
    Q,
    S,
    P,
    te,
    G,
    ce,
    ae,
    T,
    ye,
    De,
    R,
    Y,
    Pe,
    he,
    _e,
    Ue,
    ue,
    j,
    fe,
    pe,
    Ce,
    Fe,
    me,
    ve,
    p,
    D,
    Ee,
    Ne,
    ge,
    H,
    W,
    F,
    He,
    z,
    ne,
    we,
    Je,
    v,
    O,
    Oe,
    X,
    I,
    Re,
    se,
    Ke,
    Me,
    re,
    ze,
    Ie,
    be,
    f,
    $e,
    q,
    Qe,
    Se,
    Be,
    qe,
    je,
    E,
    ut,
    at,
    Ye,
    ft,
    B,
    Ze,
    g,
    lt,
    pt,
    m,
    Lt,
    et,
    Ge,
    mt,
    kt,
    Dt,
    Te,
    It,
    xt,
    Zt,
    At,
    ia,
    ea,
    Ct,
    da,
    ta,
    $t,
    ca,
    ha,
    ra,
    ya,
    ua,
    la,
    _a,
    gt,
    St,
    Xa,
    Qa,
    oa,
    Ya,
    as,
    Ve,
    on;
  return {
    c() {
      (h = a("div")),
        (d = a("div")),
        (u = a("h1")),
        (w = r("OpenFPL Gameplay")),
        (N = o()),
        (b = a("p")),
        (le =
          r(`At OpenFPL, our gameplay rules are designed to create an immersive,
      engaging, and unique fantasy football experience. We understand the
      passion and strategy that goes into fantasy football, and our gameplay
      rules are crafted to reflect this, enhancing the fun and competitiveness
      of each gameweek.`)),
        (Z = o()),
        (L = a("h2")),
        (Le = r("Starting Funds and Team Composition")),
        (ke = o()),
        (y = a("p")),
        (J =
          r(`Each user begins their journey with £300m, a budget to strategically build
      their dream team. The value of players fluctuates based on community
      ratings within the DAO. If a player's performance garners enough votes,
      their value can either increase or decrease by £0.25m each gameweek.`)),
        (oe = o()),
        (k = a("p")),
        (ie =
          r(`In terms of team structure, each user's team consists of 11 players.
      Picking from a range of clubs is key, so a maximum of two players from any
      single club can be selected. Teams must adhere to a valid formation: 1
      goalkeeper, 3-5 defenders, 3-5 midfielders, and 1-3 strikers.`)),
        (xe = o()),
        (A = a("h2")),
        (K = r("Transfers and Team Management")),
        (de = o()),
        (C = a("p")),
        (ee =
          r(`Flexibility is a cornerstone of our gameplay. Users can make up to three
      transfers per week, allowing for dynamic team management and adaptation to
      the ever-changing football landscape. These transfers don't roll over,
      encouraging active participation each week. There are no substitutes in
      our game, eliminating the frustration of unused bench points.`)),
        (Ae = o()),
        ($ = a("p")),
        (V =
          r(`Each January, users can overhaul their team completely once, adding
      another strategic layer to the game reflecting the January transfer
      window.`)),
        (Q = o()),
        (S = a("h2")),
        (P = r("Scoring System")),
        (te = o()),
        (G = a("p")),
        (ce = r(
          "Our scoring system rewards players for key contributions on the field:"
        )),
        (ae = o()),
        (T = a("ul")),
        (ye = a("li")),
        (De = r("Appearing in the game: +5 points")),
        (R = o()),
        (Y = a("li")),
        (Pe = r("Every 3 saves a goalkeeper makes: +5 points")),
        (he = o()),
        (_e = a("li")),
        (Ue = r("Goalkeeper or defender cleansheet: +10 points")),
        (ue = o()),
        (j = a("li")),
        (fe = r("Forward scores a goal: +10 points")),
        (pe = o()),
        (Ce = a("li")),
        (Fe = r("Midfielder or Forward assists a goal: +10 points")),
        (me = o()),
        (ve = a("li")),
        (p = r("Midfielder scores a goal: +15 points")),
        (D = o()),
        (Ee = a("li")),
        (Ne = r("Goalkeeper or defender assists a goal: +15 points")),
        (ge = o()),
        (H = a("li")),
        (W = r("Goalkeeper or defender scores a goal: +20 points")),
        (F = o()),
        (He = a("li")),
        (z = r("Goalkeeper saves a penalty: +20 points")),
        (ne = o()),
        (we = a("li")),
        (Je = r("Player is highest scoring player in match: +25 points")),
        (v = o()),
        (O = a("p")),
        (Oe = r("Points are also deducted for the following on field events:")),
        (X = o()),
        (I = a("ul")),
        (Re = a("li")),
        (se = r("Player receives a red card: -20 points")),
        (Ke = o()),
        (Me = a("li")),
        (re = r("Player misses a penalty: -15 points")),
        (ze = o()),
        (Ie = a("li")),
        (be = r(
          "Each time a goalkeeper or defender concedes 2 goals: -15 points"
        )),
        (f = o()),
        ($e = a("li")),
        (q = r("A player scores an own goal: -10 points")),
        (Qe = o()),
        (Se = a("li")),
        (Be = r("A player receives a yellow card: -5 points")),
        (qe = o()),
        (je = a("h2")),
        (E = r("Bonuses")),
        (ut = o()),
        (at = a("p")),
        (Ye =
          r(`OpenFPL elevates the gameplay with a diverse set of bonuses. These bonuses
      play a pivotal role in keeping OpenFPL's gameplay both fresh and
      exhilarating. Their strategic implementation allows for significant shifts
      in the leaderboard, ensuring that the competition remains open and
      dynamic. With these bonuses, any user, regardless of their position, has
      the potential to make a substantial leap in the rankings. This
      unpredictability means that victory is within reach for every participant,
      fostering a thrilling environment where every gameweek holds the promise
      of a shake-up at the top of the leaderboard. Our bonuses are as follows:`)),
        (ft = o()),
        (B = a("ul")),
        (Ze = a("li")),
        (g = r(
          "Goal Getter: X3 multiplier for each goal scored by a selected player."
        )),
        (lt = o()),
        (pt = a("li")),
        (m = r(
          "Pass Master: X3 multiplier for each assist by a selected player."
        )),
        (Lt = o()),
        (et = a("li")),
        (Ge =
          r(`No Entry: X3 multiplier for a selected goalkeeper/defender for a clean
        sheet.`)),
        (mt = o()),
        (kt = a("li")),
        (Dt = r("Safe Hands: X3 multiplier for a goalkeeper making 5 saves.")),
        (Te = o()),
        (It = a("li")),
        (xt =
          r(`Captain Fantastic: X2 multiplier on the captain’s score for scoring a
        goal.`)),
        (Zt = o()),
        (At = a("li")),
        (ia = r(
          "Team Boost: X2 multiplier for all players from a single club."
        )),
        (ea = o()),
        (Ct = a("li")),
        (da = r("Brace Bonus: X2 multiplier for any player scoring 2+ goals.")),
        (ta = o()),
        ($t = a("li")),
        (ca = r(
          "Hat-Trick Hero: X3 multiplier for any player scoring 3+ goals."
        )),
        (ha = o()),
        (ra = a("li")),
        (ya = r(
          "Countrymen: Double points for players of a selected nationality."
        )),
        (ua = o()),
        (la = a("li")),
        (_a = r("Youth Prospects: Double points for players under 21.")),
        (gt = o()),
        (St = a("h2")),
        (Xa = r("Star Player")),
        (Qa = o()),
        (oa = a("p")),
        (Ya =
          r(`Each week a user can select a star player. This player will receive double
      points for the gameweek. If one is not set by the start of the gameweek it
      will automatically be set to the most valuable player in your team.`)),
        (as = o()),
        (Ve = a("p")),
        (on =
          r(`OpenFPL's gameplay combines strategic team management, a dynamic scoring
      system, and diverse bonuses, offering a unique and competitive fantasy
      football experience. Each decision impacts your journey through the
      Premier League season, where football knowledge and strategy lead to
      rewarding outcomes.`)),
        this.h();
    },
    l(dn) {
      h = n(dn, "DIV", { class: !0 });
      var Za = s(h);
      d = n(Za, "DIV", { class: !0 });
      var U = s(d);
      u = n(U, "H1", { class: !0 });
      var Rs = s(u);
      (w = l(Rs, "OpenFPL Gameplay")),
        Rs.forEach(t),
        (N = i(U)),
        (b = n(U, "P", { class: !0 }));
      var cn = s(b);
      (le = l(
        cn,
        `At OpenFPL, our gameplay rules are designed to create an immersive,
      engaging, and unique fantasy football experience. We understand the
      passion and strategy that goes into fantasy football, and our gameplay
      rules are crafted to reflect this, enhancing the fun and competitiveness
      of each gameweek.`
      )),
        cn.forEach(t),
        (Z = i(U)),
        (L = n(U, "H2", { class: !0 }));
      var mn = s(L);
      (Le = l(mn, "Starting Funds and Team Composition")),
        mn.forEach(t),
        (ke = i(U)),
        (y = n(U, "P", { class: !0 }));
      var Ms = s(y);
      (J = l(
        Ms,
        `Each user begins their journey with £300m, a budget to strategically build
      their dream team. The value of players fluctuates based on community
      ratings within the DAO. If a player's performance garners enough votes,
      their value can either increase or decrease by £0.25m each gameweek.`
      )),
        Ms.forEach(t),
        (oe = i(U)),
        (k = n(U, "P", { class: !0 }));
      var We = s(k);
      (ie = l(
        We,
        `In terms of team structure, each user's team consists of 11 players.
      Picking from a range of clubs is key, so a maximum of two players from any
      single club can be selected. Teams must adhere to a valid formation: 1
      goalkeeper, 3-5 defenders, 3-5 midfielders, and 1-3 strikers.`
      )),
        We.forEach(t),
        (xe = i(U)),
        (A = n(U, "H2", { class: !0 }));
      var tt = s(A);
      (K = l(tt, "Transfers and Team Management")),
        tt.forEach(t),
        (de = i(U)),
        (C = n(U, "P", { class: !0 }));
      var hn = s(C);
      (ee = l(
        hn,
        `Flexibility is a cornerstone of our gameplay. Users can make up to three
      transfers per week, allowing for dynamic team management and adaptation to
      the ever-changing football landscape. These transfers don't roll over,
      encouraging active participation each week. There are no substitutes in
      our game, eliminating the frustration of unused bench points.`
      )),
        hn.forEach(t),
        (Ae = i(U)),
        ($ = n(U, "P", { class: !0 }));
      var Bs = s($);
      (V = l(
        Bs,
        `Each January, users can overhaul their team completely once, adding
      another strategic layer to the game reflecting the January transfer
      window.`
      )),
        Bs.forEach(t),
        (Q = i(U)),
        (S = n(U, "H2", { class: !0 }));
      var vn = s(S);
      (P = l(vn, "Scoring System")),
        vn.forEach(t),
        (te = i(U)),
        (G = n(U, "P", { class: !0 }));
      var gn = s(G);
      (ce = l(
        gn,
        "Our scoring system rewards players for key contributions on the field:"
      )),
        gn.forEach(t),
        (ae = i(U)),
        (T = n(U, "UL", { class: !0 }));
      var ot = s(T);
      ye = n(ot, "LI", {});
      var bn = s(ye);
      (De = l(bn, "Appearing in the game: +5 points")),
        bn.forEach(t),
        (R = i(ot)),
        (Y = n(ot, "LI", {}));
      var yn = s(Y);
      (Pe = l(yn, "Every 3 saves a goalkeeper makes: +5 points")),
        yn.forEach(t),
        (he = i(ot)),
        (_e = n(ot, "LI", {}));
      var js = s(_e);
      (Ue = l(js, "Goalkeeper or defender cleansheet: +10 points")),
        js.forEach(t),
        (ue = i(ot)),
        (j = n(ot, "LI", {}));
      var _n = s(j);
      (fe = l(_n, "Forward scores a goal: +10 points")),
        _n.forEach(t),
        (pe = i(ot)),
        (Ce = n(ot, "LI", {}));
      var En = s(Ce);
      (Fe = l(En, "Midfielder or Forward assists a goal: +10 points")),
        En.forEach(t),
        (me = i(ot)),
        (ve = n(ot, "LI", {}));
      var Ws = s(ve);
      (p = l(Ws, "Midfielder scores a goal: +15 points")),
        Ws.forEach(t),
        (D = i(ot)),
        (Ee = n(ot, "LI", {}));
      var wn = s(Ee);
      (Ne = l(wn, "Goalkeeper or defender assists a goal: +15 points")),
        wn.forEach(t),
        (ge = i(ot)),
        (H = n(ot, "LI", {}));
      var Tn = s(H);
      (W = l(Tn, "Goalkeeper or defender scores a goal: +20 points")),
        Tn.forEach(t),
        (F = i(ot)),
        (He = n(ot, "LI", {}));
      var Us = s(He);
      (z = l(Us, "Goalkeeper saves a penalty: +20 points")),
        Us.forEach(t),
        (ne = i(ot)),
        (we = n(ot, "LI", {}));
      var vt = s(we);
      (Je = l(vt, "Player is highest scoring player in match: +25 points")),
        vt.forEach(t),
        ot.forEach(t),
        (v = i(U)),
        (O = n(U, "P", { class: !0 }));
      var en = s(O);
      (Oe = l(
        en,
        "Points are also deducted for the following on field events:"
      )),
        en.forEach(t),
        (X = i(U)),
        (I = n(U, "UL", { class: !0 }));
      var va = s(I);
      Re = n(va, "LI", {});
      var Ns = s(Re);
      (se = l(Ns, "Player receives a red card: -20 points")),
        Ns.forEach(t),
        (Ke = i(va)),
        (Me = n(va, "LI", {}));
      var tn = s(Me);
      (re = l(tn, "Player misses a penalty: -15 points")),
        tn.forEach(t),
        (ze = i(va)),
        (Ie = n(va, "LI", {}));
      var Gs = s(Ie);
      (be = l(
        Gs,
        "Each time a goalkeeper or defender concedes 2 goals: -15 points"
      )),
        Gs.forEach(t),
        (f = i(va)),
        ($e = n(va, "LI", {}));
      var qs = s($e);
      (q = l(qs, "A player scores an own goal: -10 points")),
        qs.forEach(t),
        (Qe = i(va)),
        (Se = n(va, "LI", {}));
      var an = s(Se);
      (Be = l(an, "A player receives a yellow card: -5 points")),
        an.forEach(t),
        va.forEach(t),
        (qe = i(U)),
        (je = n(U, "H2", { class: !0 }));
      var Vs = s(je);
      (E = l(Vs, "Bonuses")),
        Vs.forEach(t),
        (ut = i(U)),
        (at = n(U, "P", { class: !0 }));
      var Js = s(at);
      (Ye = l(
        Js,
        `OpenFPL elevates the gameplay with a diverse set of bonuses. These bonuses
      play a pivotal role in keeping OpenFPL's gameplay both fresh and
      exhilarating. Their strategic implementation allows for significant shifts
      in the leaderboard, ensuring that the competition remains open and
      dynamic. With these bonuses, any user, regardless of their position, has
      the potential to make a substantial leap in the rankings. This
      unpredictability means that victory is within reach for every participant,
      fostering a thrilling environment where every gameweek holds the promise
      of a shake-up at the top of the leaderboard. Our bonuses are as follows:`
      )),
        Js.forEach(t),
        (ft = i(U)),
        (B = n(U, "UL", { class: !0 }));
      var Xe = s(B);
      Ze = n(Xe, "LI", {});
      var Ks = s(Ze);
      (g = l(
        Ks,
        "Goal Getter: X3 multiplier for each goal scored by a selected player."
      )),
        Ks.forEach(t),
        (lt = i(Xe)),
        (pt = n(Xe, "LI", {}));
      var zs = s(pt);
      (m = l(
        zs,
        "Pass Master: X3 multiplier for each assist by a selected player."
      )),
        zs.forEach(t),
        (Lt = i(Xe)),
        (et = n(Xe, "LI", {}));
      var za = s(et);
      (Ge = l(
        za,
        `No Entry: X3 multiplier for a selected goalkeeper/defender for a clean
        sheet.`
      )),
        za.forEach(t),
        (mt = i(Xe)),
        (kt = n(Xe, "LI", {}));
      var un = s(kt);
      (Dt = l(
        un,
        "Safe Hands: X3 multiplier for a goalkeeper making 5 saves."
      )),
        un.forEach(t),
        (Te = i(Xe)),
        (It = n(Xe, "LI", {}));
      var ns = s(It);
      (xt = l(
        ns,
        `Captain Fantastic: X2 multiplier on the captain’s score for scoring a
        goal.`
      )),
        ns.forEach(t),
        (Zt = i(Xe)),
        (At = n(Xe, "LI", {}));
      var Pn = s(At);
      (ia = l(
        Pn,
        "Team Boost: X2 multiplier for all players from a single club."
      )),
        Pn.forEach(t),
        (ea = i(Xe)),
        (Ct = n(Xe, "LI", {}));
      var rt = s(Ct);
      (da = l(
        rt,
        "Brace Bonus: X2 multiplier for any player scoring 2+ goals."
      )),
        rt.forEach(t),
        (ta = i(Xe)),
        ($t = n(Xe, "LI", {}));
      var fn = s($t);
      (ca = l(
        fn,
        "Hat-Trick Hero: X3 multiplier for any player scoring 3+ goals."
      )),
        fn.forEach(t),
        (ha = i(Xe)),
        (ra = n(Xe, "LI", {}));
      var Ln = s(ra);
      (ya = l(
        Ln,
        "Countrymen: Double points for players of a selected nationality."
      )),
        Ln.forEach(t),
        (ua = i(Xe)),
        (la = n(Xe, "LI", {}));
      var Xs = s(la);
      (_a = l(Xs, "Youth Prospects: Double points for players under 21.")),
        Xs.forEach(t),
        Xe.forEach(t),
        (gt = i(U)),
        (St = n(U, "H2", { class: !0 }));
      var kn = s(St);
      (Xa = l(kn, "Star Player")),
        kn.forEach(t),
        (Qa = i(U)),
        (oa = n(U, "P", { class: !0 }));
      var Dn = s(oa);
      (Ya = l(
        Dn,
        `Each week a user can select a star player. This player will receive double
      points for the gameweek. If one is not set by the start of the gameweek it
      will automatically be set to the most valuable player in your team.`
      )),
        Dn.forEach(t),
        (as = i(U)),
        (Ve = n(U, "P", { class: !0 }));
      var Qs = s(Ve);
      (on = l(
        Qs,
        `OpenFPL's gameplay combines strategic team management, a dynamic scoring
      system, and diverse bonuses, offering a unique and competitive fantasy
      football experience. Each decision impacts your journey through the
      Premier League season, where football knowledge and strategy lead to
      rewarding outcomes.`
      )),
        Qs.forEach(t),
        U.forEach(t),
        Za.forEach(t),
        this.h();
    },
    h() {
      c(u, "class", "text-3xl font-bold"),
        c(b, "class", "my-4"),
        c(L, "class", "text-lg font-bold"),
        c(y, "class", "my-2"),
        c(k, "class", "my-2"),
        c(A, "class", "text-lg font-bold mt-4"),
        c(C, "class", "my-2"),
        c($, "class", "my-2"),
        c(S, "class", "text-lg font-bold mt-4"),
        c(G, "class", "my-2"),
        c(T, "class", "list-disc ml-4"),
        c(O, "class", "my-2"),
        c(I, "class", "list-disc ml-4"),
        c(je, "class", "text-lg font-bold mt-4"),
        c(at, "class", "my-2"),
        c(B, "class", "list-disc ml-4"),
        c(St, "class", "text-lg font-bold mt-4"),
        c(oa, "class", "my-2"),
        c(Ve, "class", "my-4"),
        c(d, "class", "m-4"),
        c(h, "class", "container-fluid mx-auto p-4");
    },
    m(dn, Za) {
      $s(dn, h, Za),
        e(h, d),
        e(d, u),
        e(u, w),
        e(d, N),
        e(d, b),
        e(b, le),
        e(d, Z),
        e(d, L),
        e(L, Le),
        e(d, ke),
        e(d, y),
        e(y, J),
        e(d, oe),
        e(d, k),
        e(k, ie),
        e(d, xe),
        e(d, A),
        e(A, K),
        e(d, de),
        e(d, C),
        e(C, ee),
        e(d, Ae),
        e(d, $),
        e($, V),
        e(d, Q),
        e(d, S),
        e(S, P),
        e(d, te),
        e(d, G),
        e(G, ce),
        e(d, ae),
        e(d, T),
        e(T, ye),
        e(ye, De),
        e(T, R),
        e(T, Y),
        e(Y, Pe),
        e(T, he),
        e(T, _e),
        e(_e, Ue),
        e(T, ue),
        e(T, j),
        e(j, fe),
        e(T, pe),
        e(T, Ce),
        e(Ce, Fe),
        e(T, me),
        e(T, ve),
        e(ve, p),
        e(T, D),
        e(T, Ee),
        e(Ee, Ne),
        e(T, ge),
        e(T, H),
        e(H, W),
        e(T, F),
        e(T, He),
        e(He, z),
        e(T, ne),
        e(T, we),
        e(we, Je),
        e(d, v),
        e(d, O),
        e(O, Oe),
        e(d, X),
        e(d, I),
        e(I, Re),
        e(Re, se),
        e(I, Ke),
        e(I, Me),
        e(Me, re),
        e(I, ze),
        e(I, Ie),
        e(Ie, be),
        e(I, f),
        e(I, $e),
        e($e, q),
        e(I, Qe),
        e(I, Se),
        e(Se, Be),
        e(d, qe),
        e(d, je),
        e(je, E),
        e(d, ut),
        e(d, at),
        e(at, Ye),
        e(d, ft),
        e(d, B),
        e(B, Ze),
        e(Ze, g),
        e(B, lt),
        e(B, pt),
        e(pt, m),
        e(B, Lt),
        e(B, et),
        e(et, Ge),
        e(B, mt),
        e(B, kt),
        e(kt, Dt),
        e(B, Te),
        e(B, It),
        e(It, xt),
        e(B, Zt),
        e(B, At),
        e(At, ia),
        e(B, ea),
        e(B, Ct),
        e(Ct, da),
        e(B, ta),
        e(B, $t),
        e($t, ca),
        e(B, ha),
        e(B, ra),
        e(ra, ya),
        e(B, ua),
        e(B, la),
        e(la, _a),
        e(d, gt),
        e(d, St),
        e(St, Xa),
        e(d, Qa),
        e(d, oa),
        e(oa, Ya),
        e(d, as),
        e(d, Ve),
        e(Ve, on);
    },
    p: Jt,
    i: Jt,
    o: Jt,
    d(dn) {
      dn && t(h);
    },
  };
}
class J1 extends zl {
  constructor(h) {
    super(), Xl(this, h, null, V1, Ql, {});
  }
}
function K1(x) {
  let h,
    d,
    u,
    w,
    N,
    b,
    le,
    Z,
    L,
    Le,
    ke,
    y,
    J,
    oe,
    k,
    ie,
    xe,
    A,
    K,
    de,
    C,
    ee,
    Ae,
    $,
    V,
    Q,
    S,
    P,
    te,
    G,
    ce,
    ae,
    T,
    ye,
    De,
    R,
    Y,
    Pe,
    he,
    _e,
    Ue,
    ue,
    j,
    fe,
    pe,
    Ce,
    Fe,
    me,
    ve,
    p,
    D,
    Ee,
    Ne,
    ge,
    H,
    W,
    F,
    He,
    z,
    ne,
    we,
    Je,
    v,
    O,
    Oe,
    X,
    I,
    Re,
    se,
    Ke,
    Me,
    re,
    ze;
  return {
    c() {
      (h = a("div")),
        (d = a("div")),
        (u = a("h1")),
        (w = r("Marketing")),
        (N = o()),
        (b = a("p")),
        (le =
          r(`We will be marketing both online and in-person, taking advantage of being
      based in the UK and having access to millions of Premier League fans.`)),
        (Z = o()),
        (L = a("h2")),
        (Le = r("Online Marketing Strategy")),
        (ke = o()),
        (y = a("h2")),
        (J = r("Collaboration with Digitial Marketing Agency")),
        (oe = o()),
        (k = a("p")),
        (ie =
          r(`We are engaging with a digital marketing agency known for their experience
      working with startups in the digital space. This agency is in the process
      of finalising plans for a comprehensive online marketing campaign. The
      campaign will focus on PPC (Pay-Per-Click) and SEO (Search Engine
      Optimisation) strategies, with an emphasis on reaching specific user
      groups effectively.`)),
        (xe = o()),
        (A = a("h2")),
        (K = r("Initial Strategy and Goals")),
        (de = o()),
        (C = a("p")),
        (ee =
          r(`We will have a particular focus on the UK market for initial traction.
      Tracking success through KPIs, focusing on manager sign-ups and event
      attendance.`)),
        (Ae = o()),
        ($ = a("h2")),
        (V = r("OpenFPL's Initiatives")),
        (Q = o()),
        (S = a("p")),
        (P =
          r(`Our approach is to seamlessly integrate OpenFPL's online marketing
      campaigns with our broader initiatives. A key focus will be on targeted
      local advertising, aiming to highlight the distribution of 200 junior
      football club kits to grassroots football causes across the UK.
      Additionally, we've created a return on investment (ROI) leaderboard for
      each of our NFT collections. This leaderboard will highlight and market
      the clubs that are the most active and supportive in our network. The aim
      is to boost purchases through the ICPFA shop.`)),
        (te = o()),
        (G = a("p")),
        (ce =
          r(`In November 2023, a proposal was passed in the OpenChat DAO for them to
      become the official sponsor of OpenFPL. They will appear on our pick team
      advertising boards along with the football apparel given to grassroots
      football causes and sold through the ICPFA shop. We feel this partnership
      is important as promoting the wide arrange of apps available on the IC
      ecosytem will increase the pace at which the world adopts Internet
      Computer services.`)),
        (ae = o()),
        (T = a("h2")),
        (ye = r("Future Considerations")),
        (De = o()),
        (R = a("p")),
        (Y =
          r(`Outside of traditional digital marketing we plan to explore additional
      areas, such as influencer marketing.`)),
        (Pe = o()),
        (he = a("h2")),
        (_e = r("In-Person Event Marketing Strategy")),
        (Ue = o()),
        (ue = a("p")),
        (j =
          r(`As part of our comprehensive marketing plan, OpenFPL is preparing to
      launch a series of in-person, interactive events in cities home to Premier
      League clubs. These events, expected to start from Q2 2024, are inspired
      by the successful engagement strategies of major UK brands like IBM, Ford
      and Coca-Cola.`)),
        (fe = o()),
        (pe = a("h2")),
        (Ce = r("Event Planning and Execution")),
        (Fe = o()),
        (me = a("p")),
        (ve =
          r(`We are in discussions with experienced interactive hardware providers and
      event management professionals to assist in creating immersive event
      experiences. We will utilise the expertise of OpenFPL founder, James
      Beadle, in developing and delivering these interactive experiences.`)),
        (p = o()),
        (D = a("h2")),
        (Ee = r("Event Objectives and Content")),
        (Ne = o()),
        (ge = a("p")),
        (H =
          r(`We would like to teach attendees about OpenFPL and the broader Internet
      Computer ecosystem, including Internet Identity and a variety of IC dApps.
      Facilitating hands-on interactions and demonstrations will provide a
      deeper understanding of OpenFPL's features and benefits.`)),
        (W = o()),
        (F = a("h2")),
        (He = r("Promotion and Community Engagement")),
        (z = o()),
        (ne = a("p")),
        (we =
          r(`We plan to promote these events through targeted local advertising, social
      media campaigns, and collaborations with local football clubs and
      communities. We will encouraging participants to share their experiences
      on social media through various reward scheme, amplifying our reach and
      impact.`)),
        (Je = o()),
        (v = a("h2")),
        (O = r("Long-Term Vision")),
        (Oe = o()),
        (X = a("p")),
        (I =
          r(`We will be exploring opportunities to replicate this event model in other
      regions, expanding OpenFPL's global footprint.`)),
        (Re = o()),
        (se = a("h2")),
        (Ke = r("Overall Approach")),
        (Me = o()),
        (re = a("p")),
        (ze =
          r(`The marketing plan aims to be dynamic, adapting to the evolving needs of
      OpenFPL and the response from the target audience. The digital agency and
      OpenFPL will work closely to ensure that the campaigns are coherent,
      data-driven, and aligned with OpenFPL’s overall branding and objectives.`)),
        this.h();
    },
    l(Ie) {
      h = n(Ie, "DIV", { class: !0 });
      var be = s(h);
      d = n(be, "DIV", { class: !0 });
      var f = s(d);
      u = n(f, "H1", { class: !0 });
      var $e = s(u);
      (w = l($e, "Marketing")),
        $e.forEach(t),
        (N = i(f)),
        (b = n(f, "P", { class: !0 }));
      var q = s(b);
      (le = l(
        q,
        `We will be marketing both online and in-person, taking advantage of being
      based in the UK and having access to millions of Premier League fans.`
      )),
        q.forEach(t),
        (Z = i(f)),
        (L = n(f, "H2", { class: !0 }));
      var Qe = s(L);
      (Le = l(Qe, "Online Marketing Strategy")),
        Qe.forEach(t),
        (ke = i(f)),
        (y = n(f, "H2", { class: !0 }));
      var Se = s(y);
      (J = l(Se, "Collaboration with Digitial Marketing Agency")),
        Se.forEach(t),
        (oe = i(f)),
        (k = n(f, "P", { class: !0 }));
      var Be = s(k);
      (ie = l(
        Be,
        `We are engaging with a digital marketing agency known for their experience
      working with startups in the digital space. This agency is in the process
      of finalising plans for a comprehensive online marketing campaign. The
      campaign will focus on PPC (Pay-Per-Click) and SEO (Search Engine
      Optimisation) strategies, with an emphasis on reaching specific user
      groups effectively.`
      )),
        Be.forEach(t),
        (xe = i(f)),
        (A = n(f, "H2", { class: !0 }));
      var qe = s(A);
      (K = l(qe, "Initial Strategy and Goals")),
        qe.forEach(t),
        (de = i(f)),
        (C = n(f, "P", { class: !0 }));
      var je = s(C);
      (ee = l(
        je,
        `We will have a particular focus on the UK market for initial traction.
      Tracking success through KPIs, focusing on manager sign-ups and event
      attendance.`
      )),
        je.forEach(t),
        (Ae = i(f)),
        ($ = n(f, "H2", { class: !0 }));
      var E = s($);
      (V = l(E, "OpenFPL's Initiatives")),
        E.forEach(t),
        (Q = i(f)),
        (S = n(f, "P", { class: !0 }));
      var ut = s(S);
      (P = l(
        ut,
        `Our approach is to seamlessly integrate OpenFPL's online marketing
      campaigns with our broader initiatives. A key focus will be on targeted
      local advertising, aiming to highlight the distribution of 200 junior
      football club kits to grassroots football causes across the UK.
      Additionally, we've created a return on investment (ROI) leaderboard for
      each of our NFT collections. This leaderboard will highlight and market
      the clubs that are the most active and supportive in our network. The aim
      is to boost purchases through the ICPFA shop.`
      )),
        ut.forEach(t),
        (te = i(f)),
        (G = n(f, "P", { class: !0 }));
      var at = s(G);
      (ce = l(
        at,
        `In November 2023, a proposal was passed in the OpenChat DAO for them to
      become the official sponsor of OpenFPL. They will appear on our pick team
      advertising boards along with the football apparel given to grassroots
      football causes and sold through the ICPFA shop. We feel this partnership
      is important as promoting the wide arrange of apps available on the IC
      ecosytem will increase the pace at which the world adopts Internet
      Computer services.`
      )),
        at.forEach(t),
        (ae = i(f)),
        (T = n(f, "H2", { class: !0 }));
      var Ye = s(T);
      (ye = l(Ye, "Future Considerations")),
        Ye.forEach(t),
        (De = i(f)),
        (R = n(f, "P", { class: !0 }));
      var ft = s(R);
      (Y = l(
        ft,
        `Outside of traditional digital marketing we plan to explore additional
      areas, such as influencer marketing.`
      )),
        ft.forEach(t),
        (Pe = i(f)),
        (he = n(f, "H2", { class: !0 }));
      var B = s(he);
      (_e = l(B, "In-Person Event Marketing Strategy")),
        B.forEach(t),
        (Ue = i(f)),
        (ue = n(f, "P", { class: !0 }));
      var Ze = s(ue);
      (j = l(
        Ze,
        `As part of our comprehensive marketing plan, OpenFPL is preparing to
      launch a series of in-person, interactive events in cities home to Premier
      League clubs. These events, expected to start from Q2 2024, are inspired
      by the successful engagement strategies of major UK brands like IBM, Ford
      and Coca-Cola.`
      )),
        Ze.forEach(t),
        (fe = i(f)),
        (pe = n(f, "H2", { class: !0 }));
      var g = s(pe);
      (Ce = l(g, "Event Planning and Execution")),
        g.forEach(t),
        (Fe = i(f)),
        (me = n(f, "P", { class: !0 }));
      var lt = s(me);
      (ve = l(
        lt,
        `We are in discussions with experienced interactive hardware providers and
      event management professionals to assist in creating immersive event
      experiences. We will utilise the expertise of OpenFPL founder, James
      Beadle, in developing and delivering these interactive experiences.`
      )),
        lt.forEach(t),
        (p = i(f)),
        (D = n(f, "H2", { class: !0 }));
      var pt = s(D);
      (Ee = l(pt, "Event Objectives and Content")),
        pt.forEach(t),
        (Ne = i(f)),
        (ge = n(f, "P", { class: !0 }));
      var m = s(ge);
      (H = l(
        m,
        `We would like to teach attendees about OpenFPL and the broader Internet
      Computer ecosystem, including Internet Identity and a variety of IC dApps.
      Facilitating hands-on interactions and demonstrations will provide a
      deeper understanding of OpenFPL's features and benefits.`
      )),
        m.forEach(t),
        (W = i(f)),
        (F = n(f, "H2", { class: !0 }));
      var Lt = s(F);
      (He = l(Lt, "Promotion and Community Engagement")),
        Lt.forEach(t),
        (z = i(f)),
        (ne = n(f, "P", { class: !0 }));
      var et = s(ne);
      (we = l(
        et,
        `We plan to promote these events through targeted local advertising, social
      media campaigns, and collaborations with local football clubs and
      communities. We will encouraging participants to share their experiences
      on social media through various reward scheme, amplifying our reach and
      impact.`
      )),
        et.forEach(t),
        (Je = i(f)),
        (v = n(f, "H2", { class: !0 }));
      var Ge = s(v);
      (O = l(Ge, "Long-Term Vision")),
        Ge.forEach(t),
        (Oe = i(f)),
        (X = n(f, "P", { class: !0 }));
      var mt = s(X);
      (I = l(
        mt,
        `We will be exploring opportunities to replicate this event model in other
      regions, expanding OpenFPL's global footprint.`
      )),
        mt.forEach(t),
        (Re = i(f)),
        (se = n(f, "H2", { class: !0 }));
      var kt = s(se);
      (Ke = l(kt, "Overall Approach")),
        kt.forEach(t),
        (Me = i(f)),
        (re = n(f, "P", { class: !0 }));
      var Dt = s(re);
      (ze = l(
        Dt,
        `The marketing plan aims to be dynamic, adapting to the evolving needs of
      OpenFPL and the response from the target audience. The digital agency and
      OpenFPL will work closely to ensure that the campaigns are coherent,
      data-driven, and aligned with OpenFPL’s overall branding and objectives.`
      )),
        Dt.forEach(t),
        f.forEach(t),
        be.forEach(t),
        this.h();
    },
    h() {
      c(u, "class", "text-3xl font-bold"),
        c(b, "class", "my-4"),
        c(L, "class", "text-xl font-bold mb-4"),
        c(y, "class", "text-lg font-bold"),
        c(k, "class", "my-2"),
        c(A, "class", "text-lg font-bold mt-4"),
        c(C, "class", "my-2"),
        c($, "class", "text-lg font-bold mt-4"),
        c(S, "class", "my-2"),
        c(G, "class", "my-2"),
        c(T, "class", "text-lg font-bold mt-4"),
        c(R, "class", "my-2"),
        c(he, "class", "text-xl font-bold"),
        c(ue, "class", "my-2"),
        c(pe, "class", "text-lg font-bold mt-4"),
        c(me, "class", "my-2"),
        c(D, "class", "text-lg font-bold mt-4"),
        c(ge, "class", "my-2"),
        c(F, "class", "text-lg font-bold mt-4"),
        c(ne, "class", "my-2"),
        c(v, "class", "text-lg font-bold mt-4"),
        c(X, "class", "my-2"),
        c(se, "class", "text-xl font-bold mt-4"),
        c(re, "class", "my-2"),
        c(d, "class", "m-4"),
        c(h, "class", "container-fluid mx-auto p-4");
    },
    m(Ie, be) {
      $s(Ie, h, be),
        e(h, d),
        e(d, u),
        e(u, w),
        e(d, N),
        e(d, b),
        e(b, le),
        e(d, Z),
        e(d, L),
        e(L, Le),
        e(d, ke),
        e(d, y),
        e(y, J),
        e(d, oe),
        e(d, k),
        e(k, ie),
        e(d, xe),
        e(d, A),
        e(A, K),
        e(d, de),
        e(d, C),
        e(C, ee),
        e(d, Ae),
        e(d, $),
        e($, V),
        e(d, Q),
        e(d, S),
        e(S, P),
        e(d, te),
        e(d, G),
        e(G, ce),
        e(d, ae),
        e(d, T),
        e(T, ye),
        e(d, De),
        e(d, R),
        e(R, Y),
        e(d, Pe),
        e(d, he),
        e(he, _e),
        e(d, Ue),
        e(d, ue),
        e(ue, j),
        e(d, fe),
        e(d, pe),
        e(pe, Ce),
        e(d, Fe),
        e(d, me),
        e(me, ve),
        e(d, p),
        e(d, D),
        e(D, Ee),
        e(d, Ne),
        e(d, ge),
        e(ge, H),
        e(d, W),
        e(d, F),
        e(F, He),
        e(d, z),
        e(d, ne),
        e(ne, we),
        e(d, Je),
        e(d, v),
        e(v, O),
        e(d, Oe),
        e(d, X),
        e(X, I),
        e(d, Re),
        e(d, se),
        e(se, Ke),
        e(d, Me),
        e(d, re),
        e(re, ze);
    },
    p: Jt,
    i: Jt,
    o: Jt,
    d(Ie) {
      Ie && t(h);
    },
  };
}
class z1 extends zl {
  constructor(h) {
    super(), Xl(this, h, null, K1, Ql, {});
  }
}
function X1(x) {
  let h,
    d,
    u,
    w,
    N,
    b,
    le,
    Z,
    L,
    Le,
    ke,
    y,
    J,
    oe,
    k,
    ie,
    xe,
    A,
    K,
    de,
    C,
    ee,
    Ae,
    $,
    V,
    Q,
    S,
    P,
    te,
    G,
    ce,
    ae,
    T,
    ye,
    De,
    R,
    Y,
    Pe,
    he,
    _e,
    Ue,
    ue,
    j,
    fe,
    pe,
    Ce,
    Fe,
    me,
    ve,
    p,
    D,
    Ee,
    Ne,
    ge,
    H,
    W,
    F,
    He,
    z,
    ne,
    we,
    Je,
    v,
    O,
    Oe,
    X,
    I,
    Re,
    se,
    Ke,
    Me,
    re,
    ze,
    Ie,
    be,
    f,
    $e,
    q,
    Qe,
    Se,
    Be,
    qe,
    je,
    E,
    ut,
    at,
    Ye,
    ft;
  return {
    c() {
      (h = a("div")),
        (d = a("div")),
        (u = a("h1")),
        (w = r("OpenFPL Revenue Streams")),
        (N = o()),
        (b = a("p")),
        (le =
          r(`OpenFPL's revenue model is thoughtfully designed to sustain and grow the
      DAO while ensuring practical utility and value for its users.`)),
        (Z = o()),
        (L = a("h2")),
        (Le = r("Diversified Revenue Model")),
        (ke = o()),
        (y = a("p")),
        (J =
          r(`To avoid creating a supply shock by pegging services to a fixed token
      amount, OpenFPL's revenue streams are diversified. This approach mitigates
      the risk of reduced service usage due to infeasibility, ensuring long-term
      stability and utility.`)),
        (oe = o()),
        (k = a("p")),
        (ie =
          r(`Revenue streams include Private Leagues, Site Sponsorship, Content
      Creators, Podcasts, and Merchandise. These channels provide a balanced mix
      of $FPL and $ICP revenue, enhancing the DAO's financial resilience.`)),
        (xe = o()),
        (A = a("h2")),
        (K = r("Private Leagues")),
        (de = o()),
        (C = a("p")),
        (ee =
          r(`Private league fees in OpenFPL are charged in ICP to establish a stable
      revenue base. This approach aligns the revenue directly with the number of
      managers, ensuring it scales with user engagement.`)),
        (Ae = o()),
        ($ = a("h2")),
        (V = r("Merchandise")),
        (Q = o()),
        (S = a("p")),
        (P = r("We have setup a shop at ")),
        (te = a("a")),
        (G = r("icpfa.org/shop")),
        (ce =
          r(` where you will be able to purchase OpenFPL merchandise in FPL or ICP. All
      profits after the promotion, marketing and production of this merchandise will
      be deposited into the DAO's treasury.`)),
        (ae = o()),
        (T = a("h2")),
        (ye = r("Podcasts")),
        (De = o()),
        (R = a("p")),
        (Y =
          r(`OpenFPL is expanding into podcasting with a main podcast and then various
      club-specific satellite podcasts. Initially hosted off-chain, our
      long-term goal is to transition these to on-chain hosting as services
      become available.`)),
        (Pe = o()),
        (he = a("p")),
        (_e =
          r(`The main podcast will cover general OpenFPL and football topics, while the
      satellite podcasts will target fans of specific clubs.`)),
        (Ue = o()),
        (ue = a("p")),
        (j =
          r(`Revenue will be generated from sponsorships and advertising. As our
      listener base grows, these podcasts are expected to become increasingly
      lucrative. All profits, after production costs, will be deposited into the
      DAO's treasury. Beyond revenue, these podcasts are a strategic move to
      bolster community engagement and enhance the OpenFPL brand, providing
      valuable content to our audience.`)),
        (fe = o()),
        (pe = a("h2")),
        (Ce = r("Site Sponsorship")),
        (Fe = o()),
        (me = a("p")),
        (ve =
          r(`Starting from August 2025, following the conclusion of the sponsorship
      deal with OpenChat, OpenFPL will offer the site sponsorship rights for
      bidding through the DAO. This will open opportunities for interested
      parties to become the named sponsor for an entire season.`)),
        (p = o()),
        (D = a("p")),
        (Ee =
          r(`Each year, sponsors can submit their bids to become the main site sponsor
      for the upcoming season, offering any ICRC-1 currency. Once a sponsor is
      selected, their exclusive rights will be secure for the entirety of that
      season. The DAO will not allow further proposals for site sponsorship
      until the subsequent preseason, ensuring the sponsor's exclusive
      visibility and association with OpenFPL.`)),
        (Ne = o()),
        (ge = a("p")),
        (H =
          r(`All sponsorship revenue will be directed into the DAO's treasury,
      contributing to the financial health and sustainability of OpenFPL.`)),
        (W = o()),
        (F = a("h2")),
        (He = r("Content Creators")),
        (z = o()),
        (ne = a("p")),
        (we =
          r(`OpenFPL will create a platform for content creators that is designed to
      both empower creators and enhance the utility of the FPL token. Creators
      will produce fantasy football-related content and share it on OpenFPL.
      This content will be available through a video reel format accessible to
      all users.`)),
        (Je = o()),
        (v = a("p")),
        (O =
          r(`For general reel content, creators earn from a pool of FPL tokens,
      allocated based on user likes. Creators can also offer exclusive content
      for subscribers. They will receive 95% of the FPL tokens from these
      subscriptions.`)),
        (Oe = o()),
        (X = a("p")),
        (I =
          r(`Subscriptions are purchased exclusively with FPL tokens, enhancing their
      utility. The remaining 5% from subscriptions remains in the DAO's
      treasury. This approach aligns with OpenFPL's commitment to supporting
      content creators, increasing FPL token utility, and rewarding its
      community of neuron holders.`)),
        (Re = o()),
        (se = a("h2")),
        (Ke = r("Revenue Redistribution Plan")),
        (Me = o()),
        (re = a("p")),
        (ze =
          r(`In line with our commitment to directly benefit neuron holders, OpenFPL
      will allocate 50% of any ICRC-1 token received by the DAO each month to
      neuron holders.`)),
        (Ie = o()),
        (be = a("p")),
        (f =
          r(`Distribution to neuron holders will be proportional to each neuron's total
      $FPL value and its remaining duration. This ensures a fair and equitable
      redistribution of revenue.`)),
        ($e = o()),
        (q = a("p")),
        (Qe =
          r(`Calculation for this distribution will be based on the status of FPL
      neurons as at the end of each month, aligning with the DAO's transparent
      and community-focused ethos.`)),
        (Se = o()),
        (Be = a("h2")),
        (qe = r("Overall Revenue Philosophy")),
        (je = o()),
        (E = a("p")),
        (ut =
          r(`OpenFPL’s revenue philosophy is rooted in creating a sustainable ecosystem
      where the utility token maintains its value and relevance.`)),
        (at = o()),
        (Ye = a("p")),
        (ft =
          r(`The reinvestment of revenues into the DAO and direct distribution to
      neuron holders are designed to foster a cycle of growth, user engagement,
      and shared prosperity.`)),
        this.h();
    },
    l(B) {
      h = n(B, "DIV", { class: !0 });
      var Ze = s(h);
      d = n(Ze, "DIV", { class: !0 });
      var g = s(d);
      u = n(g, "H1", { class: !0 });
      var lt = s(u);
      (w = l(lt, "OpenFPL Revenue Streams")),
        lt.forEach(t),
        (N = i(g)),
        (b = n(g, "P", { class: !0 }));
      var pt = s(b);
      (le = l(
        pt,
        `OpenFPL's revenue model is thoughtfully designed to sustain and grow the
      DAO while ensuring practical utility and value for its users.`
      )),
        pt.forEach(t),
        (Z = i(g)),
        (L = n(g, "H2", { class: !0 }));
      var m = s(L);
      (Le = l(m, "Diversified Revenue Model")),
        m.forEach(t),
        (ke = i(g)),
        (y = n(g, "P", { class: !0 }));
      var Lt = s(y);
      (J = l(
        Lt,
        `To avoid creating a supply shock by pegging services to a fixed token
      amount, OpenFPL's revenue streams are diversified. This approach mitigates
      the risk of reduced service usage due to infeasibility, ensuring long-term
      stability and utility.`
      )),
        Lt.forEach(t),
        (oe = i(g)),
        (k = n(g, "P", { class: !0 }));
      var et = s(k);
      (ie = l(
        et,
        `Revenue streams include Private Leagues, Site Sponsorship, Content
      Creators, Podcasts, and Merchandise. These channels provide a balanced mix
      of $FPL and $ICP revenue, enhancing the DAO's financial resilience.`
      )),
        et.forEach(t),
        (xe = i(g)),
        (A = n(g, "H2", { class: !0 }));
      var Ge = s(A);
      (K = l(Ge, "Private Leagues")),
        Ge.forEach(t),
        (de = i(g)),
        (C = n(g, "P", { class: !0 }));
      var mt = s(C);
      (ee = l(
        mt,
        `Private league fees in OpenFPL are charged in ICP to establish a stable
      revenue base. This approach aligns the revenue directly with the number of
      managers, ensuring it scales with user engagement.`
      )),
        mt.forEach(t),
        (Ae = i(g)),
        ($ = n(g, "H2", { class: !0 }));
      var kt = s($);
      (V = l(kt, "Merchandise")),
        kt.forEach(t),
        (Q = i(g)),
        (S = n(g, "P", { class: !0 }));
      var Dt = s(S);
      (P = l(Dt, "We have setup a shop at ")),
        (te = n(Dt, "A", { class: !0, href: !0 }));
      var Te = s(te);
      (G = l(Te, "icpfa.org/shop")),
        Te.forEach(t),
        (ce = l(
          Dt,
          ` where you will be able to purchase OpenFPL merchandise in FPL or ICP. All
      profits after the promotion, marketing and production of this merchandise will
      be deposited into the DAO's treasury.`
        )),
        Dt.forEach(t),
        (ae = i(g)),
        (T = n(g, "H2", { class: !0 }));
      var It = s(T);
      (ye = l(It, "Podcasts")),
        It.forEach(t),
        (De = i(g)),
        (R = n(g, "P", { class: !0 }));
      var xt = s(R);
      (Y = l(
        xt,
        `OpenFPL is expanding into podcasting with a main podcast and then various
      club-specific satellite podcasts. Initially hosted off-chain, our
      long-term goal is to transition these to on-chain hosting as services
      become available.`
      )),
        xt.forEach(t),
        (Pe = i(g)),
        (he = n(g, "P", { class: !0 }));
      var Zt = s(he);
      (_e = l(
        Zt,
        `The main podcast will cover general OpenFPL and football topics, while the
      satellite podcasts will target fans of specific clubs.`
      )),
        Zt.forEach(t),
        (Ue = i(g)),
        (ue = n(g, "P", { class: !0 }));
      var At = s(ue);
      (j = l(
        At,
        `Revenue will be generated from sponsorships and advertising. As our
      listener base grows, these podcasts are expected to become increasingly
      lucrative. All profits, after production costs, will be deposited into the
      DAO's treasury. Beyond revenue, these podcasts are a strategic move to
      bolster community engagement and enhance the OpenFPL brand, providing
      valuable content to our audience.`
      )),
        At.forEach(t),
        (fe = i(g)),
        (pe = n(g, "H2", { class: !0 }));
      var ia = s(pe);
      (Ce = l(ia, "Site Sponsorship")),
        ia.forEach(t),
        (Fe = i(g)),
        (me = n(g, "P", { class: !0 }));
      var ea = s(me);
      (ve = l(
        ea,
        `Starting from August 2025, following the conclusion of the sponsorship
      deal with OpenChat, OpenFPL will offer the site sponsorship rights for
      bidding through the DAO. This will open opportunities for interested
      parties to become the named sponsor for an entire season.`
      )),
        ea.forEach(t),
        (p = i(g)),
        (D = n(g, "P", { class: !0 }));
      var Ct = s(D);
      (Ee = l(
        Ct,
        `Each year, sponsors can submit their bids to become the main site sponsor
      for the upcoming season, offering any ICRC-1 currency. Once a sponsor is
      selected, their exclusive rights will be secure for the entirety of that
      season. The DAO will not allow further proposals for site sponsorship
      until the subsequent preseason, ensuring the sponsor's exclusive
      visibility and association with OpenFPL.`
      )),
        Ct.forEach(t),
        (Ne = i(g)),
        (ge = n(g, "P", { class: !0 }));
      var da = s(ge);
      (H = l(
        da,
        `All sponsorship revenue will be directed into the DAO's treasury,
      contributing to the financial health and sustainability of OpenFPL.`
      )),
        da.forEach(t),
        (W = i(g)),
        (F = n(g, "H2", { class: !0 }));
      var ta = s(F);
      (He = l(ta, "Content Creators")),
        ta.forEach(t),
        (z = i(g)),
        (ne = n(g, "P", { class: !0 }));
      var $t = s(ne);
      (we = l(
        $t,
        `OpenFPL will create a platform for content creators that is designed to
      both empower creators and enhance the utility of the FPL token. Creators
      will produce fantasy football-related content and share it on OpenFPL.
      This content will be available through a video reel format accessible to
      all users.`
      )),
        $t.forEach(t),
        (Je = i(g)),
        (v = n(g, "P", { class: !0 }));
      var ca = s(v);
      (O = l(
        ca,
        `For general reel content, creators earn from a pool of FPL tokens,
      allocated based on user likes. Creators can also offer exclusive content
      for subscribers. They will receive 95% of the FPL tokens from these
      subscriptions.`
      )),
        ca.forEach(t),
        (Oe = i(g)),
        (X = n(g, "P", { class: !0 }));
      var ha = s(X);
      (I = l(
        ha,
        `Subscriptions are purchased exclusively with FPL tokens, enhancing their
      utility. The remaining 5% from subscriptions remains in the DAO's
      treasury. This approach aligns with OpenFPL's commitment to supporting
      content creators, increasing FPL token utility, and rewarding its
      community of neuron holders.`
      )),
        ha.forEach(t),
        (Re = i(g)),
        (se = n(g, "H2", { class: !0 }));
      var ra = s(se);
      (Ke = l(ra, "Revenue Redistribution Plan")),
        ra.forEach(t),
        (Me = i(g)),
        (re = n(g, "P", { class: !0 }));
      var ya = s(re);
      (ze = l(
        ya,
        `In line with our commitment to directly benefit neuron holders, OpenFPL
      will allocate 50% of any ICRC-1 token received by the DAO each month to
      neuron holders.`
      )),
        ya.forEach(t),
        (Ie = i(g)),
        (be = n(g, "P", { class: !0 }));
      var ua = s(be);
      (f = l(
        ua,
        `Distribution to neuron holders will be proportional to each neuron's total
      $FPL value and its remaining duration. This ensures a fair and equitable
      redistribution of revenue.`
      )),
        ua.forEach(t),
        ($e = i(g)),
        (q = n(g, "P", { class: !0 }));
      var la = s(q);
      (Qe = l(
        la,
        `Calculation for this distribution will be based on the status of FPL
      neurons as at the end of each month, aligning with the DAO's transparent
      and community-focused ethos.`
      )),
        la.forEach(t),
        (Se = i(g)),
        (Be = n(g, "H2", { class: !0 }));
      var _a = s(Be);
      (qe = l(_a, "Overall Revenue Philosophy")),
        _a.forEach(t),
        (je = i(g)),
        (E = n(g, "P", { class: !0 }));
      var gt = s(E);
      (ut = l(
        gt,
        `OpenFPL’s revenue philosophy is rooted in creating a sustainable ecosystem
      where the utility token maintains its value and relevance.`
      )),
        gt.forEach(t),
        (at = i(g)),
        (Ye = n(g, "P", { class: !0 }));
      var St = s(Ye);
      (ft = l(
        St,
        `The reinvestment of revenues into the DAO and direct distribution to
      neuron holders are designed to foster a cycle of growth, user engagement,
      and shared prosperity.`
      )),
        St.forEach(t),
        g.forEach(t),
        Ze.forEach(t),
        this.h();
    },
    h() {
      c(u, "class", "text-3xl font-bold"),
        c(b, "class", "my-4"),
        c(L, "class", "text-lg font-bold"),
        c(y, "class", "my-2"),
        c(k, "class", "my-2"),
        c(A, "class", "text-lg font-bold mt-4"),
        c(C, "class", "my-2"),
        c($, "class", "text-lg font-bold mt-4"),
        c(te, "class", "text-blue-500"),
        c(te, "href", "https://icpga.org/shop"),
        c(S, "class", "my-2"),
        c(T, "class", "text-xl font-bold"),
        c(R, "class", "my-2"),
        c(he, "class", "my-2"),
        c(ue, "class", "my-2"),
        c(pe, "class", "text-lg font-bold mt-4"),
        c(me, "class", "my-2"),
        c(D, "class", "my-2"),
        c(ge, "class", "my-2"),
        c(F, "class", "text-lg font-bold mt-4"),
        c(ne, "class", "my-2"),
        c(v, "class", "my-2"),
        c(X, "class", "my-2"),
        c(se, "class", "text-lg font-bold mt-4"),
        c(re, "class", "my-2"),
        c(be, "class", "my-2"),
        c(q, "class", "my-2"),
        c(Be, "class", "text-xl font-bold mt-4"),
        c(E, "class", "my-2"),
        c(Ye, "class", "my-2"),
        c(d, "class", "m-4"),
        c(h, "class", "container-fluid mx-auto p-4");
    },
    m(B, Ze) {
      $s(B, h, Ze),
        e(h, d),
        e(d, u),
        e(u, w),
        e(d, N),
        e(d, b),
        e(b, le),
        e(d, Z),
        e(d, L),
        e(L, Le),
        e(d, ke),
        e(d, y),
        e(y, J),
        e(d, oe),
        e(d, k),
        e(k, ie),
        e(d, xe),
        e(d, A),
        e(A, K),
        e(d, de),
        e(d, C),
        e(C, ee),
        e(d, Ae),
        e(d, $),
        e($, V),
        e(d, Q),
        e(d, S),
        e(S, P),
        e(S, te),
        e(te, G),
        e(S, ce),
        e(d, ae),
        e(d, T),
        e(T, ye),
        e(d, De),
        e(d, R),
        e(R, Y),
        e(d, Pe),
        e(d, he),
        e(he, _e),
        e(d, Ue),
        e(d, ue),
        e(ue, j),
        e(d, fe),
        e(d, pe),
        e(pe, Ce),
        e(d, Fe),
        e(d, me),
        e(me, ve),
        e(d, p),
        e(d, D),
        e(D, Ee),
        e(d, Ne),
        e(d, ge),
        e(ge, H),
        e(d, W),
        e(d, F),
        e(F, He),
        e(d, z),
        e(d, ne),
        e(ne, we),
        e(d, Je),
        e(d, v),
        e(v, O),
        e(d, Oe),
        e(d, X),
        e(X, I),
        e(d, Re),
        e(d, se),
        e(se, Ke),
        e(d, Me),
        e(d, re),
        e(re, ze),
        e(d, Ie),
        e(d, be),
        e(be, f),
        e(d, $e),
        e(d, q),
        e(q, Qe),
        e(d, Se),
        e(d, Be),
        e(Be, qe),
        e(d, je),
        e(d, E),
        e(E, ut),
        e(d, at),
        e(d, Ye),
        e(Ye, ft);
    },
    p: Jt,
    i: Jt,
    o: Jt,
    d(B) {
      B && t(h);
    },
  };
}
class Q1 extends zl {
  constructor(h) {
    super(), Xl(this, h, null, X1, Ql, {});
  }
}
function Y1(x) {
  let h,
    d,
    u,
    w,
    N,
    b,
    le,
    Z,
    L,
    Le,
    ke,
    y,
    J,
    oe,
    k,
    ie,
    xe,
    A,
    K,
    de,
    C,
    ee,
    Ae,
    $,
    V,
    Q,
    S,
    P,
    te,
    G,
    ce,
    ae,
    T,
    ye,
    De,
    R,
    Y,
    Pe,
    he,
    _e,
    Ue,
    ue,
    j,
    fe,
    pe,
    Ce,
    Fe,
    me,
    ve,
    p,
    D,
    Ee,
    Ne,
    ge,
    H,
    W,
    F,
    He,
    z,
    ne,
    we,
    Je,
    v,
    O,
    Oe,
    X,
    I,
    Re,
    se,
    Ke,
    Me,
    re,
    ze,
    Ie,
    be,
    f,
    $e,
    q,
    Qe,
    Se,
    Be,
    qe,
    je,
    E,
    ut,
    at,
    Ye,
    ft,
    B,
    Ze,
    g;
  return {
    c() {
      (h = a("div")),
        (d = a("div")),
        (u = a("h1")),
        (w = r("Roadmap")),
        (N = o()),
        (b = a("p")),
        (le = r("We have an ambitious roadmap of features we aim to release:")),
        (Z = o()),
        (L = a("h2")),
        (Le = r("November 2023: Investment NFTs Launch")),
        (ke = o()),
        (y = a("p")),
        (J =
          r(`We will be launching 2 NFT collections in November 2024 to give the
      opportunity for users to share in OpenFPL merchandise and podcast revenue.
      These NFTs will be used to fund the production of OpenFPL merchandise
      along with promotion of the OpenFPL platform in the run up to the genesis
      season. Further information can be found in the marketing section of this
      whitepaper.`)),
        (oe = o()),
        (k = a("h2")),
        (ie = r("December 2023: Svelte Frontend Upgrade")),
        (xe = o()),
        (A = a("p")),
        (K =
          r(`We're aligning OpenFPL with flagship IC apps like the NNS, OpenChat & Juno
      by adopting Svelte. This upgrade ensures a consistent user experience and
      leverages Svelte’s server-side rendering for faster load times.`)),
        (de = o()),
        (C = a("h2")),
        (ee = r("Jan - Feb 2024: SNS Testflight Testing")),
        (Ae = o()),
        ($ = a("p")),
        (V =
          r(`We will perform comprehensive testing of the OpenFPL gameplay and
      governance features. Detailed descriptions and outcomes of various use
      case tests, demonstrating how gameplay and governance features perform in
      different situations.`)),
        (Q = o()),
        (S = a("h2")),
        (P = r("January 2024: 'The OpenFPL Podcast' Launch")),
        (te = o()),
        (G = a("p")),
        (ce =
          r(`Starting with a main podcast, we aim to expand into fan-focused podcasts,
      emulating the model of successful platforms like Arsenal Fan TV. Initially
      audio-based, these podcasts will eventually include video content, adding
      another dimension to our engagement strategy.`)),
        (ae = o()),
        (T = a("h2")),
        (ye = r("January 2024: Shirt Production Begins")),
        (De = o()),
        (R = a("p")),
        (Y =
          r(`We are actively engaged in shirt production for OpenFPL, moving beyond
      mere concepts to tangible products. Our collaboration with a UK supplier
      is set to kit out 200 junior clubs with OpenFPL-branded shirts for
      charity, marking our first foray into merging style with the spirit of the
      game. This initiative is further elevated by a successful partnership with
      OpenChat. A recent proposal in the OpenChat DAO has been passed, resulting
      in OpenChat sponsoring half of these shirts, a testament to our
      collaborative efforts and shared vision. Concurrently, we are in advanced
      talks with a manufacturer in India, having already developed a promising
      prototype. We are fine-tuning the details to perfect the shirts, with
      production anticipated to commence in just a few months. Additionally,
      these shirts will be available for sale in the ICPFA shop, with a portion
      of each sale benefiting our NFT holders. This dual approach not only
      strengthens our brand presence but also underscores our commitment to
      supporting grassroots football communities and providing value to our NFT
      investors.`)),
        (Pe = o()),
        (he = a("h2")),
        (_e = r("February 2024: Online Marketing Campaigns")),
        (Ue = o()),
        (ue = a("p")),
        (j =
          r(`We are actively in discussions with a digital marketing agency, preparing
      to launch campaigns aimed at organically growing our base of genuine
      managers. The strategy being formulated focuses on SEO and PPC methods
      aligned with OpenFPL's objectives. These deliberations include choosing
      the most suitable online platforms and crafting a strategy that resonates
      with our ethos. The direction of these campaigns is geared towards
      measurable outcomes, especially in attracting genuine manager sign-ups and
      naturally expanding our online footprint. This approach is designed to
      cultivate a genuine and engaged community, enhancing OpenFPL's presence in
      a manner that's both authentic and impactful.`)),
        (fe = o()),
        (pe = a("h2")),
        (Ce = r("March 1st 2024: OpenFPL SNS Decentralisation Sale")),
        (Fe = o()),
        (me = a("p")),
        (ve =
          r(`We aim to begin our decentralisation sale on 1st March 2024, selling 25
      million $FPL tokens (25%).`)),
        (p = o()),
        (D = a("h2")),
        (Ee = r("April 2024: Private Leagues")),
        (Ne = o()),
        (ge = a("p")),
        (H =
          r(`The Private Leagues feature is the start of building your own OpenFPL
      community within the DAO. Managers will be able to create a Private League
      for a fee of 1 $ICP. Managers will have full control over their rewards
      structure, with features such as: Deciding on the entry fee, if any. Any
      entry fee can be in $FPL, $ICP or ckBTC. Deciding on the rewards structure
      currency, amount and percentage payouts per finishing position.`)),
        (W = o()),
        (F = a("h2")),
        (He = r("April 2024: OpenFPL Events")),
        (z = o()),
        (ne = a("p")),
        (we =
          r(`OpenFPL is set to create a series of interactive experiences at event
      locations in Premier League club cities, drawing inspiration from major UK
      brands like IBM, Ford and Coca-Cola. Planned from Q2 2024 onwards, these
      events will leverage the expertise of OpenFPL founder James Beadle. With
      his experience in creating successful and engaging interactive
      experiences, James aims to play a key role in educating attendees about
      OpenFPL, Internet Identity and the range of other IC dApps available.`)),
        (Je = o()),
        (v = a("h2")),
        (O = r("July 2024: Mobile App Launch")),
        (Oe = o()),
        (X = a("p")),
        (I =
          r(`We will release a mobile app shortly before the genesis season begins to
      make OpenFPL more accessible and convenient for users on the go.`)),
        (Re = o()),
        (se = a("h2")),
        (Ke = r("August 2024: OpenFPL Genesis Season Begins")),
        (Me = o()),
        (re = a("p")),
        (ze =
          r(`In August 2024, we launch our inaugural season, where fantasy teams start
      competing for $FPL rewards on a weekly, monthly and annual basis to
      maximise user engagment.`)),
        (Ie = o()),
        (be = a("h2")),
        (f = r("November 2024: Content Subscription Launch")),
        ($e = o()),
        (q = a("p")),
        (Qe =
          r(`Partnering with Premier League content creators to offer exclusive
      insights, with a unique monetization model for both free and
      subscription-based content.`)),
        (Se = o()),
        (Be = a("h2")),
        (qe = r("March 2025: OpenChat Integration")),
        (je = o()),
        (E = a("p")),
        (ut =
          r(`Integrating OpenChat for seamless communication within the OpenFPL
      community, providing updates and increasing engagement through group
      channels.`)),
        (at = o()),
        (Ye = a("h2")),
        (ft = r("Future: 100% On-Chain AI")),
        (B = o()),
        (Ze = a("p")),
        (g =
          r(`At OpenFPL, we are exploring the deployment of a 100% on-chain AI model
      within a dedicated canister. Our initial use case for this AI would be to
      integrate a feature within the team selection interface, allowing users to
      receive AI-recommended changes. Users will then have the option to review
      and decide whether to implement these AI suggestions in their team
      management decisions. However, given that the Internet Computer's
      infrastructure is still evolving, especially in terms of on-chain training
      capabilities, our immediate strategy involves training the model
      off-chain. As the IC infrastructure evolves we would look to transition to
      real-time, continual learning for the AI model directly on the IC. Looking
      ahead, we're excited about the potential to develop new models using our
      constantly expanding on-chain dataset, opening up more innovative
      possibilities for OpenFPL.`)),
        this.h();
    },
    l(lt) {
      h = n(lt, "DIV", { class: !0 });
      var pt = s(h);
      d = n(pt, "DIV", { class: !0 });
      var m = s(d);
      u = n(m, "H1", { class: !0 });
      var Lt = s(u);
      (w = l(Lt, "Roadmap")),
        Lt.forEach(t),
        (N = i(m)),
        (b = n(m, "P", { class: !0 }));
      var et = s(b);
      (le = l(
        et,
        "We have an ambitious roadmap of features we aim to release:"
      )),
        et.forEach(t),
        (Z = i(m)),
        (L = n(m, "H2", { class: !0 }));
      var Ge = s(L);
      (Le = l(Ge, "November 2023: Investment NFTs Launch")),
        Ge.forEach(t),
        (ke = i(m)),
        (y = n(m, "P", { class: !0 }));
      var mt = s(y);
      (J = l(
        mt,
        `We will be launching 2 NFT collections in November 2024 to give the
      opportunity for users to share in OpenFPL merchandise and podcast revenue.
      These NFTs will be used to fund the production of OpenFPL merchandise
      along with promotion of the OpenFPL platform in the run up to the genesis
      season. Further information can be found in the marketing section of this
      whitepaper.`
      )),
        mt.forEach(t),
        (oe = i(m)),
        (k = n(m, "H2", { class: !0 }));
      var kt = s(k);
      (ie = l(kt, "December 2023: Svelte Frontend Upgrade")),
        kt.forEach(t),
        (xe = i(m)),
        (A = n(m, "P", { class: !0 }));
      var Dt = s(A);
      (K = l(
        Dt,
        `We're aligning OpenFPL with flagship IC apps like the NNS, OpenChat & Juno
      by adopting Svelte. This upgrade ensures a consistent user experience and
      leverages Svelte’s server-side rendering for faster load times.`
      )),
        Dt.forEach(t),
        (de = i(m)),
        (C = n(m, "H2", { class: !0 }));
      var Te = s(C);
      (ee = l(Te, "Jan - Feb 2024: SNS Testflight Testing")),
        Te.forEach(t),
        (Ae = i(m)),
        ($ = n(m, "P", { class: !0 }));
      var It = s($);
      (V = l(
        It,
        `We will perform comprehensive testing of the OpenFPL gameplay and
      governance features. Detailed descriptions and outcomes of various use
      case tests, demonstrating how gameplay and governance features perform in
      different situations.`
      )),
        It.forEach(t),
        (Q = i(m)),
        (S = n(m, "H2", { class: !0 }));
      var xt = s(S);
      (P = l(xt, "January 2024: 'The OpenFPL Podcast' Launch")),
        xt.forEach(t),
        (te = i(m)),
        (G = n(m, "P", { class: !0 }));
      var Zt = s(G);
      (ce = l(
        Zt,
        `Starting with a main podcast, we aim to expand into fan-focused podcasts,
      emulating the model of successful platforms like Arsenal Fan TV. Initially
      audio-based, these podcasts will eventually include video content, adding
      another dimension to our engagement strategy.`
      )),
        Zt.forEach(t),
        (ae = i(m)),
        (T = n(m, "H2", { class: !0 }));
      var At = s(T);
      (ye = l(At, "January 2024: Shirt Production Begins")),
        At.forEach(t),
        (De = i(m)),
        (R = n(m, "P", { class: !0 }));
      var ia = s(R);
      (Y = l(
        ia,
        `We are actively engaged in shirt production for OpenFPL, moving beyond
      mere concepts to tangible products. Our collaboration with a UK supplier
      is set to kit out 200 junior clubs with OpenFPL-branded shirts for
      charity, marking our first foray into merging style with the spirit of the
      game. This initiative is further elevated by a successful partnership with
      OpenChat. A recent proposal in the OpenChat DAO has been passed, resulting
      in OpenChat sponsoring half of these shirts, a testament to our
      collaborative efforts and shared vision. Concurrently, we are in advanced
      talks with a manufacturer in India, having already developed a promising
      prototype. We are fine-tuning the details to perfect the shirts, with
      production anticipated to commence in just a few months. Additionally,
      these shirts will be available for sale in the ICPFA shop, with a portion
      of each sale benefiting our NFT holders. This dual approach not only
      strengthens our brand presence but also underscores our commitment to
      supporting grassroots football communities and providing value to our NFT
      investors.`
      )),
        ia.forEach(t),
        (Pe = i(m)),
        (he = n(m, "H2", { class: !0 }));
      var ea = s(he);
      (_e = l(ea, "February 2024: Online Marketing Campaigns")),
        ea.forEach(t),
        (Ue = i(m)),
        (ue = n(m, "P", { class: !0 }));
      var Ct = s(ue);
      (j = l(
        Ct,
        `We are actively in discussions with a digital marketing agency, preparing
      to launch campaigns aimed at organically growing our base of genuine
      managers. The strategy being formulated focuses on SEO and PPC methods
      aligned with OpenFPL's objectives. These deliberations include choosing
      the most suitable online platforms and crafting a strategy that resonates
      with our ethos. The direction of these campaigns is geared towards
      measurable outcomes, especially in attracting genuine manager sign-ups and
      naturally expanding our online footprint. This approach is designed to
      cultivate a genuine and engaged community, enhancing OpenFPL's presence in
      a manner that's both authentic and impactful.`
      )),
        Ct.forEach(t),
        (fe = i(m)),
        (pe = n(m, "H2", { class: !0 }));
      var da = s(pe);
      (Ce = l(da, "March 1st 2024: OpenFPL SNS Decentralisation Sale")),
        da.forEach(t),
        (Fe = i(m)),
        (me = n(m, "P", { class: !0 }));
      var ta = s(me);
      (ve = l(
        ta,
        `We aim to begin our decentralisation sale on 1st March 2024, selling 25
      million $FPL tokens (25%).`
      )),
        ta.forEach(t),
        (p = i(m)),
        (D = n(m, "H2", { class: !0 }));
      var $t = s(D);
      (Ee = l($t, "April 2024: Private Leagues")),
        $t.forEach(t),
        (Ne = i(m)),
        (ge = n(m, "P", { class: !0 }));
      var ca = s(ge);
      (H = l(
        ca,
        `The Private Leagues feature is the start of building your own OpenFPL
      community within the DAO. Managers will be able to create a Private League
      for a fee of 1 $ICP. Managers will have full control over their rewards
      structure, with features such as: Deciding on the entry fee, if any. Any
      entry fee can be in $FPL, $ICP or ckBTC. Deciding on the rewards structure
      currency, amount and percentage payouts per finishing position.`
      )),
        ca.forEach(t),
        (W = i(m)),
        (F = n(m, "H2", { class: !0 }));
      var ha = s(F);
      (He = l(ha, "April 2024: OpenFPL Events")),
        ha.forEach(t),
        (z = i(m)),
        (ne = n(m, "P", { class: !0 }));
      var ra = s(ne);
      (we = l(
        ra,
        `OpenFPL is set to create a series of interactive experiences at event
      locations in Premier League club cities, drawing inspiration from major UK
      brands like IBM, Ford and Coca-Cola. Planned from Q2 2024 onwards, these
      events will leverage the expertise of OpenFPL founder James Beadle. With
      his experience in creating successful and engaging interactive
      experiences, James aims to play a key role in educating attendees about
      OpenFPL, Internet Identity and the range of other IC dApps available.`
      )),
        ra.forEach(t),
        (Je = i(m)),
        (v = n(m, "H2", { class: !0 }));
      var ya = s(v);
      (O = l(ya, "July 2024: Mobile App Launch")),
        ya.forEach(t),
        (Oe = i(m)),
        (X = n(m, "P", { class: !0 }));
      var ua = s(X);
      (I = l(
        ua,
        `We will release a mobile app shortly before the genesis season begins to
      make OpenFPL more accessible and convenient for users on the go.`
      )),
        ua.forEach(t),
        (Re = i(m)),
        (se = n(m, "H2", { class: !0 }));
      var la = s(se);
      (Ke = l(la, "August 2024: OpenFPL Genesis Season Begins")),
        la.forEach(t),
        (Me = i(m)),
        (re = n(m, "P", { class: !0 }));
      var _a = s(re);
      (ze = l(
        _a,
        `In August 2024, we launch our inaugural season, where fantasy teams start
      competing for $FPL rewards on a weekly, monthly and annual basis to
      maximise user engagment.`
      )),
        _a.forEach(t),
        (Ie = i(m)),
        (be = n(m, "H2", { class: !0 }));
      var gt = s(be);
      (f = l(gt, "November 2024: Content Subscription Launch")),
        gt.forEach(t),
        ($e = i(m)),
        (q = n(m, "P", { class: !0 }));
      var St = s(q);
      (Qe = l(
        St,
        `Partnering with Premier League content creators to offer exclusive
      insights, with a unique monetization model for both free and
      subscription-based content.`
      )),
        St.forEach(t),
        (Se = i(m)),
        (Be = n(m, "H2", { class: !0 }));
      var Xa = s(Be);
      (qe = l(Xa, "March 2025: OpenChat Integration")),
        Xa.forEach(t),
        (je = i(m)),
        (E = n(m, "P", { class: !0 }));
      var Qa = s(E);
      (ut = l(
        Qa,
        `Integrating OpenChat for seamless communication within the OpenFPL
      community, providing updates and increasing engagement through group
      channels.`
      )),
        Qa.forEach(t),
        (at = i(m)),
        (Ye = n(m, "H2", { class: !0 }));
      var oa = s(Ye);
      (ft = l(oa, "Future: 100% On-Chain AI")),
        oa.forEach(t),
        (B = i(m)),
        (Ze = n(m, "P", { class: !0 }));
      var Ya = s(Ze);
      (g = l(
        Ya,
        `At OpenFPL, we are exploring the deployment of a 100% on-chain AI model
      within a dedicated canister. Our initial use case for this AI would be to
      integrate a feature within the team selection interface, allowing users to
      receive AI-recommended changes. Users will then have the option to review
      and decide whether to implement these AI suggestions in their team
      management decisions. However, given that the Internet Computer's
      infrastructure is still evolving, especially in terms of on-chain training
      capabilities, our immediate strategy involves training the model
      off-chain. As the IC infrastructure evolves we would look to transition to
      real-time, continual learning for the AI model directly on the IC. Looking
      ahead, we're excited about the potential to develop new models using our
      constantly expanding on-chain dataset, opening up more innovative
      possibilities for OpenFPL.`
      )),
        Ya.forEach(t),
        m.forEach(t),
        pt.forEach(t),
        this.h();
    },
    h() {
      c(u, "class", "text-3xl font-bold"),
        c(b, "class", "my-4"),
        c(L, "class", "text-lg font-bold"),
        c(y, "class", "my-2"),
        c(k, "class", "text-lg font-bold mt-4"),
        c(A, "class", "my-2"),
        c(C, "class", "text-lg font-bold mt-4"),
        c($, "class", "my-2"),
        c(S, "class", "text-lg font-bold mt-4"),
        c(G, "class", "my-2"),
        c(T, "class", "text-lg font-bold mt-4"),
        c(R, "class", "my-2"),
        c(he, "class", "text-lg font-bold mt-4"),
        c(ue, "class", "my-2"),
        c(pe, "class", "text-lg font-bold mt-4"),
        c(me, "class", "my-2"),
        c(D, "class", "text-lg font-bold mt-4"),
        c(ge, "class", "my-2"),
        c(F, "class", "text-lg font-bold mt-4"),
        c(ne, "class", "my-2"),
        c(v, "class", "text-lg font-bold mt-4"),
        c(X, "class", "my-2"),
        c(se, "class", "text-lg font-bold mt-4"),
        c(re, "class", "my-2"),
        c(be, "class", "text-lg font-bold mt-4"),
        c(q, "class", "my-2"),
        c(Be, "class", "text-lg font-bold mt-4"),
        c(E, "class", "my-2"),
        c(Ye, "class", "text-lg font-bold mt-4"),
        c(Ze, "class", "my-2"),
        c(d, "class", "m-4"),
        c(h, "class", "container-fluid mx-auto p-4");
    },
    m(lt, pt) {
      $s(lt, h, pt),
        e(h, d),
        e(d, u),
        e(u, w),
        e(d, N),
        e(d, b),
        e(b, le),
        e(d, Z),
        e(d, L),
        e(L, Le),
        e(d, ke),
        e(d, y),
        e(y, J),
        e(d, oe),
        e(d, k),
        e(k, ie),
        e(d, xe),
        e(d, A),
        e(A, K),
        e(d, de),
        e(d, C),
        e(C, ee),
        e(d, Ae),
        e(d, $),
        e($, V),
        e(d, Q),
        e(d, S),
        e(S, P),
        e(d, te),
        e(d, G),
        e(G, ce),
        e(d, ae),
        e(d, T),
        e(T, ye),
        e(d, De),
        e(d, R),
        e(R, Y),
        e(d, Pe),
        e(d, he),
        e(he, _e),
        e(d, Ue),
        e(d, ue),
        e(ue, j),
        e(d, fe),
        e(d, pe),
        e(pe, Ce),
        e(d, Fe),
        e(d, me),
        e(me, ve),
        e(d, p),
        e(d, D),
        e(D, Ee),
        e(d, Ne),
        e(d, ge),
        e(ge, H),
        e(d, W),
        e(d, F),
        e(F, He),
        e(d, z),
        e(d, ne),
        e(ne, we),
        e(d, Je),
        e(d, v),
        e(v, O),
        e(d, Oe),
        e(d, X),
        e(X, I),
        e(d, Re),
        e(d, se),
        e(se, Ke),
        e(d, Me),
        e(d, re),
        e(re, ze),
        e(d, Ie),
        e(d, be),
        e(be, f),
        e(d, $e),
        e(d, q),
        e(q, Qe),
        e(d, Se),
        e(d, Be),
        e(Be, qe),
        e(d, je),
        e(d, E),
        e(E, ut),
        e(d, at),
        e(d, Ye),
        e(Ye, ft),
        e(d, B),
        e(d, Ze),
        e(Ze, g);
    },
    p: Jt,
    i: Jt,
    o: Jt,
    d(lt) {
      lt && t(h);
    },
  };
}
class Z1 extends zl {
  constructor(h) {
    super(), Xl(this, h, null, Y1, Ql, {});
  }
}
function eg(x) {
  let h,
    d,
    u,
    w,
    N,
    b,
    le,
    Z,
    L,
    Le,
    ke,
    y,
    J,
    oe,
    k,
    ie,
    xe,
    A,
    K,
    de,
    C,
    ee,
    Ae,
    $,
    V,
    Q,
    S,
    P,
    te,
    G,
    ce,
    ae,
    T,
    ye,
    De,
    R,
    Y,
    Pe,
    he,
    _e,
    Ue,
    ue,
    j,
    fe,
    pe,
    Ce,
    Fe,
    me,
    ve,
    p,
    D,
    Ee,
    Ne,
    ge,
    H,
    W,
    F,
    He,
    z,
    ne,
    we,
    Je,
    v,
    O,
    Oe,
    X,
    I,
    Re,
    se,
    Ke,
    Me,
    re,
    ze,
    Ie,
    be,
    f,
    $e,
    q,
    Qe,
    Se,
    Be,
    qe,
    je,
    E,
    ut,
    at,
    Ye,
    ft,
    B,
    Ze,
    g,
    lt,
    pt,
    m,
    Lt,
    et,
    Ge,
    mt,
    kt,
    Dt,
    Te,
    It,
    xt,
    Zt,
    At,
    ia,
    ea,
    Ct,
    da,
    ta,
    $t,
    ca,
    ha,
    ra,
    ya,
    ua,
    la,
    _a,
    gt,
    St,
    Xa,
    Qa,
    oa,
    Ya,
    as,
    Ve,
    on,
    dn,
    Za,
    U,
    Rs,
    cn,
    mn,
    Ms,
    We,
    tt,
    hn,
    Bs,
    vn,
    gn,
    ot,
    bn,
    yn,
    js,
    _n,
    En,
    Ws,
    wn,
    Tn,
    Us,
    vt,
    en,
    va,
    Ns,
    tn,
    Gs,
    qs,
    an,
    Vs,
    Js,
    Xe,
    Ks,
    zs,
    za,
    un,
    ns,
    Pn,
    rt,
    fn,
    Ln,
    Xs,
    kn,
    Dn,
    Qs,
    mr,
    Ht,
    vr,
    gr,
    ti,
    br,
    yr,
    ai,
    _r,
    Er,
    ni,
    wr,
    Tr,
    si,
    Pr,
    Lr,
    ri,
    kr,
    Dr,
    li,
    Fr,
    Ys,
    Zs,
    er,
    oi,
    tr,
    it,
    Or,
    ii,
    bt,
    Fn,
    di,
    ci,
    ss,
    hi,
    ui,
    rs,
    fi,
    pi,
    ls,
    mi,
    vi,
    os,
    gi,
    bi,
    is,
    yi,
    _i,
    ds,
    Ei,
    wi,
    yt,
    Ir,
    Ti,
    xr,
    Ar,
    Pi,
    _t,
    On,
    Li,
    ki,
    cs,
    Di,
    Fi,
    hs,
    Oi,
    Ii,
    us,
    xi,
    Ai,
    fs,
    Ci,
    $i,
    ps,
    Si,
    Hi,
    Et,
    Cr,
    Ri,
    $r,
    Sr,
    Mi,
    Hr,
    Rr,
    Bi,
    wt,
    In,
    ji,
    Wi,
    ms,
    Ui,
    Ni,
    vs,
    Gi,
    qi,
    gs,
    Vi,
    Ji,
    bs,
    Ki,
    zi,
    Tt,
    Mr,
    Xi,
    Br,
    jr,
    Qi,
    Wr,
    Ur,
    Yi,
    Nr,
    Gr,
    Zi,
    ar,
    pn,
    ao,
    ed,
    dt,
    nr,
    td,
    qr,
    Vr,
    ad,
    Jr,
    Kr,
    nd,
    Rt,
    ys,
    sd,
    rd,
    _s,
    ld,
    od,
    Es,
    id,
    dd,
    ws,
    cd,
    hd,
    Ts,
    ud,
    fd,
    Ps,
    pd,
    md,
    xn,
    Ls,
    no,
    zr,
    An,
    ks,
    Mt,
    Xr,
    Qr,
    vd,
    Yr,
    sr,
    gd,
    Zr,
    ct,
    Cn,
    Ds,
    bd,
    yd,
    Fs,
    _d,
    Ed,
    $n,
    rr,
    so,
    el,
    Sn,
    tl,
    al,
    wd,
    nl,
    Bt,
    sl,
    Hn,
    rl,
    ll,
    Td,
    ol,
    il,
    Pd,
    Rn,
    Os,
    Ld,
    kd,
    Is,
    Dd,
    Fd,
    nn,
    dl,
    Od,
    cl,
    hl,
    Id,
    ul,
    Mn,
    fl,
    jt,
    pl,
    ml,
    xd,
    vl,
    Bn,
    gl,
    bl,
    Ad,
    yl,
    _l,
    Cd,
    jn,
    xs,
    $d,
    Sd,
    As,
    Hd,
    Rd,
    sn,
    El,
    Md,
    wl,
    Tl,
    Bd,
    Wt,
    Wn,
    jd,
    Wd,
    Un,
    Ud,
    Nd,
    Nn,
    Gd,
    qd,
    ga,
    Pl,
    Vd,
    Ll,
    kl,
    Jd,
    Dl,
    Fl,
    Kd,
    Ol,
    Il,
    zd,
    xl,
    lr,
    Xd,
    Ut,
    Gn,
    Qd,
    Yd,
    qn,
    Zd,
    ec,
    Vn,
    tc,
    ac,
    Jn,
    nc,
    sc,
    Kn,
    rc,
    lc,
    ba,
    Al,
    oc,
    Cl,
    $l,
    ic,
    Sl,
    Hl,
    dc,
    Nt,
    Cs,
    cc,
    hc,
    zn,
    uc,
    fc,
    fa,
    Rl,
    pc,
    Ml,
    Bl,
    mc,
    jl,
    Wl,
    vc,
    Ul,
    Nl,
    gc,
    Gl,
    ql,
    bc,
    Vl,
    Xn,
    yc,
    ht,
    Jl,
    _c;
  return {
    c() {
      (h = a("div")),
        (d = a("div")),
        (u = a("h1")),
        (w = r("$FPL Utility Token")),
        (N = o()),
        (b = a("h2")),
        (le = r("Utility and Functionality")),
        (Z = o()),
        (L = a("p")),
        (Le =
          r(`OpenFPL will be revenue generating, the most important role of the Utility
      token is to manage the OpenFPL treasury. The token is also used throughout
      the OpenFPL ecosystem:`)),
        (ke = o()),
        (y = a("ul")),
        (J = a("li")),
        (oe =
          r(`Rewarding users for gameplay achievements on weekly, monthly, and annual
        bases.`)),
        (k = o()),
        (ie = a("li")),
        (xe =
          r(`Facilitating participation in DAO governance, like raising proposals for
        player revaluation and team detail updates.`)),
        (A = o()),
        (K = a("li")),
        (de = r("Rewarding neuron holders upon maturity.")),
        (C = o()),
        (ee = a("li")),
        (Ae = r(
          "Accepting bids for season site sponsorship from organisations."
        )),
        ($ = o()),
        (V = a("li")),
        (Q = r(`Used for customisable entry fee (along with any ICRC-1 token)
        requirements for private leagues.`)),
        (S = o()),
        (P = a("li")),
        (te = r("Purchase of Merchandise from the ICPFA shop.")),
        (G = o()),
        (ce = a("li")),
        (ae = r(
          "Reward content creators for engagement on a football video reel."
        )),
        (T = o()),
        (ye = a("li")),
        (De =
          r(`Facilitate subscriptions to access premium football content from
        creators.`)),
        (R = o()),
        (Y = a("h2")),
        (Pe = r("Genesis Token Allocation")),
        (he = o()),
        (_e = a("p")),
        (Ue = r(
          "At the outset, OpenFPL's token allocation will be as follows:"
        )),
        (ue = o()),
        (j = a("ul")),
        (fe = a("li")),
        (pe = r("ICPFA: 12%")),
        (Ce = o()),
        (Fe = a("li")),
        (me = r("Funded NFT Holders: 12%")),
        (ve = o()),
        (p = a("li")),
        (D = r("SNS Decentralisation Sale: 25%")),
        (Ee = o()),
        (Ne = a("li")),
        (ge = r("DAO Treasury: 51%")),
        (H = o()),
        (W = a("p")),
        (F =
          r(`The ICPFA team members will receive their $FPL within 5 baskets of equal
      neurons. The neurons will contain the following configuration:`)),
        (He = o()),
        (z = a("ul")),
        (ne = a("li")),
        (we = r(
          "Basket 1: Locked for 3 months with a 3 month dissolve delay."
        )),
        (Je = o()),
        (v = a("li")),
        (O = r("Basket 2: Locked for 6 months with a 3 month dissolve delay.")),
        (Oe = o()),
        (X = a("li")),
        (I = r(
          "Basket 3: Locked for 12 months with a 3 month dissolve delay."
        )),
        (Re = o()),
        (se = a("li")),
        (Ke = r(
          "Basket 4: Locked for 18 months with a 3 month dissolve delay."
        )),
        (Me = o()),
        (re = a("li")),
        (ze = r(
          "Basket 5: Locked for 24 months with a 3 month dissolve delay."
        )),
        (Ie = o()),
        (be = a("p")),
        (f =
          r(`Each Funded NFT holder will receive their $FPL within 5 baskets of equal
      neurons. The neurons will contain the following configuration:`)),
        ($e = o()),
        (q = a("ul")),
        (Qe = a("li")),
        (Se = r("Basket 1: Unlocked with a dissolve delay of 30 days.")),
        (Be = o()),
        (qe = a("li")),
        (je = r(
          "Basket 2: Locked for 6 months with a 1 month dissolve delay."
        )),
        (E = o()),
        (ut = a("li")),
        (at = r(
          "Basket 3: Locked for 12 months with a 1 month dissolve delay."
        )),
        (Ye = o()),
        (ft = a("li")),
        (B = r(
          "Basket 4: Locked for 18 months with a 1 month dissolve delay."
        )),
        (Ze = o()),
        (g = a("li")),
        (lt = r(
          "Basket 5: Locked for 24 months with a 1 month dissolve delay."
        )),
        (pt = o()),
        (m = a("p")),
        (Lt =
          r(`Each SNS decentralisation swap participant will receive their $FPL within
      5 baskets of equal neurons. The neurons will contain the following
      configuration:`)),
        (et = o()),
        (Ge = a("ul")),
        (mt = a("li")),
        (kt = r("Basket 1: Unlocked with zero dissolve delay.")),
        (Dt = o()),
        (Te = a("li")),
        (It = r("Basket 2: Unlocked with 3 months dissolve delay.")),
        (xt = o()),
        (Zt = a("li")),
        (At = r("Basket 3: Unlocked with 6 months dissolve delay.")),
        (ia = o()),
        (ea = a("li")),
        (Ct = r("Basket 4: Unlocked with 9 months dissolve delay.")),
        (da = o()),
        (ta = a("li")),
        ($t = r("Basket 5: Unlocked with 12 months dissolve delay.")),
        (ca = o()),
        (ha = a("h2")),
        (ra = r("DAO Valuation")),
        (ya = o()),
        (ua = a("p")),
        (la =
          r(`We have used the discounted cashflow method to value the DAO. The
      following assumptions have been made:`)),
        (_a = o()),
        (gt = a("ul")),
        (St = a("li")),
        (Xa = r(
          "We can grow to the size of our Web2 competitor over 8 years."
        )),
        (Qa = o()),
        (oa = a("li")),
        (Ya = r(
          "Assumed 10% user conversion, each setting up a league at 1 ICP."
        )),
        (as = o()),
        (Ve = a("li")),
        (on =
          r(`Estimated 5% user content subscription rate at 5 ICP/month with 5% of
        this revenue going to the DAO.`)),
        (dn = o()),
        (Za = a("li")),
        (U = r("Estimated 5% users spend 10ICP per year.")),
        (Rs = o()),
        (cn = a("p")),
        (mn = r("The financials below are in ICP:")),
        (Ms = o()),
        (We = a("table")),
        (tt = a("tr")),
        (hn = a("th")),
        (Bs = r("Year")),
        (vn = o()),
        (gn = a("th")),
        (ot = r("1")),
        (bn = o()),
        (yn = a("th")),
        (js = r("2")),
        (_n = o()),
        (En = a("th")),
        (Ws = r("3")),
        (wn = o()),
        (Tn = a("th")),
        (Us = r("4")),
        (vt = o()),
        (en = a("th")),
        (va = r("5")),
        (Ns = o()),
        (tn = a("th")),
        (Gs = r("6")),
        (qs = o()),
        (an = a("th")),
        (Vs = r("7")),
        (Js = o()),
        (Xe = a("th")),
        (Ks = r("8")),
        (zs = o()),
        (za = a("tr")),
        (un = a("td")),
        (ns = a("span")),
        (Pn = o()),
        (rt = a("tr")),
        (fn = a("td")),
        (Ln = r("Managers")),
        (Xs = o()),
        (kn = a("td")),
        (Dn = r("10,000")),
        (Qs = o()),
        (mr = a("td")),
        (Ht = r("50,000")),
        (vr = o()),
        (gr = a("td")),
        (ti = r("250,000")),
        (br = o()),
        (yr = a("td")),
        (ai = r("1,000,000")),
        (_r = o()),
        (Er = a("td")),
        (ni = r("2,500,000")),
        (wr = o()),
        (Tr = a("td")),
        (si = r("5,000,000")),
        (Pr = o()),
        (Lr = a("td")),
        (ri = r("7,500,000")),
        (kr = o()),
        (Dr = a("td")),
        (li = r("10,000,000")),
        (Fr = o()),
        (Ys = a("tr")),
        (Zs = a("td")),
        (er = a("span")),
        (oi = o()),
        (tr = a("tr")),
        (it = a("td")),
        (Or = r("Revenue:")),
        (ii = o()),
        (bt = a("tr")),
        (Fn = a("td")),
        (di = r("Private Leagues")),
        (ci = o()),
        (ss = a("td")),
        (hi = r("1,000")),
        (ui = o()),
        (rs = a("td")),
        (fi = r("5,000")),
        (pi = o()),
        (ls = a("td")),
        (mi = r("25,000")),
        (vi = o()),
        (os = a("td")),
        (gi = r("100,000")),
        (bi = o()),
        (is = a("td")),
        (yi = r("250,000")),
        (_i = o()),
        (ds = a("td")),
        (Ei = r("500,000")),
        (wi = o()),
        (yt = a("td")),
        (Ir = r("750,000")),
        (Ti = o()),
        (xr = a("td")),
        (Ar = r("1,000,000")),
        (Pi = o()),
        (_t = a("tr")),
        (On = a("td")),
        (Li = r("Merchandising")),
        (ki = o()),
        (cs = a("td")),
        (Di = r("5,000")),
        (Fi = o()),
        (hs = a("td")),
        (Oi = r("25,000")),
        (Ii = o()),
        (us = a("td")),
        (xi = r("125,000")),
        (Ai = o()),
        (fs = a("td")),
        (Ci = r("500,000")),
        ($i = o()),
        (ps = a("td")),
        (Si = r("1,250,000")),
        (Hi = o()),
        (Et = a("td")),
        (Cr = r("2,500,000")),
        (Ri = o()),
        ($r = a("td")),
        (Sr = r("3,750,000")),
        (Mi = o()),
        (Hr = a("td")),
        (Rr = r("5,000,000")),
        (Bi = o()),
        (wt = a("tr")),
        (In = a("td")),
        (ji = r("Content Subscriptions")),
        (Wi = o()),
        (ms = a("td")),
        (Ui = r("125")),
        (Ni = o()),
        (vs = a("td")),
        (Gi = r("625")),
        (qi = o()),
        (gs = a("td")),
        (Vi = r("3,125")),
        (Ji = o()),
        (bs = a("td")),
        (Ki = r("12,500")),
        (zi = o()),
        (Tt = a("td")),
        (Mr = r("31,250")),
        (Xi = o()),
        (Br = a("td")),
        (jr = r("62,500")),
        (Qi = o()),
        (Wr = a("td")),
        (Ur = r("93,750")),
        (Yi = o()),
        (Nr = a("td")),
        (Gr = r("125,000")),
        (Zi = o()),
        (ar = a("tr")),
        (pn = a("td")),
        (ao = a("span")),
        (ed = o()),
        (dt = a("tr")),
        (nr = a("td")),
        (td = r("Total")),
        (qr = o()),
        (Vr = a("td")),
        (ad = r("6,125")),
        (Jr = o()),
        (Kr = a("td")),
        (nd = r("30,625")),
        (Rt = o()),
        (ys = a("td")),
        (sd = r("153,125")),
        (rd = o()),
        (_s = a("td")),
        (ld = r("612,500")),
        (od = o()),
        (Es = a("td")),
        (id = r("1,531,250")),
        (dd = o()),
        (ws = a("td")),
        (cd = r("3,062,500")),
        (hd = o()),
        (Ts = a("td")),
        (ud = r("4,593,750")),
        (fd = o()),
        (Ps = a("td")),
        (pd = r("6,125,000")),
        (md = o()),
        (xn = a("tr")),
        (Ls = a("td")),
        (no = a("span")),
        (zr = o()),
        (An = a("tr")),
        (ks = a("td")),
        (Mt = r("SNS Value (25%)")),
        (Xr = o()),
        (Qr = a("td")),
        (vd = r("1,531,250")),
        (Yr = o()),
        (sr = a("h2")),
        (gd = r("SNS Decentralisation Sale Configuration")),
        (Zr = o()),
        (ct = a("table")),
        (Cn = a("tr")),
        (Ds = a("th")),
        (bd = r("Configuration")),
        (yd = o()),
        (Fs = a("th")),
        (_d = r("Value")),
        (Ed = o()),
        ($n = a("tr")),
        (rr = a("td")),
        (so = a("span")),
        (el = o()),
        (Sn = a("tr")),
        (tl = a("td")),
        (al = r("The total number of FPL tokens to be sold.")),
        (wd = o()),
        (nl = a("td")),
        (Bt = r("25,000,000 (25%)")),
        (sl = o()),
        (Hn = a("tr")),
        (rl = a("td")),
        (ll = r("The maximum ICP to be raised.")),
        (Td = o()),
        (ol = a("td")),
        (il = r("2,000,000")),
        (Pd = o()),
        (Rn = a("tr")),
        (Os = a("td")),
        (Ld = r(
          "The minimum ICP to be raised (otherwise sale fails and ICP returned)."
        )),
        (kd = o()),
        (Is = a("td")),
        (Dd = r("1,000,000")),
        (Fd = o()),
        (nn = a("tr")),
        (dl = a("td")),
        (Od = r("The ICP from the Community Fund.")),
        (cl = o()),
        (hl = a("td")),
        (Id = r("Matched Funding Enabled")),
        (ul = o()),
        (Mn = a("tr")),
        (fl = a("td")),
        (jt = r("Sale start date.")),
        (pl = o()),
        (ml = a("td")),
        (xd = r("1st March 2024")),
        (vl = o()),
        (Bn = a("tr")),
        (gl = a("td")),
        (bl = r("Minimum number of sale participants.")),
        (Ad = o()),
        (yl = a("td")),
        (_l = r("500")),
        (Cd = o()),
        (jn = a("tr")),
        (xs = a("td")),
        ($d = r("Minimum ICP per buyer.")),
        (Sd = o()),
        (As = a("td")),
        (Hd = r("10")),
        (Rd = o()),
        (sn = a("tr")),
        (El = a("td")),
        (Md = r("Maximum ICP per buyer.")),
        (wl = o()),
        (Tl = a("td")),
        (Bd = r("150,000")),
        (Wt = o()),
        (Wn = a("h2")),
        (jd = r("Mitigation against a 51% Attack")),
        (Wd = o()),
        (Un = a("p")),
        (Ud =
          r(`There is a danger that the OpenFPL SNS treasury could be the target of an
      attack. One possible scenario is for an attacker to buy a large proportion
      of the FPL tokens in the decentralisation sale and immediately increase
      the dissolve delay of all of their neurons to the maximum 4 year in an
      attempt to gain more than 50% of the SNS voting power. If successful they
      could force through a proposal to transfer the entire ICP and FPL treasury
      to themselves. The Community Fund actually provides a great deal of
      mitigation against this scenario because it limits the proportion of
      voting power an attacker would be able to acquire.`)),
        (Nd = o()),
        (Nn = a("p")),
        (Gd = r(
          "The amount raised in the decentralisation will be used as follows:"
        )),
        (qd = o()),
        (ga = a("ul")),
        (Pl = a("li")),
        (Vd =
          r(`80% will be staked in an 8 year neuron with the maturity interest paid
        to the ICPFA.`)),
        (Ll = o()),
        (kl = a("li")),
        (Jd =
          r(`10% will be available for exchange liquidity to enable trading of the
        FPL token.`)),
        (Dl = o()),
        (Fl = a("li")),
        (Kd = r(
          "5% will be paid directly to the ICPFA after the decentralisation sale."
        )),
        (Ol = o()),
        (Il = a("li")),
        (zd =
          r(`5% will be held in reserve for cycles to run OpenFPL, likely to be
        unused as OpenFPL begins generating revenue.`)),
        (xl = o()),
        (lr = a("p")),
        (Xd =
          r(`This treasury balance will be topped up with the DAO's revenue, with 50%
      being paid to neuron holders. Any excess balance can be utilised where the
      DAO sees fit.`)),
        (Ut = o()),
        (Gn = a("h2")),
        (Qd = r("Tokenomics")),
        (Yd = o()),
        (qn = a("p")),
        (Zd =
          r(`Each season, 2.5% of the total $FPL supply will be minted for DAO rewards.
      There is no mechanism to automatically burn $FPL as we anticipate the user
      growth to be faster than the supply increase, thus increasing the price of
      $FPL. However a proposal can always be made to burn $FPL if required. If
      the DAO’s treasury is ever 60% or more of the total supply of $FPL, it
      will be ICP FA policy to raise a proposal to burn 5% of the total supply
      from the DAO’s treasury.`)),
        (ec = o()),
        (Vn = a("h2")),
        (tc = r("ICP FA Overview")),
        (ac = o()),
        (Jn = a("p")),
        (nc =
          r(`Managed by founder James Beadle, the ICP FA oversees the development,
      marketing, and management of OpenFPL. The aim is to build a strong team to
      guide OpenFPL's growth and bring new users to the ICP blockchain.
      Additionally, 25% of James' staked maturity earnings will contribute to
      the ICP FA Community Fund, supporting grassroots football projects.`)),
        (sc = o()),
        (Kn = a("p")),
        (rc =
          r(`The ICPFA will receive 5% of the decentralisation sale along with the
      maturity interest from the staked neuron. These funds will be use for the
      following:`)),
        (lc = o()),
        (ba = a("ul")),
        (Al = a("li")),
        (oc = r(
          "The ongoing promotion and marketing of OpenFPL both online and offline."
        )),
        (Cl = o()),
        ($l = a("li")),
        (ic =
          r(`Hiring of a frontend and backend developer to assist the founder with
        the day to day development workload.`)),
        (Sl = o()),
        (Hl = a("li")),
        (dc =
          r(`Hiring of a UAT Test Engineer to ensure all ICPFA products are of the
        highest quality.`)),
        (Nt = o()),
        (Cs = a("li")),
        (cc = r("Hiring of a Marketing Manager.")),
        (hc = o()),
        (zn = a("p")),
        (uc = r("Along with paying the founding team members:")),
        (fc = o()),
        (fa = a("ul")),
        (Rl = a("li")),
        (pc = r("James Beadle - Founder, Lead Developer")),
        (Ml = o()),
        (Bl = a("li")),
        (mc = r("DfinityDesigner - Designer")),
        (jl = o()),
        (Wl = a("li")),
        (vc = r("George - Community Manager")),
        (Ul = o()),
        (Nl = a("li")),
        (gc = r("ICP_Insider - Blockchain Promoter")),
        (Gl = o()),
        (ql = a("li")),
        (bc = r("MadMaxIC - Gameplay Designer")),
        (Vl = o()),
        (Xn = a("p")),
        (yc = r(
          "More details about the ICP FA and its members can be found at "
        )),
        (ht = a("a")),
        (Jl = r("icpfa.org/team")),
        (_c = r(".")),
        this.h();
    },
    l(Kl) {
      h = n(Kl, "DIV", { class: !0 });
      var or = s(h);
      d = n(or, "DIV", { class: !0 });
      var _ = s(d);
      u = n(_, "H1", { class: !0 });
      var Ec = s(u);
      (w = l(Ec, "$FPL Utility Token")),
        Ec.forEach(t),
        (N = i(_)),
        (b = n(_, "H2", { class: !0 }));
      var ro = s(b);
      (le = l(ro, "Utility and Functionality")),
        ro.forEach(t),
        (Z = i(_)),
        (L = n(_, "P", { class: !0 }));
      var wc = s(L);
      (Le = l(
        wc,
        `OpenFPL will be revenue generating, the most important role of the Utility
      token is to manage the OpenFPL treasury. The token is also used throughout
      the OpenFPL ecosystem:`
      )),
        wc.forEach(t),
        (ke = i(_)),
        (y = n(_, "UL", { class: !0 }));
      var pa = s(y);
      J = n(pa, "LI", {});
      var lo = s(J);
      (oe = l(
        lo,
        `Rewarding users for gameplay achievements on weekly, monthly, and annual
        bases.`
      )),
        lo.forEach(t),
        (k = i(pa)),
        (ie = n(pa, "LI", {}));
      var Tc = s(ie);
      (xe = l(
        Tc,
        `Facilitating participation in DAO governance, like raising proposals for
        player revaluation and team detail updates.`
      )),
        Tc.forEach(t),
        (A = i(pa)),
        (K = n(pa, "LI", {}));
      var Pc = s(K);
      (de = l(Pc, "Rewarding neuron holders upon maturity.")),
        Pc.forEach(t),
        (C = i(pa)),
        (ee = n(pa, "LI", {}));
      var oo = s(ee);
      (Ae = l(
        oo,
        "Accepting bids for season site sponsorship from organisations."
      )),
        oo.forEach(t),
        ($ = i(pa)),
        (V = n(pa, "LI", {}));
      var Lc = s(V);
      (Q = l(
        Lc,
        `Used for customisable entry fee (along with any ICRC-1 token)
        requirements for private leagues.`
      )),
        Lc.forEach(t),
        (S = i(pa)),
        (P = n(pa, "LI", {}));
      var kc = s(P);
      (te = l(kc, "Purchase of Merchandise from the ICPFA shop.")),
        kc.forEach(t),
        (G = i(pa)),
        (ce = n(pa, "LI", {}));
      var io = s(ce);
      (ae = l(
        io,
        "Reward content creators for engagement on a football video reel."
      )),
        io.forEach(t),
        (T = i(pa)),
        (ye = n(pa, "LI", {}));
      var Dc = s(ye);
      (De = l(
        Dc,
        `Facilitate subscriptions to access premium football content from
        creators.`
      )),
        Dc.forEach(t),
        pa.forEach(t),
        (R = i(_)),
        (Y = n(_, "H2", { class: !0 }));
      var Fc = s(Y);
      (Pe = l(Fc, "Genesis Token Allocation")),
        Fc.forEach(t),
        (he = i(_)),
        (_e = n(_, "P", { class: !0 }));
      var co = s(_e);
      (Ue = l(
        co,
        "At the outset, OpenFPL's token allocation will be as follows:"
      )),
        co.forEach(t),
        (ue = i(_)),
        (j = n(_, "UL", { class: !0 }));
      var Qn = s(j);
      fe = n(Qn, "LI", {});
      var Oc = s(fe);
      (pe = l(Oc, "ICPFA: 12%")),
        Oc.forEach(t),
        (Ce = i(Qn)),
        (Fe = n(Qn, "LI", {}));
      var ho = s(Fe);
      (me = l(ho, "Funded NFT Holders: 12%")),
        ho.forEach(t),
        (ve = i(Qn)),
        (p = n(Qn, "LI", {}));
      var Ic = s(p);
      (D = l(Ic, "SNS Decentralisation Sale: 25%")),
        Ic.forEach(t),
        (Ee = i(Qn)),
        (Ne = n(Qn, "LI", {}));
      var xc = s(Ne);
      (ge = l(xc, "DAO Treasury: 51%")),
        xc.forEach(t),
        Qn.forEach(t),
        (H = i(_)),
        (W = n(_, "P", { class: !0 }));
      var Kt = s(W);
      (F = l(
        Kt,
        `The ICPFA team members will receive their $FPL within 5 baskets of equal
      neurons. The neurons will contain the following configuration:`
      )),
        Kt.forEach(t),
        (He = i(_)),
        (z = n(_, "UL", { class: !0 }));
      var Ea = s(z);
      ne = n(Ea, "LI", {});
      var Ac = s(ne);
      (we = l(
        Ac,
        "Basket 1: Locked for 3 months with a 3 month dissolve delay."
      )),
        Ac.forEach(t),
        (Je = i(Ea)),
        (v = n(Ea, "LI", {}));
      var Cc = s(v);
      (O = l(
        Cc,
        "Basket 2: Locked for 6 months with a 3 month dissolve delay."
      )),
        Cc.forEach(t),
        (Oe = i(Ea)),
        (X = n(Ea, "LI", {}));
      var uo = s(X);
      (I = l(
        uo,
        "Basket 3: Locked for 12 months with a 3 month dissolve delay."
      )),
        uo.forEach(t),
        (Re = i(Ea)),
        (se = n(Ea, "LI", {}));
      var $c = s(se);
      (Ke = l(
        $c,
        "Basket 4: Locked for 18 months with a 3 month dissolve delay."
      )),
        $c.forEach(t),
        (Me = i(Ea)),
        (re = n(Ea, "LI", {}));
      var Sc = s(re);
      (ze = l(
        Sc,
        "Basket 5: Locked for 24 months with a 3 month dissolve delay."
      )),
        Sc.forEach(t),
        Ea.forEach(t),
        (Ie = i(_)),
        (be = n(_, "P", { class: !0 }));
      var fo = s(be);
      (f = l(
        fo,
        `Each Funded NFT holder will receive their $FPL within 5 baskets of equal
      neurons. The neurons will contain the following configuration:`
      )),
        fo.forEach(t),
        ($e = i(_)),
        (q = n(_, "UL", { class: !0 }));
      var rn = s(q);
      Qe = n(rn, "LI", {});
      var Hc = s(Qe);
      (Se = l(Hc, "Basket 1: Unlocked with a dissolve delay of 30 days.")),
        Hc.forEach(t),
        (Be = i(rn)),
        (qe = n(rn, "LI", {}));
      var po = s(qe);
      (je = l(
        po,
        "Basket 2: Locked for 6 months with a 1 month dissolve delay."
      )),
        po.forEach(t),
        (E = i(rn)),
        (ut = n(rn, "LI", {}));
      var Rc = s(ut);
      (at = l(
        Rc,
        "Basket 3: Locked for 12 months with a 1 month dissolve delay."
      )),
        Rc.forEach(t),
        (Ye = i(rn)),
        (ft = n(rn, "LI", {}));
      var Mc = s(ft);
      (B = l(
        Mc,
        "Basket 4: Locked for 18 months with a 1 month dissolve delay."
      )),
        Mc.forEach(t),
        (Ze = i(rn)),
        (g = n(rn, "LI", {}));
      var mo = s(g);
      (lt = l(
        mo,
        "Basket 5: Locked for 24 months with a 1 month dissolve delay."
      )),
        mo.forEach(t),
        rn.forEach(t),
        (pt = i(_)),
        (m = n(_, "P", { class: !0 }));
      var Bc = s(m);
      (Lt = l(
        Bc,
        `Each SNS decentralisation swap participant will receive their $FPL within
      5 baskets of equal neurons. The neurons will contain the following
      configuration:`
      )),
        Bc.forEach(t),
        (et = i(_)),
        (Ge = n(_, "UL", { class: !0 }));
      var ln = s(Ge);
      mt = n(ln, "LI", {});
      var vo = s(mt);
      (kt = l(vo, "Basket 1: Unlocked with zero dissolve delay.")),
        vo.forEach(t),
        (Dt = i(ln)),
        (Te = n(ln, "LI", {}));
      var jc = s(Te);
      (It = l(jc, "Basket 2: Unlocked with 3 months dissolve delay.")),
        jc.forEach(t),
        (xt = i(ln)),
        (Zt = n(ln, "LI", {}));
      var Wc = s(Zt);
      (At = l(Wc, "Basket 3: Unlocked with 6 months dissolve delay.")),
        Wc.forEach(t),
        (ia = i(ln)),
        (ea = n(ln, "LI", {}));
      var go = s(ea);
      (Ct = l(go, "Basket 4: Unlocked with 9 months dissolve delay.")),
        go.forEach(t),
        (da = i(ln)),
        (ta = n(ln, "LI", {}));
      var Uc = s(ta);
      ($t = l(Uc, "Basket 5: Unlocked with 12 months dissolve delay.")),
        Uc.forEach(t),
        ln.forEach(t),
        (ca = i(_)),
        (ha = n(_, "H2", { class: !0 }));
      var Nc = s(ha);
      (ra = l(Nc, "DAO Valuation")),
        Nc.forEach(t),
        (ya = i(_)),
        (ua = n(_, "P", { class: !0 }));
      var bo = s(ua);
      (la = l(
        bo,
        `We have used the discounted cashflow method to value the DAO. The
      following assumptions have been made:`
      )),
        bo.forEach(t),
        (_a = i(_)),
        (gt = n(_, "UL", { class: !0 }));
      var Yn = s(gt);
      St = n(Yn, "LI", {});
      var Gc = s(St);
      (Xa = l(
        Gc,
        "We can grow to the size of our Web2 competitor over 8 years."
      )),
        Gc.forEach(t),
        (Qa = i(Yn)),
        (oa = n(Yn, "LI", {}));
      var zt = s(oa);
      (Ya = l(
        zt,
        "Assumed 10% user conversion, each setting up a league at 1 ICP."
      )),
        zt.forEach(t),
        (as = i(Yn)),
        (Ve = n(Yn, "LI", {}));
      var yo = s(Ve);
      (on = l(
        yo,
        `Estimated 5% user content subscription rate at 5 ICP/month with 5% of
        this revenue going to the DAO.`
      )),
        yo.forEach(t),
        (dn = i(Yn)),
        (Za = n(Yn, "LI", {}));
      var qc = s(Za);
      (U = l(qc, "Estimated 5% users spend 10ICP per year.")),
        qc.forEach(t),
        Yn.forEach(t),
        (Rs = i(_)),
        (cn = n(_, "P", { class: !0 }));
      var Vc = s(cn);
      (mn = l(Vc, "The financials below are in ICP:")),
        Vc.forEach(t),
        (Ms = i(_)),
        (We = n(_, "TABLE", { class: !0 }));
      var nt = s(We);
      tt = n(nt, "TR", { class: !0 });
      var aa = s(tt);
      hn = n(aa, "TH", { class: !0 });
      var Jc = s(hn);
      (Bs = l(Jc, "Year")), Jc.forEach(t), (vn = i(aa)), (gn = n(aa, "TH", {}));
      var _o = s(gn);
      (ot = l(_o, "1")), _o.forEach(t), (bn = i(aa)), (yn = n(aa, "TH", {}));
      var Kc = s(yn);
      (js = l(Kc, "2")), Kc.forEach(t), (_n = i(aa)), (En = n(aa, "TH", {}));
      var zc = s(En);
      (Ws = l(zc, "3")), zc.forEach(t), (wn = i(aa)), (Tn = n(aa, "TH", {}));
      var Eo = s(Tn);
      (Us = l(Eo, "4")), Eo.forEach(t), (vt = i(aa)), (en = n(aa, "TH", {}));
      var Xc = s(en);
      (va = l(Xc, "5")), Xc.forEach(t), (Ns = i(aa)), (tn = n(aa, "TH", {}));
      var Qc = s(tn);
      (Gs = l(Qc, "6")), Qc.forEach(t), (qs = i(aa)), (an = n(aa, "TH", {}));
      var wo = s(an);
      (Vs = l(wo, "7")), wo.forEach(t), (Js = i(aa)), (Xe = n(aa, "TH", {}));
      var Yc = s(Xe);
      (Ks = l(Yc, "8")),
        Yc.forEach(t),
        aa.forEach(t),
        (zs = i(nt)),
        (za = n(nt, "TR", { class: !0 }));
      var Zc = s(za);
      un = n(Zc, "TD", { class: !0 });
      var To = s(un);
      (ns = n(To, "SPAN", {})),
        s(ns).forEach(t),
        To.forEach(t),
        Zc.forEach(t),
        (Pn = i(nt)),
        (rt = n(nt, "TR", { class: !0 }));
      var na = s(rt);
      fn = n(na, "TD", { class: !0 });
      var eh = s(fn);
      (Ln = l(eh, "Managers")),
        eh.forEach(t),
        (Xs = i(na)),
        (kn = n(na, "TD", {}));
      var Po = s(kn);
      (Dn = l(Po, "10,000")),
        Po.forEach(t),
        (Qs = i(na)),
        (mr = n(na, "TD", {}));
      var th = s(mr);
      (Ht = l(th, "50,000")),
        th.forEach(t),
        (vr = i(na)),
        (gr = n(na, "TD", {}));
      var ah = s(gr);
      (ti = l(ah, "250,000")),
        ah.forEach(t),
        (br = i(na)),
        (yr = n(na, "TD", {}));
      var Lo = s(yr);
      (ai = l(Lo, "1,000,000")),
        Lo.forEach(t),
        (_r = i(na)),
        (Er = n(na, "TD", {}));
      var nh = s(Er);
      (ni = l(nh, "2,500,000")),
        nh.forEach(t),
        (wr = i(na)),
        (Tr = n(na, "TD", {}));
      var sh = s(Tr);
      (si = l(sh, "5,000,000")),
        sh.forEach(t),
        (Pr = i(na)),
        (Lr = n(na, "TD", {}));
      var Xt = s(Lr);
      (ri = l(Xt, "7,500,000")),
        Xt.forEach(t),
        (kr = i(na)),
        (Dr = n(na, "TD", {}));
      var ko = s(Dr);
      (li = l(ko, "10,000,000")),
        ko.forEach(t),
        na.forEach(t),
        (Fr = i(nt)),
        (Ys = n(nt, "TR", { class: !0 }));
      var rh = s(Ys);
      Zs = n(rh, "TD", { class: !0 });
      var lh = s(Zs);
      (er = n(lh, "SPAN", {})),
        s(er).forEach(t),
        lh.forEach(t),
        rh.forEach(t),
        (oi = i(nt)),
        (tr = n(nt, "TR", { class: !0 }));
      var Do = s(tr);
      it = n(Do, "TD", { class: !0, colspan: !0 });
      var oh = s(it);
      (Or = l(oh, "Revenue:")),
        oh.forEach(t),
        Do.forEach(t),
        (ii = i(nt)),
        (bt = n(nt, "TR", { class: !0 }));
      var sa = s(bt);
      Fn = n(sa, "TD", { class: !0 });
      var Fo = s(Fn);
      (di = l(Fo, "Private Leagues")),
        Fo.forEach(t),
        (ci = i(sa)),
        (ss = n(sa, "TD", {}));
      var ih = s(ss);
      (hi = l(ih, "1,000")),
        ih.forEach(t),
        (ui = i(sa)),
        (rs = n(sa, "TD", {}));
      var dh = s(rs);
      (fi = l(dh, "5,000")),
        dh.forEach(t),
        (pi = i(sa)),
        (ls = n(sa, "TD", {}));
      var Oo = s(ls);
      (mi = l(Oo, "25,000")),
        Oo.forEach(t),
        (vi = i(sa)),
        (os = n(sa, "TD", {}));
      var ch = s(os);
      (gi = l(ch, "100,000")),
        ch.forEach(t),
        (bi = i(sa)),
        (is = n(sa, "TD", {}));
      var hh = s(is);
      (yi = l(hh, "250,000")),
        hh.forEach(t),
        (_i = i(sa)),
        (ds = n(sa, "TD", {}));
      var Io = s(ds);
      (Ei = l(Io, "500,000")),
        Io.forEach(t),
        (wi = i(sa)),
        (yt = n(sa, "TD", {}));
      var uh = s(yt);
      (Ir = l(uh, "750,000")),
        uh.forEach(t),
        (Ti = i(sa)),
        (xr = n(sa, "TD", {}));
      var fh = s(xr);
      (Ar = l(fh, "1,000,000")),
        fh.forEach(t),
        sa.forEach(t),
        (Pi = i(nt)),
        (_t = n(nt, "TR", { class: !0 }));
      var Gt = s(_t);
      On = n(Gt, "TD", { class: !0 });
      var ph = s(On);
      (Li = l(ph, "Merchandising")),
        ph.forEach(t),
        (ki = i(Gt)),
        (cs = n(Gt, "TD", {}));
      var mh = s(cs);
      (Di = l(mh, "5,000")),
        mh.forEach(t),
        (Fi = i(Gt)),
        (hs = n(Gt, "TD", {}));
      var xo = s(hs);
      (Oi = l(xo, "25,000")),
        xo.forEach(t),
        (Ii = i(Gt)),
        (us = n(Gt, "TD", {}));
      var vh = s(us);
      (xi = l(vh, "125,000")),
        vh.forEach(t),
        (Ai = i(Gt)),
        (fs = n(Gt, "TD", {}));
      var gh = s(fs);
      (Ci = l(gh, "500,000")),
        gh.forEach(t),
        ($i = i(Gt)),
        (ps = n(Gt, "TD", {}));
      var Ao = s(ps);
      (Si = l(Ao, "1,250,000")),
        Ao.forEach(t),
        (Hi = i(Gt)),
        (Et = n(Gt, "TD", {}));
      var bh = s(Et);
      (Cr = l(bh, "2,500,000")),
        bh.forEach(t),
        (Ri = i(Gt)),
        ($r = n(Gt, "TD", {}));
      var yh = s($r);
      (Sr = l(yh, "3,750,000")),
        yh.forEach(t),
        (Mi = i(Gt)),
        (Hr = n(Gt, "TD", {}));
      var Qt = s(Hr);
      (Rr = l(Qt, "5,000,000")),
        Qt.forEach(t),
        Gt.forEach(t),
        (Bi = i(nt)),
        (wt = n(nt, "TR", { class: !0 }));
      var qt = s(wt);
      In = n(qt, "TD", { class: !0 });
      var _h = s(In);
      (ji = l(_h, "Content Subscriptions")),
        _h.forEach(t),
        (Wi = i(qt)),
        (ms = n(qt, "TD", {}));
      var Eh = s(ms);
      (Ui = l(Eh, "125")), Eh.forEach(t), (Ni = i(qt)), (vs = n(qt, "TD", {}));
      var Co = s(vs);
      (Gi = l(Co, "625")), Co.forEach(t), (qi = i(qt)), (gs = n(qt, "TD", {}));
      var wh = s(gs);
      (Vi = l(wh, "3,125")),
        wh.forEach(t),
        (Ji = i(qt)),
        (bs = n(qt, "TD", {}));
      var Th = s(bs);
      (Ki = l(Th, "12,500")),
        Th.forEach(t),
        (zi = i(qt)),
        (Tt = n(qt, "TD", {}));
      var $o = s(Tt);
      (Mr = l($o, "31,250")),
        $o.forEach(t),
        (Xi = i(qt)),
        (Br = n(qt, "TD", {}));
      var Ph = s(Br);
      (jr = l(Ph, "62,500")),
        Ph.forEach(t),
        (Qi = i(qt)),
        (Wr = n(qt, "TD", {}));
      var Lh = s(Wr);
      (Ur = l(Lh, "93,750")),
        Lh.forEach(t),
        (Yi = i(qt)),
        (Nr = n(qt, "TD", {}));
      var So = s(Nr);
      (Gr = l(So, "125,000")),
        So.forEach(t),
        qt.forEach(t),
        (Zi = i(nt)),
        (ar = n(nt, "TR", { class: !0 }));
      var kh = s(ar);
      pn = n(kh, "TD", { colspan: !0, class: !0 });
      var Dh = s(pn);
      (ao = n(Dh, "SPAN", {})),
        s(ao).forEach(t),
        Dh.forEach(t),
        kh.forEach(t),
        (ed = i(nt)),
        (dt = n(nt, "TR", { class: !0 }));
      var Vt = s(dt);
      nr = n(Vt, "TD", { class: !0 });
      var Fh = s(nr);
      (td = l(Fh, "Total")),
        Fh.forEach(t),
        (qr = i(Vt)),
        (Vr = n(Vt, "TD", {}));
      var Oh = s(Vr);
      (ad = l(Oh, "6,125")),
        Oh.forEach(t),
        (Jr = i(Vt)),
        (Kr = n(Vt, "TD", {}));
      var Ho = s(Kr);
      (nd = l(Ho, "30,625")),
        Ho.forEach(t),
        (Rt = i(Vt)),
        (ys = n(Vt, "TD", {}));
      var Ih = s(ys);
      (sd = l(Ih, "153,125")),
        Ih.forEach(t),
        (rd = i(Vt)),
        (_s = n(Vt, "TD", {}));
      var xh = s(_s);
      (ld = l(xh, "612,500")),
        xh.forEach(t),
        (od = i(Vt)),
        (Es = n(Vt, "TD", {}));
      var Ro = s(Es);
      (id = l(Ro, "1,531,250")),
        Ro.forEach(t),
        (dd = i(Vt)),
        (ws = n(Vt, "TD", {}));
      var Ah = s(ws);
      (cd = l(Ah, "3,062,500")),
        Ah.forEach(t),
        (hd = i(Vt)),
        (Ts = n(Vt, "TD", {}));
      var Ch = s(Ts);
      (ud = l(Ch, "4,593,750")),
        Ch.forEach(t),
        (fd = i(Vt)),
        (Ps = n(Vt, "TD", {}));
      var Mo = s(Ps);
      (pd = l(Mo, "6,125,000")),
        Mo.forEach(t),
        Vt.forEach(t),
        (md = i(nt)),
        (xn = n(nt, "TR", { class: !0 }));
      var $h = s(xn);
      Ls = n($h, "TD", { colspan: !0, class: !0 });
      var Sh = s(Ls);
      (no = n(Sh, "SPAN", {})),
        s(no).forEach(t),
        Sh.forEach(t),
        $h.forEach(t),
        (zr = i(nt)),
        (An = n(nt, "TR", { class: !0 }));
      var Ft = s(An);
      ks = n(Ft, "TD", { class: !0, colspan: !0 });
      var Bo = s(ks);
      (Mt = l(Bo, "SNS Value (25%)")),
        Bo.forEach(t),
        (Xr = i(Ft)),
        (Qr = n(Ft, "TD", {}));
      var Hh = s(Qr);
      (vd = l(Hh, "1,531,250")),
        Hh.forEach(t),
        Ft.forEach(t),
        nt.forEach(t),
        (Yr = i(_)),
        (sr = n(_, "H2", { class: !0 }));
      var Rh = s(sr);
      (gd = l(Rh, "SNS Decentralisation Sale Configuration")),
        Rh.forEach(t),
        (Zr = i(_)),
        (ct = n(_, "TABLE", { class: !0 }));
      var Pt = s(ct);
      Cn = n(Pt, "TR", { class: !0 });
      var jo = s(Cn);
      Ds = n(jo, "TH", {});
      var Mh = s(Ds);
      (bd = l(Mh, "Configuration")),
        Mh.forEach(t),
        (yd = i(jo)),
        (Fs = n(jo, "TH", {}));
      var Wo = s(Fs);
      (_d = l(Wo, "Value")),
        Wo.forEach(t),
        jo.forEach(t),
        (Ed = i(Pt)),
        ($n = n(Pt, "TR", { class: !0 }));
      var Bh = s($n);
      rr = n(Bh, "TD", { class: !0 });
      var jh = s(rr);
      (so = n(jh, "SPAN", {})),
        s(so).forEach(t),
        jh.forEach(t),
        Bh.forEach(t),
        (el = i(Pt)),
        (Sn = n(Pt, "TR", { class: !0 }));
      var ir = s(Sn);
      tl = n(ir, "TD", {});
      var Wh = s(tl);
      (al = l(Wh, "The total number of FPL tokens to be sold.")),
        Wh.forEach(t),
        (wd = i(ir)),
        (nl = n(ir, "TD", {}));
      var Uh = s(nl);
      (Bt = l(Uh, "25,000,000 (25%)")),
        Uh.forEach(t),
        ir.forEach(t),
        (sl = i(Pt)),
        (Hn = n(Pt, "TR", { class: !0 }));
      var dr = s(Hn);
      rl = n(dr, "TD", {});
      var Nh = s(rl);
      (ll = l(Nh, "The maximum ICP to be raised.")),
        Nh.forEach(t),
        (Td = i(dr)),
        (ol = n(dr, "TD", {}));
      var Gh = s(ol);
      (il = l(Gh, "2,000,000")),
        Gh.forEach(t),
        dr.forEach(t),
        (Pd = i(Pt)),
        (Rn = n(Pt, "TR", { class: !0 }));
      var cr = s(Rn);
      Os = n(cr, "TD", {});
      var qh = s(Os);
      (Ld = l(
        qh,
        "The minimum ICP to be raised (otherwise sale fails and ICP returned)."
      )),
        qh.forEach(t),
        (kd = i(cr)),
        (Is = n(cr, "TD", {}));
      var Vh = s(Is);
      (Dd = l(Vh, "1,000,000")),
        Vh.forEach(t),
        cr.forEach(t),
        (Fd = i(Pt)),
        (nn = n(Pt, "TR", { class: !0 }));
      var hr = s(nn);
      dl = n(hr, "TD", {});
      var Jh = s(dl);
      (Od = l(Jh, "The ICP from the Community Fund.")),
        Jh.forEach(t),
        (cl = i(hr)),
        (hl = n(hr, "TD", {}));
      var Kh = s(hl);
      (Id = l(Kh, "Matched Funding Enabled")),
        Kh.forEach(t),
        hr.forEach(t),
        (ul = i(Pt)),
        (Mn = n(Pt, "TR", { class: !0 }));
      var ur = s(Mn);
      fl = n(ur, "TD", {});
      var zh = s(fl);
      (jt = l(zh, "Sale start date.")),
        zh.forEach(t),
        (pl = i(ur)),
        (ml = n(ur, "TD", {}));
      var Xh = s(ml);
      (xd = l(Xh, "1st March 2024")),
        Xh.forEach(t),
        ur.forEach(t),
        (vl = i(Pt)),
        (Bn = n(Pt, "TR", { class: !0 }));
      var Ot = s(Bn);
      gl = n(Ot, "TD", {});
      var Uo = s(gl);
      (bl = l(Uo, "Minimum number of sale participants.")),
        Uo.forEach(t),
        (Ad = i(Ot)),
        (yl = n(Ot, "TD", {}));
      var Qh = s(yl);
      (_l = l(Qh, "500")),
        Qh.forEach(t),
        Ot.forEach(t),
        (Cd = i(Pt)),
        (jn = n(Pt, "TR", { class: !0 }));
      var No = s(jn);
      xs = n(No, "TD", {});
      var Go = s(xs);
      ($d = l(Go, "Minimum ICP per buyer.")),
        Go.forEach(t),
        (Sd = i(No)),
        (As = n(No, "TD", {}));
      var Yh = s(As);
      (Hd = l(Yh, "10")),
        Yh.forEach(t),
        No.forEach(t),
        (Rd = i(Pt)),
        (sn = n(Pt, "TR", { class: !0 }));
      var qo = s(sn);
      El = n(qo, "TD", {});
      var Vo = s(El);
      (Md = l(Vo, "Maximum ICP per buyer.")),
        Vo.forEach(t),
        (wl = i(qo)),
        (Tl = n(qo, "TD", {}));
      var Zh = s(Tl);
      (Bd = l(Zh, "150,000")),
        Zh.forEach(t),
        qo.forEach(t),
        Pt.forEach(t),
        (Wt = i(_)),
        (Wn = n(_, "H2", { class: !0 }));
      var eu = s(Wn);
      (jd = l(eu, "Mitigation against a 51% Attack")),
        eu.forEach(t),
        (Wd = i(_)),
        (Un = n(_, "P", { class: !0 }));
      var Jo = s(Un);
      (Ud = l(
        Jo,
        `There is a danger that the OpenFPL SNS treasury could be the target of an
      attack. One possible scenario is for an attacker to buy a large proportion
      of the FPL tokens in the decentralisation sale and immediately increase
      the dissolve delay of all of their neurons to the maximum 4 year in an
      attempt to gain more than 50% of the SNS voting power. If successful they
      could force through a proposal to transfer the entire ICP and FPL treasury
      to themselves. The Community Fund actually provides a great deal of
      mitigation against this scenario because it limits the proportion of
      voting power an attacker would be able to acquire.`
      )),
        Jo.forEach(t),
        (Nd = i(_)),
        (Nn = n(_, "P", { class: !0 }));
      var tu = s(Nn);
      (Gd = l(
        tu,
        "The amount raised in the decentralisation will be used as follows:"
      )),
        tu.forEach(t),
        (qd = i(_)),
        (ga = n(_, "UL", { class: !0 }));
      var Zn = s(ga);
      Pl = n(Zn, "LI", {});
      var Ko = s(Pl);
      (Vd = l(
        Ko,
        `80% will be staked in an 8 year neuron with the maturity interest paid
        to the ICPFA.`
      )),
        Ko.forEach(t),
        (Ll = i(Zn)),
        (kl = n(Zn, "LI", {}));
      var au = s(kl);
      (Jd = l(
        au,
        `10% will be available for exchange liquidity to enable trading of the
        FPL token.`
      )),
        au.forEach(t),
        (Dl = i(Zn)),
        (Fl = n(Zn, "LI", {}));
      var nu = s(Fl);
      (Kd = l(
        nu,
        "5% will be paid directly to the ICPFA after the decentralisation sale."
      )),
        nu.forEach(t),
        (Ol = i(Zn)),
        (Il = n(Zn, "LI", {}));
      var zo = s(Il);
      (zd = l(
        zo,
        `5% will be held in reserve for cycles to run OpenFPL, likely to be
        unused as OpenFPL begins generating revenue.`
      )),
        zo.forEach(t),
        Zn.forEach(t),
        (xl = i(_)),
        (lr = n(_, "P", { class: !0 }));
      var su = s(lr);
      (Xd = l(
        su,
        `This treasury balance will be topped up with the DAO's revenue, with 50%
      being paid to neuron holders. Any excess balance can be utilised where the
      DAO sees fit.`
      )),
        su.forEach(t),
        (Ut = i(_)),
        (Gn = n(_, "H2", { class: !0 }));
      var ru = s(Gn);
      (Qd = l(ru, "Tokenomics")),
        ru.forEach(t),
        (Yd = i(_)),
        (qn = n(_, "P", { class: !0 }));
      var Xo = s(qn);
      (Zd = l(
        Xo,
        `Each season, 2.5% of the total $FPL supply will be minted for DAO rewards.
      There is no mechanism to automatically burn $FPL as we anticipate the user
      growth to be faster than the supply increase, thus increasing the price of
      $FPL. However a proposal can always be made to burn $FPL if required. If
      the DAO’s treasury is ever 60% or more of the total supply of $FPL, it
      will be ICP FA policy to raise a proposal to burn 5% of the total supply
      from the DAO’s treasury.`
      )),
        Xo.forEach(t),
        (ec = i(_)),
        (Vn = n(_, "H2", { class: !0 }));
      var lu = s(Vn);
      (tc = l(lu, "ICP FA Overview")),
        lu.forEach(t),
        (ac = i(_)),
        (Jn = n(_, "P", { class: !0 }));
      var ou = s(Jn);
      (nc = l(
        ou,
        `Managed by founder James Beadle, the ICP FA oversees the development,
      marketing, and management of OpenFPL. The aim is to build a strong team to
      guide OpenFPL's growth and bring new users to the ICP blockchain.
      Additionally, 25% of James' staked maturity earnings will contribute to
      the ICP FA Community Fund, supporting grassroots football projects.`
      )),
        ou.forEach(t),
        (sc = i(_)),
        (Kn = n(_, "P", { class: !0 }));
      var Qo = s(Kn);
      (rc = l(
        Qo,
        `The ICPFA will receive 5% of the decentralisation sale along with the
      maturity interest from the staked neuron. These funds will be use for the
      following:`
      )),
        Qo.forEach(t),
        (lc = i(_)),
        (ba = n(_, "UL", { class: !0 }));
      var es = s(ba);
      Al = n(es, "LI", {});
      var iu = s(Al);
      (oc = l(
        iu,
        "The ongoing promotion and marketing of OpenFPL both online and offline."
      )),
        iu.forEach(t),
        (Cl = i(es)),
        ($l = n(es, "LI", {}));
      var Yt = s($l);
      (ic = l(
        Yt,
        `Hiring of a frontend and backend developer to assist the founder with
        the day to day development workload.`
      )),
        Yt.forEach(t),
        (Sl = i(es)),
        (Hl = n(es, "LI", {}));
      var Yo = s(Hl);
      (dc = l(
        Yo,
        `Hiring of a UAT Test Engineer to ensure all ICPFA products are of the
        highest quality.`
      )),
        Yo.forEach(t),
        (Nt = i(es)),
        (Cs = n(es, "LI", {}));
      var du = s(Cs);
      (cc = l(du, "Hiring of a Marketing Manager.")),
        du.forEach(t),
        es.forEach(t),
        (hc = i(_)),
        (zn = n(_, "P", { class: !0 }));
      var cu = s(zn);
      (uc = l(cu, "Along with paying the founding team members:")),
        cu.forEach(t),
        (fc = i(_)),
        (fa = n(_, "UL", { class: !0 }));
      var wa = s(fa);
      Rl = n(wa, "LI", {});
      var hu = s(Rl);
      (pc = l(hu, "James Beadle - Founder, Lead Developer")),
        hu.forEach(t),
        (Ml = i(wa)),
        (Bl = n(wa, "LI", {}));
      var uu = s(Bl);
      (mc = l(uu, "DfinityDesigner - Designer")),
        uu.forEach(t),
        (jl = i(wa)),
        (Wl = n(wa, "LI", {}));
      var Zo = s(Wl);
      (vc = l(Zo, "George - Community Manager")),
        Zo.forEach(t),
        (Ul = i(wa)),
        (Nl = n(wa, "LI", {}));
      var fu = s(Nl);
      (gc = l(fu, "ICP_Insider - Blockchain Promoter")),
        fu.forEach(t),
        (Gl = i(wa)),
        (ql = n(wa, "LI", {}));
      var pu = s(ql);
      (bc = l(pu, "MadMaxIC - Gameplay Designer")),
        pu.forEach(t),
        wa.forEach(t),
        (Vl = i(_)),
        (Xn = n(_, "P", { class: !0 }));
      var fr = s(Xn);
      (yc = l(
        fr,
        "More details about the ICP FA and its members can be found at "
      )),
        (ht = n(fr, "A", { class: !0, href: !0 }));
      var mu = s(ht);
      (Jl = l(mu, "icpfa.org/team")),
        mu.forEach(t),
        (_c = l(fr, ".")),
        fr.forEach(t),
        _.forEach(t),
        or.forEach(t),
        this.h();
    },
    h() {
      c(u, "class", "text-3xl font-bold my-4"),
        c(b, "class", "text-xl font-bold"),
        c(L, "class", "my-2"),
        c(y, "class", "list-disc ml-4"),
        c(Y, "class", "text-lg font-bold mt-4"),
        c(_e, "class", "my-2"),
        c(j, "class", "list-disc ml-4"),
        c(W, "class", "my-2"),
        c(z, "class", "list-disc ml-4"),
        c(be, "class", "my-2"),
        c(q, "class", "list-disc ml-4"),
        c(m, "class", "my-2"),
        c(Ge, "class", "list-disc ml-4"),
        c(ha, "class", "text-lg font-bold mt-4"),
        c(ua, "class", "my-2"),
        c(gt, "class", "list-disc ml-4"),
        c(cn, "class", "mt-8"),
        c(hn, "class", "text-left px-4"),
        c(tt, "class", "text-right svelte-58jp75"),
        c(un, "class", "h-6"),
        c(za, "class", "svelte-58jp75"),
        c(fn, "class", "text-left px-4"),
        c(rt, "class", "svelte-58jp75"),
        c(Zs, "class", "h-6"),
        c(Ys, "class", "svelte-58jp75"),
        c(it, "class", "text-left px-4"),
        c(it, "colspan", "9"),
        c(tr, "class", "svelte-58jp75"),
        c(Fn, "class", "text-left px-4"),
        c(bt, "class", "svelte-58jp75"),
        c(On, "class", "text-left px-4"),
        c(_t, "class", "svelte-58jp75"),
        c(In, "class", "text-left px-4"),
        c(wt, "class", "svelte-58jp75"),
        c(pn, "colspan", "9"),
        c(pn, "class", "h-6"),
        c(ar, "class", "svelte-58jp75"),
        c(nr, "class", "text-left px-4"),
        c(dt, "class", "font-bold svelte-58jp75"),
        c(Ls, "colspan", "9"),
        c(Ls, "class", "h-6"),
        c(xn, "class", "svelte-58jp75"),
        c(ks, "class", "text-left px-4"),
        c(ks, "colspan", "8"),
        c(An, "class", "font-bold svelte-58jp75"),
        c(
          We,
          "class",
          "w-full text-right border-collapse striped mb-8 mt-4 svelte-58jp75"
        ),
        c(sr, "class", "text-lg font-bold mt-4"),
        c(Cn, "class", "svelte-58jp75"),
        c(rr, "class", "h-6"),
        c($n, "class", "svelte-58jp75"),
        c(Sn, "class", "svelte-58jp75"),
        c(Hn, "class", "svelte-58jp75"),
        c(Rn, "class", "svelte-58jp75"),
        c(nn, "class", "svelte-58jp75"),
        c(Mn, "class", "svelte-58jp75"),
        c(Bn, "class", "svelte-58jp75"),
        c(jn, "class", "svelte-58jp75"),
        c(sn, "class", "svelte-58jp75"),
        c(
          ct,
          "class",
          "w-full text-left border-collapse striped mb-8 mt-4 svelte-58jp75"
        ),
        c(Wn, "class", "text-lg font-bold mt-4"),
        c(Un, "class", "my-2"),
        c(Nn, "class", "my-2"),
        c(ga, "class", "list-disc ml-4"),
        c(lr, "class", "my-2"),
        c(Gn, "class", "text-lg font-bold mt-4"),
        c(qn, "class", "my-2"),
        c(Vn, "class", "text-lg font-bold mt-4"),
        c(Jn, "class", "my-2"),
        c(Kn, "class", "my-2"),
        c(ba, "class", "list-disc ml-4"),
        c(zn, "class", "my-2"),
        c(fa, "class", "list-disc ml-4"),
        c(ht, "class", "text-blue-500"),
        c(ht, "href", "https://icpfa.org/team"),
        c(Xn, "class", "my-2"),
        c(d, "class", "m-4"),
        c(h, "class", "container-fluid mx-auto p-4");
    },
    m(Kl, or) {
      $s(Kl, h, or),
        e(h, d),
        e(d, u),
        e(u, w),
        e(d, N),
        e(d, b),
        e(b, le),
        e(d, Z),
        e(d, L),
        e(L, Le),
        e(d, ke),
        e(d, y),
        e(y, J),
        e(J, oe),
        e(y, k),
        e(y, ie),
        e(ie, xe),
        e(y, A),
        e(y, K),
        e(K, de),
        e(y, C),
        e(y, ee),
        e(ee, Ae),
        e(y, $),
        e(y, V),
        e(V, Q),
        e(y, S),
        e(y, P),
        e(P, te),
        e(y, G),
        e(y, ce),
        e(ce, ae),
        e(y, T),
        e(y, ye),
        e(ye, De),
        e(d, R),
        e(d, Y),
        e(Y, Pe),
        e(d, he),
        e(d, _e),
        e(_e, Ue),
        e(d, ue),
        e(d, j),
        e(j, fe),
        e(fe, pe),
        e(j, Ce),
        e(j, Fe),
        e(Fe, me),
        e(j, ve),
        e(j, p),
        e(p, D),
        e(j, Ee),
        e(j, Ne),
        e(Ne, ge),
        e(d, H),
        e(d, W),
        e(W, F),
        e(d, He),
        e(d, z),
        e(z, ne),
        e(ne, we),
        e(z, Je),
        e(z, v),
        e(v, O),
        e(z, Oe),
        e(z, X),
        e(X, I),
        e(z, Re),
        e(z, se),
        e(se, Ke),
        e(z, Me),
        e(z, re),
        e(re, ze),
        e(d, Ie),
        e(d, be),
        e(be, f),
        e(d, $e),
        e(d, q),
        e(q, Qe),
        e(Qe, Se),
        e(q, Be),
        e(q, qe),
        e(qe, je),
        e(q, E),
        e(q, ut),
        e(ut, at),
        e(q, Ye),
        e(q, ft),
        e(ft, B),
        e(q, Ze),
        e(q, g),
        e(g, lt),
        e(d, pt),
        e(d, m),
        e(m, Lt),
        e(d, et),
        e(d, Ge),
        e(Ge, mt),
        e(mt, kt),
        e(Ge, Dt),
        e(Ge, Te),
        e(Te, It),
        e(Ge, xt),
        e(Ge, Zt),
        e(Zt, At),
        e(Ge, ia),
        e(Ge, ea),
        e(ea, Ct),
        e(Ge, da),
        e(Ge, ta),
        e(ta, $t),
        e(d, ca),
        e(d, ha),
        e(ha, ra),
        e(d, ya),
        e(d, ua),
        e(ua, la),
        e(d, _a),
        e(d, gt),
        e(gt, St),
        e(St, Xa),
        e(gt, Qa),
        e(gt, oa),
        e(oa, Ya),
        e(gt, as),
        e(gt, Ve),
        e(Ve, on),
        e(gt, dn),
        e(gt, Za),
        e(Za, U),
        e(d, Rs),
        e(d, cn),
        e(cn, mn),
        e(d, Ms),
        e(d, We),
        e(We, tt),
        e(tt, hn),
        e(hn, Bs),
        e(tt, vn),
        e(tt, gn),
        e(gn, ot),
        e(tt, bn),
        e(tt, yn),
        e(yn, js),
        e(tt, _n),
        e(tt, En),
        e(En, Ws),
        e(tt, wn),
        e(tt, Tn),
        e(Tn, Us),
        e(tt, vt),
        e(tt, en),
        e(en, va),
        e(tt, Ns),
        e(tt, tn),
        e(tn, Gs),
        e(tt, qs),
        e(tt, an),
        e(an, Vs),
        e(tt, Js),
        e(tt, Xe),
        e(Xe, Ks),
        e(We, zs),
        e(We, za),
        e(za, un),
        e(un, ns),
        e(We, Pn),
        e(We, rt),
        e(rt, fn),
        e(fn, Ln),
        e(rt, Xs),
        e(rt, kn),
        e(kn, Dn),
        e(rt, Qs),
        e(rt, mr),
        e(mr, Ht),
        e(rt, vr),
        e(rt, gr),
        e(gr, ti),
        e(rt, br),
        e(rt, yr),
        e(yr, ai),
        e(rt, _r),
        e(rt, Er),
        e(Er, ni),
        e(rt, wr),
        e(rt, Tr),
        e(Tr, si),
        e(rt, Pr),
        e(rt, Lr),
        e(Lr, ri),
        e(rt, kr),
        e(rt, Dr),
        e(Dr, li),
        e(We, Fr),
        e(We, Ys),
        e(Ys, Zs),
        e(Zs, er),
        e(We, oi),
        e(We, tr),
        e(tr, it),
        e(it, Or),
        e(We, ii),
        e(We, bt),
        e(bt, Fn),
        e(Fn, di),
        e(bt, ci),
        e(bt, ss),
        e(ss, hi),
        e(bt, ui),
        e(bt, rs),
        e(rs, fi),
        e(bt, pi),
        e(bt, ls),
        e(ls, mi),
        e(bt, vi),
        e(bt, os),
        e(os, gi),
        e(bt, bi),
        e(bt, is),
        e(is, yi),
        e(bt, _i),
        e(bt, ds),
        e(ds, Ei),
        e(bt, wi),
        e(bt, yt),
        e(yt, Ir),
        e(bt, Ti),
        e(bt, xr),
        e(xr, Ar),
        e(We, Pi),
        e(We, _t),
        e(_t, On),
        e(On, Li),
        e(_t, ki),
        e(_t, cs),
        e(cs, Di),
        e(_t, Fi),
        e(_t, hs),
        e(hs, Oi),
        e(_t, Ii),
        e(_t, us),
        e(us, xi),
        e(_t, Ai),
        e(_t, fs),
        e(fs, Ci),
        e(_t, $i),
        e(_t, ps),
        e(ps, Si),
        e(_t, Hi),
        e(_t, Et),
        e(Et, Cr),
        e(_t, Ri),
        e(_t, $r),
        e($r, Sr),
        e(_t, Mi),
        e(_t, Hr),
        e(Hr, Rr),
        e(We, Bi),
        e(We, wt),
        e(wt, In),
        e(In, ji),
        e(wt, Wi),
        e(wt, ms),
        e(ms, Ui),
        e(wt, Ni),
        e(wt, vs),
        e(vs, Gi),
        e(wt, qi),
        e(wt, gs),
        e(gs, Vi),
        e(wt, Ji),
        e(wt, bs),
        e(bs, Ki),
        e(wt, zi),
        e(wt, Tt),
        e(Tt, Mr),
        e(wt, Xi),
        e(wt, Br),
        e(Br, jr),
        e(wt, Qi),
        e(wt, Wr),
        e(Wr, Ur),
        e(wt, Yi),
        e(wt, Nr),
        e(Nr, Gr),
        e(We, Zi),
        e(We, ar),
        e(ar, pn),
        e(pn, ao),
        e(We, ed),
        e(We, dt),
        e(dt, nr),
        e(nr, td),
        e(dt, qr),
        e(dt, Vr),
        e(Vr, ad),
        e(dt, Jr),
        e(dt, Kr),
        e(Kr, nd),
        e(dt, Rt),
        e(dt, ys),
        e(ys, sd),
        e(dt, rd),
        e(dt, _s),
        e(_s, ld),
        e(dt, od),
        e(dt, Es),
        e(Es, id),
        e(dt, dd),
        e(dt, ws),
        e(ws, cd),
        e(dt, hd),
        e(dt, Ts),
        e(Ts, ud),
        e(dt, fd),
        e(dt, Ps),
        e(Ps, pd),
        e(We, md),
        e(We, xn),
        e(xn, Ls),
        e(Ls, no),
        e(We, zr),
        e(We, An),
        e(An, ks),
        e(ks, Mt),
        e(An, Xr),
        e(An, Qr),
        e(Qr, vd),
        e(d, Yr),
        e(d, sr),
        e(sr, gd),
        e(d, Zr),
        e(d, ct),
        e(ct, Cn),
        e(Cn, Ds),
        e(Ds, bd),
        e(Cn, yd),
        e(Cn, Fs),
        e(Fs, _d),
        e(ct, Ed),
        e(ct, $n),
        e($n, rr),
        e(rr, so),
        e(ct, el),
        e(ct, Sn),
        e(Sn, tl),
        e(tl, al),
        e(Sn, wd),
        e(Sn, nl),
        e(nl, Bt),
        e(ct, sl),
        e(ct, Hn),
        e(Hn, rl),
        e(rl, ll),
        e(Hn, Td),
        e(Hn, ol),
        e(ol, il),
        e(ct, Pd),
        e(ct, Rn),
        e(Rn, Os),
        e(Os, Ld),
        e(Rn, kd),
        e(Rn, Is),
        e(Is, Dd),
        e(ct, Fd),
        e(ct, nn),
        e(nn, dl),
        e(dl, Od),
        e(nn, cl),
        e(nn, hl),
        e(hl, Id),
        e(ct, ul),
        e(ct, Mn),
        e(Mn, fl),
        e(fl, jt),
        e(Mn, pl),
        e(Mn, ml),
        e(ml, xd),
        e(ct, vl),
        e(ct, Bn),
        e(Bn, gl),
        e(gl, bl),
        e(Bn, Ad),
        e(Bn, yl),
        e(yl, _l),
        e(ct, Cd),
        e(ct, jn),
        e(jn, xs),
        e(xs, $d),
        e(jn, Sd),
        e(jn, As),
        e(As, Hd),
        e(ct, Rd),
        e(ct, sn),
        e(sn, El),
        e(El, Md),
        e(sn, wl),
        e(sn, Tl),
        e(Tl, Bd),
        e(d, Wt),
        e(d, Wn),
        e(Wn, jd),
        e(d, Wd),
        e(d, Un),
        e(Un, Ud),
        e(d, Nd),
        e(d, Nn),
        e(Nn, Gd),
        e(d, qd),
        e(d, ga),
        e(ga, Pl),
        e(Pl, Vd),
        e(ga, Ll),
        e(ga, kl),
        e(kl, Jd),
        e(ga, Dl),
        e(ga, Fl),
        e(Fl, Kd),
        e(ga, Ol),
        e(ga, Il),
        e(Il, zd),
        e(d, xl),
        e(d, lr),
        e(lr, Xd),
        e(d, Ut),
        e(d, Gn),
        e(Gn, Qd),
        e(d, Yd),
        e(d, qn),
        e(qn, Zd),
        e(d, ec),
        e(d, Vn),
        e(Vn, tc),
        e(d, ac),
        e(d, Jn),
        e(Jn, nc),
        e(d, sc),
        e(d, Kn),
        e(Kn, rc),
        e(d, lc),
        e(d, ba),
        e(ba, Al),
        e(Al, oc),
        e(ba, Cl),
        e(ba, $l),
        e($l, ic),
        e(ba, Sl),
        e(ba, Hl),
        e(Hl, dc),
        e(ba, Nt),
        e(ba, Cs),
        e(Cs, cc),
        e(d, hc),
        e(d, zn),
        e(zn, uc),
        e(d, fc),
        e(d, fa),
        e(fa, Rl),
        e(Rl, pc),
        e(fa, Ml),
        e(fa, Bl),
        e(Bl, mc),
        e(fa, jl),
        e(fa, Wl),
        e(Wl, vc),
        e(fa, Ul),
        e(fa, Nl),
        e(Nl, gc),
        e(fa, Gl),
        e(fa, ql),
        e(ql, bc),
        e(d, Vl),
        e(d, Xn),
        e(Xn, yc),
        e(Xn, ht),
        e(ht, Jl),
        e(Xn, _c);
    },
    p: Jt,
    i: Jt,
    o: Jt,
    d(Kl) {
      Kl && t(h);
    },
  };
}
class tg extends zl {
  constructor(h) {
    super(), Xl(this, h, null, eg, Ql, {});
  }
}
function ag(x) {
  let h,
    d,
    u,
    w,
    N,
    b,
    le,
    Z,
    L,
    Le,
    ke,
    y,
    J,
    oe,
    k,
    ie,
    xe,
    A,
    K,
    de,
    C,
    ee,
    Ae,
    $,
    V;
  return {
    c() {
      (h = a("div")),
        (d = a("div")),
        (u = a("h1")),
        (w = r("Our Vision")),
        (N = o()),
        (b = a("p")),
        (le =
          r(`In an evolving landscape where blockchain technology is still unlocking
      its potential, the Internet Computer offers a promising platform for
      innovative applications. OpenFPL is one such initiative, aiming to
      transform fantasy Premier League football into a more engaging and
      decentralised experience.`)),
        (Z = o()),
        (L = a("p")),
        (Le =
          r(`Our goal is to develop this popular service into a decentralised
      autonomous organisation (DAO), rewarding fans for their insight and
      participation in football.`)),
        (ke = o()),
        (y = a("p")),
        (J =
          r(`Our vision for OpenFPL encompasses a commitment to societal impact,
      specifically through meaningful contributions to the ICPFA community fund.
      This effort is focused on supporting grassroots football initiatives,
      demonstrating our belief in OpenFPL's ability to bring about positive
      change in the football community.`)),
        (oe = o()),
        (k = a("p")),
        (ie =
          r(`OpenFPL aims to be recognised as more than just a digital platform; we
      aspire to build a brand that creates diverse revenue opportunities. Our
      economic model is designed to directly benefit our token holders,
      particularly those with staked neurons, through a fair distribution of
      rewards. This ensures that the value generated by the platform is shared
      within our community.`)),
        (xe = o()),
        (A = a("p")),
        (K =
          r(`Central to OpenFPL is our community focus. We strive to create a space
      where Premier League fans feel at home, with their input shaping the
      service. Our features, including community-based player valuations,
      customisable private leagues, and collaborations with football content
      creators, are all aimed at enhancing user engagement. As we attract more
      users, we expect an increased demand for our services, which will
      contribute to the growth and value of our governance token, $FPL.`)),
        (de = o()),
        (C = a("p")),
        (ee =
          r(`In essence, OpenFPL represents a unique blend of football passion and
      blockchain innovation. Our approach is about more than just reinventing
      fantasy sports; it's about building a vibrant community, pushing
      technological boundaries, and generating new economic opportunities.
      OpenFPL seeks to redefine the way fans engage with the sport they love,
      making a real impact in the football world.`)),
        (Ae = o()),
        ($ = a("p")),
        (V =
          r(`Innovation is at the heart of OpenFPL. We are excited about exploring the
      possibilities of integrating on-chain AI to assist managers with team
      selection. This endeavor is not just about enhancing the user experience;
      it's about exploring new frontiers for blockchain technology in sports.`)),
        this.h();
    },
    l(Q) {
      h = n(Q, "DIV", { class: !0 });
      var S = s(h);
      d = n(S, "DIV", { class: !0 });
      var P = s(d);
      u = n(P, "H1", { class: !0 });
      var te = s(u);
      (w = l(te, "Our Vision")),
        te.forEach(t),
        (N = i(P)),
        (b = n(P, "P", { class: !0 }));
      var G = s(b);
      (le = l(
        G,
        `In an evolving landscape where blockchain technology is still unlocking
      its potential, the Internet Computer offers a promising platform for
      innovative applications. OpenFPL is one such initiative, aiming to
      transform fantasy Premier League football into a more engaging and
      decentralised experience.`
      )),
        G.forEach(t),
        (Z = i(P)),
        (L = n(P, "P", { class: !0 }));
      var ce = s(L);
      (Le = l(
        ce,
        `Our goal is to develop this popular service into a decentralised
      autonomous organisation (DAO), rewarding fans for their insight and
      participation in football.`
      )),
        ce.forEach(t),
        (ke = i(P)),
        (y = n(P, "P", { class: !0 }));
      var ae = s(y);
      (J = l(
        ae,
        `Our vision for OpenFPL encompasses a commitment to societal impact,
      specifically through meaningful contributions to the ICPFA community fund.
      This effort is focused on supporting grassroots football initiatives,
      demonstrating our belief in OpenFPL's ability to bring about positive
      change in the football community.`
      )),
        ae.forEach(t),
        (oe = i(P)),
        (k = n(P, "P", { class: !0 }));
      var T = s(k);
      (ie = l(
        T,
        `OpenFPL aims to be recognised as more than just a digital platform; we
      aspire to build a brand that creates diverse revenue opportunities. Our
      economic model is designed to directly benefit our token holders,
      particularly those with staked neurons, through a fair distribution of
      rewards. This ensures that the value generated by the platform is shared
      within our community.`
      )),
        T.forEach(t),
        (xe = i(P)),
        (A = n(P, "P", { class: !0 }));
      var ye = s(A);
      (K = l(
        ye,
        `Central to OpenFPL is our community focus. We strive to create a space
      where Premier League fans feel at home, with their input shaping the
      service. Our features, including community-based player valuations,
      customisable private leagues, and collaborations with football content
      creators, are all aimed at enhancing user engagement. As we attract more
      users, we expect an increased demand for our services, which will
      contribute to the growth and value of our governance token, $FPL.`
      )),
        ye.forEach(t),
        (de = i(P)),
        (C = n(P, "P", { class: !0 }));
      var De = s(C);
      (ee = l(
        De,
        `In essence, OpenFPL represents a unique blend of football passion and
      blockchain innovation. Our approach is about more than just reinventing
      fantasy sports; it's about building a vibrant community, pushing
      technological boundaries, and generating new economic opportunities.
      OpenFPL seeks to redefine the way fans engage with the sport they love,
      making a real impact in the football world.`
      )),
        De.forEach(t),
        (Ae = i(P)),
        ($ = n(P, "P", { class: !0 }));
      var R = s($);
      (V = l(
        R,
        `Innovation is at the heart of OpenFPL. We are excited about exploring the
      possibilities of integrating on-chain AI to assist managers with team
      selection. This endeavor is not just about enhancing the user experience;
      it's about exploring new frontiers for blockchain technology in sports.`
      )),
        R.forEach(t),
        P.forEach(t),
        S.forEach(t),
        this.h();
    },
    h() {
      c(u, "class", "text-3xl font-bold"),
        c(b, "class", "my-4"),
        c(L, "class", "my-4"),
        c(y, "class", "my-4"),
        c(k, "class", "my-4"),
        c(A, "class", "my-4"),
        c(C, "class", "my-4"),
        c($, "class", "my-4"),
        c(d, "class", "m-4"),
        c(h, "class", "container-fluid mx-auto p-4");
    },
    m(Q, S) {
      $s(Q, h, S),
        e(h, d),
        e(d, u),
        e(u, w),
        e(d, N),
        e(d, b),
        e(b, le),
        e(d, Z),
        e(d, L),
        e(L, Le),
        e(d, ke),
        e(d, y),
        e(y, J),
        e(d, oe),
        e(d, k),
        e(k, ie),
        e(d, xe),
        e(d, A),
        e(A, K),
        e(d, de),
        e(d, C),
        e(C, ee),
        e(d, Ae),
        e(d, $),
        e($, V);
    },
    p: Jt,
    i: Jt,
    o: Jt,
    d(Q) {
      Q && t(h);
    },
  };
}
class ng extends zl {
  constructor(h) {
    super(), Xl(this, h, null, ag, Ql, {});
  }
}
function sg(x) {
  let h, d;
  return (
    (h = new N1({})),
    {
      c() {
        Yl(h.$$.fragment);
      },
      l(u) {
        Zl(h.$$.fragment, u);
      },
      m(u, w) {
        eo(h, u, w), (d = !0);
      },
      i(u) {
        d || (Ss(h.$$.fragment, u), (d = !0));
      },
      o(u) {
        Hs(h.$$.fragment, u), (d = !1);
      },
      d(u) {
        to(h, u);
      },
    }
  );
}
function rg(x) {
  let h, d;
  return (
    (h = new tg({})),
    {
      c() {
        Yl(h.$$.fragment);
      },
      l(u) {
        Zl(h.$$.fragment, u);
      },
      m(u, w) {
        eo(h, u, w), (d = !0);
      },
      i(u) {
        d || (Ss(h.$$.fragment, u), (d = !0));
      },
      o(u) {
        Hs(h.$$.fragment, u), (d = !1);
      },
      d(u) {
        to(h, u);
      },
    }
  );
}
function lg(x) {
  let h, d;
  return (
    (h = new q1({})),
    {
      c() {
        Yl(h.$$.fragment);
      },
      l(u) {
        Zl(h.$$.fragment, u);
      },
      m(u, w) {
        eo(h, u, w), (d = !0);
      },
      i(u) {
        d || (Ss(h.$$.fragment, u), (d = !0));
      },
      o(u) {
        Hs(h.$$.fragment, u), (d = !1);
      },
      d(u) {
        to(h, u);
      },
    }
  );
}
function og(x) {
  let h, d;
  return (
    (h = new Q1({})),
    {
      c() {
        Yl(h.$$.fragment);
      },
      l(u) {
        Zl(h.$$.fragment, u);
      },
      m(u, w) {
        eo(h, u, w), (d = !0);
      },
      i(u) {
        d || (Ss(h.$$.fragment, u), (d = !0));
      },
      o(u) {
        Hs(h.$$.fragment, u), (d = !1);
      },
      d(u) {
        to(h, u);
      },
    }
  );
}
function ig(x) {
  let h, d;
  return (
    (h = new z1({})),
    {
      c() {
        Yl(h.$$.fragment);
      },
      l(u) {
        Zl(h.$$.fragment, u);
      },
      m(u, w) {
        eo(h, u, w), (d = !0);
      },
      i(u) {
        d || (Ss(h.$$.fragment, u), (d = !0));
      },
      o(u) {
        Hs(h.$$.fragment, u), (d = !1);
      },
      d(u) {
        to(h, u);
      },
    }
  );
}
function dg(x) {
  let h, d;
  return (
    (h = new Z1({})),
    {
      c() {
        Yl(h.$$.fragment);
      },
      l(u) {
        Zl(h.$$.fragment, u);
      },
      m(u, w) {
        eo(h, u, w), (d = !0);
      },
      i(u) {
        d || (Ss(h.$$.fragment, u), (d = !0));
      },
      o(u) {
        Hs(h.$$.fragment, u), (d = !1);
      },
      d(u) {
        to(h, u);
      },
    }
  );
}
function cg(x) {
  let h, d;
  return (
    (h = new J1({})),
    {
      c() {
        Yl(h.$$.fragment);
      },
      l(u) {
        Zl(h.$$.fragment, u);
      },
      m(u, w) {
        eo(h, u, w), (d = !0);
      },
      i(u) {
        d || (Ss(h.$$.fragment, u), (d = !0));
      },
      o(u) {
        Hs(h.$$.fragment, u), (d = !1);
      },
      d(u) {
        to(h, u);
      },
    }
  );
}
function hg(x) {
  let h, d;
  return (
    (h = new ng({})),
    {
      c() {
        Yl(h.$$.fragment);
      },
      l(u) {
        Zl(h.$$.fragment, u);
      },
      m(u, w) {
        eo(h, u, w), (d = !0);
      },
      i(u) {
        d || (Ss(h.$$.fragment, u), (d = !0));
      },
      o(u) {
        Hs(h.$$.fragment, u), (d = !1);
      },
      d(u) {
        to(h, u);
      },
    }
  );
}
function ug(x) {
  let h,
    d,
    u,
    w,
    N,
    b,
    le,
    Z,
    L,
    Le,
    ke,
    y,
    J,
    oe,
    k,
    ie,
    xe,
    A,
    K,
    de,
    C,
    ee,
    Ae,
    $,
    V,
    Q,
    S,
    P,
    te,
    G,
    ce,
    ae,
    T,
    ye,
    De,
    R,
    Y,
    Pe,
    he,
    _e,
    Ue,
    ue,
    j,
    fe,
    pe,
    Ce,
    Fe,
    me,
    ve,
    p,
    D,
    Ee,
    Ne,
    ge,
    H,
    W,
    F,
    He,
    z;
  const ne = [hg, cg, dg, ig, og, lg, rg, sg],
    we = [];
  function Je(v, O) {
    return v[0] === "vision"
      ? 0
      : v[0] === "gameplay"
      ? 1
      : v[0] === "roadmap"
      ? 2
      : v[0] === "marketing"
      ? 3
      : v[0] === "revenue"
      ? 4
      : v[0] === "dao"
      ? 5
      : v[0] === "tokenomics"
      ? 6
      : v[0] === "architecture"
      ? 7
      : -1;
  }
  return (
    ~(H = Je(x)) && (W = we[H] = ne[H](x)),
    {
      c() {
        (h = a("div")),
          (d = a("h1")),
          (u = r("OpenFPL Whitepaper")),
          (w = o()),
          (N = a("div")),
          (b = a("ul")),
          (le = a("li")),
          (Z = a("button")),
          (L = r("Vision")),
          (y = o()),
          (J = a("li")),
          (oe = a("button")),
          (k = r("Gameplay")),
          (A = o()),
          (K = a("li")),
          (de = a("button")),
          (C = r("Roadmap")),
          ($ = o()),
          (V = a("li")),
          (Q = a("button")),
          (S = r("Marketing")),
          (G = o()),
          (ce = a("li")),
          (ae = a("button")),
          (T = r("Revenue")),
          (R = o()),
          (Y = a("li")),
          (Pe = a("button")),
          (he = r("DAO")),
          (ue = o()),
          (j = a("li")),
          (fe = a("button")),
          (pe = r("Tokenomics")),
          (me = o()),
          (ve = a("li")),
          (p = a("button")),
          (D = r("Architecture")),
          (ge = o()),
          W && W.c(),
          this.h();
      },
      l(v) {
        h = n(v, "DIV", { class: !0 });
        var O = s(h);
        d = n(O, "H1", { class: !0 });
        var Oe = s(d);
        (u = l(Oe, "OpenFPL Whitepaper")),
          Oe.forEach(t),
          O.forEach(t),
          (w = i(v)),
          (N = n(v, "DIV", { class: !0 }));
        var X = s(N);
        b = n(X, "UL", { class: !0 });
        var I = s(b);
        le = n(I, "LI", { class: !0 });
        var Re = s(le);
        Z = n(Re, "BUTTON", { class: !0 });
        var se = s(Z);
        (L = l(se, "Vision")),
          se.forEach(t),
          Re.forEach(t),
          (y = i(I)),
          (J = n(I, "LI", { class: !0 }));
        var Ke = s(J);
        oe = n(Ke, "BUTTON", { class: !0 });
        var Me = s(oe);
        (k = l(Me, "Gameplay")),
          Me.forEach(t),
          Ke.forEach(t),
          (A = i(I)),
          (K = n(I, "LI", { class: !0 }));
        var re = s(K);
        de = n(re, "BUTTON", { class: !0 });
        var ze = s(de);
        (C = l(ze, "Roadmap")),
          ze.forEach(t),
          re.forEach(t),
          ($ = i(I)),
          (V = n(I, "LI", { class: !0 }));
        var Ie = s(V);
        Q = n(Ie, "BUTTON", { class: !0 });
        var be = s(Q);
        (S = l(be, "Marketing")),
          be.forEach(t),
          Ie.forEach(t),
          (G = i(I)),
          (ce = n(I, "LI", { class: !0 }));
        var f = s(ce);
        ae = n(f, "BUTTON", { class: !0 });
        var $e = s(ae);
        (T = l($e, "Revenue")),
          $e.forEach(t),
          f.forEach(t),
          (R = i(I)),
          (Y = n(I, "LI", { class: !0 }));
        var q = s(Y);
        Pe = n(q, "BUTTON", { class: !0 });
        var Qe = s(Pe);
        (he = l(Qe, "DAO")),
          Qe.forEach(t),
          q.forEach(t),
          (ue = i(I)),
          (j = n(I, "LI", { class: !0 }));
        var Se = s(j);
        fe = n(Se, "BUTTON", { class: !0 });
        var Be = s(fe);
        (pe = l(Be, "Tokenomics")),
          Be.forEach(t),
          Se.forEach(t),
          (me = i(I)),
          (ve = n(I, "LI", { class: !0 }));
        var qe = s(ve);
        p = n(qe, "BUTTON", { class: !0 });
        var je = s(p);
        (D = l(je, "Architecture")),
          je.forEach(t),
          qe.forEach(t),
          I.forEach(t),
          (ge = i(X)),
          W && W.l(X),
          X.forEach(t),
          this.h();
      },
      h() {
        c(d, "class", "p-4 mx-1 text-2xl"),
          c(h, "class", "bg-panel rounded-lg mx-4 mt-4"),
          c(
            Z,
            "class",
            (Le = `p-2 ${x[0] === "vision" ? "text-white" : "text-gray-400"}`)
          ),
          c(
            le,
            "class",
            (ke = `mr-4 text-xs md:text-base ${
              x[0] === "vision" ? "active-tab" : ""
            }`)
          ),
          c(
            oe,
            "class",
            (ie = `p-2 ${x[0] === "gameplay" ? "text-white" : "text-gray-400"}`)
          ),
          c(
            J,
            "class",
            (xe = `mr-4 text-xs md:text-base ${
              x[0] === "gameplay" ? "active-tab" : ""
            }`)
          ),
          c(
            de,
            "class",
            (ee = `p-2 ${x[0] === "roadmap" ? "text-white" : "text-gray-400"}`)
          ),
          c(
            K,
            "class",
            (Ae = `mr-4 text-xs md:text-base ${
              x[0] === "roadmap" ? "active-tab" : ""
            }`)
          ),
          c(
            Q,
            "class",
            (P = `p-2 ${x[0] === "marketing" ? "text-white" : "text-gray-400"}`)
          ),
          c(
            V,
            "class",
            (te = `mr-4 text-xs md:text-base ${
              x[0] === "marketing" ? "active-tab" : ""
            }`)
          ),
          c(
            ae,
            "class",
            (ye = `p-2 ${x[0] === "revenue" ? "text-white" : "text-gray-400"}`)
          ),
          c(
            ce,
            "class",
            (De = `mr-4 text-xs md:text-base ${
              x[0] === "revenue" ? "active-tab" : ""
            }`)
          ),
          c(
            Pe,
            "class",
            (_e = `p-2 ${x[0] === "dao" ? "text-white" : "text-gray-400"}`)
          ),
          c(
            Y,
            "class",
            (Ue = `mr-4 text-xs md:text-base ${
              x[0] === "dao" ? "active-tab" : ""
            }`)
          ),
          c(
            fe,
            "class",
            (Ce = `p-2 ${
              x[0] === "tokenomics" ? "text-white" : "text-gray-400"
            }`)
          ),
          c(
            j,
            "class",
            (Fe = `mr-4 text-xs md:text-base ${
              x[0] === "tokenomics" ? "active-tab" : ""
            }`)
          ),
          c(
            p,
            "class",
            (Ee = `p-2 ${
              x[0] === "architecture" ? "text-white" : "text-gray-400"
            }`)
          ),
          c(
            ve,
            "class",
            (Ne = `mr-4 text-xs md:text-base ${
              x[0] === "architecture" ? "active-tab" : ""
            }`)
          ),
          c(b, "class", "flex rounded-t-lg bg-light-gray px-4 pt-2"),
          c(N, "class", "bg-panel rounded-lg m-4");
      },
      m(v, O) {
        $s(v, h, O),
          e(h, d),
          e(d, u),
          $s(v, w, O),
          $s(v, N, O),
          e(N, b),
          e(b, le),
          e(le, Z),
          e(Z, L),
          e(b, y),
          e(b, J),
          e(J, oe),
          e(oe, k),
          e(b, A),
          e(b, K),
          e(K, de),
          e(de, C),
          e(b, $),
          e(b, V),
          e(V, Q),
          e(Q, S),
          e(b, G),
          e(b, ce),
          e(ce, ae),
          e(ae, T),
          e(b, R),
          e(b, Y),
          e(Y, Pe),
          e(Pe, he),
          e(b, ue),
          e(b, j),
          e(j, fe),
          e(fe, pe),
          e(b, me),
          e(b, ve),
          e(ve, p),
          e(p, D),
          e(N, ge),
          ~H && we[H].m(N, null),
          (F = !0),
          He ||
            ((z = [
              ei(Z, "click", x[2]),
              ei(oe, "click", x[3]),
              ei(de, "click", x[4]),
              ei(Q, "click", x[5]),
              ei(ae, "click", x[6]),
              ei(Pe, "click", x[7]),
              ei(fe, "click", x[8]),
              ei(p, "click", x[9]),
            ]),
            (He = !0));
      },
      p(v, O) {
        (!F ||
          (O & 1 &&
            Le !==
              (Le = `p-2 ${
                v[0] === "vision" ? "text-white" : "text-gray-400"
              }`))) &&
          c(Z, "class", Le),
          (!F ||
            (O & 1 &&
              ke !==
                (ke = `mr-4 text-xs md:text-base ${
                  v[0] === "vision" ? "active-tab" : ""
                }`))) &&
            c(le, "class", ke),
          (!F ||
            (O & 1 &&
              ie !==
                (ie = `p-2 ${
                  v[0] === "gameplay" ? "text-white" : "text-gray-400"
                }`))) &&
            c(oe, "class", ie),
          (!F ||
            (O & 1 &&
              xe !==
                (xe = `mr-4 text-xs md:text-base ${
                  v[0] === "gameplay" ? "active-tab" : ""
                }`))) &&
            c(J, "class", xe),
          (!F ||
            (O & 1 &&
              ee !==
                (ee = `p-2 ${
                  v[0] === "roadmap" ? "text-white" : "text-gray-400"
                }`))) &&
            c(de, "class", ee),
          (!F ||
            (O & 1 &&
              Ae !==
                (Ae = `mr-4 text-xs md:text-base ${
                  v[0] === "roadmap" ? "active-tab" : ""
                }`))) &&
            c(K, "class", Ae),
          (!F ||
            (O & 1 &&
              P !==
                (P = `p-2 ${
                  v[0] === "marketing" ? "text-white" : "text-gray-400"
                }`))) &&
            c(Q, "class", P),
          (!F ||
            (O & 1 &&
              te !==
                (te = `mr-4 text-xs md:text-base ${
                  v[0] === "marketing" ? "active-tab" : ""
                }`))) &&
            c(V, "class", te),
          (!F ||
            (O & 1 &&
              ye !==
                (ye = `p-2 ${
                  v[0] === "revenue" ? "text-white" : "text-gray-400"
                }`))) &&
            c(ae, "class", ye),
          (!F ||
            (O & 1 &&
              De !==
                (De = `mr-4 text-xs md:text-base ${
                  v[0] === "revenue" ? "active-tab" : ""
                }`))) &&
            c(ce, "class", De),
          (!F ||
            (O & 1 &&
              _e !==
                (_e = `p-2 ${
                  v[0] === "dao" ? "text-white" : "text-gray-400"
                }`))) &&
            c(Pe, "class", _e),
          (!F ||
            (O & 1 &&
              Ue !==
                (Ue = `mr-4 text-xs md:text-base ${
                  v[0] === "dao" ? "active-tab" : ""
                }`))) &&
            c(Y, "class", Ue),
          (!F ||
            (O & 1 &&
              Ce !==
                (Ce = `p-2 ${
                  v[0] === "tokenomics" ? "text-white" : "text-gray-400"
                }`))) &&
            c(fe, "class", Ce),
          (!F ||
            (O & 1 &&
              Fe !==
                (Fe = `mr-4 text-xs md:text-base ${
                  v[0] === "tokenomics" ? "active-tab" : ""
                }`))) &&
            c(j, "class", Fe),
          (!F ||
            (O & 1 &&
              Ee !==
                (Ee = `p-2 ${
                  v[0] === "architecture" ? "text-white" : "text-gray-400"
                }`))) &&
            c(p, "class", Ee),
          (!F ||
            (O & 1 &&
              Ne !==
                (Ne = `mr-4 text-xs md:text-base ${
                  v[0] === "architecture" ? "active-tab" : ""
                }`))) &&
            c(ve, "class", Ne);
        let Oe = H;
        (H = Je(v)),
          H !== Oe &&
            (W &&
              (M1(),
              Hs(we[Oe], 1, 1, () => {
                we[Oe] = null;
              }),
              B1()),
            ~H
              ? ((W = we[H]),
                W || ((W = we[H] = ne[H](v)), W.c()),
                Ss(W, 1),
                W.m(N, null))
              : (W = null));
      },
      i(v) {
        F || (Ss(W), (F = !0));
      },
      o(v) {
        Hs(W), (F = !1);
      },
      d(v) {
        v && t(h), v && t(w), v && t(N), ~H && we[H].d(), (He = !1), j1(z);
      },
    }
  );
}
function fg(x) {
  let h, d;
  return (
    (h = new W1({
      props: { $$slots: { default: [ug] }, $$scope: { ctx: x } },
    })),
    {
      c() {
        Yl(h.$$.fragment);
      },
      l(u) {
        Zl(h.$$.fragment, u);
      },
      m(u, w) {
        eo(h, u, w), (d = !0);
      },
      p(u, [w]) {
        const N = {};
        w & 1025 && (N.$$scope = { dirty: w, ctx: u }), h.$set(N);
      },
      i(u) {
        d || (Ss(h.$$.fragment, u), (d = !0));
      },
      o(u) {
        Hs(h.$$.fragment, u), (d = !1);
      },
      d(u) {
        to(h, u);
      },
    }
  );
}
function pg(x, h, d) {
  let u = "vision";
  function w(J) {
    d(0, (u = J));
  }
  return [
    u,
    w,
    () => w("vision"),
    () => w("gameplay"),
    () => w("roadmap"),
    () => w("marketing"),
    () => w("revenue"),
    () => w("dao"),
    () => w("tokenomics"),
    () => w("architecture"),
  ];
}
class gg extends zl {
  constructor(h) {
    super(), Xl(this, h, pg, fg, Ql, {});
  }
}
export { gg as component };