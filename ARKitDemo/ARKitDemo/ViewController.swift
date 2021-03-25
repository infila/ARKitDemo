/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 The sample app's main view controller.
 */

import ARKit
import Combine
import RealityKit
import UIKit

class ViewController: UIViewController {
  @IBOutlet var arView: ARSCNView!

  let bodyNode = SCNNode()

  var nodes: [String: SCNSphereNode] = [:]
  var lines: [String: SCNCylinderNode] = [:]
  lazy var soundPromptManager = SoundPromptManager.shared

  let characterOffset: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left

  var tapPlacementAnchor: AnchorEntity?

  private var sessionInitSucceed = false
  private var isPositionSuitable = false
  private var frameCount: Int = 0

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.navigationController?.setNavigationBarHidden(false, animated: false)
    arView.delegate = self
    arView.scene.rootNode.addChildNode(bodyNode)
    // If the iOS device doesn't support body tracking, raise a developer error for
    // this unhandled case.
    guard ARBodyTrackingConfiguration.isSupported else {
      fatalError("This feature is only supported on devices with an A12 chip")
    }

    // Run a body tracking configration.
    let configuration = ARBodyTrackingConfiguration()
    arView.session.run(configuration)

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
}

extension ViewController {

  private func refreshNodes(for bodyAnchor: ARBodyAnchor) {
    bodyNode.transform = SCNMatrix4(bodyAnchor.transform)
    let skeleton = bodyAnchor.skeleton
    let jointTransforms = skeleton.jointModelTransforms
    for (i, jointTransform) in jointTransforms.enumerated() {
      let jointName = skeleton.definition.jointNames[i]
      let parentIndex = skeleton.definition.parentIndices[i]
      if nodes[jointName] == nil {
        let node = SCNSphereNode()
        nodes[jointName] = node
        bodyNode.addChildNode(node)
      }
      guard let node = nodes[jointName] else { continue }
      node.transform = SCNMatrix4(jointTransform)

      guard parentIndex >= 0 else { continue }
      let parentName = skeleton.definition.jointNames[parentIndex]
      guard let endNode = nodes[parentName] else { continue }

      if lines[jointName] == nil {
        let lineNode = SCNCylinderNode(startNode: node, endNode: endNode)
        lines[jointName] = lineNode
        bodyNode.addChildNode(lineNode)
      }
      guard let lineNode = lines[jointName] else { continue }
      lineNode.startNode = node
      lineNode.endNode = endNode
    }
  }
}

extension ViewController: ARSCNViewDelegate {
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let bodyAnchor = anchor as? ARBodyAnchor else { return }
    OperationQueue.main.addOperation {
      self.frameCount += 1
      self.refreshNodes(for: bodyAnchor)
    }
  }

  func session(_ session: ARSession, didFailWithError error: Error) {
    soundPromptManager.playSound(forText: "Initialization failed, try restart as well")
  }

  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    if !sessionInitSucceed {
//      soundPromptManager.playSound(forText: "Initialization succeed, please prepare for your swing")
      sessionInitSucceed = true
    }
  }
}
