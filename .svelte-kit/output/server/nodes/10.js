

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.2bb99e2d.js","_app/immutable/chunks/index.8d56e52c.js","_app/immutable/chunks/vendor.46433e6e.js"];
export const stylesheets = ["_app/immutable/assets/index.1eb97911.css"];
export const fonts = [];
