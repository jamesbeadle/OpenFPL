

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.FxKprRg5.js","_app/immutable/chunks/index.DuAglEVb.js","_app/immutable/chunks/vendor.hUSe3yth.js"];
export const stylesheets = ["_app/immutable/assets/index.BnVD0ddi.css"];
export const fonts = [];
