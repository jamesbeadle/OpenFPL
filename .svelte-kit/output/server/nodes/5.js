

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.5a4bedbe.js","_app/immutable/chunks/index.8d56e52c.js","_app/immutable/chunks/vendor.46433e6e.js"];
export const stylesheets = ["_app/immutable/assets/index.1eb97911.css"];
export const fonts = [];
