<script lang="ts">
  import LoadingDots from "./loading-dots.svelte";
  export let message: string | undefined = undefined;
</script>

<div class="spinner-container">
  <div class="local-spinner"></div>
  {#if message}
    <div class="message-row">
      <p class="loading-text">{message}</p>
      <div class="dots-container">
        <LoadingDots />
      </div>
    </div>
  {/if}
</div>

<style>
  .spinner-container {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1rem;
  }

  .message-row {
    display: flex;
    align-items: center;
    gap: 0.25rem;
    margin-top: 1rem;
  }

  .loading-text {
    color: white;
    font-size: 1.125rem;
    text-align: center;
  }

  .dots-container { 
    color: white;
    font-size: 1.125rem;
    display: flex;
    align-items: center;
    padding-top: 2px;
  }

  .local-spinner {
    border: 5px solid rgba(255, 255, 255, 0.3);
    border-top: 5px solid white;
    border-radius: 50%;
    width: 50px;
    height: 50px;
    animation: spin 1s linear infinite;
  }

  @keyframes spin {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }
</style>