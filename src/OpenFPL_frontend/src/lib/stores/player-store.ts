import { fixtureStore } from "$lib/stores/fixture-store";
import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  ClubFilterDTO,
  DataHashDTO,
  FixtureDTO,
  PlayerDTO,
  SeasonId,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/helpers";

function createPlayerStore() {
  const { subscribe, set } = writable<PlayerDTO[]>([]);

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let allFixtures: FixtureDTO[];
  fixtureStore.subscribe((value) => (allFixtures = value));
  console.log('Creating actor in player store line 26');
  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  async function sync() {
    let category = "players";
    console.log('actor getting data hashes in player store sync line 35');
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing player store");
      return;
    }

    let dataCacheValues: DataHashDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataHashDTO) => x.category === category) ?? null;

    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash?.hash != localHash) {
      console.log('Actor getting players in players store sync');
      let result = await actor.getPlayers();

      if (isError(result)) {
        console.error("Error fetching players data");
        return;
      }

      let updatedPlayersData = result.ok;

      updatedPlayersData.sort((a: PlayerDTO, b: PlayerDTO) => {
        if (a.clubId === b.clubId) {
          return b.valueQuarterMillions - a.valueQuarterMillions;
        }
        return a.clubId - b.clubId;
      });

      localStorage.setItem(
        category,
        JSON.stringify(updatedPlayersData, replacer),
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
    let dto: ClubFilterDTO = {
      leagueId: 1,
      clubId: clubId,
    };
    console.log('Actor getting loaned players line 92');
    let loanedPlayers = await actor.getLoanedPlayers(dto);

    if (isError(loanedPlayers)) {
      console.error("Error fetching loaned players");
      return [];
    }

    return loanedPlayers.ok;
  }

  async function getRetiredPlayers(clubId: number): Promise<PlayerDTO[]> {
    let dto: ClubFilterDTO = {
      leagueId: 1,
      clubId: clubId,
    };
    console.log('Actor getting retired players line 108');
    let retiredPlayers = await actor.getRetiredPlayers(dto);

    if (isError(retiredPlayers)) {
      console.error("Error fetching retired players");
      return [];
    }

    return retiredPlayers.ok;
  }

  return {
    subscribe,
    sync,
    getLoanedPlayers,
    getRetiredPlayers,
  };
}

export const playerStore = createPlayerStore();
