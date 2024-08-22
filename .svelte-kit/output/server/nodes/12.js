

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.D4eS_7_f.js","_app/immutable/chunks/index.BRpR1_Hq.js","_app/immutable/chunks/vendor.BBdnrATY.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
