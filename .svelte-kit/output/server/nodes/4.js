

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.4qWiqPfp.js","_app/immutable/chunks/index.R7CZTyFa.js","_app/immutable/chunks/vendor.WW9KjT63.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
