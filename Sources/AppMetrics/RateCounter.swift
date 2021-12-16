//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import CoreMedia
import CommonUtils

public struct RateCounter {
  public enum Smoothing {
    case none
    case linear(windowSize: Int)
  }

  public typealias Rate = TimeInterval

  public private(set) var rate: Rate = 0

  private var lastUpdateTime: TimeInterval = -1
  private let isSmoothingEnabled: Bool
  private let timeScale: TimeInterval
  private lazy var smoothingBuffer = MAQueue<TimeInterval>(windowSize: 0)
  private lazy var elapsedTime: TimeInterval = -1

  // MARK: - Methods

  public init(timeScale: TimeInterval, smoothing: Smoothing) {
    self.timeScale = timeScale
    switch smoothing {
    case .none:
      isSmoothingEnabled = false
    case .linear(let windowSize):
      isSmoothingEnabled = true
      smoothingBuffer.set(windowSize: windowSize)
    }
  }

  @discardableResult
  public mutating func tick() -> Rate {
    guard lastUpdateTime > 0 else {
      lastUpdateTime = Benchmark.time
      return rate
    }
    if isSmoothingEnabled {
      smoothingBuffer.add(Benchmark.time - lastUpdateTime)
      rate = timeScale / smoothingBuffer.avg
    } else {
      rate = timeScale / Benchmark.time - lastUpdateTime
    }
    lastUpdateTime = Benchmark.time
    return rate
  }
}
