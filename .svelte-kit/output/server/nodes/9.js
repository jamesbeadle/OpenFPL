

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.UZgv1xgH.js","_app/immutable/chunks/index.1jbsnd12.js","_app/immutable/chunks/vendor.Ym-lahay.js"];
export const stylesheets = ["_app/immutable/assets/index.KveW6Omx.css"];
export const fonts = [];
