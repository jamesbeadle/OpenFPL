

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.2lZHA3yS.js","_app/immutable/chunks/index._IQWgTCV.js","_app/immutable/chunks/vendor.HoqO4wW8.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
