

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.kUq2ty5Q.js","_app/immutable/chunks/index.BiVgslvN.js","_app/immutable/chunks/vendor.BLvjRUh5.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
