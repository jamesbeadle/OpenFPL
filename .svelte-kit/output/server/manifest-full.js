export const manifest = (() => {
function __memo(fn) {
	let value;
	return () => value ??= (value = fn());
}

return {
	appDir: "_app",
	appPath: "_app",
	assets: new Set(["FPLCoin.png","ICPCoin.png","Manrope-Regular.woff2","background.jpg","board.png","brace-bonus.png","captain-fantastic.png","ckBTCCoin.png","ckETHCoin.png","countrymen.png","discord.png","favicon.png","github.png","goal-getter.png","hat-trick-hero.png","no-entry.png","openchat.png","pass-master.png","pitch.png","poppins-regular-webfont.woff2","profile_placeholder.png","prospects.png","safe-hands.png","team-boost.png","telegram.png","twitter.png"]),
	mimeTypes: {".png":"image/png",".woff2":"font/woff2",".jpg":"image/jpeg"},
	_: {
		client: {"start":"_app/immutable/entry/start.fc2b2ebd.js","app":"_app/immutable/entry/app.b3be0bed.js","imports":["_app/immutable/entry/start.fc2b2ebd.js","_app/immutable/chunks/index.aa733771.js","_app/immutable/chunks/singletons.1877a767.js","_app/immutable/entry/app.b3be0bed.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/index.aa733771.js"],"stylesheets":[],"fonts":[]},
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
