//
//  ValuationResultView.swift
//  ZiPingSwift
//
//  Created by fanqie on 2018/8/9.
//  Copyright © 2018年 Chinayoujiao. All rights reserved.
//

import UIKit

class ValuationResultView: UIView {
    
    fileprivate var tableView: UITableView!
    var tabelHeaderView :UIView!
    var headerTitleView : HeaderTitleView!
    var dataArray : NSArray!
    override init(frame: CGRect) {
        super.init(frame: frame)
        dataArray = getData()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ValuationResultCell", bundle: nil), forCellReuseIdentifier: "ValuationResultCell")
//        tableView.register(ValuationResultCell.self, forCellReuseIdentifier:  "ValuationResultCell")
        tableView.separatorStyle = .none
        addSubview(tableView)
        //表头
        tabelHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 61))
        tableView.tableHeaderView = tabelHeaderView
        
        headerTitleView = HeaderTitleView(frame: CGRect(x: 0, y: 16, width: frame.width, height: 46));
        tabelHeaderView.addSubview(headerTitleView)
        headerTitleView.typeData = ["  \n总分","认知\n领域","语言\n领域","社会\n领域","学习\n品质",]
        tableView.reloadData()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ValuationResultView: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ValuationResultCell") as? ValuationResultCell
        cell?.selectionStyle = .none
        cell?.textLabel?.theme_textColor = Theme.Color.textColor
        cell?.dict = dataArray[indexPath.row] as! NSDictionary
       
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func  getData() -> NSArray {
        let someArray : [String]=["101","23","123","44","55"]
        
        
        let mutable1 : NSMutableDictionary = NSMutableDictionary()
        mutable1.setObject("2018春季第一次", forKey:"title"  as NSCopying)
        mutable1.setObject("(12/01~01/15)", forKey:"time"  as NSCopying)
        mutable1.setObject(someArray, forKey: "list"  as NSCopying)
        
       
        
        let arry:[NSDictionary] =  [mutable1, mutable1, mutable1,mutable1,mutable1]
        
        return arry as NSArray
    }
}


