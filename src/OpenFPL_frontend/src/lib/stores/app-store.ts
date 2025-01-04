import type { AppStatusDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { writable } from "svelte/store";
import { AppService } from "$lib/services/app-service";
import { toasts } from "./toasts-store";

function createAppStore() {
  const { subscribe, set } = writable<AppStatusDTO | null>(null);

  async function getAppStatus(): Promise<AppStatusDTO | undefined> {
    return await new AppService().getAppStatus();
  }

  async function copyTextAndShowToast(text: string) {
    try {
      await navigator.clipboard.writeText(text);
      toasts.addToast({
        type: "success",
        message: "Copied to clipboard.",
        duration: 2000,
      });
    } catch (err) {
      console.error("Failed to copy:", err);
    }
  }

  return {
    subscribe,
    getAppStatus,
    setAppStatus: (appStatus: AppStatusDTO) => set(appStatus),
    copyTextAndShowToast,
  };
}

export const appStore = createAppStore();
