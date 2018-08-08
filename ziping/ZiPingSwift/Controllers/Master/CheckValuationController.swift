//
//  CheckValuationController.swift
//  ZiPingSwift
//
//  Created by fanqie on 2018/8/6.
//  Copyright © 2018年 Chinayoujiao. All rights reserved.
//

import UIKit

class CheckValuationController: KYBaseTableViewController {

    var tabelHeaderView: UIView!
    
    /// 三个条件
    var termConditionView: CYJConditionView!
    var classConditionView: CYJConditionView!
    var scopeConditionView: CYJConditionView!
    
    //选择班级
    var classCondition: CYJConditionButton!
    //测评时间
    var valuationTimeCondition: CYJConditionButton!
    
    // 三个按钮
    var actionsView: CYJActionsView!
   
    //完成人数对比
    var titleView : CompleteNumberView!
    
    
    // 学期的数组
    lazy var semesterArray: [CYJOption] = {
        return [CYJOption(title: "春季", opId: 2), CYJOption(title: "秋季", opId: 1)]
    }()
    
    // 班级种类的数组
    lazy var gradeArray:  [CYJOption] = {
        return [CYJOption(title: "大班", opId: 1),
                CYJOption(title: "中班", opId: 2),
                CYJOption(title: "小班", opId: 3),
                CYJOption(title: "托班", opId: 4)]
    }()
    
    // 测评时间数组
    lazy var valuationTimeArray:  [CYJOption] = {
        return [CYJOption(title: "秋季第一次测评", opId: 1),
                CYJOption(title: "秋季第二次测评", opId: 2),
                CYJOption(title: "春季第一次测评", opId: 3),
                CYJOption(title: "春季第二次测评", opId: 4)]
    }()
    
    /// 参数 对象
    var analyseParam: CYJAnalyseParam = CYJAnalyseParam()
    
    /// 年分的数组
    lazy var yearArray: [CYJOption] = {
        
        var years = [CYJOption]()
        
        let data = Date(timeIntervalSinceNow: 0)
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year], from: data)
        let year = comp.year
        
        let index = year! - 2017
        for i in 0..<(index + 1) {
            let option = CYJOption(title: "\(year! - i)", opId: year! - i)
            years.append(option)
        }
        return years
    }()
    
    //请求的列表数据
    var listChartDatas : [String] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "专项测评"
        tabelHeaderView = UIView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: 560))
        tabelHeaderView.theme_backgroundColor = Theme.Color.line
        tableView.tableHeaderView = tabelHeaderView
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        
        //=======================================记录时间===================================================
        //MARK: 设置初始年与学期
        let yearAndSemester = Date().getYearAndSemester()
        self.analyseParam.year = yearAndSemester.year
        self.analyseParam.semester = yearAndSemester.semester
        
        termConditionView = CYJConditionView(title: "记录时间:", key: "time")
        //年
        let yearCondition = CYJConditionButton(title: "\(self.analyseParam.year)", key: "time_year") { (sender) in
            
            let index = self.yearArray.index(where: { $0.opId == self.analyseParam.year}) ?? 0
            
            let optionController = CYJOptionsSelectedController(currentIndex: index, options: self.yearArray) { [unowned sender](op) in
                print("\(op.title)")
                sender.setTitle(op.title, for: .normal)
                
                self.analyseParam.year = Int(op.title)!
                
                //                //TODO: 选年--刷新--班级--范围
                //                self.classCondition.title = "全部"
                //                self.scopeCondition.title = "筛选"
                //                self.fetchDomainsFromServer()
                //
                //                self.analyseParam.cId = 0
                //                self.analyseParam.dId = nil
                //                self.analyseParam.diId = nil
            }
            self.navigationController?.pushViewController(optionController, animated: true)
        }
        //季节
        let season = self.semesterArray.index { $0.opId == self.analyseParam.semester}
        let seasonCondition = CYJConditionButton(title: self.semesterArray[season!].title , key: "time_season") { (sender) in
            
            let index = self.semesterArray.index { $0.opId == self.analyseParam.semester} ?? 0
            
            let optionController = CYJOptionsSelectedController(currentIndex: index, options: self.semesterArray) { [unowned sender](op) in
                print("\(op.title)")
                sender.setTitle(op.title, for: .normal)
                
                self.analyseParam.semester = op.opId
                //TODO: 选年--刷新--班级--范围
                //                self.classCondition.setTitle("全部", for: .normal)
                //                self.classCondition.title = "全部"
                
                //                self.scopeCondition.setTitle("范围", for: .normal)
                //                self.scopeCondition.title = "筛选"
                
                
                
                self.analyseParam.cId = 0
                self.analyseParam.dId = nil
                self.analyseParam.diId = nil
            }
            self.navigationController?.pushViewController(optionController, animated: true)
        }
        
        termConditionView.addCondition(yearCondition)
        termConditionView.addCondition(seasonCondition)
        termConditionView.frame.origin = CGPoint(x: 0, y: 0)
        tabelHeaderView.addSubview(termConditionView)
        
        
        
        //=======================================筛选班级====================================================
        //MARK: 设置初始年级为 大班 -- 获取领域
        
        classConditionView = CYJConditionView(title: "筛选班级:", key: "class")
        classCondition = CYJConditionButton(title: "请选择班级", key: "class_grade") {[unowned self] (sender) in
            print("筛选年级")
            
            let gradeIndex = self.gradeArray.index(where: { $0.opId == self.analyseParam.grade}) ?? 0
            
            let optionController = CYJOptionsSelectedController(currentIndex: gradeIndex, options: self.gradeArray) { [unowned sender](op) in
                print("\(op.title)")
                sender.setTitle(op.title, for: .normal)
                
                self.analyseParam.grade = op.opId
                
                
                
                //刷新下面参数
                //TODO: 选年--刷新--班级--范围
                //                self.classCondition.setTitle("全部", for: .normal)
                //                self.classCondition.title = "全部"
                
                //                self.scopeCondition.setTitle("范围", for: .normal)
                //                self.scopeCondition.title = "筛选"
                
                
                
                self.analyseParam.cId = 0
                self.analyseParam.dId = nil
                self.analyseParam.diId = nil
            }
            self.navigationController?.pushViewController(optionController, animated: true)
        }
        
        classConditionView.addCondition(classCondition)
        classConditionView.frame.origin = CGPoint(x: 0, y: termConditionView.frame.maxY)
        tabelHeaderView.addSubview(classConditionView)
        
        
        
        
        
        
        
        //=======================================测评时间====================================================
        scopeConditionView = CYJConditionView(title: "测评时间:", key: "scope")
        valuationTimeCondition = CYJConditionButton(title: "范围", key: "scope_scope") { [unowned self] (sender) in
            //TODO: print("分析范围")
            
            //            if self.domainsForClass.count == 0 {
            //                Third.toast.message("该年级园长暂未设置评价指标，暂不能查看成长分析报告。")
            //                return
            //            }
            
            let scope = CYJAnalyseScropeController()
            //            scope.domains = self.domainsForClass
            //            scope.selectedDids = self.selectedDids
            //            scope.selectedDiids = self.selectedDiids
            
            scope.completeClosure = { [unowned sender] in
                print($0)
                //改变已选个数
                let count = $0.0.count + $0.1.count
                
                if count > 0 {
                    
                    //                    sender.setTitle("已选\(count)", for: .normal)
                    //                    self.scopeCondition.title = "筛选"
                    sender.title = "已选分析范围\(count)个"
                    self.analyseParam.dId = $0.0.joined(separator: ",")
                    self.analyseParam.diId = $0.1.joined(separator: ",")
                    
                }else{
                    sender.setTitle("筛选", for: .normal)
                }
            }
            
            self.navigationController?.pushViewController(scope, animated: true)
        }
        scopeConditionView.addCondition(valuationTimeCondition)
        scopeConditionView.frame.origin = CGPoint(x: 0, y: classConditionView.frame.maxY)
        tabelHeaderView.addSubview(scopeConditionView)
        
        
        
        //=======================================重置、报告、申请专业分析====================================================
        actionsView = CYJActionsView(frame: CGRect(x: 0, y: scopeConditionView.frame.maxY, width: view.frame.width, height: 60))
        actionsView.innerPadding = 10
        actionsView.theme_backgroundColor = Theme.Color.ground
        
        let resetButton = CYJFilterButton(title: "重置") { [unowned self] (sender) in
            print("重置")
            //TODO: 重置筛选的状态
            //MARK: 设置 初始 年 学期
            let yearAndSemester = Date().getYearAndSemester()
            self.analyseParam.year = yearAndSemester.year
            self.analyseParam.semester = yearAndSemester.semester
            self.analyseParam.grade = 1
            self.analyseParam.cId = 0
            self.analyseParam.dId = nil
            self.analyseParam.diId = nil
            
            let season = self.semesterArray.index { $0.opId == self.analyseParam.semester}
            yearCondition.setTitle("\(self.analyseParam.year)", for: .normal)
            seasonCondition.setTitle("\(self.semesterArray[season!].title)", for: .normal)
            
            self.classCondition.title = "请选择班级"
            self.valuationTimeCondition.title = "筛选"
            
            
//            self.clearAllCharts()
            
        }
        resetButton.defaultColorStyle = true
        
        let showButton = CYJFilterButton(title: "查看报告") {[weak self] (sender) in
            print("查看报告")
            //MARK: 请求bar数据
            if self?.analyseParam.dId == nil || self?.analyseParam.diId == nil {
                Third.toast.message("请选择分析范围")
                return
            }
        }
        showButton.defaultColorStyle = false
        let applyButton = CYJFilterButton(title: "申请专业分析") { [unowned self] (sender) in
            print("申请专hahahah 业分析")
            
            let applyController = CYJProfessionalAnalyseController()
            
            self.navigationController?.pushViewController(applyController, animated: true)
        }
        applyButton.defaultColorStyle = false
        
        actionsView.actions = [resetButton, showButton, applyButton]
        tabelHeaderView.addSubview(actionsView)
        
    //===========================================统计结果==========================================================
        let comparedView = UIView()
        comparedView.theme_backgroundColor = Theme.Color.viewLightColor
        comparedView.frame = CGRect(x: 0, y: actionsView.frame.maxY, width: view.frame.width, height: 40)
        tabelHeaderView.addSubview(comparedView)
        
        let titleLabel = UILabel()
        titleLabel.text = "统计结果"
        titleLabel.theme_textColor = Theme.Color.textColorlight
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        comparedView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(comparedView).offset(15)
            make.centerY.equalTo(comparedView)
            make.width.equalTo(100)
        }
        
        
        
        let compareButton = UIButton(type: .custom)
        compareButton.setImage(#imageLiteral(resourceName: "yz-duibi") , for: .normal)
        compareButton.setImage(#imageLiteral(resourceName: "yz-duibi-active") , for: .selected)
        compareButton.setTitle(" 对比上一次", for: .normal)
        compareButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        compareButton.addTarget(self, action: #selector(compareAciton(button:)), for: .touchUpInside)
        compareButton.theme_setTitleColor(Theme.Color.textColorDark, forState: .normal)
        comparedView.addSubview(compareButton)
        compareButton.snp.makeConstraints { (make) in
            make.right.equalTo(comparedView).offset(-16)
            make.top.equalTo(comparedView).offset(0)
            make.bottom.equalTo(comparedView).offset(0)
            make.width.equalTo(100)
        }
        //===========================================完成人数对比==========================================================

        let completeNumberView = CompleteNumberView.init(frame: CGRect(x: 0, y: comparedView.frame.maxY, width: view.frame.width, height: 257));
        tabelHeaderView.addSubview(completeNumberView)
   
        tableView.register(UINib.init(nibName: "ScoreListTableViewCell", bundle: nil), forCellReuseIdentifier: "scoreListCell")
//        let nib = UINib(nibName: "ScoreListTableViewCell", bundle: nil) //nibName指的是我们创建的Cell文件名
//        tableView.register(nib, forCellReuseIdentifier: "scoreListCell")
         tableView.register(ScoreListTableViewCell.self, forCellReuseIdentifier: "scoreListCell")
        
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        // 获取一下班级信息
//        self.getClassbyYear()
    }

    func compareAciton(button : UIButton){
        button.isSelected = !button.isSelected
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CheckValuationController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
//220 + CGFloat(barChartData.dataSets.count) * 21)/
extension CheckValuationController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "scoreListCell") as? ScoreListTableViewCell
//        if cell == nil {
            cell = Bundle.main.loadNibNamed("ScoreListTableViewCell", owner: self, options: nil)?.last as? ScoreListTableViewCell
//        }
        cell?.textLabel?.text = "nihao "
//        cell?.averageLab.text = "nihao "
        
        cell?.selectionStyle = .none
        return cell!
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        let cell = tableView.cellForRow(at: indexPath) as? CYJCustomBarChartCell
        //        cell?.animateOut()
//    }
    
}
