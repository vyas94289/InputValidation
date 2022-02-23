//
//  TextFieldWithError.swift
//  InputValidation
//
//  Created by Gaurang on 23/02/22.
//

import UIKit

class ThemeTextField: UITextField {
    
    // MARK: - Views
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
    private var titleLabel: UILabel!
    private let borderLayer = CALayer()
    // MARK: - Variables
    var errorMessage: String? {
        didSet(error) {
            self.updateErrorMessage(withText: error, animated: true)
        }
    }
    
    // MARK: - Constants
    private let placeholderColor: UIColor = .gray
    private let defaultHeight: CGFloat = 44
    private let padding: CGFloat = 10
    private var lineColor: UIColor {
        if isEnabled {
            return .purple
        } else {
            return .gray
        }
    }
    
    // MARK: - Views overridden methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTextField()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors()
        setFonts()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = self.bounds
    }
    
    override open var intrinsicContentSize: CGSize {
        return .init(width: bounds.width, height: defaultHeight)
    }
    
    override var isEnabled: Bool {
        didSet {
            updateColors()
        }
    }
    
    // MARK: - Other methods
    private final func initTextField() {
        borderStyle = .none
        setPaddings()
        createTitleLabel()
        updateColors()
        setFonts()
        createBorderLayer()
    }
    
    private func createBorderLayer() {
        borderLayer.borderWidth = 1
        borderLayer.cornerRadius = 5
        borderLayer.bounds = self.frame
        self.layer.insertSublayer(borderLayer, at: 0)
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
    
    private func createTitleLabel() {
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
    
    private func updateColors() {
        borderLayer.borderColor = lineColor.cgColor
        self.textColor = .black
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
