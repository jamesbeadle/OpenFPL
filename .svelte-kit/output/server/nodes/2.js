

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.DQHxnwZx.js","_app/immutable/chunks/index.DrWzKATK.js","_app/immutable/chunks/vendor.mDcLQhi8.js"];
export const stylesheets = ["_app/immutable/assets/index.3x8TuEHK.css"];
export const fonts = [];
