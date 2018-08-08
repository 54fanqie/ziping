//
//  ScoreListTableViewCell.swift
//  ZiPingSwift
//
//  Created by fanqie on 2018/8/8.
//  Copyright © 2018年 Chinayoujiao. All rights reserved.
//

import UIKit

class ScoreListTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var tatolLab: UILabel!
    @IBOutlet weak var averageLab: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }
    override init(style: UITableViewCellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        let bundle = Bundle.init(for: self.classForCoder)
//        let name = NSStringFromClass("ScoreListTableViewCell").components(separatedBy: ".").last
//        let nib = UINib(nibName: name!, bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
//        
//        let view = Bundle.main.loadNibNamed("ScoreListTableViewCell", owner: self, options: nil)?[0] as! ScoreListTableViewCell
//        view.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//        self.addSubview(view)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
