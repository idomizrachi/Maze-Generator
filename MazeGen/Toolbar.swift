//
//  Toolbar.swift
//  MazeGen
//
//  Created by Ido Mizrachi on 2/12/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit

class Toolbar: UIView {
    var rowsChanged:((Int) -> ())?
    var columnsChanged:((Int) -> ())?
    var generatePressed:(() -> ())?
    
    lazy var rowsSlider: Slider = {
        let slider = Slider()
        slider.minValue = 2
        slider.maxValue = 50
        slider.image = UIImage(named: "rows")
        slider.imageWidth = 20
        slider.imageHeight = 20
        slider.valueChanged = { [weak self] (value: Int) -> () in
            guard let `self` = self else { return }
            self.rowsChanged?(value)
        }
        slider.refreshProgressViewFrame()
        return slider
    }()
    
    lazy var columnsSlider: Slider = {
        let slider = Slider()
        slider.minValue = 2
        slider.maxValue = 50
        slider.image = UIImage(named: "columns")
        slider.imageWidth = 20
        slider.imageHeight = 20
        slider.valueChanged = { [weak self] (value: Int) -> () in
            guard let `self` = self else { return }
            self.columnsChanged?(value)
        }
        slider.refreshProgressViewFrame()
        return slider
    }()
    
    lazy var generateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("▶", for: .normal)
        button.addTarget(self, action: #selector(generateButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var fillView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var slidersContainerView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.addArrangedSubview(self.rowsSlider)
        stackView.addArrangedSubview(self.columnsSlider)
        return stackView
    }()
    
    lazy var buttonsContainerView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(self.generateButton)
        return stackView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(self.slidersContainerView)
        stackView.addArrangedSubview(self.buttonsContainerView)
        stackView.addArrangedSubview(self.fillView)
        return stackView
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        sharedInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        self.addSubview(self.stackView)
        setupConstraints()
        self.layer.cornerRadius = 5
    }
    
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.rowsSlider.translatesAutoresizingMaskIntoConstraints = false
        self.columnsSlider.translatesAutoresizingMaskIntoConstraints = false
        self.fillView.translatesAutoresizingMaskIntoConstraints = false
        let top = self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
        let bottom = self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        let leading = self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        let trailing = self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        let rowsWidth = self.rowsSlider.widthAnchor.constraint(equalToConstant: 40)
        let columnsWidth = self.columnsSlider.widthAnchor.constraint(equalToConstant: 40)
        let slidersHeight = self.slidersContainerView.heightAnchor.constraint(equalToConstant: 100)
        NSLayoutConstraint.activate([top, bottom, leading, trailing, rowsWidth, columnsWidth, slidersHeight])
    }
    
    @objc func generateButtonPressed(sender: UIButton) {
        self.generatePressed?()
    }
    
}
