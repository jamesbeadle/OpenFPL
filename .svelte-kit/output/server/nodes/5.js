

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.440b1805.js","_app/immutable/chunks/index.2002a9fc.js","_app/immutable/chunks/vendor.53617c6c.js"];
export const stylesheets = ["_app/immutable/assets/index.2462d728.css"];
export const fonts = [];
