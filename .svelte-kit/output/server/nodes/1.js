

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.MKFMva0D.js","_app/immutable/chunks/index.huGMpKYj.js","_app/immutable/chunks/vendor.hB46pdEq.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
