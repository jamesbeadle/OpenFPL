

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.BX9-RgM_.js","_app/immutable/chunks/index.D5Tbyx2j.js","_app/immutable/chunks/vendor.CrndV6oW.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
