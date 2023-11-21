//
//  UIViewController+ext.swift
//  GHFollowers
//
//  Created by ioannis on 17/6/23.
//


import UIKit
import SafariServices

extension UIViewController {
    
    func presentGFAlert(title:String,message:String,buttonTitle:String) {
        
        let alertVC                     = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        self.present(alertVC, animated: true)
        
    }
    
    func presentDefaultError() {
        
        let alertVC                     = GFAlertVC(title: "Something Went Wrong  ", message:"We were unable to complete yoru task at this time, Please try again", buttonTitle: "OK")
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        self.present(alertVC, animated: true)
        
    }
    
    
    func presentSafariVC(with url:URL)  {
        let safariVC                       = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC,animated: true)
    }
    
}
