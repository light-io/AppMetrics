//
// Created by Alexander Lakhonin on 24.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import Combine
import CommonUtils

public final class LoggingSystem: LogWriter, LogsProvider {
  public static let shared = LoggingSystem()

  @Atomic public var minimumLogLevel: AppLogger.Level = {
    #if DEBUG
    return .debug
    #else
    return .info
    #endif
  }()

  @Atomic public var isSavingLogsToFile = true

  public var logsPublisher: AnyPublisher<AppLogger.Message, Never> {
    logsSubject.eraseToAnyPublisher()
  }

  private let queue: DispatchQueue

  private let logsSubject = PassthroughSubject<AppLogger.Message, Never>()

  private var logsPool: [AppLogger.Message] = []

  private let logFilesHandle: LogFilesHandle

  // MARK: - Methods

  init(
    queue: DispatchQueue = DispatchQueue("com.AppMetrics.LoggingSystem", type: .serial, qos: .default)
  ) {
    self.queue = queue
    logFilesHandle = LogFilesHandle()
    queue.asyncAfter(deadline: .now() + 1) {
      self.read()
    }
  }

  func write(_ message: AppLogger.Message) {
    queue.sync {
      logsPool.append(message)
      logsSubject.send(message)
//      logFilesHandle.write(message)
    }
  }

  // MARK: - Private methods

  func read() {
    queue.async {
      self.logFilesHandle.read()
    }
  }
}
