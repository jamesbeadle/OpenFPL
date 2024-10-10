import { writable } from "svelte/store";
import type { CountryDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createCountryStore() {
  const { subscribe, set } = writable<CountryDTO[]>([]);

  return {
    subscribe,
    setCountries: (countries: CountryDTO[]) => set(countries),
  };
}

export const countryStore = createCountryStore();
