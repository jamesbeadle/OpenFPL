

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.Dt83DI8M.js","_app/immutable/chunks/index.iAIjWfQX.js","_app/immutable/chunks/vendor.BxX63cV4.js"];
export const stylesheets = ["_app/immutable/assets/index.Bsw_5pHn.css"];
export const fonts = [];
