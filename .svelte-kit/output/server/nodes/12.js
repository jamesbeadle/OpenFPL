

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.TwQ8J00B.js","_app/immutable/chunks/index.FEX7Z5EQ.js","_app/immutable/chunks/vendor.o27uGtKn.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
