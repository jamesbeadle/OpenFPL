

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.DgL4B89w.js","_app/immutable/chunks/index.6mk5M69k.js","_app/immutable/chunks/vendor.LyhkWkPi.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
