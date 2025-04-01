import { writable } from "svelte/store";
import type { Country } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createCountryStore() {
  const { subscribe, set } = writable<Country[]>([]);

  return {
    subscribe,
    setCountries: (countries: Country[]) => set(countries),
  };
}

export const countryStore = createCountryStore();
