import { authStore } from "$lib/stores/auth.store";
import { isError } from "$lib/utils/Helpers";
import type {
  AddInitialFixturesDTO,
  FixtureDTO,
  PlayerEventData,
  PlayerPosition,
  ShirtType,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createGovernanceStore() {
  async function revaluePlayerUp(playerId: number): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminRevaluePlayerUp(playerId); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function revaluePlayerDown(playerId: number): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminRevaluePlayerDown(playerId); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminSubmitFixtureData(
        seasonId,
        gameweek,
        fixtureId,
        playerEventData
      ); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
  ) {
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
        seasonFixtures
      };

      let result = identityActor.adminAddInitialFixtures(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL
      console.log(seasonFixtures)

      if (isError(result)) {
        console.error("Error submitting proposal");
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
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminRescheduleFixture(
        seasonId,
        fixtureId,
        updatedFixtureGameweek,
        updatedFixtureDate
      ); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminLoanPlayer(
        playerId,
        loanClubId,
        loanEndDate
      ); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminTransferPlayer(playerId, newClubId); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function recallPlayer(playerId: number): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminRecallPlayer(playerId); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminCreatePlayer(
        clubId,
        position,
        firstName,
        lastName,
        shirtNumber,
        valueQuarterMillions,
        dateOfBirth,
        nationality
      ); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
    nationalityId: number
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminUpdatePlayer(
        playerId,
        position,
        firstName,
        lastName,
        shirtNumber,
        dateOfBirth,
        nationalityId
      ); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
  ) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminSetPlayerInjury(
        playerId,
        description,
        expectedEndDate
      ); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminRetirePlayer(playerId, retirementDate); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function unretirePlayer(playerId: number): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminUnretirePlayer(playerId); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function promoteFormerClub(clubId: number): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminPromoteFormerClub(clubId); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminPromoteNewClub(
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType
      ); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = identityActor.adminUpdateClub(
        clubId,
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType
      ); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

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
