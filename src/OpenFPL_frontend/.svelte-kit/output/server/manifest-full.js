export const manifest = (() => {
  function __memo(fn) {
    let value;
    return () => (value ??= value = fn());
  }

  return {
    appDir: "_app",
    appPath: "_app",
    assets: new Set(["favicon.png"]),
    mimeTypes: { ".png": "image/png" },
    _: {
      client: {
        start: "_app/immutable/entry/start.a7d9ae63.js",
        app: "_app/immutable/entry/app.41dc0f1e.js",
        imports: [
          "_app/immutable/entry/start.a7d9ae63.js",
          "_app/immutable/chunks/scheduler.e108d1fd.js",
          "_app/immutable/chunks/singletons.e25685a9.js",
          "_app/immutable/entry/app.41dc0f1e.js",
          "_app/immutable/chunks/scheduler.e108d1fd.js",
          "_app/immutable/chunks/index.a21d6cee.js",
        ],
        stylesheets: [],
        fonts: [],
      },
      nodes: [
        __memo(() => import("./nodes/0.js")),
        __memo(() => import("./nodes/1.js")),
        __memo(() => import("./nodes/2.js")),
      ],
      routes: [
        {
          id: "/",
          pattern: /^\/$/,
          params: [],
          page: { layouts: [0], errors: [1], leaf: 2 },
          endpoint: null,
        },
      ],
      matchers: async () => {
        return {};
      },
    },
  };
})();
