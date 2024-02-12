

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.eSKzuQZi.js","_app/immutable/chunks/index.7dUL5Mvz.js","_app/immutable/chunks/vendor.Qs1-0cZc.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
