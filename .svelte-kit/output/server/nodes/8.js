

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.uSip2ETf.js","_app/immutable/chunks/index.DlgKAGeU.js","_app/immutable/chunks/vendor.DGWZq8v6.js"];
export const stylesheets = ["_app/immutable/assets/index.DI_gyc2R.css"];
export const fonts = [];
