//
// Created by Alexander Lakhonin on 13.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import SwiftUI
import AppMetrics

struct MetricEventCell: View {
  let viewModel: ViewModel

  private var backgroundColor: Color {
    viewModel.isOdd ? Color.white.opacity(0.1) : Color.clear
  }

  var body: some View {
    VStack(alignment: .trailing, spacing: 0) {
      infoPanel
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(Color.clear)
      messagePanel
        .background(Color.clear)
    }
    .frame(maxWidth: .infinity, maxHeight: 300)
    .foregroundColor(Color.white)
    .background(backgroundColor)
  }

  // MARK: - ViewBuilders

  @ViewBuilder
  private var infoPanel: some View {
    HStack {
      Image(systemName: "clock").font(Font.body.bold()).foregroundColor(Color.white)
      Text(viewModel.timestamp)
      Spacer()
      levelBadge
    }.padding(0)
  }

  @ViewBuilder
  private var messagePanel: some View {
    HStack(alignment: .top) {
      Text(viewModel.message).fixedSize(horizontal: false, vertical: true)
      Spacer()
    }.padding(0)
  }

  @ViewBuilder
  private var levelBadge: some View {
    HStack {
      Text(viewModel.eventTypeInfo)
    }
    .padding([.top, .bottom], 0)
    .padding([.leading, .trailing], 0)
  }
}
