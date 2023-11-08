<script>
  import '../index.scss';
  import { createActor, canisterId } from '../declarations/backend';
  import logo from '../assets/logo2.svg'

  const isLocal = process.env.DFX_NETWORK === 'local';
  const host = isLocal ? 'http://localhost:4943' : 'https://icp-api.io';
  const backend = createActor(canisterId, { agentOptions: { host } });
  
  let greeting = "";

  function onSubmit(event) {
    event.preventDefault();
    const name = event.target.name.value;
    backend.greet(name).then((response) => {
      greeting = response;
    });
    return false;
  }

</script>

<main>
  <img src={logo} alt="DFINITY logo" />
      <br />
      <br />
      <form action="#" on:submit={onSubmit}>
        <label for="name">Enter your name: &nbsp;</label>
        <input id="name" alt="Name" type="text" />
        <button type="submit">Click Me!</button>
      </form>
      <section id="greeting">{greeting}</section>
</main>
