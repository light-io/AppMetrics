//
// Created by Alexander Lakhonin on 24.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

// TODO: - Move to CommonUtils

public final class MicrosecondPrecisionDateFormatter: DateFormatter {
//  private let microsecondsPrefix = "."
  private let defaultDateFormat = "yyyy-MM-dd'T'HH:mm:ss"

  // MARK: - Methods

  public override init() {
    super.init()
    dateFormat = defaultDateFormat
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func stringWithMicroseconds(from date: Date) -> String? {
    let components = calendar.dateComponents(Set([Calendar.Component.nanosecond]), from: date)
    guard let nanosecond = components.nanosecond else { return nil }
    let nanosecondsInMicrosecond = Double(1_000)
    let microseconds = lrint(Double(nanosecond) / nanosecondsInMicrosecond)
    guard let updatedDate = calendar.date(byAdding: .nanosecond, value: -nanosecond, to: date) else {
      return nil
    }
    dateFormat = "\(dateFormat ?? defaultDateFormat)'.\(microseconds)'Z"
    return string(from: updatedDate)
  }
}
