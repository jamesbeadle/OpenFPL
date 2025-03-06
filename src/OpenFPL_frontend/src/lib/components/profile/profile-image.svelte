<script lang="ts">
    import { userGetProfilePicture } from "$lib/derived/user.derived";
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";

    let fileInput: HTMLInputElement;
    
    let uploadingImage = false;

    function clickFileInput() {
        fileInput.click();
    }

    function handleFileChange(event: Event) {
        const input = event.target as HTMLInputElement;
        if (input.files && input.files[0]) {
            const file = input.files[0];
            if (file.size > 1000 * 1024) {
                toasts.addToast({ type: "error", message: "Profile image too large. The maximum size is 1MB." });
                console.error("Error updating profile image.");
                return;
            }
            uploadProfileImage(file);
        }
    }

    async function uploadProfileImage(file: File) {
        uploadingImage = true;

        try {
            await userStore.updateProfilePicture(file);
            await userStore.cacheProfile();
            await userStore.sync();
            toasts.addToast({
                message: "Profile image updated.",
                type: "success",
                duration: 2000,
            });
        } catch (error) {
            toasts.addToast({
                message: "Error updating profile image." ,
                type: "error",
            });
            console.error("Error updating profile image", error);
        } finally {
            uploadingImage = false;
        }
    }
</script>
<div class="w-full px-2 md:w-1/2 lg:w-1/3 xl:w-1/4">
    <div class="flex flex-col group md:block">
        <img src={$userGetProfilePicture} alt="Profile" class="w-full mb-1 rounded-lg" />

        <div class="mt-4 file-upload-wrapper">
            <button class="btn-file-upload fpl-button" on:click={clickFileInput}>Upload Photo</button>
            <input
                type="file"
                id="profile-image"
                accept="image/*"
                bind:this={fileInput}
                on:change={handleFileChange}
                style="opacity: 0; position: absolute; left: 0; top: 0;"
            />
        </div>
    </div>
</div>