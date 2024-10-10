

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.DF6TYh9g.js","_app/immutable/chunks/index.BiVgslvN.js","_app/immutable/chunks/vendor.BLvjRUh5.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
