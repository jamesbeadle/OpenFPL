
  

  <div class="local-spinner" />

  <style>
   .local-spinner {
      border: 5px solid rgba(255, 255, 255, 0.3);
      border-top: 5px solid white;
      border-radius: 50%;
      width: 50px;
      height: 50px;
      position: relative; /* Change from absolute to relative */
      margin: 0 auto; /* Centers the spinner horizontally in a flex or block layout */
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
  