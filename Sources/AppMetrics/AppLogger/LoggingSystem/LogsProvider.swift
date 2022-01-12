//
// Created by Alexander Lakhonin on 24.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import Combine

public protocol LogsProvider {
  var logsPublisher: AnyPublisher<AppLogger.Message, Never> { get }
}
