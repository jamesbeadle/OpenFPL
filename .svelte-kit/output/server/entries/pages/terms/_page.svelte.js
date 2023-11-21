import { c as create_ssr_component, v as validate_component } from "../../../chunks/index2.js";
import { L as Layout } from "../../../chunks/Layout.js";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="bg-panel rounded-lg m-4 p-4"><h1 class="p-4 mx-1 text-2xl">OpenFPL DAO Terms &amp; Conditions</h1>
      <div class="bg-panel rounded-lg m-4"><div><p class="my-2">Last Updated: 13th October 2023</p>

          <p class="my-2">By accessing the OpenFPL website (&quot;Site&quot;) and participating in the
            OpenFPL Fantasy Football DAO (&quot;Service&quot;), you agree to comply with
            and be bound by the following Terms and Conditions.
          </p>

          <h2 class="text-xl font-bold">Acceptance of Terms</h2>
          <p class="my-2">You acknowledge that you have read, understood, and agree to be
            bound by these Terms. These Terms are subject to change by a DAO
            proposal and vote.
          </p>

          <h2 class="text-xl font-bold">Decentralised Structure</h2>
          <p class="my-2">OpenFPL operates as a decentralised autonomous organisation (DAO).
            As such, traditional legal and liability structures may not apply.
            Members and users are responsible for their own actions within the
            DAO framework.
          </p>

          <h2 class="text-xl font-bold">Eligibility</h2>
          <p class="my-2">The Service is open to users of all ages.</p>

          <h2 class="text-xl font-bold">User Conduct</h2>
          <p class="my-2">No Automation or Bots: You agree not to use bots, automated methods,
            or other non-human ways of interacting with the site.
          </p>

          <h2 class="text-xl font-bold">Username Policy</h2>
          <p class="my-2">You agree not to use usernames that are offensive, vulgar, or
            infringe on the rights of others.
          </p>

          <h2 class="text-xl font-bold">Changes to Terms</h2>
          <p class="my-2">These Terms and Conditions are subject to change. Amendments will be
            effective upon DAO members&#39; approval via proposal and vote.
          </p></div></div></div></div>`;
    }
  })}`;
});
export {
  Page as default
};
