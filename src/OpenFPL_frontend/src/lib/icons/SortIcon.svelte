<script lang="ts">
    interface Props {
        className: string;
        fill1: string;
        fill2: string;
    }
    let { className }: Props = $props();
</script>

<svg 
    class={className}
    aria-hidden="true"
    viewBox="0 0 8 17" 
    xmlns="http://www.w3.org/2000/svg"
>
    <path d="M0 5.55667L0.943 6.5L4.00133 3.387L7.057 6.5L8 5.55667L4.00133 1.5L0 5.55667Z" fill={fill1}/>
    <path d="M0 11.4433L0.943 10.5L4.00133 13.613L7.057 10.5L8 11.4433L4.00133 15.5L0 11.4433Z" fill={fill2}/>
</svg>