

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.DG4ZJ_AV.js","_app/immutable/chunks/index.EEEp3mA5.js","_app/immutable/chunks/vendor.DkHAgQUu.js"];
export const stylesheets = ["_app/immutable/assets/index.yn7f-zCh.css"];
export const fonts = [];
