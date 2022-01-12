//
// Created by Alexander Lakhonin on 16.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import SwiftUI
import AppMetrics
import AppMetricsKit

struct ContentView: View {
  private let logger = AppLogger(subsystem: "DemoApp", category: "MainView")

  var body: some View {
    Text("hello")

    AppMetricsView()
      .padding()
      .onAppear(perform: onAppear)
  }

  private func timestamp() -> String {
    var buffer = [Int8](repeating: 0, count: 255)
#if os(Windows)
    var timestamp: __time64_t = __time64_t()
    _ = _time64(&timestamp)

    var localTime: tm = tm()
    _ = _localtime64_s(&localTime, &timestamp)

    _ = strftime(&buffer, buffer.count, "%Y-%m-%dT%H:%M:%S%z", &localTime)
#else
    var timestamp = time(nil)
    let localTime = localtime(&timestamp)
    strftime(&buffer, buffer.count, "%Y-%m-%dT%H:%M:%S.%f%z", localTime)
#endif
    return buffer.withUnsafeBufferPointer {
      $0.withMemoryRebound(to: CChar.self) {
        String(cString: $0.baseAddress!)
      }
    }
  }

  private func onAppear() {
    logger.debug("on appear")
//    print(mach_absolute_time())
//    print(Date.now)
//    print(NSDate())
    let formatter = DateFormatter()
//
//    var info = mach_timebase_info()
//    guard mach_timebase_info(&info) == KERN_SUCCESS else { return }
//    let currentTime = mach_absolute_time()
//    let nanos = currentTime * UInt64(info.numer) / UInt64(info.denom)
//    print(nanos)
//    print(timestamp())
//
//    var dc = DateComponents()
//    dc.nanosecond = Int(nanos)
//    print(dc.date)

//    let d = CFAbsoluteTimeGetCurrent()
//    let date = Date(timeIntervalSinceReferenceDate: d)
////    let date = Date(timeIntervalSince1970: nanos)
//    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//
//    print("=")
//    print(formatter.string(from: date))
//
//    let formatter1 = MicrosecondPrecisionDateFormatter()
//    print(d)
//    print(1490891661.074981)
//    let date1 = Date(timeIntervalSinceReferenceDate: d)
//    print("---")
//    print(formatter1.string(from: date1))
    logger.debug(":debug message 😄, вьл:вдь")
    logger.fault("oy oy that's fault message")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
