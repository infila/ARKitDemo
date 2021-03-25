//
//  ARSkeletonJointName+extension.swift
//  BodyDetection
//
//  Created by James Chen on 2019/11/18.
//  Copyright © 2019 James Chen. All rights reserved.
//

import ARKit

extension ARSkeleton.JointName {
  // 上颌/下颌
  public static var jaw: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "jaw_joint")
  }

  // 下巴
  public static var chin: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "chin_joint")
  }

  public static var neckMid: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "neck_2_joint")
  }

  public static var nose: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "nose_joint")
  }

  public static var hip: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "hips_joint")
  }

  public static var leftArm: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "left_arm_joint")
  }

  public static var rightArm: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "right_arm_joint")
  }

  public static var leftForeArm: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "left_forearm_joint")
  }

  public static var rightForeArm: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "right_forearm_joint")
  }
  
  public static var leftUpLeg: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "left_upLeg_joint")
  }

  public static var rightUpLeg: ARSkeleton.JointName {
    return ARSkeleton.JointName(rawValue: "right_upLeg_joint")
  }
}
