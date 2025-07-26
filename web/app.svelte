<script lang="ts">
  import { onDestroy, onMount } from "svelte";

  onDestroy(() => {
  });

  onMount(async () => {
  });

</script>

<div class="container mx-auto flex sm:w-full">
  <div class="flex-1">
    <h1 class="text-2xl font-bold">Welcome to the Svelte App</h1>
    <p class="mt-4">This is a simple Svelte application.</p>
  </div>
  <div class="flex-1">
    <p class="text-gray-600">You can add your content here.</p>
  </div>
</div>

<style lang="postcss">
  @reference "tailwindcss";

  :global(body) {
    background: white;
  }
</style>

