//
//  AppDelegate.swift
//  NavigationDrawer
//
//  Created by Sowrirajan Sugumaran on 12/11/17.
//  Copyright © 2017 Sowrirajan Sugumaran. All rights reserved.
//

import UIKit

class SPKeyBoardAvoiding: UIScrollView, UIScrollViewDelegate {

    // Get a touched view which is contained by Scroll view.
    open override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool
    {
        if view .isKind(of: UITextField.self)
        {
            let textField:UITextField = view as! UITextField
            self.isScrollEnabled = true
            var rect = textField.bounds
            rect = textField.convert(rect, to: self)
            var points:CGPoint = rect.origin
            points.x = 0
            
            let model = UIDevice.current.model
            print("\(UIDevice().type.rawValue)")
            print("textfielposition=\(textField.frame.origin.y)")
            if model == "iPad"
            {
                switch UIDevice().type.rawValue
                {
                case "simulator/sandbox","iPad 5":
                    
                    break
                case "iPad Air 2","iPad Air 1","iPad Pro 9.7\" cellular","iPad Pro 12.9\" cellular":
                    points.y -= 90//self.frame.size.height/2 - 80
                    
                    if textField.frame.origin.y >= 140
                    {
                        self.setContentOffset(points, animated: true)
                    }
                    break
                default:
                    print("No Match")
                }
                
            }else{
               switch UIDevice().type.rawValue
                {
                case "iPhone 5S","iPhone SE":
                    points.y -= 150//self.frame.size.height/2 - 80
                
                    if textField.frame.origin.y >= 140
                    {
                        self.setContentOffset(points, animated: true)
                    }
                break
                case "iPhone 6S","iPhone 6","iPhone 6 Plus","iPhone 6S Plus","iPhone 7","iPhone 7 Plus","iPhone 8","iPhone 8 Plus","iPhone X":
                    points.y -= self.frame.size.height/2 - 100
                    
                    if textField.frame.origin.y >= 158
                    {
                        self.setContentOffset(points, animated: true)
                    }
                    
                    break
                default:
                   print("No Match")
                }
                
            }
        }else{
            if view .isKind(of: UITextView.self)
            {
                let textField:UITextView = view as! UITextView
                self.isScrollEnabled = true
                var rect = textField.bounds
                rect = textField.convert(rect, to: self)
                var points:CGPoint = rect.origin
                points.x = 0
                
                let model = UIDevice.current.model
                print("\(UIDevice().type.rawValue)")
                if model == "iPad"
                {
                    switch UIDevice().type.rawValue
                    {
                    case "simulator/sandbox","iPad 5":
                        
                        break
                    case "iPad Air 2","iPad Air 1","iPad Pro 9.7\" cellular","iPad Pro 12.9\" cellular":
                        points.y -= 90//self.frame.size.height/2 - 80
                        
                        if textField.frame.origin.y >= 140
                        {
                            self.setContentOffset(points, animated: true)
                        }
                        break
                    default:
                        print("No Match")
                    }
                    
                }else{
                    
                    print("textfielposition=\(textField.frame.origin.y)")
                    
                    switch UIDevice().type.rawValue
                    {
                    case "iPhone 5S","iPhone SE":
                        points.y -= self.frame.size.height/2 - 80
                        
                        if textField.frame.origin.y >= 140
                        {
                            self.setContentOffset(points, animated: true)
                        }
                        break
                    case "iPhone 6S","iPhone 6","iPhone 6 Plus","iPhone 6S Plus","iPhone 7","iPhone 7 Plus","iPhone 8","iPhone 8 Plus","iPhone X":
                        points.y -= self.frame.size.height/2 - 100
                        
                        if textField.frame.origin.y >= 216
                        {
                            self.setContentOffset(points, animated: true)
                        }
                        
                        break
                    default:
                        print("No Match")
                    }
                    
                }
            }
        }
         return true
    }
  
}
