//
//  UIViewController+Ext.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 24/04/21.
//

import UIKit
import RxSwift

extension UIViewController {
 
    func presentAlertWithField(title: String? = nil,
                               message: String? = nil,
                               text: String? = nil,
                               placeholder: String? = nil) -> Single<String> {
        return Single.create { [weak self] single in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = text
                textField.placeholder = placeholder
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                let field = alert.textFields![0]
                single(.success(field.text ?? ""))
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true)
            
            return Disposables.create()
        }
    }
}
