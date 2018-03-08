//
//  ViewController.swift
//  MazeGen
//
//  Created by Ido Mizrachi on 1/18/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
//    lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        return scrollView
//    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("Generate", for: .normal)
        button.frame = CGRect(x: 40, y: 40, width: 100, height: 60)
        return button
    }()
    
    lazy var mazeView: MazeView = {
        let mazeModel: MazeModel = MazeModel(width: 5, height: 8)
        let frame = CGRect(x: 20, y: 200, width: 300, height: 300)
        let mazeView: MazeView = MazeView(model: mazeModel, frame: frame)
        return mazeView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let point: Point = Point(x: 1, y: 1)
//        let cellModel = CellModel(point: point, visited: false, walls: [.Top, .Left])
//        let rect = CGRect(x: 100, y: 100, width: 100, height: 100)
//        let cell = Cell(model: cellModel, frame: rect)
//        cell.backgroundColor = UIColor.white
//        self.view.addSubview(cell)
//
        self.view.addSubview(self.button)
        
        self.button.addTarget(self, action: #selector(generateMaze(sender:)), for: .touchUpInside)
        self.view.addSubview(self.mazeView)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//            self.mazeView.stop()
//        }
    }
    
    @objc func generateMaze(sender: UIButton) {
        self.mazeView.generate()
    }

}

