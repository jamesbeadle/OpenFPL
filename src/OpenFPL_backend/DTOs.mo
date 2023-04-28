module DTOs {
    
    public type ProfileDTO = {
        principalName: Text;
        depositAddress: Blob;
        displayName: Text;
        walletAddress: Text;
    };

    public type AccountBalanceDTO = {
        accountBalance: Nat64;
    };
    
}
