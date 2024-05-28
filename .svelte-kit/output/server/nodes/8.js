

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8._8BHqlUl.js","_app/immutable/chunks/index.mAGRpK-0.js","_app/immutable/chunks/vendor.iHPJyCR-.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
