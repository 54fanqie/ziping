//
//  CompleteNumberView.swift
//  test2
//
//  Created by fanqie on 2018/8/6.
//  Copyright © 2018年 fanqie. All rights reserved.
//

import UIKit
class CompleteNumberView: UIView {
 
    
    @IBOutlet weak var leftTitleLab: UILabel!
    @IBOutlet weak var leftCountLab: UILabel!
    @IBOutlet weak var rightTitleLab: UILabel!
    @IBOutlet weak var rightCountLab: UILabel!
   
    @IBOutlet weak var ageSexLab: UILabel!
    @IBOutlet weak var tatolLab: UILabel!
    @IBOutlet weak var averageLab: UILabel!
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var listTitleView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        awakeFromNib()
        initial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //初始化属性配置
    func initial(){
        leftTitleLab.text = "完成测评幼儿"
        rightTitleLab.text = "未完成测评幼儿"
        
        leftCountLab.text = "10"
        rightCountLab.text = "12"
        
        ageSexLab.text = "年龄段/性别"
        tatolLab.text = "班级总分平均分 \n （本/上次）"
        averageLab.text = "园内同年龄组平均分"
        listTitleView.layer.theme_borderColor = "Global.separatorColor"
        listTitleView.layer.borderWidth = 1
    }
    
    // load view from xib
    //加载xib
    override func awakeFromNib() {
        Bundle.main.loadNibNamed("CompleteNumberView", owner: self, options: nil)
        self.view.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(view)
    }

    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
