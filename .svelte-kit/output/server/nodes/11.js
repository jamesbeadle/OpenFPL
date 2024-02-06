

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.z94DV0l6.js","_app/immutable/chunks/index.OM25CVuU.js","_app/immutable/chunks/vendor.0jy579Do.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
