export const manifest = (() => {
function __memo(fn) {
	let value;
	return () => value ??= (value = fn());
}

return {
	appDir: "_app",
	appPath: "_app",
	assets: new Set([".DS_Store",".ic-assets.json",".well-known/ic-domains",".well-known/ii-alternative-origins","FPLCoin.png","ICPCoin.png","Manrope-Regular.woff2","adopt.png","adopt_filled.png","apple-touch-icon.png","background.jpg","board.png","brace-bonus.png","captain-fantastic.png","ckBTCCoin.png","ckETHCoin.png","discord.png","favicon.png","favicons/apple-touch-icon.png","favicons/browserconfig.xml","favicons/favicon-16x16.png","favicons/favicon-32x32.png","favicons/favicon.ico","favicons/icon-192x192.png","favicons/icon-512x512.png","favicons/mstile-150x150.png","favicons/safari-pinned-tab.svg","github.png","goal-getter.png","hat-trick-hero.png","manifest.webmanifest","meta-share.jpg","no-entry.png","one-nation.png","openchat.png","pass-master.png","pitch.png","poppins-regular-webfont.woff2","profile_placeholder.png","prospects.png","reject.png","reject_filled.png","safe-hands.png","team-boost.png","telegram.png","twitter.png"]),
	mimeTypes: {".json":"application/json",".png":"image/png",".woff2":"font/woff2",".jpg":"image/jpeg",".xml":"text/xml",".svg":"image/svg+xml",".webmanifest":"application/manifest+json"},
	_: {
		client: {"start":"_app/immutable/entry/start.D9EoOlaW.js","app":"_app/immutable/entry/app.6AhZ0hOa.js","imports":["_app/immutable/entry/start.D9EoOlaW.js","_app/immutable/chunks/index.DwX5I7HC.js","_app/immutable/chunks/vendor.EauaSV0L.js","_app/immutable/entry/app.6AhZ0hOa.js","_app/immutable/chunks/index.DwX5I7HC.js","_app/immutable/chunks/vendor.EauaSV0L.js"],"stylesheets":["_app/immutable/assets/index.Cd9SHXD-.css","_app/immutable/assets/index.Cd9SHXD-.css"],"fonts":[],"uses_env_dynamic_public":false},
		nodes: [
			__memo(() => import('./nodes/0.js')),
			__memo(() => import('./nodes/1.js')),
			__memo(() => import('./nodes/2.js')),
			__memo(() => import('./nodes/3.js')),
			__memo(() => import('./nodes/4.js')),
			__memo(() => import('./nodes/5.js')),
			__memo(() => import('./nodes/6.js')),
			__memo(() => import('./nodes/7.js')),
			__memo(() => import('./nodes/8.js')),
			__memo(() => import('./nodes/9.js')),
			__memo(() => import('./nodes/10.js')),
			__memo(() => import('./nodes/11.js')),
			__memo(() => import('./nodes/12.js'))
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
				id: "/canisters",
				pattern: /^\/canisters\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 3 },
				endpoint: null
			},
			{
				id: "/clubs",
				pattern: /^\/clubs\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 5 },
				endpoint: null
			},
			{
				id: "/club",
				pattern: /^\/club\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 4 },
				endpoint: null
			},
			{
				id: "/gameplay-rules",
				pattern: /^\/gameplay-rules\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 6 },
				endpoint: null
			},
			{
				id: "/manager",
				pattern: /^\/manager\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 7 },
				endpoint: null
			},
			{
				id: "/pick-team",
				pattern: /^\/pick-team\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 8 },
				endpoint: null
			},
			{
				id: "/player",
				pattern: /^\/player\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 9 },
				endpoint: null
			},
			{
				id: "/profile",
				pattern: /^\/profile\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 10 },
				endpoint: null
			},
			{
				id: "/terms",
				pattern: /^\/terms\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 11 },
				endpoint: null
			},
			{
				id: "/whitepaper",
				pattern: /^\/whitepaper\/?$/,
				params: [],
				page: { layouts: [0,], errors: [1,], leaf: 12 },
				endpoint: null
			}
		],
		matchers: async () => {
			
			return {  };
		},
		server_assets: {}
	}
}
})();
