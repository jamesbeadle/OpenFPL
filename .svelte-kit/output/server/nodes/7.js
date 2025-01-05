

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.B-FEx1Ne.js","_app/immutable/chunks/index.D9GMCFuj.js","_app/immutable/chunks/vendor.egwcexiT.js"];
export const stylesheets = ["_app/immutable/assets/index.CJCc5hpr.css"];
export const fonts = [];
