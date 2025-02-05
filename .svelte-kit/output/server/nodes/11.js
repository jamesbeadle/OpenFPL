

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.OdvoqedM.js","_app/immutable/chunks/index.DrWzKATK.js","_app/immutable/chunks/vendor.mDcLQhi8.js"];
export const stylesheets = ["_app/immutable/assets/index.3x8TuEHK.css"];
export const fonts = [];
