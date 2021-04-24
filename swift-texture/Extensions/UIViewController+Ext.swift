//
//  UIViewController+Ext.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 24/04/21.
//

import UIKit

extension UIViewController {
 
    func presentAlertWithField(title: String? = nil,
                               message: String? = nil,
                               text: String? = nil,
                               placeholder: String? = nil,
                               onSave: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let field = alert.textFields![0]
            onSave(field.text ?? "")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
