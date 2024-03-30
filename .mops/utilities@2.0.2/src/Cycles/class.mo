import { toText = principalToText } "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import Error "mo:base/Error";
import { tabulate; filter; find } "mo:base/Array";
import Buffer "mo:base/Buffer";
import List "mo:base/List";
import State "state";
import T "types";

module {

  public func constructor(state_: T.State): T.Cycles = object {

    let state = State.unwrap( state_ );

    public func balance() : Nat { Cycles.balance() };

    public func accept<system>() : Nat { Cycles.accept( Cycles.available() ) };

    public func set_canister_id(p: Principal): () { state.canister_id := p };

    public func is_admin(p: Principal) : Bool = switch(
      find<Principal>(state.admins, func(x) = x== p) ){
        case( ?some ) true; case null false;
    };

    public func release(amt: Nat) : () {
      if ( state.reserved >= amt ) state.reserved -= amt;
    };

    public func reserve(amt: Nat) : Bool {
      let bal : Nat = Cycles.balance();
      let reserved : Nat = state.reserved + amt;
      if ( bal <= reserved ) false
      else if ( (bal - reserved) < state.minimum_balance ) false
      else {
        state.reserved := reserved;
        true
      }
    };

    public func transfer(request: T.TransferRequest): async* T.Return<Nat> {

      let amt_avail = Cycles.balance();
      let trapped = Buffer.Buffer<Text>(0);
      let async_buf = Buffer.Buffer<(Principal, async Nat)>(state.clients.size());

      let amt_req = List.foldLeft<(Any, Nat), Nat>(
        request.status, 0, func(x, (_, y)): Nat { if ( y >= request.max_cycles ) 0 else request.max_cycles - y }
      );

      let amt_rsrvd = state.reserved + amt_req;

      if ( amt_rsrvd >= amt_avail or (amt_avail - amt_rsrvd) <= state.minimum_balance )
        
        return { response = 0; trapped = [] }
      
      else {

        state.reserved := amt_rsrvd;
      
        for ( (client, balance) in List.toIter<(Principal, Nat)>(request.status) ){
          
          if ( balance < request.max_cycles ){
          
            let address = principalToText( client );
            let interface : T.Interface = actor( address );
            Cycles.add( request.max_cycles - balance );
            async_buf.add((client, interface.cycles_accept()));

          }

        };

        var amt_sent : Nat = 0;
      
        for ( (client, async_response) in async_buf.vals() ){
          
          try amt_sent += await async_response catch (e) trapped.add(
            principalToText(client) # ": " # Error.message(e) # "\n"
          )

        };
      
        state.reserved -= amt_req;
      
        return {response = amt_sent; trapped = Buffer.toArray<Text>( trapped ) }

      }
    
    };

    public func status(request : T.StatusRequest) : async* T.ReturnStatus {

      let trapped = Buffer.Buffer<Text>(0);
      var status_list = List.nil<T.Status>();
      var queue = List.nil<(Principal, async T.ReturnStatus)>();
      
      for ( client in state.clients.vals() ){
      
        let interface : T.Interface = actor(principalToText( client ));
      
        queue := List.push<(Principal, async T.ReturnStatus)>((client, interface.cycles_request_status({status = null})), queue);
      
      };
      
      for ( (client, async_response) in List.toIter( queue ) ){
      
        try {
      
          let ret = await async_response;
          trapped.append( Buffer.fromArray( ret.trapped ) );
          status_list := List.push<T.Status>(ret.response.status, status_list)
      
        } catch (e) trapped.add(
      
          principalToText(client) # ": " # Error.message(e) # "\n"
      
        )
      
      };
      
      var status = List.flatten<(Principal, Nat)>( status_list );

      status := List.push<(Principal, Nat)>((state.canister_id, Cycles.balance()), status);

      return { response = { status = status }; trapped = Buffer.toArray<Text>( trapped ) } 
      
    };

    public func change(request: T.ChangeRequest) : async* T.Return<()> {
      
      let client_args = Buffer.Buffer<T.ChangeRequestArg>(0);
      
      for ( arg in request.args.vals() ){
      
        switch arg {
      
          case( #RemoveClient prin ) state.clients := filter<Principal>(state.clients, func(p) = p != prin);
      
          case( #AddClient prin ){
      
            let size : Nat = state.clients.size();
      
            state.clients := tabulate<Principal>(size, func(i){
      
              if ( i >= size ) prin else state.clients[i]
      
            });
      
          };
      
          case( #RemoveAdmin prin ){
      
            client_args.add(#RemoveAdmin(prin));
      
            state.admins := filter<Principal>(state.admins, func(p) = p != prin);
      
          };
      
          case( #AddAdmin prin ){
      
            client_args.add(#AddAdmin(prin));
      
            let size : Nat = state.admins.size();
      
            state.admins := tabulate<Principal>(size, func(i){
      
              if ( i >= size ) prin else state.admins[i]
      
            });
      
          }
      
        }
      
      };
      
      if ( client_args.size() > 0 ){
      
        let trapped = Buffer.Buffer<Text>(0);
        
        var queue = List.nil<(Principal, async T.Return<()>)>();
        
        let client_request : T.ChangeRequest = { args = Buffer.toArray<T.ChangeRequestArg>( client_args ) };
      
        for ( client in state.clients.vals() ){
        
          let interface : T.Interface = actor( principalToText( client ) );
        
          queue := List.push<(Principal, async T.Return<()>)>((client, interface.cycles_request_change(client_request)), queue);
        
        };
      
        for ( (client, async_response) in List.toIter( queue ) ){
        
          try {
        
            let resp = await async_response;
            trapped.append( Buffer.fromArray( resp.trapped ) );
        
          } catch (e) trapped.add(
        
            principalToText(client) # ": " # Error.message(e) # "\n"
        
          )
        };
        
        return { response = (); trapped = Buffer.toArray<Text>( trapped ) }
      
      } else {
      
        return { response = (); trapped = [] }
      
      }

    }

  };

};