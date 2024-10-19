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
<rect width="60" height="30" fill="#005eb6"/>
<polygon points="0,0 60,30 60,0 0,30" fill="#ffffff"/>
<polygon points="0,2.5 2.5,0 30,13.75 57.5,0 60,2.5 46.25,15 60,27.5 57.5,30 30,16.25 2.5,30 0,27.5 13.75,15" fill="#005eb6"/>
</svg>
