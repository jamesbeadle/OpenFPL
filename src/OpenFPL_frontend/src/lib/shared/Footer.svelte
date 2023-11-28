<script>
  import JunoIcon from "$lib/icons/JunoIcon.svelte";
  import OpenFplIcon from "$lib/icons/OpenFPLIcon.svelte";
</script>

<footer class="bg-gray-900 text-white py-3">
  <div
    class="container mx-auto flex flex-col sm:flex-row items-start sm:items-center justify-between text-xs"
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
              src="openchat.png"
              class="h-4 w-auto mb-2 mr-2"
              alt="OpenChat"
            />
          </a>
          <a
            href="https://twitter.com/OpenFPL_DAO"
            target="_blank"
            rel="noopener noreferrer"
          >
            <img src="twitter.png" class="h-4 w-auto mb-2 mr-2" alt="Twitter" />
          </a>
          <a
            href="https://t.co/WmOhFA8JUR"
            target="_blank"
            rel="noopener noreferrer"
          >
            <img src="discord.png" class="h-4 w-auto mb-2 mr-2" alt="Discord" />
          </a>
          <a
            href="https://t.co/vVkquMrdOu"
            target="_blank"
            rel="noopener noreferrer"
          >
            <img
              src="telegram.png"
              class="h-4 w-auto mb-2 mr-2"
              alt="Telegram"
            />
          </a>
          <a
            href="https://github.com/jamesbeadle/OpenFPL"
            target="_blank"
            rel="noopener noreferrer"
          >
            <img src="github.png" class="h-4 w-auto mb-2" alt="GitHub" />
          </a>
        </div>
      </div>
      <div class="flex justify-start">
        <div class="flex flex-col sm:flex-row sm:space-x-2 pl-4">
          <a href="/whitepaper" class="hover:text-gray-300">Whitepaper</a>
          <span class="hidden sm:flex">|</span>
          <a href="/gameplay-rules" class="hover:text-gray-300"
            >Gameplay Rules</a
          >
          <span class="hidden sm:flex">|</span>
          <a href="/terms" class="hover:text-gray-300">Terms & Conditions</a>
        </div>
      </div>
    </div>
    <div class="flex-0">
      <a href="/">
        <b class="px-4 mt-2 sm:mt-0 sm:px-10 flex items-center"
          ><OpenFplIcon className="h-6 w-auto mr-2" />OpenFPL</b
        >
      </a>
    </div>
    <div class="flex-1">
      <div class="flex justify-end">
        <div class="text-right px-4 sm:px-0 mt-1 sm:mt-0 md:mr-4">
          <a
            href="https://juno.build"
            target="_blank"
            class="hover:text-gray-300 flex items-center"
          >
            Sponsored By juno.build
            <JunoIcon className="h-8 w-auto ml-2" />
          </a>
        </div>
      </div>
    </div>
  </div>
</footer>
