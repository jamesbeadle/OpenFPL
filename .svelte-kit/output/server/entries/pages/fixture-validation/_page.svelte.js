import { c as create_ssr_component, a as subscribe, o as onDestroy, v as validate_component, e as escape, b as each, d as add_attribute } from "../../../chunks/index2.js";
import "../../../chunks/team-store.js";
import "../../../chunks/fixture-store.js";
import "../../../chunks/player-store.js";
import { i as isLoading, L as Layout } from "../../../chunks/Layout.js";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_isLoading;
  $$unsubscribe_isLoading = subscribe(isLoading, (value) => value);
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let currentGameweek;
  let currentSeason;
  onDestroy(() => {
  });
  $$unsubscribe_isLoading();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="container-fluid mx-4 md:mx-16 mt-4 bg-panel"><div class="flex flex-col space-y-4 text-xs md:text-base"><div class="flex p-4"><h1>${escape(`Season ${currentSeason}`)} - ${escape(`Gameweek ${currentGameweek}`)}</h1></div>
      <div class="flex flex-col sm:flex-row gap-4 sm:gap-8"><div class="flex flex-col sm:flex-row justify-between sm:items-center"><div class="md:flex md:items-center mt-2 sm:mt-0 ml-2"><button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1" ${""}>&lt;</button>
            <select class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px] md:min-w-[140px]">${each(gameweeks, (gameweek) => {
        return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
      })}</select>
            <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1" ${""}>&gt;</button></div></div></div>
      <div class="flex flex-col space-y-4 mt-4 text-xs md:text-base"><div class="overflow-x-auto flex-1"><div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"><div class="w-1/4 px-4">Home Team</div>
            <div class="w-1/4 px-4">Away Team</div>
            <div class="w-1/4 px-4">Status</div>
            <div class="w-1/4 px-4">Actions</div></div>

          ${`<p class="w-100 p-4">No leaderboard data.</p>`}</div></div></div></div>`;
    }
  })}`;
});
export {
  Page as default
};
