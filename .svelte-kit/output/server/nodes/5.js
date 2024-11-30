

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.DskmSWtp.js","_app/immutable/chunks/index.CIUF4qHH.js","_app/immutable/chunks/vendor.BgTLETNM.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
