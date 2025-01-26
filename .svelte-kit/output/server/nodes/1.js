

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.CvC7gr7b.js","_app/immutable/chunks/index.DuAglEVb.js","_app/immutable/chunks/vendor.hUSe3yth.js"];
export const stylesheets = ["_app/immutable/assets/index.BnVD0ddi.css"];
export const fonts = [];
