//
// Created by Alexander Lakhonin on 14.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import Combine
import CommonUtils

public struct StdEvent {
  public let message: String
  public let timestamp: Date
}

final class StdStreamListener {
  var stdEventsPublisher: AnyPublisher<StdEvent, Never> {
    stdEventsSubject.eraseToAnyPublisher()
  }

  private let stdoutPipe = Pipe()
  private let notificationCenter: NotificationCenter
  private var stdoutObserver: NSObjectProtocol?
  private let stdEventsSubject = PassthroughSubject<StdEvent, Never>()
  private let queue: DispatchQueue

  // MARK: - Methods

  init(
    queue: DispatchQueue = DispatchQueue("com.AppMetrics.StdStreamListener", type: .concurrent, qos: .default),
    notificationCenter: NotificationCenter = .default
  ) {
    self.queue = queue
    self.notificationCenter = notificationCenter
    captureStandardOutput()
  }

  deinit {
    if let stdoutObserver = stdoutObserver {
      notificationCenter.removeObserver(stdoutObserver)
    }
  }

  // MARK: - Private methods

  private func captureStandardOutput() {
    dup2(stdoutPipe.fileHandleForWriting.fileDescriptor, FileHandle.standardOutput.fileDescriptor)

    stdoutPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()

    stdoutObserver = notificationCenter.addObserver(
      forName: NSNotification.Name.NSFileHandleDataAvailable,
      object: stdoutPipe.fileHandleForReading,
      queue: nil
    ) { [weak self] _ in
      guard let output = self?.stdoutPipe.fileHandleForReading.availableData else { return }
      let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
      self?.stdEventsSubject.send(StdEvent(message: outputString, timestamp: .now))
      self?.stdoutPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
    }
  }
}
