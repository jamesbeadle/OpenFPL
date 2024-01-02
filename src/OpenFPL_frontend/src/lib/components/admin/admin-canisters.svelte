<script>
  import { adminStore } from "$lib/stores/admin-store";
  import type { 
    AdminMainCanisterInfo,
    AdminWeeklyCanisterList,
    AdminMonthlyCanisterList,
    AdminSeasonCanisterList,
    AdminProfilePictureCanisterList
   } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  //have a different array for each canister type as the table produces will have slightly different columns
    //leaderboards will have season and gameweek etc
    //profiles sho;ld have the number of pictures stored 

  let selectedCansiterType = "Main";
  let mainCanisterInfo: AdminMainCanisterInfo;
  let weeklyLeaderboardCanisters: AdminWeeklyCanisterList;
  let monthlyLeaderboardCanisters: AdminMonthlyCanisterList;
  let seasonLeaderboardCanisters: AdminSeasonCanisterList;
  let profilePictureCanisters: AdminProfilePictureCanisterList;


  
  $: canisterIds = selectedCansiterType === "Main" ? [] : 
    selectedCansiterType === "WeeklyLeaderboard" ? [] : 
    selectedCansiterType === "MonthlyLeaderboard" ? [] :
    selectedCansiterType === "SeasonLeaderboard" ? [] :
    selectedCansiterType === "Profile" ? [] :  [];

</script>



<div class="flex p-4">
  <div class="flex items-center">
    <p>Type:</p>
    <select
      class="px-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
      bind:value={selectedCansiterType}
    >
      <option value={"Main"}>Main</option>
      <option value={"WeeklyLeaderboard"}>WeeklyLeaderboard</option>
      <option value={"MonthlyLeaderboard"}>MonthlyLeaderboard</option>
      <option value={"SeasonLeaderboard"}>SeasonLeaderboard</option>
      <option value={"Profile"}>Profile</option>
    </select>
  </div>
</div>


{#each canisterIds as canisterId}

{/each}



<!-- Main Canister Info -->
<!-- Leaderboard Canister Ids Info -->
<!-- Profile Picture Canister Ids -->

<div class="flex">
  <div class="w-1/4">
    <p>Canister Id</p>
  </div>
  <div class="w-1/4">
    <p>Cycles Balanace</p>
  </div>
  <div class="w-1/4">
    <p>Options</p>
  </div>
</div>
<!-- Pagination -->
