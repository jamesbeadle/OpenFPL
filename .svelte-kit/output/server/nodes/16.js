

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.OvV8-pha.js","_app/immutable/chunks/index.QsEDd-vp.js","_app/immutable/chunks/vendor.RqmdUEvQ.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
