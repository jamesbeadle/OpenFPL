

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.32TDVPlo.js","_app/immutable/chunks/index.fbedQ5Nw.js","_app/immutable/chunks/vendor.VR1BIeqi.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
