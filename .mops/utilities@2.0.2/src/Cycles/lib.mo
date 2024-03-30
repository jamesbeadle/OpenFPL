import T "types";
import C "class";
import S "state";

module {

  public type State = T.State;

  public let State = S;

  public type Cycles = T.Cycles;

  public type Interface = T.Interface;

  public let { constructor = Cycles } = C;

  public type Status = T.Status;

  public type StatusResponse = T.StatusResponse;

  public type StatusRequest = T.StatusRequest;

  public type TransferRequest = T.TransferRequest;

  public type ChangeRequest = T.ChangeRequest;

  public type Return<T> = T.Return<T>;

  public type ReturnStatus = T.ReturnStatus;

  public type ReturnAmount = T.ReturnAmount;

  public type ChangeRequestArg = T.ChangeRequestArg;
  
}