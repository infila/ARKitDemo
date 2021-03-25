//
//  SCNTextNode.swift
//  BodyDetection
//
//  Created by James Chen on 2020/10/15.
//  Copyright © 2020 James Chen. All rights reserved.
//

import SceneKit

class SCNTextNode: SCNNode {
  var text: String? {
    didSet {
      guard let sText = _geometry as? SCNText else {
        return
      }
      sText.string = text
    }
  }
  
  private var fontSize: CGFloat
  
  private var color: UIColor {
    didSet {
      geometry?.firstMaterial?.diffuse.contents = color
    }
  }

  private var _geometry: SCNGeometry?
  internal override var geometry: SCNGeometry? {
    get {
      return _geometry
    }
    set {
      super.geometry = newValue
      _geometry = newValue
    }
  }

  init(text: String, fontSize: CGFloat) {
    self.text = text
    self.fontSize = fontSize
    color = UIColor.blue
    super.init()
    let sText = SCNText(string: text, extrusionDepth: 5)
    sText.font = UIFont.systemFont(ofSize: fontSize)
    geometry = sText
    geometry?.firstMaterial?.diffuse.contents = color
  }

  required init?(coder: NSCoder) {
    text = ""
    fontSize = 16
    color = UIColor.blue
    super.init(coder: coder)
  }
}
