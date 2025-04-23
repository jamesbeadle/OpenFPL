<script>
  import OpenFplIcon from "$lib/icons/OpenFPLIcon.svelte";
</script>

<svelte:head>
  <link rel="preload" href="/github.png" as="image" />
  <link rel="preload" href="/openchat.png" as="image" />
  <link rel="preload" href="/twitter.png" as="image" />
</svelte:head>

<footer class="py-3 text-white bg-gray-900">
  <div
    class="container flex flex-col items-start justify-between mx-1 text-xs xs:mx-2 md:mx-auto md:flex-row md:items-center"
  >
    <div class="flex-1">
      <div class="flex justify-start">
        <div class="flex flex-row pl-4">
          <a
            href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
            target="_blank"
            rel="noopener noreferrer"
          >
            <img
              src="/openchat.png"
              class="w-auto h-4 mb-2 mr-2"
              alt="OpenChat"
            />
          </a>
          <a
            href="https://x.com/OpenFPL_DAO"
            target="_blank"
            rel="noopener noreferrer"
          >
            <img src="/twitter.png" class="w-auto h-4 mb-2 mr-2" alt="X" />
          </a>
          <a
            href="https://github.com/jamesbeadle/OpenFPL"
            target="_blank"
            rel="noopener noreferrer"
          >
            <img src="/github.png" class="w-auto h-4 mb-2" alt="GitHub" />
          </a>
        </div>
      </div>
      <div class="flex justify-start">
        <div class="flex flex-col pl-4 md:flex-row md:space-x-2">
          <a href="/whitepaper" class="hover:text-gray-300">Whitepaper</a>
          <span class="hidden md:flex">|</span>
          <a
            href="/gameplay-rules"
            class="hover:text-gray-300 md:hidden lg:block">Gameplay Rules</a
          >
          <a
            href="/gameplay-rules"
            class="hidden hover:text-gray-300 md:block lg:hidden">Rules</a
          >
          <span class="hidden md:flex">|</span>
          <a href="/terms" class="hover:text-gray-300">Terms & Conditions</a>
        </div>
      </div>
    </div>
    <div class="flex-0">
      <a href="/">
        <b class="flex items-center px-4 mt-2 md:mt-0 md:px-10"
          ><OpenFplIcon currentColor='white' className="h-6 w-auto mr-2" />OpenFPL</b
        >
      </a>
    </div>
    <div class="flex-1">
      <div class="flex justify-end">
        <div class="px-4 mt-1 text-right md:px-0 md:mt-0 md:mr-4">
          <p>Developed by Waterway Labs</p>
        </div>
      </div>
    </div>
  </div>
</footer>
