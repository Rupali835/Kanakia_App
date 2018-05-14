//
//  StringValidation.swift
//  GenextTutors
//
//  Created by GENEXT-PC on 12/02/18.
//  Copyright © 2018 GeNextStudents. All rights reserved.
//

import Foundation


extension String
{
    
    func removeBlankSpace() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //[self  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    func isValidEmail() -> Bool {
      
      let testStr : String = self
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPhone() -> Bool {
        let testStr : String = self
        let PhoneRegEx = "[0-9]{10}"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", PhoneRegEx)
        return phoneTest.evaluate(with: testStr)
    }
    func isValidZip() -> Bool {
        
        let testStr : String = self
        let ZipRegEx = "[0-9]{6}"
        let ZipTest = NSPredicate(format:"SELF MATCHES %@", ZipRegEx)
        return ZipTest.evaluate(with: testStr)
    }
    
    func isAlphabetsOnly() -> Bool {
        let testStr : String = self
        let AlphabetsRegEx = "[A-Za-z]+"
        let AlphabetTest = NSPredicate(format:"SELF MATCHES %@", AlphabetsRegEx)
        return AlphabetTest.evaluate(with: testStr)
    }
    func isAlphaNumerics() -> Bool {
        let testStr : String = self
        let AlphaNumericsRegEx = "[A-Z0-9a-z]"
        let AlphaNumericTest = NSPredicate(format:"SELF MATCHES %@", AlphaNumericsRegEx)
        return AlphaNumericTest.evaluate(with: testStr)
    }
    
}
