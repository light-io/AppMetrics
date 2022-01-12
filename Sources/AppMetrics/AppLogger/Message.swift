//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import OSLog

public extension AppLogger {
  struct Message: Codable {
    public let timestamp: Double
    public let message: String
    public let level: AppLogger.Level
    public let metadata: Metadata

    public var date: Date {
      Date(timeIntervalSinceReferenceDate: timestamp)
    }
  }
}

public extension AppLogger.Message {
  struct Metadata: Codable {
    public let category: String
    public let subsystem: String
    public let verbose: Verbose?
  }

  struct Verbose: Codable {
    let file: String
    let function: String
    let line: Int
  }
}

extension AppLogger.Message: CustomStringConvertible {
  public var description: String {
    let description = "[\(level)] \(message)"
    guard let verbose = metadata.verbose else {
      return description
    }
    return description + " \(verbose)"
  }
}

extension AppLogger.Message.Verbose: CustomStringConvertible {
  public var description: String {
    "[\(file), \(function), \(line)]"
  }
}
