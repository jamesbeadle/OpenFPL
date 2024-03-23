
module {

  public type State = { var nonce : Nat };

  public func init(): State = { var nonce = 0 : Nat };

}