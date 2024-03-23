import Debug "mo:base/Debug";
import {expect = _expect; fail = _fail} "./expect";
import {expectAsync = _expectAsync} "./expect/async";

module {
	public func test(name : Text, fn : () -> async ()) : async () {
		Debug.print("mops:1:start " # name);
		await fn();
		Debug.print("mops:1:end " # name);
	};

	public func suite(name : Text, fn : () -> async ()) : async () {
		await test(name, fn);
	};

	public func skip(name : Text, fn : () -> async ()) : async () {
		Debug.print("mops:1:skip " # name);
	};

	public let expect = {
		_expect with
		call = _expectAsync.call;
	};
	public let fail = _fail;
};