import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  CountryDTO,
  DataCacheDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/Helpers";

function createCountriesStore() {
  const { subscribe, set } = writable<CountryDTO[]>([]);

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  async function sync() {
    let category = "countries";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing countries store");
      return;
    }

    let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataCacheDTO) => x.category === category) ??
      null;
    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash?.hash != localHash) {
      let result = await actor.getCountries();

      if (isError(result)) {
        console.error("Error fetching countries");
      }

      let updatedCountriesData = result.ok;

      localStorage.setItem(
        category,
        JSON.stringify(updatedCountriesData, replacer),
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedCountriesData);
    } else {
      const cachedCountriesData = localStorage.getItem(category);
      let cachedCountries: CountryDTO[] = [];
      try {
        cachedCountries = JSON.parse(cachedCountriesData || "[]");
      } catch (e) {
        cachedCountries = [];
      }
      set(cachedCountries);
    }
  }

  return {
    subscribe,
    sync,
  };
}

export const countriesStore = createCountriesStore();
