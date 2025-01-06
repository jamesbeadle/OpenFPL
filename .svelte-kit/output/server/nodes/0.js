

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.Bc8FhKue.js","_app/immutable/chunks/index.AmMYR9WD.js","_app/immutable/chunks/vendor.CeSDK7tZ.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
