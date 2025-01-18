

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.sYYlC7Rb.js","_app/immutable/chunks/index.Bb5euTb-.js","_app/immutable/chunks/vendor.BGLvqiCG.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
