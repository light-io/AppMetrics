//
// Created by Alexander Lakhonin on 14.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import AppMetrics

extension LogCell {
  struct ViewModel: Identifiable {
    let id: Int
    let logMessage: AppLogger.Message

    var isOdd: Bool {
      id.isMultiple(of: 2)
    }

    var date: String {
      dateFormatter.stringWithMicroseconds(from: logMessage.date) ?? ""
    }

    private let dateFormatter = MicrosecondPrecisionDateFormatter()
  }
}
