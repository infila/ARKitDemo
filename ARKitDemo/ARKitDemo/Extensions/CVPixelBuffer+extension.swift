//
//  CVPixelBuffer+extension.swift
//  BodyDetection
//
//  Created by James Chen on 2019/11/25.
//  Copyright © 2019 James Chen. All rights reserved.
//

import Accelerate
import AVFoundation
import CoreImage

let ciContext = CIContext()

extension CVPixelBuffer {
  func copy() -> CVPixelBuffer {
    precondition(CFGetTypeID(self) == CVPixelBufferGetTypeID(), "copy() cannot be called on a non-CVPixelBuffer")

    var _copy: CVPixelBuffer?

    CVPixelBufferCreate(
      nil,
      CVPixelBufferGetWidth(self),
      CVPixelBufferGetHeight(self),
      CVPixelBufferGetPixelFormatType(self),
      CVBufferGetAttachments(self, .shouldPropagate),
      &_copy)

    guard let copy = _copy else { fatalError() }

    CVPixelBufferLockBaseAddress(self, .readOnly)
    CVPixelBufferLockBaseAddress(copy, [])
    defer {
      CVPixelBufferUnlockBaseAddress(copy, [])
      CVPixelBufferUnlockBaseAddress(self, .readOnly)
    }

    for plane in 0 ..< CVPixelBufferGetPlaneCount(self) {
      let dest = CVPixelBufferGetBaseAddressOfPlane(copy, plane)
      let source = CVPixelBufferGetBaseAddressOfPlane(self, plane)
      let height = CVPixelBufferGetHeightOfPlane(self, plane)
      let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(self, plane)

      memcpy(dest, source, height * bytesPerRow)
    }

    return copy
  }

  func scale(_ scale: CGFloat) -> CVPixelBuffer? {
//    let startDate = Date()
    var image = CIImage(cvPixelBuffer: self)
    image = image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
    var output: CVPixelBuffer?
    CVPixelBufferCreate(nil,
                        Int(image.extent.width),
                        Int(image.extent.height),
                        CVPixelBufferGetPixelFormatType(self),
                        nil,
                        &output)
    guard output != nil else { return nil }
//    print(Date().timeIntervalSince(startDate))
    ciContext.render(image, to: output!)
//    print(Date().timeIntervalSince(startDate))
    return output
  }
}
