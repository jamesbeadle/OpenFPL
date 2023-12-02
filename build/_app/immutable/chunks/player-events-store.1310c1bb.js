import { f as H } from "./fixture-store.880a736f.js";
import { A as x, n as B, r as L } from "./Layout.3f9368f3.js";
import { p as k } from "./player-store.f12f3662.js";
import { w as g } from "./singletons.e655d5e5.js";
import { s as M } from "./team-store.583260fe.js";
function J() {
  const { subscribe: C, set: v } = g([]);
  let h;
  M.subscribe((e) => {
    h = e;
  });
  let E;
  H.subscribe((e) => (E = e));
  let f = x.createActor(B, "pec6o-uqaaa-aaaal-qb7eq-cai");
  async function F() {
    let e = "playerEventData",
      s = (await f.getDataHashes()).find((o) => o.category === e) ?? null;
    const a = localStorage.getItem(e);
    if (s?.hash != a) {
      let o = await f.getPlayerDetailsForGameweek(
        h.activeSeason.id,
        h.focusGameweek
      );
      localStorage.setItem("player_events_data", JSON.stringify(o, L)),
        localStorage.setItem(e, s?.hash ?? ""),
        v(o);
    } else {
      const o = localStorage.getItem("player_events_data");
      let t = [];
      try {
        t = JSON.parse(o || "[]");
      } catch {
        t = [];
      }
      v(t);
    }
  }
  async function G() {
    const e = localStorage.getItem("player_events_data");
    let r;
    try {
      r = JSON.parse(e || "[]");
    } catch {
      r = [];
    }
    return r;
  }
  async function _(e, r) {
    try {
      return await f.getPlayerDetails(e, r);
    } catch (s) {
      throw (console.error("Error fetching player data:", s), s);
    }
  }
  async function N(e, r) {
    await F();
    let s = [];
    h?.focusGameweek === r
      ? (s = await G())
      : (s = await f.getPlayersDetailsForGameweek(
          e.playerIds,
          h?.activeSeason.id,
          r
        ));
    let a = [];
    k.subscribe((l) => {
      a = l.filter((i) => e.playerIds.includes(i.id));
    })();
    const y = (
      await Promise.all(
        a.map(
          async (l) =>
            await A(
              s.find((i) => i.id == l.id),
              l
            )
        )
      )
    ).map((l) => {
      const i = R(l, E),
        n = w(l, e, i),
        b = l.player.id === e.captainId ? i + n : 0;
      return { ...l, points: i, bonusPoints: n, totalPoints: i + n + b };
    });
    return await Promise.all(y);
  }
  async function A(e, r) {
    let s = 0,
      a = 0,
      o = 0,
      t = 0,
      y = 0,
      l = 0,
      i = 0,
      n = 0,
      b = 0,
      u = 0,
      P = 0,
      p = 0,
      c = 0,
      S = 0,
      I = 0,
      d = 0;
    return (
      e.events.forEach((q) => {
        switch (q.eventType) {
          case 0:
            P += 1;
            break;
          case 1:
            switch (((s += 1), e.position)) {
              case 0:
              case 1:
                c += 20;
                break;
              case 2:
                c += 15;
                break;
              case 3:
                c += 10;
                break;
            }
            break;
          case 2:
            switch (((a += 1), e.position)) {
              case 0:
              case 1:
                S += 15;
                break;
              case 2:
              case 3:
                S += 10;
                break;
            }
            break;
          case 3:
            (u += 1), e.position < 2 && u % 2 === 0 && (I += -15);
            break;
          case 4:
            i += 1;
            break;
          case 5:
            (n += 1), e.position < 2 && u === 0 && (d += 10);
            break;
          case 6:
            b += 1;
            break;
          case 7:
            y += 1;
            break;
          case 8:
            t += 1;
            break;
          case 9:
            o += 1;
            break;
          case 10:
            l += 1;
            break;
          case 11:
            p += 1;
            break;
        }
      }),
      {
        player: r,
        points: e.points,
        appearance: P,
        goals: s,
        assists: a,
        goalsConceded: u,
        saves: i,
        cleanSheets: n,
        penaltySaves: b,
        missedPenalties: y,
        yellowCards: t,
        redCards: o,
        ownGoals: l,
        highestScoringPlayerId: p,
        goalPoints: c,
        assistPoints: S,
        goalsConcededPoints: I,
        cleanSheetPoints: d,
        gameweek: e.gameweek,
        bonusPoints: 0,
        totalPoints: 0,
      }
    );
  }
  function R(e, r) {
    if (!e) return console.error("No gameweek data found:", e), 0;
    let s = 0,
      a = 5,
      o = 5,
      t = 20,
      y = 25,
      l = -20,
      i = -10,
      n = -15,
      b = -10,
      u = -5,
      P = 10;
    var p = 0,
      c = 0;
    switch (
      (e.appearance > 0 && (s += a * e.appearance),
      e.redCards > 0 && (s += l),
      e.missedPenalties > 0 && (s += i * e.missedPenalties),
      e.ownGoals > 0 && (s += b * e.ownGoals),
      e.yellowCards > 0 && (s += u * e.yellowCards),
      e.player.position)
    ) {
      case 0:
        (p = 20),
          (c = 15),
          e.saves >= 3 && (s += Math.floor(e.saves / 3) * o),
          e.penaltySaves && (s += t * e.penaltySaves),
          e.cleanSheets > 0 && (s += P),
          e.goalsConceded >= 2 && (s += Math.floor(e.goalsConceded / 2) * n);
        break;
      case 1:
        (p = 20),
          (c = 15),
          e.cleanSheets > 0 && (s += P),
          e.goalsConceded >= 2 && (s += Math.floor(e.goalsConceded / 2) * n);
        break;
      case 2:
        (p = 15), (c = 10);
        break;
      case 3:
        (p = 10), (c = 10);
        break;
    }
    return (
      (r ? r.filter((d) => d.gameweek === e.gameweek) : []).find(
        (d) =>
          (d.homeTeamId === e.player.teamId ||
            d.awayTeamId === e.player.teamId) &&
          d.highestScoringPlayerId === e.player.id
      ) && (s += y),
      (s += e.goals * p),
      (s += e.assists * c),
      s
    );
  }
  function w(e, r, s) {
    if (!e) return console.error("No gameweek data found:", e), 0;
    let a = 0;
    var o = 0,
      t = 0;
    switch (e.player.position) {
      case 0:
        (o = 20), (t = 15);
        break;
      case 1:
        (o = 20), (t = 15);
        break;
      case 2:
        (o = 15), (t = 10);
        break;
      case 3:
        (o = 10), (t = 10);
        break;
    }
    return (
      r.goalGetterGameweek === e.gameweek &&
        r.goalGetterPlayerId === e.player.id &&
        (a = e.goals * o * 2),
      r.passMasterGameweek === e.gameweek &&
        r.passMasterPlayerId === e.player.id &&
        (a = e.assists * t * 2),
      r.noEntryGameweek === e.gameweek &&
        r.noEntryPlayerId === e.player.id &&
        (e.player.position === 0 || e.player.position === 1) &&
        e.cleanSheets &&
        (a = s * 2),
      r.safeHandsGameweek === e.gameweek &&
        e.player.position === 0 &&
        e.saves >= 5 &&
        (a = s * 2),
      r.captainFantasticGameweek === e.gameweek &&
        r.captainId === e.player.id &&
        e.goals > 0 &&
        (a = s),
      r.braceBonusGameweek === e.gameweek && e.goals >= 2 && (a = s),
      r.hatTrickHeroGameweek === e.gameweek && e.goals >= 3 && (a = s * 2),
      r.teamBoostGameweek === e.gameweek &&
        e.player.teamId === r.teamBoostTeamId &&
        (a = s),
      a
    );
  }
  return { subscribe: C, sync: F, getPlayerDetails: _, getGameweekPlayers: N };
}
const X = J();
export { X as p };
