

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.e842a93e.js","_app/immutable/chunks/index.80ec7ad5.js","_app/immutable/chunks/vendor.5806c9fe.js"];
export const stylesheets = ["_app/immutable/assets/index.570eca6a.css"];
export const fonts = [];
