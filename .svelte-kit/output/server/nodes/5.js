

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5._ahQKdR7.js","_app/immutable/chunks/index.iPuWD1QW.js","_app/immutable/chunks/vendor.qer07tqA.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
