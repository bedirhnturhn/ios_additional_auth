//
//  TextFieldChecks.swift
//  ios_additional_auth
//
//  Created by Bedirhan Turhan on 29.06.2022.
//


import UIKit

extension UIViewController {
    func isValidEmail(testStr:String?) -> Bool {
        guard let testStr = testStr else { return false }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.range(of: emailRegEx, options: .regularExpression )
        let result = range != nil ? true : false
        return result
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }

        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        
        //There’s at least one uppercase letter
        //There’s at least one lowercase letter
        //There’s at least one numeric digit
        //The text is at least 8 characters long
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        if (passwordTest.evaluate(with: testStr)){
            return true
        }else {
            return false
        }
    }
}

