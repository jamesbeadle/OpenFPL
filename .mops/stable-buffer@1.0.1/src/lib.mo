import C "class";
import C2 "const";
import T "types";
import S "state";

module {

  public let State = S;

  public type State = T.State;

  public let { StableBuffer } = C;

  public type StableBuffer = T.StableBuffer;

  public let { MEMORY_EXHAUSTED; PAGE_SIZE } = C2;

  public type Return<T> = T.Return<T>;

  public type Error = T.Error;

}