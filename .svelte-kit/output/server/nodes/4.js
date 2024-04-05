

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.21jK49e8.js","_app/immutable/chunks/index.yRY_CT8F.js","_app/immutable/chunks/vendor.Dzx9b1MF.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
