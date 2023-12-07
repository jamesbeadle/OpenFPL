

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.e89b8b2c.js","_app/immutable/chunks/index.f1e93ddb.js","_app/immutable/chunks/vendor.cb9ca98f.js"];
export const stylesheets = ["_app/immutable/assets/index.78e714a3.css"];
export const fonts = [];
