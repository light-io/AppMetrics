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

  @Atomic public var isSaveEventsToFile = true
  public private(set) var metricsInfo = MetricsInfo(numberOfInits: 0)

  private let fileSystem: FileSystem
  private let newEventsSubject = PassthroughSubject<MetricsEvent, Never>()
  private let queue: DispatchQueue
  private var stdStreamListener: StdStreamListener?
  private let notificationCenter: NotificationCenter
  private let cancellableBag = CancellableBag()

  // MARK: - Methods

  init(
    fileSystem: FileSystem = FileSystem(),
    notificationCenter: NotificationCenter = .default,
    queue: DispatchQueue = DispatchQueue("com.AppMetrics.MetricsManager", type: .concurrent, qos: .default)
  ) {
    self.fileSystem = fileSystem
    self.notificationCenter = notificationCenter
    self.queue = queue
//    fileSystem.prepare()
//    updateMetricsInfo()
  }

  public func enableStdStreamInterception() {
    guard stdStreamListener.isNil else { return }
    stdStreamListener = StdStreamListener()
  }

  public func fetchEvents() async -> [MetricsEvent] {
    await withUnsafeContinuation { continuation in
      continuation.resume(returning: [])
    }
  }
}
