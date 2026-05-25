<script lang="ts">
	let { data } = $props();
	let { user } = $derived(data);
</script>

<svelte:head>
	<title>OpenFPL</title>
</svelte:head>

<main class="mx-auto max-w-3xl px-6 py-16">
	<h1 class="text-4xl font-bold tracking-tight">OpenFPL</h1>
	<p class="mt-4 text-lg text-slate-600">
		A free, open fantasy Premier League game. Pick 11 within £100M, captain one, climb the
		leaderboard.
	</p>

	<div class="mt-10 rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
		{#if user}
			<p class="text-slate-700">
				Signed in as <span class="font-medium">{user.email}</span>.
			</p>
			<a
				href="/app"
				class="mt-4 inline-block rounded-md bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-800"
			>
				Go to dashboard →
			</a>
		{:else}
			<p class="text-slate-700">Sign in with Google to create your team.</p>
			<a
				href="/login"
				class="mt-4 inline-block rounded-md bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-800"
			>
				Sign in →
			</a>
		{/if}
	</div>

	<p class="mt-12 text-sm text-slate-500">
		Foundation scaffold. See <a href="https://github.com/jamesbeadle/OpenFPL/blob/main/docs/SCOPE.md" class="underline">docs/SCOPE.md</a> for the full product spec.
	</p>
</main>
