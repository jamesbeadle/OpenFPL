export const manifest = (() => {
function __memo(fn) {
	let value;
	return () => value ??= (value = fn());
}

return {
	appDir: "_app",
	appPath: "_app",
	assets: new Set(["background.jpg","discord.png","discord.png:Zone.Identifier","favicon.png","github.png","github.png:Zone.Identifier","openchat.png","openchat.png:Zone.Identifier","poppins-regular-webfont.woff2","telegram.png","telegram.png:Zone.Identifier","twitter.png","twitter.png:Zone.Identifier"]),
	mimeTypes: {".jpg":"image/jpeg",".png":"image/png",".woff2":"font/woff2"},
	_: {
		client: {"start":"_app/immutable/entry/start.d27fa20a.js","app":"_app/immutable/entry/app.763ffcc0.js","imports":["_app/immutable/entry/start.d27fa20a.js","_app/immutable/chunks/index.e590a2b1.js","_app/immutable/chunks/singletons.2158a4f8.js","_app/immutable/entry/app.763ffcc0.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/index.e590a2b1.js"],"stylesheets":[],"fonts":[]},
		nodes: [
			__memo(() => import('./nodes/0.js')),
			__memo(() => import('./nodes/1.js')),
			__memo(() => import('./nodes/2.js')),
			__memo(() => import('./nodes/3.js')),
			__memo(() => import('./nodes/4.js')),
			__memo(() => import('./nodes/5.js'))
		],
		routes: [
			{
				id: "/",
				pattern: /^\/$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 2 },
				endpoint: null
			},
			{
				id: "/governance",
				pattern: /^\/governance\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 3 },
				endpoint: null
			},
			{
				id: "/pick-team",
				pattern: /^\/pick-team\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 4 },
				endpoint: null
			},
			{
				id: "/profile",
				pattern: /^\/profile\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 5 },
				endpoint: null
			}
		],
		matchers: async () => {
			
			return {  };
		}
	}
}
})();
