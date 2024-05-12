

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.pVCqD0vY.js","_app/immutable/chunks/index.lJk0NqPg.js","_app/immutable/chunks/vendor.SjY331Zq.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
