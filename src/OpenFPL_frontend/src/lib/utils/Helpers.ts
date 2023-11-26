import { Position } from "$lib/enums/Position";
import type { FixtureWithTeams } from "$lib/types/FixtureWithTeams";

export function formatUnixDateToReadable(unixNano: number) {
  const date = new Date(unixNano / 1000000);
  const options: Intl.DateTimeFormatOptions = {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  };

  return new Intl.DateTimeFormat("en-UK", options).format(date);
}
export function getCountdownTime(unixNano: number) {
  const targetDate = new Date(unixNano / 1000000);
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

export function formatUnixTimeToTime(unixTimeNano: number): string {
  const unixTimeMillis = unixTimeNano / 1000000;
  const date = new Date(unixTimeMillis);

  let hours = date.getHours();
  const minutes = date.getMinutes();
  const ampm = hours >= 12 ? "PM" : "AM";
  hours = hours % 12;
  hours = hours ? hours : 12;
  const minutesStr = minutes < 10 ? "0" + minutes : minutes;

  return `${hours}:${minutesStr} ${ampm}`;
}

export function getPositionText(position: Position): string {
  switch (position) {
    case Position.GOALKEEPER:
      return "Goalkeeper";
    case Position.DEFENDER:
      return "Defender";
    case Position.MIDFIELDER:
      return "Midfielder";
    case Position.FORWARD:
      return "Forward";
    default:
      return "Unknown position";
  }
}

export function getPositionAbbreviation(position: Position): string {
  switch (position) {
    case Position.GOALKEEPER:
      return "GK";
    case Position.DEFENDER:
      return "DF";
    case Position.MIDFIELDER:
      return "MF";
    case Position.FORWARD:
      return "FW";
    default:
      return "?";
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

import type { TeamStats } from "$lib/types/TeamStats";
import * as FlagIcons from "svelte-flag-icons";
import type {
  FantasyTeam,
  Team,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";

export function getFlagComponent(countryCode: string) {
  switch (countryCode) {
    case "Albania":
      return FlagIcons.Al;
    case "Algeria":
      return FlagIcons.Dz;
    case "Argentina":
      return FlagIcons.Ar;
    case "Australia":
      return FlagIcons.Au;
    case "Austria":
      return FlagIcons.At;
    case "Belgium":
      return FlagIcons.Be;
    case "Bosnia and Herzegovina":
      return FlagIcons.Ba;
    case "Brazil":
      return FlagIcons.Br;
    case "Burkina Faso":
      return FlagIcons.Bf;
    case "Cameroon":
      return FlagIcons.Cm;
    case "Canada":
      return FlagIcons.Ca;
    case "Colombia":
      return FlagIcons.Co;
    case "Costa Rica":
      return FlagIcons.Cr;
    case "Croatia":
      return FlagIcons.Hr;
    case "Czech Republic":
      return FlagIcons.Cz;
    case "Denmark":
      return FlagIcons.Dk;
    case "DR Congo":
      return FlagIcons.Cg;
    case "Ecuador":
      return FlagIcons.Ec;
    case "Egypt":
      return FlagIcons.Eg;
    case "England":
      return FlagIcons.Gb;
    case "Estonia":
      return FlagIcons.Ee;
    case "Finland":
      return FlagIcons.Fi;
    case "France":
      return FlagIcons.Fr;
    case "Gabon":
      return FlagIcons.Ga;
    case "Germany":
      return FlagIcons.De;
    case "Ghana":
      return FlagIcons.Gh;
    case "Greece":
      return FlagIcons.Gr;
    case "Grenada":
      return FlagIcons.Gd;
    case "Guinea":
      return FlagIcons.Gn;
    case "Iceland":
      return FlagIcons.Is;
    case "Iran":
      return FlagIcons.Ir;
    case "Ireland":
      return FlagIcons.Ie;
    case "Israel":
      return FlagIcons.Il;
    case "Italy":
      return FlagIcons.It;
    case "Ivory Coast":
      return FlagIcons.Ci;
    case "Jamaica":
      return FlagIcons.Jm;
    case "Japan":
      return FlagIcons.Jp;
    case "Macedonia":
      return FlagIcons.Mk;
    case "Mali":
      return FlagIcons.Ml;
    case "Mexico":
      return FlagIcons.Mx;
    case "Montserrat":
      return FlagIcons.Ms;
    case "Morocco":
      return FlagIcons.Ma;
    case "Netherlands":
      return FlagIcons.Nl;
    case "Nigeria":
      return FlagIcons.Ne;
    case "Northern Ireland":
      return FlagIcons.Gb;
    case "Norway":
      return FlagIcons.No;
    case "Paraguay":
      return FlagIcons.Py;
    case "Poland":
      return FlagIcons.Pl;
    case "Portugal":
      return FlagIcons.Pt;
    case "Scotland":
      return FlagIcons.Gb;
    case "Senegal":
      return FlagIcons.Sn;
    case "Serbia":
      return FlagIcons.Rs;
    case "Slovakia":
      return FlagIcons.Sk;
    case "South Africa":
      return FlagIcons.Za;
    case "South Korea":
      return FlagIcons.Kr;
    case "Spain":
      return FlagIcons.Es;
    case "Sweden":
      return FlagIcons.Se;
    case "Switzerland":
      return FlagIcons.Ch;
    case "Tunisia":
      return FlagIcons.Tn;
    case "Turkey":
      return FlagIcons.Tr;
    case "Ukraine":
      return FlagIcons.Ua;
    case "United States":
      return FlagIcons.Us;
    case "Uruguay":
      return FlagIcons.Uy;
    case "Wales":
      return FlagIcons.Gb;
    case "Zimbabwe":
      return FlagIcons.Zw;
    default:
      return null;
  }
}

export function updateTableData(
  fixtures: FixtureWithTeams[],
  teams: Team[],
  selectedGameweek: number
): TeamStats[] {
  let tempTable: Record<number, TeamStats> = {};

  teams.forEach((team) => initTeamData(team.id, tempTable, teams));

  const relevantFixtures = fixtures.filter(
    (fixture) =>
      fixture.fixture.status === 3 &&
      fixture.fixture.gameweek <= selectedGameweek
  );

  relevantFixtures.forEach(({ fixture, homeTeam, awayTeam }) => {
    if (!homeTeam || !awayTeam) return;

    initTeamData(homeTeam.id, tempTable, teams);
    initTeamData(awayTeam.id, tempTable, teams);

    const homeStats = tempTable[homeTeam.id];
    const awayStats = tempTable[awayTeam.id];

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
  teams: Team[]
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

export function getAvailableFormations(
  players: PlayerDTO[],
  team: FantasyTeam
): string[] {
  const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };
  team.playerIds.forEach((id) => {
    const teamPlayer = players.find((p) => p.id === id);
    if (teamPlayer) {
      positionCounts[teamPlayer.position]++;
    }
  });

  const formations = [
    "3-4-3",
    "3-5-2",
    "4-3-3",
    "4-4-2",
    "4-5-1",
    "5-4-1",
    "5-3-2",
  ];
  return formations.filter((formation) => {
    const [def, mid, fwd] = formation.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce(
      (a, b) => a + b,
      0
    );

    return totalPlayers + additionalPlayersNeeded <= 11;
  });
}
