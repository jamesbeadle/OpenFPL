

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.sj8MLyiH.js","_app/immutable/chunks/index.8SA59u2t.js","_app/immutable/chunks/vendor.NEyrHX3U.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
