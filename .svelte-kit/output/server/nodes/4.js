

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.5mM61_Xs.js","_app/immutable/chunks/index.1jbsnd12.js","_app/immutable/chunks/vendor.Ym-lahay.js"];
export const stylesheets = ["_app/immutable/assets/index.KveW6Omx.css"];
export const fonts = [];
