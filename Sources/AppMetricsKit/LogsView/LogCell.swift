//
// Created by Alexander Lakhonin on 13.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import SwiftUI
import AppMetrics

struct LogCell: View {
  let viewModel: ViewModel

  private var backgroundColor: Color {
    viewModel.isOdd ? Color.white.opacity(0.1) : Color.clear
  }

  var body: some View {
    VStack(alignment: .trailing, spacing: 5) {
      infoPanel
        .frame(maxWidth: .infinity)
        .background(Color.clear)
      messagePanel
        .background(Color.clear)
    }
    .padding(5)
    .frame(maxWidth: .infinity)
    .foregroundColor(Color.white)
    .background(backgroundColor)
    .font(.footnote)
  }

  // MARK: - ViewBuilders

  @ViewBuilder
  private var infoPanel: some View {
    HStack {
      Image(systemName: "clock").font(Font.footnote.bold()).foregroundColor(Color.blue)
      Text(viewModel.date)
      Spacer()
      levelBadge.font(.footnote.bold())
    }.padding(0)
  }

  @ViewBuilder
  private var messagePanel: some View {
    HStack(alignment: .top) {
      Text(viewModel.logMessage.message).fixedSize(horizontal: false, vertical: true)
      Spacer()
    }.padding(0)
  }

  @ViewBuilder
  private var levelBadge: some View {
    HStack {
      Text(viewModel.logMessage.level.description)
    }
    .padding([.top, .bottom], 0)
    .padding([.leading, .trailing], 0)
  }
}
