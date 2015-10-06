//
//  String+IBCalculator.swift
//  IBCalculator
//
//  Created by Jake Lin on 10/5/15.
//  Copyright © 2015 Jake Lin. All rights reserved.
//

import Foundation
import UIKit

extension String {
  /// Draw the `String` inside the bounding rectangle with a given alignment.
  func drawAtPointInRect(rect: CGRect, withAttributes attributes: [String: AnyObject]?, andAlignment alignment: NCStringAlignment) {
    let size = self.sizeWithAttributes(attributes)
    var x, y: CGFloat
    
    switch alignment {
    case .LeftTop, .LeftCenter, .LeftBottom:
      x = CGRectGetMinX(rect)
    case .CenterTop, .Center, .CenterBottom:
      x = CGRectGetMidX(rect) - size.width / 2
    case .RightTop, .RightCenter, .RightBottom:
      x = CGRectGetMaxX(rect) - size.width
    }
    
    switch alignment {
    case .LeftTop, .CenterTop, .RightTop:
      y = CGRectGetMinY(rect)
    case .LeftCenter, .Center, .RightCenter:
      y = CGRectGetMidY(rect) - size.height / 2
    case .LeftBottom, .CenterBottom, .RightBottom:
      y = CGRectGetMaxY(rect) - size.height
    }
    
    self.drawAtPoint(CGPoint(x: x, y: y), withAttributes: attributes)
  }
}
