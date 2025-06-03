//
//  LocalizationHelper.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-08.
//

import Foundation

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
