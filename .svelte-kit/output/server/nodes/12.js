

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12._F3-8x8l.js","_app/immutable/chunks/index.Li0AwpJS.js","_app/immutable/chunks/vendor.t_-gKxFP.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
