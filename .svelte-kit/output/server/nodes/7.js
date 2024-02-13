

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.EEQURcmD.js","_app/immutable/chunks/index.Rt14yxHq.js","_app/immutable/chunks/vendor.PiJdbqeB.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
