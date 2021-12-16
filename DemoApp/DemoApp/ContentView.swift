//
// Created by Alexander Lakhonin on 16.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import SwiftUI
//import AppMetrics
//import AppMetricsKit

struct ContentView: View {
//  private let logger = AppLogger(subsystem: "DemoApp", category: "MainView")

  var body: some View {
    Text("hello")

//    AppMetricsView()
//      .padding()
//      .onAppear(perform: onAppear)
  }

  private func onAppear() {
//    logger.debug("on appear")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
