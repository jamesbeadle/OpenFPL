

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.f04c4cd5.js","_app/immutable/chunks/index.85206748.js"];
export const stylesheets = [];
export const fonts = [];
