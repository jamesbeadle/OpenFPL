<script>
  export let size = '24'; 
  export let role = 'img';
  export let ariaLabel = 'flag of England'; 
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
