module Types{
    
    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotAllowed;
        #DecodeError;
    };
    
    public type Profile = {
        principalName: Text;
        displayName: Text;
        wallet: Text;
        depositAddress: Blob;
        balance: Nat64;
    };
}
