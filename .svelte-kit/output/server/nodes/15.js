

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/status/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.CMkfvdsT.js","_app/immutable/chunks/index.CB-wWf15.js","_app/immutable/chunks/vendor.DU63niPF.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
