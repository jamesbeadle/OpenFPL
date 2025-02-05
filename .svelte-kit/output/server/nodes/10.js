

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.B_ot7UBm.js","_app/immutable/chunks/index.BCy7GDc7.js","_app/immutable/chunks/vendor.D9AN0HQc.js"];
export const stylesheets = ["_app/immutable/assets/index.3x8TuEHK.css"];
export const fonts = [];
