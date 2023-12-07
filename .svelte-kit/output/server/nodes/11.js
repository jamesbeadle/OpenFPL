

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.d23f0ab0.js","_app/immutable/chunks/index.f1e93ddb.js","_app/immutable/chunks/vendor.cb9ca98f.js"];
export const stylesheets = ["_app/immutable/assets/index.78e714a3.css"];
export const fonts = [];
