

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.B3LH8DXt.js","_app/immutable/chunks/index.AmMYR9WD.js","_app/immutable/chunks/vendor.CeSDK7tZ.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
