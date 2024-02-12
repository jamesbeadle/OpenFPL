

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.YTYmW3l3.js","_app/immutable/chunks/index.7dUL5Mvz.js","_app/immutable/chunks/vendor.Qs1-0cZc.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
