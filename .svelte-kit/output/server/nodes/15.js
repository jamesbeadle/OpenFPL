

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.wM2Go-bQ.js","_app/immutable/chunks/index.eD_l2pag.js","_app/immutable/chunks/vendor.V1G1edFp.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
