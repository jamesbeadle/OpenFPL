<script>
  export let size = '24'; 
  export let role = 'img';
  export let ariaLabel = 'flag of Wales'; 
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
<rect width="60" height="15" y="15" fill="#006847"/>
  <rect width="60" height="15" fill="#ffffff"/>
  <path d="M23 11l2.5 2l.5 -2.5h2l1 -1.5l.5 1.5h1.5l-.5 -1.5l1.5 -1.5l-2 -2.5h-2l-1.5 1.5l-1 -1l-.5 1.5h-1.5v-1.5l-1.5 2h-2v1.5l-1.5 -1.5l-1 1.5l1.5 1.5v2l-1.5 1.5l1 2.5h2l-.5 -2.5l2.5 -1z" fill="#da291c"/>
  <path d="M30 15l2.5 1l1 -1.5v-2h1.5l-1 -1.5l2 -1l-2.5 -1h-1.5l-1 1.5l-1 -1h-2v-1l-2.5 1.5l-.5 2l1.5 1l-.5 2.5h2.5z" fill="#da291c"/>
  <path d="M22 20h2l1 -1h-1.5v-1h-2v2h1.5z" fill="#da291c"/>
  <path d="M27 21h1.5v-2h-2l.5 -1l-1.5 1v1.5l2 1.5l-.5 1.5h2l.5 -1l-2.5 -1.5z" fill="#da291c"/>
  <path d="M33 20h1.5v-2.5l-1.5 -1.5h-1l.5 1.5l1 1z" fill="#da291c"/>
</svg>
