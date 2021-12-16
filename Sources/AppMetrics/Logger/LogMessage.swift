//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import OSLog

public struct LogMessage: Codable {
  public let timestamp: Date
  public let message: String
  public let logLevel: LogLevel
  public let subsystem: String
  public let category: String
  public let verbose: Verbose?

  public struct Verbose: Codable {
    let file: String
    let function: String
    let line: Int
  }
}

extension LogMessage: CustomStringConvertible {
  public var description: String {
    let description = "[\(logLevel)] \(message)"
    guard let verbose = verbose else {
      return description
    }
    return description + " \(verbose)"
  }
}

extension LogMessage.Verbose: CustomStringConvertible {
  public var description: String {
    "[\(file), \(function), \(line)]"
  }
}
