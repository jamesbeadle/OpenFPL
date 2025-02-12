import { writable } from "svelte/store";

export interface Toast {
  id: number;
  message: string;
  type?: "info" | "success" | "error" | "frontend-update";
  duration?: number;
}

function createToastsStore() {
  const { subscribe, update } = writable<Toast[]>([]);
  let idCounter = 0;

  function addToast(toast: Omit<Toast, "id">) {
    update((toasts) => [...toasts, { ...toast, id: ++idCounter }]);
  }

  function removeToast(id: number) {
    update((toasts) => toasts.filter((toast) => toast.id !== id));
  }

  return {
    subscribe,
    addToast,
    removeToast,
  };
}

export const toasts = createToastsStore();
export const { addToast } = toasts;
