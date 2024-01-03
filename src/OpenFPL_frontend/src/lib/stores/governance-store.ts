import { authStore } from "$lib/stores/auth.store";
import type { FixtureDTO, PlayerEventData, PlayerPosition, ShirtType } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createGovernanceStore() {

  async function revaluePlayerUp(playerId: number) : Promise<void>{
    //TODO: Implement
  }

  async function revaluePlayerDown(playerId: number) : Promise<void>{
    //TODO: Implement
  }

  async function submitFixtureData(seasonId: number, gameweek : number, fixtureId: number, playerEventData: PlayerEventData[]) : Promise<void>{
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      //let result = await identityActor.savePlayerEvents(
       // fixtureId,
      //  allPlayerEvents
      //);
      //TODO: Add in admin fixture submission logic
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  async function initialFixtures(seasonId: number, seasonFixtures: FixtureDTO[]){
    //TODO: Implement
  }

  async function rescheduleFixture(seasonId: number, fixtureId: number, updatedFixtureGameweek: number, updatedFixtureDate: number) : Promise<void>{
    
  }

  async function loanPlayer(playerId: number, loanClubId: number, loanEndDate: number) : Promise<void>{
    //TODO: Implement
  }

  async function transferPlayer(playerId: number, newClubId: number) : Promise<void>{
    //TODO: Implement
  }

  async function recallPlayer(playerId: number) : Promise<void>{
    //TODO: Implement
  }

  async function createPlayer(
    clubId: number, 
    position: PlayerPosition,
    firstName: string,
    lastName: string,
    shirtNumber: number,
    valueQuarterMillions: number,
    dateOfBirth: number,
    nationality: number) : Promise<void>{
    //TODO: Implement
  }

  async function updatePlayer(
    playerId: number,
    position: number,
    firstName: string,
    lastName: string,
    shirtNumber: number,
    dateOfBirth: number,
    nationality: number) : Promise<void>{
    //TODO: Implement
  }

  async function setPlayerInjury(
    playerId: number,
    description: string,
    expectedEndDate: number){
    //TODO: Implement
  }

  async function retirePlayer( 
    playerId: number,
    retirementDate: number) : Promise<void>{
    //TODO: Implement
  }

  async function unretirePlayer(playerId : number) : Promise<void>{
    //TODO: Implement
  }

  async function promoteFormerClub(clubId: number) : Promise<void>{
    //TODO: Implement
  }

  async function promoteNewClub(
    name: string,
    friendlyName: string,
    primaryColourHex: string,
    secondaryColourHex: string,
    thirdColourHex: string,
    abbreviatedName: string,
    shirtType: ShirtType) : Promise<void>{
    //TODO: Implement
  }

  async function updateClub(
    clubId: number,
    name: string,
    friendlyName: Text,
    primaryColourHex: Text,
    secondaryColourHex: Text,
    thirdColourHex: Text,
    abbreviatedName: Text,
    shirtType: ShirtType) : Promise<void>{
    //TODO: Implement
  }

  return {
    revaluePlayerUp,
    revaluePlayerDown,
    submitFixtureData,
    initialFixtures,
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
    updateClub
  };
}

export const governanceStore = createGovernanceStore();
