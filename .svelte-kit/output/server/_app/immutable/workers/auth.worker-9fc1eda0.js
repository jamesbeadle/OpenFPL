import { AuthClient, IdbStorage, KEY_STORAGE_DELEGATION } from "@dfinity/auth-client";
import { DelegationChain, isDelegationValid } from "@dfinity/identity";
BigInt(
  60 * 60 * 1e3 * 1e3 * 1e3 * 24 * 14
);
const AUTH_TIMER_INTERVAL = 1e3;
const createAuthClient = () => AuthClient.create({
  idleOptions: {
    disableIdle: true,
    disableDefaultIdleCallback: true
  }
});
onmessage = ({ data }) => {
  const { msg } = data;
  switch (msg) {
    case "startIdleTimer":
      startIdleTimer();
      return;
    case "stopIdleTimer":
      stopIdleTimer();
      return;
  }
};
let timer = void 0;
const startIdleTimer = () => timer = setInterval(async () => await onIdleSignOut(), AUTH_TIMER_INTERVAL);
const stopIdleTimer = () => {
  if (!timer) {
    return;
  }
  clearInterval(timer);
  timer = void 0;
};
const onIdleSignOut = async () => {
  const [auth, chain] = await Promise.all([
    checkAuthentication(),
    checkDelegationChain()
  ]);
  if (auth && chain.valid && chain.delegation !== null) {
    emitExpirationTime(chain.delegation);
    return;
  }
  logout();
};
const checkAuthentication = async () => {
  const authClient = await createAuthClient();
  return authClient.isAuthenticated();
};
const checkDelegationChain = async () => {
  const idbStorage = new IdbStorage();
  const delegationChain = await idbStorage.get(
    KEY_STORAGE_DELEGATION
  );
  const delegation = delegationChain !== null ? DelegationChain.fromJSON(delegationChain) : null;
  return {
    valid: delegation !== null && isDelegationValid(delegation),
    delegation
  };
};
const logout = () => {
  stopIdleTimer();
  postMessage({ msg: "signOutIdleTimer" });
};
const emitExpirationTime = (delegation) => {
  const expirationTime = delegation.delegations[0]?.delegation.expiration;
  if (expirationTime === void 0) {
    return;
  }
  const authRemainingTime = new Date(Number(expirationTime / BigInt(1e6))).getTime() - Date.now();
  postMessage({
    msg: "delegationRemainingTime",
    data: {
      authRemainingTime
    }
  });
};
