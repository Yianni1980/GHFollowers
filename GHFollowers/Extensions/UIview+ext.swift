//
//  UIview+ext.swift
//  GHFollowers
//
//  Created by ioannis on 17/6/23.
//

import UIKit
extension UIView {
    func addSubViews (_ views: UIView...){
        for view in views { addSubview(view)}
        
    }
}
