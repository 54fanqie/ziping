//
//  QuestionnaireIngViewController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/20/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit

class QuestionnaireIngViewController: KYBaseViewController {

    @IBOutlet weak var markLab: UILabel!
    @IBOutlet weak var titlelab: UILabel!
    @IBOutlet weak var starValuationBtn: UIButton!
    var valuationStatueInfo : ValuationStatuModel?{
        didSet{
            titlelab.text = self.valuationStatueInfo?.title
            markLab.text = self.valuationStatueInfo?.remarks
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starValuationBtn.layer.cornerRadius = 20
        starValuationBtn.layer.masksToBounds = true
        starValuationBtn.theme_backgroundColor = Theme.Color.main
        // Do any additional setup after loading the view.
    }

    @IBAction func starValuationAction(_ sender: Any) {
        var vc : UIViewController
        if self.valuationStatueInfo?.historyid == 0{
            let instrucVc  = InstructionViewController()
            instrucVc.shijuanid = (self.valuationStatueInfo?.shijuanid)!
            vc = instrucVc
        }else{
            let mu = MultipleChoiceController();
            mu.shijuanid = (self.valuationStatueInfo?.shijuanid)!
            vc = mu
        }
         self.navigationController?.pushViewController(vc, animated: true)
        
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
