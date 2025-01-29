

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.BuSwkUTE.js","_app/immutable/chunks/index.TtZ8Ao47.js","_app/immutable/chunks/vendor.BZkzYF1m.js"];
export const stylesheets = ["_app/immutable/assets/index.DI_gyc2R.css"];
export const fonts = [];
