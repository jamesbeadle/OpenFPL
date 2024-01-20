import { authStore } from "$lib/stores/auth.store";
import { isError } from "$lib/utils/Helpers";
import type {
  AddInitialFixturesDTO,
  CreatePlayerDTO,
  FixtureDTO,
  LoanPlayerDTO,
  PlayerEventData,
  PlayerPosition,
  PromoteFormerClubDTO,
  PromoteNewClubDTO,
  RecallPlayerDTO,
  RescheduleFixtureDTO,
  RetirePlayerDTO,
  RevaluePlayerDownDTO,
  RevaluePlayerUpDTO,
  SetPlayerInjuryDTO,
  ShirtType,
  SubmitFixtureDataDTO,
  TransferPlayerDTO,
  UnretirePlayerDTO,
  UpdateClubDTO,
  UpdatePlayerDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createGovernanceStore() {
  async function revaluePlayerUp(playerId: number): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: RevaluePlayerUpDTO = {
        playerId: playerId
      };

      let result = await identityActor.adminRevaluePlayerUp(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL
      console.log(result);
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function revaluePlayerDown(playerId: number): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: RevaluePlayerDownDTO = {
        playerId: playerId
      };

      let result = await identityActor.adminRevaluePlayerDown(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function submitFixtureData(
    seasonId: number,
    gameweek: number,
    fixtureId: number,
    playerEventData: PlayerEventData[]
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: SubmitFixtureDataDTO = {
        seasonId,
        gameweek,
        fixtureId,
        playerEventData
      };

      let result = await identityActor.adminSubmitFixtureData(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function addInitialFixtures(
    seasonId: number,
    seasonFixtures: FixtureDTO[]
  ): Promise<any> {
    if (seasonId == 0) {
      return;
    }

    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: AddInitialFixturesDTO = {
        seasonId,
        seasonFixtures,
      };

      let result = await identityActor.adminAddInitialFixtures(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function rescheduleFixture(
    seasonId: number,
    fixtureId: number,
    updatedFixtureGameweek: number,
    updatedFixtureDate: number
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: RescheduleFixtureDTO = {
        seasonId,
        fixtureId,
        updatedFixtureGameweek,
        updatedFixtureDate: BigInt(updatedFixtureDate)
      };

      let result = await identityActor.adminRescheduleFixture(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function loanPlayer(
    playerId: number,
    loanClubId: number,
    loanEndDate: number
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: LoanPlayerDTO = {
        playerId,
        loanClubId,
        loanEndDate: BigInt(loanEndDate)
      };

      let result = await identityActor.adminLoanPlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function transferPlayer(
    playerId: number,
    newClubId: number
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: TransferPlayerDTO = {
        playerId, newClubId
      };

      let result = await identityActor.adminTransferPlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function recallPlayer(playerId: number): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: RecallPlayerDTO = {
        playerId
      };

      let result = await identityActor.adminRecallPlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
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
    dateOfBirth: number,
    nationality: number
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: CreatePlayerDTO = {
        clubId,
        position,
        firstName,
        lastName,
        shirtNumber,
        valueQuarterMillions,
        dateOfBirth: BigInt(dateOfBirth),
        nationality
      };

      let result = await identityActor.adminCreatePlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
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
    nationality: number
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: UpdatePlayerDTO = {
        playerId,
        position,
        firstName,
        lastName,
        shirtNumber,
        dateOfBirth: BigInt(dateOfBirth),
        nationality
      };

      let result = await identityActor.adminUpdatePlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function setPlayerInjury(
    playerId: number,
    description: string,
    expectedEndDate: number
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: SetPlayerInjuryDTO = {
        playerId,
        description,
        expectedEndDate: BigInt(expectedEndDate)
      };

      let result = await identityActor.adminSetPlayerInjury(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function retirePlayer(
    playerId: number,
    retirementDate: number
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: RetirePlayerDTO = {
        playerId,
        retirementDate: BigInt(retirementDate)
      };

      let result = await identityActor.adminRetirePlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function unretirePlayer(playerId: number): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: UnretirePlayerDTO = {
        playerId
      };

      let result = await identityActor.adminUnretirePlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function promoteFormerClub(clubId: number): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: PromoteFormerClubDTO = {
        clubId
      };

      let result = await identityActor.adminPromoteFormerClub(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
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
    shirtType: ShirtType
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: PromoteNewClubDTO = {
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType
      };

      let result = await identityActor.adminPromoteNewClub(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
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
    shirtType: ShirtType
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: UpdateClubDTO = {
        clubId,
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType
      };

      let result = await identityActor.adminUpdateClub(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  return {
    revaluePlayerUp,
    revaluePlayerDown,
    submitFixtureData,
    addInitialFixtures,
    rescheduleFixture,
    loanPlayer,
    transferPlayer,
    recallPlayer,
    createPlayer,
    updatePlayer,
    setPlayerInjury,
    retirePlayer,
    unretirePlayer,
    promoteFormerClub,
    promoteNewClub,
    updateClub,
  };
}

export const governanceStore = createGovernanceStore();
