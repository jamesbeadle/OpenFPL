

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.BgxaBewH.js","_app/immutable/chunks/index.sDSv6r9A.js","_app/immutable/chunks/vendor.2eEpgq4P.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
