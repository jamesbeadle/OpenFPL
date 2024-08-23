

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/status/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.yr4R8TLF.js","_app/immutable/chunks/index.7vjBrd2P.js","_app/immutable/chunks/vendor.O8W3gYEr.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
