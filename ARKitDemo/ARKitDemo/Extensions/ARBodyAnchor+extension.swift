//
//  ARBodyAnchor+extension.swift
//  BodyDetection
//
//  Created by James Chen on 2019/12/5.
//  Copyright © 2019 James Chen. All rights reserved.
//

import ARKit

extension ARBodyAnchor {
  @nonobjc public func absTransform(for jointName: ARSkeleton.JointName) -> simd_float4x4? {
    guard let modelTransform = skeleton.modelTransform(for: jointName) else {
      return nil
    }
    return transform * modelTransform
  }
}
