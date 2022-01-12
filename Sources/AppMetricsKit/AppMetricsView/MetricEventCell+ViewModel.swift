//
// Created by Alexander Lakhonin on 14.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import AppMetrics

extension MetricEventCell {
  struct ViewModel: Identifiable {
    let id: Int
    let event: MetricsEvent

    var isOdd: Bool {
      id.isMultiple(of: 2)
    }

    var timestamp: String {
      dateFormatter.string(from: event.timestamp)
    }

    var message: String {
      switch event {
      case let .log(logMessage):
        return logMessage.message
      case let .stdstream(stdStreamEvent):
        return stdStreamEvent.message
      }
    }

    var eventTypeInfo: String {
      switch event {
      case let .log(logMessage):
        return logMessage.level.description
      case .stdstream:
        return "stdout"
      }
    }

    private let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss.SSSS"
      return dateFormatter
    }()
  }
}
