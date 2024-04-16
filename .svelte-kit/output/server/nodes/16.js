

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.zh1rTo1N.js","_app/immutable/chunks/index.5PoTnmgC.js","_app/immutable/chunks/vendor.o18DwYu9.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
