

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.udqiWYC3.js","_app/immutable/chunks/index.I7Cv-gam.js","_app/immutable/chunks/vendor.B6xHTgLG.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
