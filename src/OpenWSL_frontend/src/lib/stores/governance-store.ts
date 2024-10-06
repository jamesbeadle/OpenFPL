import { authStore } from "$lib/stores/auth.store";
import { playerStore } from "$lib/stores/player-store";
import { Principal } from "@dfinity/principal";
import { SnsGovernanceCanister } from "@dfinity/sns";
import type {
  Command,
  ExecuteGenericNervousSystemFunction,
} from "@dfinity/sns/dist/candid/sns_governance";
import type {
  AddInitialFixturesDTO,
  ClubDTO,
  CreatePlayerDTO,
  FixtureDTO,
  Gender,
  LoanPlayerDTO,
  MoveFixtureDTO,
  PlayerDTO,
  PlayerEventData,
  PlayerPosition,
  PostponeFixtureDTO,
  PromoteNewClubDTO,
  RecallPlayerDTO,
  RetirePlayerDTO,
  RevaluePlayerDownDTO,
  RevaluePlayerUpDTO,
  SetPlayerInjuryDTO,
  ShirtType,
  SubmitFixtureDataDTO,
  SystemStateDTO,
  TransferPlayerDTO,
  UnretirePlayerDTO,
  UpdateClubDTO,
  UpdatePlayerDTO,
} from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { fixtureStore } from "./fixture-store";
import { systemStore } from "./system-store";
import { teamStore } from "./team-store";
import { IDL } from "@dfinity/candid";
import { seasonStore } from "./season-store";

function createGovernanceStore() {
  async function revaluePlayerUp(playerId: number): Promise<any> {
    try {
      await systemStore.sync();
      await playerStore.sync();

      let allPlayers: PlayerDTO[] = [];
      const unsubscribe = playerStore.subscribe((players) => {
        allPlayers = players;
      });
      unsubscribe();

      var systemState: SystemStateDTO | null = null;

      const unsubscribeSystemState = systemStore.subscribe((state) => {
        systemState = state;
      });
      unsubscribeSystemState();

      var dto: RevaluePlayerUpDTO = {
        playerId: playerId,
        seasonId:
          systemState == null
            ? 0
            : (systemState as SystemStateDTO).pickTeamSeasonId,
        gameweek:
          systemState == null
            ? 0
            : (systemState as SystemStateDTO).pickTeamGameweek,
      };

      let player = allPlayers.find((x) => x.id == playerId);
      if (player) {
        let title = `Revalue ${player.lastName} value up.`;
        let summary = `Revalue ${player.lastName} value up from £${(
          player.valueQuarterMillions / 4
        )
          .toFixed(2)
          .toLocaleString()}m -> £${((player.valueQuarterMillions + 1) / 4)
          .toFixed(2)
          .toLocaleString()}m).`;

        await executeProposal(dto, title, summary, 1000n, [
          IDL.Record({ playerId: IDL.Nat16 }),
        ]);
      }
    } catch (error) {
      console.error("Error revaluing player up:", error);
      throw error;
    }
  }

  async function revaluePlayerDown(playerId: number): Promise<any> {
    try {
      await playerStore.sync();

      let allPlayers: PlayerDTO[] = [];
      const unsubscribe = playerStore.subscribe((players) => {
        allPlayers = players;
      });
      unsubscribe();

      var systemState: SystemStateDTO | null = null;

      const unsubscribeSystemState = systemStore.subscribe((state) => {
        systemState = state;
      });
      unsubscribeSystemState();

      var dto: RevaluePlayerDownDTO = {
        playerId: playerId,
        seasonId:
          systemState == null
            ? 0
            : (systemState as SystemStateDTO).pickTeamSeasonId,
        gameweek:
          systemState == null
            ? 0
            : (systemState as SystemStateDTO).pickTeamGameweek,
      };

      let player = allPlayers.find((x) => x.id == playerId);
      if (player) {
        let title = `Revalue ${player.lastName} value down.`;
        let summary = `Revalue ${player.lastName} value down from £${(
          player.valueQuarterMillions / 4
        )
          .toFixed(2)
          .toLocaleString()}m -> £${((player.valueQuarterMillions - 1) / 4)
          .toFixed(2)
          .toLocaleString()}m).`;

        await executeProposal(dto, title, summary, 2000n, [
          IDL.Record({ playerId: IDL.Nat16 }),
        ]);
      }
    } catch (error) {
      console.error("Error revaluing player down:", error);
      throw error;
    }
  }

  async function submitFixtureData(
    seasonId: number,
    gameweek: number,
    fixtureId: number,
    month: number,
    playerEventData: PlayerEventData[],
  ): Promise<any> {
    try {
      await teamStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      await fixtureStore.sync(seasonId);

      let allFixtures: FixtureDTO[] = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();

      let dto: SubmitFixtureDataDTO = {
        month,
        gameweek,
        fixtureId,
        playerEventData,
      };

      let fixture = allFixtures.find((x) => x.id == fixtureId);
      if (fixture) {
        let homeClub = clubs.find((x) => x.id == fixture?.homeClubId);
        let awayClub = clubs.find((x) => x.id == fixture?.awayClubId);
        if (!homeClub || !awayClub) {
          return;
        }

        let title = `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`;
        let summary = `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`;

        await executeProposal(dto, title, summary, 3000n, [
          IDL.Record({
            fixtureId: IDL.Nat32,
            seasonId: IDL.Nat16,
            gameweek: IDL.Nat8,
            playerEventData: IDL.Vec(
              IDL.Record({
                fixtureId: IDL.Nat32,
                clubId: IDL.Nat16,
                playerId: IDL.Nat16,
                eventStartMinute: IDL.Nat8,
                eventEndMinute: IDL.Nat8,
                eventType: IDL.Variant({
                  Goal: IDL.Null,
                  GoalConceded: IDL.Null,
                  Appearance: IDL.Null,
                  PenaltySaved: IDL.Null,
                  RedCard: IDL.Null,
                  KeeperSave: IDL.Null,
                  CleanSheet: IDL.Null,
                  YellowCard: IDL.Null,
                  GoalAssisted: IDL.Null,
                  OwnGoal: IDL.Null,
                  HighestScoringPlayer: IDL.Null,
                }),
              }),
            ),
          }),
        ]);
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function addInitialFixtures(
    seasonFixtures: FixtureDTO[],
  ): Promise<any> {
    try {
      await systemStore.sync();
      await seasonStore.sync();
      let seasonName = "";

      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          const unsubscribeSeasonStore = seasonStore.subscribe((seasons) => {
            let currentSeason = seasons.find(x => x.id == systemState.pickTeamSeasonId);
            if(currentSeason){
              seasonName = currentSeason.name;
            }
            unsubscribeSeasonStore();
          });
        }
      });
      unsubscribeSystemStore();

      let dto: AddInitialFixturesDTO = {
        seasonFixtures,
      };

      let title = `Add initial fixtures for season ${seasonName}`;
      let summary = `Add initial fixtures for season ${seasonName}`;

      await executeProposal(dto, title, summary, 4000n, [
        IDL.Record({
          seasonId: IDL.Nat16,
          seasonFixtures: IDL.Vec(
            IDL.Record({
              id: IDL.Nat32,
              status: IDL.Variant({
                Unplayed: IDL.Null,
                Finalised: IDL.Null,
                Active: IDL.Null,
                Complete: IDL.Null,
              }),
              highestScoringPlayerId: IDL.Nat16,
              seasonId: IDL.Nat16,
              awayClubId: IDL.Nat16,
              events: IDL.Vec(
                IDL.Record({
                  fixtureId: IDL.Nat32,
                  clubId: IDL.Nat16,
                  playerId: IDL.Nat16,
                  eventStartMinute: IDL.Nat8,
                  eventEndMinute: IDL.Nat8,
                  eventType: IDL.Variant({
                    Goal: IDL.Null,
                    GoalConceded: IDL.Null,
                    Appearance: IDL.Null,
                    PenaltySaved: IDL.Null,
                    RedCard: IDL.Null,
                    KeeperSave: IDL.Null,
                    CleanSheet: IDL.Null,
                    YellowCard: IDL.Null,
                    GoalAssisted: IDL.Null,
                    OwnGoal: IDL.Null,
                    HighestScoringPlayer: IDL.Null,
                  }),
                }),
              ),
            }),
          ),
          homeClubId: IDL.Nat16,
          kickOff: IDL.Int,
          homeGoals: IDL.Nat8,
          gameweek: IDL.Nat8,
          awayGoals: IDL.Nat8,
        }),
      ]);
    } catch (error) {
      console.error("Error adding initial fixtures:", error);
      throw error;
    }
  }

  async function moveFixture(
    fixtureId: number,
    updatedFixtureGameweek: number,
    updatedFixtureDate: string,
  ): Promise<any> {
    try {
      await teamStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let seasonId = 0;

      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonId = systemState?.calculationSeasonId;
        }
      });
      unsubscribeSystemStore();

      await fixtureStore.sync(seasonId);

      let allFixtures: FixtureDTO[] = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();

      const dateObject = new Date(updatedFixtureDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: MoveFixtureDTO = {
        fixtureId,
        updatedFixtureGameweek,
        updatedFixtureDate: nanoseconds,
      };

      let fixture = allFixtures.find((x) => x.id == fixtureId);
      if (fixture) {
        let homeClub = clubs.find((x) => x.id == fixture?.homeClubId);
        let awayClub = clubs.find((x) => x.id == fixture?.awayClubId);
        if (!homeClub || !awayClub) {
          return;
        }

        let title = `Move fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`;
        let summary = `Move fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`;
        await executeProposal(dto, title, summary, 5000n, [
          IDL.Record({
            fixtureId: IDL.Nat32,
            updatedFixtureGameweek: IDL.Nat8,
            updatedFixtureDate: IDL.Int,
          }),
        ]);
      }
    } catch (error) {
      console.error("Error moving fixture:", error);
      throw error;
    }
  }

  async function postponeFixture(fixtureId: number): Promise<any> {
    try {
      await teamStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let seasonId = 0;

      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonId = systemState?.calculationSeasonId;
        }
      });
      unsubscribeSystemStore();

      await fixtureStore.sync(seasonId);

      let allFixtures: FixtureDTO[] = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();

      let dto: PostponeFixtureDTO = {
        fixtureId,
      };
      let fixture = allFixtures.find((x) => x.id == fixtureId);
      if (fixture) {
        let homeClub = clubs.find((x) => x.id == fixture?.homeClubId);
        let awayClub = clubs.find((x) => x.id == fixture?.awayClubId);
        if (!homeClub || !awayClub) {
          return;
        }

        let title = `Postpone fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`;
        let summary = `Postpone fixture for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`;
        await executeProposal(dto, title, summary, 6000n, [
          IDL.Record({ fixtureId: IDL.Nat32 }),
        ]);
      }
    } catch (error) {
      console.error("Error postponing fixture:", error);
      throw error;
    }
  }

  async function rescheduleFixture(
    fixtureId: number,
    updatedFixtureGameweek: number,
    updatedFixtureDate: string,
  ): Promise<any> {
    try {
      await teamStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let seasonId = 0;

      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonId = systemState?.calculationSeasonId;
        }
      });
      unsubscribeSystemStore();

      await fixtureStore.sync(seasonId);

      let allFixtures: FixtureDTO[] = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();

      const dateObject = new Date(updatedFixtureDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: MoveFixtureDTO = {
        fixtureId,
        updatedFixtureGameweek,
        updatedFixtureDate: nanoseconds,
      };

      let fixture = allFixtures.find((x) => x.id == fixtureId);
      if (fixture) {
        let homeClub = clubs.find((x) => x.id == fixture?.homeClubId);
        let awayClub = clubs.find((x) => x.id == fixture?.awayClubId);
        if (!homeClub || !awayClub) {
          return;
        }

        let title = `Move fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`;
        let summary = `Move fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`;
        await executeProposal(dto, title, summary, 7000n, [
          IDL.Record({
            postponedFixtureId: IDL.Nat32,
            updatedFixtureGameweek: IDL.Nat8,
            updatedFixtureDate: IDL.Int,
          }),
        ]);
      }
    } catch (error) {
      console.error("Error rescheduling fixture:", error);
      throw error;
    }
  }

  async function transferPlayer(
    playerId: number,
    newLeagueId: number,
    newClubId: number,
    newShirtNumber: number,
    seasonId: number,
    gameweek: number
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      let title = "";
      let player = allPlayers.find((x) => x.id == playerId);
      if (player) {
        let currentClub = clubs.find((x) => x.id == player?.clubId);
        let newClub = clubs.find((x) => x.id == newClubId);
        if (!currentClub) {
          return;
        }

        if (newClubId == 0) {
          title = `Transfer ${player.firstName} ${player.lastName} outside of Premier League.`;
        }

        if (newClub) {
          title = `Transfer ${player.firstName} ${player.lastName} to ${newClub.friendlyName}`;
        }
      }

      let summary = title;

      let dto: TransferPlayerDTO = {
        playerId,
        newClubId,
        newShirtNumber,
        newLeagueId,
        clubId: player?.clubId ?? 0,
        seasonId,
        gameweek
      };

      await executeProposal(dto, title, summary, 8000n, [
        IDL.Record({ playerId: IDL.Nat16, newClubId: IDL.Nat16 }),
      ]);
    } catch (error) {
      console.error("Error transferring player:", error);
      throw error;
    }
  }

  async function loanPlayer(
    playerId: number,
    loanLeagueId: number,
    loanClubId: number,
    loanEndDate: string,
    seasonId: number,
    gameweek: number
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      const dateObject = new Date(loanEndDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: LoanPlayerDTO = {
        playerId,
        loanLeagueId,
        loanClubId,
        loanEndDate: nanoseconds,
        seasonId,
        gameweek
      };

      let player = allPlayers.find((x) => x.id == playerId);
      if (player) {
        let club = clubs.find((x) => x.id == player?.clubId);
        if (!club) {
          return;
        }

        let title = `Loan ${player.firstName} to ${club?.friendlyName}.`;
        let summary = `Loan ${player.firstName} to ${club?.friendlyName}.`;

        await executeProposal(dto, title, summary, 9000n, [
          IDL.Record({
            playerId: IDL.Nat16,
            loanClubId: IDL.Nat16,
            loanEndDate: IDL.Int,
          }),
        ]);
      }
    } catch (error) {
      console.error("Error loaning player:", error);
      throw error;
    }
  }

  async function recallPlayer(playerId: number): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      let dto: RecallPlayerDTO = {
        playerId,
      };

      let player = allPlayers.find((x) => x.id == playerId);
      if (player) {
        let club = clubs.find((x) => x.id == player?.clubId);
        if (!club) {
          return;
        }

        let title = `Recall ${player.firstName} ${player?.lastName} loan.`;
        let summary = `Recall ${player.firstName} ${player?.lastName} loan.`;
        await executeProposal(dto, title, summary, 10000n, [
          IDL.Record({ playerId: IDL.Nat16 }),
        ]);
      }
    } catch (error) {
      console.error("Error recalling player loan:", error);
      throw error;
    }
  }

  async function createPlayer(
    clubId: number,
    position: PlayerPosition,
    firstName: string,
    lastName: string,
    shirtNumber: number,
    valueQuarterMillions: number,
    dateOfBirth: string,
    nationality: number,
    gender: Gender
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      const dateObject = new Date(dateOfBirth);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: CreatePlayerDTO = {
        gender,
        clubId,
        position,
        firstName,
        lastName,
        shirtNumber,
        valueQuarterMillions,
        dateOfBirth: nanoseconds,
        nationality,
      };

      let club = clubs.find((x) => x.id == clubId);
      if (!club) {
        return;
      }
      let title = `Create New Player: ${firstName} ${lastName}.`;
      let summary = `Create New Player: ${firstName} ${lastName}.`;

      await executeProposal(dto, title, summary, 11000n, [
        IDL.Record({
          clubId: IDL.Nat16,
          valueQuarterMillions: IDL.Nat16,
          dateOfBirth: IDL.Int,
          nationality: IDL.Nat16,
          shirtNumber: IDL.Nat8,
          position: IDL.Variant({
            Goalkeeper: IDL.Null,
            Defender: IDL.Null,
            Midfielder: IDL.Null,
            Forward: IDL.Null,
          }),
          lastName: IDL.Text,
          firstName: IDL.Text,
        }),
      ]);
    } catch (error) {
      console.error("Error creating player:", error);
      throw error;
    }
  }

  async function updatePlayer(
    playerId: number,
    position: PlayerPosition,
    firstName: string,
    lastName: string,
    shirtNumber: number,
    dateOfBirth: bigint,
    nationality: number,
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      let player = allPlayers.find((x) => x.id == playerId);
      if (player) {
        let club = clubs.find((x) => x.id == player?.clubId);
        if (!club) {
          return;
        }
        let dto: UpdatePlayerDTO = {
          dateOfBirth: dateOfBirth,
          playerId: playerId,
          nationality: nationality,
          shirtNumber: shirtNumber,
          position: position,
          lastName: lastName,
          firstName: firstName,
        };
        let title = `Update ${player.firstName} ${player.lastName} details.`;
        let summary = `Update ${player.firstName} ${player.lastName} details.`;
        await executeProposal(dto, title, summary, 12000n, [
          IDL.Record({
            dateOfBirth: IDL.Int,
            playerId: IDL.Nat16,
            nationality: IDL.Nat16,
            shirtNumber: IDL.Nat8,
            position: IDL.Variant({
              Goalkeeper: IDL.Null,
              Defender: IDL.Null,
              Midfielder: IDL.Null,
              Forward: IDL.Null,
            }),
            lastName: IDL.Text,
            firstName: IDL.Text,
          }),
        ]);
      }
    } catch (error) {
      console.error("Error updating player:", error);
      throw error;
    }
  }

  async function setPlayerInjury(
    playerId: number,
    description: string,
    expectedEndDate: string,
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      const dateObject = new Date(expectedEndDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: SetPlayerInjuryDTO = {
        playerId,
        description,
        expectedEndDate: nanoseconds,
      };

      let player = allPlayers.find((x) => x.id == playerId);
      if (player) {
        let club = clubs.find((x) => x.id == player?.clubId);
        if (!club) {
          return;
        }

        let title = `Set Player Injury for ${player.firstName} ${player.lastName}.`;
        let summary = `Set Player Injury for ${player.firstName} ${player.lastName}.`;
        await executeProposal(dto, title, summary, 13000n, [
          IDL.Record({
            playerId: IDL.Nat16,
            description: IDL.Text,
            expectedEndDate: IDL.Int,
          }),
        ]);
      }
    } catch (error) {
      console.error("Error setting player injury:", error);
      throw error;
    }
  }

  async function retirePlayer(
    playerId: number,
    retirementDate: string,
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      const dateObject = new Date(retirementDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: RetirePlayerDTO = {
        playerId,
        retirementDate: nanoseconds,
      };

      let player = allPlayers.find((x) => x.id == playerId);
      if (player) {
        let club = clubs.find((x) => x.id == player?.clubId);
        if (!club) {
          return;
        }
        let title = `Retire ${player.firstName} ${player.lastName}.`;
        let summary = `Retire ${player.firstName} ${player.lastName}.`;
        await executeProposal(dto, title, summary, 14000n, [
          IDL.Record({ playerId: IDL.Nat16, retirementDate: IDL.Int }),
        ]);
      }
    } catch (error) {
      console.error("Error retiring player:", error);
      throw error;
    }
  }

  async function unretirePlayer(playerId: number): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      let dto: UnretirePlayerDTO = {
        playerId,
      };

      let player = allPlayers.find((x) => x.id == playerId);
      if (player) {
        let club = clubs.find((x) => x.id == player?.clubId);
        if (!club) {
          return;
        }

        let title = `Unretire ${player.firstName} ${player.lastName}.`;
        let summary = `Unretire ${player.firstName} ${player.lastName}.`;
        await executeProposal(dto, title, summary, 15000n, [
          IDL.Record({ playerId: IDL.Nat16 }),
        ]);
      }
    } catch (error) {
      console.error("Error unretiring player:", error);
      throw error;
    }
  }

  async function promoteNewClub(
    name: string,
    friendlyName: string,
    primaryColourHex: string,
    secondaryColourHex: string,
    thirdColourHex: string,
    abbreviatedName: string,
    shirtType: ShirtType,
  ): Promise<any> {
    try {
      let dto: PromoteNewClubDTO = {
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType,
      };

      let title = `Promote ${friendlyName}. to the Premier League`;
      let summary = `Promote ${name} from the Championship to the Premier League.`;
      executeProposal(dto, title, summary, 17000n, [
        IDL.Record({
          secondaryColourHex: IDL.Text,
          name: IDL.Text,
          friendlyName: IDL.Text,
          thirdColourHex: IDL.Text,
          abbreviatedName: IDL.Text,
          shirtType: IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null }),
          primaryColourHex: IDL.Text,
        }),
      ]);
    } catch (error) {
      console.error("Error promoting new club:", error);
      throw error;
    }
  }

  async function updateClub(
    clubId: number,
    name: string,
    friendlyName: string,
    primaryColourHex: string,
    secondaryColourHex: string,
    thirdColourHex: string,
    abbreviatedName: string,
    shirtType: ShirtType,
  ): Promise<any> {
    try {
      await teamStore.sync();
      let dto: UpdateClubDTO = {
        clubId: clubId,
        secondaryColourHex: secondaryColourHex,
        name: name,
        friendlyName: friendlyName,
        thirdColourHex: thirdColourHex,
        abbreviatedName: abbreviatedName,
        shirtType: shirtType,
        primaryColourHex: primaryColourHex,
      };

      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let seasonId = 0;

      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonId = systemState?.calculationSeasonId;
        }
      });
      unsubscribeSystemStore();

      await fixtureStore.sync(seasonId);

      let allFixtures: FixtureDTO[] = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();

      let club = clubs.find((x) => x.id == clubId);
      if (!club) {
        return;
      }

      let title = `Update ${club.friendlyName} club details.`;
      let summary = `Update ${club.friendlyName} club details.`;
      await executeProposal(dto, title, summary, 18000n, [
        IDL.Record({
          clubId: IDL.Nat16,
          secondaryColourHex: IDL.Text,
          name: IDL.Text,
          friendlyName: IDL.Text,
          thirdColourHex: IDL.Text,
          abbreviatedName: IDL.Text,
          shirtType: IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null }),
          primaryColourHex: IDL.Text,
        }),
      ]);
    } catch (error) {
      console.error("Error updating club:", error);
      throw error;
    }
  }

  async function executeProposal(
    dto: any,
    title: string,
    summary: string,
    functionId: bigint,
    argTypes: IDL.Type<any>[],
  ) {
    const unsubscribeAuthStore = authStore.subscribe(async (auth) => {
      if (auth) {
        let principal = auth.identity?.getPrincipal().toText() ?? "";
        if (principal == "") {
          return;
        }

        const agent: any = await ActorFactory.getGovernanceAgent(auth.identity);
        if (process.env.DFX_NETWORK !== "ic") {
          await agent.fetchRootKey();
        }

        const snsGovernanceCanisterPrincipal: Principal = Principal.fromText(
          process.env.CANISTER_ID_SNS_GOVERNANCE ?? "",
        );
        const { listNeurons, manageNeuron } = SnsGovernanceCanister.create({
          agent,
          canisterId: snsGovernanceCanisterPrincipal,
        });

        let userNeurons = await listNeurons({
          certified: false,
          principal: Principal.fromText(principal),
        });
        if (userNeurons.length > 0) {
          console.log(dto);

          const payloadArrayBuffer = IDL.encode(argTypes, [dto]);

          console.log(payloadArrayBuffer);

          const fn: ExecuteGenericNervousSystemFunction = {
            function_id: functionId,
            payload: new Uint8Array(payloadArrayBuffer),
          };

          const command: Command = {
            MakeProposal: {
              title: title,
              url: "openfpl.xyz/governance",
              summary: summary,
              action: [{ ExecuteGenericNervousSystemFunction: fn }],
            },
          };

          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }

          await manageNeuron({
            subaccount: neuronId.id,
            command: [command],
          });
        }
      }
    });
    unsubscribeAuthStore();
  }

  return {
    revaluePlayerUp,
    revaluePlayerDown,
    submitFixtureData,
    addInitialFixtures,
    moveFixture,
    postponeFixture,
    rescheduleFixture,
    loanPlayer,
    transferPlayer,
    recallPlayer,
    createPlayer,
    updatePlayer,
    setPlayerInjury,
    retirePlayer,
    unretirePlayer,
    promoteNewClub,
    updateClub,
  };
}

export const governanceStore = createGovernanceStore();
