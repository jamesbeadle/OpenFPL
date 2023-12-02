import { c as create_ssr_component, a as subscribe, o as onDestroy, v as validate_component, d as add_attribute, e as escape, b as each, f as noop, g as set_store_value } from "../../../chunks/index2.js";
import { p as page } from "../../../chunks/stores.js";
import { w as writable } from "../../../chunks/index.js";
import { A as ActorFactory, a as authStore } from "../../../chunks/team-store.js";
import "../../../chunks/fixture-store.js";
import { l as loadingText, i as isLoading, t as toastStore, L as Layout } from "../../../chunks/Layout.js";
import "../../../chunks/player-store.js";
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
function createGovernanceStore() {
  const { subscribe: subscribe2, set } = writable([]);
  async function submitFixtureData(fixtureId, allPlayerEvents) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      await identityActor.savePlayerEvents(fixtureId, allPlayerEvents);
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }
  return {
    subscribe: subscribe2,
    submitFixtureData
  };
}
const governanceStore = createGovernanceStore();
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
  let { closeModal } = $$props;
  if ($$props.show === void 0 && $$bindings.show && show !== void 0)
    $$bindings.show(show);
  if ($$props.onConfirm === void 0 && $$bindings.onConfirm && onConfirm !== void 0)
    $$bindings.onConfirm(onConfirm);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  return `${show ? `<div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"><div class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"><div class="mt-3 text-center"><h3 class="text-lg leading-6 font-medium mb-2">Please confirm you want to clear the draft from your cache.
        </h3></div>

      <div class="items-center py-3 flex space-x-4"><button class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300">Cancel
        </button>
        <button class="px-4 py-2 fpl-purple-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300">Clear
        </button></div></div></div>` : ``}`;
});
let showConfirmDataModal = false;
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let fixtureId;
  let $playerEventData, $$unsubscribe_playerEventData = noop, $$subscribe_playerEventData = () => ($$unsubscribe_playerEventData(), $$unsubscribe_playerEventData = subscribe(playerEventData, ($$value) => $playerEventData = $$value), playerEventData);
  let $loadingText, $$unsubscribe_loadingText;
  let $isLoading, $$unsubscribe_isLoading;
  let $selectedPlayers, $$unsubscribe_selectedPlayers;
  let $page, $$unsubscribe_page;
  $$unsubscribe_loadingText = subscribe(loadingText, (value) => $loadingText = value);
  $$unsubscribe_isLoading = subscribe(isLoading, (value) => $isLoading = value);
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let fixture;
  let homeTeam;
  let awayTeam;
  let showClearDraftModal = false;
  let selectedPlayers = writable([]);
  $$unsubscribe_selectedPlayers = subscribe(selectedPlayers, (value) => $selectedPlayers = value);
  let playerEventData = writable([]);
  $$subscribe_playerEventData();
  let isSubmitDisabled = true;
  onDestroy(() => {
  });
  async function confirmFixtureData() {
    set_store_value(isLoading, $isLoading = true, $isLoading);
    set_store_value(loadingText, $loadingText = "Saving Fixture Data", $loadingText);
    try {
      await governanceStore.submitFixtureData(fixtureId, $playerEventData);
      localStorage.removeItem(`fixtureDraft_${fixtureId}`);
      toastStore.show("Fixture data saved", "success");
      goto("/fixture-validation");
    } catch (error) {
      toastStore.show("Error saving fixture data.", "error");
      console.error("Error saving fixture data: ", error);
    } finally {
      set_store_value(isLoading, $isLoading = false, $isLoading);
      set_store_value(loadingText, $loadingText = "Loading", $loadingText);
    }
  }
  function clearDraft() {
    $$subscribe_playerEventData(playerEventData = writable([]));
    localStorage.removeItem(`fixtureDraft_${fixtureId}`);
    toastStore.show("Draft cleared.", "success");
    closeConfirmClearDraftModal();
  }
  function closeConfirmClearDraftModal() {
    showClearDraftModal = false;
  }
  fixtureId = Number($page.url.searchParams.get("id"));
  isSubmitDisabled = $playerEventData.length == 0 || $playerEventData.filter((x) => x.eventType == 0).length != $selectedPlayers.length;
  $$unsubscribe_playerEventData();
  $$unsubscribe_loadingText();
  $$unsubscribe_isLoading();
  $$unsubscribe_selectedPlayers();
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="container-fluid mx-4 md:mx-16 mt-4 bg-panel"><div class="flex flex-col text-xs md:text-base mt-4"><div class="flex flex-row space-x-2 p-4"><button class="fpl-button px-4 py-2">Select Players</button>
        <button class="fpl-button px-4 py-2">Save Draft</button>
        <button class="fpl-button px-4 py-2">Clear Draft</button></div>
      ${!$isLoading ? `<div class="flex w-full"><ul class="flex bg-light-gray px-4 pt-2 w-full mt-4"><li${add_attribute("class", `mr-4 text-xs md:text-base ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>${escape(homeTeam?.friendlyName)}</button></li>
            <li${add_attribute("class", `mr-4 text-xs md:text-base ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>${escape(awayTeam?.friendlyName)}</button></li></ul></div>
        <div class="flex w-full flex-col"><div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer w-full"><div class="w-1/6 px-4">Player</div>
            <div class="w-1/6 px-4">Position</div>
            <div class="w-1/6 px-4">Events</div>
            <div class="w-1/6 px-4">Start</div>
            <div class="w-1/6 px-4">End</div>
            <div class="w-1/6 px-4"> </div></div>
          ${`${each($selectedPlayers.filter((x) => x.teamId === fixture?.homeTeamId), (player) => {
        return `<div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer w-full"><div class="w-1/6 px-4">${escape(`${player.firstName.length > 0 ? player.firstName.charAt(0) + "." : ""} ${player.lastName}`)}</div>
                ${player.position == 0 ? `<div class="w-1/6 px-4">GK</div>` : ``}
                ${player.position == 1 ? `<div class="w-1/6 px-4">DF</div>` : ``}
                ${player.position == 2 ? `<div class="w-1/6 px-4">MF</div>` : ``}
                ${player.position == 3 ? `<div class="w-1/6 px-4">FW</div>` : ``}
                <div class="w-1/6 px-4">Events:
                  ${escape($playerEventData?.length > 0 && $playerEventData?.filter((e) => e.playerId === player.id).length ? $playerEventData?.filter((e) => e.playerId === player.id).length : 0)}</div>
                <div class="w-1/6 px-4">${escape($playerEventData && $playerEventData?.length > 0 && $playerEventData?.find((e) => e.playerId === player.id && e.eventType == 0) ? $playerEventData?.find((e) => e.playerId === player.id && e.eventType == 0)?.eventStartMinute : "-")}</div>
                <div class="w-1/6 px-4">${escape($playerEventData && $playerEventData?.length > 0 && $playerEventData?.find((e) => e.playerId === player.id && e.eventType == 0) ? $playerEventData?.find((e) => e.playerId === player.id && e.eventType == 0)?.eventEndMinute : "-")}</div>
                <div class="w-1/6 px-4"><button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1">Update Events
                  </button></div>
              </div>`;
      })}`}
          ${``}</div>
        <div class="flex w-full m-4"><h1>Summary</h1></div>
        <div class="flex flex-row w-full m-4"><div class="text-sm font-medium flex-grow">Appearances: ${escape($playerEventData.filter((x) => x.eventType == 0).length)}</div>
          <div class="text-sm font-medium flex-grow">Goals: ${escape($playerEventData.filter((x) => x.eventType == 1).length)}</div>
          <div class="text-sm font-medium flex-grow">Own Goals: ${escape($playerEventData.filter((x) => x.eventType == 10).length)}</div>
          <div class="text-sm font-medium flex-grow">Assists: ${escape($playerEventData.filter((x) => x.eventType == 2).length)}</div>
          <div class="text-sm font-medium flex-grow">Keeper Saves: ${escape($playerEventData.filter((x) => x.eventType == 4).length)}</div>
          <div class="text-sm font-medium flex-grow">Yellow Cards: ${escape($playerEventData.filter((x) => x.eventType == 8).length)}</div>
          <div class="text-sm font-medium flex-grow">Red Cards: ${escape($playerEventData.filter((x) => x.eventType == 9).length)}</div>
          <div class="text-sm font-medium flex-grow">Penalties Saved: ${escape($playerEventData.filter((x) => x.eventType == 6).length)}</div>
          <div class="text-sm font-medium flex-grow">Penalties Missed: ${escape($playerEventData.filter((x) => x.eventType == 7).length)}</div></div>

        <div class="items-center mt-3 flex space-x-4"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
            px-4 py-2 text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Submit Event Data</button></div>` : ``}</div></div>`;
    }
  })}

${``}

${``}

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
      closeModal: closeConfirmClearDraftModal,
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
