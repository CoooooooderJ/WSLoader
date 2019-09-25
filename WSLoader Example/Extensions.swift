//
//  Extensions.swift
//  WSLoader Example
//
//  Created by Tina on 2019/9/25.
//  Copyright © 2019 Tina. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let pink = UIColor.rgb(r: 238, g: 180, b: 180)
}
