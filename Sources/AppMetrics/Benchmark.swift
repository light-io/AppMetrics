//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

public enum Benchmark {
  public static func measure(_ work: () -> Void) -> TimeInterval {
    var info = mach_timebase_info()
    guard mach_timebase_info(&info) == KERN_SUCCESS else { return -1 }

    let start = mach_absolute_time()
    work()
    let end = mach_absolute_time()

    let elapsed = end - start

    let nanos = elapsed * UInt64(info.numer) / UInt64(info.denom)
    return TimeInterval(nanos) / TimeInterval(NSEC_PER_SEC)
  }

  @inline(__always)
  public static var time: TimeInterval {
    ProcessInfo.processInfo.systemUptime
  }
}
