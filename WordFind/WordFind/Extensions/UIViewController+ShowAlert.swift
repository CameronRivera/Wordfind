//
//  UIViewController+ShowAlert.swift
//  WordFind
//
//  Created by Cameron Rivera on 9/7/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title: String?, _ message: String?, _ completion: ((UIAlertAction) -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: completion)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
