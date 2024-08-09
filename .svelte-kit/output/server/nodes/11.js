

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/logs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.nNAYO9QP.js","_app/immutable/chunks/index.GI747qyO.js","_app/immutable/chunks/vendor.9HRA6_pd.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
