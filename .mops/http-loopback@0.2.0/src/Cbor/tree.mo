import { toArray = bufferToArray; fromArray = bufferFromArray } "mo:base/Buffer";
import { fromArray = blobFromArray } "mo:base/Blob";
import { trap; print } "mo:base/Debug";
import T "types";

module {

  let EMPTY   : Nat64 = 0;
  let FORK    : Nat64 = 1; 
  let LABELED : Nat64 = 2;
  let LEAF    : Nat64 = 3;
  let PRUNED  : Nat64 = 4;

  public class HashTree(tree: T.Tree) = {

    public func lookup(path: T.Path) : ?Blob = lookup_path(path, tree, 0, path.size());

    func lookup_path(path: T.Path, tree: T.Tree, offset: Nat, size: Nat): ?Blob {
      let #majorType0( tag ) = tree[0] else { return null };
      if ( size == 0 ){
        if ( tag == LEAF ){
          let #majorType2( bytes ) = tree[1] else { return null };
          return ?blobFromArray( bytes )
        } 
        else return null;
      };
      switch( find_label(path[offset], flatten_forks(tree)) ){
        case( ?t ) lookup_path(path, t, offset+1, size-1);
        case null null
      }
    };

    func flatten_forks(t: T.Tree): [T.Tree] {
      let #majorType0( tag ) = t[0] else { return [] };
      if( tag == EMPTY ) []
      else if ( tag == FORK ){
        let #majorType4( l_val ) = t[1] else { return [] };
        let #majorType4( r_val ) = t[2] else { return [] };
        let buffer = bufferFromArray<T.Tree>( flatten_forks( l_val ) );
        buffer.append( bufferFromArray<T.Tree>( flatten_forks( r_val ) ) );
        bufferToArray<T.Tree>( buffer )
      }
      else [t]
    };

    func find_label(key: Blob, trees: [T.Tree]): ?T.Tree {
      if ( trees.size() == 0 ) return null;
      for ( tree in trees.vals() ){
        let #majorType0( tag ) = tree[0] else { return null };
        if ( tag == LABELED ){
          let #majorType2( bytes ) = tree[1] else { return null };
          let label_ : Blob = blobFromArray( bytes );
          if ( label_ == key ){
            let #majorType4( labeled_tree ) = tree[2] else { return null };
            return ?labeled_tree
          }
        }
      };
      null
    };
  
  };

};