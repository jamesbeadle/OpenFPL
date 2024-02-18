

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.JL4UFO6Z.js","_app/immutable/chunks/index.24yUIs-3.js","_app/immutable/chunks/vendor.ELOLCXCt.js"];
export const stylesheets = ["_app/immutable/assets/index.482clYIt.css"];
export const fonts = [];
