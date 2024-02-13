

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.XcomPu1Y.js","_app/immutable/chunks/index.6WP3nwe8.js","_app/immutable/chunks/vendor.wG7Y2Cun.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
