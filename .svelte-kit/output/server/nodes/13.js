

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.p6kVaEaA.js","_app/immutable/chunks/index.7dUL5Mvz.js","_app/immutable/chunks/vendor.Qs1-0cZc.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
