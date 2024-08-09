

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.PVrTabm6.js","_app/immutable/chunks/index.GI747qyO.js","_app/immutable/chunks/vendor.9HRA6_pd.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
