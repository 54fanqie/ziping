//
//  CheckValuationController.swift
//  ZiPingSwift
//
//  Created by fanqie on 2018/8/6.
//  Copyright © 2018年 Chinayoujiao. All rights reserved.
//

import UIKit
import HandyJSON
//年级
class GradeOptionModel: CYJBaseModel {
    var grade : String?
    var gradeName : String?
    var classList : [ClassOptionModel] = []
}
//班级
class ClassOptionModel: CYJBaseModel {
    var classId : String?
    var className : String?
}

//测评时间
class TestTimeModel: CYJBaseModel {
    var shijuanid : String?
    var testTime : String?
    var title : String?
}


//查询测评对比数据
class AnalysisModel: CYJBaseModel {
    var testStatistics  : NSDictionary? //统计情况 groupId=2时使用，（overComplete=己完成，overStart=己开始，overNoStart=未开始）
    var testGroupData : [TestGroupData] = []
}

//列表对比数据
class TestGroupData: CYJBaseModel {
    var rangeAge : String?
    var sex : String?
    var averageScore : String?
    var averageAge : String?
}


//查询条件数据
class CheckValuationParamModel: CYJBaseModel {
    var year : Int = 0
    var semester : Int = 0
    var grade : Int = 0
    var classId : Int = 0
    var shijuanid : Int = 0
    var isComparison : Int = 0    
}


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
    
    //显示完成未完成视图
    var completeNumberView : CompleteNumberView!
    //对比按钮背景视图
    var comparedView : UIView!
    //对比按钮
    var compareButton : UIButton!
    
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
    
    // 学期的数组
    lazy var semesterArray: [CYJOption] = {
        return [CYJOption(title: "春季", opId: 2), CYJOption(title: "秋季", opId: 1)]
    }()
    
    // 班级种类的数组
    var gradeArray = [GradeOptionModel]()
    
    // 测评时间数组
    var valuationTimeArray = [TestTimeModel]()
    
    
    /// 参数 对象
    var checkValuationParamModel: CheckValuationParamModel = CheckValuationParamModel()
    
    /// 标记选项 ：时间、季节、班级、测评时间 选项
    var yearIndex : Int = 0
    var semesterIndex : Int = 0
    var gradeIndex : Int = 0
    var classIndex : Int = 0
    var timeIndex : Int = 0
    
    
    /// 参数 对象
    var analyseParam: CYJAnalyseParam = CYJAnalyseParam()
    
    
    
    //单次列表数据
    var thisListDatas = [TestGroupData]()
    //封装对比数据
    var valuation = [TestGroupData]()
    //是否对比数据
    var isComparison : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "专项测评"
        tabelHeaderView = UIView(frame: CGRect(x: 0, y: Theme.Measure.navigationBarHeight, width: view.frame.width, height: 544))
        tabelHeaderView.backgroundColor = UIColor.white
        tableView.tableHeaderView = tabelHeaderView
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        
        //请求班级信息
        getClassDetailList()
        
        
        
        
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
                self.checkValuationParamModel.year = Int(op.title)!
                
                //TODO: 选年--刷新--班级--测评时间
                self.classCondition.title = "请选择班级"
                self.valuationTimeCondition.title = "请选择时间"
                
                
                self.checkValuationParamModel.grade = 0
                self.checkValuationParamModel.classId = 0
                self.checkValuationParamModel.shijuanid = 0
                self.checkValuationParamModel.isComparison = 0
                self.classIndex = 0
                self.gradeIndex = 0
                self.timeIndex = 0
                
                //刷新评测时间
                self.getValuationTimeList()
                
                self.analyseParam.cId = 0
                self.analyseParam.dId = nil
                self.analyseParam.diId = nil
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
                
                self.checkValuationParamModel.semester = op.opId
                //TODO: 更换季节--刷新--班级--测评时间
                self.classCondition.title = "请选择班级"
                self.valuationTimeCondition.title = "请选择时间"
                self.checkValuationParamModel.grade = 0
                self.checkValuationParamModel.classId = 0
                self.checkValuationParamModel.shijuanid = 0
                self.checkValuationParamModel.isComparison = 0
                self.classIndex = 0
                self.gradeIndex = 0
                self.timeIndex = 0
                
                //刷新评测时间
                self.getValuationTimeList()
                
                
                
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
        self.gradeIndex = 0
        self.classIndex = 0
        classConditionView = CYJConditionView(title: "请选择班级:", key: "class")
        classCondition = CYJConditionButton(title: "请选择班级", key: "class_grade") {[unowned self] (sender) in
            print("筛选年级")
            
            let optionController = ClassOptionSelectedController.init(gardeIndex: self.gradeIndex, classsIndex: self.classIndex, options: self.gradeArray, completeHandler: {[unowned sender] (op, gradeIndex, classIndex, gradeName, className) in
                
                self.checkValuationParamModel.grade = op.grade
                self.checkValuationParamModel.classId = op.classId
                sender.title = "\(gradeName)" + "-" + "\(className)"
                self.gradeIndex = gradeIndex
                self.classIndex = classIndex
                
                
            })
            self.navigationController?.pushViewController(optionController, animated: true)
        }
        
        classConditionView.addCondition(classCondition)
        classConditionView.frame.origin = CGPoint(x: 0, y: termConditionView.frame.maxY)
        tabelHeaderView.addSubview(classConditionView)
        
        
        
        //请求测评时间信息
        getValuationTimeList()
        
        
        //=======================================测评时间====================================================
        scopeConditionView = CYJConditionView(title: "测评时间:", key: "time")
        self.timeIndex = 0
        valuationTimeCondition = CYJConditionButton(title: "请选择测评时间", key: "test_time") { [unowned self] (sender) in
            
            let testTimeController = TImeOptionSelectedController(currentIndex: self.timeIndex, options: self.valuationTimeArray) { [unowned sender](op , selectIndex) in
                
                print("\(String(describing: op.testTime))")
                sender.title = op.testTime
                self.checkValuationParamModel.shijuanid = Int(op.shijuanid!)!
                self.timeIndex = selectIndex
            }
            self.navigationController?.pushViewController(testTimeController, animated: true)
        }
        scopeConditionView.addCondition(valuationTimeCondition)
        scopeConditionView.frame.origin = CGPoint(x: 0, y: classConditionView.frame.maxY)
        tabelHeaderView.addSubview(scopeConditionView)
        
        
        
        //=======================================重置、报告、申请专业分析====================================================
        actionsView = CYJActionsView(frame: CGRect(x: 0, y: scopeConditionView.frame.maxY, width: view.frame.width, height: 60))
        actionsView.innerPadding = 10
        actionsView.theme_backgroundColor = Theme.Color.ground
        // 1
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
            
            
            
            self.classCondition.title = "请选择班级"
            self.valuationTimeCondition.title = "请选择测评时间"
            
            
            self.checkValuationParamModel.grade = 0
            self.checkValuationParamModel.classId = 0
            self.checkValuationParamModel.shijuanid = 0
            self.checkValuationParamModel.isComparison = 0
            self.classIndex = 0
            self.gradeIndex = 0
            self.timeIndex = 0
            
            if (self.completeNumberView != nil) {
                self.completeNumberView.removeFromSuperview()
                self.completeNumberView = nil
            }
            if (self.compareButton != nil){
                self.compareButton.removeFromSuperview()
                self.compareButton = nil
            }
            
            
            
            self.thisListDatas.removeAll()
            self.valuation.removeAll()
            self.tableView.reloadData()
            
            let season = self.semesterArray.index { $0.opId == self.analyseParam.semester}
            yearCondition.setTitle("\(self.analyseParam.year)", for: .normal)
            seasonCondition.setTitle("\(self.semesterArray[season!].title)", for: .normal)
            
            
            //            self.clearAllCharts()
            
        }
        resetButton.filterButtonStyle = .nomal_light_Style
        // 2
        let showButton = CYJFilterButton(title: "查看报告") {[weak self] (sender) in
            print("查看报告")
            //MARK: 请求bar数据
            if self?.checkValuationParamModel.classId == 0  {
                Third.toast.message("请选择班级")
                return
            }
            if self?.checkValuationParamModel.shijuanid == 0  {
                Third.toast.message("请选择测评时间")
                return
            }
            //请求数据
            self?.getValuationAnalysis()
            
        }
        // 3
        showButton.filterButtonStyle = .nomal_color_Style
        let applyButton = CYJFilterButton(title: "申请专业分析") { [unowned self] (sender) in
            
            print("申请专业分析")
            let applyController = CYJProfessionalAnalyseController()
            applyController.isValuation = true
            self.navigationController?.pushViewController(applyController, animated: true)
        }
        
        applyButton.filterButtonStyle = .nomal_color_Style
        actionsView.actions = [resetButton, showButton, applyButton]
        tabelHeaderView.addSubview(actionsView)
        
        
        
        //===========================================统计结果==========================================================
        comparedView = UIView()
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
    }
    //初始化视图
    func initUI() {
        compareButton = UIButton(type: .custom)
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
        completeNumberView = CompleteNumberView.init(frame: CGRect(x: 0, y: comparedView.frame.maxY, width: view.frame.width, height: 257));
        tabelHeaderView.addSubview(completeNumberView)
        //        tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
    }
    
    
    
    func compareAciton(button : UIButton){
        button.isSelected = !button.isSelected
        self.completeNumberView.isComparison = button.isSelected
        isComparison = button.isSelected
        tableView.reloadData()
    }
    //获取班级信息
    func getClassDetailList(){
        RequestManager.POST(urlString: APIManager.Valuation.getClass, params: nil) { [weak self] (data, error) in
            
            guard error == nil else {
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            //遍历，并赋值
            if let datas = data as? NSArray {
                //遍历，并赋值
                datas.forEach({ [] in
                    let target = JSONDeserializer<GradeOptionModel>.deserializeFrom(dict: $0 as? NSDictionary)
                    self?.gradeArray.append(target!)
                })
            }
        }
    }
    
    //获取测评时间
    func getValuationTimeList(){
        RequestManager.POST(urlString: APIManager.Valuation.getTestTime, params: ["year":self.analyseParam.year,"semester":self.analyseParam.year]) { [weak self] (data, error) in
            
            guard error == nil else {
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            //遍历，并赋值
            if let datas = data as? NSArray {
                self?.valuationTimeArray.removeAll()
                //遍历，并赋值
                datas.forEach({ [] in
                    let target = JSONDeserializer<TestTimeModel>.deserializeFrom(dict: $0 as? NSDictionary)
                    self?.valuationTimeArray.append(target!)
                })
            }
        }
    }
    
    
    //查询测评-分析
    func getValuationAnalysis(){
        RequestManager.POST(urlString: APIManager.Valuation.analysis, params: ["year":self.checkValuationParamModel.year ,"semester":self.checkValuationParamModel.semester,"grade":self.checkValuationParamModel.grade,"classId":self.checkValuationParamModel.classId,"shijuanid":self.checkValuationParamModel.shijuanid,"isComparison":self.checkValuationParamModel.isComparison]) { [weak self] (data, error) in
            
            guard error == nil else {
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            //先清空数据
            if (self?.thisListDatas.count)! > 0 || (self?.valuation.count)! > 0 {
                self?.thisListDatas.removeAll()
                self?.valuation.removeAll()
            }
            
            
            let dictionary = data as? NSDictionary
            let this = dictionary!["thisTime"] as? NSDictionary
            let last = dictionary!["lastTime"] as? NSDictionary
            
            let thisListDatas  = JSONDeserializer<AnalysisModel>.deserializeFrom(dict: this )
            let lastListDatas  = JSONDeserializer<AnalysisModel>.deserializeFrom(dict: last)
            if (self?.completeNumberView == nil) || (self?.compareButton == nil){
                self?.initUI()
                self?.completeNumberView.thisTestStatistics = (thisListDatas?.testStatistics)!
                self?.completeNumberView.lastTestStatistics = (lastListDatas?.testStatistics)!
                //单次数据
                self?.thisListDatas = (thisListDatas?.testGroupData)!
                //封装对比数据
                self?.compareData(lastListDatas: (lastListDatas?.testGroupData)!)
                self?.tableView.reloadData()
            }
        }
    }
    //组装列表数据
    func compareData(lastListDatas:[TestGroupData]){
        for i in 0..<self.thisListDatas.count{
            let model = TestGroupData();
            model.rangeAge = self.thisListDatas[i].rangeAge
            model.sex = self.thisListDatas[i].sex
            model.averageScore = String(format: "%@/%@",self.thisListDatas[i].averageScore!, lastListDatas[i].averageScore!)
            model.averageAge = String(format: "%@/%@",self.thisListDatas[i].averageAge!, lastListDatas[i].averageAge!)
            valuation.append(model)
        }
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
        if isComparison == true {
            return valuation.count
        }else{
            return thisListDatas.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var   cell :ScoreListTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cellID"  ) as? ScoreListTableViewCell
        if cell == nil {
            cell = ScoreListTableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        cell.selectionStyle = .none
        
        if isComparison == true {
            cell.testGroupData = self.valuation[indexPath.row]
        }else{
            cell.testGroupData = self.thisListDatas[indexPath.row]
        }
        
        return cell
        
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        let cell = tableView.cellForRow(at: indexPath) as? CYJCustomBarChartCell
    //        cell?.animateOut()
    //    }
    
}
