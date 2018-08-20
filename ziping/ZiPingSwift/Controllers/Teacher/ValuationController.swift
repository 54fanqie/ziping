//
//  ValuationController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/21/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit
import HandyJSON
class ValuationController: KYBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //四周均不延伸
        self.edgesForExtendedLayout = []
        
        
        
        //请求数据查看是否完成
        RequestManager.POST(urlString: APIManager.Valuation.check, params: nil, complete: { [weak self] (data, error) in
            
            guard error == nil else {
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            
            if let datas = data as? NSDictionary {
                //遍历，并赋值
                let target = JSONDeserializer<ValuationStatuModel>.deserializeFrom(dict: datas )
                self?.goToVC(index: (target?.status)!, target: target!)
            }
        })
        
        
       
    }
    
    func goToVC( index : Int,target : ValuationStatuModel)  {
        let statue = index
        switch statue {
        case 0://未开始
          
            let  noStartVC = ValuationNoStartViewController();
            noStartVC.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - Theme.Measure.navigationBarHeight)
            view.addSubview(noStartVC.view)
            noStartVC.valuationStatueInfo = target
            addChildViewController(noStartVC)
            
            
        case 1://进行中
            let completeVC = ValuationCompleteController();
            completeVC.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - Theme.Measure.navigationBarHeight)
            //添加获取到的视图控制器的视图
            completeVC.valuationStatuModel = target
            view.addSubview(completeVC.view)
            addChildViewController(completeVC)
            
        case 2://已结束
            let  endVC = ValuationEndViewController();
            endVC.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - Theme.Measure.navigationBarHeight)
            view.addSubview(endVC.view)
            addChildViewController(endVC)
            
            
        default:
            let completeVC = ValuationCompleteController();
            completeVC.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - Theme.Measure.navigationBarHeight)
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
