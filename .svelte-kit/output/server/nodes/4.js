

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.mQ_ufbGA.js","_app/immutable/chunks/index.mAGRpK-0.js","_app/immutable/chunks/vendor.iHPJyCR-.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
