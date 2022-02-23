//
//  ThemeEditText.swift
//  InputValidation
//
//  Created by Gaurang on 23/02/22.
//

import UIKit
import IQKeyboardManagerSwift

class ThemeEditText: IQTextView {
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = " \(title) "
            titleLabel.sizeToFit()
        }
    }

    private var titleLabel: UILabel!
    private let borderLayer = CALayer()
    
    private let placeholderColor: UIColor = .gray
    private let padding: CGFloat = 10
    private var lineColor: UIColor = .purple
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
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
    
    private final func setupView() {
        setPaddings()
        createTitleLabel()
        updateColors()
        setFonts()
        createBorderLayer()
        clipsToBounds = false
    }
    
    private func setPaddings() {
        self.textContainerInset = .init(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    private func createBorderLayer() {
        borderLayer.borderWidth = 1
        borderLayer.cornerRadius = 5
        borderLayer.bounds = self.frame
        self.layer.insertSublayer(borderLayer, at: 0)
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

}
