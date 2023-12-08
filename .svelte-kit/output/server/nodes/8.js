

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.a79157f6.js","_app/immutable/chunks/index.39db584a.js","_app/immutable/chunks/vendor.398a4dc8.js"];
export const stylesheets = ["_app/immutable/assets/index.862f8b2a.css"];
export const fonts = [];
