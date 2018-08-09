//
//  HeaderTitleView.swift
//  ZiPingSwift
//
//  Created by fanqie on 2018/8/9.
//  Copyright © 2018年 Chinayoujiao. All rights reserved.
//

import UIKit

class HeaderTitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let xibView =  awakeFromNib(frame: frame)
        self.addSubview(xibView)
        initial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //初始化属性配置
    func initial(){
 
    }
    
    // load view from xib
    //加载xib
     func awakeFromNib(frame: CGRect)-> UIView{
       let xibView = Bundle.main.loadNibNamed("HeaderTitleView", owner: self, options: nil)?.last as! UIView
       xibView.frame =  CGRect(x: 0, y: 0, width: frame.width, height: frame.height);
       return xibView
    }

}
