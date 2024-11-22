

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.Ctw9EtU5.js","_app/immutable/chunks/index.BHMF_V_u.js","_app/immutable/chunks/vendor.gz3ZAMFu.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
