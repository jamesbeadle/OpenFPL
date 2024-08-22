

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.UKhcETMD.js","_app/immutable/chunks/index.WUYkU5M6.js","_app/immutable/chunks/vendor.zNSaqJ3p.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
