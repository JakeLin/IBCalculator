//
//  CalculatorView.swift
//  IBCalculator
//
//  Created by Jake Lin on 10/5/15.
//  Copyright © 2015 Jake Lin. All rights reserved.
//

import UIKit

@IBDesignable
class CalculatorView: UIView {
  let (columns, rows) = (4, 6) as (CGFloat, CGFloat)
  
  // basic buttons: all 1x1 unit
  let buttonRows = [ ["C", "=", "/", "*"], ["7", "8", "9", "-"], ["4", "5", "6", "+"], ["1", "2", "3"] ]
  
  // special cases: non-square or out of position
  let specialButtons = [("=", CGPoint(x: 3, y: 4), CGSize(width: 1, height: 2)),
    ("0", CGPoint(x: 0, y: 5), CGSize(width: 2, height: 1)),
    (".", CGPoint(x: 2, y: 5), CGSize(width: 1, height: 1))]
  
  // MARK: - IBInspectable
  
  @IBInspectable var faceColor: UIColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
  
  @IBInspectable var textColor: UIColor = UIColor.blackColor()
  @IBInspectable var textSize: CGFloat = 12
  
  @IBInspectable var buttonColor: UIColor = UIColor.whiteColor()
  @IBInspectable var edgeColor: UIColor = UIColor.blackColor()
  @IBInspectable var edgeWidth: CGFloat = 1
  
  @IBInspectable var shadowColor: UIColor = UIColor.blackColor()
  @IBInspectable var shadowOffset: CGFloat = 2
  
  @IBInspectable var cornerRadius: CGFloat = 7
  
  @IBInspectable var paddingX: CGFloat = 7
  @IBInspectable var paddingY: CGFloat = 8
  @IBInspectable var spacingX: CGFloat = 3
  @IBInspectable var spacingY: CGFloat = 5
  
  @IBInspectable var titleHeight: CGFloat = 20
  @IBInspectable var titleColor: UIColor = UIColor.whiteColor()
  @IBInspectable var titleBarColor: UIColor = UIColor.blackColor()
  
  // MARK: - Drawing
  
  override func drawRect(rect: CGRect) {
    
    // initial drawing setup
    
    // determine unit height/width from view size, padding and button spacing
    let unitHeight = (bounds.height - 2 * paddingY - (rows - 1) * spacingY - titleHeight) / rows
    let unitWidth = (bounds.width - 2 * paddingX - (columns - 1) * spacingX) / columns
    
    // set up text attributes
    let textFont = UIFont.systemFontOfSize(textSize)
    let textAttributes = [NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColor]
    
    // get the graphics context
    let context = UIGraphicsGetCurrentContext()
    
    // helper functions
    
    // maps a point and size (in units) to an actual rect in the view's coordinates for drawing
    func rectForPosition(position: CGPoint, andSize size: CGSize) -> CGRect {
      let x       = paddingX + unitWidth * position.x + spacingX * position.x
      let y       = titleHeight + paddingY + unitHeight * position.y + spacingY * position.y
      let width   = size.width * unitWidth + (size.width - 1) * spacingX
      let height  = size.height * unitHeight + (size.height - 1) * spacingY
      
      return pixelAlignedRect(CGRect(x: x, y: y, width: width, height: height))
    }
    
    // draw a button in the specified rect
    func drawButtonInRect(rect: CGRect, withText text: String) {
      shadowColor.setFill()
      UIRectFill(rect.offsetBy(dx: shadowOffset, dy: shadowOffset))
      
      buttonColor.setFill()
      edgeColor.setStroke()
      CGContextSetLineWidth(context, edgeWidth)
      UIRectFill(rect)
      UIRectFrame(rect)
      
      var textRect = rect
      if textRect.width != unitWidth {
        textRect.size.width = unitWidth
      }
      if textRect.height != unitHeight {
        textRect.origin.y = textRect.maxY - unitHeight
        textRect.size.height = unitHeight
      }
      text.drawAtPointInRect(textRect, withAttributes: textAttributes, andAlignment: .Center)
    }
    
    // draw the display
    func drawDisplayInRect(rect: CGRect, withText text: String) {
      buttonColor.setFill()
      edgeColor.setStroke()
      CGContextSetLineWidth(context, edgeWidth)
      UIRectFill(rect)
      UIRectFrame(rect)
      
      text.drawAtPointInRect(rect.offsetBy(dx: unitWidth / -3, dy: 0), withAttributes: textAttributes, andAlignment: .RightCenter)
    }
    
    /// Convert a rect to a pixel-aligned version, rounding position and size
    func pixelAlignedRect(var rect: CGRect) -> CGRect {
      rect.origin.x = round(rect.origin.x)
      rect.origin.y = round(rect.origin.y)
      rect.size.width = round(rect.size.width)
      rect.size.height = round(rect.size.height)
      
      return rect
    }
    
    // calculator "window" - paint the color of the title bar
    let window = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    titleBarColor.setFill()
    window.fill()
    
    // center the title in the title bar
    let title = "Calculator"
    let (titleRect, _) = bounds.divide(titleHeight, fromEdge: CGRectEdge.MinYEdge)
    let titleAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(textSize + 2), NSForegroundColorAttributeName: titleColor]
    title.drawAtPointInRect(titleRect, withAttributes: titleAttributes, andAlignment: .Center)
    
    // calculator "face" - covers most of the window
    let face = UIBezierPath(roundedRect: bounds.insetBy(dx: 0, dy: titleHeight / 2).offsetBy(dx: 0, dy: titleHeight / 2), cornerRadius: cornerRadius)
    faceColor.setFill()
    face.fill()
    
    // draw the display
    let displayRect = rectForPosition(CGPoint(x: 0, y: 0), andSize: CGSize(width: 4, height: 1))
    drawDisplayInRect(displayRect, withText: "3")
    
    // draw basic buttons
    for (rowNumber, row) in buttonRows.enumerate() {
      for (columnNumber, text) in row.enumerate() {
        drawButtonInRect(rectForPosition(CGPoint(x: columnNumber, y: rowNumber + 1), andSize: CGSize(width: 1, height: 1)), withText: text)
      }
    }
    
    // draw special buttons
    for buttonInfo in specialButtons {
      drawButtonInRect(rectForPosition(buttonInfo.1, andSize: buttonInfo.2), withText: buttonInfo.0)
    }
  }
}
