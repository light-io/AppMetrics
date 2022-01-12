//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

protocol LogWriter {
  func write(_ message: AppLogger.Message)
}
