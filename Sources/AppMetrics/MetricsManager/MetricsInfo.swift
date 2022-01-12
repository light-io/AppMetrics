//
// Created by Alexander Lakhonin on 23.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

public struct MetricsInfo: Codable {
  public let numberOfInits: Int

  func makeNewByIncreasingInit() -> MetricsInfo {
    MetricsInfo(numberOfInits: numberOfInits + 1)
  }
}
