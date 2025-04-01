import type { AppStatus } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { writable } from "svelte/store";
import { AppService } from "$lib/services/app-service";
import { toasts } from "./toasts-store";
import { isError } from "$lib/utils/helpers";

function createAppStore() {
  const { subscribe, set } = writable<AppStatus | null>(null);

  async function getAppStatus(): Promise<AppStatus | undefined> {
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

  async function checkServerVersion() {
    const res = await new AppService().getAppStatus();
    if (isError(res)) {
      throw new Error("Error fetching app status");
    }

    let status: AppStatus = res!;

    let localVersion = localStorage.getItem("version");
    if (!localVersion) {
      localStorage.setItem("version", status.version);
      return;
    }

    if (status.version !== localStorage.getItem("version")) {
      toasts.addToast({
        message: `ICFC V${status.version} is now available. Click here to reload:`,
        type: "frontend-update",
      });
    }
  }

  async function updateFrontend() {
    const res = await new AppService().getAppStatus();
    if (isError(res)) {
      throw new Error("Error fetching app status");
    }

    let status: AppStatus = res!;
    localStorage.setItem("version", status.version);
    window.location.replace(`${window.location.pathname}?v=${status.version}`);
  }

  return {
    subscribe,
    getAppStatus,
    setAppStatus: (appStatus: AppStatus) => set(appStatus),
    copyTextAndShowToast,
    checkServerVersion,
    updateFrontend,
  };
}

export const appStore = createAppStore();
