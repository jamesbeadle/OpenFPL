

export const index = 14;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/14.L4iXmPLL.js","_app/immutable/chunks/index.yUiKS0Mp.js","_app/immutable/chunks/vendor.HYaJUzF5.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
