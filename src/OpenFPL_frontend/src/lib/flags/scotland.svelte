<script>
  export let size = '24'; 
  export let role = 'img';
  export let ariaLabel = 'flag of Scotland'; 
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
  <!-- Blue background -->
  <rect width="60" height="30" fill="#005eb6" />
  <!-- White saltire (diagonal cross) -->
  <polygon points="0,0 60,30 60,0 0,30" fill="#ffffff" />
  <polygon points="0,3 3,0 60,27 57,30" fill="#005eb6" />
  <polygon points="57,0 60,3 3,30 0,27" fill="#005eb6" />
</svg>
