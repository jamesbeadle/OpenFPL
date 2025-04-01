<script lang="ts">
    import CopyIcon from "$lib/icons/CopyIcon.svelte";
    import { authStore } from "$lib/stores/auth-store";
    import { toasts } from "$lib/stores/toasts-store";

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
</script>

<div class="relative bg-BrandGrayShade2 rounded-lg p-4">
    <button 
        on:click={() => { copyTextAndShowToast($authStore.identity?.getPrincipal().toString() ?? "") }}
        class="absolute top-2 right-2 text-white"
    >
        <CopyIcon className="w-5 h-5" fill='#FFFFFF' />
    </button>
    <p class="text-white font-mono text-sm break-all px-4">
        {$authStore.identity?.getPrincipal().toString() ?? "Not available"}
    </p>
</div>