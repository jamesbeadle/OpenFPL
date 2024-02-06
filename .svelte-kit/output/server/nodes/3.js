

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3._wushF7y.js","_app/immutable/chunks/index.yUiKS0Mp.js","_app/immutable/chunks/vendor.HYaJUzF5.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
