

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/logs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.4D-ewnRI.js","_app/immutable/chunks/index.QsEDd-vp.js","_app/immutable/chunks/vendor.RqmdUEvQ.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
