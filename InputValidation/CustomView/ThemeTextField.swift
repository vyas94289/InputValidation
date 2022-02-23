//
//  TextFieldWithError.swift
//  InputValidation
//
//  Created by Gaurang on 23/02/22.
//

import UIKit

class ThemeTextField: UITextField {
    @IBOutlet weak var errorLabel: UILabel? {
        didSet {
            self.updateErrorMessage(withText: errorMessage, animated: false)
        }
    }
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = " \(title) "
            titleLabel.sizeToFit()
        }
    }
    @IBInspectable var placeholderColor: UIColor = UIColor.gray
    @IBInspectable var smallStyle: Bool = false
    @IBInspectable var extraSmallStyle: Bool = false
    @IBInspectable var thirteenFontStyle: Bool = false
    
    var errorMessage: String? {
        didSet(error) {
            self.updateErrorMessage(withText: error, animated: true)
        }
    }
    
    var lineView: UIView!
    var titleLabel: UILabel!
    let defaultHeight: CGFloat = 44
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
    
    private final func initTextField() {
        borderStyle = .none
        setPaddings()
        createLineView()
        createTitleLabel()
        updateColors()
        setFonts()
    }
    
    private func setPaddings() {
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: padding, height: 1))
        self.rightViewMode = .always
        self.rightView = UIView(frame: CGRect.init(x: 0, y: 0, width: padding, height: 1))
    }
    
    private func setFonts() {
        font = UIFont.systemFont(ofSize: 14)
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: placeholderColor,
                                                                     NSAttributedString.Key.font: font!])
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
        return .init(width: bounds.width, height: defaultHeight)
    }
    
    override var isEnabled: Bool {
        didSet {
            updateColors()
        }
    }
    
    private func updateErrorMessage(withText text: String?, animated: Bool) {
        errorLabel?.isHidden = errorMessage == nil
        errorLabel?.text = errorMessage
        guard animated else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 5,
                       options: .curveEaseInOut, animations: {
                        self.errorLabel?.superview?.layoutIfNeeded()
                       })
        
    }
}

extension ThemeTextField {
    
    func isValidInput(type: InputValidation) -> Bool {
        let validation = type.isValid(input: self.text ?? "", field: self.title)
        if validation.isValid {
            return true
        } else {
            self.errorMessage = validation.error
            return false
        }
    }
    
    func addCountryCodeButton(onButtonTapped: @escaping EmptyClosure) {
        let countryCodeButton: CountyPickerButton = UIView.fromNib()
        countryCodeButton.title = "+91"
        countryCodeButton.onButtonTapped = onButtonTapped
        self.leftView = countryCodeButton
        self.leftViewMode = .always
        countryCodeButton.translatesAutoresizingMaskIntoConstraints = false
        countryCodeButton.heightAnchor.constraint(equalToConstant: self.defaultHeight - 14).isActive = true
    }
}
