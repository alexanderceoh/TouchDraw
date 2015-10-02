//
//  ViewController.swift
//  TouchDraw
//
//  Created by Alex Oh on 9/30/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var colorPallete: UICollectionView!
    
    @IBOutlet weak var controlPanelTop: NSLayoutConstraint!
    
    
    @IBOutlet weak var controlPanelView: UIView!
    
    @IBOutlet weak var toggleButton: ToggleButton!
    
    @IBAction func toggleControlPanel(sender: AnyObject) {
        
        
        // when we press the button, we're going to toggle the top constraint
        // if the controlPanelView == 0 then change the frame to -200 else 0
        
        
        self.controlPanelTop.constant = controlPanelView.frame.origin.y == 0 ? -200 : 0
        
        view.setNeedsUpdateConstraints()
        
        let degrees: CGFloat = controlPanelView.frame.origin.y == 0 ? 0 : 180
        
        UIView.animateWithDuration(0.4) { () -> Void in
            
            self.view.layoutIfNeeded()
            
            // this is to rotate the arrow for the toggle button
            
            let degreesToRadians: (CGFloat) ->CGFloat = {
                return $0 / 180.0 * CGFloat(M_PI)
            }
            
            let t = CGAffineTransformMakeRotation(degreesToRadians(degrees))
            self.toggleButton.transform = t
        
        
        }
        
    }
    
    let colorSource = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.controlPanelTop.constant = -200
        
        colorPallete.delegate = self
        colorPallete.dataSource = colorSource
        
        colorPallete.reloadData()
        
    }
    
    var chosenTool: Int = 0

    @IBAction func chooseTool(button: UIButton) {
        
        chosenTool = button.tag
        
        
    }
    
    var chosenColor: UIColor = UIColor.blackColor()
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        chosenColor = cell?.backgroundColor ?? UIColor.blueColor()
        
    }
    
    @IBAction func undo(sender: AnyObject) {
        
        if (view as? DrawView)?.lines.count > 0 {
        
            (view as? DrawView)?.lines.removeLast()
        
        view.setNeedsDisplay()
        }
    }
    
    @IBAction func clear(sender: AnyObject) {
        
        // this is kind of a fail safe; the two ?'s
        (view as? DrawView)?.lines = []
        
        view.setNeedsDisplay()
    }
    
    

    
    // the act of actually touching the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            switch chosenTool {
                
            case 1 :
                
                // SCRIBBLE
                
                let newScribble = Scribble()
                
                
                // we need the points of the touch
                newScribble.points.append(touch.locationInView(view))
                
                newScribble.strokeColor = chosenColor
                newScribble.strokeWidth = 10
                
                (view as? DrawView)?.lines.append(newScribble)
                
                
            case 2 :
                
                startShape(.Rectangle, withTouch: touch)
                
            case 3 :
                
                startShape(.Circle, withTouch: touch)
                
            case 4 :
                
                startShape(.Triangle, withTouch: touch)
                
            case 5 :
                
                startShape(.Diamond, withTouch: touch)
                
            default :
                
                // LINE
                
                let newLine = Line()
                
                newLine.start = touch.locationInView(view)
                newLine.strokeColor = chosenColor
                newLine.strokeWidth = 10
                
                
                (view as? DrawView)?.lines.append(newLine)
                
                

                
            }
            
            
            

            
            view.setNeedsDisplay()

            
        }
        
    }
    
    func startShape(type: ShapeType, withTouch touch: UITouch) {
        
        //// SHAPE
        
        let shape = Shape(type: type)
        
        shape.start = touch.locationInView(view)
        shape.fillColor = chosenColor
        
        (view as? DrawView)?.lines.append(shape)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            
            //// SCRIBBLE , if the last item in the last array is a scribble type it will do this
            
            if let currentScribble = (view as? DrawView)?.lines.last as? Scribble {
                
                currentScribble.points.append(touch.locationInView(view))
                
                view.setNeedsDisplay()
                
                
                
            //// LINE
                
            } else if let currentLine = (view as? DrawView)?.lines.last {
                
                currentLine.end = touch.locationInView(view)
                
                view.setNeedsDisplay()
            
            }
            
        }
        
    }

}

class Colors: NSObject, UICollectionViewDataSource {
    
    let fillColors = [
    
        UIColor.redColor(),
        UIColor.blackColor(),
        UIColor.cyanColor(),
        UIColor.orangeColor(),
        UIColor.purpleColor(),
        UIColor.magentaColor(),
        UIColor.blueColor(),
        UIColor.yellowColor(),
        UIColor.greenColor()
        
        
    ]
    
    let strokeColors = [
    
        UIColor.magentaColor(),
        UIColor.blueColor(),
        UIColor.yellowColor(),
        UIColor.greenColor()
        
    ]
    
    var isFill = true
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return isFill ? fillColors.count : strokeColors.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath)
        
        cell.backgroundColor = isFill ? fillColors[indexPath.item] : strokeColors[indexPath.item]
        
        return cell
    }
    
}

