export const manifest = (() => {
function __memo(fn) {
	let value;
	return () => value ??= (value = fn());
}

return {
	appDir: "_app",
	appPath: "_app",
	assets: new Set(["favicon.png"]),
	mimeTypes: {".png":"image/png"},
	_: {
		client: {"start":"_app/immutable/entry/start.ab3b7763.js","app":"_app/immutable/entry/app.f07dbe3f.js","imports":["_app/immutable/entry/start.ab3b7763.js","_app/immutable/chunks/index.6dba6488.js","_app/immutable/chunks/singletons.0757534f.js","_app/immutable/entry/app.f07dbe3f.js","_app/immutable/chunks/index.6dba6488.js"],"stylesheets":[],"fonts":[]},
		nodes: [
			__memo(() => import('./nodes/0.js')),
			__memo(() => import('./nodes/1.js')),
			__memo(() => import('./nodes/2.js'))
		],
		routes: [
			{
				id: "/",
				pattern: /^\/$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 2 },
				endpoint: null
			}
		],
		matchers: async () => {
			
			return {  };
		}
	}
}
})();
