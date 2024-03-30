import T "types";
import C "const";
import M "methods";
import A "address";

module {

  public let Address = A;

  public let { transfer; balance } = M;

  public type Memo = T.Memo;
  
  public type Address = T.Address;
    
  public type Subaccount = T.Subaccount;

  public type AccountIdentifier = T.AccountIdentifier;

  public type Tokens = T.Tokens;

  public let { Interface } = T;

  public module Subaccount = {
    
    public let { nat_to_subaccount = from_nat } = Address;

  };

  public module AccountIdentifier = {

    public let { identifier_from_principal = from_principal } = Address;

    public let { from_identifier = to_address } = Address;

  };

};