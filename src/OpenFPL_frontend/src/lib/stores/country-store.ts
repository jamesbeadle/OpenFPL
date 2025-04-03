import { writable } from "svelte/store";
import type { Country } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { CountryService } from "../services/country-service";

function createCountryStore() {
  const { subscribe, set } = writable<Country[]>([]);

  async function getCountries() {
    return new CountryService().getCountries();
  }

  return {
    subscribe,
    setCountries: (countries: Country[]) => set(countries),
    getCountries
  };
}

export const countryStore = createCountryStore();
