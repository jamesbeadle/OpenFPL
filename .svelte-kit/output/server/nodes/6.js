

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.V3slET3o.js","_app/immutable/chunks/index.G7d1Sx9t.js","_app/immutable/chunks/vendor.Rf4l0dsQ.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
