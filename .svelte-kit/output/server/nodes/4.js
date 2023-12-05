

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.b05e8c91.js","_app/immutable/chunks/index.af4712d6.js","_app/immutable/chunks/vendor.8ee4eaca.js"];
export const stylesheets = ["_app/immutable/assets/index.b96eeb27.css"];
export const fonts = [];
