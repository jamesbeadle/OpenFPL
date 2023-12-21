import T "../../types";
import DTOs "../../DTOs";
import List "mo:base/List";
import CanisterIds "../../CanisterIds";
import Time "mo:base/Time";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Timer "mo:base/Timer";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";
import Utilities "../../utilities";

module {
  public class TimerComposite(
    gameweekBeginExpiredCallback : () -> async (),
    gameKickOffExpiredCallback : () -> async (),
    gameCompletedExpiredCallback : () -> async (),
    loanExpiredCallback : () -> async (),
    transferWindowStartCallback : () -> async (),
    transferWindowEndCallback : () -> async ()
  ) {
   
    var timers: [T.TimerInfo] = [];
  
    public func setStableData(stable_timers: [T.TimerInfo]) {
      timers := stable_timers;
    };

    public func setTimer(time: Int, callbackName: Text){
      let duration : Timer.Duration = #seconds(Int.abs(time - Time.now()));
      let timerInfo: T.TimerInfo = {
        id = 0;
        triggerTime = time;
        callbackName = callbackName;
      };  
      setAndBackupTimer(duration, timerInfo);
    };

    public func removeExpiredTimers() : () {
      let currentTime = Time.now();
      timers := Array.filter<T.TimerInfo>(
        timers,
        func(timer : T.TimerInfo) : Bool {
          return timer.triggerTime > currentTime;
        },
      );
    };

    private func setAndBackupTimer(duration : Timer.Duration, timerInfo: T.TimerInfo) {
      let jobId : Timer.TimerId = switch (timerInfo.callbackName) {
        case "gameweekBeginExpired" {
          Timer.setTimer(duration, gameweekBeginExpiredCallback);
        };
        case "gameKickOffExpired" {
          Timer.setTimer(duration, gameKickOffExpiredCallback);
        };
        case "gameCompletedExpired" {
          Timer.setTimer(duration, gameCompletedExpiredCallback);
        };
        case "loanExpired" {
          Timer.setTimer(duration, loanExpiredCallback);
        };
        case "transferWindowStart" {
          Timer.setTimer(duration, transferWindowStartCallback);
        };
        case "transferWindowEnd" {
          Timer.setTimer(duration, transferWindowEndCallback);
        };
        case _ { 
          Timer.setTimer(duration, defaultCallback);
        };
      };

      let triggerTime = switch (duration) {
        case (#seconds s) {
          Time.now() + s * 1_000_000_000;
        };
        case (#nanoseconds ns) {
          Time.now() + ns;
        };
      };

      let newTimerInfo : T.TimerInfo = {
        id = jobId;
        triggerTime = timerInfo.triggerTime;
        callbackName = timerInfo.callbackName;
      };

      var timerBuffer = Buffer.fromArray<T.TimerInfo>(timers);
      timerBuffer.add(newTimerInfo);
      timers := Buffer.toArray(timerBuffer);
    };

    private func recreateTimers() {
      let currentTime = Time.now();
      for (timerInfo in Iter.fromArray(timers)) {
        let remainingDuration = timerInfo.triggerTime - currentTime;

        if (remainingDuration > 0) {
          let duration : Timer.Duration = #nanoseconds(Int.abs(remainingDuration));

          switch (timerInfo.callbackName) {
            case "gameweekBeginExpired" {
              ignore Timer.setTimer(duration, gameweekBeginExpiredCallback);
            };
            case "gameKickOffExpired" {
              ignore Timer.setTimer(duration, gameKickOffExpiredCallback);
            };
            case "gameCompletedExpired" {
              ignore Timer.setTimer(duration, gameCompletedExpiredCallback);
            };
            case "loanExpired" {
              ignore Timer.setTimer(duration, loanExpiredCallback);
            };
            case "transferWindowStart" {
              ignore Timer.setTimer(duration, transferWindowStartCallback);
            };
            case "transferWindowEnd" {
              ignore Timer.setTimer(duration, transferWindowEndCallback);
            };
            case _ {};
          };
        };
      };
    };

    private func defaultCallback() : async () {};

  };
};
