

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.70470a3f.js","_app/immutable/chunks/index.aa733771.js","_app/immutable/chunks/TeamService.7d253bbd.js","_app/immutable/chunks/Layout.79823031.js","_app/immutable/chunks/stores.897bcf18.js","_app/immutable/chunks/singletons.1877a767.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.679ed808.css"];
export const fonts = [];
