import { c as create_ssr_component, v as validate_component, d as add_attribute } from "../../../chunks/index3.js";
import { L as Layout } from "../../../chunks/Layout.js";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="bg-panel rounded-lg m-4"><ul class="flex rounded-lg bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-lg ${"active-tab"}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-white"}`,
        0
      )}>Proposals</button></li></ul>

      ${`<div class="p-4"><p>Proposals will appear here after the SNS decentralisation sale.</p>
          <p>For now the OpenFPL team will continue to add fixture data through <a class="text-blue-500" href="/fixture-validation">this</a> view.
          </p></div>`}</div></div>`;
    }
  })}`;
});
export {
  Page as default
};
