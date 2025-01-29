import Array "mo:base/Array";
import Text "mo:base/Text";
import Blob "mo:base/Blob";

module {

  public func isUsernameValid(username: Text) : Bool {
    if (Text.size(username) < 3 or Text.size(username) > 20) {
      return false;
    };

    let isAlphanumeric = func(s : Text) : Bool {
      let chars = Text.toIter(s);
      for (c in chars) {
        if (not ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or (c == ' '))) {
          return false;
        };
      };
      return true;
    };

    if (not isAlphanumeric(username)) {
      return false;
    };
    return true;
  };

  public func isProfilePictureValid(profilePicture : Blob) : Bool {
    let sizeInKB = Array.size(Blob.toArray(profilePicture)) / 1024;
    return (sizeInKB > 0 and sizeInKB <= 500);
  };

};
