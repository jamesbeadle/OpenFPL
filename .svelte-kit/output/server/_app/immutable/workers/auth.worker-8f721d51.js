(function(authClient2, identity2) {
  "use strict";
  BigInt(
    60 * 60 * 1e3 * 1e3 * 1e3 * 24 * 14
  );
  const AUTH_TIMER_INTERVAL = 1e3;
  const createAuthClient = () => authClient2.AuthClient.create({
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
    const authClient3 = await createAuthClient();
    return authClient3.isAuthenticated();
  };
  const checkDelegationChain = async () => {
    const idbStorage = new authClient2.IdbStorage();
    const delegationChain = await idbStorage.get(
      authClient2.KEY_STORAGE_DELEGATION
    );
    const delegation = delegationChain !== null ? identity2.DelegationChain.fromJSON(delegationChain) : null;
    return {
      valid: delegation !== null && identity2.isDelegationValid(delegation),
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
})(authClient, identity);
