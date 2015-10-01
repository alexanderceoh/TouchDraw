//
//  DrawView.swift
//  TouchDraw
//
//  Created by Alex Oh on 9/30/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    // creating an array of lines
    // since Scribble is a subclass of Line, because anything a Line can do, a Scribble can do
    // var lines = [Line]()
    
    var lines = [Line]()
    

    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        
        UIColor.magentaColor().set()
        
        for line in lines {
            
            
            // unwrapping the start and end lines
            if let start = line.start, let end = line.end {
            
                // asking does the line have a fillColor, if it does we are going to do something with it
                if let fillColor = line.fillColor {
                
                    fillColor.set()
                    
                    if let shape = line as? Shape {
                        
                        let width = end.x - start.x
                        let height = end.y - start.y
                        
                        let rect = CGRect(x: start.x, y: start.y, width: width, height: height)
                        
                        // ?? -> if shape.type hasn't been set, then set it as Rectangle
                        switch shape.type ?? . Rectangle {
                            
                        case .Circle :
                            
                            CGContextFillEllipseInRect(context, rect)
                            
                        case .Triangle :
                            
                            let top = CGPoint(x: width / 2 + start.x, y: start.y)
                            let right = end
                            let left = CGPoint(x: start.x, y: end.y)
                            
                            // starting with the top point
                            CGContextMoveToPoint(context, top.x, top.y)
                            
                            // then adding points to the right and the left
                            CGContextAddLineToPoint(context, right.x, right.y)
                            CGContextAddLineToPoint(context, left.x, left.y)
                            
                            // we're connecting to the top for stroke purposes, but don't need for fill
                            CGContextAddLineToPoint(context, top.x, top.y)
                            
                            // then fill will automatically connect the last point to the first point and fill it in
                            CGContextFillPath(context)
                            
                        case .Rectangle :
                            
                            CGContextFillRect(context, rect)
                            
                            
                        case .Diamond :
                            
                            let top = CGPoint(x: width / 2 + start.x, y: start.y)
                            let right = CGPoint(x: end.x, y: height / 2 + start.y)
                            let left = CGPoint(x: start.x, y: height / 2 + start.y)
                            let bottom = CGPoint(x: width / 2 + start.x, y: end.y)
                            
                            
                            CGContextMoveToPoint(context, top.x, top.y)
                            CGContextAddLineToPoint(context, right.x, right.y)
                            CGContextAddLineToPoint(context, bottom.x, bottom.y)
                            CGContextAddLineToPoint(context, left.x, left.y)
                            
                            // closes the diamond
                            CGContextAddLineToPoint(context, top.x, top.y)
                            
                            CGContextFillPath(context)
                        
                            
                        }
                        
                    }
                    
                    
                    
                }
                
                if let strokeColor = line.strokeColor {
                    
                    strokeColor.set()
                    
                    CGContextSetLineWidth(context, line.strokeWidth)
                    
                    
                    // create a point when you click during Scribble
                    CGContextSetLineCap(context, .Round)
                    CGContextSetLineJoin(context, .Round)
                    
                    // creating the path you will draw on
                    CGContextMoveToPoint(context, start.x, start.y)
                    
                    
//                    if line is Scribble { }
                    
                    if let scribble = line as? Scribble {
                        
                        CGContextAddLines(context, scribble.points, scribble.points.count)
                        
                    }
                    
                    CGContextAddLineToPoint(context, end.x, end.y)
                    // actually drawing the path
                    CGContextStrokePath(context)
                    
                }
                
                
                
            }
            
        }
        
        
        
/* showing creating rectangles and images on top of images
        
        UIColor.magentaColor().set()
        
        // sets both the stroke and fill
        
        
        // each subsequent draw is drawing on top of the image beforehand
        
        CGContextFillEllipseInRect(context, CGRect(x: 10, y: 10, width: 200, height: 100))
        
        UIColor.cyanColor().set()
        
        CGContextStrokeRect(context, CGRect(x: 200, y: 10, width: 100, height: 100))
        
*/


/* showing paths, i.e stencils
        
        
        // a path will be like creating a stencil, it's not filled yet

        UIColor.magentaColor().set()
        
        // the ADDellipse is a stencil
        CGContextAddEllipseInRect(context, CGRect(x: 20, y: 20, width: 200, height: 200))
        
        CGContextStrokePath(context)
        
        CGContextAddEllipseInRect(context, CGRect(x: 100, y: 100, width: 200, height: 200))
        
        UIColor.cyanColor().set()
        
        // the color will be that last one you set, before you CGContextFILLpath
        // Everytime you fill, it empties the stencil
        CGContextFillPath(context)
    
*/
 
/* creating lines from point to point
        
        
        UIColor.magentaColor().set()
        
        CGContextMoveToPoint(context, 20, 20)
        
        CGContextAddLineToPoint(context, 200, 100)
        
        CGContextMoveToPoint(context, 200, 200)
        
        CGContextAddLineToPoint(context, 200, 100)
        
        CGContextStrokePath(context)
   
*/
    }
    
}

class Line {
    
    var start: CGPoint?
    var end: CGPoint?
    
    var strokeColor: UIColor?
    var fillColor: UIColor?
    
    var strokeWidth: CGFloat = 0
    // CGFloat has a decimal like a Double, but it is specifically built for Core Graphics

}


class Scribble : Line {
    
    var points = [CGPoint]() {
        
        didSet {
            
            start = points.first
            end = points.last
            
        }
        
    }
    
}

enum ShapeType {
    
    case Rectangle, Circle, Triangle, Diamond
    
}

class Shape: Line {
    
    var type: ShapeType!
    
    init(type: ShapeType) {
        
        self.type = type
        
    }
    
}
