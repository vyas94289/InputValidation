//
//  ThemePickerButton.swift
//  InputValidation
//
//  Created by Gaurang on 25/02/22.
//

import UIKit

class ThemePickerButton: UIControl {
    
    // MARK: - Inspectable
    @IBInspectable var text: String? = nil {
        didSet {
            placeholderLabel.text = text
        }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = " \(title) "
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            configImageView()
        }
    }
    
    @IBInspectable var downArrow: Bool = false {
        didSet {
            rightImage = UIImage(systemName: "chevron.down")
        }
    }
    
    // MARK: - Views
    private var placeholderLabel: UILabel!
    private var titleLabel: UILabel!
    private var imageView: UIImageView?
    private let borderLayer = CALayer()
    
    // MARK: - Variable and Constants
    private let padding: CGFloat = 10
    private var lineColor: UIColor {
        isEnabled ? .purple : .gray
    }
    
    // MARK: - View Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    
    override open var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 44)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = self.bounds
    }
    
    // MARK: - Custom methods
    func setViews() {
        drawLineLayer()
        createPlaceholderLabel()
        createTitleLabel()
        addActions()
    }
    
    private func drawLineLayer() {
        borderLayer.borderWidth = 1
        borderLayer.cornerRadius = 5
        borderLayer.bounds = self.frame
        borderLayer.borderColor = lineColor.cgColor
        self.layer.insertSublayer(borderLayer, at: 0)
    }
    
    private func createPlaceholderLabel() {
        placeholderLabel = UILabel()
        placeholderLabel.textColor = .black
        placeholderLabel.font = .systemFont(ofSize: 14)
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func createTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textColor = .purple
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.backgroundColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: -6)
        ])
        
    }
    
    private func configImageView() {
        imageView?.removeFromSuperview()
        if let image = self.rightImage?.withRenderingMode(.alwaysOriginal) {
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            self.imageView = imageView
        }
    }
    
    // MARK: - Actions
    private func addActions() {
        addTarget(self, action: #selector(touchStart), for: .touchDown)
        addTarget(self, action: #selector(touchEnd), for: .touchUpInside)
        addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
    }
    
    @objc func touchStart() {
        print("Touch start")
        self.alpha = 0.5
    }
    
    @objc func touchEnd() {
        self.alpha = 1
        print("Touch end")
    }
    
    @objc func touchDragExit() {
        self.alpha = 1
        print("Touch drag Exit")
    }
    
    // MARK: - Expand
    var isExpanded: Bool = false {
        didSet {
            startArrowAnimation()
        }
    }
    private func startArrowAnimation() {
        guard downArrow, let imageView = self.imageView else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 5,
                       options: .curveEaseInOut, animations: {
                        imageView.transform = self.isExpanded ? .init(rotationAngle: -.pi) : .identity
                       })
        
    }
    
}

extension UIView {
    func setAllSideContraints(_ insets: UIEdgeInsets) {
        guard let view = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
    }
}
