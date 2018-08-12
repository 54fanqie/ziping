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
    @IBOutlet weak var remarkLab: UILabel!
    @IBOutlet weak var firstTimeLab: UILabel!
    @IBOutlet weak var secondTimeLab: UILabel!
    @IBOutlet weak var thirdTimeLab: UILabel!
    @IBOutlet weak var fourTimeLab: UILabel!
    var valuationStatueInfo : ValuationStatuModel?{
        didSet{
            valuationTimeLab.text = self.valuationStatueInfo?.title
            remarkLab.text = self.valuationStatueInfo?.remarks
            let testTime = self.valuationStatueInfo?.testTime
            firstTimeLab.text = testTime?[0] as? String
            secondTimeLab.text = testTime?[1] as? String
            thirdTimeLab.text = testTime?[2] as? String
            fourTimeLab.text = testTime?[3] as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
