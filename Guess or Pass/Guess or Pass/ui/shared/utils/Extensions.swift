//
//  Extensions.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import Foundation

extension String {
    func singularForm() -> String {
        var singularForm = self

        if self.hasSuffix("s") && self.count > 1 {
            singularForm.removeLast()
        }

        return singularForm
    }
}
