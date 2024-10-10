

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.pOwaezE3.js","_app/immutable/chunks/index.Dw14OJGW.js","_app/immutable/chunks/vendor.CwiUmlJj.js"];
export const stylesheets = ["_app/immutable/assets/index.WFhWvobM.css"];
export const fonts = [];
