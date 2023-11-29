// stores.ts
import { writable } from "svelte/store";

export const isLoading = writable(true);

export const loadingText = writable("Loading");
