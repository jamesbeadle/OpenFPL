

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.CvXfeGxi.js","_app/immutable/chunks/index.Bb5euTb-.js","_app/immutable/chunks/vendor.BGLvqiCG.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
