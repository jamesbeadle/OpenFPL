import { writable } from "svelte/store";

interface ToastState {
  visible: boolean;
  message: string;
  type: "success" | "error";
}

function createToastStore() {
  const { subscribe, set, update } = writable<ToastState>({
    visible: false,
    message: "",
    type: "success",
  });

  function show(message: string, type: "success" | "error" = "success") {
    update(() => ({ visible: true, message, type }));
    setTimeout(
      () => set({ visible: false, message: "", type: "success" }),
      3000
    );
  }

  return { subscribe, show };
}

export const toastStore = createToastStore();
