

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.DYSRr3Of.js","_app/immutable/chunks/index.D9GMCFuj.js","_app/immutable/chunks/vendor.egwcexiT.js"];
export const stylesheets = ["_app/immutable/assets/index.CJCc5hpr.css"];
export const fonts = [];
