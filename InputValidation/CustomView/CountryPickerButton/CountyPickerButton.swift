//
//  CountyPickerButton.swift
//  InputValidation
//
//  Created by Gaurang on 22/02/22.
//

import UIKit

typealias EmptyClosure = () -> Void

class CountyPickerButton: UIView {
    
    @IBOutlet weak var button: UIButton!
    
    var onButtonTapped: EmptyClosure?
    
    var title: String? {
        get {
            button.title(for: .normal)
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        onButtonTapped?()
    }
    
}


extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
