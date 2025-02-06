import { writable } from "svelte/store";
import type { CountryDTO } from "../../../../external_declarations/data_canister/data_canister.did";

function createCountryStore() {
  const { subscribe, set } = writable<CountryDTO[]>([]);

  return {
    subscribe,
    setCountries: (countries: CountryDTO[]) => set(countries),
  };
}

export const countryStore = createCountryStore();
