//
//  CGSize+Geometry.swift
//  Luna
//
//  Created by Andrew Shepard on 6/18/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    var middle: CGPoint {
        let midX = floor(width / 2)
        let midY = floor(height / 2)
        return CGPoint(x: midX, y: midY)
    }
}
