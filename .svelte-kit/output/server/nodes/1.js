

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.LkfX09MJ.js","_app/immutable/chunks/index.akQFABtw.js","_app/immutable/chunks/vendor.1xCNdly2.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
