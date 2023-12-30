import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  CountryDTO,
  DataCacheDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isSuccess, replacer } from "../utils/Helpers";

function createCountriesStore() {
  const { subscribe, set } = writable<CountryDTO[] | null>(null);

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    let category = "countries";
    const newHashValues: DataCacheDTO[] = await actor.getDataHashes();
    if(isSuccess(newHashValues)){
      let liveHash = newHashValues.find((x) => x.category === category) ?? null;
      const localHash = localStorage.getItem(category);
  
      if (liveHash?.hash != localHash) {
        let updatedCountriesData = await actor.getCountries();
        console.log(updatedCountriesData);
        localStorage.setItem(
          "countries_data",
          JSON.stringify(updatedCountriesData, replacer)
        );
        localStorage.setItem(category, liveHash?.hash ?? "");
        set(updatedCountriesData);
      } else {
        const cachedCountriesData = localStorage.getItem("countries_data");
        let cachedCountries: CountryDTO[] | null = null;
        try {
          cachedCountries = JSON.parse(cachedCountriesData || "[]");
        } catch (e) {
          cachedCountries = null;
        }
        set(cachedCountries);
      }
    }
  }

  async function getCountryById(id: number): Promise<CountryDTO | undefined> {
    let countries: CountryDTO[] = [];
    subscribe((value) => {
      countries = value ?? [];
    })();
    return countries.find((country) => country.id === id);
  }

  return {
    subscribe,
    sync,
  };
}

export const countriesStore = createCountriesStore();
