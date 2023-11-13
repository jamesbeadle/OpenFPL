import { c as create_ssr_component, b as add_attribute, a as subscribe$1, v as validate_component, e as escape, n as null_to_empty } from "./index2.js";
import { p as page } from "./stores.js";
import { AuthClient } from "@dfinity/auth-client";
import { d as derived, w as writable } from "./index.js";
const { subscribe, set } = writable({ identity: null });
const authStore = {
  subscribe,
  set,
  login: async () => {
    const authClient = await AuthClient.create();
    const identityProviderUrl = "https://identity.ic0.app";
    await authClient.login({
      maxTimeToLive: BigInt(7 * 24 * 60 * 60 * 1e3 * 1e3 * 1e3),
      onSuccess: async () => {
        const identity = await authClient.getIdentity();
        set({ identity });
      },
      identityProvider: identityProviderUrl
      // Pass the URL here
    });
  },
  logout: async () => {
    set({ identity: null });
  }
};
derived(
  authStore,
  ($authStore) => $authStore.identity !== null
);
derived(
  authStore,
  ($authStore) => $authStore.identity?.getPrincipal().toString()
);
const OpenFPLIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 137 188"><path d="M68.8457 0C43.0009 4.21054 19.8233 14.9859 0.331561 30.5217L0.264282 30.6627V129.685L68.7784 187.97L136.528 129.685L136.543 30.6204C117.335 15.7049 94.1282 4.14474 68.8457 0ZM82.388 145.014C82.388 145.503 82.0804 145.992 81.5806 146.114L68.7784 150.329C68.5285 150.39 68.2786 150.39 68.0287 150.329L55.2265 146.114C54.7267 145.931 54.4143 145.503 54.4143 145.014V140.738C54.4143 140.31 54.6642 139.883 55.039 139.7L67.8413 133.102C68.2161 132.919 68.591 132.919 68.9658 133.102L81.768 139.7C82.1429 139.883 82.388 140.31 82.388 140.738V145.014ZM106.464 97.9137C106.464 98.3414 106.214 98.769 105.777 98.9523L96.6607 103.534C96.036 103.84 95.8486 104.573 96.1609 105.122L105.027 121.189C105.277 121.678 105.215 122.228 104.84 122.594L89.7262 137.134C89.2889 137.561 88.6641 137.561 88.1644 137.256L70.9313 125.099C70.369 124.671 70.2441 123.877 70.7439 123.327L84.4208 108.421C85.2329 107.505 84.2958 106.161 83.1713 106.527L68.7447 111.109C68.4948 111.17 68.2449 111.17 67.9951 111.109L53.6358 106.527C52.4488 106.161 51.5742 107.566 52.3863 108.421L66.0584 123.327C66.5582 123.877 66.4332 124.671 65.871 125.099L48.6379 137.256C48.1381 137.561 47.5134 137.561 47.0761 137.134L31.9671 122.533C31.5923 122.167 31.5298 121.617 31.7797 121.128L40.6461 105.061C40.9585 104.45 40.7086 103.778 40.1463 103.473L31.03 98.8912C30.6552 98.7079 30.3428 98.2803 30.3428 97.8526V65.8413C30.3428 64.9249 31.4049 64.314 32.217 64.8639L39.709 69.8122C40.0214 70.0565 40.2088 70.362 40.2088 70.7896L40.2713 79.0368C40.2713 79.4034 40.4587 79.7699 40.7711 80.0143L51.7616 87.5284C52.5737 88.0782 53.6983 87.4673 53.6358 86.4898L52.9486 71.9503C52.9486 71.5838 52.7612 71.2173 52.4488 71.034L30.8426 56.5556C30.5302 56.3112 30.3428 55.9447 30.3428 55.5781V48.4305C30.3428 48.1862 30.4053 47.8807 30.5927 47.6975L38.3971 38.0452C38.7094 37.6176 39.2717 37.4954 39.7715 37.6786L67.9326 47.8807C68.1825 48.0029 68.4948 48.0029 68.7447 47.8807L96.9106 37.6786C97.4104 37.4954 97.9679 37.6786 98.2802 38.0452L106.089 47.6975C106.277 47.8807 106.339 48.1862 106.339 48.4305V55.5781C106.339 55.9447 106.152 56.3112 105.84 56.5556L84.2333 71.034C84.0459 71.2783 83.8585 71.6449 83.8585 72.0114L83.1713 86.5509C83.1088 87.5284 84.2333 88.1393 85.0455 87.5895L96.036 80.0753C96.3484 79.831 96.5358 79.5255 96.5358 79.0979L96.5983 70.8507C96.5983 70.4842 96.7857 70.1176 97.098 69.8733L104.59 64.9249C105.402 64.3751 106.464 64.9249 106.464 65.9024V97.9137Z" fill="#fffff"></path></svg>`;
});
const WalletIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 24 24"><path d="M12.136.326A1.5 1.5 0 0 1 14 1.78V3h.5A1.5 1.5 0 0 1 16 4.5v9a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 13.5v-9a1.5 1.5 0 0 1 1.432-1.499L12.136.326zM5.562 3H13V1.78a.5.5 0 0 0-.621-.484L5.562 3zM1.5 4a.5.5 0 0 0-.5.5v9a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-13z"></path><path d="M15.5,6.5v3a1,1,0,0,1-1,1h-3.5v-5H14.5A1,1,0,0,1,15.5,6.5Z"></path><path d="M12,8a.5,.5 0,1,1,.001,0Z"></path></svg>`;
});
const Header_svelte_svelte_type_style_lang = "";
const css = {
  code: 'header.svelte-tlhn8x{background-color:rgba(36, 37, 41, 0.9)}.nav-underline.svelte-tlhn8x{position:relative;display:inline-block;color:white}.nav-underline.svelte-tlhn8x::after{content:"";position:absolute;width:100%;height:2px;background-color:#2ce3a6;bottom:0;left:0;transform:scaleX(0);transition:transform 0.3s ease-in-out;color:#2ce3a6}.nav-underline.svelte-tlhn8x:hover::after,.nav-underline.active.svelte-tlhn8x::after{transform:scaleX(1);color:#2ce3a6}.nav-underline.svelte-tlhn8x:hover::after{transform:scaleX(1);background-color:gray}.nav-button.svelte-tlhn8x{background-color:transparent}.nav-button.svelte-tlhn8x:hover{background-color:transparent;color:#2ce3a6;border:none}',
  map: null
};
const Header = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let currentClass;
  let $page, $$unsubscribe_page;
  let $isAuthenticated, $$unsubscribe_isAuthenticated;
  $$unsubscribe_page = subscribe$1(page, (value) => $page = value);
  const isAuthenticated = derived(authStore, ($authStore) => $authStore.identity !== null && $authStore.identity !== void 0);
  $$unsubscribe_isAuthenticated = subscribe$1(isAuthenticated, (value) => $isAuthenticated = value);
  $$result.css.add(css);
  currentClass = (route) => $page.url.pathname === route ? "text-blue-500 nav-underline active" : "nav-underline";
  $$unsubscribe_page();
  $$unsubscribe_isAuthenticated();
  return `<header class="svelte-tlhn8x"><nav class="text-white"><div class="px-4 h-16 flex justify-between items-center w-full"><a href="/" class="hover:text-gray-400 flex items-center">${validate_component(OpenFPLIcon, "OpenFPLIcon").$$render($$result, { className: "h-8 w-auto" }, {}, {})}<b class="ml-2">OpenFPL</b></a>
      <button class="md:hidden focus:outline-none"><svg width="24" height="18" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="24" height="2" rx="1" fill="currentColor"></rect><rect y="8" width="24" height="2" rx="1" fill="currentColor"></rect><rect y="16" width="24" height="2" rx="1" fill="currentColor"></rect></svg></button>
      ${$isAuthenticated ? `<ul class="hidden md:flex"><li class="mx-2 flex items-center h-16"><a href="/" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/"), true) + " svelte-tlhn8x"}"><span class="flex items-center h-full px-4">Home</span></a></li>
          <li class="mx-2 flex items-center h-16"><a href="/pick-team" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/pick-team"), true) + " svelte-tlhn8x"}"><span class="flex items-center h-full px-4">Squad Selection</span></a></li>
          <li class="mx-2 flex items-center h-16"><a href="/governance" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/governance"), true) + " svelte-tlhn8x"}"><span class="flex items-center h-full px-4">Governance</span></a></li>
          <li class="mx-2 flex items-center h-16"><a href="/profile" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/profile"), true) + " svelte-tlhn8x"}"><span class="flex items-center h-full px-4">Profile</span></a></li>
          <li class="mx-2 flex items-center h-16"><button class="flex items-center justify-center px-4 py-2 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-tlhn8x">Disconnect
              ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul>
        <div class="${escape(null_to_empty(`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`), true) + " svelte-tlhn8x"}"><ul class="flex flex-col"><li class="p-2"><a href="/" class="${escape(null_to_empty(`nav-underline hover:text-gray-400 ${currentClass("/")}`), true) + " svelte-tlhn8x"}">Home</a></li>
            <li class="p-2"><a href="/pick-team" class="${escape(null_to_empty(currentClass("/pick-team")), true) + " svelte-tlhn8x"}">Squad Selection</a></li>
            <li class="p-2"><a href="/governance" class="${escape(null_to_empty(currentClass("/governance")), true) + " svelte-tlhn8x"}">Governance</a></li>
            <li class="p-2"><a href="/profile" class="${escape(null_to_empty(currentClass("/profile")), true) + " svelte-tlhn8x"}">Profile</a></li>
            <li class="p-2"><button class="flex items-center justify-center px-4 py-2 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-tlhn8x">Disconnect
                ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div>` : `<ul class="hidden md:flex"><li class="mx-2 flex items-center h-16"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-tlhn8x">Connect
              ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul>
        <div class="${escape(null_to_empty(`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`), true) + " svelte-tlhn8x"}"><ul class="flex flex-col"><li class="p-2"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-tlhn8x">Connect
                ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div>`}</div></nav>
</header>`;
});
const JunoIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 130 130"><g id="Layer_1-2"><g><path d="M91.99,64.798c0,-20.748 -16.845,-37.593 -37.593,-37.593l-0.003,-0c-20.749,-0 -37.594,16.845 -37.594,37.593l0,0.004c0,20.748 16.845,37.593 37.594,37.593l0.003,0c20.748,0 37.593,-16.845 37.593,-37.593l0,-0.004Z"></path><circle cx="87.153" cy="50.452" r="23.247" style="fill:#7888ff;"></circle></g></g></svg>`;
});
const Footer = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `<footer class="bg-gray-900 text-white py-3"><div class="container mx-auto flex flex-col sm:flex-row items-start sm:items-center justify-between text-xs"><div class="flex-1"><div class="flex justify-start"><div class="flex flex-row pl-4"><a href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" target="_blank" rel="noopener noreferrer"><img src="openchat.png" class="h-4 w-auto mb-2 mr-2" alt="OpenChat"></a>
          <a href="https://twitter.com/OpenFPL_DAO" target="_blank" rel="noopener noreferrer"><img src="twitter.png" class="h-4 w-auto mb-2 mr-2" alt="Twitter"></a>
          <a href="https://t.co/WmOhFA8JUR" target="_blank" rel="noopener noreferrer"><img src="discord.png" class="h-4 w-auto mb-2 mr-2" alt="Discord"></a>
          <a href="https://t.co/vVkquMrdOu" target="_blank" rel="noopener noreferrer"><img src="telegram.png" class="h-4 w-auto mb-2 mr-2" alt="Telegram"></a>
          <a href="https://github.com/jamesbeadle/OpenFPL" target="_blank" rel="noopener noreferrer"><img src="github.png" class="h-4 w-auto mb-2" alt="GitHub"></a></div></div>
      <div class="flex justify-start"><div class="flex flex-col sm:flex-row sm:space-x-2 pl-4"><a href="/whitepaper" class="hover:text-gray-300">Whitepaper</a>
          <span class="hidden sm:flex">|</span>
          <a href="/gameplay" class="hover:text-gray-300">Gameplay Rules</a>
          <span class="hidden sm:flex">|</span>
          <a href="/terms" class="hover:text-gray-300">Terms and Conditions</a>
          <span class="hidden sm:flex">|</span>
          <a href="/fixture-validation-list" class="hover:text-gray-300">Pre-SNS Fixture Validation</a></div></div></div>
    <div class="flex-0"><b class="px-4 mt-2 sm:mt-0 sm:px-10 flex items-center">${validate_component(OpenFPLIcon, "OpenFplIcon").$$render($$result, { className: "h-6 w-auto mr-2" }, {}, {})}OpenFPL</b></div>
    <div class="flex-1"><div class="flex justify-end"><div class="text-right px-4 sm:px-0 mt-1 sm:mt-0"><a href="https://juno.build" target="_blank" class="hover:text-gray-300 flex items-center">Sponsored By juno.build
            ${validate_component(JunoIcon, "JunoIcon").$$render($$result, { className: "h-8 w-auto ml-2" }, {}, {})}</a></div></div></div></div></footer>`;
});
const app = "";
const Layout = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `<div class="flex flex-col h-screen justify-between">${validate_component(Header, "Header").$$render($$result, {}, {}, {})}
  <main class="mb-auto">${slots.default ? slots.default({}) : ``}</main>
  ${validate_component(Footer, "Footer").$$render($$result, {}, {}, {})}
</div>`;
});
export {
  Layout as L
};
