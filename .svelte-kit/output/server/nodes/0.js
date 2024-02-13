

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.QSLM7EtF.js","_app/immutable/chunks/index.ckeBYQaT.js","_app/immutable/chunks/vendor.hsIoeDGN.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
