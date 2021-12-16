//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import Combine
import CommonUtils

public final class MetricsManager: MetricsEventsProvider {
  public static let shared = MetricsManager()

  public var newEventsPublisher: AnyPublisher<MetricsEvent, Never> {
    newEventsSubject.eraseToAnyPublisher()
  }

  private let fileSystem: FileSystemManager
  private let maxPoolSize: Int = 10
  private var eventspool: [MetricsEvent] = []
  private let newEventsSubject = PassthroughSubject<MetricsEvent, Never>()
  private let queue: DispatchQueue
  private var stdStreamListener: StdStreamListener?
  private let cancellableBag = CancellableBag()

  // MARK: - Methods

  init(
    fileSystem: FileSystemManager = FileSystem(),
    queue: DispatchQueue = DispatchQueue("com.AppMetrics.MetricsManager", type: .concurrent, qos: .default)
  ) {
    self.fileSystem = fileSystem
    self.queue = queue
  }

  public func enableStdStreamInterception() {
    guard stdStreamListener.isNil else { return }
    stdStreamListener = StdStreamListener()
    stdStreamListener?.stdEventsPublisher
      .sink { [weak self] in
        self?.write(.stdstream($0))
      }
      .store(in: cancellableBag)
  }

  public func fetchEvents() async -> [MetricsEvent] {
    await withUnsafeContinuation { continuation in
      queue.async { [self] in
        continuation.resume(returning: eventspool)
      }
    }
  }

  func write(_ event: MetricsEvent) {
    queue.async(flags: [.barrier]) { [self] in
      eventspool.append(event)
      newEventsSubject.send(event)
    }
  }
}
