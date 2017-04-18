//
//  ViewControllerExtension.swift
//  MTECHProgramme
//
//  Created by Jack Le on 11/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import Foundation
import UIKit
import FlatUIKit

extension UIViewController {
    func alert(content:String) {
        alert(content:content, onCancel: {
            action -> Void in
        })
    }
    
    func alert(content:String, onCancel: @escaping ()->()) {
        let alertView:FUIAlertView = FUIAlertView()
        alertView.title = "Notification"
        alertView.message = content
        alertView.addButton(withTitle: "OK")
        alertView.titleLabel.textColor = UIColor.clouds()
        alertView.titleLabel.font = UIFont.boldFlatFont(ofSize: 16)
        alertView.messageLabel.textColor = UIColor.clouds()
        alertView.messageLabel.font = UIFont.boldFlatFont(ofSize: 14)
        alertView.backgroundOverlay.backgroundColor = UIColor.clouds().withAlphaComponent(0.8)
        alertView.alertContainer.backgroundColor = UIColor.midnightBlue()
        alertView.defaultButtonColor = UIColor.clouds()
        alertView.defaultButtonShadowColor = UIColor.asbestos()
        alertView.defaultButtonFont = UIFont.boldFlatFont(ofSize: 16)
        alertView.defaultButtonTitleColor = UIColor.asbestos()
        
        alertView.onCancelAction = {
            action->Void in
            
            onCancel()
        }
        
        alertView.show()
    }
    
    func applyTheme() {
//        self.view.backgroundColor = UIColor(fromHexCode: "#ECF3F4")
    }
    
    func showSpinner(view: UIView) {
        LoadingView.sharedInstance.show(view: view)
    }
    
    func hideSpinner() {
        LoadingView.sharedInstance.hide()
    }
    
}
