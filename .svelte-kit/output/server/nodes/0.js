

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.uwqv4Vez.js","_app/immutable/chunks/index.qylRMdwI.js","_app/immutable/chunks/vendor.Dea5ReM1.js"];
export const stylesheets = ["_app/immutable/assets/index.AeUbcvqf.css"];
export const fonts = [];
