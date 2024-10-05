

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.uawC3ATq.js","_app/immutable/chunks/index.DQsxTc7K.js","_app/immutable/chunks/vendor.B-YlKLv-.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
