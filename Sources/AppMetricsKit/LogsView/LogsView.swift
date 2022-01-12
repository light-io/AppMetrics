//
// Created by Alexander Lakhonin on 13.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import SwiftUI
import AppMetrics

public struct LogsView: View {
  @StateObject private var presenter = LogsViewPresenter(
    logsProvider: LoggingSystem.shared
  )

  public init() { }

  public var body: some View {
    logsView
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .padding(0)
    .background(Color.black)
    .onAppear(perform: onAppear)
  }

  // MARK: - ViewBuilders

  @ViewBuilder
  private var logsView: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(presenter.logMessages, id: \.id) {
          LogCell(viewModel: $0).background(Color.clear)
        }
      }
    }
    .padding(0)
    .background(Color.clear)
  }

  // MARK: - Private methods

  private func onAppear() { }
}

#if DEBUG
struct AppMetricsView_Previews: PreviewProvider {
  private static let logger = AppLogger(subsystem: "AppMetricsKit", category: "AppMetricsView_Previews")

  static var previews: some View {
    LogsView()
      .previewLayout(.fixed(width: 400, height: 500))
      .onAppear {
        MetricsManager.shared.enableStdStreamInterception()
        AppMetricsView_Previews.logger.debug("test log")
        AppMetricsView_Previews.logger.warning("test log warning")
        AppMetricsView_Previews.logger.error(
          "test log message, long error message, test log message, long error message test"
        )
        AppMetricsView_Previews.logger.fault("test log fault")
      }
  }
}
#endif
