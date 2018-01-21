//
//  Cell.swift
//  MazeGen
//
//  Created by Ido Mizrachi on 1/18/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit

class Cell: UIView, CellModelDelegate {
    
    var model: CellModel
    
    init(model: CellModel, frame: CGRect) {
        self.model = model
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.model.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        var point = CGPoint(x: rect.size.width, y: 0)
        if (self.model.walls.contains(.Top)) {
            path.addLine(to: point)
            path.stroke()
        } else {
            path.move(to: point)
        }
        point = CGPoint(x: rect.size.width, y: rect.size.height)
        if (self.model.walls.contains(.Right)) {
            path.addLine(to: point)
            path.stroke()
        } else {
            path.move(to: point)
        }
        point = CGPoint(x: 0, y: rect.size.height)
        if (self.model.walls.contains(.Bottom)) {
            path.addLine(to: point)
            path.stroke()
        } else {
            path.move(to: point)
        }
        point = CGPoint(x: 0, y: 0)
        if (self.model.walls.contains(.Left)) {
            path.addLine(to: point)
            path.stroke()
        } else {
            path.move(to: point)
        }
        
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
    }
    
    func cellModelChanged() {
        self.setNeedsDisplay()        
    }

}
