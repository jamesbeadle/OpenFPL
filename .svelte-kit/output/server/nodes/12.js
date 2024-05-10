

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.qp5EnGDC.js","_app/immutable/chunks/index.wVOtZ4od.js","_app/immutable/chunks/vendor.0WKKziQh.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
