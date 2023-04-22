import { OpenFPL_backend } from "../../declarations/OpenFPL_backend";

document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const button = e.target.querySelector("button");

  const name = document.getElementById("name").value.toString();

  button.setAttribute("disabled", true);

  // Interact with foo actor, calling the greet method
  const greeting = await OpenFPL_backend.getTokenName();

  button.removeAttribute("disabled");

  document.getElementById("greeting").innerText = greeting;

  return false;
});
