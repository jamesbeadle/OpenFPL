import Client "../Client";

module {

  public type Seed = Blob;
  public type SeedPhrase = [Text];
  public type Client = Client.Client;
  public type KeyId = Client.KeyId;
  public type Params = Client.Params;
  public type Message = Client.Message;
  public type Signature = Client.Signature;
  public type AsyncReturn<T> = Client.AsyncReturn<T>;
  public type PublicKey = Client.PublicKey;

};