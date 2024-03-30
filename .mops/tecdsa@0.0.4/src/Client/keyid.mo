import C "const";
import T "types";

module {

  let { TAG_SECP256K1 = SECP256K1 } = C;
  let { TAG = { KEY_1 = SECP256K1_TAG_KEY_1 }; ID = { KEY_1 = SECP256K1_ID_KEY_1 } } = C.SECP256K1;
  let { TAG = { TEST_KEY_1 = SECP256K1_TAG_TEST_KEY_1 }; ID = { TEST_KEY_1 = SECP256K1_ID_TEST_KEY_1 } } = C.SECP256K1;
  let { TAG = { DFX_TEST_KEY = SECP256K1_TAG_DFX_TEST_KEY }; ID = { DFX_TEST_KEY = SECP256K1_ID_DFX_TEST_KEY } } = C.SECP256K1;


  public func fromTag(tag: T.Tag): ?T.KeyId {
    if ( tag.0 == SECP256K1 ){
      if ( tag.1 == SECP256K1_TAG_KEY_1 ) ?{ curve = C.SECP256K1.CURVE; name = SECP256K1_ID_KEY_1 }
      else if ( tag.1 == SECP256K1_TAG_TEST_KEY_1 ) ?{ curve = C.SECP256K1.CURVE; name = SECP256K1_ID_TEST_KEY_1 }
      else if ( tag.1 == SECP256K1_TAG_DFX_TEST_KEY ) ?{ curve = C.SECP256K1.CURVE; name = SECP256K1_ID_DFX_TEST_KEY }
      else null
    } else null
  };


  public func toTag(key_id: T.KeyId): ?T.Tag {
    switch( key_id.curve ){
      case( #secp256k1 ){
        if ( key_id.name == SECP256K1_ID_KEY_1 ) ?(SECP256K1, SECP256K1_TAG_KEY_1)
        else if ( key_id.name == SECP256K1_ID_TEST_KEY_1 ) ?(SECP256K1, SECP256K1_TAG_TEST_KEY_1)
        else if ( key_id.name == SECP256K1_ID_DFX_TEST_KEY ) ?(SECP256K1, SECP256K1_TAG_DFX_TEST_KEY)
        else null;
      }
    }
  };

};