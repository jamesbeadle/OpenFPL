

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.Id6JIO2m.js","_app/immutable/chunks/index.1jbsnd12.js","_app/immutable/chunks/vendor.Ym-lahay.js"];
export const stylesheets = ["_app/immutable/assets/index.KveW6Omx.css"];
export const fonts = [];
