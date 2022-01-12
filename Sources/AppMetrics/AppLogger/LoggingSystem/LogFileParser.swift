//
// Created by Alexander Lakhonin on 10.01.2022.
// Copyright © 2022 Alexander Lakhonin. All right reserved.
//

import Foundation

struct LogFileParser {
  struct Result {
    let messages: [AppLogger.Message]
    let dataLeft: Data?
    let brokenMessages: Int
  }

  func parse(_ data: Data) -> Result? {
    let reversedData = data.reversed()
    var startIndex = reversedData.startIndex
    var isFinished = false
    var brokenMessages = 0
    var messages: [AppLogger.Message] = []
    while startIndex != reversedData.endIndex && !isFinished {
      do {
        messages.append(try getNextMessage(from: reversedData, startIndex: &startIndex))
      } catch let error as InternalError {
        switch error {
        case .outOfBounds, .separatorNotFound, .failedToGetMessageLength, .failedToParseSeparator:
          isFinished = true
        case .failedToParseMessage:
          brokenMessages += 1
          assertionFailure("Failed to parse message")
        }
      } catch let error as LogMessageCoder.Error {
        brokenMessages += 1
        assertionFailure("\(error)")
      } catch {
        assertionFailure("Unexpected error: \(error)")
        isFinished = true
      }
    }
    if messages.isEmpty {
      return nil
    }
    return Result(
      messages: messages,
      dataLeft: startIndex == reversedData.endIndex ? nil : Data(reversedData[startIndex ..< reversedData.endIndex].reversed()),
      brokenMessages: brokenMessages
    )
  }

  // MARK: - Private methods

  private func getNextMessage<Data: Collection>(
    from data: Data, startIndex: inout Data.Index
  ) throws -> AppLogger.Message where Data.Element == Foundation.Data.Element {
    let separatorPosition = try getSeparatorPosition(from: data[startIndex ..< data.endIndex])
    guard
      let separatorStartIndex = data.index(startIndex, offsetBy: separatorPosition - 1, limitedBy: data.endIndex),
      let separatorEndIndex = data.index(startIndex, offsetBy: separatorPosition + 1, limitedBy: data.endIndex)
    else {
      throw InternalError.outOfBounds
    }
    let messageLength = try getMessageLength(from: data, startIndex: startIndex, endIndex: separatorStartIndex)

    guard let messageEndIndex = data.index(separatorEndIndex, offsetBy: messageLength.length, limitedBy: data.endIndex) else {
      throw InternalError.outOfBounds
    }
    startIndex = data.index(
      separatorEndIndex, offsetBy: messageLength.length + messageLength.digits, limitedBy: data.endIndex
    ) ?? data.endIndex
    let messageRawData = data[separatorEndIndex ..< messageEndIndex]
    guard let messageString = String(bytes: messageRawData.reversed(), encoding: .utf8) else {
      throw InternalError.failedToParseMessage
    }
    return try LogMessageCoder.decode(messageString)
  }

  private func getMessageLength<Data: Collection>(
    from data: Data, startIndex: Data.Index, endIndex: Data.Index
  ) throws -> (length: Int, digits: Int) where Data.Element == Foundation.Data.Element {
    let messageLengthRawValue = Foundation.Data(data[startIndex ... endIndex].reversed())
    guard
      let messageLengthStringValue = String(data: messageLengthRawValue, encoding: .utf8),
      let messageLengthIntValue = Int(messageLengthStringValue.trimmingCharacters(in: .whitespacesAndNewlines))
    else {
      throw InternalError.failedToGetMessageLength
    }
    return (length: messageLengthIntValue, digits: messageLengthStringValue.count)
  }

  private func getSeparatorPosition<Data: Collection>(from data: Data) throws -> Int where Data.Element: Comparable {
    var separatorPosition: Int = NSNotFound
    guard
      let separatorData = ":".data(using: .utf8),
      separatorData.count == 1,
      let separator = separatorData[0] as? Data.Element
    else {
      throw InternalError.failedToParseSeparator
    }
    for (i, byte) in data.enumerated() where byte == separator {
      separatorPosition = i
      break
    }
    if separatorPosition == NSNotFound { throw InternalError.separatorNotFound }
    return separatorPosition
  }
}

private extension LogFileParser {
  enum InternalError: Swift.Error {
    case outOfBounds
    case failedToGetMessageLength
    case failedToParseSeparator
    case separatorNotFound
    case failedToParseMessage
  }
}
