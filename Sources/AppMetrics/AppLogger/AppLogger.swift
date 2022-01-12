//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import OSLog

public struct AppLogger {
  public let subsystem: String
  public let category: String

  private let consoleWriter: LogWriter = ConsoleWriter()
  private var fileWriter: LogWriter { LoggingSystem.shared }
  private let minimumLogLevel: Level
  private let isSavingLogsToFile: Bool

  public init(
    subsystem: String,
    category: String,
    minimumLogLevel: Level = LoggingSystem.shared.minimumLogLevel,
    isSavingLogsToFile: Bool = LoggingSystem.shared.isSavingLogsToFile
  ) {
    self.subsystem = subsystem
    self.category = category
    self.minimumLogLevel = minimumLogLevel
    self.isSavingLogsToFile = isSavingLogsToFile
  }

  public func debug(_ message: @autoclosure () -> String) {
    guard minimumLogLevel <= .debug else { return }
    log(message, level: .debug, verbose: nil)
  }

  public func info(
    _ message: @autoclosure () -> String,
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    guard minimumLogLevel <= .info else { return }
    let verbose = Message.Verbose(file: file, function: function, line: line)
    log(message, level: .info, verbose: verbose)
  }

  public func warning(_ message: @autoclosure () -> String) {
    guard minimumLogLevel <= .warning else { return }
    log(message, level: .warning, verbose: nil)
  }

  public func error(
    _ message: @autoclosure () -> String,
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    guard minimumLogLevel <= .error else { return }
    let verbose = Message.Verbose(file: file, function: function, line: line)
    log(message, level: .error, verbose: verbose)
  }

  public func fault(
    _ message: @autoclosure () -> String,
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    guard minimumLogLevel <= .fault else { return }
    let verbose = Message.Verbose(file: file, function: function, line: line)
    log(message, level: .fault, verbose: verbose)
  }

  // MARK: - Private methods

  @inline(__always)
  private func log(_ message: () -> String, level: Level, verbose: Message.Verbose?) {
    let message = Message(
      timestamp: CFAbsoluteTimeGetCurrent(),
      message: message(),
      level: level,
      metadata: Message.Metadata(
        category: category,
        subsystem: subsystem,
        verbose: verbose
      )
    )
    consoleWriter.write(message)
    if isSavingLogsToFile {
      fileWriter.write(message)
    }
  }
}
