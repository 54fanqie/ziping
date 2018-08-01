//
//  QuestionnaireEndViewController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/20/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit

class QuestionnaireEndViewController: KYBaseViewController {

    @IBOutlet weak var applyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        applyButton.layer.cornerRadius = 20
        applyButton.layer.masksToBounds = true
        applyButton.theme_backgroundColor = Theme.Color.main
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var applyAction: UIButton!
    
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
