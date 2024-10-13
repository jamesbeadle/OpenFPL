<script lang="ts">
    import { onMount } from "svelte";
    import { toastsError } from "$lib/stores/toasts-store";
    import Layout from "../Layout.svelte";
    import LocalSpinner from "$lib/components/local-spinner.svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import CopyIcon from "$lib/icons/CopyIcon.svelte";
    import type { AdminDashboardDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { AdminService } from "$lib/services/admin-service";
    import { formatCycles } from "$lib/utils/helpers";

    let isLoading = true;
    let adminData: AdminDashboardDTO | null = null;

    onMount(async () => {
      try {
        await storeManager.syncStores();
        let adminService = new AdminService();
        adminData = await adminService.getAdminDashboard();
      } catch (error) {
        toastsError({
          msg: { text: "Error loading admin view." },
          err: error,
        });
        console.error("Error loading admin view:", error);
      } finally {
        isLoading = false;
      }
    });
</script>

<Layout>
  {#if isLoading}
    <LocalSpinner />
  {:else}
    {#if adminData}
      <div class="bg-panel rounded-md p-6 shadow-md">
        <h1 class="text-2xl font-bold mt-4 px-4">Admin Dashboard</h1>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">

          <div class="rounded-lg px-4 mt-4 shadow-sm">
            {#if adminData}
                <p>OpenFPL Backend Canister Cycles: {formatCycles(adminData.openFPLBackendCycles)}</p>
                <div class="flex flex-row items-center mt-2">
                    <p>{`dfx canister topup ${adminData.openFPLCanisterId}`}</p>
                    <CopyIcon className="w-4 ml-2" fill="#FFFFFF" />    
                </div>
            {/if}
          </div>

          <div class="rounded-lg px-4 mt-4 shadow-sm">
            {#if adminData}
                <p>OpenWSL Backend Canister Cycles: {formatCycles(adminData.openWSLBackendCycles)}</p>
                <div class="flex flex-row items-center mt-2">
                    <p>{`dfx canister topup ${adminData.openWSLCanisterId}`}</p>
                    <CopyIcon className="w-4 ml-2" fill="#FFFFFF" />    
                </div>
            {/if}
          </div>

          <div class="rounded-lg px-4 my-4 shadow-sm">
            {#if adminData}
                <p>Data Canister Cycles: {formatCycles(adminData.dataCanisterCycles)}</p>
                <div class="flex flex-row items-center mt-2">
                    <p>{`dfx canister topup ${adminData.dataCanisterId}`}</p>
                    <CopyIcon className="w-4 ml-2" fill="#FFFFFF" />    
                </div>
            {/if}
          </div>

        </div>

        <div class="rounded-lg px-4 shadow-sm">
          <h2 class="text-xl font-semibold mb-4">Manager Canisters</h2>
          <table class="min-w-full bg-gray-50 rounded-lg">
            <thead>
              <tr>
                <th class="py-2 px-4 text-left font-medium text-gray-700">Canister ID</th>
                <th class="py-2 px-4 text-left font-medium text-gray-700">Cycles</th>
              </tr>
            </thead>
            <tbody>
                {#each adminData.managerCanisters as [canisterId, cycles]}
                    <tr class="border-t">
                    <td class="py-2 px-4 text-gray-800">{canisterId}</td>
                    <td class="py-2 px-4 text-gray-800">{formatCycles(cycles)}</td>
                    </tr>
                {/each}
            </tbody>
          </table>
        </div>
      </div>
    {/if}
  {/if}
</Layout>
