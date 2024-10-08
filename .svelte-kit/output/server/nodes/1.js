

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.AG2aZYlT.js","_app/immutable/chunks/index.BQt4hJ4e.js","_app/immutable/chunks/vendor.BxzTRA2Y.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
