//
// Created by Alexander Lakhonin on 28.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

final class LogFilesHandle {
  private let fileSystem: FileSystem
  private let logFileParser = LogFileParser()
  private let url: URL
  private var fileHandle: FileHandle?
  private let chunkSize: UInt64 = 1_000
  private var currentFileURL: URL?

  // MARK: - Methods

  init(fileSystem: FileSystem = .shared) {
    self.fileSystem = fileSystem
    url = fileSystem.createLogFile(withName: "logs")
    fileHandle = try? FileHandle(forUpdating: url)
    currentFileURL = url
  }

  func write(_ message: AppLogger.Message) {
    do {
      let encodedMessage = LogMessageCoder.encode(message)
      let dataLength = encodedMessage.utf8.count
      guard let data = "\(dataLength):\(encodedMessage):\(dataLength)\n".data(using: .utf8) else {
        assertionFailure("Failed to encode AppLogger.Message to utf8 data representation")
        return
      }
      try fileHandle?.seekToEnd()
      try fileHandle?.write(contentsOf: data)
    } catch {
      assertionFailure(error.localizedDescription)
    }
  }

  func read() -> [AppLogger.Message]? {
    guard let fileHandle = fileHandle else {
      return nil
    }
    do {
      return try readFullFile(fileHandle: fileHandle)
    } catch {
      assertionFailure("\(error)")
      return nil
    }
  }

  // MARK: - Private methods

  private func readFullFile(fileHandle: FileHandle) throws -> [AppLogger.Message] {
    try fileHandle.seek(toOffset: 0)
    guard let data = try fileHandle.readToEnd()§ else { return [] }
    return logFileParser.parse(data)?.messages ?? []
  }
}
