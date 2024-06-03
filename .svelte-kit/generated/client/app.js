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
		"/clubs": [6],
		"/club": [5],
		"/cycles": [7],
		"/gameplay-rules": [8],
		"/governance": [9],
		"/league": [10],
		"/manager": [11],
		"/my-leagues": [12],
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