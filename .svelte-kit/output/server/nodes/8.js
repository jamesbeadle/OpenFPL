

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.ov_7YE0g.js","_app/immutable/chunks/index.BRpR1_Hq.js","_app/immutable/chunks/vendor.BBdnrATY.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
