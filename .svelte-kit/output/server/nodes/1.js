

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.2fu1Fh-k.js","_app/immutable/chunks/index.DaeqkaXP.js","_app/immutable/chunks/vendor.CLV0qwmn.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
