
<script>
  export let size = '24'; 
  export let role = 'img';
  export let ariaLabel = 'flag of Northern Ireland'; 
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
  <rect width="60" height="30" fill="#ffffff"/>
  <rect width="10" height="30" x="25" fill="#ce1126"/>
  <rect width="60" height="10" y="10" fill="#ce1126"/>
  <polygon points="27.5,7.5 32.5,7.5 32.5,12.5 35,12.5 35,17.5 32.5,17.5 32.5,22.5 27.5,22.5 27.5,17.5 25,17.5 25,12.5 27.5,12.5" fill="#ffffff"/>
  <polygon points="28,9.5 32,9.5 32,12.5 34,12.5 34,17.5 32,17.5 32,20.5 28,20.5 28,17.5 26,17.5 26,12.5 28,12.5" fill="#ce1126"/>
  <path d="M 30 13 a 1.5 1.5 0 1 0 0 6 a 1.5 1.5 0 1 0 0 -6" fill="#ffffff"/>
  <polygon points="29.25,15 30.75,15 30.75,16.5 29.25,16.5" fill="#ce1126"/>
  <polygon points="29.75,17 30.25,17 30.25,17.5 29.75,17.5" fill="#ce1126"/>
  <path d="M30 7l2 0l0 2l2 0l0 2l-2 0l0 2l-2 0l0 -2l-2 0l0 -2l2 0l0 -2Z" fill="#ffd700"/>
</svg>
