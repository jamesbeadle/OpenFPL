<script>

    import OpenFplIcon from "$lib/icons/OpenFPLIcon.svelte";

</script>

<footer class="bg-gray-900 text-white py-3">
  <div class="container mx-auto flex items-center justify-between text-xs">
    <div class="flex-1">
      <div class="flex justify-start">
        <div class="flex space-x-2 pl-4">
          <a href="/whitepaper" class="hover:text-gray-300">Whitepaper</a>
          <span>|</span>
          <a href="/gameplay" class="hover:text-gray-300">Gameplay Rules</a>
          <span>|</span>
          <a href="/terms" class="hover:text-gray-300">Terms and Conditions</a>
          <span>|</span>
          <a href="/fixture-validation-list" class="hover:text-gray-300">Pre-SNS Fixture Validation</a>
        </div>
      </div>
    </div>
    <div class="flex-0">
      
    <b class="px-10 text-lg flex items-center">
      <OpenFplIcon className="h-8 w-auto mr-2" />OpenFPL</b>
    </div>
    <div class="flex-1">
      <div class="flex justify-end">
        <div class="text-right pr-4">
          <a href="https://juno.build" target='_blank' class="hover:text-gray-300">
            Sponsored By juno.build
          </a>
        </div>
      </div>
    </div>
  </div>
</footer>
