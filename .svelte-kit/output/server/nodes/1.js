

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.l7JN3UQg.js","_app/immutable/chunks/index.Bb5euTb-.js","_app/immutable/chunks/vendor.BGLvqiCG.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
