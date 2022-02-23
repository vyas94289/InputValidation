//
//  File.swift
//  InputValidation
//
//  Created by Gaurang on 22/02/22.
//

import UIKit

class TextFieldWithError: UITextField {
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = " \(title) "
            titleLabel.sizeToFit()
        }
    }
    @IBInspectable var errorMessage: String? {
        didSet {
            toggleErrorLabel()
        }
    }
    @IBInspectable var placeholderColor: UIColor = UIColor.gray
    @IBInspectable var smallStyle: Bool = false
    @IBInspectable var extraSmallStyle: Bool = false
    @IBInspectable var thirteenFontStyle: Bool = false

    var lineView: UIView!
    var errorLabel: UILabel!
    var titleLabel: UILabel!
    private let defaultHeight: CGFloat = 44
    private let padding: CGFloat = 10

    var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }

    var lineColor: UIColor {
        if isEnabled {
            return UIColor.purple.withAlphaComponent(thirteenFontStyle ? 0.33 : 1)
        } else {
            return .clear
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initTextField()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTextField()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors()
        setFonts()
    }

    fileprivate final func initTextField() {
        borderStyle = .none
        createLineView()
        createTitleLabel()
        createErrorLabel()
        updateColors()
        setFonts()
    }

    func setFonts() {
        font = UIFont.systemFont(ofSize: 14)
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: placeholderColor,
                                                                     NSAttributedString.Key.font: font!])
    }
    
    private func createErrorLabel() {
        errorLabel = UILabel()
        errorLabel.font = UIFont.systemFont(ofSize: 13)
        errorLabel.textColor = .red
        self.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func toggleErrorLabel() {
        errorLabel.isHidden = errorMessage == nil
        errorLabel.text = errorMessage
        errorLabel.layoutIfNeeded()
        invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    fileprivate func createLineView() {

        if lineView == nil {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false
            lineView.layer.borderWidth = 1
            lineView.layer.cornerRadius = 5
            self.lineView = lineView
        
        }

        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(lineView)
    }

    func createTitleLabel() {
        if titleLabel == nil {
            let titleLabel = UILabel()
            titleLabel.textColor = .purple
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            titleLabel.backgroundColor = .white
            titleLabel.frame.origin.y = -6
            titleLabel.frame.origin.x = padding
            self.titleLabel = titleLabel
        }

        titleLabel.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin]
        addSubview(titleLabel)
    }

    open func updateColors() {
        lineView?.layer.borderColor = lineColor.cgColor
        self.textColor = thirteenFontStyle ? .gray : .black
    }

    /// Invoked by layoutIfNeeded automatically
    override open func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: defaultHeight)
    }

    override open var intrinsicContentSize: CGSize {
        if errorMessage == nil {
            return .init(width: bounds.width, height: defaultHeight)
        } else {
            return .init(width: bounds.width, height: defaultHeight + errorLabel.frame.height)
        }
        
    }
    
    func errorHeight() -> CGFloat {
        if errorMessage == nil {
            return 0
        }
        if let titleLabel = errorLabel,
            let font = titleLabel.font {
            return font.lineHeight
        }
        return 15.0
    }
    
    
    /**
    Calculate the rectangle for the textfield when it is not being edited
    - parameter bounds: The current bounds of the field
    - returns: The rectangle that the textfield should render in
    */
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: padding)
    }

    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: padding)
    }

    /**
     Calculate the rectangle for the placeholder
     - parameter bounds: The current bounds of the placeholder
     - returns: The rectangle that the placeholder should render in
     */
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: padding)
    }
    
    
    override var isEnabled: Bool {
        didSet {
            updateColors()
        }
    }
}
