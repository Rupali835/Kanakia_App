//
//  AppStoryboards.swift
//  AppStoryboards
//
//  Created by Gurdeep on 15/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    
    case Main, Mrms, Pms
    
    var instance : UIStoryboard {
        print(self.rawValue)
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    

}

extension UIViewController
{
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    

}
