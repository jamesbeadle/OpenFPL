

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.HeSQa8QX.js","_app/immutable/chunks/index.DQsxTc7K.js","_app/immutable/chunks/vendor.B-YlKLv-.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
