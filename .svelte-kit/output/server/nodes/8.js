

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.p8rdMxyc.js","_app/immutable/chunks/index.BD1-Avof.js","_app/immutable/chunks/vendor.D6LFIRIk.js"];
export const stylesheets = ["_app/immutable/assets/index.DI_gyc2R.css"];
export const fonts = [];
