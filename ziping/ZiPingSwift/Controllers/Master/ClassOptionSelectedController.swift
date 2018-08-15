//
//  ClassOptionSelectedController.swift
//  ZiPingSwift
//
//  Created by 番茄 on 7/27/18.
//  Copyright © 2018 Chinayoujiao. All rights reserved.
//

import UIKit

class ClassOptionSelectedController: KYBaseViewController ,UITableViewDataSource, UITableViewDelegate{
    
    var classTableView: UITableView!
    var gradeTableView: UITableView!
    
    var completeHandler: ((_ option: CheckValuationParamModel, _ grardeIndex : Int , _ classIndex : Int, _ grardeName : String , _ className : String) -> Void)
    
    var gardeIndex: Int = 0
    var classsIndex: Int = 0
    
    
    
    var dataSource:[GradeOptionModel] = []
    var subDataSource:[ClassOptionModel] = []
    //选中的参数
    var checkValuationParamModel = CheckValuationParamModel()
    
    /// 创建选择的页面
    ///
    /// - Parameters:
    ///   - currentIndex: 已选中位置
    ///   - options: 选项列表
    ///   - completeHandle: 完成事件
    init(gardeIndex: Int, classsIndex: Int,options: [GradeOptionModel], completeHandler: @escaping ((_ option: CheckValuationParamModel, _ grardeIndex : Int , _ classIndex : Int, _ grardeName : String , _ className : String) -> Void)) {
        self.gardeIndex = gardeIndex
        self.classsIndex = classsIndex
        
        self.dataSource = options
        self.completeHandler = completeHandler
        super.init(nibName: nil, bundle: nil)
        
        //初始化子列表数据
        getSubDataSource(index: gardeIndex)
        
        
        print(self.subDataSource)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //刷新子菜单
    func getSubDataSource(index:Int){
        //初始化数据
        let gradeOptionModel = self.dataSource[index]
        let claseOptionModel = ClassOptionModel()
        claseOptionModel.className = "请选择班级"
        claseOptionModel.classId = "0"
        self.subDataSource = gradeOptionModel.classList
        self.subDataSource.insert(claseOptionModel, at: 0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择班级"
        let rect = self.view.frame
        
        gradeTableView = UITableView(frame: CGRect(x :0 , y:0 , width:rect.size.width/2 ,height:rect.size.height ))
        gradeTableView.tag = 110;
        self.gradeTableView.delegate = self;
        self.gradeTableView.dataSource = self;
        self.gradeTableView.register(ClassOptionTableCell.self, forCellReuseIdentifier:"gradecellId")
        view.addSubview(self.gradeTableView)
        gradeTableView.bounces = false
        gradeTableView.separatorStyle = .none
        
        
        
        //        let gradeTabelHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        //        gradeTabelHeaderView.theme_backgroundColor = Theme.Color.viewLightColor
        //        gradeTableView.tableHeaderView = gradeTabelHeaderView
        //        let rightLine = UILabel();
        //        rightLine.theme_backgroundColor = Theme.Color.line
        //        gradeTabelHeaderView.addSubview(rightLine)
        
        //        rightLine.snp.makeConstraints({ (make)in
        //            make.top.equalTo(gradeTabelHeaderView).offset(0)
        //            make.bottom.equalTo(gradeTabelHeaderView).offset(0)
        //            make.right.equalTo(gradeTabelHeaderView).offset(0)
        //            make.width.equalTo(1)
        //        })
        
        //        let gradeLabel = UILabel()
        //        gradeLabel.text = "请选择年级"
        //        gradeLabel.theme_textColor = Theme.Color.textColor
        //        gradeLabel.font = UIFont.systemFont(ofSize: 14)
        //        gradeTabelHeaderView.addSubview(gradeLabel)
        //        gradeLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(gradeTabelHeaderView).offset(15)
        //            make.centerY.equalTo(gradeTabelHeaderView)
        //            make.width.equalTo(100)
        //        }
        
        
        //班级
        classTableView = UITableView(frame: CGRect(x :rect.size.width/2, y:0 , width:rect.size.width/2 ,height:rect.size.height  ))
        classTableView.tag = 120
        self.classTableView.delegate = self;
        self.classTableView.dataSource = self;
        self.classTableView.register(ClassOptionTableCell.self, forCellReuseIdentifier:"classcellId")
        view.addSubview(self.classTableView)
        classTableView.bounces = false
        classTableView.tableFooterView = UIView()
        classTableView.separatorStyle = .none
        
        //        let classTabelHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        //        classTabelHeaderView.theme_backgroundColor = Theme.Color.viewLightColor
        //        classTableView.tableHeaderView = classTabelHeaderView
        //
        //        let classLabel = UILabel()
        //        classLabel.text = "请选择班级"
        //        classLabel.theme_textColor = Theme.Color.textColor
        //        classLabel.font = UIFont.systemFont(ofSize: 14)
        //        classTabelHeaderView.addSubview(classLabel)
        //        classLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(classTabelHeaderView).offset(15)
        //            make.centerY.equalTo(classTabelHeaderView)
        //            make.width.equalTo(100)
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 110 {
            return self.dataSource.count
        }else{
            return self.subDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 110 { //年级
            var cell = tableView.dequeueReusableCell(withIdentifier: "gradecellId")
            if cell == nil {
                cell = UITableViewCell(style: .default , reuseIdentifier: "gradecellId")
            }
            cell?.selectionStyle = .none
            cell?.theme_tintColor = Theme.Color.main
            let gradeOptionModel = self.dataSource[indexPath.row]
            cell?.textLabel?.text = gradeOptionModel.gradeName
            
            if indexPath.row  == self.gardeIndex {
                cell?.accessoryType = .checkmark
            }else{
                cell?.accessoryType = .none
            }
            
            
            return cell!
        }else{//班级
            var cell = tableView.dequeueReusableCell(withIdentifier: "classcellId")
            if cell == nil {
                cell = UITableViewCell(style: .default , reuseIdentifier: "classcellId")
            }
            cell?.theme_tintColor = Theme.Color.main
            let classOptionModel = self.subDataSource[indexPath.row]
            cell?.textLabel?.text = classOptionModel.className
            cell?.selectionStyle = .none
            
            if indexPath.row   == self.classsIndex {
                cell?.accessoryType = .checkmark
            }else{
                cell?.accessoryType = .none
            }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView.tag == 110 {
            self.gardeIndex = indexPath.row
            //子tableView切换数据
            getSubDataSource(index: self.gardeIndex)
            self.classsIndex = 0
            //选择班级编号
            classTableView.reloadData()
            gradeTableView.reloadData()
            
            
        }else{
            //选中的选中项
            self.classsIndex = indexPath.row
            tableView.reloadData()
            
            
            //获取年级 班级名字
            let cell1 = gradeTableView.cellForRow(at: NSIndexPath.init(row: self.gardeIndex, section: 0) as IndexPath)
            let cell2 = classTableView.cellForRow(at: NSIndexPath.init(row: self.classsIndex, section: 0) as IndexPath)
            
            
            //根据选项获取正确年级 班级 id
            let classOptionModel = self.subDataSource[self.classsIndex]
            checkValuationParamModel.classId = Int(classOptionModel.classId!)!
            
            let gradeOptionModel = self.dataSource[self.gardeIndex]
            checkValuationParamModel.grade = Int(gradeOptionModel.grade!)!
            
            completeHandler(checkValuationParamModel,self.gardeIndex,self.classsIndex,(cell1?.textLabel?.text)!,(cell2?.textLabel?.text)!)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


class ClassOptionTableCell: UITableViewCell {
    var bottomLine: UILabel!
    var rightLine: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initial()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //初始化属性配置
    func initial(){
        
        self.textLabel?.theme_textColor = Theme.Color.textColor
        self.textLabel?.font = UIFont.systemFont(ofSize: 15)
        rightLine = UILabel();
        rightLine.theme_backgroundColor = Theme.Color.line
        self.addSubview(rightLine)
        
        rightLine?.snp.makeConstraints({ (make)in
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.width.equalTo(1)
        })
        
        bottomLine = UILabel();
        bottomLine.theme_backgroundColor = Theme.Color.line
        self.addSubview(bottomLine)
        
        bottomLine?.snp.makeConstraints({ (make)in
            make.left.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(1)
        })
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}




