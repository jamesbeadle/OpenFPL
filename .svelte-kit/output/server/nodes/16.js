

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.oLHKDloi.js","_app/immutable/chunks/index.GyPKHwEb.js","_app/immutable/chunks/vendor.ouuYzY3k.js"];
export const stylesheets = ["_app/immutable/assets/index.KveW6Omx.css"];
export const fonts = [];
