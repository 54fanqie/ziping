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
    
    var thisTestStatistics = NSDictionary(){
        didSet{
            leftTitleLab.text = "完成测评幼儿"
            rightTitleLab.text = "未完成测评幼儿"
            ageSexLab.text = "年龄段/性别"
            tatolLab.text = "班级总分平均分"
            averageLab.text = "园内同年龄组平均分"
            
            
            leftCountLab.text = thisTestStatistics["overComplete"] as? String
            rightCountLab.text =  thisTestStatistics["noComplete"] as? String
        }
    }
    var lastTestStatistics = NSDictionary()
    
    var isComparison : Bool = false {
        didSet{
            if isComparison == true {//进行对比
                leftTitleLab.text = "本/上次完成测评幼儿"
                rightTitleLab.text = "本/上次未完成测评幼儿"
                ageSexLab.text = "年龄段/性别"
              
                tatolLab.text = "班级总分平均分 \n （本/上次）"
                averageLab.text = "园内同年龄组平均分 \n （本/上次）"
                
              
                
                leftCountLab.text = String(format: "%@/%@", (thisTestStatistics["overComplete"] as? String)!,(lastTestStatistics["overComplete"] as? String)!)
                
                rightCountLab.text = String(format: "%@/%@", (thisTestStatistics["noComplete"] as? String)!,(lastTestStatistics["noComplete"] as? String)!)
                
            
            }else{//不对比
                leftTitleLab.text = "完成测评幼儿"
                rightTitleLab.text = "未完成测评幼儿"
                ageSexLab.text = "年龄段/性别"
                tatolLab.text = "班级总分平均分"
                averageLab.text = "园内同年龄组平均分"
                
                leftCountLab.text = thisTestStatistics["overComplete"] as? String
                rightCountLab.text =  thisTestStatistics["noComplete"] as? String
                
                
            }
            
        }
    }
    
   
    
    
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
