

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.1efb0d88.js","_app/immutable/chunks/index.9f0003df.js","_app/immutable/chunks/vendor.2e93f72a.js"];
export const stylesheets = ["_app/immutable/assets/index.fa34df7c.css"];
export const fonts = [];
