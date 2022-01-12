//
// Created by Alexander Lakhonin on 24.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

// TODO: - Move to CommonUtils

public final class MicrosecondPrecisionDateFormatter {

  public var dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss"

  private let dateFormatter = DateFormatter()
  private let microsecondsPrefix = "."

  public func string(from date: Date) -> String? {
    let components = dateFormatter.calendar.dateComponents(Set([Calendar.Component.nanosecond]), from: date)
    guard let nanosecond = components.nanosecond else { return nil }
    let nanosecondsInMicrosecond = Double(1_000)
    let microseconds = lrint(Double(nanosecond) / nanosecondsInMicrosecond)
    guard let updatedDate = dateFormatter.calendar.date(byAdding: .nanosecond, value: -nanosecond, to: date) else {
      return nil
    }
    dateFormatter.dateFormat = "\(dateFormat)'.\(microseconds)'Z"
    return dateFormatter.string(from: updatedDate)
  }
}
