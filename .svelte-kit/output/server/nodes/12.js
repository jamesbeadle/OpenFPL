

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.C7wnFvcb.js","_app/immutable/chunks/index.BiVgslvN.js","_app/immutable/chunks/vendor.BLvjRUh5.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
