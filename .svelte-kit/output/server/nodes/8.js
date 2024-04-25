

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.-38Zg4Mk.js","_app/immutable/chunks/index.sDSv6r9A.js","_app/immutable/chunks/vendor.2eEpgq4P.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
