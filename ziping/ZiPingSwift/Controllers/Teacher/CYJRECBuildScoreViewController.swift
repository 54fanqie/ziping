//
//  CYJRECBuildScoreViewController.swift
//  ZiPingSwift
//
//  Created by kyang on 2017/8/30.
//  Copyright © 2017年 Chinayoujiao. All rights reserved.
//

import UIKit

import HandyJSON
import SwiftTheme

protocol CYJRECBuildSubViewChangeDelegate : class{
    func subViewChanged(index: Int, highlight: Bool) -> Void
}

class CYJRECBuildScoreViewController: KYBaseViewController {
    
    /// 需要从上一个页面传递过来， required  grId != 0
    var recordParam : CYJNewRECParam {
        return CYJRECBuildHelper.default.recordParam
    }
    var sharedUIds = [Int]()
    /// 创建 segmentView 所需数据
    var children: [String] {
        let children = self.recordParam.info.map { (evaluate) -> String in
            return evaluate.name!
        }
        return children
    }
    /// 创建 segmentView 所需数据
    var images: [String] {
        let avatars = self.recordParam.info.map { (evaluate) -> String in
            return evaluate.avatar ?? "http://www.jkhahk.com"
        }
        return avatars
    }
    
    var allDomains: [CYJDomain] = []
    //    var actionView: CYJActionsView!
    var buttonActionView: UIView!
//    var lastButton : UIButton!
//    var saveButton : UIButton!
//    var nextButton : UIButton!
//    var lineLab : UILabel!
    //MARK: View Properties
    var segView: CustomScrollSegmentView!
    var segmentStyle: SegmentStyle!
    var contentView: ContentView!

    
    var contentViewControllers: [CYJRECBuildScoreContainerController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "评分评价"
        view.theme_backgroundColor = Theme.Color.viewLightColor
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        // 关闭返回，让只能通过暂存按钮返回上个页面
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(dismissSelfNavigationController))
        
        //TODO: First 请求 student 的评价数据
        
        switch CYJRECBuildHelper.default.buildStep {
        case .uploaded:
            //TODO: third 请求评价信息后，创建当前界面的数据并刷新出来，
            //这时候已经存在了幼儿数据
            self.makeSegmentView()
            //直接请求domain 数据
            self.fetchDominsFromServer()
            self.requestStudentDataFromServer()
        case .cached(_):
            self.requestStudentDataFromServer()
        default:
            break
        }
        
        // makeActionsView
        self.makeActionsView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: 设置recordView的父识图
        CYJASRRecordor.share.containerView = self.view
        
        //到了第二部，要更新mark
        recordParam.mark = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //MARK: 设置recordView的父识图
        CYJASRRecordor.share.containerView = nil
        Third.toast.hide {}
    }
    
    
    /// 关闭成长记录 -- 未暂存的就没有啦
    func dismissSelfNavigationController() {
        
        switch CYJRECBuildHelper.default.buildStep {
        case .cached(let indexPath):
            if self.recordParam.type == 2 {
                NotificationCenter.default.post(name: CYJNotificationName.recordChanged, object: indexPath)
            }else
            {
                NotificationCenter.default.post(name: CYJNotificationName.recordChanged, object: "cached")
            }
        default :
            NotificationCenter.default.post(name: CYJNotificationName.recordChanged, object: nil)
        }
        
        self.navigationController?.dismiss(animated: true, completion: {})
    }
}
// MARK: - UI extension
extension CYJRECBuildScoreViewController {
    
    func makeSegmentView() {
        // 滚动条
        var style = SegmentStyle()
        style.showLine = true        // 颜色渐变
        style.gradualChangeTitleColor = true         // 滚动条颜色
        style.titleMargin = 30        //标题间距
        style.scrollTitle = true// s滚动标题
        style.titleAlignment = false  //整体剧中
        style.titleFont = UIFont.systemFont(ofSize: 17)
        let color = ThemeManager.color(for: "Nav.barTintColor")!
        let normalColor = ThemeManager.color(for: "Global.textColorLight")!
        //        style.selectedTitleColor = UIColor(red: 86/255.0, green: 173/255.0, blue: 235/255.0, alpha: 1)
        //        style.normalTitleColor = UIColor(red: 86/255.0, green: 173/255.0, blue: 235/255.0, alpha: 1)
        //        style.scrollLineColor =  UIColor(red: 86/255.0, green: 173/255.0, blue: 235/255.0, alpha: 1)
        
        style.scrollLineColor =  color
        style.normalTitleColor = normalColor
        style.selectedTitleColor = normalColor
        style.highlightTitleColor = color
        
        self.segmentStyle = style
        
        segView = CustomScrollSegmentView(frame: CGRect(x: 0, y: Theme.Measure.navigationBarHeight, width: view.frame.width, height: 50), segmentStyle: style, titles: children, images: images)
        
        segmentView.theme_backgroundColor = Theme.Color.ground
        view.addSubview(segmentView)
        
    }
    func makeActionsView() {
        buttonActionView = UIView(frame: CGRect(x: 0, y: view.frame.height - 44, width: view.frame.width, height: 44))
        view.addSubview(buttonActionView)
        
       let lastButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonActionView.frame.width  * 0.6 * 0.5 - 0.5, height: 44))
        lastButton.theme_setTitleColor(Theme.Color.textColorlight, forState: .normal)
        lastButton.theme_backgroundColor = Theme.Color.ground
        lastButton.setTitle("上一步", for: .normal)
        lastButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        lastButton.addTarget(self, action: #selector(lastREC), for: .touchUpInside)
         buttonActionView.addSubview(lastButton)
        
        let lineLab = UILabel(frame: CGRect(x: buttonActionView.frame.width  * 0.6 * 0.5, y:0, width: 0.5, height: 44))
        lineLab.theme_backgroundColor = Theme.Color.viewLightColor
        buttonActionView.addSubview(lineLab)
        
       let saveButton = UIButton(frame: CGRect(x: 0.5 + buttonActionView.frame.width  * 0.6 * 0.5, y: 0, width: buttonActionView.frame.width  * 0.6 * 0.5, height: 44))
        saveButton.theme_setTitleColor(Theme.Color.textColorlight, forState: .normal)
        saveButton.theme_backgroundColor = Theme.Color.ground
        saveButton.setTitle("暂存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveButton.addTarget(self, action: #selector(saveREC), for: .touchUpInside)
        buttonActionView.addSubview(saveButton)
       let nextButton = UIButton(frame: CGRect(x: buttonActionView.frame.width  * 0.6, y: 0, width: buttonActionView.frame.width  * 0.4, height: 44))
        nextButton.theme_setTitleColor(Theme.Color.ground, forState: .normal)
        nextButton.theme_backgroundColor = Theme.Color.main
        nextButton.setTitle("提交并完成该记录", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextButton.addTarget(self, action: #selector(nextREC), for: .touchUpInside)
        buttonActionView.addSubview(nextButton)
 
    }
    
    /// 创建 主要内容的视图
    func makeContentView() {
        
        contentView = ContentView(frame: CGRect(x: 0, y: Theme.Measure.navigationBarHeight + 1 + 50 + 5, width: view.frame.width, height: view.frame.height - (Theme.Measure.navigationBarHeight + 1 + 50 + 44)), childVcs: setChildVcs(), parentViewController: self)
        contentView.delegate = self
        // 避免循环引用
        segView.titleBtnOnClick = {[unowned self] (label: UILabel, index: Int) in
            // 切换内容显示(update content)
            UIApplication.shared.keyWindow?.endEditing(true)
            self.contentView.setContentOffSet(CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: self.segmentStyle.changeContentAnimated)
        }
        view.addSubview(contentView)
        
    }
    /// swiperView 必须实现的
    func setChildVcs() -> [UIViewController] {
        
        var childVCs: [UIViewController] = []
        
        for i in 0..<children.count {
            
            let vc = CYJRECBuildScoreContainerController()
            vc.delegate = self
            
            vc.title = children[i]
            vc.childIndex = i
            vc.allDomains = self.allDomains
            vc.view.frame = CGRect(x: 0, y: 8, width: Theme.Measure.screenWidth, height: Theme.Measure.screenHeight - Theme.Measure.navigationBarHeight - 50 - 44)
            childVCs.append(vc)
        }
        
        self.contentViewControllers = childVCs as! [CYJRECBuildScoreContainerController]
        return childVCs
    }
}

// MARK: - 数据请求
extension CYJRECBuildScoreViewController {
    
    /// 请求评价信息
    func requestStudentDataFromServer() {
        
        RequestManager.POST(urlString: APIManager.Record.student, params: ["token" : LocaleSetting.token, "grId": "\(self.recordParam.grId)"]) { [unowned self] (data, error) in
            //如果存在error
            guard error == nil else {
                Third.toast.hide {}
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            if let evaluates = data as? NSArray {
                //遍历，并赋值
                var tmpEvaluates = [CYJRecordEvaluate]()
                evaluates.forEach({
                    let target = JSONDeserializer<CYJRecordEvaluate>.deserializeFrom(dict: $0 as? NSDictionary)
                    tmpEvaluates.append(target!)
                })
                //TODO: second 请求评价信息后，将评价信息放到参数里面
                
                self.recordParam.getValues(evaluates: tmpEvaluates)
                
                //TODO: third 请求评价信息后，创建当前界面的数据并刷新出来，
                self.makeSegmentView()
                
                self.fetchDominsFromServer()
                
                Third.toast.hide {}
            }
        }
    }
    /// 请求所用的domain
    func fetchDominsFromServer() {
        
        let domainParam: [String: Any] = [
            "level": "4",
            "year" :  "2017",
            "semester" : "1",
            "grade" : "1",
            "token" : LocaleSetting.token ]
        
        RequestManager.POST(urlString: APIManager.Record.tree, params: domainParam ) { [unowned self] (data, error) in
            //如果存在error
            guard error == nil else {
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            if let fields = data as? NSArray {
                //遍历，并赋值
                var tmp = [CYJDomain]()
                fields.forEach({ 
                    let target = JSONDeserializer<CYJDomain>.deserializeFrom(dict: $0 as? NSDictionary)
                    tmp.append(target!)
                    
                })
                self.allDomains = tmp
                
                self.makeContentView()
            }
        }
    }
    
    /// 上传对象到Object      需要与 self.recordParam.type 配对使用
    
   func uploadObjectToServer(_ finish: Int) {
        let paramter = self.recordParam.encodeToDictionary()
        
        //        self.alertShare()
        //        return
        //        self.actionView.makeButtonDisabled()
        
        RequestManager.POST(urlString: APIManager.Record.edit, params: paramter) { [unowned self] (data, error) in
            //            self.actionView.makeButtonEnabled()
            //如果存在error
            guard error == nil else {
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            //改变LocaleSetting的状态，用以需要的地方刷新页面使用
            //            LocaleSetting.share.recordChanged = true
            
            
            if finish == 0 {
                Third.toast.message("暂存成功")
                self.navigationController?.popViewController(animated: true)
            }else if finish == 1{
                Third.toast.message("暂存成功")
            }else if finish == 2 {
                // 更新状态到发布
                
                if self.recordParam.type == 2 {
                    //TODO: 4⃣️ 执行的操作是最后的提交，分享的话
                    CYJRECBuildHelper.default.buildStep.publish()
                    
                    self.shareRecordToParent(uid: self.sharedUIds)
                    
                }else {
                    //TODO: 4⃣️ 保存成功之后，弹出一个alert，让用户选择是否分享
                    DispatchQueue.main.async { [unowned self] in
                        self.alertShare()
                    }
                }
            }
        }
    }
    
    /// 分享给家长
    ///
    /// - Parameter uid: <#uid description#>
    func shareRecordToParent(uid: [Int]) {
        
        if uid.count > 0 {
            // 有哦孩子，去分享
            let paramter: [String : Any] = ["token" : LocaleSetting.token, "uId" : uid, "grId" : "\(self.recordParam.grId)"]
            
            RequestManager.POST(urlString: APIManager.Record.share, params: paramter) { [unowned self] (data, error) in
                //如果存在error
                guard error == nil else {
                    Third.toast.message((error?.localizedDescription)!)
                    return
                }
                
                Third.toast.message("提交成功", hide: {
                    DispatchQueue.main.async { [unowned self] in
                        //TODO: 6⃣️ 分享成功后，销毁页面
                        self.dismissSelfNavigationController()
                    }
                })
            }
            
        }else {
            // 否则，直接让界面消失
            self.dismissSelfNavigationController()
        }
    }
    
    
}

//MARK: Actions
extension CYJRECBuildScoreViewController {
    
    func lastREC() {
        getlIds()
        //暂存时，要上传
        self.recordParam.type = 1
        uploadObjectToServer(0)
        
        navigationController?.popViewController(animated: true)
    }
    
    /// 暂存，
    func saveREC() {
        
        getlIds()
        //暂存时，要上传
        self.recordParam.type = 1
        uploadObjectToServer(1)
    }
    
    /// 下一步 -- 完成，上传到服务器
    func nextREC() {
        
        getlIds()
        //TODO: 1⃣️ 遍历，查看所有孩子的 描述，如果有没填的，弹出第一个alert
        let unContent = self.recordParam.info.filter { (evaluate) -> Bool in
            if evaluate.content == nil {
                return true
            }
            if (evaluate.content?.isEmpty)! {
                return true
            }
            return false
        }
        if unContent.count > 0 {
            let alert = CYJRECBuildAlertController()
            
            alert.completeHandler = { [unowned self] in
                print("CYJRECBuildAlertController sure -- continue upload")
                //TODO: 2⃣️ 如果继续的话，那么，提交 -- ⚠️此时继续执行暂存的操作
                self.recordParam.type = 1
                self.uploadObjectToServer(2)
            }
            alert.showAlert()
            return
        }
        
        //TODO: 1⃣️ 遍历，查看所有孩子的 评分，如果有没填的，弹出第一个alert
        let unEvaluate = self.recordParam.info.filter { $0.lId.count == 0}
        if unEvaluate.count > 0 {
            let alert = CYJRECBuildAlertController()
            
            alert.completeHandler = { [unowned self] in
                print("CYJRECBuildAlertController sure -- continue upload")
                //TODO: 2⃣️ 如果继续的话，那么，提交 -- ⚠️此时继续执行暂存的操作
                self.recordParam.type = 1
                self.uploadObjectToServer(2)
            }
            alert.showAlert()
            return
        }
        
        //不弹一的话，直接弹2？
        
        self.recordParam.type = 1
        self.uploadObjectToServer(2)
        
    }
    
    /// 拿到lId数据，放到
    func getlIds() {
        //TODO: 0⃣️ 把选中的level 从数据中取出来
        self.contentViewControllers.forEach { (container) in
            var lids = [String]()
            container.firstViewController.selectedNodes.forEach({
                lids.append($0.ext!["lId"]!)
            })
            
            let evaluate = self.recordParam.info[container.childIndex]
            evaluate.lId = lids
        }
    }
    
    func alertShare() {
        
        let alert = CYJRECSharedAlertController()
        alert.children = self.recordParam.info
        alert.completeHandler = {[unowned self] in
            print("CYJRECBuildAlertController sure -- continue upload")
            //先把alert 消化掉？
            alert.dismiss(animated: false, completion: nil)
            //TODO: 5⃣️ 如果回调的数据存在，那么分享，否则什么也不做
            self.sharedUIds = $0
            self.recordParam.type = 2
            self.uploadObjectToServer(2)
        }
        
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension CYJRECBuildScoreViewController: ContentViewDelegate
{
    var segmentView: ScrollSegmentBase
    {
        return segView
    }
    
    func contentViewMoveToIndex(_ fromIndex: Int, toIndex: Int, progress: CGFloat) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
extension CYJRECBuildScoreViewController: CYJRECBuildSubViewChangeDelegate {
    
    func subViewChanged(index: Int, highlight: Bool) {
        segView.hightlightLabel(index: index, highlight: highlight)
    }
}



