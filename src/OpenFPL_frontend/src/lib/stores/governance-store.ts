import { authStore } from "$lib/stores/auth.store";
import { GovernanceCanister } from "@dfinity/nns";
import { SnsGovernanceCanister } from "@dfinity/sns";
import { playerStore } from "$lib/stores/player-store";
import { isError } from "$lib/utils/Helpers";
import type {
  AddInitialFixturesDTO,
  CreatePlayerDTO,
  FixtureDTO,
  LoanPlayerDTO,
  MoveFixtureDTO,
  PlayerEventData,
  PlayerPosition,
  PostponeFixtureDTO,
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
import type { Action, MakeProposalRequest, NeuronId, Option } from "@dfinity/nns";
import { ManageNeuron } from "@dfinity/nns-proto";
import type { HttpAgent } from "@dfinity/agent";

function createGovernanceStore() {
  async function revaluePlayerUp(playerId: number): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: RevaluePlayerUpDTO = {
        playerId: playerId,
      };

      let result = await identityActor.adminRevaluePlayerUp(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL
      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function revaluePlayerDown(playerId: number): Promise<any> {
    try {
      
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_GOVERNANCE_CANISTER_ID ?? ""
      ); //TODO: Create the governance canister

      const { listNeurons  } = GovernanceCanister.create(identityActor);

      const governanceAgent: HttpAgent = ActorFactory.getAgent(process.env.OPENFPL_GOVERNANCE_CANISTER_ID, identityActor, null);

      const { metadata: governanceMetadata } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor,
      });
      const metadata = await governanceMetadata({ certified: true });
      
      
      let userNeurons = await listNeurons({certified: true});
      await playerStore.sync();
      let player = playerStore.subscribe(players => {
        let player = players.find(x => x.id == playerId);
          if(!player){
            return;
          }
  
          
          if(userNeurons.length > 0){
            const neuronId: Option<NeuronId> = userNeurons[0].neuronId;
                  
            let dto: RevaluePlayerDownDTO = {
              playerId: playerId,
            };
/*            
            let makeProposalRequest: MakeProposalRequest = {
              neuronId: neuronId,
              title: `Revalue ${player.lastName} value down.`,
              url: "openfpl.xyz/governance",
              summary: `Revalue ${player.lastName} value down from £${(player.valueQuarterMillions / 4).toFixed(2).toLocaleString()}m -> £${((player.valueQuarterMillions - 1)/4).toFixed(2).toLocaleString()}m).`,
              action:  action
                
            };
            await makeProposal(makeProposalRequest);
            */
          }
        }
      );
      /*
      activeProposals = proposalResponse.proposals;



      let result = await identityActor.adminRevaluePlayerDown(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
        return;
      }
      */
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
        playerEventData,
      };

      let result = await identityActor.adminSubmitFixtureData(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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

  async function moveFixture(
    fixtureId: number,
    updatedFixtureGameweek: number,
    updatedFixtureDate: string
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      const dateObject = new Date(updatedFixtureDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: MoveFixtureDTO = {
        fixtureId,
        updatedFixtureGameweek,
        updatedFixtureDate: nanoseconds,
      };

      let result = await identityActor.adminMoveFixture(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
        return;
      }
    } catch (error) {
      console.error("Error moving fixture:", error);
      throw error;
    }
  }

  async function postponeFixture(fixtureId: number): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: PostponeFixtureDTO = {
        fixtureId,
      };

      let result = await identityActor.adminPostponeFixture(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
        return;
      }
    } catch (error) {
      console.error("Error postponing fixture:", error);
      throw error;
    }
  }

  async function rescheduleFixture(
    fixtureId: number,
    updatedFixtureGameweek: number,
    updatedFixtureDate: string
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      const dateObject = new Date(updatedFixtureDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: RescheduleFixtureDTO = {
        postponedFixtureId: fixtureId,
        updatedFixtureGameweek,
        updatedFixtureDate: nanoseconds,
      };

      let result = await identityActor.adminRescheduleFixture(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
    loanEndDate: string
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      const dateObject = new Date(loanEndDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: LoanPlayerDTO = {
        playerId,
        loanClubId,
        loanEndDate: nanoseconds,
      };

      let result = await identityActor.adminLoanPlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
        playerId,
        newClubId,
      };

      let result = await identityActor.adminTransferPlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
        playerId,
      };

      let result = await identityActor.adminRecallPlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
    dateOfBirth: string,
    nationality: number
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      const dateObject = new Date(dateOfBirth);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: CreatePlayerDTO = {
        clubId,
        position,
        firstName,
        lastName,
        shirtNumber,
        valueQuarterMillions,
        dateOfBirth: nanoseconds,
        nationality,
      };

      let result = await identityActor.adminCreatePlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
        nationality,
      };

      let result = await identityActor.adminUpdatePlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
    expectedEndDate: string
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      const dateObject = new Date(expectedEndDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: SetPlayerInjuryDTO = {
        playerId,
        description,
        expectedEndDate: nanoseconds,
      };

      let result = await identityActor.adminSetPlayerInjury(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
        return;
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function retirePlayer(
    playerId: number,
    retirementDate: string
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      const dateObject = new Date(retirementDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: RetirePlayerDTO = {
        playerId,
        retirementDate: nanoseconds,
      };

      let result = await identityActor.adminRetirePlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
        playerId,
      };

      let result = await identityActor.adminUnretirePlayer(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
        clubId,
      };

      let result = await identityActor.adminPromoteFormerClub(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
        shirtType,
      };

      let result = await identityActor.adminPromoteNewClub(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
        shirtType,
      };

      let result = await identityActor.adminUpdateClub(dto); //TODO: POST SNS REPLACE WITH GOVERNANCE CANISTER CALL

      if (isError(result)) {
        console.error("Error submitting proposal: ", result);
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
    promoteFormerClub,
    promoteNewClub,
    updateClub,
  };
}

export const governanceStore = createGovernanceStore();
