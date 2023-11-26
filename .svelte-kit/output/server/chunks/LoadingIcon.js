import { c as create_ssr_component, e as escape, n as null_to_empty, v as validate_component, b as add_attribute } from "./index2.js";
import { O as OpenFPLIcon } from "./Layout.js";
const LoadingIcon_svelte_svelte_type_style_lang = "";
const css = {
  code: "circle.svelte-1nhsm5j{transition:stroke-dashoffset 0.2s}.svg-scale.svelte-1nhsm5j{transform:scale(2)}",
  map: null
};
const LoadingIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { progress = 0 } = $$props;
  let { className = "" } = $$props;
  if ($$props.progress === void 0 && $$bindings.progress && progress !== void 0)
    $$bindings.progress(progress);
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  $$result.css.add(css);
  return `<div class="flex justify-center items-center h-screen"><div class="${escape(null_to_empty(`${className} flex justify-center items-center h-screen`), true) + " svelte-1nhsm5j"}"><div class="relative">${validate_component(OpenFPLIcon, "OpenFplIcon").$$render($$result, { className: "h-12 w-12" }, {}, {})}

      <svg class="absolute top-0 left-0 h-full w-full svg-scale svelte-1nhsm5j" viewBox="0 0 100 100"><circle cx="50" cy="50" r="45" stroke="#2CE3A6" stroke-dasharray="283"${add_attribute("stroke-dashoffset", 283 - progress / 100 * 283, 0)} fill="transparent" stroke-width="5" transform="rotate(-90 50 50)" class="svelte-1nhsm5j"></circle></svg></div></div>
</div>`;
});
export {
  LoadingIcon as L
};
