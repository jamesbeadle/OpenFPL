

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9._8t3weP2.js","_app/immutable/chunks/index.24yUIs-3.js","_app/immutable/chunks/vendor.ELOLCXCt.js"];
export const stylesheets = ["_app/immutable/assets/index.482clYIt.css"];
export const fonts = [];
