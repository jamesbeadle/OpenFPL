

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.Jqef1Vpo.js","_app/immutable/chunks/index.-VY4MWjE.js","_app/immutable/chunks/vendor.27DMH7ky.js"];
export const stylesheets = ["_app/immutable/assets/index.lJ5sRFEc.css"];
export const fonts = [];
