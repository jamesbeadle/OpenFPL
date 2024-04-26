

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.7G61VJzq.js","_app/immutable/chunks/index.eD_l2pag.js","_app/immutable/chunks/vendor.V1G1edFp.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
