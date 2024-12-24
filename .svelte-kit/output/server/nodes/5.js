

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.CcBNZ8pa.js","_app/immutable/chunks/index.EEEp3mA5.js","_app/immutable/chunks/vendor.DkHAgQUu.js"];
export const stylesheets = ["_app/immutable/assets/index.yn7f-zCh.css"];
export const fonts = [];
