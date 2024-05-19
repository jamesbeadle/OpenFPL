

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.1Y9Mw6iM.js","_app/immutable/chunks/index.p0uHIuz9.js","_app/immutable/chunks/vendor.vSvlDHOz.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
