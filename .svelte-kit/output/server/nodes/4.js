

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.o2Hl6MkZ.js","_app/immutable/chunks/index.hPPP8Pz3.js","_app/immutable/chunks/vendor.PmbRkDNL.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
