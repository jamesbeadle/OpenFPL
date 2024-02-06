

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.E6kuQwMP.js","_app/immutable/chunks/index.yUiKS0Mp.js","_app/immutable/chunks/vendor.HYaJUzF5.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
