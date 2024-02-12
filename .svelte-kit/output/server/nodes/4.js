

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.ovyLzU9y.js","_app/immutable/chunks/index.7dUL5Mvz.js","_app/immutable/chunks/vendor.Qs1-0cZc.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
