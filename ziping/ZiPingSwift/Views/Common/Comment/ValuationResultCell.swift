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
   
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var formbackView: UIView!
     var dict : NSDictionary = [:] {
        
        didSet {
           print(dict)
            let data = dict.object(forKey: "list") as! NSArray
        
            if data.count == 0{
                return
            }
            
            titleLab.text = dict.object(forKey: "title") as? String
            timeLab.text = (dict.object(forKey: "time") as! String)

            for index in 0..<data.count {
                print(index)
                let fw = (Theme.Measure.screenWidth - 129)  / CGFloat(data.count)
                let vi = FormView.init(frame: CGRect(x: fw * CGFloat(index), y: 0, width: fw , height: 53 ));
                let  code = data[index] as! String
                vi.codeLab.text = code
                
                formbackView.addSubview(vi)
            }
        }
    }
    
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    func setupViews() {
        
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
