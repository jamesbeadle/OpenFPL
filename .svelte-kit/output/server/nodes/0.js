

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.d7DfFLia.js","_app/immutable/chunks/index.fbedQ5Nw.js","_app/immutable/chunks/vendor.VR1BIeqi.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
