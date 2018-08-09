//
//  ValuationResultViewController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/21/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit

class ValuationResultViewController: KYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vi = ValuationResultView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: Theme.Measure.screenHeight - 64 ))
        view.addSubview(vi)
        
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
