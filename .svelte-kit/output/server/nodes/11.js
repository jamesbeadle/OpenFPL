

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.5b1ca828.js","_app/immutable/chunks/index.2cecf91d.js","_app/immutable/chunks/vendor.2353e400.js"];
export const stylesheets = ["_app/immutable/assets/index.4609496a.css"];
export const fonts = [];
