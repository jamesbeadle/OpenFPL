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
	() => import('./nodes/17'),
	() => import('./nodes/18')
];

export const server_loads = [];

export const dictionary = {
		"/": [2],
		"/add-fixture-data": [3],
		"/add-proposal": [4],
		"/admin": [5],
		"/clubs": [7],
		"/club": [6],
		"/cycles": [8],
		"/gameplay-rules": [9],
		"/governance": [10],
		"/league": [11],
		"/manager": [12],
		"/pick-team": [13],
		"/player": [14],
		"/profile": [15],
		"/status": [16],
		"/terms": [17],
		"/whitepaper": [18]
	};

export const hooks = {
	handleError: (({ error }) => { console.error(error) }),

	reroute: (() => {})
};

export { default as root } from '../root.svelte';