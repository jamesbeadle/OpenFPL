<script lang="ts">
    import CopyIcon from "$lib/icons/CopyIcon.svelte";
    import { authStore } from "$lib/stores/auth-store";
    import { toasts } from "$lib/stores/toasts-store";

    export let bgColor = "bg-BrandGray";
    export let borderColor = "border-BrandGrayShade3";

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

<div class="flex items-center justify-between px-4 py-2 border rounded-lg {bgColor} {borderColor}">
    <p class="font-mono text-sm truncate text-BrandGrayShade5">
        {$authStore.identity?.getPrincipal().toString() ?? "Not available"}
    </p>
    <button 
        on:click={() => { copyTextAndShowToast($authStore.identity?.getPrincipal().toString() ?? "") }}
        class="p-2 ml-2 text-white transition-colors duration-200 rounded-lg hover:bg-BrandGrayShade2"
    >
        <CopyIcon className="w-5 h-5" fill='#FFFFFF' />
    </button>
</div>