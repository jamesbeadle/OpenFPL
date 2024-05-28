

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.Z1Gd0Aji.js","_app/immutable/chunks/index.mAGRpK-0.js","_app/immutable/chunks/vendor.iHPJyCR-.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
