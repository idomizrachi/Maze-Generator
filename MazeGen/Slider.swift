//
//  Slider.swift
//  Slider
//
//  Created by Ido Mizrachi on 1/25/18.
//  Copyright © 2018 Ido Mizrachi. All rights reserved.
//

import UIKit

class Slider: UIView, UIGestureRecognizerDelegate {
    
    //MARK: Public
    var valueChanged: ((Int) -> ())?
    
    var minValue: Int = 0
    var maxValue: Int = 10
    var value: Int = 0
    var progress: CGFloat = 0.0
    
    var progressColor: UIColor = .lightGray
    //backgroundColor - from UIView
    var textColor: UIColor = .white {
        didSet {
            self.label.textColor = textColor
            self.imageView.tintColor = textColor
        }
    }
    var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue?.withRenderingMode(.alwaysTemplate)
            self.imageView.tintColor = self.textColor
        }
    }
    
    var imageWidth: CGFloat = 40 {
        didSet {
            self.imageWidthConstraint?.constant = self.imageWidth
        }
    }
    
    var imageHeight: CGFloat = 40 {
        didSet {
            self.imageHeightConstraint?.constant = self.imageHeight
        }
    }
    
    
    //MARK: Private - State
    private var previousLocation: CGPoint? = nil
    private var initialLayout:Bool = true
    //MARK: Private - Subviews
    private lazy var label: UILabel = {
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(frame: CGRect.zero)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(self.label)
        stackView.addArrangedSubview(self.imageView)
        return stackView
    }()
    
    private lazy var progressView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    
    //MARK: UIView - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.progressView)
        self.addSubview(self.stackView)
        self.addGestureRecognizer(self.panGesture)
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.darkGray
        self.setupConstraints()
        self.refreshProgressViewFrame()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.initialLayout {
            self.initialLayout = false
            self.progressView.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.size.height, width: self.bounds.size.width, height: 0.0)
        }
    }
    
    private func setupConstraints() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageWidthConstraint = self.imageView.widthAnchor.constraint(equalToConstant: self.imageWidth)
        self.imageHeightConstraint = self.imageView.heightAnchor.constraint(equalToConstant: self.imageHeight)
        let centerX = self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerY = self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([centerX, centerY, imageWidthConstraint!, imageHeightConstraint!])
    }
    
    //MARK: Private - methods
    @objc func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.previousLocation = gestureRecognizer.location(in: self)
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
            })
        case .changed:
            let location = gestureRecognizer.location(in: self)
            if let previousLocation = self.previousLocation {
                let diff: CGFloat = previousLocation.y - location.y
                self.progress += diff * 0.01
                if self.progress < 0.0 {
                    self.progress = 0.0
                }
                if self.progress > 1.0 {
                    self.progress = 1.0
                }
                print(self.progress)
                self.refreshProgressViewFrame()
            }
            previousLocation = location
        case .ended:
            reset()
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.previousLocation = touches.first!.location(in: self)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        reset()
    }
    
    func reset() {
        self.previousLocation = nil
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @objc func panGesture(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .changed:
            let location = gestureRecognizer.location(in: self)
            if let previousLocation = self.previousLocation {
                let diff: CGFloat = previousLocation.y - location.y
                self.progress += diff * 0.01
                if self.progress < 0.0 {
                    self.progress = 0.0
                }
                if self.progress > 1.0 {
                    self.progress = 1.0
                }
                print(self.progress)
                self.refreshProgressViewFrame()
            }
            previousLocation = location
        case .ended, .cancelled:
            reset()
        default:
            break
        }
    }
    
    
    func refreshProgressViewFrame() {
        var progressFrame = self.progressView.frame
        progressFrame.origin.y = self.bounds.size.height - self.progress * self.bounds.size.height
        progressFrame.size.height = self.bounds.size.height * self.progress
        self.progressView.frame = progressFrame
        var progressValue:Int = Int(self.progress * (CGFloat(self.maxValue - self.minValue))) + self.minValue
        if progressValue <= 0 {
            progressValue = self.minValue
        }
        self.value = progressValue
        self.valueChanged?(progressValue)
        let progressString: String = "\(progressValue)"
        self.label.text = progressString
    }
    

}
