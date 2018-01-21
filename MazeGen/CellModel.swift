//
//  CellModel.swift
//  MazeGen
//
//  Created by Ido Mizrachi on 1/19/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit

protocol CellModelDelegate:class {
    func cellModelChanged()
}

struct Point {
    var x: Int
    var y: Int
}

enum Wall {
    case Top
    case Bottom
    case Left
    case Right
}


class CellModel {
    weak var delegate: CellModelDelegate? = nil
    var point: Point
    var current: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.cellModelChanged()
            }
        }
    }
    var visited: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.cellModelChanged()
            }
        }
    }
    var walls: [Wall] = [.Top, .Bottom, .Left, .Right]
    
    init(point: Point) {
        self.point = point
    }
    
    func remove(wall: Wall) {
        if let index = self.walls.index(of: wall) {
            self.walls.remove(at: index)
        }
        DispatchQueue.main.async {
            self.delegate?.cellModelChanged()
        }
    }
    
}
