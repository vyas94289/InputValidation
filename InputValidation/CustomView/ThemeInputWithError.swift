//
//  ThemeInputWithError.swift
//  InputValidation
//
//  Created by Gaurang on 21/02/22.
//

import UIKit
import MaterialComponents

extension MDCOutlinedTextField {
    
    @IBInspectable var themeStyle: Bool {
        get {
            return true
        }
        set {
            setThemeStyle()
        }
    }
    
    @IBInspectable var title: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    func setThemeStyle() {
        self.setLeadingAssistiveLabelColor(.red, for: .normal)
        self.setLeadingAssistiveLabelColor(.red, for: .editing)
        self.setOutlineColor(.purple, for: .editing)
        self.setOutlineColor(.gray, for: .normal)
        self.setFloatingLabelColor(.purple, for: .editing)
        self.setFloatingLabelColor(.gray, for: .normal)
    }
    
    var errorMessage: String? {
        get {
            self.leadingAssistiveLabel.text
        }
        set {
            self.updateErrorMessage(newValue)
        }
    }
    
    func updateErrorMessage(_ error: String?) {
        self.leadingAssistiveLabel.text = error
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func isValidInput(type: InputValidation) -> Bool {
        let validation = type.isValid(input: self.text ?? "", field: self.title ?? "")
        if validation.isValid {
            return true
        } else {
            self.errorMessage = validation.error
            return false
        }
    }
}

