//
//  MazeView.swift
//  MazeGen
//
//  Created by Ido Mizrachi on 1/19/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit

class MazeView2: UIView {

    private let model: MazeModel
    var cellViews: [[Cell]] = []
    
    init(model: MazeModel, frame: CGRect) {
        self.model = model
//        let rows = self.model.cells.count
//        self.cellViews = []
//        for x in 0..<rows {
//            let row = self.model.cells[x]
//            var cellViewsRow:[Cell] = []
//            let columns = row.count
//            for y in 0..<columns {
//                let cellFrame = CGRect(x: x * Int(frame.size.width) / rows, y: y * Int(frame.size.height) / columns, width: Int(frame.size.width) / rows, height: Int(frame.size.height) / columns)
//                let cellView = Cell(model: row[y], frame: cellFrame)
//                cellViewsRow.append(cellView)
//            }
//            self.cellViews.append(cellViewsRow)
//        }
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
//        for x in 0..<self.cellViews.count {
//            let row = self.cellViews[x]
//            let columns = row.count
//            for y in 0..<columns {
//                self.addSubview(row[y])
//            }
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func generate() {
        guard self.model.isRunning == false else {
            return
        }
        clear()
        let rows = self.model.cells.count
        for x in 0..<rows {
            let row = self.model.cells[x]
            var cellViewsRow:[Cell] = []
            let columns = row.count
            for y in 0..<columns {
                let cellFrame = CGRect(x: x * Int(frame.size.width) / rows, y: y * Int(frame.size.height) / columns, width: Int(frame.size.width) / rows, height: Int(frame.size.height) / columns)
                let cellView = Cell(model: row[y], frame: cellFrame)
                cellViewsRow.append(cellView)
            }
            self.cellViews.append(cellViewsRow)
        }
        for x in 0..<self.cellViews.count {
            let row = self.cellViews[x]
            let columns = row.count
            for y in 0..<columns {
                self.addSubview(row[y])
            }
        }
        self.model.generate()
    }
    
    func stop() {
        self.model.isRunning = false
    }
    
    private func clear() {
        for x in 0..<self.cellViews.count {
            let row = self.cellViews[x]
            let columns = row.count
            for y in 0..<columns {
                row[y].removeFromSuperview()
            }
        }
        self.cellViews.removeAll()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.addRect(rect)
        
    }
 

}
