

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.CHjUAeP4.js","_app/immutable/chunks/index.aYNPSdxF.js","_app/immutable/chunks/vendor.BD4x6AJW.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
