//
//  ViewController.swift
//  MazeGen
//
//  Created by Ido Mizrachi on 2/12/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    lazy var toolbar: Toolbar = {
        let toolbar: Toolbar = Toolbar()
        toolbar.rowsChanged = { [weak self] (numberOfRows: Int) -> () in
            guard let strongSelf = self else { return }
            print("rows: \(numberOfRows)")
            if strongSelf.mazeModel.numberOfRows != numberOfRows {
                strongSelf.mazeModel.numberOfRows = numberOfRows
                var frame: CGRect = strongSelf.mazeView.frame
                frame.size.height = CGFloat(numberOfRows + 2) * strongSelf.mazeModel.diameter
                strongSelf.mazeView.frame = frame
                strongSelf.scrollView.contentSize = strongSelf.mazeView.bounds.size
                strongSelf.mazeView.setNeedsDisplay()
            }
        }
        toolbar.columnsChanged = { [weak self] (numberOfColumns: Int) -> () in
            guard let strongSelf = self else { return }
            if strongSelf.mazeModel.numberOfColumns != numberOfColumns {
                strongSelf.mazeModel.numberOfColumns = numberOfColumns
                var frame: CGRect = strongSelf.mazeView.frame
                frame.size.width = CGFloat(numberOfColumns + 2) * strongSelf.mazeModel.diameter
                strongSelf.mazeView.frame = frame
                strongSelf.scrollView.contentSize = strongSelf.mazeView.bounds.size
                strongSelf.mazeView.setNeedsDisplay()
            }
        }
        toolbar.generatePressed = { [weak self] () in
            guard let `self` = self else { return }
            print("generate")
            self.mazeModel.generate()
        }
        return toolbar
    }()
    
    lazy var mazeModel: MazeModel = {
        let mazeMode: MazeModel = MazeModel(numberOfRows: 10, numberOfColumns: 10)
        return mazeMode
    }()
    
    lazy var mazeView: MazeView = {
        let mazeView: MazeView = MazeView(model: self.mazeModel)
        self.mazeModel.delegate = mazeView
        mazeView.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
//        mazeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return mazeView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.contentSize = self.mazeView.bounds.size
        scrollView.addSubview(self.mazeView)
        scrollView.zoomScale = 1
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 10
        scrollView.bouncesZoom = true
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.black
        return scrollView
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.toolbar)
        setupConstraints()
        
        
//        self.mazeView.generate()
    }
    
    private func setupConstraints() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
//        self.mazeView.translatesAutoresizingMaskIntoConstraints = false
        self.toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        
        let toolbarTop = self.toolbar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32)
        let toolbarBottom = self.toolbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
        let toolbarLeading = self.toolbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        
        //let toolbarTrailing = self.toolbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        //let toolbarHeight = self.toolbar.heightAnchor.constraint(equalToConstant: 120)
    
        
        let scrollViewTop = self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
        let scrollViewLeading = self.scrollView.leadingAnchor.constraint(equalTo: self.toolbar.trailingAnchor)
        let scrollViewTrailing = self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let scrollViewBotton = self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
        
        NSLayoutConstraint.activate([scrollViewTop, scrollViewLeading, scrollViewTrailing, scrollViewBotton, toolbarTop, toolbarBottom, toolbarLeading])
        
//        let mazeViewTop = self.mazeView.topAnchor.constraint(equalTo: self.view.topAnchor)
//        let mazeViewLeading = self.mazeView.leadingAnchor.constraint(equalTo: self.toolbar.trailingAnchor)
//        let mazeViewTrailing = self.mazeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
//        let mazeViewBotton = self.mazeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//
//        NSLayoutConstraint.activate([toolbarTop, toolbarBottom, toolbarLeading, mazeViewTop, mazeViewBotton, mazeViewLeading, mazeViewTrailing])
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mazeView
    }

    
}
