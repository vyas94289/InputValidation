//
//  ViewController2.swift
//  InputValidation
//
//  Created by Gaurang on 22/02/22.
//

import UIKit
import IQKeyboardManagerSwift

class ViewController2: UIViewController {

    @IBOutlet weak var mobileTextfield: ThemeTextField!
    @IBOutlet weak var emailTextField: ThemeTextField!
    @IBOutlet var nameTextField: ThemeTextField!
    @IBOutlet weak var deliveryTypeSpinner: ThemePickerButton!
    
    private lazy var doneButton = UIBarButtonItem(title: "Go", style: .done, target: self, action: #selector(self.doneTapped))
    
    private lazy var validationWithField: [InputValidation: ThemeTextField] = [
        .name: nameTextField, .email: emailTextField, .mobile: mobileTextfield
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Validation"
        navigationItem.rightBarButtonItem = doneButton
        mobileTextfield.addCountryCodeButton(onButtonTapped: {
            
        })
        deliveryTypeSpinner.text = "Home"
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
    
    @IBAction func typePickerTapped() {
        deliveryTypeSpinner.isExpanded.toggle()
    }
}
// MARK: - Textfield delegate
extension ViewController2: UITextFieldDelegate {
    
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
        (textField as? ThemeTextField)?.errorMessage = nil
        return true
    }
    
}
