//
//  UIViewController+ShowAlert.swift
//  WordFind
//
//  Created by Cameron Rivera on 9/7/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title: String?, _ message: String?, _ firstActionText: String? = nil, _ secondActionText: String? = nil, _ completion: ((UIAlertAction) -> ())? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: firstActionText ?? "Confirm", style: .default, handler: completion)
        
        alertController.addAction(confirmAction)
        
        if let second = secondActionText {
            let secondAction = UIAlertAction(title: second, style: .default, handler: nil)
            alertController.addAction(secondAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
}
