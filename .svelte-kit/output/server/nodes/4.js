

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.BOd1m27Q.js","_app/immutable/chunks/index.B7xrigMo.js","_app/immutable/chunks/vendor.Bft4PkYq.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
