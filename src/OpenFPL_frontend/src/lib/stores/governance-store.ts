import { authStore } from "$lib/stores/auth.store";
import { SnsGovernanceCanister } from "@dfinity/sns";
import { playerStore } from "$lib/stores/player-store";
import { isError } from "$lib/utils/Helpers";
import type {
  AddInitialFixturesDTO,
  ClubDTO,
  CreatePlayerDTO,
  FixtureDTO,
  LoanPlayerDTO,
  MoveFixtureDTO,
  PlayerDTO,
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
  SystemStateDTO,
  TransferPlayerDTO,
  UnretirePlayerDTO,
  UpdateClubDTO,
  UpdatePlayerDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import type { HttpAgent } from "@dfinity/agent";
import type { Command, ExecuteGenericNervousSystemFunction, GetProposal, RegisterVote } from "@dfinity/sns/dist/candid/sns_governance";
import { fixtureStore } from "./fixture-store";
import { systemStore } from "./system-store";
import { teamStore } from "./team-store";

function createGovernanceStore() {
  async function revaluePlayerUp(playerId: number): Promise<any> {
    try {
      await playerStore.sync();
        

      let allPlayers: PlayerDTO[] = [];
      const unsubscribe = playerStore.subscribe((players) => {
        allPlayers = players;
      });
      unsubscribe();

      var dto: RevaluePlayerUpDTO = {
        playerId: playerId,
      };
      
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_GOVERNANCE_CANISTER_ID ?? ""
      ); //TODO: Post SNS add in governance canister references

      const governanceAgent: HttpAgent = ActorFactory.getAgent(process.env.OPENFPL_GOVERNANCE_CANISTER_ID, identityActor, null);

      const { manageNeuron: governanceManageNeuron, listNeurons: governanceListNeurons } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor,
      });

      const userNeurons = await governanceListNeurons({ 
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: {id: []}});
      if(userNeurons.length > 0){
        const jsonString = JSON.stringify(dto);

        const encoder = new TextEncoder();
        const payload = encoder.encode(jsonString);

        const fn: ExecuteGenericNervousSystemFunction = {
          function_id: 1000n,
          payload: payload
        }

        let player = allPlayers.find(x => x.id == playerId);
        if(player){
          const command: Command = {MakeProposal: {
            title: `Revalue ${player.lastName} value up.`,
            url: "openfpl.xyz/governance",
            summary: `Revalue ${player.lastName} value up from £${(player.valueQuarterMillions / 4).toFixed(2).toLocaleString()}m -> £${((player.valueQuarterMillions + 1)/4).toFixed(2).toLocaleString()}m).`,
            action:  [{ ExecuteGenericNervousSystemFunction : fn }]
          }};

          const neuronId = userNeurons[0].id[0];
          if(!neuronId){
            return;
          }
          
          await governanceManageNeuron({ subaccount: neuronId.id, command: [command]});

        }
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

      var dto: RevaluePlayerDownDTO = {
        playerId: playerId,
      };
      
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_GOVERNANCE_CANISTER_ID ?? ""
      ); //TODO: Post SNS add in governance canister references

      const governanceAgent: HttpAgent = ActorFactory.getAgent(process.env.OPENFPL_GOVERNANCE_CANISTER_ID, identityActor, null);

      const { manageNeuron: governanceManageNeuron, listNeurons: governanceListNeurons } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor,
      });

      const userNeurons = await governanceListNeurons({ 
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: {id: []}});
      if(userNeurons.length > 0){
        const jsonString = JSON.stringify(dto);

        const encoder = new TextEncoder();
        const payload = encoder.encode(jsonString);

        const fn: ExecuteGenericNervousSystemFunction = {
          function_id: 2000n,
          payload: payload
        }

        let player = allPlayers.find(x => x.id == playerId);
        if(player){
          const command: Command = {MakeProposal: {
            title: `Revalue ${player.lastName} value down.`,
            url: "openfpl.xyz/governance",
            summary: `Revalue ${player.lastName} value down from £${(player.valueQuarterMillions / 4).toFixed(2).toLocaleString()}m -> £${((player.valueQuarterMillions - 1)/4).toFixed(2).toLocaleString()}m).`,
            action:  [{ ExecuteGenericNervousSystemFunction : fn }]
          }};

          const neuronId = userNeurons[0].id[0];
          if(!neuronId){
            return;
          }
          
          await governanceManageNeuron({ subaccount: neuronId.id, command: [command]});

        }
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
    playerEventData: PlayerEventData[]
  ): Promise<any> {
    try {
      await teamStore.sync();
      
      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if(teams){
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
        seasonId,
        gameweek,
        fixtureId,
        playerEventData,
      };
      
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_GOVERNANCE_CANISTER_ID ?? ""
      ); //TODO: Post SNS add in governance canister references

      const governanceAgent: HttpAgent = ActorFactory.getAgent(process.env.OPENFPL_GOVERNANCE_CANISTER_ID, identityActor, null);

      const { manageNeuron: governanceManageNeuron, listNeurons: governanceListNeurons } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor,
      });

      const userNeurons = await governanceListNeurons({ 
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: {id: []}});
      if(userNeurons.length > 0){
        const jsonString = JSON.stringify(dto);

        const encoder = new TextEncoder();
        const payload = encoder.encode(jsonString);

        const fn: ExecuteGenericNervousSystemFunction = {
          function_id: 3000n,
          payload: payload
        }

        let fixture = allFixtures.find(x => x.id == fixtureId);
        if(fixture){
          let homeClub = clubs.find(x => x.id == fixture?.homeClubId);
          let awayClub = clubs.find(x => x.id == fixture?.awayClubId);
          if(!homeClub || !awayClub){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
            url: "openfpl.xyz/governance",
            summary:  `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
            action:  [{ ExecuteGenericNervousSystemFunction : fn }]
          }};

          const neuronId = userNeurons[0].id[0];
          if(!neuronId){
            return;
          }
          
          await governanceManageNeuron({ subaccount: neuronId.id, command: [command]});

        }
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
    try {
      await systemStore.sync();
      let seasonName = "";

      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if(systemState){
          seasonName = systemState?.calculationSeasonName;
        }
      });
      unsubscribeSystemStore();

      let dto: AddInitialFixturesDTO = {
        seasonId,
        seasonFixtures,
      };
      
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_GOVERNANCE_CANISTER_ID ?? ""
      ); //TODO: Post SNS add in governance canister references

      const governanceAgent: HttpAgent = ActorFactory.getAgent(process.env.OPENFPL_GOVERNANCE_CANISTER_ID, identityActor, null);

      const { manageNeuron: governanceManageNeuron, listNeurons: governanceListNeurons } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor,
      });

      const userNeurons = await governanceListNeurons({ 
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: {id: []}});
      if(userNeurons.length > 0){
        const jsonString = JSON.stringify(dto);

        const encoder = new TextEncoder();
        const payload = encoder.encode(jsonString);

        const fn: ExecuteGenericNervousSystemFunction = {
          function_id: 4000n,
          payload: payload
        }
        
        const command: Command = {MakeProposal: {
          title: `Add initial fixtures for season ${seasonName}.`,
          url: "openfpl.xyz/governance",
          summary: `Add initial fixtures for season ${seasonName}.`,
          action:  [{ ExecuteGenericNervousSystemFunction : fn }]
        }};

        const neuronId = userNeurons[0].id[0];
        if(!neuronId){
          return;
        }
        
        await governanceManageNeuron({ subaccount: neuronId.id, command: [command]});
      }
    } catch (error) {
      console.error("Error adding initial fixtures:", error);
      throw error;
    }
  }

  async function moveFixture(
    fixtureId: number,
    updatedFixtureGameweek: number,
    updatedFixtureDate: string
  ): Promise<any> {
    try {
      await teamStore.sync();
      
      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if(teams){
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

      let seasonId = 0;

      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if(systemState){
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
      
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_GOVERNANCE_CANISTER_ID ?? ""
      ); //TODO: Post SNS add in governance canister references

      const governanceAgent: HttpAgent = ActorFactory.getAgent(process.env.OPENFPL_GOVERNANCE_CANISTER_ID, identityActor, null);

      const { manageNeuron: governanceManageNeuron, listNeurons: governanceListNeurons } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor,
      });

      const userNeurons = await governanceListNeurons({ 
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: {id: []}});
      if(userNeurons.length > 0){
        const jsonString = JSON.stringify(dto);

        const encoder = new TextEncoder();
        const payload = encoder.encode(jsonString);

        const fn: ExecuteGenericNervousSystemFunction = {
          function_id: 5000n,
          payload: payload
        }

        let fixture = allFixtures.find(x => x.id == fixtureId);
        if(fixture){
          let homeClub = clubs.find(x => x.id == fixture?.homeClubId);
          let awayClub = clubs.find(x => x.id == fixture?.awayClubId);
          if(!homeClub || !awayClub){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Move fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
            url: "openfpl.xyz/governance",
            summary:  `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
            action:  [{ ExecuteGenericNervousSystemFunction : fn }]
          }};

          const neuronId = userNeurons[0].id[0];
          if(!neuronId){
            return;
          }
          
          await governanceManageNeuron({ subaccount: neuronId.id, command: [command]});

        }
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }






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
