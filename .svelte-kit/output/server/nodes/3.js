

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/canisters/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.CDsfhW0L.js","_app/immutable/chunks/index.D5Tbyx2j.js","_app/immutable/chunks/vendor.CrndV6oW.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
