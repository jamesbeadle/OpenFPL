

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.C9tVxwn0.js","_app/immutable/chunks/index.Cr2czQZv.js","_app/immutable/chunks/vendor.C4wzBxk1.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
