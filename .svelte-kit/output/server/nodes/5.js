

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.j6sMrBg0.js","_app/immutable/chunks/index.xZBGozng.js","_app/immutable/chunks/vendor.MFp1l1y3.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
