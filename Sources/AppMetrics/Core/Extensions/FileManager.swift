//
// Created by Alexander Lakhonin on 28.12.2021.
// Copyright © 2021 Alexander Lakhonin. All right reserved.
//

import Foundation

extension FileManager {
  func fileSize(atPath path: String) throws -> UInt64? {
    let attr = try attributesOfItem(atPath: path)
    return attr[.size] as? UInt64
  }
}
