//
//  Compare.swift
//  BodyDetection
//
//  Created by James Chen on 2019/11/11.
//  Copyright © 2019 James Chen. All rights reserved.
//

import Foundation

enum Compare: Int {
  typealias RawValue = Int
  
  case smaller = -1
  case equal = 0
  case bigger = 1
  
  init(a: Float, b: Float) {
    if a == b {
      self = .equal
    } else if a < b {
      self = .smaller
    } else {
      self = .bigger
    }
  }
  
  init(a: Int, b: Int) {
    if a == b {
      self = .equal
    } else if a < b {
      self = .smaller
    } else {
      self = .bigger
    }
  }
}
