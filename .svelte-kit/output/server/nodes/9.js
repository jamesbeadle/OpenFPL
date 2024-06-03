

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.b8SRkGPB.js","_app/immutable/chunks/index.Li0AwpJS.js","_app/immutable/chunks/vendor.t_-gKxFP.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
