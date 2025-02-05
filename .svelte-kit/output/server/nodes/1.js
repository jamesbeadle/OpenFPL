

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.Dr-noH1A.js","_app/immutable/chunks/index.DrWzKATK.js","_app/immutable/chunks/vendor.mDcLQhi8.js"];
export const stylesheets = ["_app/immutable/assets/index.3x8TuEHK.css"];
export const fonts = [];
