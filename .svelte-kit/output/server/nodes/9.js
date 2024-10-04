

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.Cy9nllRP.js","_app/immutable/chunks/index.BG1BOtU1.js","_app/immutable/chunks/vendor.1capJgBY.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
