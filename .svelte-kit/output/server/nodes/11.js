

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.81M_LTrg.js","_app/immutable/chunks/index.lJk0NqPg.js","_app/immutable/chunks/vendor.SjY331Zq.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
