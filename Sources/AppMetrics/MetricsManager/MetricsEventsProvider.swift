//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import Combine

public protocol MetricsEventsProvider: AnyObject {
  var newEventsPublisher: AnyPublisher<MetricsEvent, Never> { get }

  func fetchEvents() async -> [MetricsEvent]
}
