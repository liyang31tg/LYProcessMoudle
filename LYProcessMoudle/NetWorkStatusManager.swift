//
//  NetWorkStatusManager.swift
//  TruckDriver
//
//  Created by liyang on 2016/11/16.
//  Copyright © 2016年 liyang. All rights reserved.
//

import UIKit
public class NetWorkStatusManager {
  public  enum NetWorkStausManagerType {
        case loading
        case loadError
    }
    //UIImage
    static let showImages:[UIImage] = {()->[UIImage] in
        var tmpShowImages:[UIImage] = []
        for i in 1...13{
            if let image = UIImage(named: "screenload\(i)"){
                tmpShowImages.append(image)
            }
        }
        return tmpShowImages
        }()
    static let imageError="screenload_fail"//没网络的图片
    //show(创建并显示)
   public class func showOn(levelView:UIView,msg:String = "",showType:NetWorkStatusManager.NetWorkStausManagerType = NetWorkStatusManager.NetWorkStausManagerType.loading , offsetY:Int = 0 , edges : UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0) , failBlock:(@convention(block) () -> ())? = nil){
        if let isExitNetWorkStausView = self.getOn(levelView: levelView){
            isExitNetWorkStausView.showType         =   showType;//这里切换状态
            isExitNetWorkStausView.noticeLable.text =    msg
            isExitNetWorkStausView.failBlock        =   failBlock
        }else{
            let s       =   NetWorkStatusView(msg: msg, offsetY: offsetY,showType:showType)
            s.failBlock =   failBlock
            s.edges     =   edges
            levelView.addSubview(s)
        }
    }
    //get(获得显示在这个view上的)
    class func getOn(levelView:UIView) -> NetWorkStatusView?{
        let subviews=levelView.subviews
        var targetView:NetWorkStatusView?
        for subview in subviews{
            if subview is NetWorkStatusView {
                targetView=subview as? NetWorkStatusView
                break
            }
        }
        return targetView
    }
    //dismiss(清除显示的view)
   public class func dismiss(levelView:UIView){
        let targetView = self.getOn(levelView: levelView)
        UIView.animate(withDuration: 0.3, animations:{ ()->() in
        targetView?.alpha=0
        }){ (iscompete) -> () in
            if iscompete {
                targetView?.removeFromSuperview()
            }
        
        }
    }
    
class NetWorkStatusView: UIView {
        let imageview           = UIImageView(image:NetWorkStatusManager.showImages.first!)
        var imagess:[UIImage]   = []
        let imageBtn            = UIButton()//无网络的时候双击消失
        var edges               = UIEdgeInsets()
        var failBlock:(@convention(block) () -> ())?//失败的时候点击回调直到成功
        var showType:NetWorkStatusManager.NetWorkStausManagerType{//计算属性
            get{//不可使用
                return NetWorkStatusManager.NetWorkStausManagerType.loading
            }
            set{
                if imageview.isAnimating {
                    imageview.stopAnimating()
                }
                if newValue == NetWorkStatusManager.NetWorkStausManagerType.loadError{
                    imageview.image             =  UIImage(named: NetWorkStatusManager.imageError)
                    imageBtn.isEnabled          =  true
                }
                if newValue == NetWorkStatusManager.NetWorkStausManagerType.loading{
                    imageBtn.isEnabled          = false
                    imageview.animationImages   = NetWorkStatusManager.showImages
                    imageview.animationDuration = 0.3 * 13
                    imageview.startAnimating()
                }
            }
        }
        var offsetY:Int!
        var noticeStr:String!
        var noticeLable=UILabel()
        init(msg:String,offsetY:Int,showType:NetWorkStatusManager.NetWorkStausManagerType){
            super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            self.translatesAutoresizingMaskIntoConstraints              = false
            self.backgroundColor                                        = UIColor(red: 235, green: 236, blue: 232, alpha: 1.0)
            self.offsetY                                                = offsetY
            self.noticeStr                                              = msg
            self.noticeLable.text                                       = msg
            
            self.imageview.translatesAutoresizingMaskIntoConstraints    = false
            self.noticeLable.translatesAutoresizingMaskIntoConstraints  = false
            self.imageBtn.translatesAutoresizingMaskIntoConstraints     = false
            
            self.addSubview(imageview)
            self.addSubview(noticeLable)
            self.addSubview(imageBtn)
            
            //添加事件
            imageBtn.addTarget(self, action: #selector(NetWorkStatusView.againRequest), for: UIControlEvents.touchUpInside)
            //切换状态
            self.showType=showType
            //addconstraints
            noticeLable.textColor=UIColor.red
            noticeLable.font = UIFont.systemFont(ofSize: 14)
            imageview.contentMode = UIViewContentMode.scaleAspectFit
            /*imageview*/
            let imageViewWidthConstraint = NSLayoutConstraint(item: imageview, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 150)
            let imageViewHeightConstraint = NSLayoutConstraint(item: imageview, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 150)
            let imageViewCenterXConstraint = NSLayoutConstraint(item: imageview, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let imageViewCenterYConstraint = NSLayoutConstraint(item: imageview, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: CGFloat(self.offsetY))
            self.addConstraints([imageViewWidthConstraint,imageViewHeightConstraint,imageViewCenterXConstraint,imageViewCenterYConstraint])
            /*noticeLable*/
            let noticeLableWidthConstraint = NSLayoutConstraint(item: noticeLable, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 10)
            let noticeLableHeightConstraint = NSLayoutConstraint(item: noticeLable, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 10)
            let noticeLableCenterXConstraint = NSLayoutConstraint(item: noticeLable, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let noticeLableTopConstraint = NSLayoutConstraint(item: noticeLable, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: imageview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 10)
            self.addConstraints([noticeLableWidthConstraint,noticeLableHeightConstraint,noticeLableCenterXConstraint,noticeLableTopConstraint])
            /*imageBtn*/
            let imageBtnWidthConstraint = NSLayoutConstraint(item: imageBtn, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 150)
            let imageBtnHeightConstraint = NSLayoutConstraint(item: imageBtn, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 150)
            let imageBtnCenterXConstraint = NSLayoutConstraint(item: imageBtn, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let imageBtnCenterYConstraint = NSLayoutConstraint(item: imageBtn, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: CGFloat(self.offsetY))
            self.addConstraints([imageBtnWidthConstraint,imageBtnHeightConstraint,imageBtnCenterXConstraint,imageBtnCenterYConstraint])
        }
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func didMoveToSuperview(){
            super.didMoveToSuperview()
            let superView = self.superview
            if let s = superView {
                let topConstraint =  NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: s, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.edges.top)
                let leadingConstraint =   NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: s, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: self.edges.left)
                let trainlingConstraint =   NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: s, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: self.edges.right)
                let bottomConstraint =   NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: s, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: self.edges.bottom)
                s.addConstraints([topConstraint,leadingConstraint,trainlingConstraint,bottomConstraint])
            }
        }
        
        func againRequest(){
            if let failbb=self.failBlock{
                failbb()
            }
        }
        deinit{
            print("\(self.classForCoder) is die");
        }
    }
    
}

