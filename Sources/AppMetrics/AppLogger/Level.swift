//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import OSLog

public extension AppLogger {
  enum Level: Int {
    case debug
    case warning
    case info
    case error
    case fault
  }
}

extension AppLogger.Level {
  var type: OSLogType {
    switch self {
    case .debug:
      return .debug
    case .info:
      return .info
    case .warning:
      return .default
    case .error:
      return .error
    case .fault:
      return .fault
    }
  }
}

extension AppLogger.Level: CustomStringConvertible {
  public var description: String {
    switch self {
    case .debug:
      return "⚙️ debug"
    case .info:
      return "ℹ️ info"
    case .warning:
      return "⚠️ warning"
    case .error:
      return "🚨 error"
    case .fault:
      return "💥 fault"
    }
  }
}

extension AppLogger.Level: Codable { }

extension AppLogger.Level: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}
