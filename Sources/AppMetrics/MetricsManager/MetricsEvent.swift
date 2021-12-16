//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

public enum MetricsEvent {
  case log(_ log: LogMessage)
  case stdstream(_ event: StdEvent)

  public var timestamp: Date {
    switch self {
    case let .log(logMessage):
      return logMessage.timestamp
    case let .stdstream(event):
      return event.timestamp
    }
  }
}
