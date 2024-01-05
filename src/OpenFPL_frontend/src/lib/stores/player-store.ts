import { fixtureStore } from "$lib/stores/fixture-store";
import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  FixtureDTO,
  PlayerDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/Helpers";

function createPlayerStore() {
  const { subscribe, set } = writable<PlayerDTO[]>([]);

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let allFixtures: FixtureDTO[];
  fixtureStore.subscribe((value) => (allFixtures = value));

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    let category = "players";

    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing player store");
      return;
    }

    let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataCacheDTO) => x.category === category) ??
      null;
    
    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash?.hash != localHash) {
      let result = await actor.getPlayers();

      if(isError(result)){
        console.error("Error fetching players data")
        return;
      }

      let updatedPlayersData = result.ok;

      localStorage.setItem(
        category,
        JSON.stringify(updatedPlayersData, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedPlayersData);
    } else {
      const cachedPlayersData = localStorage.getItem(category);
      let cachedPlayers: PlayerDTO[] = [];
      try {
        cachedPlayers = JSON.parse(cachedPlayersData || "[]");
      } catch (e) {
        cachedPlayers = [];
      }
      set(cachedPlayers);
    }
  }

  async function getLoanedPlayers(clubId: number): Promise<PlayerDTO[]> {
    let loanedPlayers = await actor.getLoanPlayers(clubId);

    if (isError(loanedPlayers)) {
      console.error("Error fetching loaned players");
      return [];
    }

    return loanedPlayers.ok;
  }

  async function getRetiredPlayers(clubId: number): Promise<PlayerDTO[]> {
    let loanedPlayers = await actor.getRetiredPlayers(clubId);

    if (isError(loanedPlayers)) {
      console.error("Error fetching retired players");
      return [];
    }

    return loanedPlayers.ok;
  }

  return {
    subscribe,
    sync,
    getLoanedPlayers,
    getRetiredPlayers,
  };
}

export const playerStore = createPlayerStore();
