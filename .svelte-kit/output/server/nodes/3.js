

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.1riVLaRT.js","_app/immutable/chunks/index.-uxyNZMg.js","_app/immutable/chunks/vendor.TtSWZ-Fy.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
