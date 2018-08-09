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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ValuationResultCell", bundle: nil), forCellReuseIdentifier: "ValuationResultCell")
        tableView.separatorStyle = .none
        addSubview(tableView)
        
        tabelHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 61))
        tableView.tableHeaderView = tabelHeaderView
        
        headerTitleView = HeaderTitleView(frame: CGRect(x: 0, y: 16, width: frame.width, height: 46));
        tabelHeaderView.addSubview(headerTitleView)
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
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ValuationResultCell") as? ValuationResultCell
        cell?.selectionStyle = .none
        cell?.textLabel?.theme_textColor = Theme.Color.textColor
        
       
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


