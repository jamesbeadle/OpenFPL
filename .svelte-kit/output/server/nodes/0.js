

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.db811d34.js","_app/immutable/chunks/index.e5a74962.js","_app/immutable/chunks/vendor.e707e0a3.js"];
export const stylesheets = ["_app/immutable/assets/index.e87a5613.css"];
export const fonts = [];
