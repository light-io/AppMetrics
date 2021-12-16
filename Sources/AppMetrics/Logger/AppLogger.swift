//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import OSLog

public struct AppLogger {
  private static var minimumLogType: LogLevel = .debug

  public static func setupMinimumLogType(_ minimumLogType: LogLevel) {
    AppLogger.minimumLogType = minimumLogType
  }

  public let subsystem: String
  public let category: String

  private let consoleWriter: LogWriter = ConsoleWriter()
  private var fileWriter: LogWriter { MetricsManager.shared }

  public init(subsystem: String, category: String) {
    self.subsystem = subsystem
    self.category = category
  }

  public func debug(_ message: @autoclosure () -> String) {
    guard AppLogger.minimumLogType <= LogLevel.debug else {
      return
    }
    let message = LogMessage(
      timestamp: .now,
      message: message(),
      logLevel: .debug,
      subsystem: subsystem,
      category: category,
      verbose: nil
    )
    consoleWriter.log(message)
    writeToFile(message)
  }

  public func info(
    _ message: @autoclosure () -> String,
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    guard AppLogger.minimumLogType <= LogLevel.info else {
      return
    }
    let verbose = LogMessage.Verbose(file: file, function: function, line: line)
    let message = LogMessage(
      timestamp: .now,
      message: message(),
      logLevel: .info,
      subsystem: subsystem,
      category: category,
      verbose: verbose
    )
    consoleWriter.log(message)
    writeToFile(message)
  }

  public func warning(_ message: @autoclosure () -> String) {
    guard AppLogger.minimumLogType <= LogLevel.warning else {
      return
    }
    let message = LogMessage(
      timestamp: .now,
      message: message(),
      logLevel: .warning,
      subsystem: subsystem,
      category: category,
      verbose: nil
    )
    consoleWriter.log(message)
    writeToFile(message)
  }

  public func error(
    _ message: @autoclosure () -> String,
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    guard AppLogger.minimumLogType <= LogLevel.error else {
      return
    }
    let verbose = LogMessage.Verbose(file: file, function: function, line: line)
    let message = LogMessage(
      timestamp: .now,
      message: message(),
      logLevel: .error,
      subsystem: subsystem,
      category: category,
      verbose: verbose
    )
    consoleWriter.log(message)
    writeToFile(message)
  }

  public func fault(
    _ message: @autoclosure () -> String,
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    guard AppLogger.minimumLogType <= LogLevel.fault else {
      return
    }
    let verbose = LogMessage.Verbose(file: file, function: function, line: line)
    let message = LogMessage(
      timestamp: .now,
      message: message(),
      logLevel: .fault,
      subsystem: subsystem,
      category: category,
      verbose: verbose
    )
    consoleWriter.log(message)
    writeToFile(message)
  }

  // MARK: - Private methods

  @inline(__always)
  private func writeToFile(_ message: LogMessage) {
    fileWriter.log(message)
  }
}
