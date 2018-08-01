//
//  MultipleChoiceCell.swift
//  test
//
//  Created by 番茄 on 7/25/18.
//  Copyright © 2018 fanqie. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol MultipleChoiceDelegate : NSObjectProtocol{
    func selectResult(parma:String)
}

class MultipleChoiceCell: UITableViewCell {
    
    init(style: UITableViewCellStyle, reuseIdentifier: String? , cellData: NSDictionary) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.lauoutUI(cellData: cellData)
    }
    
    //声明类的代理属性变量名
    var delegate : MultipleChoiceDelegate?
    
    var backView: UIView?
    var titleLab: UILabel?
    var topView: UIView?
    var bottomView: UIView?
    var imageViewMuArray : NSMutableArray?
    
    
    
    //题目标题高度
    let topViewHeight = 45
    
    //题目标题left间距
    let titleLeftSpace = 20
    
    //每行选择答案高度
    let subViewHeight = 40
    
    //选择按钮大小
    let imageSize = 20
    
    //选择按钮left间距
     let imageLeftSpace = 20
   
    //选项内容与按钮的间距
    let contentTobuttonSpace = 10
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func lauoutUI(cellData :NSDictionary)  {
        //问题
        let questionTitle = cellData["title"] as! String
       
        //答案
        let questionArray = cellData["data"] as! NSArray
        
        
   
        backView = UIView();
        backView?.layer.cornerRadius = 10
        backView?.layer.masksToBounds = true
        backView?.backgroundColor = UIColor.white
        backView?.layer.borderWidth = 0.1
        backView?.layer.theme_borderColor = "Global.textColorLight"
        self.contentView.addSubview(backView!)
        
        imageViewMuArray = NSMutableArray();
        
        topView = UIView();
        topView?.theme_backgroundColor = Theme.Color.viewLightColor
        backView?.addSubview(topView!)
        topView?.snp.makeConstraints({ (make)in
            make.left.equalTo(backView!).offset(0)
            make.right.equalTo(backView!).offset(0)
            make.top.equalTo(backView!).offset(0)
            make.height.equalTo(topViewHeight)
        })
        
        titleLab = UILabel();
        titleLab?.text = questionTitle
        titleLab?.theme_textColor = Theme.Color.textColorDark
        titleLab?.font = UIFont.systemFont(ofSize: 15)
        topView?.addSubview(titleLab!)
        
        titleLab?.snp.makeConstraints({ (make)in
            make.left.equalTo(topView!).offset(titleLeftSpace)
            make.right.equalTo(topView!).offset(0)
            make.centerY.equalTo(topView!)
        })
        
        
        bottomView = UIView();
        bottomView?.backgroundColor = UIColor.white
        backView?.addSubview(bottomView!)
        
        
        
        bottomView?.snp.makeConstraints({ (make)in
            make.left.equalTo(backView!).offset(0)
            make.right.equalTo(backView!).offset(0)
            make.top.equalTo(topView!.snp.bottom).offset(10)
            make.height.equalTo(subViewHeight * questionArray.count)
        })
        
        for i in 0..<questionArray.count{
            
            let dict = questionArray[i] as! NSDictionary;
            let isSelect = dict["answer"] as! Bool
            
            
            let subView = UIView()
            bottomView?.addSubview(subView)
            
            subView.snp.makeConstraints({ (make)in
                make.left.equalTo(bottomView!).offset(0)
                make.right.equalTo(bottomView!).offset(0)
                make.top.equalTo(bottomView!).offset(subViewHeight * i)
                make.height.equalTo(subViewHeight)
            })
            let imageView = UIImageView();
            if(isSelect){
                imageView.image = #imageLiteral(resourceName: "cnb-seted")
            }else{
                imageView.image = #imageLiteral(resourceName: "cnb")
            }
            imageView.tag = i
            subView.addSubview(imageView)
            
            imageView.snp.makeConstraints({ (make)in
                make.left.equalTo(subView).offset(imageLeftSpace)
                make.centerY.equalTo(subView)
                make.width.equalTo(imageSize)
                make.height.equalTo(imageSize)
            })
            imageViewMuArray?.add(imageView)
            
            let selButton = UIButton();
            selButton.tag = i
            selButton.addTarget(self, action: #selector(selectAnswner(button:)), for: .touchUpInside)
            subView.addSubview(selButton)
            selButton.snp.makeConstraints({ (make)in
                make.left.equalTo(subView).offset(0)
                make.centerY.equalTo(subView)
                make.width.equalTo(50)
                make.height.equalTo(30)
            })
            
        
            let contentTitle = UILabel();
            contentTitle.text = dict["question"] as? String
            contentTitle.font = UIFont.systemFont(ofSize: 15)
            contentTitle.theme_textColor = Theme.Color.textColorDark
            subView.addSubview(contentTitle)
            
            contentTitle.snp.makeConstraints({ (make)in
                make.left.equalTo(selButton.snp.right).offset(contentTobuttonSpace)
                make.centerY.equalTo(selButton)
                make.right.equalTo(subView).offset(10)
            })
        }
        
        backView?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-10)
            make.bottom.equalTo(bottomView!.snp.bottom).offset(4)
        })
    }
    
    @objc func selectAnswner(button:UIButton) {
        for imageView in imageViewMuArray!{
            let imageView = imageView as! UIImageView
            if imageView.tag == button.tag {
                imageView.image = #imageLiteral(resourceName: "cnb-seted")
            }else{
                imageView.image = #imageLiteral(resourceName: "cnb")
            }
        }
        if delegate != nil{
            delegate?.selectResult(parma: String(format: "%d", button.tag))
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
