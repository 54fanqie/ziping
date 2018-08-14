//
//  QuestionnComplentViewController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/20/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit
import HandyJSON
class QuestionnComplentViewController: KYBaseViewController {
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var firstLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        applyButton.layer.cornerRadius = 20
        applyButton.layer.masksToBounds = true
        applyButton.theme_backgroundColor = Theme.Color.main
        firstLab.text = "您已完成2017年秋季第一次问卷测评~"
    }
    
    @IBOutlet weak var applyAction: UIButton!
    
    
    
    @IBAction func applyforMaster(_ sender: Any) {
        RequestManager.POST(urlString: APIManager.Valuation.applyReport, params: ["historyid" : 1]) { [weak self] (data, error) in
            guard error == nil else {
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            
            let custom = JSONDeserializer<CustomResponds>.deserializeFrom(dict: data as? NSDictionary)
            if custom?.status == 200 {
                
            }else
            {
                
            }
            let alert = ValuationAlertController()
            //                alert.message = info["message"]as! String
            alert.message = "专项测评专业分析申请已发送给园长，将由园长与平台沟通哦~"
            alert.completeHandler = { [] in
                alert.dismiss(animated:true, completion: nil)
            }
            alert.showAlert()
        }
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
