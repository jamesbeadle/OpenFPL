

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.Dix5Hmrp.js","_app/immutable/chunks/index.p0uHIuz9.js","_app/immutable/chunks/vendor.vSvlDHOz.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
