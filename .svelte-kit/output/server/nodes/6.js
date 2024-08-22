

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.5cB7469K.js","_app/immutable/chunks/index.ltbeZL92.js","_app/immutable/chunks/vendor.PqoAZjCC.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
