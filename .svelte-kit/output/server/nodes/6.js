

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.iiRII9FU.js","_app/immutable/chunks/index.yRY_CT8F.js","_app/immutable/chunks/vendor.Dzx9b1MF.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
