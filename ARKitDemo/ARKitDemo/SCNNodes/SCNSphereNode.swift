//
//  SCNSphereNode.swift
//  BodyDetection
//
//  Created by James Chen on 2019/10/18.
//  Copyright © 2019 James Chen. All rights reserved.
//

import SceneKit

class SCNSphereNode: SCNNode {
  var radius: CGFloat

  var color: UIColor {
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

  init(radius: CGFloat = 0.02) {
    self.radius = radius
    color = UIColor.red
    super.init()
    geometry = SCNSphere(radius: radius)
    geometry?.firstMaterial?.diffuse.contents = UIColor.red
  }

  required init?(coder: NSCoder) {
    radius = 0
    color = UIColor.red
    super.init(coder: coder)
  }
}
