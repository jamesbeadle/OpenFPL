

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.Dkmnzj_a.js","_app/immutable/chunks/index.dt38MbyP.js","_app/immutable/chunks/vendor.91b5nc10.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
