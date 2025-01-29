

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.P8IdSofg.js","_app/immutable/chunks/index.TtZ8Ao47.js","_app/immutable/chunks/vendor.BZkzYF1m.js"];
export const stylesheets = ["_app/immutable/assets/index.DI_gyc2R.css"];
export const fonts = [];
