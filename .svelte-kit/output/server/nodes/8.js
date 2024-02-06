

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.p-XeYnI1.js","_app/immutable/chunks/index.OM25CVuU.js","_app/immutable/chunks/vendor.0jy579Do.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
