//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

extension MetricsManager: LogWriter {
  func log(_ message: LogMessage) {
    write(.log(message))
  }
}
