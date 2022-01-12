//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import OSLog

struct ConsoleWriter: LogWriter {
  func write(_ message: AppLogger.Message) {
    os_log(
      message.level.type,
      log: .init(subsystem: "\(message.metadata.subsystem)", category: "\(message.metadata.category)"),
      "%{public}s",
      "\(message)"
    )
  }
}
