

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.iMX6eg0d.js","_app/immutable/chunks/index.Dw14OJGW.js","_app/immutable/chunks/vendor.CwiUmlJj.js"];
export const stylesheets = ["_app/immutable/assets/index.WFhWvobM.css"];
export const fonts = [];
