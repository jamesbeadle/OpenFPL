import { c as create_ssr_component, o as onDestroy, b as each, d as add_attribute, e as escape, v as validate_component, a as subscribe } from "../../../chunks/index2.js";
import { i as isLoading, L as Layout } from "../../../chunks/Layout.js";
import { f as formatUnixTimeToTime, A as ActorFactory, i as idlFactory, a as authStore } from "../../../chunks/team-store.js";
import "../../../chunks/fixture-store.js";
import { B as BadgeIcon } from "../../../chunks/BadgeIcon.js";
import { w as writable } from "../../../chunks/index.js";
import "@dfinity/agent";
const Admin_fixtures = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let filteredFixtures;
  let groupedFixtures;
  let fixturesWithTeams = [];
  let selectedGameweek = 1;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  onDestroy(() => {
  });
  filteredFixtures = fixturesWithTeams.filter(({ fixture }) => fixture.gameweek === selectedGameweek);
  groupedFixtures = filteredFixtures.reduce(
    (acc, fixtureWithTeams) => {
      const date = new Date(Number(fixtureWithTeams.fixture.kickOff) / 1e6);
      const dateFormatter = new Intl.DateTimeFormat(
        "en-GB",
        {
          weekday: "long",
          day: "numeric",
          month: "long",
          year: "numeric"
        }
      );
      const dateKey = dateFormatter.format(date);
      if (!acc[dateKey]) {
        acc[dateKey] = [];
      }
      acc[dateKey].push(fixtureWithTeams);
      return acc;
    },
    {}
  );
  return `<div class="container-fluid mt-4 mb-4"><div class="flex flex-col space-y-4"><div class="flex flex-col sm:flex-row gap-4 sm:gap-8"><div class="flex items-center space-x-2 ml-4"><button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1" ${"disabled"}>&lt;
        </button>

        <select class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]">${each(gameweeks, (gameweek) => {
    return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
  })}</select>

        <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1" ${""}>&gt;
        </button></div></div>
    <div>${each(Object.entries(groupedFixtures), ([date, fixtures]) => {
    return `<div><div class="flex items-center justify-between border border-gray-700 py-4 bg-light-gray"><h2 class="date-header ml-4 text-xs md:text-base">${escape(date)}</h2></div>
          ${each(fixtures, ({ fixture, homeTeam, awayTeam }) => {
      return `<div${add_attribute("class", `flex items-center justify-between py-2 border-b border-gray-700  ${fixture.status === 0 ? "text-gray-400" : "text-white"}`, 0)}><div class="flex items-center w-1/2 ml-4"><div class="flex w-1/2 space-x-4 justify-center"><div class="w-10 items-center justify-center"><a${add_attribute("href", `/club?id=${fixture.homeTeamId}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: homeTeam ? homeTeam.primaryColourHex : "",
          secondaryColour: homeTeam ? homeTeam.secondaryColourHex : "",
          thirdColour: homeTeam ? homeTeam.thirdColourHex : ""
        },
        {},
        {}
      )}
                    </a></div>
                  <span class="font-bold text-lg">v</span>
                  <div class="w-10 items-center justify-center"><a${add_attribute("href", `/club?id=${fixture.awayTeamId}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: awayTeam ? awayTeam.primaryColourHex : "",
          secondaryColour: awayTeam ? awayTeam.secondaryColourHex : "",
          thirdColour: awayTeam ? awayTeam.thirdColourHex : ""
        },
        {},
        {}
      )}</a>
                  </div></div>
                <div class="flex w-1/2 lg:justify-center"><span class="text-sm md:text-lg ml-4 md:ml-0 text-left">${escape(formatUnixTimeToTime(Number(fixture.kickOff)))}</span>
                </div></div>
              <div class="flex items-center space-x-10 w-1/2 lg:justify-center"><div class="flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px] text-xs md:text-base"><a${add_attribute("href", `/club?id=${fixture.homeTeamId}`, 0)}>${escape(homeTeam ? homeTeam.friendlyName : "")}</a>
                  <a${add_attribute("href", `/club?id=${fixture.awayTeamId}`, 0)}>${escape(awayTeam ? awayTeam.friendlyName : "")}</a></div>
                <div class="flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px] text-xs md:text-base"><span>${escape(fixture.status === 0 ? "-" : fixture.homeGoals)}</span>
                  <span>${escape(fixture.status === 0 ? "-" : fixture.awayGoals)}</span>
                </div></div>
            </div>`;
    })}
        </div>`;
  })}</div></div></div>`;
});
function createSeasonStore() {
  const { subscribe: subscribe2, set } = writable([]);
  const actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    const updatedSeasonsData = await actor.getSeasons();
    set(updatedSeasonsData);
  }
  return {
    subscribe: subscribe2,
    sync
  };
}
createSeasonStore();
const System_state_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $authStore, $$unsubscribe_authStore;
  $$unsubscribe_authStore = subscribe(authStore, (value) => $authStore = value);
  let { showModal } = $$props;
  let { closeModal } = $$props;
  let { cancelModal } = $$props;
  let { isLoading: isLoading2 } = $$props;
  onDestroy(() => {
  });
  if ($$props.showModal === void 0 && $$bindings.showModal && showModal !== void 0)
    $$bindings.showModal(showModal);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  if ($$props.cancelModal === void 0 && $$bindings.cancelModal && cancelModal !== void 0)
    $$bindings.cancelModal(cancelModal);
  if ($$props.isLoading === void 0 && $$bindings.isLoading && isLoading2 !== void 0)
    $$bindings.isLoading(isLoading2);
  isSubmitDisabled = ($authStore.identity?.getPrincipal().toString() ?? "") !== "kydhj-2crf5-wwkao-msv4s-vbyvu-kkroq-apnyv-zykjk-r6oyk-ksodu-vqe";
  $$unsubscribe_authStore();
  return `${showModal ? `<div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"><div class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"><div class="mt-3 text-center"><h3 class="text-lg leading-6 font-medium mb-2">Update System State</h3>
        <form><div class="mt-4">

            

            </div>
          <div class="items-center py-3 flex space-x-4"><button class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300">Cancel
            </button>
            <button${add_attribute("class", `px-4 py-2 ${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`, 0)} type="submit" ${isSubmitDisabled ? "disabled" : ""}>Update
            </button></div></form></div></div></div>` : ``}`;
});
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { showModal = false } = $$props;
  function hideModal() {
    showModal = false;
  }
  if ($$props.showModal === void 0 && $$bindings.showModal && showModal !== void 0)
    $$bindings.showModal(showModal);
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${validate_component(System_state_modal, "SystemStateModal").$$render(
        $$result,
        {
          showModal,
          closeModal: hideModal,
          cancelModal: hideModal,
          isLoading
        },
        {},
        {}
      )}
  <div class="m-4"><div class="bg-panel rounded-lg m-4"><div class="flex flex-col p-4"><h1 class="text-xl">OpenFPL Admin</h1>
        <p class="mt-2">This view is for testing purposes only.</p></div>

      <div class="flex flex-row p-4 space-x-4"><button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1">System Status</button></div>

      <ul class="flex rounded-t-lg bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-base ${"active-tab"}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-white"}`,
        0
      )}>Fixtures</button></li></ul>

      ${`${validate_component(Admin_fixtures, "AdminFixtures").$$render($$result, {}, {}, {})}`}</div></div>`;
    }
  })}`;
});
export {
  Page as default
};
