

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.BpEtqK0T.js","_app/immutable/chunks/index.6mk5M69k.js","_app/immutable/chunks/vendor.LyhkWkPi.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
