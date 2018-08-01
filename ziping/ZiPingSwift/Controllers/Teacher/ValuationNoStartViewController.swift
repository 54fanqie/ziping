//
//  ValuationNoStartViewController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/19/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit

class ValuationNoStartViewController: KYBaseViewController {

    @IBOutlet weak var valuationTimeLab: UILabel!
    @IBOutlet weak var firstTimeLab: UILabel!
    @IBOutlet weak var secondTimeLab: UILabel!
    @IBOutlet weak var thirdTimeLab: UILabel!
    @IBOutlet weak var fourTimeLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        valuationTimeLab.text = "距离下一次测评还有65天，测评时间范围时请注意查看。"
        firstTimeLab.text = "9月01日~10月15日为秋季学期的第一次测评；"
        secondTimeLab.text = "12月01日~01月15日为秋季学期的第二次测评；"
        thirdTimeLab.text = "02月15日-03月30为春季学期的日第一次测评；"
        fourTimeLab.text = "06月1日-07月15日为春季学期的第二次测评；"
    
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
