//
//  ViewController.swift
//  InputValidation
//
//  Created by Gaurang on 17/02/22.
//

import UIKit
import MaterialComponents
import IQKeyboardManagerSwift

class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var fullNameField: MDCOutlinedTextField!
    @IBOutlet weak var emailField: MDCOutlinedTextField!
    @IBOutlet weak var mobileField: MDCOutlinedTextField!
    @IBOutlet weak var usernameField: MDCOutlinedTextField!
    
    // MARK: - Variables
    private lazy var doneButton = UIBarButtonItem(title: "Go", style: .done, target: self, action: #selector(self.doneTapped))
    private lazy var validationWithField: [InputValidation: MDCOutlinedTextField] = [
        .name: fullNameField, .email: emailField, .mobile: mobileField, .username: usernameField
    ]
    private let countryCodeButton: CountyPickerButton = UIView.fromNib()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    // MARK: - Other methods
    private func setupView() {
        navigationItem.title = "Validation"
        navigationItem.rightBarButtonItem = doneButton
        
        countryCodeButton.title = "+91"
        countryCodeButton.onButtonTapped  = { [unowned self] in
            print(self.description, "Button tapped")
        }
        countryCodeButton.frame.size.width = 40
        countryCodeButton.frame.size.height = 40
        mobileField.leftView = countryCodeButton
        mobileField.leftViewMode = .always
        

    }
    
    private func isValidInput() -> Bool {
        var isValid = true
        for (type, textField) in validationWithField where textField.isValidInput(type: type) == false {
            isValid = false
        }
        return isValid
    }
    
    // MARK: - Actions
    @objc private func doneTapped() {
        view.endEditing(true)
        guard isValidInput() else {
            return
        }
        print("Valid")
    }
    
    @objc private func countryCodeTapped() {
        
    }
}

// MARK: - Textfield delegate
extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = self.validationWithField.first(where: { $0.value == textField}) else {
            return true
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= field.key.maxLimit
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        (textField as? MDCOutlinedTextField)?.errorMessage = nil
        return true
    }
    
}
