<script lang="ts">
    import { Modal } from "@dfinity/gix-components";

    export let visible: boolean;
    export let closeDetailModal: () => void;
</script>

<Modal {visible} on:nnsClose={closeDetailModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Promote New Club</h3>
        <button class="times-button" on:click={closeDetailModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            <div class="ml-4">
                <!-- //TODO: 
                    name : Text;
                    friendlyName : Text;
                    primaryColourHex : Text;
                    secondaryColourHex : Text;
                    thirdColourHex : Text;
                    abbreviatedName : Text;
                    shirtType : T.ShirtType;
                -->
            </div>
        </div>
    </div>
</Modal>