

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.5hoyElB-.js","_app/immutable/chunks/index.CLi1RpFB.js","_app/immutable/chunks/vendor.Bc0f2jhl.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9RvrdY.css"];
export const fonts = [];
