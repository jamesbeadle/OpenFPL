

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.0tKN4jwb.js","_app/immutable/chunks/index.CnuGqOJ4.js","_app/immutable/chunks/vendor.DLVNmxxu.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
