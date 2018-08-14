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
    
    var completeHandler: ((_ option: GradeOptionModel) -> Void)
    var currentIndex: Int = 0
    var dataSource:[GradeOptionModel] = []
    var subDataSource:[ClassOptionModel] = []
    
    
    /// 创建选择的页面
    ///
    /// - Parameters:
    ///   - currentIndex: 已选中位置
    ///   - options: 选项列表
    ///   - completeHandle: 完成事件
    init(currentIndex: Int, options: [GradeOptionModel], completeHandle: @escaping ((_ option: GradeOptionModel) -> Void)) {
        self.currentIndex = currentIndex
        self.dataSource = options
        self.completeHandler = completeHandle
        
        super.init(nibName: nil, bundle: nil)
        let gradeOptionModel = self.dataSource[1]
        self.subDataSource = gradeOptionModel.classOptionList
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择班级"
        let rect = self.view.frame
        
        gradeTableView = UITableView(frame: CGRect(x :0 , y:0 , width:rect.size.width/2 ,height:rect.size.height ))
        gradeTableView.tag = 110;
        self.gradeTableView.delegate = self;
        self.gradeTableView.dataSource = self;
        self.gradeTableView.register(UITableViewCell.self, forCellReuseIdentifier:"gradecellId")
        view.addSubview(self.gradeTableView)
        gradeTableView.bounces = false
        gradeTableView.tableFooterView = UIView()
        
        let gradeTabelHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        gradeTabelHeaderView.theme_backgroundColor = Theme.Color.line
        gradeTableView.tableHeaderView = gradeTabelHeaderView
        
        let gradeLabel = UILabel()
        gradeLabel.text = "请选择年级"
        gradeLabel.theme_textColor = Theme.Color.textColor
        gradeLabel.font = UIFont.systemFont(ofSize: 14)
        gradeTabelHeaderView.addSubview(gradeLabel)
        gradeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(gradeTabelHeaderView).offset(15)
            make.centerY.equalTo(gradeTabelHeaderView)
            make.width.equalTo(100)
        }
        
        
        
        
        classTableView = UITableView(frame: CGRect(x :rect.size.width/2, y:0 , width:rect.size.width/2 ,height:rect.size.height  ))
        classTableView.tag = 120
        self.classTableView.delegate = self;
        self.classTableView.dataSource = self;
        self.classTableView.register(UITableViewCell.self, forCellReuseIdentifier:"classcellId")
        view.addSubview(self.classTableView)
        classTableView.bounces = false
        classTableView.tableFooterView = UIView()
        
        
        let classTabelHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        classTabelHeaderView.theme_backgroundColor = Theme.Color.line
        classTableView.tableHeaderView = classTabelHeaderView
        
        let classLabel = UILabel()
        classLabel.text = "请选择班级"
        classLabel.theme_textColor = Theme.Color.textColor
        classLabel.font = UIFont.systemFont(ofSize: 14)
        classTabelHeaderView.addSubview(classLabel)
        classLabel.snp.makeConstraints { (make) in
            make.left.equalTo(classTabelHeaderView).offset(15)
            make.centerY.equalTo(classTabelHeaderView)
            make.width.equalTo(100)
        }
        
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
            //        let option = gradeArray[indexPath.row]
            //
            //            if indexPath.row == 1 {
            //                cell?.accessoryType = .checkmark
            //            }else
            //            {
            //                cell?.accessoryType = .none
            //            }
            let gradeOptionModel = self.dataSource[indexPath.row]
            cell?.textLabel?.text = gradeOptionModel.gradeName
            
            if indexPath.row == currentIndex {
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
            //        let option = gradeArray[indexPath.row]
            //
            //            if indexPath.row == 1 {
            //                cell?.accessoryType = .checkmark
            //            }else
            //            {
            //                cell?.accessoryType = .none
            //            }
            
            let classOptionModel = self.subDataSource[indexPath.row]
            cell?.textLabel?.text = classOptionModel.className
            
//            if indexPath.row == currentIndex {
//                cell?.accessoryType = .checkmark
//            }else{
//                cell?.accessoryType = .none
//            }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let option = gradeArray[indexPath.row]
        //
        //        completeHandler!(option)
        //
        //        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}






