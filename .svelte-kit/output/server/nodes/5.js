

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.cbnwKuaw.js","_app/immutable/chunks/index.CtN1Jx6S.js","_app/immutable/chunks/vendor.BfIfyYda.js"];
export const stylesheets = ["_app/immutable/assets/index.DmmpSnor.css"];
export const fonts = [];
