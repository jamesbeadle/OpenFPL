

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.C_f8ECO6.js","_app/immutable/chunks/index.CZk4YoWU.js","_app/immutable/chunks/vendor.DwcYOq77.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9RvrdY.css"];
export const fonts = [];
