

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.UiW1-m4Y.js","_app/immutable/chunks/index.eD_l2pag.js","_app/immutable/chunks/vendor.V1G1edFp.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
