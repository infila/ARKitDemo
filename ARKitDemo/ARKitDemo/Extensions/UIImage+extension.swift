//
//  UIImage+extension.swift
//  BodyDetection
//
//  Created by James Chen on 2019/11/27.
//  Copyright © 2019 James Chen. All rights reserved.
//

import UIKit

extension UIImage {
  
  public convenience init(pixelBuffer: CVPixelBuffer) {
    self.init(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
  }
  
  public func jpegDataSize() -> Int {
    let data = jpegData(compressionQuality: 1)
    return data?.count ?? -1
  }
}
