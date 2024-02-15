
import { SnsGovernanceCanister } from "@dfinity/sns";
import type { HttpAgent } from "@dfinity/agent";
import type { Command, ExecuteGenericNervousSystemFunction } from "@dfinity/sns/dist/candid/sns_governance";
import { authStore } from "$lib/stores/auth.store";
import { fixtureStore } from "./fixture-store";
import { systemStore } from "./system-store";
import { teamStore } from "./team-store";
import { playerStore } from "$lib/stores/player-store";
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
      console.error("Error moving fixture:", error);
      throw error;
    }
  }

  async function postponeFixture(fixtureId: number): Promise<any> {
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

      let dto: PostponeFixtureDTO = {
        fixtureId,
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
          function_id: 6000n,
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
            title: `Postpone fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
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
          function_id: 7000n,
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
      console.error("Error rescheduling fixture:", error);
      throw error;
    }
  }

  async function transferPlayer(
    playerId: number,
    newClubId: number
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();
      
      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if(teams){
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      
      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if(players){
          allPlayers = players;
        }
      });
      unsubscribeTeamStore();

      let dto: TransferPlayerDTO = {
        playerId,
        newClubId,
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
          function_id: 8000n,
          payload: payload
        }

        let player = allPlayers.find(x => x.id == playerId);
        if(player){
          let currentClub = clubs.find(x => x.id == player?.clubId);
          let newClub = clubs.find(x => x.id == newClubId);
          if(!currentClub){
            return;
          }

          let title = "";
          if(newClubId == 0){
            title = `Transfer ${player.firstName} ${player.lastName} outside of Premier League.`;
          }

          if(newClub){
            title = `Transfer ${player.firstName} ${player.lastName} to ${newClub.friendlyName}`;
          }
          
          const command: Command = {MakeProposal: {
            title: title,
            url: "openfpl.xyz/governance",
            summary:  title,
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
      console.error("Error transferring player:", error);
      throw error;
    }
  }

  async function loanPlayer(
    playerId: number,
    loanClubId: number,
    loanEndDate: string
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();
      
      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if(teams){
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      
      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if(players){
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      const dateObject = new Date(loanEndDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1000000);

      let dto: LoanPlayerDTO = {
        playerId,
        loanClubId,
        loanEndDate: nanoseconds,
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
          function_id: 9000n,
          payload: payload
        }

        let player = allPlayers.find(x => x.id == playerId);
        if(player){
          let club = clubs.find(x => x.id == player?.clubId);
          if(!club){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Loan ${player.firstName} to ${club?.friendlyName}.`,
            url: "openfpl.xyz/governance",
            summary:  `Loan ${player.firstName} to ${club?.friendlyName}.`,
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
        if(teams){
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      
      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if(players){
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      let dto: RecallPlayerDTO = {
        playerId,
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
          function_id: 10000n,
          payload: payload
        }

        let player = allPlayers.find(x => x.id == playerId);
        if(player){
          let club = clubs.find(x => x.id == player?.clubId);
          if(!club){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Recall ${player.firstName} ${player?.lastName} loan.`,
            url: "openfpl.xyz/governance",
            summary:   `Recall ${player.firstName} ${player?.lastName} loan.`,
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
    nationality: number
  ): Promise<any> {
    try {
      
      await teamStore.sync();
      await playerStore.sync();
      
      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if(teams){
          clubs = teams;
        }
      });
      unsubscribeTeamStore();

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
          function_id: 11000n,
          payload: payload
        }
        
          let club = clubs.find(x => x.id == clubId);
          if(!club){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Create New Player: ${firstName} v ${lastName}.`,
            url: "openfpl.xyz/governance",
            summary: `Create New Player: ${firstName} v ${lastName}.`,
            action:  [{ ExecuteGenericNervousSystemFunction : fn }]
          }};

          const neuronId = userNeurons[0].id[0];
          if(!neuronId){
            return;
          }
          
          await governanceManageNeuron({ subaccount: neuronId.id, command: [command]});
        }
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
    nationality: number
  ): Promise<any> {
    try {
      
      await teamStore.sync();
      await playerStore.sync();
      
      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if(teams){
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      
      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if(players){
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      let dto: UpdatePlayerDTO = {
        playerId,
        position,
        firstName,
        lastName,
        shirtNumber,
        dateOfBirth: BigInt(dateOfBirth),
        nationality,
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
          function_id: 12000n,
          payload: payload
        }

        let player = allPlayers.find(x => x.id == playerId);
        if(player){
          let club = clubs.find(x => x.id == player?.clubId);
          if(!club){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Update ${player.firstName} ${player.lastName} details.`,
            url: "openfpl.xyz/governance",
            summary:  `Update ${player.firstName} ${player.lastName} details.`,
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
      console.error("Error updating player:", error);
      throw error;
    }
  }

  async function setPlayerInjury(
    playerId: number,
    description: string,
    expectedEndDate: string
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();
      
      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if(teams){
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      
      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if(players){
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
          function_id: 13000n,
          payload: payload
        }

        let player = allPlayers.find(x => x.id == playerId);
        if(player){
          let club = clubs.find(x => x.id == player?.clubId);
          if(!club){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Set Player Injury for ${player.firstName} ${player.lastName}.`,
            url: "openfpl.xyz/governance",
            summary:  `Set Player Injury for ${player.firstName} ${player.lastName}.`,
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
      console.error("Error setting player injury:", error);
      throw error;
    }
  }

  async function retirePlayer(
    playerId: number,
    retirementDate: string
  ): Promise<any> {
    try {
      await teamStore.sync();
      await playerStore.sync();
      
      let clubs: ClubDTO[] = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if(teams){
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      
      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if(players){
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
          function_id: 14000n,
          payload: payload
        }

        let player = allPlayers.find(x => x.id == playerId);
        if(player){
          let club = clubs.find(x => x.id == player?.clubId);
          if(!club){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Retire ${player.firstName} ${player.lastName}.`,
            url: "openfpl.xyz/governance",
            summary:  `Retire ${player.firstName} ${player.lastName}.`,
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
        if(teams){
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      
      let allPlayers: PlayerDTO[] = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if(players){
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();

      let dto: UnretirePlayerDTO = {
        playerId,
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
          function_id: 15000n,
          payload: payload
        }

        let player = allPlayers.find(x => x.id == playerId);
        if(player){
          let club = clubs.find(x => x.id == player?.clubId);
          if(!club){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Unretire ${player.firstName} ${player.lastName}.`,
            url: "openfpl.xyz/governance",
            summary:  `Unretire ${player.firstName} ${player.lastName}.`,
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
      console.error("Error unretiring player:", error);
      throw error;
    }
  }

  async function promoteFormerClub(clubId: number): Promise<any> {
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

      let dto: PromoteFormerClubDTO = {
        clubId,
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
          function_id: 16000n,
          payload: payload
        }
        
          let club = clubs.find(x => x.id == clubId);
          if(!club){
            return;
          }
          
          const command: Command = {MakeProposal: {
            title: `Promote ${club.friendlyName}.`,
            url: "openfpl.xyz/governance",
            summary: `Promote ${club.friendlyName}.`,
            action:  [{ ExecuteGenericNervousSystemFunction : fn }]
          }};

          const neuronId = userNeurons[0].id[0];
          if(!neuronId){
            return;
          }
          
          await governanceManageNeuron({ subaccount: neuronId.id, command: [command]});

        }
    } catch (error) {
      console.error("Error promoting former club:", error);
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
      
      let dto: PromoteNewClubDTO = {
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType,
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
          function_id: 17000n,
          payload: payload
        }
  
        const command: Command = {MakeProposal: {
          title: `Promote ${friendlyName}.`,
          url: "openfpl.xyz/governance",
          summary:  `Promote ${friendlyName}.`,
          action:  [{ ExecuteGenericNervousSystemFunction : fn }]
        }};

        const neuronId = userNeurons[0].id[0];
        if(!neuronId){
          return;
        }
        
        await governanceManageNeuron({ subaccount: neuronId.id, command: [command]});

      }
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
    shirtType: ShirtType
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
          function_id: 18000n,
          payload: payload
        }

        let club = clubs.find(x => x.id == clubId);
        if(!club){
          return;
        }
        
        const command: Command = {MakeProposal: {
          title: `Update ${club.friendlyName} club details.`,
          url: "openfpl.xyz/governance",
          summary:  `Update ${club.friendlyName} club details.`,
          action:  [{ ExecuteGenericNervousSystemFunction : fn }]
        }};

        const neuronId = userNeurons[0].id[0];
        if(!neuronId){
          return;
        }
        
        await governanceManageNeuron({ subaccount: neuronId.id, command: [command]});

      }
    } catch (error) {
      console.error("Error updating club:", error);
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
