

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.6e753596.js","_app/immutable/chunks/index.2cecf91d.js","_app/immutable/chunks/vendor.2353e400.js"];
export const stylesheets = ["_app/immutable/assets/index.4609496a.css"];
export const fonts = [];
