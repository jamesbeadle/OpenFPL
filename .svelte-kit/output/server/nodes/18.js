

export const index = 18;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/18.qsQzCOhQ.js","_app/immutable/chunks/index.wXjPbdew.js","_app/immutable/chunks/vendor.f5cRldcM.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
