//
//  LYProcessHUD.swift
//  LYProcessMoudle
//
//  Created by liyang on 2016/11/18.
//  Copyright © 2016年 liyang. All rights reserved.
//

import UIKit

public class LYProcessHUD: UIView {
    
    static let constantTag  = 668
    
    private static var iamgev:UIImageView = { () -> UIImageView in
        let rect =  CGRect(x: 0, y: 0, width: 75, height: 75)
        let imageview = UIImageView(frame: rect)
        var imageArrays:[UIImage] = []
        for i in 1..<15 {
            if let tmpI = UIImage(named: "load\(i)") {
                imageArrays.append(tmpI)
            }
        }
        imageview.animationImages = imageArrays
        return imageview
    }()
    
    private static var bgView:UIView = { () -> UIView in
        let view = UIView()
        view.addSubview(LYProcessHUD.iamgev)
        view.tag = constantTag
        
        return view
    }()
    
    public class func showOn(view:UIView?) -> UIView{
        if let _ = view?.viewWithTag(constantTag) {
            
            return LYProcessHUD.bgView
        }
        if let destinView = view {
            
            DispatchQueue.main.async {
                LYProcessHUD.bgView.center = destinView.center
                LYProcessHUD.bgView.frame  = destinView.bounds
                LYProcessHUD.iamgev.center = LYProcessHUD.bgView.center
                destinView.addSubview(LYProcessHUD.bgView)
                LYProcessHUD.iamgev.startAnimating()
            }
            
        }
        return LYProcessHUD.iamgev
    }
    
    public class func dismissOn(view:UIView?){
        LYProcessHUD.iamgev.stopAnimating()
        if let destinView = view{
            DispatchQueue.main.async {
                let showView = destinView.viewWithTag(constantTag)
                showView?.removeFromSuperview()
            }
            
        }
        
        
    }
    
}
