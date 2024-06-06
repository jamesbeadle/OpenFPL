

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.vB6sKg1u.js","_app/immutable/chunks/index.qllRPenI.js","_app/immutable/chunks/vendor.4bb5GVx4.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
