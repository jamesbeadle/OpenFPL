

export const index = 17;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/17.nakeeth5.js","_app/immutable/chunks/index.a29C8zV4.js","_app/immutable/chunks/vendor.4IjpAYxE.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
