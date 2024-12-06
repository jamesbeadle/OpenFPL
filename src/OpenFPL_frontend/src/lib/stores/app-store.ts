import type { AppStatusDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { writable } from "svelte/store";
import { AppService } from "$lib/services/app-service";

function createAppStore() {
  const { subscribe, set } = writable<AppStatusDTO | null>(null);

  async function getAppStatus(): Promise<AppStatusDTO> {
    return await new AppService().getAppStatus();
  }

  return {
    subscribe,
    getAppStatus,
    setAppStatus: (appStatus: AppStatusDTO) => set(appStatus),
  };
}

export const appStore = createAppStore();
