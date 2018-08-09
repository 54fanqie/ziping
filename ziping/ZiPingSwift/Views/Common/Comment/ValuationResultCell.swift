//
//  ValuationResultCell.swift
//  ZiPingSwift
//
//  Created by fanqie on 2018/8/9.
//  Copyright © 2018年 Chinayoujiao. All rights reserved.
//

import UIKit

class FormView: UIView {
    var codeLab: UILabel!
    var line: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //初始化属性配置
    func initial(){
        codeLab = UILabel();
        codeLab?.text = "120"
        codeLab?.theme_textColor = Theme.Color.textColor
        codeLab?.font = UIFont.systemFont(ofSize: 14)
        codeLab?.textAlignment = .center
        self.addSubview(codeLab!)
        
        codeLab?.snp.makeConstraints({ (make)in
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.centerY.equalTo(self).offset(0)
        })
        
        line = UILabel();
        line.theme_backgroundColor = Theme.Color.line
        self.addSubview(line)
        
        line?.snp.makeConstraints({ (make)in
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.width.equalTo(1)
        })
    }
    
}


class ValuationResultCell: UITableViewCell {
    
    @IBOutlet weak var formbackView: UIView!
    var count : Int = 4
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        for index in 0..<count {
            print(index)
            let fw = formbackView.frame.width  / 4
            let vi = FormView.init(frame: CGRect(x: fw * CGFloat(index), y: 0, width: fw , height: formbackView.frame.height ));
            formbackView.addSubview(vi)
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
