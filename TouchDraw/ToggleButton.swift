//
//  ToggleButton.swift
//  TouchDraw
//
//  Created by Alex Oh on 10/1/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit



@IBDesignable class ToggleButton: UIButton {

    @IBInspectable var strokeWidth: CGFloat = 1
    
    @IBInspectable var circleInset: CGFloat = 10
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        let insetRect = CGRectInset(rect, circleInset, circleInset)
        
        tintColor.set()
        
        CGContextSetLineWidth(context, strokeWidth)
        
        CGContextStrokeEllipseInRect(context, insetRect)
        
        
        
        
        let midX = CGRectGetMidX(rect)
        let midY = CGRectGetMidY(rect)
        
        // this is the button triangle
        CGContextMoveToPoint(context, circleInset + 10, midY - 3)
        CGContextAddLineToPoint(context, midX, midY + 6)
        CGContextAddLineToPoint(context, rect.width - circleInset - 10, midY - 3)
        
        CGContextStrokePath(context)
        
    }
    

}
