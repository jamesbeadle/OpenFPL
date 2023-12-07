

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.8feecef2.js","_app/immutable/chunks/index.34586331.js","_app/immutable/chunks/vendor.e301af42.js"];
export const stylesheets = ["_app/immutable/assets/index.f04596bd.css"];
export const fonts = [];
