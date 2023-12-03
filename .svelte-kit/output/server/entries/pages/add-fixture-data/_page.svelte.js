import { c as create_ssr_component, a as subscribe, b as createEventDispatcher, d as add_attribute, v as validate_component, e as escape, n as null_to_empty, f as compute_slots, o as onDestroy, g as noop, h as set_store_value, i as each } from "../../../chunks/ssr.js";
import { p as page } from "../../../chunks/stores.js";
import { w as writable } from "../../../chunks/index.js";
import { i as i18n, I as IconClose, t as toastsStore, A as ActorFactory, a as authStore, L as Layout } from "../../../chunks/Layout.js";
import { nonNullish } from "@dfinity/utils";
import "dompurify";
import { l as loadingText, L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
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
const errorDetailToString = (err) => typeof err === "string" ? err : err instanceof Error ? err.message : "message" in err ? err.message : void 0;
const css$1 = {
  code: ".backdrop.svelte-whxjdd{position:absolute;top:0;right:0;bottom:0;left:0;background:var(--backdrop);color:var(--backdrop-contrast);-webkit-backdrop-filter:var(--backdrop-filter);backdrop-filter:var(--backdrop-filter);z-index:var(--backdrop-z-index);touch-action:manipulation;cursor:pointer}.backdrop.disablePointerEvents.svelte-whxjdd{cursor:inherit;pointer-events:none}",
  map: null
};
const Backdrop = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $i18n, $$unsubscribe_i18n;
  $$unsubscribe_i18n = subscribe(i18n, (value) => $i18n = value);
  let { disablePointerEvents = false } = $$props;
  createEventDispatcher();
  if ($$props.disablePointerEvents === void 0 && $$bindings.disablePointerEvents && disablePointerEvents !== void 0)
    $$bindings.disablePointerEvents(disablePointerEvents);
  $$result.css.add(css$1);
  $$unsubscribe_i18n();
  return `<div role="button" tabindex="-1"${add_attribute("aria-label", $i18n.core.close, 0)} class="${["backdrop svelte-whxjdd", disablePointerEvents ? "disablePointerEvents" : ""].join(" ").trim()}" data-tid="backdrop"></div>`;
});
let elementsCounters = {};
const nextElementId = (prefix) => {
  elementsCounters = {
    ...elementsCounters,
    [prefix]: (elementsCounters[prefix] ?? 0) + 1
  };
  return `${prefix}${elementsCounters[prefix]}`;
};
const css = {
  code: ".modal.svelte-1bbimtl.svelte-1bbimtl{position:fixed;top:0;right:0;bottom:0;left:0;z-index:var(--modal-z-index);touch-action:initial;cursor:initial}.wrapper.svelte-1bbimtl.svelte-1bbimtl{position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);display:flex;flex-direction:column;background:var(--overlay-background);color:var(--overlay-background-contrast);--button-secondary-background:var(--focus-background);overflow:hidden;box-sizing:border-box;box-shadow:var(--overlay-box-shadow)}.wrapper.svelte-1bbimtl .container-wrapper.svelte-1bbimtl{margin:var(--padding-1_5x) var(--padding-2x) auto;display:flex;flex-direction:column;gap:var(--padding-1_5x);flex:1;overflow:hidden}.wrapper.alert.svelte-1bbimtl.svelte-1bbimtl{width:var(--alert-width);max-width:var(--alert-max-width);max-height:var(--alert-max-height);border-radius:var(--alert-border-radius)}.wrapper.alert.svelte-1bbimtl .header.svelte-1bbimtl{padding:var(--alert-padding-y) var(--alert-padding-x) var(--padding)}.wrapper.alert.svelte-1bbimtl .container-wrapper.svelte-1bbimtl{margin-bottom:calc(var(--alert-padding-y) * 2 / 3)}.wrapper.alert.svelte-1bbimtl .content.svelte-1bbimtl{margin:0 0 calc(var(--alert-padding-y) / 2);padding:calc(var(--alert-padding-y) / 2) calc(var(--alert-padding-x) / 2) 0}.wrapper.alert.svelte-1bbimtl .footer.svelte-1bbimtl{padding:0 var(--alert-padding-x) calc(var(--alert-padding-y) * 2 / 3)}@media(min-width: 576px){.wrapper.alert.svelte-1bbimtl .footer.svelte-1bbimtl{justify-content:flex-end}}.wrapper.dialog.svelte-1bbimtl.svelte-1bbimtl{width:var(--dialog-width);max-width:var(--dialog-max-width);min-height:var(--dialog-min-height);height:var(--dialog-height);max-height:var(--dialog-max-height, 100%);border-radius:var(--dialog-border-radius)}@supports (-webkit-touch-callout: none){.wrapper.dialog.svelte-1bbimtl.svelte-1bbimtl{max-height:-webkit-fill-available}@media(min-width: 768px){.wrapper.dialog.svelte-1bbimtl.svelte-1bbimtl{max-height:var(--dialog-max-height, 100%)}}}.wrapper.dialog.svelte-1bbimtl .header.svelte-1bbimtl{padding:var(--dialog-padding-y) var(--padding-3x) var(--padding)}.wrapper.dialog.svelte-1bbimtl .container-wrapper.svelte-1bbimtl{margin-bottom:var(--dialog-padding-y)}.wrapper.dialog.svelte-1bbimtl .content.svelte-1bbimtl{margin:0;padding:var(--dialog-padding-y) var(--dialog-padding-x)}.header.svelte-1bbimtl.svelte-1bbimtl{display:grid;grid-template-columns:1fr auto 1fr;gap:var(--padding);z-index:var(--z-index);position:relative}.header.svelte-1bbimtl h2.svelte-1bbimtl{white-space:var(--text-white-space, nowrap);overflow:hidden;text-overflow:ellipsis;grid-column-start:2;text-align:center}.header.svelte-1bbimtl button.svelte-1bbimtl{display:flex;justify-content:center;align-items:center;padding:0;justify-self:flex-end}.header.svelte-1bbimtl button.svelte-1bbimtl:active,.header.svelte-1bbimtl button.svelte-1bbimtl:focus,.header.svelte-1bbimtl button.svelte-1bbimtl:hover{background:var(--background-shade);border-radius:var(--border-radius)}.content.svelte-1bbimtl.svelte-1bbimtl{overflow-y:var(--modal-content-overflow-y, auto);overflow-x:hidden}.container.svelte-1bbimtl.svelte-1bbimtl{position:relative;display:flex;flex-direction:column;flex:1;overflow:hidden;border-radius:16px;background:var(--overlay-content-background);color:var(--overlay-content-background-contrast)}",
  map: null
};
const Modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$slots = compute_slots(slots);
  let $i18n, $$unsubscribe_i18n;
  $$unsubscribe_i18n = subscribe(i18n, (value) => $i18n = value);
  let { visible = true } = $$props;
  let { role = "dialog" } = $$props;
  let { testId = void 0 } = $$props;
  let { disablePointerEvents = false } = $$props;
  let showHeader;
  let showFooterAlert;
  createEventDispatcher();
  const modalTitleId = nextElementId("modal-title-");
  const modalContentId = nextElementId("modal-content-");
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.role === void 0 && $$bindings.role && role !== void 0)
    $$bindings.role(role);
  if ($$props.testId === void 0 && $$bindings.testId && testId !== void 0)
    $$bindings.testId(testId);
  if ($$props.disablePointerEvents === void 0 && $$bindings.disablePointerEvents && disablePointerEvents !== void 0)
    $$bindings.disablePointerEvents(disablePointerEvents);
  $$result.css.add(css);
  showHeader = nonNullish($$slots.title);
  showFooterAlert = nonNullish($$slots.footer) && role === "alert";
  $$unsubscribe_i18n();
  return `${visible ? `<div class="modal svelte-1bbimtl"${add_attribute("role", role, 0)}${add_attribute("data-tid", testId, 0)}${add_attribute("aria-labelledby", showHeader ? modalTitleId : void 0, 0)}${add_attribute("aria-describedby", modalContentId, 0)}>${validate_component(Backdrop, "Backdrop").$$render($$result, { disablePointerEvents }, {}, {})} <div class="${escape(null_to_empty(`wrapper ${role}`), true) + " svelte-1bbimtl"}">${showHeader ? `<div class="header svelte-1bbimtl"><h2${add_attribute("id", modalTitleId, 0)} data-tid="modal-title" class="svelte-1bbimtl">${slots.title ? slots.title({}) : ``}</h2> ${!disablePointerEvents ? `<button data-tid="close-modal"${add_attribute("aria-label", $i18n.core.close, 0)} class="svelte-1bbimtl">${validate_component(IconClose, "IconClose").$$render($$result, { size: "24px" }, {}, {})}</button>` : ``}</div>` : ``} <div class="container-wrapper svelte-1bbimtl">${slots["sub-title"] ? slots["sub-title"]({}) : ``} <div class="container svelte-1bbimtl"><div class="${["content svelte-1bbimtl", role === "alert" ? "alert" : ""].join(" ").trim()}"${add_attribute("id", modalContentId, 0)}>${slots.default ? slots.default({}) : ``}</div></div></div> ${showFooterAlert ? `<div class="footer toolbar svelte-1bbimtl">${slots.footer ? slots.footer({}) : ``}</div>` : ``}</div></div>` : ``}`;
});
const toastsShow = (msg) => toastsStore.show(msg);
const toastsError = ({
  msg: { text, ...rest },
  err
}) => {
  if (nonNullish(err)) {
    console.error(err);
  }
  return toastsStore.show({
    text: `${text}${nonNullish(err) ? ` / ${errorDetailToString(err)}` : ""}`,
    ...rest,
    level: "error"
  });
};
const goto = /* @__PURE__ */ client_method("goto");
function createGovernanceStore() {
  const { subscribe: subscribe2, set } = writable([]);
  async function submitFixtureData(fixtureId, allPlayerEvents) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
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
  let { visible = false } = $$props;
  let { onConfirm } = $$props;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.onConfirm === void 0 && $$bindings.onConfirm && onConfirm !== void 0)
    $$bindings.onConfirm(onConfirm);
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="flex justify-between items-center"><h4 class="text-lg font-bold" data-svelte-h="svelte-1q1allu">Confirm Fixture Data</h4> <button class="text-black" data-svelte-h="svelte-naxdfo">✕</button></div> <div class="my-5" data-svelte-h="svelte-7ennqn"><h1>Please confirm your fixture data.</h1> <p class="text-sm text-gray-600">You will not be able to edit your submission and entries that differ from
      the accepted consensus data will not receive $FPL rewards. If consensus
      has already been reached for the fixture your submission will also not be
      counted.</p></div> <div class="flex justify-end gap-3"><button class="px-4 py-2 border rounded text-black" data-svelte-h="svelte-28muw1">Cancel</button> <button class="px-4 py-2 bg-blue-500 text-white rounded" data-svelte-h="svelte-2n1nwn">Confirm</button></div>`;
    }
  })}`;
});
const Clear_draft_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { visible = false } = $$props;
  let { onConfirm } = $$props;
  let { closeModal } = $$props;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.onConfirm === void 0 && $$bindings.onConfirm && onConfirm !== void 0)
    $$bindings.onConfirm(onConfirm);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mt-3 text-center" data-svelte-h="svelte-9o48zw"><h3 class="text-lg leading-6 font-medium mb-2">Please confirm you want to clear the draft from your cache.</h3></div> <div class="items-center py-3 flex space-x-4"><button class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300" data-svelte-h="svelte-1tm5eym">Cancel</button> <button class="px-4 py-2 fpl-purple-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300" data-svelte-h="svelte-1bvkaon">Clear</button></div>`;
    }
  })}`;
});
let showConfirmDataModal = false;
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let fixtureId;
  let $playerEventData, $$unsubscribe_playerEventData = noop, $$subscribe_playerEventData = () => ($$unsubscribe_playerEventData(), $$unsubscribe_playerEventData = subscribe(playerEventData, ($$value) => $playerEventData = $$value), playerEventData);
  let $loadingText, $$unsubscribe_loadingText;
  let $selectedPlayers, $$unsubscribe_selectedPlayers;
  let $page, $$unsubscribe_page;
  $$unsubscribe_loadingText = subscribe(loadingText, (value) => $loadingText = value);
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
  let isLoading = true;
  onDestroy(() => {
  });
  async function confirmFixtureData() {
    isLoading = true;
    set_store_value(loadingText, $loadingText = "Saving Fixture Data", $loadingText);
    try {
      await governanceStore.submitFixtureData(fixtureId, $playerEventData);
      localStorage.removeItem(`fixtureDraft_${fixtureId}`);
      toastsShow({
        text: "Fixture data saved.",
        level: "success",
        duration: 2e3
      });
      goto("/fixture-validation");
    } catch (error) {
      toastsError({
        msg: { text: "Error saving fixture data." },
        err: error
      });
      console.error("Error saving fixture data: ", error);
    } finally {
      isLoading = false;
      set_store_value(loadingText, $loadingText = "Loading", $loadingText);
    }
  }
  function clearDraft() {
    $$subscribe_playerEventData(playerEventData = writable([]));
    localStorage.removeItem(`fixtureDraft_${fixtureId}`);
    toastsShow({
      text: "Draft cleared.",
      level: "success",
      duration: 2e3
    });
    closeConfirmClearDraftModal();
  }
  function closeConfirmClearDraftModal() {
    showClearDraftModal = false;
  }
  fixtureId = Number($page.url.searchParams.get("id"));
  isSubmitDisabled = $playerEventData.length == 0 || $playerEventData.filter((x) => x.eventType == 0).length != $selectedPlayers.length;
  $$unsubscribe_playerEventData();
  $$unsubscribe_loadingText();
  $$unsubscribe_selectedPlayers();
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${isLoading ? `${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}` : `<div class="container-fluid mx-4 md:mx-16 mt-4 bg-panel"><div class="flex flex-col text-xs md:text-base mt-4"><div class="flex flex-row space-x-2 p-4"><button class="fpl-button px-4 py-2" data-svelte-h="svelte-1r8hmpb">Select Players</button> <button class="fpl-button px-4 py-2" data-svelte-h="svelte-1km0b4b">Save Draft</button> <button class="fpl-button px-4 py-2" data-svelte-h="svelte-1m508oj">Clear Draft</button></div> <div class="flex w-full"><ul class="flex bg-light-gray px-4 pt-2 w-full mt-4"><li${add_attribute("class", `mr-4 text-xs md:text-base ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>${escape(homeTeam?.friendlyName)}</button></li> <li${add_attribute("class", `mr-4 text-xs md:text-base ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>${escape(awayTeam?.friendlyName)}</button></li></ul></div> <div class="flex w-full flex-col"><div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer w-full" data-svelte-h="svelte-15cg9f0"><div class="w-1/6 px-4">Player</div> <div class="w-1/6 px-4">Position</div> <div class="w-1/6 px-4">Events</div> <div class="w-1/6 px-4">Start</div> <div class="w-1/6 px-4">End</div> <div class="w-1/6 px-4"> </div></div> ${`${each($selectedPlayers.filter((x) => x.teamId === fixture?.homeTeamId), (player) => {
        return `<div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer w-full"><div class="w-1/6 px-4">${escape(`${player.firstName.length > 0 ? player.firstName.charAt(0) + "." : ""} ${player.lastName}`)}</div> ${player.position == 0 ? `<div class="w-1/6 px-4" data-svelte-h="svelte-mmeyla">GK</div>` : ``} ${player.position == 1 ? `<div class="w-1/6 px-4" data-svelte-h="svelte-1bhhlci">DF</div>` : ``} ${player.position == 2 ? `<div class="w-1/6 px-4" data-svelte-h="svelte-syz487">MF</div>` : ``} ${player.position == 3 ? `<div class="w-1/6 px-4" data-svelte-h="svelte-8mc40v">FW</div>` : ``} <div class="w-1/6 px-4">Events:
                  ${escape($playerEventData?.length > 0 && $playerEventData?.filter((e) => e.playerId === player.id).length ? $playerEventData?.filter((e) => e.playerId === player.id).length : 0)}</div> <div class="w-1/6 px-4">${escape($playerEventData && $playerEventData?.length > 0 && $playerEventData?.find((e) => e.playerId === player.id && e.eventType == 0) ? $playerEventData?.find((e) => e.playerId === player.id && e.eventType == 0)?.eventStartMinute : "-")}</div> <div class="w-1/6 px-4">${escape($playerEventData && $playerEventData?.length > 0 && $playerEventData?.find((e) => e.playerId === player.id && e.eventType == 0) ? $playerEventData?.find((e) => e.playerId === player.id && e.eventType == 0)?.eventEndMinute : "-")}</div> <div class="w-1/6 px-4"><button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1" data-svelte-h="svelte-kdfprs">Update Events
                  </button></div> </div>`;
      })}`} ${``}</div> <div class="flex w-full m-4" data-svelte-h="svelte-1toeckg"><h1>Summary</h1></div> <div class="flex flex-row w-full m-4"><div class="text-sm font-medium flex-grow">Appearances: ${escape($playerEventData.filter((x) => x.eventType == 0).length)}</div> <div class="text-sm font-medium flex-grow">Goals: ${escape($playerEventData.filter((x) => x.eventType == 1).length)}</div> <div class="text-sm font-medium flex-grow">Own Goals: ${escape($playerEventData.filter((x) => x.eventType == 10).length)}</div> <div class="text-sm font-medium flex-grow">Assists: ${escape($playerEventData.filter((x) => x.eventType == 2).length)}</div> <div class="text-sm font-medium flex-grow">Keeper Saves: ${escape($playerEventData.filter((x) => x.eventType == 4).length)}</div> <div class="text-sm font-medium flex-grow">Yellow Cards: ${escape($playerEventData.filter((x) => x.eventType == 8).length)}</div> <div class="text-sm font-medium flex-grow">Red Cards: ${escape($playerEventData.filter((x) => x.eventType == 9).length)}</div> <div class="text-sm font-medium flex-grow">Penalties Saved: ${escape($playerEventData.filter((x) => x.eventType == 6).length)}</div> <div class="text-sm font-medium flex-grow">Penalties Missed: ${escape($playerEventData.filter((x) => x.eventType == 7).length)}</div></div> <div class="items-center mt-3 flex space-x-4"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
            px-4 py-2 text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Submit Event Data</button></div></div></div>`}`;
    }
  })} ${``} ${``} ${validate_component(Confirm_fixture_data_modal, "ConfirmFixtureDataModal").$$render(
    $$result,
    {
      visible: showConfirmDataModal,
      onConfirm: confirmFixtureData
    },
    {},
    {}
  )} ${validate_component(Clear_draft_modal, "ClearDraftModal").$$render(
    $$result,
    {
      closeModal: closeConfirmClearDraftModal,
      visible: showClearDraftModal,
      onConfirm: clearDraft
    },
    {},
    {}
  )}`;
});
export {
  Page as default
};
