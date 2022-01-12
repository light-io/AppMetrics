//
// Created by Alexander Lakhonin on 13.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import CommonUtils
import AppMetrics

@MainActor
final class LogsViewPresenter: ObservableObject {
  @Published private(set) var logMessages: [LogCell.ViewModel] = []

  private let logsProvider: LogsProvider
  private var cancellableBag = CancellableBag()

  // MARK: - Methods

  init(logsProvider: LogsProvider) {
    self.logsProvider = logsProvider
    bind()
  }

  // MARK: - Private methods

  private func bind() {
    logsProvider.logsPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        guard let self = self else { return }
        self.logMessages.append(LogCell.ViewModel(id: self.logMessages.count, logMessage: $0))
      }
      .store(in: cancellableBag)
  }
}
