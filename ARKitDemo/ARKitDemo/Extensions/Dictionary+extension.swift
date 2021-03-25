//
//  Dictionary+extension.swift
//  MLMarkTool
//
//  Created by James Chen on 2019/10/23.
//  Copyright © 2019 James Chen. All rights reserved.
//

import Foundation

extension Dictionary {
  public func element(at index: Int) -> Dictionary<Key, Value>.Element {
    return self[self.index(startIndex, offsetBy: index)]
  }

  public var first: Dictionary<Key, Value>.Element? {
    guard startIndex != endIndex else { return nil }
    return self[self.index(startIndex, offsetBy: 0)]
  }

  public var last: Dictionary<Key, Value>.Element? {
    guard startIndex != endIndex else { return nil }
    return self[self.index(startIndex, offsetBy: self.count - 1)]
  }
}

extension Dictionary.Keys {
  public subscript(index: Int) -> Element {
    return self[self.index(startIndex, offsetBy: index)]
  }

  public var first: Element? {
    guard startIndex != endIndex else { return nil }
    return self[self.index(startIndex, offsetBy: 0)]
  }

  public var last: Element? {
    guard startIndex != endIndex else { return nil }
    return self[self.index(startIndex, offsetBy: self.count - 1)]
  }
}

extension Dictionary.Values {
  public subscript(index: Int) -> Element {
    return self[self.index(startIndex, offsetBy: index)]
  }

  public var first: Element? {
    guard startIndex != endIndex else { return nil }
    return self[self.index(startIndex, offsetBy: 0)]
  }

  public var last: Element? {
    guard startIndex != endIndex else { return nil }
    return self[self.index(startIndex, offsetBy: self.count - 1)]
  }
}
