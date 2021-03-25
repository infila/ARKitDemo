//
//  ARSkeleton3D+extension.swift
//  BodyDetection
//
//  Created by James Chen on 2019/11/8.
//  Copyright © 2019 James Chen. All rights reserved.
//

import ARKit

extension ARSkeleton3D {
  var rootTransform: simd_float4x4? {
    return modelTransform(for: .root)
  }

  var headTransform: simd_float4x4? {
    return modelTransform(for: .head)
  }

  var leftShoulderTransform: simd_float4x4? {
    guard jointModelTransforms.count >= JointIndex.left_shoulder_1_joint.rawValue else {
      return nil
    }
    return modelTransform(for: .leftShoulder)
  }

  var rightShoulderTransform: simd_float4x4? {
    return modelTransform(for: .rightShoulder)
  }

  var leftHandTransform: simd_float4x4? {
    return modelTransform(for: .leftHand)
  }

  var rightHandTransform: simd_float4x4? {
    return modelTransform(for: .rightHand)
  }

  var leftFootTransform: simd_float4x4? {
    return modelTransform(for: .leftFoot)
  }

  var rightFootTransform: simd_float4x4? {
    return modelTransform(for: .rightFoot)
  }

  var leftArmTransform: simd_float4x4? {
    guard jointModelTransforms.count >= JointIndex.left_arm_joint.rawValue else {
      return nil
    }
    return jointModelTransforms[JointIndex.left_arm_joint.rawValue]
  }

  var rightArmTransform: simd_float4x4? {
    guard jointModelTransforms.count >= JointIndex.right_arm_joint.rawValue else {
      return nil
    }
    return jointModelTransforms[JointIndex.right_arm_joint.rawValue]
  }

  var leftLegTransform: simd_float4x4? {
    guard jointModelTransforms.count >= JointIndex.left_leg_joint.rawValue else {
      return nil
    }
    return jointModelTransforms[JointIndex.left_leg_joint.rawValue]
  }

  var rightLegTransform: simd_float4x4? {
    guard jointModelTransforms.count >= JointIndex.right_leg_joint.rawValue else {
      return nil
    }
    return jointModelTransforms[JointIndex.right_leg_joint.rawValue]
  }
}
