import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";
import type { TeamStats } from "$lib/types/team-stats";
import * as FlagIcons from "svelte-flag-icons";

import type { GameweekData } from "$lib/interfaces/GameweekData";
import EnglandFlag from "../flags/england.svelte";
import ScotlandFlag from "../flags/scotland.svelte";
import WalesFlag from "../flags/wales.svelte";
import NorthernIrelandFlag from "../flags/northern_ireland.svelte";
import type {
  Club,
  Fixture,
  FixtureStatusType,
  Player,
  PlayerEventType,
  PlayerPoints,
  PlayerPosition,
  FantasyTeamSnapshot,
  LeaderboardEntry,
  MembershipType,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export function uint8ArrayToBase64(bytes: Uint8Array): string {
  const binary = Array.from(bytes)
    .map((byte) => String.fromCharCode(byte))
    .join("");
  return btoa(binary);
}

export function formatUnixDateToReadable(unixNano: bigint) {
  const date = new Date(Number(unixNano) / 1000000);
  const options: Intl.DateTimeFormatOptions = {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  };

  return new Intl.DateTimeFormat("en-UK", options).format(date);
}

export function formatUnixDateToSmallReadable(unixNano: bigint) {
  const date = new Date(Number(unixNano) / 1000000);
  const options: Intl.DateTimeFormatOptions = {
    year: "numeric",
    month: "short",
    day: "numeric",
  };

  return new Intl.DateTimeFormat("en-UK", options).format(date);
}

export function getCountdownTime(unixNano: bigint) {
  const targetDate = new Date(Number(unixNano) / 1000000);
  const now = new Date();
  const diff = targetDate.getTime() - now.getTime();

  if (diff <= 0) {
    return { days: 0, hours: 0, minutes: 0 };
  }

  const days = Math.floor(diff / (1000 * 60 * 60 * 24));
  const hours = Math.floor((diff / (1000 * 60 * 60)) % 24);
  const minutes = Math.floor((diff / (1000 * 60)) % 60);

  return { days, hours, minutes };
}

export function replacer(key: string, value: bigint) {
  if (typeof value === "bigint") {
    return value.toString();
  } else {
    return value;
  }
}

export function formatUnixTimeToTime(unixNano: bigint): string {
  const unixTimeMillis = Number(unixNano) / 1000000;
  const date = new Date(unixTimeMillis);

  const options: Intl.DateTimeFormatOptions = {
    hour: "numeric",
    minute: "numeric",
    hour12: true,
    timeZone: "Europe/London",
  };

  return new Intl.DateTimeFormat("en-GB", options).format(date);
}

export function formatUnixDateTimeToReadable(unixNano: bigint): string {
  const date = new Date(Number(unixNano) / 1000000);

  const dateOptions: Intl.DateTimeFormatOptions = {
    day: "numeric",
    month: "short",
    year: "numeric",
  };
  const formattedDate = new Intl.DateTimeFormat("en-UK", dateOptions).format(
    date,
  );

  const timeOptions: Intl.DateTimeFormatOptions = {
    hour: "numeric",
    minute: "numeric",
    hour12: true,
    timeZone: "Europe/London",
  };
  const formattedTime = new Intl.DateTimeFormat("en-GB", timeOptions).format(
    date,
  );

  return `${formattedDate}, ${formattedTime}`;
}

export function formatUnixToDateInputValue(unixNano: bigint) {
  const date = new Date(Number(unixNano) / 1000000);
  const year = date.getFullYear();
  let month = (date.getMonth() + 1).toString();
  let day = date.getDate().toString();

  month = month.length < 2 ? "0" + month : month;
  day = day.length < 2 ? "0" + day : day;

  return `${year}-${month}-${day}`;
}

export function convertDateInputToUnixNano(dateString: string): bigint {
  const dateParts = dateString.split("-");
  if (dateParts.length !== 3) {
    throw new Error("Invalid date format. Expected YYYY-MM-DD");
  }

  const year = parseInt(dateParts[0], 10);
  const month = parseInt(dateParts[1], 10) - 1;
  const day = parseInt(dateParts[2], 10);

  const date = new Date(year, month, day);
  const unixTimeMillis = date.getTime();
  return BigInt(unixTimeMillis) * BigInt(1000000);
}

export function getPositionIndexToText(position: number): string {
  switch (position) {
    case 0:
      return "Goalkeeper";
    case 1:
      return "Defender";
    case 2:
      return "Midfielder";
    case 3:
      return "Forward";
    default:
      return "Unknown position";
  }
}

export function convertPositionToIndex(playerPosition: PlayerPosition): number {
  if ("Goalkeeper" in playerPosition) return 0;
  if ("Defender" in playerPosition) return 1;
  if ("Midfielder" in playerPosition) return 2;
  if ("Forward" in playerPosition) return 3;
  return 0;
}

export function getPositionAbbreviation(position: number): string {
  switch (position) {
    case 0:
      return "GK";
    case 1:
      return "DF";
    case 2:
      return "MF";
    case 3:
      return "FW";
    default:
      return "-";
  }
}

export function convertPositionToAbbreviation(
  position: PlayerPosition,
): string {
  let positionString = Object.keys(position)[0];

  switch (positionString) {
    case "Goalkeeper":
      return "GK";
    case "Defender":
      return "DF";
    case "Midfielder":
      return "MF";
    case "Forward":
      return "FW";
    default:
      return "-";
  }
}

export function convertDateToReadable(nanoseconds: number): string {
  const milliseconds = nanoseconds / 1e6;
  const date = new Date(milliseconds);
  return date.toLocaleDateString("en-GB");
}

export function calculateAgeFromNanoseconds(nanoseconds: number) {
  const milliseconds = nanoseconds / 1e6;
  const birthDate = new Date(milliseconds);
  const today = new Date();

  let age = today.getFullYear() - birthDate.getFullYear();
  const monthDifference = today.getMonth() - birthDate.getMonth();

  if (
    monthDifference < 0 ||
    (monthDifference === 0 && today.getDate() < birthDate.getDate())
  ) {
    age--;
  }

  return age;
}

export function getFlagComponent(countryId: number) {
  switch (countryId) {
    case 1:
      return FlagIcons.Af;
    case 2:
      return FlagIcons.Al;
    case 3:
      return FlagIcons.Dz;
    case 4:
      return FlagIcons.Ad;
    case 5:
      return FlagIcons.Ao;
    case 6:
      return FlagIcons.Ag;
    case 7:
      return FlagIcons.Ar;
    case 8:
      return FlagIcons.Am;
    case 9:
      return FlagIcons.Au;
    case 10:
      return FlagIcons.At;
    case 11:
      return FlagIcons.Az;
    case 12:
      return FlagIcons.Bs;
    case 13:
      return FlagIcons.Bh;
    case 14:
      return FlagIcons.Bd;
    case 15:
      return FlagIcons.Bb;
    case 16:
      return FlagIcons.By;
    case 17:
      return FlagIcons.Be;
    case 18:
      return FlagIcons.Bz;
    case 20:
      return FlagIcons.Bt;
    case 21:
      return FlagIcons.Bo;
    case 22:
      return FlagIcons.Ba;
    case 23:
      return FlagIcons.Bw;
    case 24:
      return FlagIcons.Br;
    case 25:
      return FlagIcons.Bn;
    case 26:
      return FlagIcons.Bg;
    case 27:
      return FlagIcons.Bf;
    case 28:
      return FlagIcons.Bi;
    case 29:
      return FlagIcons.Cv;
    case 30:
      return FlagIcons.Kh;
    case 31:
      return FlagIcons.Cm;
    case 32:
      return FlagIcons.Ca;
    case 33:
      return FlagIcons.Cf;
    case 34:
      return FlagIcons.Td;
    case 35:
      return FlagIcons.Cl;
    case 36:
      return FlagIcons.Cn;
    case 37:
      return FlagIcons.Co;
    case 38:
      return FlagIcons.Km;
    case 39:
      return FlagIcons.Cd;
    case 40:
      return FlagIcons.Cg;
    case 41:
      return FlagIcons.Cr;
    case 42:
      return FlagIcons.Ci;
    case 43:
      return FlagIcons.Hr;
    case 44:
      return FlagIcons.Cu;
    case 45:
      return FlagIcons.Cy;
    case 46:
      return FlagIcons.Cz;
    case 47:
      return FlagIcons.Dk;
    case 48:
      return FlagIcons.Dj;
    case 49:
      return FlagIcons.Dm;
    case 50:
      return FlagIcons.Do;
    case 51:
      return FlagIcons.Ec;
    case 52:
      return FlagIcons.Eg;
    case 53:
      return FlagIcons.Sv;
    case 54:
      return FlagIcons.Gq;
    case 55:
      return FlagIcons.Er;
    case 56:
      return FlagIcons.Ee;
    case 57:
      return FlagIcons.Sz;
    case 58:
      return FlagIcons.Et;
    case 59:
      return FlagIcons.Fj;
    case 60:
      return FlagIcons.Fi;
    case 61:
      return FlagIcons.Fr;
    case 62:
      return FlagIcons.Ga;
    case 63:
      return FlagIcons.Gm;
    case 64:
      return FlagIcons.Ge;
    case 65:
      return FlagIcons.De;
    case 66:
      return FlagIcons.Gh;
    case 67:
      return FlagIcons.Gr;
    case 68:
      return FlagIcons.Gd;
    case 69:
      return FlagIcons.Gt;
    case 70:
      return FlagIcons.Gn;
    case 71:
      return FlagIcons.Gm;
    case 72:
      return FlagIcons.Gy;
    case 73:
      return FlagIcons.Ht;
    case 74:
      return FlagIcons.Hn;
    case 75:
      return FlagIcons.Hu;
    case 76:
      return FlagIcons.Is;
    case 77:
      return FlagIcons.In;
    case 78:
      return FlagIcons.Id;
    case 79:
      return FlagIcons.Ir;
    case 80:
      return FlagIcons.Iq;
    case 81:
      return FlagIcons.Ie;
    case 82:
      return FlagIcons.Il;
    case 83:
      return FlagIcons.It;
    case 84:
      return FlagIcons.Jm;
    case 85:
      return FlagIcons.Jp;
    case 86:
      return FlagIcons.Jo;
    case 87:
      return FlagIcons.Kz;
    case 88:
      return FlagIcons.Ke;
    case 89:
      return FlagIcons.Ki;
    case 90:
      return FlagIcons.Kp;
    case 91:
      return FlagIcons.Kr;
    case 92:
      return FlagIcons.Xk;
    case 93:
      return FlagIcons.Kw;
    case 94:
      return FlagIcons.Kg;
    case 95:
      return FlagIcons.La;
    case 96:
      return FlagIcons.Lv;
    case 97:
      return FlagIcons.Lb;
    case 98:
      return FlagIcons.Ls;
    case 99:
      return FlagIcons.Lr;
    case 100:
      return FlagIcons.Ly;
    case 101:
      return FlagIcons.Li;
    case 102:
      return FlagIcons.Lt;
    case 103:
      return FlagIcons.Lu;
    case 104:
      return FlagIcons.Mg;
    case 105:
      return FlagIcons.Mw;
    case 106:
      return FlagIcons.My;
    case 107:
      return FlagIcons.Mv;
    case 108:
      return FlagIcons.Ml;
    case 109:
      return FlagIcons.Mt;
    case 110:
      return FlagIcons.Mh;
    case 111:
      return FlagIcons.Mr;
    case 112:
      return FlagIcons.Mu;
    case 113:
      return FlagIcons.Mx;
    case 114:
      return FlagIcons.Fm;
    case 115:
      return FlagIcons.Md;
    case 116:
      return FlagIcons.Mc;
    case 117:
      return FlagIcons.Mn;
    case 118:
      return FlagIcons.Me;
    case 119:
      return FlagIcons.Ma;
    case 120:
      return FlagIcons.Mz;
    case 121:
      return FlagIcons.Mm;
    case 122:
      return FlagIcons.Na;
    case 123:
      return FlagIcons.Nr;
    case 124:
      return FlagIcons.Np;
    case 125:
      return FlagIcons.Nl;
    case 126:
      return FlagIcons.Nz;
    case 127:
      return FlagIcons.Ni;
    case 128:
      return FlagIcons.Ne;
    case 129:
      return FlagIcons.Ne;
    case 130:
      return FlagIcons.Mk;
    case 131:
      return FlagIcons.No;
    case 132:
      return FlagIcons.Om;
    case 133:
      return FlagIcons.Pk;
    case 134:
      return FlagIcons.Pw;
    case 135:
      return FlagIcons.Pa;
    case 136:
      return FlagIcons.Pg;
    case 137:
      return FlagIcons.Py;
    case 138:
      return FlagIcons.Pe;
    case 139:
      return FlagIcons.Ph;
    case 140:
      return FlagIcons.Pl;
    case 141:
      return FlagIcons.Pt;
    case 142:
      return FlagIcons.Qa;
    case 143:
      return FlagIcons.Ro;
    case 144:
      return FlagIcons.Ru;
    case 145:
      return FlagIcons.Rw;
    case 146:
      return FlagIcons.Kn;
    case 147:
      return FlagIcons.Lc;
    case 148:
      return FlagIcons.Vc;
    case 149:
      return FlagIcons.Ws;
    case 150:
      return FlagIcons.Sm;
    case 151:
      return FlagIcons.St;
    case 152:
      return FlagIcons.Sa;
    case 153:
      return FlagIcons.Sn;
    case 154:
      return FlagIcons.Rs;
    case 155:
      return FlagIcons.Sc;
    case 156:
      return FlagIcons.Sl;
    case 157:
      return FlagIcons.Sg;
    case 158:
      return FlagIcons.Sk;
    case 159:
      return FlagIcons.Si;
    case 160:
      return FlagIcons.Sb;
    case 161:
      return FlagIcons.So;
    case 162:
      return FlagIcons.Za;
    case 163:
      return FlagIcons.Ss;
    case 164:
      return FlagIcons.Es;
    case 165:
      return FlagIcons.Lk;
    case 166:
      return FlagIcons.Sd;
    case 167:
      return FlagIcons.Sr;
    case 168:
      return FlagIcons.Se;
    case 169:
      return FlagIcons.Ch;
    case 170:
      return FlagIcons.Sy;
    case 171:
      return FlagIcons.Tw;
    case 172:
      return FlagIcons.Tj;
    case 173:
      return FlagIcons.Tz;
    case 174:
      return FlagIcons.Th;
    case 175:
      return FlagIcons.Tl;
    case 176:
      return FlagIcons.Tg;
    case 177:
      return FlagIcons.To;
    case 178:
      return FlagIcons.Tt;
    case 179:
      return FlagIcons.Tn;
    case 180:
      return FlagIcons.Tr;
    case 181:
      return FlagIcons.Tm;
    case 182:
      return FlagIcons.Tv;
    case 183:
      return FlagIcons.Ug;
    case 184:
      return FlagIcons.Ua;
    case 185:
      return FlagIcons.Ae;
    case 186:
      return EnglandFlag;
    case 187:
      return FlagIcons.Us;
    case 188:
      return FlagIcons.Uy;
    case 189:
      return FlagIcons.Uz;
    case 190:
      return FlagIcons.Vu;
    case 191:
      return FlagIcons.Va;
    case 192:
      return FlagIcons.Ve;
    case 193:
      return FlagIcons.Vn;
    case 194:
      return FlagIcons.Ye;
    case 195:
      return FlagIcons.Zm;
    case 196:
      return FlagIcons.Zw;
    case 197:
      return ScotlandFlag;
    case 198:
      return WalesFlag;
    case 199:
      return NorthernIrelandFlag;
    default:
      return null;
  }
}

export function updateTableData(
  fixtures: FixtureWithClubs[],
  teams: Club[],
  selectedGameweek: number,
): TeamStats[] {
  let tempTable: Record<number, TeamStats> = {};

  teams.forEach((team) => initTeamData(team.id, tempTable, teams));

  const relevantFixtures = fixtures.filter(
    (fixture) =>
      convertFixtureStatus(fixture.fixture.status) === 3 &&
      fixture.fixture.gameweek <= selectedGameweek,
  );

  relevantFixtures.forEach(({ fixture, homeClub, awayClub }) => {
    if (!homeClub || !awayClub) return;

    initTeamData(homeClub.id, tempTable, teams);
    initTeamData(awayClub.id, tempTable, teams);

    const homeStats = tempTable[homeClub.id];
    const awayStats = tempTable[awayClub.id];

    homeStats.played++;
    awayStats.played++;

    homeStats.goalsFor += fixture.homeGoals;
    homeStats.goalsAgainst += fixture.awayGoals;
    awayStats.goalsFor += fixture.awayGoals;
    awayStats.goalsAgainst += fixture.homeGoals;

    if (fixture.homeGoals > fixture.awayGoals) {
      homeStats.wins++;
      homeStats.points += 3;
      awayStats.losses++;
    } else if (fixture.homeGoals === fixture.awayGoals) {
      homeStats.draws++;
      awayStats.draws++;
      homeStats.points += 1;
      awayStats.points += 1;
    } else {
      awayStats.wins++;
      awayStats.points += 3;
      homeStats.losses++;
    }
  });

  return Object.values(tempTable).sort((a, b) => {
    const goalDiffA = a.goalsFor - a.goalsAgainst;
    const goalDiffB = b.goalsFor - b.goalsAgainst;

    if (b.points !== a.points) return b.points - a.points;
    if (goalDiffB !== goalDiffA) return goalDiffB - goalDiffA;
    if (b.goalsFor !== a.goalsFor) return b.goalsFor - a.goalsFor;
    return a.goalsAgainst - b.goalsAgainst;
  });
}

function initTeamData(
  teamId: number,
  table: Record<number, TeamStats>,
  teams: Club[],
) {
  if (!table[teamId]) {
    const team = teams.find((t) => t.id === teamId);
    if (team) {
      table[teamId] = {
        ...team,
        played: 0,
        wins: 0,
        draws: 0,
        losses: 0,
        goalsFor: 0,
        goalsAgainst: 0,
        points: 0,
      };
    }
  }
}

export function convertEvent(playerEvent: PlayerEventType): number {
  if ("Appearance" in playerEvent) return 0;
  if ("Goal" in playerEvent) return 1;
  if ("GoalAssisted" in playerEvent) return 2;
  if ("GoalConceded" in playerEvent) return 3;
  if ("KeeperSave" in playerEvent) return 4;
  if ("CleanSheet" in playerEvent) return 5;
  if ("PenaltySaved" in playerEvent) return 6;
  if ("PenaltyMissed" in playerEvent) return 7;
  if ("YellowCard" in playerEvent) return 8;
  if ("RedCard" in playerEvent) return 9;
  if ("OwnGoal" in playerEvent) return 10;
  if ("HighestScoringPlayer" in playerEvent) return 11;
  return 0;
}

export function convertIntToEvent(playerEvent: number): PlayerEventType {
  if (playerEvent == 0) return { Appearance: null };
  if (playerEvent == 1) return { Goal: null };
  if (playerEvent == 2) return { GoalAssisted: null };
  if (playerEvent == 3) return { GoalConceded: null };
  if (playerEvent == 4) return { KeeperSave: null };
  if (playerEvent == 5) return { CleanSheet: null };
  if (playerEvent == 6) return { PenaltySaved: null };
  if (playerEvent == 7) return { PenaltyMissed: null };
  if (playerEvent == 8) return { YellowCard: null };
  if (playerEvent == 9) return { RedCard: null };
  if (playerEvent == 10) return { OwnGoal: null };
  if (playerEvent == 11) return { HighestScoringPlayer: null };
  return { Appearance: null };
}

export function convertFixtureStatus(fixtureStatus: FixtureStatusType): number {
  if ("Unplayed" in fixtureStatus) return 0;
  if ("Active" in fixtureStatus) return 1;
  if ("Complete" in fixtureStatus) return 2;
  if ("Finalised" in fixtureStatus) return 3;
  return 0;
}

export function getDateFromBigInt(dateMS: number): string {
  const dateInMilliseconds = Number(dateMS / 1000000);
  const date = new Date(dateInMilliseconds);
  const monthNames = [
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
  ];
  return `${monthNames[date.getUTCMonth()]} ${date.getUTCFullYear()}`;
}

interface ErrorResponse {
  err: {
    NotFound?: null;
  };
}

interface SuccessResponse {
  ok: any;
}
export function isError(response: any): response is ErrorResponse {
  return response && response.err !== undefined;
}

export function isSuccess(response: any): response is SuccessResponse {
  return response && response.ok !== undefined;
}

export function getMonthFromNumber(month: number): string {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
  }

  return "";
}
export function formatE8s(e8Value: bigint): string {
  const value = Number(e8Value) / 100_000_000;
  return value.toLocaleString(undefined, {
    minimumFractionDigits: 4,
    maximumFractionDigits: 4,
  });
}
export function formatWholeE8s(e8Value: bigint): string {
  const value = Number(e8Value) / 100_000_000;
  return value.toLocaleString(undefined, {
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  });
}

export function formatCycles(cycles: bigint): string {
  const trillionsOfCycles = Number(cycles) / 1_000_000_000_000;
  return (
    trillionsOfCycles.toLocaleString(undefined, {
      minimumFractionDigits: 4,
      maximumFractionDigits: 4,
    }) + "T"
  );
}

export function extractPlayerData(
  playerPointsDTO: PlayerPoints,
  player: Player,
): GameweekData {
  let goals = 0,
    assists = 0,
    redCards = 0,
    yellowCards = 0,
    missedPenalties = 0,
    ownGoals = 0,
    saves = 0,
    cleanSheets = 0,
    penaltySaves = 0,
    goalsConceded = 0,
    appearance = 0,
    highestScoringPlayerId = 0;

  let goalPoints = 0,
    assistPoints = 0,
    goalsConcededPoints = 0,
    cleanSheetPoints = 0;

  playerPointsDTO.events.forEach((event) => {
    switch (convertEvent(event.eventType)) {
      case 0:
        appearance += 1;
        break;
      case 1:
        goals += 1;
        switch (convertPositionToIndex(playerPointsDTO.position)) {
          case 0:
          case 1:
            goalPoints += 20;
            break;
          case 2:
            goalPoints += 15;
            break;
          case 3:
            goalPoints += 10;
            break;
        }
        break;
      case 2:
        assists += 1;
        switch (convertPositionToIndex(playerPointsDTO.position)) {
          case 0:
          case 1:
            assistPoints += 15;
            break;
          case 2:
          case 3:
            assistPoints += 10;
            break;
        }
        break;
      case 3:
        goalsConceded += 1;
        if (
          convertPositionToIndex(playerPointsDTO.position) < 2 &&
          goalsConceded % 2 === 0
        ) {
          goalsConcededPoints += -15;
        }
        break;
      case 4:
        saves += 1;
        break;
      case 5:
        cleanSheets += 1;
        if (
          convertPositionToIndex(playerPointsDTO.position) < 2 &&
          goalsConceded === 0
        ) {
          cleanSheetPoints += 10;
        }
        break;
      case 6:
        penaltySaves += 1;
        break;
      case 7:
        missedPenalties += 1;
        break;
      case 8:
        yellowCards += 1;
        break;
      case 9:
        redCards += 1;
        break;
      case 10:
        ownGoals += 1;
        break;
      case 11:
        highestScoringPlayerId += 1;
        break;
    }
  });

  let playerGameweekDetails: GameweekData = {
    player: player,
    points: playerPointsDTO.points,
    appearance: appearance,
    goals: goals,
    assists: assists,
    goalsConceded: goalsConceded,
    saves: saves,
    cleanSheets: cleanSheets,
    penaltySaves: penaltySaves,
    missedPenalties: missedPenalties,
    yellowCards: yellowCards,
    redCards: redCards,
    ownGoals: ownGoals,
    highestScoringPlayerId: highestScoringPlayerId,
    goalPoints: goalPoints,
    assistPoints: assistPoints,
    goalsConcededPoints: goalsConcededPoints,
    cleanSheetPoints: cleanSheetPoints,
    gameweek: playerPointsDTO.gameweek,
    bonusPoints: 0,
    totalPoints: 0,
    isCaptain: false,
    nationalityId: player.nationality,
  };

  return playerGameweekDetails;
}

export function calculatePlayerScore(
  gameweekData: GameweekData,
  fixtures: Fixture[],
): number {
  if (!gameweekData) {
    console.error("No gameweek data found:", gameweekData);
    return 0;
  }

  let score = 0;
  let pointsForAppearance = 5;
  let pointsFor3Saves = 5;
  let pointsForPenaltySave = 20;
  let pointsForHighestScore = 25;
  let pointsForRedCard = -20;
  let pointsForPenaltyMiss = -10;
  let pointsForEach2Conceded = -15;
  let pointsForOwnGoal = -10;
  let pointsForYellowCard = -5;
  let pointsForCleanSheet = 10;

  var pointsForGoal = 0;
  var pointsForAssist = 0;

  if (gameweekData.appearance > 0) {
    score += pointsForAppearance * gameweekData.appearance;
  }

  if (gameweekData.redCards > 0) {
    score += pointsForRedCard;
  }

  if (gameweekData.missedPenalties > 0) {
    score += pointsForPenaltyMiss * gameweekData.missedPenalties;
  }

  if (gameweekData.ownGoals > 0) {
    score += pointsForOwnGoal * gameweekData.ownGoals;
  }

  if (gameweekData.yellowCards > 0) {
    score += pointsForYellowCard * gameweekData.yellowCards;
  }

  switch (convertPositionToIndex(gameweekData.player.position)) {
    case 0:
      pointsForGoal = 20;
      pointsForAssist = 15;

      if (gameweekData.saves >= 3) {
        score += Math.floor(gameweekData.saves / 3) * pointsFor3Saves;
      }
      if (gameweekData.penaltySaves) {
        score += pointsForPenaltySave * gameweekData.penaltySaves;
      }

      if (gameweekData.cleanSheets > 0) {
        score += pointsForCleanSheet;
      }
      if (gameweekData.goalsConceded >= 2) {
        score +=
          Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
      }

      break;
    case 1:
      pointsForGoal = 20;
      pointsForAssist = 15;

      if (gameweekData.cleanSheets > 0) {
        score += pointsForCleanSheet;
      }
      if (gameweekData.goalsConceded >= 2) {
        score +=
          Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
      }

      break;
    case 2:
      pointsForGoal = 15;
      pointsForAssist = 10;
      break;
    case 3:
      pointsForGoal = 10;
      pointsForAssist = 10;
      break;
  }

  const gameweekFixtures = fixtures
    ? fixtures.filter((fixture) => fixture.gameweek === gameweekData.gameweek)
    : [];

  const playerFixtures = gameweekFixtures.filter(
    (fixture) =>
      (fixture.homeClubId === gameweekData.player.clubId ||
        fixture.awayClubId === gameweekData.player.clubId) &&
      fixture.highestScoringPlayerId === gameweekData.player.id,
  );

  if (playerFixtures && playerFixtures.length > 0) {
    score += pointsForHighestScore * playerFixtures.length;
  }

  score += gameweekData.goals * pointsForGoal;

  score += gameweekData.assists * pointsForAssist;
  return score;
}

export function getFixturesWithTeams(
  clubs: Club[],
  fixtures: Fixture[],
): FixtureWithClubs[] {
  return fixtures
    .sort((a, b) => Number(a.kickOff) - Number(b.kickOff))
    .map((fixture) => ({
      fixture,
      homeClub: clubs.find((club) => club.id === fixture.homeClubId),
      awayClub: clubs.find((club) => club.id === fixture.awayClubId),
    }));
}

export function getPlayerName(player: Player): string {
  return player.firstName != ""
    ? player.firstName.charAt(0) + "." + " " + player.lastName
    : player.lastName;
}

export function getActualIndex(
  rowIndex: number,
  colIndex: number,
  gridSetup: number[][],
): number {
  let startIndex = gridSetup
    .slice(0, rowIndex)
    .reduce((sum, currentRow) => sum + currentRow.length, 0);
  return startIndex + colIndex;
}

export function reduceFilteredFixtures(filteredFixtures: FixtureWithClubs[]): {
  [key: string]: FixtureWithClubs[];
} {
  return filteredFixtures.reduce(
    (acc: { [key: string]: FixtureWithClubs[] }, fixture) => {
      const kickOff = fixture.fixture.kickOff;
      const date = new Date(Number(kickOff) / 1000000);
      const dateFormatter = new Intl.DateTimeFormat("en-GB", {
        weekday: "long",
        day: "numeric",
        month: "long",
        year: "numeric",
      });
      const dateKey = dateFormatter.format(date);

      if (!acc[dateKey]) {
        acc[dateKey] = [];
      }
      acc[dateKey].push(fixture);
      return acc;
    },
    {} as { [key: string]: FixtureWithClubs[] },
  );
}

export function isAmountValid(amount: string): boolean {
  if (!amount) {
    return false;
  }
  const regex = /^\d+(\.\d{1,8})?$/;
  return regex.test(amount);
}

export function isPrincipalValid(principalId: string): boolean {
  if (!principalId) {
    return false;
  }
  const regex = /^([a-z2-7]{5}-){10}[a-z2-7]{3}$/i;
  return regex.test(principalId);
}

export function convertToE8s(amount: string): bigint {
  const [whole, fraction = ""] = amount.split(".");
  const fractionPadded = (fraction + "00000000").substring(0, 8);
  return BigInt(whole) * 100_000_000n + BigInt(fractionPadded);
}

export function getBonusIcon(snapshot: FantasyTeamSnapshot): string {
  if (snapshot.goalGetterGameweek === snapshot.gameweek) {
    return `<img src="/goal-getter.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else if (snapshot.passMasterGameweek === snapshot.gameweek) {
    return `<img src="/pass-master.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else if (snapshot.noEntryGameweek === snapshot.gameweek) {
    return `<img src="/no-entry.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else if (snapshot.teamBoostGameweek === snapshot.gameweek) {
    return `<img src="/team-boost.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else if (snapshot.safeHandsGameweek === snapshot.gameweek) {
    return `<img src="/safe-hands.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else if (snapshot.captainFantasticGameweek === snapshot.gameweek) {
    return `<img src="/captain-fantastic.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else if (snapshot.prospectsGameweek === snapshot.gameweek) {
    return `<img src="/prospects.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else if (snapshot.oneNationGameweek === snapshot.gameweek) {
    return `<img src="/one-nation.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else if (snapshot.braceBonusGameweek === snapshot.gameweek) {
    return `<img src="/brace-bonus.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else if (snapshot.hatTrickHeroGameweek === snapshot.gameweek) {
    return `<img src="/hat-trick-hero.png" alt="Bonus" class="w-6 md:w-9" />`;
  } else {
    return "-";
  }
}

export function getGameweeks(totalGameweeks: number): number[] {
  return Array.from({ length: totalGameweeks }, (_, i) => i + 1);
}

export function normaliseString(str: string) {
  return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
}

export function addTeamDataToPlayers(clubs: Club[], players: Player[]): any[] {
  return players.map((player) => {
    const team = clubs.find((t) => t.id === player.clubId);
    return { ...player, team };
  });
}

export function checkValidMembership(membershipType: MembershipType): boolean {
  return (
    "Founding" in membershipType ||
    "Seasonal" in membershipType ||
    "Lifetime" in membershipType ||
    "Monthly" in membershipType
  );
}
