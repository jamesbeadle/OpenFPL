import { c as create_ssr_component, o as onDestroy, v as validate_component, d as add_attribute } from "../../../chunks/index3.js";
import "../../../chunks/index.js";
import "../../../chunks/system-store.js";
import "../../../chunks/manager-store.js";
import { a as LoadingIcon, L as Layout } from "../../../chunks/Layout.js";
import "../../../chunks/app.constants.js";
import "@dfinity/auth-client";
import "@dfinity/utils";
import "@dfinity/agent";
import "../../../chunks/team-store.js";
const CopyIcon_svelte_svelte_type_style_lang = "";
const updateUsernameModal_svelte_svelte_type_style_lang = "";
const updateFavouriteTeamModal_svelte_svelte_type_style_lang = "";
const profileDetail_svelte_svelte_type_style_lang = "";
const css = {
  code: '.file-upload-wrapper.svelte-10w7xjk{position:relative;overflow:hidden;display:inline-block;width:100%}.btn-file-upload.svelte-10w7xjk{width:100%;border:none;padding:10px 20px;border-radius:5px;font-size:1em;cursor:pointer;text-align:center;display:block}input[type="file"].svelte-10w7xjk{font-size:100px;position:absolute;left:0;top:0;opacity:0;width:100%;height:100%;cursor:pointer}',
  map: null
};
const Profile_detail = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  onDestroy(() => {
  });
  $$result.css.add(css);
  return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}`;
});
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="bg-panel rounded-lg m-4"><ul class="flex rounded-lg bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-lg ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>Details</button></li>
        <li${add_attribute("class", `mr-4 text-xs md:text-lg ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Gameweeks</button></li></ul>

      ${`${validate_component(Profile_detail, "ProfileDetail").$$render($$result, {}, {}, {})}`}</div></div>`;
    }
  })}`;
});
export {
  Page as default
};
