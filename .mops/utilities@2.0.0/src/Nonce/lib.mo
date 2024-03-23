import C "Class";
import S "State";

module {

  public type Nonce = C.Nonce;
  
  public type State = S.State;
  
  public let { Nonce } = C;

  public let State = S;

}