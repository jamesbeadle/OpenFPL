

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.2WnFb8pK.js","_app/immutable/chunks/index.24yUIs-3.js","_app/immutable/chunks/vendor.ELOLCXCt.js"];
export const stylesheets = ["_app/immutable/assets/index.482clYIt.css"];
export const fonts = [];
