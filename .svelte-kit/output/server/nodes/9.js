

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.AQsm5KCB.js","_app/immutable/chunks/index.BHMF_V_u.js","_app/immutable/chunks/vendor.gz3ZAMFu.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
