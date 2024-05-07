

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.imzO6AUa.js","_app/immutable/chunks/index.nza_aed8.js","_app/immutable/chunks/vendor.pR9IcFkJ.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
