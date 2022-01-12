//
// Created by Alexander Lakhonin on 16.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import SwiftUI
import AppMetrics
import AppMetricsKit

struct ContentView: View {
  private let logger = AppLogger(subsystem: "DemoApp", category: "MainView")

  var body: some View {
    LogsView()
      .padding([.leading, .trailing], 5)
      .onAppear(perform: onAppear)
  }

  private func onAppear() {
    logger.debug("on appear")
    logger.error("error occured")
    logger.debug(":debug message 😄,\n multiline message")
    logger.fault("oy oy that's fault message")
    logger.warning("wraning message")
    logger.debug("long long long long long message long long long long long message long long long long long message")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
