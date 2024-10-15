export { matchers } from './matchers.js';

export const nodes = [
	() => import('./nodes/0'),
	() => import('./nodes/1'),
	() => import('./nodes/2'),
	() => import('./nodes/3'),
	() => import('./nodes/4'),
	() => import('./nodes/5'),
	() => import('./nodes/6'),
	() => import('./nodes/7'),
	() => import('./nodes/8'),
	() => import('./nodes/9'),
	() => import('./nodes/10'),
	() => import('./nodes/11'),
	() => import('./nodes/12'),
	() => import('./nodes/13'),
	() => import('./nodes/14'),
	() => import('./nodes/15'),
	() => import('./nodes/16'),
	() => import('./nodes/17')
];

export const server_loads = [];

export const dictionary = {
		"/": [2],
		"/add-fixture-data": [3],
		"/add-proposal": [4],
		"/admin": [5],
		"/clubs": [7],
		"/club": [6],
		"/gameplay-rules": [8],
		"/governance": [9],
		"/leagues": [11],
		"/league": [10],
		"/manager": [12],
		"/pick-team": [13],
		"/player": [14],
		"/profile": [15],
		"/terms": [16],
		"/whitepaper": [17]
	};

export const hooks = {
	handleError: (({ error }) => { console.error(error) }),

	reroute: (() => {})
};

export { default as root } from '../root.svelte';