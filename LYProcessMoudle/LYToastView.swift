//
//  LYToastView.swift
//  LYProcessMoudle
//
//  Created by liyang on 2016/11/19.
//  Copyright © 2016年 liyang. All rights reserved.
//

import UIKit

public class LYToastViewManager {
    
    static var toastView:LYToastView?
    static var workItem:DispatchWorkItem?
    
    
    public class func show(onView:UIView?,msg:String){
        if let v = onView {
            workItem?.cancel()
            workItem = nil
            DispatchQueue.main.async {
                if nil == self.toastView {
                    self.toastView  =  LYToastView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    v.addSubview(self.toastView ?? UIView())
                }
                self.toastView?.midLable.text = msg
            }
           
            
        }
        workItem = DispatchWorkItem{
            toastView?.removeFromSuperview()
            toastView = nil
        }
        if let witem = self.workItem {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: witem)
        }
    }
    
}


class LYToastView: UIView {
    var bottomConstraint:NSLayoutConstraint?
    
    let backgroundImageView:UIImageView = { () -> UIImageView in
        var tmpbackgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 62, height: 62))
        tmpbackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        var image = UIImage(named: "toast_background")
        var tImage = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 100, bottom: 30, right: 100), resizingMode: UIImageResizingMode.stretch)
        tmpbackgroundImageView.image = tImage
        return tmpbackgroundImageView
    }()
    
    let leftImageView:UIImageView = { () -> UIImageView in
        var tmpLetfImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 62, height: 62))
        tmpLetfImageView.translatesAutoresizingMaskIntoConstraints = false
        tmpLetfImageView.image = UIImage(named: "toast_avatar")
        return tmpLetfImageView
    }()
    
    let midLable:UILabel = {() -> UILabel in
        
        var tmpMidLable = UILabel()
        tmpMidLable.numberOfLines   = 2
        tmpMidLable.textColor       = UIColor.white
        tmpMidLable.textAlignment   = .center
        tmpMidLable.translatesAutoresizingMaskIntoConstraints = false
        return tmpMidLable
    }()
    
    let rightImageView:UIImageView = { () -> UIImageView in
        var tmpRightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        tmpRightImageView.translatesAutoresizingMaskIntoConstraints = false
        tmpRightImageView.image = UIImage(named: "toast_button")
        return tmpRightImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImageView)
        self.addSubview(leftImageView)
        self.addSubview(midLable)
        self.addSubview(rightImageView)
        
        //addconstraint
        let leadingBGConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let topBGConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let bottomBGConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let trainingBGConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        self.addConstraints([leadingBGConstraint,topBGConstraint,bottomBGConstraint,trainingBGConstraint])
        
        //leftImageView constraint
        let leadingLIConstraint = NSLayoutConstraint(item: leftImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 5)
        
        let widthLIConstraint = NSLayoutConstraint(item: leftImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 62)
        
        let heightLIConstraint = NSLayoutConstraint(item: leftImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 62)
        
        let centerYLIConstraint = NSLayoutConstraint(item: leftImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        self.addConstraints([leadingLIConstraint,widthLIConstraint,heightLIConstraint,centerYLIConstraint])
        
        //rightImageView constraint
        let leadingRIConstraint = NSLayoutConstraint(item: rightImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -5)
        
        let widthRIConstraint = NSLayoutConstraint(item: rightImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 48)
        
        let heightRIConstraint = NSLayoutConstraint(item: rightImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 48)
        
        let centerYRIConstraint = NSLayoutConstraint(item: rightImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        self.addConstraints([leadingRIConstraint,widthRIConstraint,heightRIConstraint,centerYRIConstraint])
        
        //midLable constratin
        let leadingMLConstraint = NSLayoutConstraint(item: midLable, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: leftImageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
        
        let trainingMLConstraint = NSLayoutConstraint(item: midLable, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: rightImageView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: -10)
        
        let topMLConstraint = NSLayoutConstraint(item: midLable, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
        
        let bottomMLConstraint = NSLayoutConstraint(item: midLable, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -10)
        
        let weidhtMLConstraint = NSLayoutConstraint(item: midLable, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 10)
        self.addConstraints([leadingMLConstraint,trainingMLConstraint,topMLConstraint,bottomMLConstraint,weidhtMLConstraint])
        
        self.initKeyBoardNoticefication()
        
        
        
        
    }
    
    func initKeyBoardNoticefication(){
        UIApplication.shared.keyWindow?.endEditing(true)
        NotificationCenter.default.addObserver(self, selector: #selector(LYToastView.keyBoardWillChangeFrame(notificationa:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LYToastView.keyboardWillHide(notificationa:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyBoardWillChangeFrame(notificationa:Notification){
        if let info  = notificationa.userInfo , let endKeyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,let animationTime = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            
            self.bottomConstraint?.constant = -endKeyboardRect.size.height
            UIView.animate(withDuration: animationTime){
                
                self.superview?.layoutIfNeeded()
            }
            
            
        }
        
    }
    func keyboardWillHide(notificationa:Notification){
        
        if let info  = notificationa.userInfo ,let animationTime = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            self.bottomConstraint?.constant = -100
            UIView.animate(withDuration: animationTime){
                self.superview?.layoutIfNeeded()
            }
            
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        print("\(self) is die")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let s = self.superview {
            bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: s, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -100)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 70)
            
            let centerConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: s, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
            
            let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: s, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10)
            //                leadingConstraint.priority = UILayoutPriorityDefaultHigh
            let trainingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -10)
            //                trainingConstraint.priority = UILayoutPriorityDefaultHigh
            
            if let sb = bottomConstraint {
                s.addConstraints([sb,heightConstraint,leadingConstraint,trainingConstraint,centerConstraint,widthConstraint])
            }
        }
    }
}
