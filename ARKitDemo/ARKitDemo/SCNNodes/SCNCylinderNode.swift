//
//  SCNCylinderNode.swift
//  BodyDetection
//
//  Created by James Chen on 2019/10/29.
//  Copyright © 2019 James Chen. All rights reserved.
//

import SceneKit

class SCNCylinderNode: SCNNode {
  var startNode: SCNNode {
    didSet {
      updatePosition()
    }
  }

  var endNode: SCNNode {
    didSet {
      updatePosition()
    }
  }

  var color: UIColor {
    didSet {
      geometry?.firstMaterial?.diffuse.contents = color
    }
  }

  private var _geometry: SCNCylinder?
  internal override var geometry: SCNGeometry? {
    get {
      return _geometry
    }
    set {
      super.geometry = newValue
      _geometry = newValue as? SCNCylinder
    }
  }

  init(startNode: SCNNode, endNode: SCNNode, radius: CGFloat = 0.01) {
    self.startNode = startNode
    self.endNode = endNode
    color = UIColor.red
    super.init()
    let geometry = SCNCylinder(radius: radius, height: CGFloat(distance(simd_float3(startNode.position), simd_float3(endNode.position))))
    geometry.firstMaterial?.diffuse.contents = color
    _geometry = geometry
    let node = SCNNode(geometry: geometry)
    node.eulerAngles.x = Float.pi / 2
    addChildNode(node)
    constraints = [SCNLookAtConstraint(target: endNode)]
  }

  required init?(coder: NSCoder) {
    startNode = SCNNode()
    endNode = SCNNode()
    color = UIColor.red
    super.init(coder: coder)
  }

  private func updatePosition() {
    let x = (startNode.position.x + endNode.position.x) / 2
    let y = (startNode.position.y + endNode.position.y) / 2
    let z = (startNode.position.z + endNode.position.z) / 2
    position = SCNVector3(x, y, z)
  }

  private func updateLength() {
    if let geometry = geometry as? SCNCylinder {
      geometry.height = CGFloat(distance(simd_float3(startNode.position), simd_float3(endNode.position)))
    }
  }
}
