

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.pk70QWcs.js","_app/immutable/chunks/index.cpnoR8ih.js","_app/immutable/chunks/vendor.sFbGAM1W.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
