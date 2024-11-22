

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.Cs5-cegE.js","_app/immutable/chunks/index.BHMF_V_u.js","_app/immutable/chunks/vendor.gz3ZAMFu.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
