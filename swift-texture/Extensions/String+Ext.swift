//
//  String+Ext.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import Foundation

extension String {
    
    func ifEmpty(_ string: String) -> String {
        return isEmpty ? string : self
    }
}
