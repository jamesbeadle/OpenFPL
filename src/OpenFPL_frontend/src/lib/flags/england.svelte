<script lang="ts">

	interface Props {
		size: string;
		role: string;
		ariaLabel: string;
  }
  let { size, role, ariaLabel }: Props = $props();
</script>

<svg
  xmlns="http://www.w3.org/2000/svg"
  viewBox="0 0 60 30"
  {role}
  aria-label={ariaLabel}
  class={$$props.class} 
  width={size}
  height={size}
  {...$$restProps}
>
  <rect width="60" height="30" fill="#ffffff" />
  <rect width="10" height="30" x="25" fill="#ce1126" />
  <rect width="60" height="10" y="10" fill="#ce1126" />
</svg>
