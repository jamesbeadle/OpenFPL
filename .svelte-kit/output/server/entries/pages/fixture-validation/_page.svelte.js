import { c as create_ssr_component } from "../../../chunks/index3.js";
import "@dfinity/agent";
import "../../../chunks/app.constants.js";
import "@dfinity/auth-client";
import "@dfinity/utils";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${`<div class="flex items-center justify-center h-screen"><div class="spinner-border animate-spin inline-block w-8 h-8 border-4 rounded-full" role="status"><span class="visually-hidden">Loading...</span></div>
    <p class="text-center mt-1">Loading Fixtures</p></div>`}`;
});
export {
  Page as default
};
