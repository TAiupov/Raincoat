//
//  UIApplication+Extension.swift
//  Raincoat
//
//  Created by Тагир Аюпов on 2021-06-24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
