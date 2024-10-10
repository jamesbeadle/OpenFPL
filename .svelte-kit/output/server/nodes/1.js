

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.0bgkrz1H.js","_app/immutable/chunks/index.Dw14OJGW.js","_app/immutable/chunks/vendor.CwiUmlJj.js"];
export const stylesheets = ["_app/immutable/assets/index.WFhWvobM.css"];
export const fonts = [];
