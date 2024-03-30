

module {

  public let DEFAULT_MAX_RESPONSE_BYTES : Nat64 = 20_000_000;

  public module FEES {

    public module ID {

      public let PER_CALL : Text = "http_fee_per_call";

      public let PER_RESPONSE_BYTE : Text = "http_fee_per_response_byte";

      public let PER_REQUEST_BYTE : Text = "http_fee_per_request_byte";

    };

    public module APP {

      public let PER_CALL : Nat64 = 49_140_000;

      public let PER_RESPONSE_BYTE : Nat64 = 10_400;

      public let PER_REQUEST_BYTE : Nat64 = 5_200;

    };

    public module FIDUCIARY {

      public let PER_CALL : Nat64 = 171_360_000;

      public let PER_RESPONSE_BYTE : Nat64 = 27_200;

      public let PER_REQUEST_BYTE : Nat64 = 13_600;

    };

  };

}