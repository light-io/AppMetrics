//
// Created by Alexander Lakhonin on 27.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation
import CommonUtils

enum LogMessageCoder {

  // MARK: - Methods

  static func encode(_ message: AppLogger.Message) -> String {
    String(
      format: "%f,%d,%@,%@,%d,%d:%@%d:%@%d:%@",
      message.timestamp,
      message.level.rawValue,
      message.metadata.verbose?.file ?? "",
      message.metadata.verbose?.function ?? "",
      message.metadata.verbose?.line ?? -1,
      message.message.utf8.count,
      message.message,
      message.metadata.category.utf8.count,
      message.metadata.category,
      message.metadata.subsystem.utf8.count,
      message.metadata.subsystem
    )
  }

  static func decode(_ data: String) throws -> AppLogger.Message {
    let split = data.split(separator: ",", maxSplits: 5, omittingEmptySubsequences: false)
    guard split.count == 6 else {
      throw Error.failedToDecodeData
    }
    guard
      let timestamp = Double(split[0]),
      let level = Int(split[1]),
      let logLevel = AppLogger.Level(rawValue: level),
      let messageResult = extractMessage(from: split[5].utf8),
      let categroyResult = extractMessage(from: messageResult.nextUTF8Repr),
      let subsystemResult = extractMessage(from: categroyResult.nextUTF8Repr)
    else {
      throw Error.failedToDecodeData
    }
    let verbose: AppLogger.Message.Verbose?
    if !split[2].isEmpty && !split[3].isEmpty, let line = Int(split[4]), line >= 0 {
      verbose = AppLogger.Message.Verbose(file: String(split[2]), function: String(split[3]), line: line)
    } else {
      verbose = nil
    }
    return AppLogger.Message(
      timestamp: timestamp,
      message: messageResult.message,
      level: logLevel,
      metadata: AppLogger.Message.Metadata(
        category: categroyResult.message,
        subsystem: subsystemResult.message,
        verbose: verbose
      )
    )
  }

  // MARK: - Private methods

  private static func extractMessage(
    from utf8Repr: Substring.UTF8View.SubSequence
  ) -> (nextUTF8Repr: Substring.UTF8View.SubSequence, message: String)? {
    guard
      let index = utf8Repr.firstIndex(of: .init(ascii: ":")),
      let prefix = String(utf8Repr.prefix(upTo: index)),
      let messageLength = Int(prefix)
    else {
      return nil
    }
    let suffix = utf8Repr.suffix(from: index).dropFirst()
    guard let message = String(suffix.prefix(messageLength)) else {
      return nil
    }
    return (nextUTF8Repr: suffix.dropFirst(messageLength), message: message)
  }
}

extension LogMessageCoder {
  enum Error: Swift.Error {
    case failedToDecodeData
  }
}
