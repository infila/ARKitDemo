//
//  GlobalFunctions.swift
//  BodyDetection
//
//  Created by James Chen on 2019/11/22.
//  Copyright © 2019 James Chen. All rights reserved.
//

import Foundation

func synced(_ lock: Any, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
