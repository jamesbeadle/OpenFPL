

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.CoFlOFBK.js","_app/immutable/chunks/index.Cr2czQZv.js","_app/immutable/chunks/vendor.C4wzBxk1.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
