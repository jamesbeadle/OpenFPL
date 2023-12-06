

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.ee389b32.js","_app/immutable/chunks/index.84b7e5b3.js","_app/immutable/chunks/vendor.d061dfbb.js"];
export const stylesheets = ["_app/immutable/assets/index.dea223c5.css"];
export const fonts = [];
