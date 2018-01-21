//
//  MazeModel.swift
//  MazeGen
//
//  Created by Ido Mizrachi on 1/19/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit


class MazeModel {
    
    let queue: DispatchQueue = DispatchQueue(label: "Maze Gen")
    var currentCell: CellModel? = nil
    var cells: [[CellModel]] = []
    var width: Int
    var height: Int
    var unvisitedCellsCount = 0
    var isRunning: Bool = false
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        for x in 0..<self.width {
            var row:[CellModel] = []
            for y in 0..<self.height {
                let point: Point = Point(x: x, y: y)
                let cellModel: CellModel = CellModel(point: point)
                row.append(cellModel)
            }
            self.cells.append(row)
        }
        self.unvisitedCellsCount = self.width * self.height
        self.currentCell = self.cells[0][0]
    }
    
    func generate() {
        if self.isRunning {
            return
        }
        self.isRunning = true
        self.queue.async {
            // https://en.wikipedia.org/wiki/Maze_generation_algorithm#Recursive_backtracker
            var stack: [CellModel] = []
            
            //1.
            self.currentCell = self.cells[0][0]
            self.currentCell!.visited = true
            self.unvisitedCellsCount -= 1
            //2.
            while self.unvisitedCellsCount > 0 {
                Thread.sleep(forTimeInterval: 0.05)
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
                } else {
                    //2.2
                    if stack.count > 0 {
                        //2.2.1
                        self.currentCell!.current = false
                        self.currentCell = stack.remove(at: 0)
                        self.currentCell!.current = true

                    }
                }
            }
            self.isRunning = false
        }

    }
    
    func unvisitedNeighbors(cell: CellModel) -> [CellModel] {
        var result: [CellModel] = []
        if cell.point.y-1 > 0 {
            let topNeighbor = self.cells[cell.point.x][cell.point.y-1]
            if topNeighbor.visited == false {
                result.append(topNeighbor)
            }
        }
        if cell.point.y+1 < self.height {
            let bottomNeighbor = self.cells[cell.point.x][cell.point.y+1]
            if bottomNeighbor.visited == false {
                result.append(bottomNeighbor)
            }
        }
        if cell.point.x-1 > 0 {
            let leftNeighbor = self.cells[cell.point.x-1][cell.point.y]
            if leftNeighbor.visited == false {
                result.append(leftNeighbor)
            }
        }
        if cell.point.x+1 < width {
            let rightNeighbor = self.cells[cell.point.x+1][cell.point.y]
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
