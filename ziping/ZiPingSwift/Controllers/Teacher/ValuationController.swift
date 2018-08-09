//
//  ValuationController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/21/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit

class ValuationController: KYBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //四周均不延伸
        self.edgesForExtendedLayout = []
        
        let statue = 3
        switch statue {
        case 1:
            let completeVC = ValuationCompleteController();
            completeVC.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            //添加获取到的视图控制器的视图
            view.addSubview(completeVC.view)
            addChildViewController(completeVC)
            
        case 2:
            let  noStartVC = ValuationNoStartViewController();
            noStartVC.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            view.addSubview(noStartVC.view)
            addChildViewController(noStartVC)
            
            
        case 3:
            let  endVC = ValuationEndViewController();
            endVC.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            view.addSubview(endVC.view)
            addChildViewController(endVC)
            
            
        default:
            let completeVC = ValuationCompleteController();
            completeVC.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            view.addSubview(completeVC.view)
            addChildViewController(completeVC)
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
