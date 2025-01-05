

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.WevnAVXm.js","_app/immutable/chunks/index.6mk5M69k.js","_app/immutable/chunks/vendor.LyhkWkPi.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
