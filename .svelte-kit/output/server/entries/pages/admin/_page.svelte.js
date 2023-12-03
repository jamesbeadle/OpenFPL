import { c as create_ssr_component, v as validate_component } from "../../../chunks/index2.js";
import { A as ActorFactory, i as idlFactory, L as Layout, a as LoadingIcon } from "../../../chunks/Layout.js";
import { w as writable } from "../../../chunks/index.js";
import "@dfinity/agent";
import "@dfinity/auth-client";
import "@dfinity/utils";
function createSeasonStore() {
  const { subscribe, set } = writable([]);
  const actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.OPENFPL_BACKEND_CANISTER_ID
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
