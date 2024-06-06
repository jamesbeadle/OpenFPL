

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.W6lh7fgK.js","_app/immutable/chunks/index.qllRPenI.js","_app/immutable/chunks/vendor.4bb5GVx4.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
