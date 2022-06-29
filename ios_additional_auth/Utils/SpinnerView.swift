//
//  SpinnerView.swift
//  ios_additional_auth
//
//  Created by Bedirhan Turhan on 29.06.2022.
//

import UIKit

fileprivate var aView : UIView?
fileprivate var returning : Bool = false

extension UIViewController {
    func showSpinner(){
        returning = true
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        
        Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { t in
            self.removeSpinner()
            
            
        }
    }
    
    func removeSpinner(){
        returning = false
        aView?.removeFromSuperview()
        aView = nil
    }
    
    fileprivate func alertAction(_title: String, _message: String, actionG : @escaping() -> ()){
        let alert = UIAlertController(title:_title,
                                    message: _message,
                                    preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            actionG()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
