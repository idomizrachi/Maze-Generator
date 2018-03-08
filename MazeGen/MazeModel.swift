//
//  MazeModel.swift
//  MazeGen
//
//  Created by Ido Mizrachi on 1/19/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit

protocol MazeModelDelegate {
    func mazeModelDidUpdate()
}

class MazeModel {
    
    var delegate: MazeModelDelegate?
    let queue: DispatchQueue = DispatchQueue(label: "Maze Gen")
    var currentCell: CellModel? = nil
    var cells: [[CellModel]] = []
    var numberOfRows: Int = 10 {
        didSet {
            refreshCells()
        }
    }
    var numberOfColumns: Int = 10 {
        didSet {
            refreshCells()
        }
    }
    var diameter: CGFloat = 30.0
    
    var unvisitedCellsCount = 0
    var isRunning: Bool = false
    
    init(numberOfRows: Int, numberOfColumns: Int) {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        refreshCells()
//        for x in 0..<self.width {
//            var row:[CellModel] = []
//            for y in 0..<self.height {
//                let point: Point = Point(x: x, y: y)
//                let cellModel: CellModel = CellModel(point: point)
//                row.append(cellModel)
//            }
//            self.cells.append(row)
//        }
//        self.unvisitedCellsCount = self.width * self.height
//        self.currentCell = self.cells[0][0]
    }
    
    private func refreshCells() {
        self.cells.removeAll()
        for y in 0..<self.numberOfRows {
            var row:[CellModel] = []
            for x in 0..<self.numberOfColumns {
                let point: Point = Point(x: x, y: y)
                let cellModel: CellModel = CellModel(point: point)
                row.append(cellModel)
            }
            self.cells.append(row)
        }
        self.unvisitedCellsCount = self.numberOfRows * self.numberOfColumns
        self.currentCell = self.cells[0][0]
    }
    
    
    func generate() {
        if self.isRunning {
            return
        }
        self.isRunning = true
        self.queue.async { [weak self] in
            guard let `self` = self else { return }
            // https://en.wikipedia.org/wiki/Maze_generation_algorithm#Recursive_backtracker
            var stack: [CellModel] = []
            
            //1.
            self.currentCell = self.cells[0][0]
            self.currentCell!.visited = true
            self.unvisitedCellsCount -= 1
            //2.
            while self.unvisitedCellsCount > 0 {
                if self.isRunning == false {
                    break
                }
                //2.1.
                let neighbors = self.unvisitedNeighbors(cell: self.currentCell!)
                if neighbors.count > 0 {
                    //2.1.1
                    let randomNeighborIndex = Int(arc4random_uniform(UInt32(neighbors.count)))
                    let randomNeighbor = neighbors[randomNeighborIndex]
                    //2.1.2
                    stack.append(self.currentCell!)
                    //2.1.3
                    self.removeWalls(cell1: self.currentCell!, cell2: randomNeighbor)
                    //2.1.4
                    self.currentCell!.current = false
                    self.currentCell = randomNeighbor
                    self.currentCell!.current = true
                    self.currentCell!.visited = true
                    self.unvisitedCellsCount -= 1
                    Thread.sleep(forTimeInterval: 0.1)
                } else {
                    //2.2
                    if stack.count > 0 {
                        //2.2.1
                        self.currentCell!.current = false
                        self.currentCell = stack.remove(at: stack.count-1)
                        self.currentCell!.current = true

                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.mazeModelDidUpdate()
                }
            }
            print("Done")
            self.isRunning = false
        }

    }
    
    func unvisitedNeighbors(cell: CellModel) -> [CellModel] {
        var result: [CellModel] = []
        if cell.point.y-1 > 0 {
            let topNeighbor = self.cells[cell.point.y-1][cell.point.x]
            if topNeighbor.visited == false {
                result.append(topNeighbor)
            }
        }
        if cell.point.y+1 < self.numberOfRows {
            let bottomNeighbor = self.cells[cell.point.y+1][cell.point.x]
            if bottomNeighbor.visited == false {
                result.append(bottomNeighbor)
            }
        }
        if cell.point.x-1 > 0 {
            let leftNeighbor = self.cells[cell.point.y][cell.point.x-1]
            if leftNeighbor.visited == false {
                result.append(leftNeighbor)
            }
        }
        if cell.point.x+1 < self.numberOfColumns {
            let rightNeighbor = self.cells[cell.point.y][cell.point.x+1]
            if rightNeighbor.visited == false {
                result.append(rightNeighbor)
            }
        }
        return result
    }
    
    func removeWalls(cell1: CellModel, cell2: CellModel) {
        let xDiff = cell1.point.x - cell2.point.x
        let yDiff = cell1.point.y - cell2.point.y
        if xDiff < 0 {
            //cell2 is right neighbor
            cell1.remove(wall: .Right)
            cell2.remove(wall: .Left)
        } else if xDiff > 0 {
            //cell2 is left neighbor
            cell1.remove(wall: .Left)
            cell2.remove(wall: .Right)
        }
        if yDiff < 0 {
            //cell2 is bottom neighbor
            cell1.remove(wall: .Bottom)
            cell2.remove(wall: .Top)
        } else if yDiff > 0 {
            //cell2 is top neighbor
            cell1.remove(wall: .Top)
            cell2.remove(wall: .Bottom)            
        }
    }
    

}
