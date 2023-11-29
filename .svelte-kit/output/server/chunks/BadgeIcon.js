import { c as create_ssr_component, d as add_attribute } from "./index3.js";
const BadgeIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  let { primaryColour = "" } = $$props;
  let { secondaryColour = "" } = $$props;
  let { thirdColour = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  if ($$props.primaryColour === void 0 && $$bindings.primaryColour && primaryColour !== void 0)
    $$bindings.primaryColour(primaryColour);
  if ($$props.secondaryColour === void 0 && $$bindings.secondaryColour && secondaryColour !== void 0)
    $$bindings.secondaryColour(secondaryColour);
  if ($$props.thirdColour === void 0 && $$bindings.thirdColour && thirdColour !== void 0)
    $$bindings.thirdColour(thirdColour);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 814 814"><path d="M407 33.9165C295.984 33.9165 135.667 118.708 135.667 118.708V508.75C135.667 508.75 141.044 561.82 152.625 593.541C194.871 709.259 407 780.083 407 780.083C407 780.083 619.129 709.259 661.375 593.541C672.956 561.82 678.333 508.75 678.333 508.75V118.708C678.333 118.708 518.016 33.9165 407 33.9165Z"${add_attribute("fill", primaryColour, 0)}></path><path d="M712.25 101.75V493.013C712.25 649.097 603.581 689.831 407 814C210.419 689.831 101.75 649.063 101.75 493.013V101.75C167.718 45.2448 282.729 0 407 0C531.271 0 646.282 45.2448 712.25 101.75ZM644.417 135.361C585.775 96.052 496.506 67.8333 407.237 67.8333C317.223 67.8333 228.124 96.1198 169.583 135.361V492.979C169.583 595.712 225.817 622.235 407 734.025C587.979 622.337 644.417 595.814 644.417 492.979V135.361Z"${add_attribute("fill", thirdColour, 0)}></path><path d="M407.237 135.667C464.862 135.667 527.811 150.42 576.583 174.467V493.012C576.583 547.347 562.542 558.539 407 654.422L407.237 135.667Z"${add_attribute("fill", secondaryColour, 0)}></path></svg>`;
});
export {
  BadgeIcon as B
};