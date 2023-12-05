

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.392c4d52.js","_app/immutable/chunks/index.af4712d6.js","_app/immutable/chunks/vendor.8ee4eaca.js"];
export const stylesheets = ["_app/immutable/assets/index.b96eeb27.css"];
export const fonts = [];
