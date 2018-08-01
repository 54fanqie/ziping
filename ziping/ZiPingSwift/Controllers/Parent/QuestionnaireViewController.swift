//
//  QuestionnaireViewController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/20/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit
import SwiftTheme

class QuestionnaireViewController: KYBaseViewController {
    
    var scrollPageView: ScrollPageView!
    var uid: Int = 0
    var statue :Int = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.theme_backgroundColor = Theme.Color.ground
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        //        hidesBottomBarWhenPushed = true
        // 滚动条
        var style = SegmentStyle()
        style.showLine = true        // 颜色渐变
        style.gradualChangeTitleColor = true         // 滚动条颜色
        //        style.scrollLineColor =  UIColor(red: 41/255.0, green: 167/255.0, blue: 158/255.0, alpha: 1)
        style.titleMargin = 30        //标题间距
        style.scrollTitle = true// s滚动标题
        style.titleAlignment = true  //整体剧中
        //        style.normalTitleColor = UIColor(red: 86/255.0, green: 173/255.0, blue: 235/255.0, alpha: 1)
        style.titleFont = UIFont.systemFont(ofSize: 17)
        //        style.selectedTitleColor = UIColor(red: 86/255.0, green: 173/255.0, blue: 235/255.0, alpha: 1)
        let color = ThemeManager.color(for: "Nav.barTintColor")!
        let normalColor = ThemeManager.color(for: "Global.textColorLight")!
        
        style.scrollLineColor =  color
        style.normalTitleColor = normalColor
        style.selectedTitleColor = color
        
        scrollPageView = ScrollPageView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: Theme.Measure.screenHeight - 64), segmentStyle: style, titles: ["问卷测评", "教师测评结果"], childVcs: setChildVcs(), parentViewController: self)
        
        view.addSubview(scrollPageView)
    }
    /// swiperView 必须实现的
    func setChildVcs() -> [UIViewController] {
        
        var childVCs: [UIViewController] = []
        switch statue {
        case 0:
            //  问卷测评 未开始
            let vc4 = ValuationNoStartViewController()
            vc4.view.backgroundColor = UIColor.white
            vc4.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            childVCs.append(vc4)
        case 1:
            //  问卷测评  进行中
            let vc1 = QuestionnaireIngViewController()
            vc1.view.backgroundColor = UIColor.white
            vc1.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            childVCs.append(vc1)
        case 3:
            //  问卷测评  已完成
            let vc3 = QuestionnComplentViewController()
            vc3.view.backgroundColor = UIColor.white
            vc3.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            childVCs.append(vc3)
        case 4:
            //  问卷测评  已结束
            let vc2 = QuestionnaireEndViewController()
            vc2.view.backgroundColor = UIColor.white
            vc2.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            childVCs.append(vc2)
        case 5:
            //  问卷测评  已毕业
            let vc5 = GraduationViewController()
            vc5.view.backgroundColor = UIColor.white
            vc5.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            childVCs.append(vc5)

        default:
            //  问卷测评  未开始
            let vc = ValuationNoStartViewController()
            vc.view.backgroundColor = UIColor.white
            vc.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
            childVCs.append(vc)
        }
        //教师测评结果
        let vc = ValuationResultViewController();
        vc.view.backgroundColor = UIColor.white
        vc.view.frame = CGRect(x: 0, y: 0.5, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - 64)
        childVCs.append(vc)
        return childVCs
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
