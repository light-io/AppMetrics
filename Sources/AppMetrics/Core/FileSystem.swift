//
// Created by Alexander Lakhonin on 23.09.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import CommonUtils

final class FileSystem {
  enum Extension: String {
    case log
  }

  static let shared = FileSystem()

  private(set) lazy var metricsDirectory = baseDirectory.appendingPathComponent("AppMetrics", isDirectory: true)
  private(set) lazy var logsDirectory = metricsDirectory.appendingPathComponent("Logs", isDirectory: true)

  private let fileManager: FileManager = .default
  private var baseDirectory: URL {
    do {
      return try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  // MARK: - Methods

  func getFileSize(atPath path: String) throws -> UInt64? {
    try fileManager.fileSize(atPath: path)
  }

  // MARK: - Working with logs

  func createLogFile(withName name: String) -> URL {
    let url = logsDirectory
      .appendingPathComponent(name, isDirectory: false)
      .appendingPathExtension("log")
    if !fileManager.fileExists(atPath: url.path) {
      fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
    }
    return url
  }

  // MARK: - Refactor

  enum File: String {
    case metricsInfo = "metrics_info"
  }

  var isAppMetricsDirectoryExists: Bool {
    var isDir: ObjCBool = true
    return fileManager.fileExists(atPath: metricsDirectory.path, isDirectory: &isDir)
  }

  var isLogsDirectoryExists: Bool {
    var isDir: ObjCBool = true
    return fileManager.fileExists(atPath: logsDirectory.path, isDirectory: &isDir)
  }

  var logsFileURL: URL {
    logsDirectory
      .appendingPathComponent("logs", isDirectory: false)
      .appendingPathExtension("log")
  }

  // MARK: - Methods

  init() { }

  func prepare() {
    if !isAppMetricsDirectoryExists {
      do {
        try fileManager.createDirectory(at: metricsDirectory, withIntermediateDirectories: true, attributes: nil)
      } catch {
        fatalError(error.localizedDescription)
      }
    }
    if !isLogsDirectoryExists {
      do {
        try fileManager.createDirectory(at: logsDirectory, withIntermediateDirectories: true, attributes: nil)
      } catch {
        fatalError(error.localizedDescription)
      }
    }
  }
}
