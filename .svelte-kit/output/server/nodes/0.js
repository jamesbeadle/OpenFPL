

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.BnZPFx25.js","_app/immutable/chunks/index.DGE_BOuz.js","_app/immutable/chunks/vendor.BB0dFjMb.js"];
export const stylesheets = ["_app/immutable/assets/index.DknT4k6x.css"];
export const fonts = [];
