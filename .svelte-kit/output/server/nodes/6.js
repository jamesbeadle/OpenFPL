

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.DM6IVrUM.js","_app/immutable/chunks/index.CB-wWf15.js","_app/immutable/chunks/vendor.DU63niPF.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
