//
//  ImagesToVideoUtil.swift
//  BodyDetection
//
//  Created by James Chen on 2019/11/21.
//  Copyright © 2019 James Chen. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

typealias CXEMovieMakerCompletion = (URL) -> Void
typealias CXEMovieMakerUIImageExtractor = (AnyObject) -> UIImage?

public class ImagesToVideoUtils: NSObject {
  static let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
  static let tempPath = paths[0] + "/exportvideo.mp4"
  static let fileURL = URL(fileURLWithPath: tempPath)

  private var assetWriter: AVAssetWriter!
  private var writeInput: AVAssetWriterInput!
  private var bufferAdapter: AVAssetWriterInputPixelBufferAdaptor!
  private var videoSettings: [String: Any]!

  private var completionBlock: CXEMovieMakerCompletion?
  private var movieMakerUIImageExtractor: CXEMovieMakerUIImageExtractor?

  public class func videoSettings(width: Int, height: Int) -> [String: Any] {
    if Int(width) % 16 != 0 {
      print("warning: video settings width must be divisible by 16")
    }

    let videoSettings: [String: Any] = [AVVideoCodecKey: AVVideoCodecType.jpeg, // AVVideoCodecH264,
                                        AVVideoWidthKey: width,
                                        AVVideoHeightKey: height]
    return videoSettings
  }

  public init(videoSettings: [String: Any] = videoSettings(width: 640, height: 480)) {
    super.init()

    if FileManager.default.fileExists(atPath: ImagesToVideoUtils.tempPath) {
      guard (try? FileManager.default.removeItem(atPath: ImagesToVideoUtils.tempPath)) != nil else {
        print("remove path failed")
        return
      }
    }

    assetWriter = try! AVAssetWriter(url: ImagesToVideoUtils.fileURL, fileType: AVFileType.mov)

    self.videoSettings = videoSettings
    writeInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings)
    assert(assetWriter.canAdd(writeInput), "add failed")

    assetWriter.add(writeInput)
    let bufferAttributes: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB)]
    bufferAdapter = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writeInput, sourcePixelBufferAttributes: bufferAttributes)
  }

  func createMovie(urls: [URL], dateOfEachFrame: [Date], withCompletion: @escaping CXEMovieMakerCompletion) {
    var buffers: [CVPixelBuffer] = []
    for (i, url) in urls.enumerated() {
      guard let image = UIImage(data: try! Data(contentsOf: url)) else {
        print("Frames lost at index:%d", i)
        continue
      }
      guard let buffer = self.newPixelBufferFrom(cgImage: image.cgImage!) else {
        print("Frames lost at index:%d", i)
        continue
      }
      buffers.append(buffer)
    }
    createMovie(imagesBuffers: buffers, dateOfEachFrame: dateOfEachFrame, withCompletion: withCompletion)
  }

  func createMovie(images: [UIImage], dateOfEachFrame: [Date], withCompletion: @escaping CXEMovieMakerCompletion) {
    var buffers: [CVPixelBuffer] = []
    for (i, image) in images.enumerated() {
      guard let buffer = self.newPixelBufferFrom(cgImage: image.cgImage!) else {
        print("Frames lost at index:%d", i)
        continue
      }
      buffers.append(buffer)
    }
    createMovie(imagesBuffers: buffers, dateOfEachFrame: dateOfEachFrame, withCompletion: withCompletion)
  }

  func createMovie(images: [CIImage], dateOfEachFrame: [Date], withCompletion: @escaping CXEMovieMakerCompletion) {
    var buffers: [CVPixelBuffer] = []
    for (i, image) in images.enumerated() {
      guard let buffer = self.newPixelBufferFrom(ciImage: image) else {
        print("Frames lost at index:%d", i)
        continue
      }
      buffers.append(buffer)
    }
    createMovie(imagesBuffers: buffers, dateOfEachFrame: dateOfEachFrame, withCompletion: withCompletion)
  }

  func createMovie(imagesBuffers: [CVPixelBuffer], dateOfEachFrame: [Date], rotationAngle: CGFloat = 0, withCompletion: @escaping CXEMovieMakerCompletion) {
    assert(imagesBuffers.count == dateOfEachFrame.count, "Image and Date should have same count")
    completionBlock = withCompletion
    if rotationAngle != 0 {
      writeInput.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }

    assetWriter.startWriting()
    assetWriter.startSession(atSourceTime: CMTime.zero)

    let mediaInputQueue = DispatchQueue(label: "mediaInputQueue")
    var i = 0
    let frameNumber = imagesBuffers.count

    let startDate = dateOfEachFrame[0]
    writeInput.requestMediaDataWhenReady(on: mediaInputQueue) {
      while true {
        if i >= frameNumber {
          break
        }

        if self.writeInput.isReadyForMoreMediaData {
          let sampleBuffer = imagesBuffers[i]
          if i == 0 {
            self.bufferAdapter.append(sampleBuffer, withPresentationTime: CMTime.zero)
          } else {
            let date = dateOfEachFrame[i]
            let presentTime = CMTime(seconds: date.timeIntervalSince(startDate), preferredTimescale: 600)
            self.bufferAdapter.append(sampleBuffer, withPresentationTime: presentTime)
          }
          i = i + 1
        }
      }
      self.writeInput.markAsFinished()
      self.assetWriter.finishWriting {
        DispatchQueue.main.sync {
          self.completionBlock!(ImagesToVideoUtils.fileURL)
        }
      }
    }
  }

  private func newPixelBufferFrom(cgImage: CGImage) -> CVPixelBuffer? {
    let options: [String: Any] = [kCVPixelBufferCGImageCompatibilityKey as String: true, kCVPixelBufferCGBitmapContextCompatibilityKey as String: true]
    var pxbuffer: CVPixelBuffer?
    let frameWidth = videoSettings[AVVideoWidthKey] as! Int
    let frameHeight = videoSettings[AVVideoHeightKey] as! Int

    let status = CVPixelBufferCreate(kCFAllocatorDefault, frameWidth, frameHeight, kCVPixelFormatType_32ARGB, options as CFDictionary?, &pxbuffer)
    assert(status == kCVReturnSuccess && pxbuffer != nil, "newPixelBuffer failed")

    CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
    let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: pxdata, width: frameWidth, height: frameHeight, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pxbuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
    assert(context != nil, "context is nil")

    context!.concatenate(CGAffineTransform.identity)
    context!.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
    CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
    return pxbuffer
  }

  private func newPixelBufferFrom(ciImage: CIImage) -> CVPixelBuffer? {
    guard let image = UIImage(ciImage: ciImage).cgImage else { return nil }
    return newPixelBufferFrom(cgImage: image)
  }
}
