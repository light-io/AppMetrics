//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

public enum Benchmark {
  public static func measure(_ work: () -> Void) -> TimeInterval {
    let begin = ProcessInfo.processInfo.systemUptime
    work()
    return ProcessInfo.processInfo.systemUptime - begin
  }

  @inline(__always)
  public static var time: TimeInterval {
    ProcessInfo.processInfo.systemUptime
  }
}
