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
    var target : ValuationStatuModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "专项测评"
        if target.status == 1 {
           self.view.theme_backgroundColor = "Nav.barTintColor"
        }
        
        
        //请求数据查看是否完成
//        RequestManager.POST(urlString: APIManager.Valuation.check, params: nil, complete: { [weak self] (data, error) in
//
//            guard error == nil else {
//                Third.toast.message((error?.localizedDescription)!)
//                return
//            }
//
//            if let datas = data as? NSDictionary {
//                //遍历，并赋值
//                let target = JSONDeserializer<ValuationStatuModel>.deserializeFrom(dict: datas )
//                self?.goToVC(index: (target?.status)!, target: target!)
//            }
//        })
        goToVC(index: (target?.status)!, target: target!)
        
       
    }
    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        //关闭导航栏半透明效果
//        //设置背景色透明
//        navigationController?.navigationBar.setBackgroundImage(nil , for: UIBarMetrics.default)
//        //清除navibar的下划线
//        navigationController?.navigationBar.shadowImage = nil
//        navigationController?.navigationBar.isTranslucent = false
       
        self.navigationController?.isNavigationBarHidden  = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // 1.设置导航栏标题属性：设置标题颜色
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
//        // 2.设置导航栏前景色：设置item指示色
//        navigationController?.navigationBar.tintColor = UIColor.white
//
//        // 3.设置导航栏半透明
//        navigationController?.navigationBar.isTranslucent = true
//
//        let color = UIColor.init(red: 246/255.0, green: 76/255.0, blue: 128/255.0, alpha: 1)
//        // 4.设置导航栏背景图片
//        navigationController?.navigationBar.setBackgroundImage(getImageWithColor(color: color), for: UIBarMetrics.default)
//
//        // 5.设置导航栏阴影图片
//        navigationController?.navigationBar.shadowImage = UIImage()
        if target.status == 1 {
            self.navigationController?.isNavigationBarHidden  = true
        }
    }
    
    /// 将颜色转换为图片
    ///
    /// - Parameter color: <#color description#>
    /// - Returns: <#return value description#>
//    func getImageWithColor(color:UIColor)->UIImage{
//        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        context!.setFillColor(color.cgColor)
//        context!.fill(rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
//    }
    func goToVC( index : Int,target : ValuationStatuModel)  {
        let statue = index
        switch statue {
        case 0://未开始
          
            let  noStartVC = ValuationNoStartViewController();
            noStartVC.view.frame = CGRect(x: 0, y: Theme.Measure.navigationBarHeight, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - Theme.Measure.navigationBarHeight)
            view.addSubview(noStartVC.view)
            noStartVC.valuationStatueInfo = target
            addChildViewController(noStartVC)
            
            
        case 1://进行中并完成
            let completeVC = ValuationCompleteController();
            completeVC.view.frame = CGRect(x: 0, y: Theme.Measure.navigationStatueBarHeight, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - Theme.Measure.navigationStatueBarHeight)
            //添加获取到的视图控制器的视图
            completeVC.valuationStatuModel = target
            view.addSubview(completeVC.view)
            addChildViewController(completeVC)
            
        case 2://已结束
            let  endVC = ValuationEndViewController();
            endVC.view.frame = CGRect(x: 0, y: 0, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - Theme.Measure.navigationBarHeight)
            view.addSubview(endVC.view)
            addChildViewController(endVC)
            
            
        default:
            let completeVC = ValuationCompleteController();
            completeVC.view.frame = CGRect(x: 0, y: Theme.Measure.navigationBarHeight, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - Theme.Measure.navigationBarHeight)
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
