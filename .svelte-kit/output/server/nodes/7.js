

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.RZWsrHNk.js","_app/immutable/chunks/index.jujRCk2m.js","_app/immutable/chunks/vendor.DBoHS05S.js"];
export const stylesheets = ["_app/immutable/assets/index.482clYIt.css"];
export const fonts = [];
