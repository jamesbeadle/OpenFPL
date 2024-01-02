

export const index = 14;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/14.42bd5c2b.js","_app/immutable/chunks/index.f37048de.js","_app/immutable/chunks/vendor.2edda797.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
