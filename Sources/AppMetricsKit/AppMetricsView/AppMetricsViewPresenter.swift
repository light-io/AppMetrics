//
// Created by Alexander Lakhonin on 13.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import CommonUtils
import AppMetrics

@MainActor
final class AppMetricsViewPresenter: ObservableObject {
  @Published private(set) var events: [MetricEventCell.ViewModel] = []

  private let eventsProvider: MetricsEventsProvider
  private var cancellableBag = CancellableBag()

  // MARK: - Methods

  init(eventsProvider: MetricsEventsProvider) {
    self.eventsProvider = eventsProvider
    bind()
  }

  func loadEvents() {
    Task {
      var loadedEvents = await eventsProvider.fetchEvents().enumerated().map {
        MetricEventCell.ViewModel(id: $0, event: $1)
      }
      if events.isEmpty {
        events = loadedEvents
      } else {
        loadedEvents.append(contentsOf: events)
        events = loadedEvents
      }
    }
  }

  // MARK: - Private methods

  private func bind() {
    eventsProvider.newEventsPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        guard let self = self else { return }
        self.events.append(MetricEventCell.ViewModel(id: self.events.count, event: $0))
      }
      .store(in: cancellableBag)
  }
}
