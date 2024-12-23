

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.CyLAFQNL.js","_app/immutable/chunks/index.CZk4YoWU.js","_app/immutable/chunks/vendor.DwcYOq77.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9RvrdY.css"];
export const fonts = [];
