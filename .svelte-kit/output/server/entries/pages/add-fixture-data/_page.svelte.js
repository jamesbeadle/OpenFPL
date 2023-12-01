import { c as create_ssr_component, a as subscribe, e as escape, b as each, d as add_attribute, o as onDestroy, v as validate_component, f as noop } from "../../../chunks/index2.js";
import { p as page } from "../../../chunks/stores.js";
import { w as writable } from "../../../chunks/index.js";
import { A as ActorFactory } from "../../../chunks/team-store.js";
import "../../../chunks/fixture-store.js";
import { i as isLoading, l as loadingText, t as toastStore, L as Layout } from "../../../chunks/Layout.js";
import { a as authStore } from "../../../chunks/auth.js";
function client_method(key) {
  {
    if (key === "before_navigate" || key === "after_navigate" || key === "on_navigate") {
      return () => {
      };
    } else {
      const name_lookup = {
        disable_scroll_handling: "disableScrollHandling",
        preload_data: "preloadData",
        preload_code: "preloadCode",
        invalidate_all: "invalidateAll"
      };
      return () => {
        throw new Error(`Cannot call ${name_lookup[key] ?? key}(...) on the server`);
      };
    }
  }
}
const goto = /* @__PURE__ */ client_method("goto");
const Player_events_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $playerEventData, $$unsubscribe_playerEventData;
  let { show = false } = $$props;
  let { player } = $$props;
  let { fixtureId } = $$props;
  let { playerEventData } = $$props;
  $$unsubscribe_playerEventData = subscribe(playerEventData, (value) => $playerEventData = value);
  let eventStartTime = 0;
  let eventEndTime = 0;
  const eventOptions = [
    { id: 0, label: "Appearance" },
    { id: 1, label: "Goal Scored" },
    { id: 2, label: "Goal Assisted" },
    { id: 7, label: "Penalty Missed" },
    { id: 8, label: "Yellow Card" },
    { id: 9, label: "Red Card" },
    { id: 10, label: "Own Goal" }
  ];
  if ($$props.show === void 0 && $$bindings.show && show !== void 0)
    $$bindings.show(show);
  if ($$props.player === void 0 && $$bindings.player && player !== void 0)
    $$bindings.player(player);
  if ($$props.fixtureId === void 0 && $$bindings.fixtureId && fixtureId !== void 0)
    $$bindings.fixtureId(fixtureId);
  if ($$props.playerEventData === void 0 && $$bindings.playerEventData && playerEventData !== void 0)
    $$bindings.playerEventData(playerEventData);
  $$unsubscribe_playerEventData();
  return `${show ? `<div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"><div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md">${player ? `<div class="flex justify-between items-center"><h4 class="text-lg font-bold">${escape(player.firstName !== "" ? player.firstName.charAt(0) + "." : "")}
            ${escape(player.lastName)} - Match Events
          </h4>
          <button class="text-black">✕</button></div>

        <div class="mt-4 p-4 border-t border-gray-200"><h4 class="text-lg font-bold mb-3">Add Event</h4>
          <div class="flex flex-col gap-3"><div><label for="eventType" class="block text-sm font-medium text-gray-700">Event Type</label>
              <select id="eventType" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"><option value="-1" disabled>Select event type</option>${each(eventOptions, (option) => {
    return `<option${add_attribute("value", option.id, 0)}>${escape(option.label)}</option>`;
  })}</select></div>
            <div><label for="startMinute" class="block text-sm font-medium text-gray-700">Start Minute</label>
              <input type="number" id="startMinute" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md" placeholder="Enter start minute"${add_attribute("value", eventStartTime, 0)}></div>
            <div><label for="endMinute" class="block text-sm font-medium text-gray-700">End Minute</label>
              <input type="number" id="endMinute" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md" placeholder="Enter end minute"${add_attribute("value", eventEndTime, 0)}></div>
            <button class="mt-2 px-4 py-2 bg-blue-500 text-white rounded">Add Event</button></div></div>

        <div class="mt-4"><ul class="list-disc pl-5">${each($playerEventData, (event, index) => {
    return `<li class="flex justify-between items-center mb-2"><span>${escape(event.eventType)} - From ${escape(event.eventStartMinute)} to ${escape(event.eventEndMinute)}
                  minutes</span>
                <button class="px-3 py-1 bg-red-500 text-white rounded">Remove
                </button>
              </li>`;
  })}</ul></div>` : ``}
      <div class="flex justify-end gap-3 mt-4"><button class="px-4 py-2 bg-blue-500 text-white rounded">Done</button></div></div></div>` : ``}`;
});
const Select_players_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $teamPlayers, $$unsubscribe_teamPlayers;
  let $selectedPlayers, $$unsubscribe_selectedPlayers;
  let { teamPlayers = writable([]) } = $$props;
  $$unsubscribe_teamPlayers = subscribe(teamPlayers, (value) => $teamPlayers = value);
  let { selectedTeam } = $$props;
  let { selectedPlayers = writable([]) } = $$props;
  $$unsubscribe_selectedPlayers = subscribe(selectedPlayers, (value) => $selectedPlayers = value);
  let { show = false } = $$props;
  if ($$props.teamPlayers === void 0 && $$bindings.teamPlayers && teamPlayers !== void 0)
    $$bindings.teamPlayers(teamPlayers);
  if ($$props.selectedTeam === void 0 && $$bindings.selectedTeam && selectedTeam !== void 0)
    $$bindings.selectedTeam(selectedTeam);
  if ($$props.selectedPlayers === void 0 && $$bindings.selectedPlayers && selectedPlayers !== void 0)
    $$bindings.selectedPlayers(selectedPlayers);
  if ($$props.show === void 0 && $$bindings.show && show !== void 0)
    $$bindings.show(show);
  $$unsubscribe_teamPlayers();
  $$unsubscribe_selectedPlayers();
  return `${show ? `<div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"><div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md"><div class="flex justify-between items-center"><h4 class="text-lg font-bold">Select ${escape(selectedTeam.friendlyName)} Players
        </h4>
        <button class="text-black">✕</button></div>
      <div class="my-5 flex flex-wrap">${each($teamPlayers, (player) => {
    let selected = $selectedPlayers.some((p) => p.id === player.id);
    return `
          <div class="flex-1 sm:flex-basis-1/2"><label class="block"><input type="checkbox" ${selected ? "checked" : ""}>
              ${escape(`${player.firstName.length > 0 ? player.firstName.charAt(0) + "." : ""} ${player.lastName}`)}</label>
          </div>`;
  })}</div>
      <div class="flex justify-end gap-3"><button class="px-4 py-2 border rounded text-black">Cancel</button>
        <button class="px-4 py-2 bg-blue-500 text-white rounded">Select Players</button></div></div></div>` : ``}`;
});
const Confirm_fixture_data_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { show = false } = $$props;
  let { onConfirm } = $$props;
  if ($$props.show === void 0 && $$bindings.show && show !== void 0)
    $$bindings.show(show);
  if ($$props.onConfirm === void 0 && $$bindings.onConfirm && onConfirm !== void 0)
    $$bindings.onConfirm(onConfirm);
  return `${show ? `<div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"><div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md"><div class="flex justify-between items-center"><h4 class="text-lg font-bold">Confirm Fixture Data</h4>
        <button class="text-black">✕</button></div>
      <div class="my-5"><h1>Please confirm your fixture data.</h1>
        <p class="text-sm text-gray-600">You will not be able to edit your submission and entries that differ
          from the accepted consensus data will not receive $FPL rewards. If
          consensus has already been reached for the fixture your submission
          will also not be counted.
        </p></div>
      <div class="flex justify-end gap-3"><button class="px-4 py-2 border rounded text-black">Cancel</button>
        <button class="px-4 py-2 bg-blue-500 text-white rounded">Confirm</button></div></div></div>` : ``}`;
});
const Clear_draft_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { show = false } = $$props;
  let { onConfirm } = $$props;
  if ($$props.show === void 0 && $$bindings.show && show !== void 0)
    $$bindings.show(show);
  if ($$props.onConfirm === void 0 && $$bindings.onConfirm && onConfirm !== void 0)
    $$bindings.onConfirm(onConfirm);
  return `${show ? `<div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"><div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md"><div class="flex justify-between items-center"><h4 class="text-lg font-bold">Confirm Clear Draft</h4>
        <button class="text-black">✕</button></div>
      <div class="my-5"><h1>Please confirm you want to clear the draft from your cache.</h1></div>
      <div class="flex justify-end gap-3"><button class="px-4 py-2 border rounded text-black">Cancel</button>
        <button class="px-4 py-2 bg-blue-500 text-white rounded">Confirm</button></div></div></div>` : ``}`;
});
function createGovernanceStore() {
  const { subscribe: subscribe2, set } = writable([]);
  async function getValidatableFixtures() {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.OPENFPL_BACKEND_CANISTER_ID
    );
    const fixtures = await identityActor.getValidatableFixtures();
    set(fixtures);
    return fixtures;
  }
  async function submitFixtureData(fixtureId, allPlayerEvents) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      await identityActor.submitFixtureData(fixtureId, allPlayerEvents);
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }
  return {
    subscribe: subscribe2,
    getValidatableFixtures,
    submitFixtureData
  };
}
const governanceStore = createGovernanceStore();
let showPlayerSelectionModal = false;
let showClearDraftModal = false;
let showConfirmDataModal = false;
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let fixtureId;
  let $playerEventData, $$unsubscribe_playerEventData = noop, $$subscribe_playerEventData = () => ($$unsubscribe_playerEventData(), $$unsubscribe_playerEventData = subscribe(playerEventData, ($$value) => $playerEventData = $$value), playerEventData);
  let $page, $$unsubscribe_page;
  let $selectedPlayers, $$unsubscribe_selectedPlayers;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let teams;
  let fixture;
  let showPlayerEventModal = false;
  let teamPlayers = writable([]);
  let selectedPlayers = writable([]);
  $$unsubscribe_selectedPlayers = subscribe(selectedPlayers, (value) => $selectedPlayers = value);
  let selectedTeam;
  let selectedPlayer;
  let playerEventData = writable([]);
  $$subscribe_playerEventData();
  onDestroy(() => {
  });
  async function confirmFixtureData() {
    isLoading.set(true);
    loadingText.set("Saving Fixture Data");
    try {
      await governanceStore.submitFixtureData(fixtureId, $playerEventData);
      localStorage.removeItem(`fixtureDraft_${fixtureId}`);
      toastStore.show("Fixture data saved", "success");
      goto("/fixture-validation");
    } catch (error) {
      toastStore.show("Error saving fixture data.", "error");
      console.error("Error saving fixture data: ", error);
    } finally {
      isLoading.set(false);
      loadingText.set("Loading");
    }
  }
  function clearDraft() {
    $$subscribe_playerEventData(playerEventData = writable([]));
    localStorage.removeItem(`fixtureDraft_${fixtureId}`);
    toastStore.show("Draft cleared.", "success");
  }
  function getTeamFromId(teamId) {
    return teams.find((team) => team.id === teamId);
  }
  fixtureId = Number($page.url.searchParams.get("id"));
  $$unsubscribe_playerEventData();
  $$unsubscribe_page();
  $$unsubscribe_selectedPlayers();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${isLoading ? `<div class="flex items-center justify-center h-screen"><p class="text-center mt-1">Loading Fixture Data...</p></div>` : `<div class="m-4"><button class="fpl-button">Save Draft</button>
      <div class="bg-panel rounded-lg m-4"><ul class="flex rounded-t-lg bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-base ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>${escape(getTeamFromId(0)?.friendlyName)}</button></li>
          <li${add_attribute("class", `mr-4 text-xs md:text-base ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>${escape(getTeamFromId(0)?.friendlyName)}</button></li></ul>

        ${`${each($selectedPlayers.filter((x) => x.teamId === fixture?.homeTeamId), (player) => {
        return `<div class="card player-card mb-4"><div class="card-header"><h5>${escape(player.lastName)}</h5>
                <p class="small-text mb-0 mt-0">${escape(player.firstName)}</p></div>
              <div class="card-body"><p>Events: ${escape($playerEventData.filter((pe) => pe.playerId === player.id).length)}</p>
                <button>Update</button></div>
            </div>`;
      })}`}</div></div>`}`;
    }
  })}

${validate_component(Select_players_modal, "SelectPlayersModal").$$render(
    $$result,
    {
      show: showPlayerSelectionModal,
      teamPlayers,
      selectedTeam,
      selectedPlayers
    },
    {},
    {}
  )}
${validate_component(Player_events_modal, "PlayerEventsModal").$$render(
    $$result,
    {
      show: showPlayerEventModal,
      player: selectedPlayer,
      fixtureId,
      playerEventData
    },
    {},
    {}
  )}
${validate_component(Confirm_fixture_data_modal, "ConfirmFixtureDataModal").$$render(
    $$result,
    {
      show: showConfirmDataModal,
      onConfirm: confirmFixtureData
    },
    {},
    {}
  )}
${validate_component(Clear_draft_modal, "ClearDraftModal").$$render(
    $$result,
    {
      show: showClearDraftModal,
      onConfirm: clearDraft
    },
    {},
    {}
  )}`;
});
export {
  Page as default
};
