

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.BZw3MO3C.js","_app/immutable/chunks/index.BCy7GDc7.js","_app/immutable/chunks/vendor.D9AN0HQc.js"];
export const stylesheets = ["_app/immutable/assets/index.3x8TuEHK.css"];
export const fonts = [];
