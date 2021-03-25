//
//  SoundPromptManager.swift
//  BodyDetection
//
//  Created by James Chen on 2019/10/21.
//  Copyright © 2019 James Chen. All rights reserved.
//

import UIKit
import AVKit

class SoundPromptManager: NSObject {
  static let shared = SoundPromptManager()

  private(set) var lastPlayDate: Date?
  private(set) var timeInterval: Double = 0.1
  private(set) var isSpeaking: Bool = false
  
  private var speech: AVSpeechSynthesizer = AVSpeechSynthesizer()
  
  private override init() {
    super.init()
    speech.delegate = self
  }
  
  func playSound(forText message: String, immediately: Bool = false) {
    if Thread.isMainThread {
      speak(forText: message, immediately: immediately)
    } else {
      OperationQueue.main.addOperation {
        self.speak(forText: message, immediately: immediately)
      }
    }
  }
  
  private func speak(forText message: String, immediately: Bool = false) {
    if immediately {
      speech.stopSpeaking(at: .immediate)
    } else if speech.isSpeaking ||
      (lastPlayDate != nil && abs(lastPlayDate?.timeIntervalSince(Date()) ?? 0) < timeInterval) {
      return
    }
    let utterance = AVSpeechUtterance(string: message)
    speech.speak(utterance)
  }
}


extension SoundPromptManager: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    isSpeaking = true
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    isSpeaking = false
    lastPlayDate = Date()
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    isSpeaking = false
  }
}
