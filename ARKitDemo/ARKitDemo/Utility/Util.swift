//
//  Util.swift
//  BodyDetection
//
//  Created by James Chen on 2019/10/18.
//  Copyright © 2019 James Chen. All rights reserved.
//

import ARKit

class Util {
  static func printSimd4x4(name:String = "", simd4x4: simd_float4x4) {
    NSLog("%@:\n{%f, %f, %f, %f\n%f, %f, %f, %f\n%f, %f, %f, %f\n%f, %f, %f, %f}\n", name, simd4x4.columns.0.x, simd4x4.columns.0.y, simd4x4.columns.0.z, simd4x4.columns.0.w, simd4x4.columns.1.x, simd4x4.columns.1.y, simd4x4.columns.1.z, simd4x4.columns.1.w,simd4x4.columns.2.x, simd4x4.columns.2.y, simd4x4.columns.2.z, simd4x4.columns.2.w,simd4x4.columns.3.x, simd4x4.columns.3.y, simd4x4.columns.3.z, simd4x4.columns.3.w)
  }
  
  static func printPosition(name:String = "", simd4x4: simd_float4x4) {
    NSLog("%@:\n{%f, %f, %f, %f}\n", name, simd4x4.columns.3.x, simd4x4.columns.3.y, simd4x4.columns.3.z, simd4x4.columns.3.w)
  }
  
  static func distance(a: simd_float4x4, b: simd_float4x4, ignoreZ: Bool = false) -> Float {
    return distance(a: positionFromTransform(transform: a), b: positionFromTransform(transform: b), ignoreZ: ignoreZ)
  }
  
  static func distance(a: simd_float3, b: simd_float3, ignoreZ: Bool = false) -> Float {
    if ignoreZ {
      return sqrtf(pow((a.x - b.x), 2) + pow((a.y - b.y), 2))
    }
    return sqrtf(pow((a.x - b.x), 2) + pow((a.y - b.y), 2) + pow((a.z - b.z), 2))
  }
  
  static func bAngle(a: simd_float3, b: simd_float3, c: simd_float3, ignoreZ: Bool = false) -> Float {
    let ab = distance(a: a, b: b, ignoreZ: ignoreZ)
    let bc = distance(a: b, b: c, ignoreZ: ignoreZ)
    let ac = distance(a: a, b: c, ignoreZ: ignoreZ)
    let angleB = acos((pow(ab, 2) + pow(bc, 2) - pow(ac, 2)) / (2 * ab * bc))
    return angleB * 180 / Float.pi
  }
  
  static func bAngle(a: simd_float4x4, b: simd_float4x4, c: simd_float4x4, ignoreZ: Bool = false) -> Float {
    let ap = positionFromTransform(transform: a)
    let bp = positionFromTransform(transform: b)
    let cp = positionFromTransform(transform: c)
    return self.bAngle(a: ap, b: bp, c: cp, ignoreZ: ignoreZ)
  }
  
  static func bAngle(a: simd_float4x4?, b: simd_float4x4?, c: simd_float4x4?, ignoreZ: Bool = false) -> Float? {
    guard let a = a, let b = b, let c = c else {
      return nil
    }
    let ap = positionFromTransform(transform: a)
    let bp = positionFromTransform(transform: b)
    let cp = positionFromTransform(transform: c)
    return self.bAngle(a: ap, b: bp, c: cp, ignoreZ: ignoreZ)
  }
  
  static func positionFromTransform(transform: simd_float4x4) -> simd_float3 {
    let position = transform.columns.3
    return simd_float3(position.x / position.w, position.y / position.w, position.z / position.w)
  }
  
  static func midTransform(start: simd_float4x4, end: simd_float4x4) -> simd_float4x4 {
    var trans = simd_inverse(start) * end
    trans.columns.3.x /= 2
    trans.columns.3.y /= 2
    trans.columns.3.z /= 2
    return start * trans
  }
}
