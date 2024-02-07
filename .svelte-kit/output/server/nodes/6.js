

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.hcXL921J.js","_app/immutable/chunks/index.hPPP8Pz3.js","_app/immutable/chunks/vendor.PmbRkDNL.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
