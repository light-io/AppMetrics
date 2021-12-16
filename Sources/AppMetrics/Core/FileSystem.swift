//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

final class FileSystem: FileSystemManager {
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  private let fileManager: FileManager = .default
  private var baseDirectory: URL {
    do {
      return try fileManager.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  private lazy var metricsDirectory: URL = baseDirectory.appendingPathComponent("Metrics", isDirectory: true)

  // MARK: - Methods

  init() {
    prepare()
  }

  func save(_ events: [MetricsEvent]) {
    Thread.assertIsBackground()
//    let data = encoder.encode(<#T##value: Encodable##Encodable#>)
  }

  // MARK: - Private methods

  private func prepare() {
    do {
      try fileManager.createDirectory(at: metricsDirectory, withIntermediateDirectories: true, attributes: nil)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}
