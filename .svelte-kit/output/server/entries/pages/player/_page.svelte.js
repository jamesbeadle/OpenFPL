import { c as create_ssr_component, d as add_attribute, a as subscribe, o as onDestroy, v as validate_component, e as escape, m as missing_component } from "../../../chunks/index3.js";
import { p as page } from "../../../chunks/stores.js";
import "../../../chunks/player-store.js";
import { u as updateTableData, b as getPositionText, c as calculateAgeFromNanoseconds, d as convertDateToReadable, a as getFlagComponent } from "../../../chunks/team-store.js";
import "../../../chunks/fixture-store.js";
import "../../../chunks/system-store.js";
import { a as LoadingIcon, L as Layout } from "../../../chunks/Layout.js";
import { B as BadgeIcon } from "../../../chunks/BadgeIcon.js";
const ShirtIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  let { primaryColour = "#2CE3A6" } = $$props;
  let { secondaryColour = "#777777" } = $$props;
  let { thirdColour = "#FFFFFF" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  if ($$props.primaryColour === void 0 && $$bindings.primaryColour && primaryColour !== void 0)
    $$bindings.primaryColour(primaryColour);
  if ($$props.secondaryColour === void 0 && $$bindings.secondaryColour && secondaryColour !== void 0)
    $$bindings.secondaryColour(secondaryColour);
  if ($$props.thirdColour === void 0 && $$bindings.thirdColour && thirdColour !== void 0)
    $$bindings.thirdColour(thirdColour);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 86 88"><g filter="url(#filter0_d_354_581)"><path d="M65.9308 38.3253L63.5966 33.0215L63.642 33.2129C63.5966 34.2107 63.5603 35.2633 63.533 36.366C63.4831 38.3299 63.4604 40.4442 63.4604 42.6587C63.4604 54.9386 64.1597 70.308 64.8727 79.9999H21.1266C21.835 70.2989 22.5389 54.9159 22.5389 42.6313C22.5389 40.4214 22.5162 38.3162 22.4663 36.3569C22.439 35.2542 22.4027 34.2062 22.3573 33.2129L22.3982 33.0215L20.0685 38.3253L9.30566 33.3131L20.5453 10.6213L20.5862 10.5438L20.6271 10.4573C20.6271 10.4573 31.6578 6.72087 32.0166 6.3609C32.0983 6.27889 32.2346 6.09662 32.3935 5.86424C34.2554 8.43871 36.6668 10.6122 39.4688 12.2252C40.2726 12.69 41.1037 13.1046 41.971 13.4737C42.3026 13.615 42.6432 13.7517 42.9883 13.8747V13.8838C42.9883 13.8838 42.9928 13.8838 42.9974 13.8793C43.0019 13.8838 43.0065 13.8838 43.011 13.8838V13.8747C43.3516 13.7517 43.6922 13.615 44.0237 13.4737C44.8865 13.1092 45.7267 12.69 46.5305 12.2252C49.3324 10.6122 51.7439 8.43871 53.6058 5.85968C53.7647 6.09662 53.901 6.27889 53.9827 6.3609C54.3415 6.72087 65.3722 10.4573 65.3722 10.4573L65.4131 10.5438L65.454 10.6213L76.6891 33.3131L65.9308 38.3253Z"${add_attribute("fill", primaryColour, 0)}></path><path d="M51.2756 3.04364C51.1348 3.26691 50.985 3.48563 50.8351 3.69979C49.0504 6.26059 46.7298 8.43864 44.0232 10.0881C43.6917 10.2932 43.3556 10.4845 43.0105 10.6714C43.0105 10.6714 43.0059 10.6759 43.0014 10.6759C42.9969 10.6759 42.9923 10.6714 42.9878 10.6714C42.6426 10.4845 42.302 10.2886 41.9705 10.0836C39.2685 8.43864 36.9479 6.26059 35.1632 3.69979C35.0133 3.48563 34.8634 3.26691 34.7227 3.04364H51.2756Z"${add_attribute("fill", secondaryColour, 0)}></path><path d="M68.5512 8.58005L68.265 8.00136C68.265 8.00136 68.2514 7.99681 68.2287 7.98769C67.5294 7.75075 57.3478 4.29686 55.1726 3.35365C54.9546 3.25796 54.8138 3.18505 54.7775 3.1486C54.7502 3.12126 54.7184 3.08936 54.6866 3.0438C54.2416 2.49701 53.1699 0.715384 52.8429 0.164037C52.7793 0.0592356 52.743 0 52.743 0H33.2564C33.2564 0 33.22 0.0592356 33.1565 0.164037C32.8295 0.715384 31.7578 2.49701 31.3173 3.0438C31.2809 3.08936 31.2491 3.12126 31.2219 3.1486C31.1856 3.18505 31.0448 3.25796 30.8223 3.35365C28.6424 4.29686 18.4654 7.75075 17.7706 7.98769C17.7479 7.99681 17.7343 8.00136 17.7343 8.00136L17.4482 8.5846L4.33301 35.0629L18.5835 41.7019L20.0685 38.3254L9.3057 33.3132L20.5454 10.6214L20.5862 10.5439L20.6271 10.4574C20.6271 10.4574 31.6578 6.72096 32.0166 6.36099C32.0984 6.27897 32.2346 6.09671 32.3935 5.86432C34.2555 8.43879 36.6669 10.6123 39.4688 12.2253C40.2726 12.6901 41.1037 13.1047 41.9711 13.4738C42.3026 13.6151 42.6432 13.7518 42.9883 13.8748C42.9883 13.8748 42.9914 13.8763 42.9974 13.8794C42.9974 13.8794 43.0065 13.8794 43.011 13.8748C43.3516 13.7518 43.6922 13.6151 44.0237 13.4738C44.8866 13.1093 45.7267 12.6901 46.5305 12.2253C49.3325 10.6123 51.7439 8.43879 53.6058 5.85977C53.7648 6.09671 53.901 6.27897 53.9827 6.36099C54.3415 6.72096 65.3723 10.4574 65.3723 10.4574L65.4131 10.5439L65.454 10.6214L76.6891 33.3132L65.9308 38.3254L67.4158 41.7019L81.6663 35.0629L68.5512 8.58005ZM50.8356 3.69995C49.0509 6.26075 46.7303 8.43879 44.0237 10.0883C43.6922 10.2933 43.3562 10.4847 43.011 10.6715V10.6806H43.0019C42.9974 10.6806 42.9929 10.6806 42.9883 10.6806V10.6715C42.6432 10.4847 42.3026 10.2888 41.9711 10.0837C39.269 8.43879 36.9484 6.26075 35.1637 3.69995C35.0138 3.48579 34.864 3.26707 34.7232 3.0438H51.2761C51.1354 3.26707 50.9855 3.48579 50.8356 3.69995Z"${add_attribute("fill", thirdColour, 0)}></path></g></svg>`;
});
const playerGameweekModal_svelte_svelte_type_style_lang = "";
const Player_gameweek_history = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  onDestroy(() => {
  });
  Number($page.url.searchParams.get("id"));
  $$unsubscribe_page();
  return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}`;
});
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let selectedGameweek = 1;
  let selectedPlayer = null;
  let teams = [];
  let fixtures = [];
  let fixturesWithTeams = [];
  let team = null;
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  Number($page.url.searchParams.get("id"));
  {
    if (fixtures.length > 0 && teams.length > 0) {
      updateTableData(fixturesWithTeams, teams, selectedGameweek);
    }
  }
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="flex flex-col md:flex-row"><div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow flex flex-col items-center"><p class="text-gray-300 text-xs">${escape(getPositionText(-1))}</p>
          <div class="py-2 flex">${validate_component(ShirtIcon, "ShirtIcon").$$render(
        $$result,
        {
          className: "h-10",
          primaryColour: team?.primaryColourHex,
          secondaryColour: team?.secondaryColourHex,
          thirdColour: team?.thirdColourHex
        },
        {},
        {}
      )}</div>
          <p class="text-gray-300 text-xs">Shirt: ${escape(selectedPlayer?.shirtNumber)}</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">${escape(team?.name)}</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(selectedPlayer?.lastName)}</p>
          <p class="text-gray-300 text-xs flex items-center">${validate_component(getFlagComponent("") || missing_component, "svelte:component").$$render($$result, { class: "w-4 h-4 mr-1", size: "100" }, {}, {})}${escape(selectedPlayer?.firstName)}</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Value</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">£${escape((Number(0) / 4).toFixed(2))}m
          </p>
          <p class="text-gray-300 text-xs">Weekly Change: 0%</p></div>
        <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>
        <div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs">Age</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(calculateAgeFromNanoseconds(Number(0)))}</p>
          <p class="text-gray-300 text-xs">${escape(convertDateToReadable(Number(0)))}</p></div></div>
      <div class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs">Next Game:</p>
          <div class="flex justify-center mb-2 mt-2"><div class="flex justify-center items-center"><div class="w-10 ml-4 mr-4"><a${add_attribute("href", `/club?id=${-1}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: "",
          secondaryColour: "",
          thirdColour: ""
        },
        {},
        {}
      )}</a></div>
              <div class="w-v ml-1 mr-1 flex justify-center"><p class="text-xs mt-2 mb-2 font-bold">v</p></div>
              <div class="w-10 ml-4"><a${add_attribute("href", `/club?id=${-1}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: "",
          secondaryColour: "",
          thirdColour: ""
        },
        {},
        {}
      )}</a></div></div></div>
          <div class="flex justify-center"><div class="w-10 ml-4 mr-4"><p class="text-gray-300 text-xs text-center"><a class="text-gray-300 text-xs text-center"${add_attribute("href", `/club?id=${-1}`, 0)}>${escape("")}</a></p></div>
            <div class="w-v ml-2 mr-2"></div>
            <div class="w-10 ml-4"><p class="text-gray-300 text-xs text-center"><a class="text-gray-300 text-xs text-center"${add_attribute("href", `/club?id=${-1}`, 0)}>${escape("")}</a></p></div></div></div>
        <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>
        <div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs mt-4 md:mt-0">Kick Off:</p>
          <div class="flex"><p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(countdownDays)}<span class="text-gray-300 text-xs ml-1">d</span>
              : ${escape(countdownHours)}<span class="text-gray-300 text-xs ml-1">h</span>
              : ${escape(countdownMinutes)}<span class="text-gray-300 text-xs ml-1">m</span></p></div>
          <p class="text-gray-300 text-xs">${escape(nextFixtureDate)} | ${escape(nextFixtureTime)}</p></div></div></div></div>

  <div class="m-4"><div class="bg-panel rounded-md m-4"><ul class="flex bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-lg ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>Gameweek History
          </button></li></ul>
      ${`${validate_component(Player_gameweek_history, "PlayerGameweekHistory").$$render($$result, {}, {}, {})}`}</div></div>`;
    }
  })}`;
});
export {
  Page as default
};
