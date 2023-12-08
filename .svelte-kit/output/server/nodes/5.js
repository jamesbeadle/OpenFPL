

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.9fba2549.js","_app/immutable/chunks/index.39db584a.js","_app/immutable/chunks/vendor.398a4dc8.js"];
export const stylesheets = ["_app/immutable/assets/index.862f8b2a.css"];
export const fonts = [];
