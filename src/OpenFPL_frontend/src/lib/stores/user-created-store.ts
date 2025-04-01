import type { CreatedData } from "$lib/types/store";
import type { Option } from "$lib/types/utils";
import { writable, type Readable } from "svelte/store";

type UserCreatedStoreData<T> = Option<CreatedData<T>>;

export interface CreatedStore<T> extends Readable<UserCreatedStoreData<T>> {
  set: (data: CreatedData<T>) => void;
  reset: () => void;
}

export const initCreatedStore = <T>(): CreatedStore<T> => {
  const { subscribe, set } = writable<UserCreatedStoreData<T>>(undefined);

  return {
    subscribe,

    set(data) {
      set(data);
    },

    reset: () => {
      set(null);
    },
  };
};
