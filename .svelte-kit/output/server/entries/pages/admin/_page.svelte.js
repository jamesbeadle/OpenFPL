import { c as create_ssr_component, v as validate_component } from "../../../chunks/ssr.js";
import { A as ActorFactory, b as idlFactory, L as Layout } from "../../../chunks/Layout.js";
import "@dfinity/utils";
import "dompurify";
import { w as writable } from "../../../chunks/index.js";
import "@dfinity/agent";
import "@dfinity/auth-client";
import { L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
function createSeasonStore() {
  const { subscribe, set } = writable([]);
  const actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    const updatedSeasonsData = await actor.getSeasons();
    set(updatedSeasonsData);
  }
  return {
    subscribe,
    sync
  };
}
createSeasonStore();
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { showModal = false } = $$props;
  if ($$props.showModal === void 0 && $$bindings.showModal && showModal !== void 0)
    $$bindings.showModal(showModal);
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
export {
  Page as default
};
