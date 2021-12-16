//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import OSLog

struct ConsoleWriter: LogWriter {
  func log(_ message: LogMessage) {
    os_log(
      message.logLevel.type,
      log: .init(subsystem: "\(message.subsystem)", category: "\(message.category)"),
      "%{public}s",
      "\(message)"
    )
  }
}
