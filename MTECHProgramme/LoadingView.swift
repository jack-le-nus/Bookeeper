//
//  LoadingView.swift
//  MTECHProgramme
//
//  Created by Jack Le on 11/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import Foundation
import UIKit

public class LoadingView{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingView {
        struct Static {
            static let instance: LoadingView = LoadingView()
        }
        return Static.instance
    }
    
    public func show(view: UIView) {
    
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hide() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
