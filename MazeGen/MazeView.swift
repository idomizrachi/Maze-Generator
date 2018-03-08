//
//  MazeView.swift
//  MazeGen
//
//  Created by Ido Mizrachi on 2/17/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit
class MazeView: UIView, MazeModelDelegate {
    private let model: MazeModel
    
    init(model: MazeModel) {
        self.model = model
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.clear(self.bounds)
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.gray.cgColor)
        for columns in self.model.cells {
            for cell in columns {
                drawCell(cell: cell, context: context)
            }
        }
    }
    
    public func generate() {
        guard self.model.isRunning == false else {
            return
        }
        self.model.generate()
    }
    
    
    private func drawCell(cell: CellModel, context: CGContext) {
        let width = self.model.diameter
        let height = self.model.diameter
        let x = CGFloat(cell.point.x) * width //+ 30
        let y = CGFloat(cell.point.y) * height //+ 30
        
        context.move(to: CGPoint(x: x, y: y))
        var point = CGPoint(x: x + width, y: y)
        if (cell.walls.contains(.Top)) {
            context.addLine(to: point)
            context.strokePath()
        }
        context.move(to: point)
        point = CGPoint(x: x + width, y: y + height)
        if (cell.walls.contains(.Right)) {
            context.addLine(to: point)
            context.strokePath()
        }
        context.move(to: point)
        point = CGPoint(x: x, y: y + height)
        if (cell.walls.contains(.Bottom)) {
            context.addLine(to: point)
            context.strokePath()
        }
        context.move(to: point)
        point = CGPoint(x: x, y: y)
        if (cell.walls.contains(.Left)) {
            context.addLine(to: point)
            context.strokePath()
        }
        context.move(to: point)
        
        /*
        var rect2 = rect
        rect2.origin.x += 2
        rect2.size.width -= 4
        rect2.origin.y += 2
        rect2.size.height -= 4
        let fillPath: UIBezierPath = UIBezierPath(rect: rect2)
        if self.model.current {
            UIColor.green.setFill()
            //        } else if self.model.visited {
            //            UIColor.green.setFill()
        } else {
            UIColor.clear.setFill()
        }
        fillPath.fill()
 */
    }
    
    func mazeModelDidUpdate() {
        self.setNeedsDisplay()
    }
}
