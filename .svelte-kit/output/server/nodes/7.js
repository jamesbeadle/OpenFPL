

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.Bfk8XHYt.js","_app/immutable/chunks/index.CtN1Jx6S.js","_app/immutable/chunks/vendor.BfIfyYda.js"];
export const stylesheets = ["_app/immutable/assets/index.DmmpSnor.css"];
export const fonts = [];
