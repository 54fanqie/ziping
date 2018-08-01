//
//  ValuationCompleteController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/18/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit

class ValuationCompleteController: KYBaseViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bigTitleLab: UILabel!
    @IBOutlet weak var scopetitleLab: UILabel!
    
    @IBOutlet weak var compentLab: UILabel!
    @IBOutlet weak var noCompentLab: UILabel!
    @IBOutlet weak var noStartLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //四周均不延伸
        self.edgesForExtendedLayout = []
        topView.theme_backgroundColor = "Nav.barTintColor"
        bigTitleLab.text = "2018年春季第一次测评"
        scopetitleLab.text = "此次的测评时间范围2月15日~3月30日，请在该时间范围内在PC或PAD端访问 “www.epaofu.com”完成班内幼儿的"
        compentLab.text = "10"
        noCompentLab.text = "19"
        noStartLab.text = "1"
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
