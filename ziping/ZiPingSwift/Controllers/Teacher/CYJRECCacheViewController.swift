//
//  CYJRECCacheViewController.swift
//  ZiPingSwift
//
//  Created by kyang on 2017/10/12.
//  Copyright © 2017年 Chinayoujiao. All rights reserved.
//

import Foundation
import HandyJSON

class CYJRECCacheViewController: KYBaseTableViewController, CYJActionPassOnDeleagte{
    
    var dataSource: [CYJRECCacheCellFrame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "暂存记录"
        //input code here
        self.shouldHeaderRefresh = true
        self.shouldFooterRefresh = true
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView();
        tableView.register(CYJRECCacheCell.self, forCellReuseIdentifier: CYJRECCacheCell.CellMode.none.rawValue)
        tableView.register(CYJRECCacheCell.self, forCellReuseIdentifier: CYJRECCacheCell.CellMode.one.rawValue)
        tableView.register(CYJRECCacheCell.self, forCellReuseIdentifier: CYJRECCacheCell.CellMode.two.rawValue)
        tableView.register(CYJRECCacheCell.self, forCellReuseIdentifier: CYJRECCacheCell.CellMode.three.rawValue)
        tableView.register(CYJRECCacheCell.self, forCellReuseIdentifier: CYJRECCacheCell.CellMode.four.rawValue)
        tableView.register(CYJRECCacheCell.self, forCellReuseIdentifier: CYJRECCacheCell.CellMode.video.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(listenRecordChanged(notifi:)), name: CYJNotificationName.recordChanged, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次都要新数据！
        self.fetchDataSource()
        
    }
    
    func listenRecordChanged(notifi: Notification) {
        
        if let _ = notifi.object as? String {
            //暂存-->暂存
            DLog("//暂存-->暂存")
            DispatchQueue.main.async { [weak self] in
                if self?.tableView.contentOffset.y == 0 {
                    //没有位移
                    DLog("//刷新+++++++++++++++++=")

                    self?.page = 1
                    self?.tableView.mj_footer.resetNoMoreData()
                    self?.fetchDataSource()
                }
            }
        }else if let index = notifi.object as? IndexPath {
            //暂存 --》发布
            DLog("//暂存 --》发布")
            //发现目标--表示是从暂存列表进入的，这时候要更新列表了
            if let _ = tableView.cellForRow(at: index) {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.deleteRows(at: [index], with: .none)
                }
            }
        }else {
            //发布-- 暂存  没有变化
            DLog("//发布-- 暂存  没有变化")
        }
    }
}

//MARK: make UI
extension CYJRECCacheViewController {
    
    override func fetchDataSource() {
        
        
        RequestManager.POST(urlString: APIManager.Record.listTemp, params: ["token": LocaleSetting.token, "page": "\(self.page)"]) { [weak self] (data, error) in
            
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            
            //如果存在error
            guard error == nil else {
                self?.statusUpdated(success: false)
                Third.toast.message((error?.localizedDescription)!)
                return
                
            }
            self?.statusUpdated(success: true)
            
            if let records = data as? NSArray {
                if self?.page == 1 {
                    self?.dataSource.removeAll()
                }
                //遍历，并赋值
                var tmpCaches = [CYJRECCacheCellFrame]()
                records.forEach({
                    let target = JSONDeserializer<CYJRecord>.deserializeFrom(dict: $0 as? NSDictionary)
                    
                    let cellframe = CYJRECCacheCellFrame(record: target!)
                    
                    tmpCaches.append(cellframe)
                })
                
                if tmpCaches.count < 10 {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
                self?.dataSource.append(contentsOf: tmpCaches)
                
                self?.tableView.reloadData()
            }
        }
    }
}
extension CYJRECCacheViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellFrame = dataSource[indexPath.row]
        let photoCount = cellFrame.record.photo?.count
        var mode: CYJRECCacheCell.CellMode
        switch photoCount! {
            
        case 0: mode = CYJRECCacheCell.CellMode.none
        case 1: mode = CYJRECCacheCell.CellMode.one
        case 2: mode = CYJRECCacheCell.CellMode.two
        case 3: mode = CYJRECCacheCell.CellMode.three
        case 4: mode = CYJRECCacheCell.CellMode.four
        default:
            mode = CYJRECCacheCell.CellMode.none
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mode.rawValue) as? CYJRECCacheCell
        cell?.delegate = self
        
        cell?.listFrame = cellFrame
        cell?.selectionStyle = .none
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellFrame = dataSource[indexPath.row]
        
        return cellFrame.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //进去编辑页面
        let record = dataSource[indexPath.row].record
        let buildFirst = CYJRECBuildInfoViewController()
        buildFirst.grId = record.grId
        CYJRECBuildHelper.default.buildStep = .cached(indexPath)
        let buildNav = KYNavigationController(rootViewController: buildFirst)
        self.present(buildNav, animated: true, completion: nil)
    }
    
    func actionsPass(on sender: UITableViewCell) {
        
        let cacheCell = sender as! CYJRECCacheCell
        let record = cacheCell.listFrame.record
        
        
        let alert = UIAlertController(title: "是否删除", message: "删除后无法找回，是否删除？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "删除", style: .destructive) { (action) in
            
            RequestManager.POST(urlString: APIManager.Record.delete, params: ["token": LocaleSetting.token ,"grId": record.grId]) { [unowned self] (data, error) in
                //如果存在error
                guard error == nil else {
                    Third.toast.message((error?.localizedDescription)!)
                    return
                }
                Third.toast.message("删除成功")
                
                let indexPath = self.tableView.indexPath(for: cacheCell)
                
                self.dataSource.remove(at: (indexPath?.row)!)
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            }
        })
        
        //        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //        alert.addAction(UIAlertAction(title: "编辑暂存记录", style: .default) {[unowned self] (action) in
        //            //
        //            let buildFirst = CYJRECBuildInfoViewController()
        //            buildFirst.grId = record.grId
        //            CYJRECBuildHelper.default.buildStep = .editInfo
        //            let buildNav = KYNavigationController(rootViewController: buildFirst)
        //            self.present(buildNav, animated: true, completion: nil)
        //        })
        //        alert.addAction(UIAlertAction(title: "编辑评分评价", style: .default) { [unowned self] (action) in
        //            //
        //            let buildFirst = CYJRECBuildInfoViewController()
        //            buildFirst.grId = record.grId
        //
        //            CYJRECBuildHelper.default.buildStep = .editScore
        //            let buildNav = KYNavigationController(rootViewController: buildFirst)
        //            self.present(buildNav, animated: true, completion: nil)
        ////        })
        //        alert.addAction(UIAlertAction(title: "删除记录", style: .destructive) { (action) in
        //            //
        //            RequestManager.POST(urlString: APIManager.Record.delete, params: ["token": LocaleSetting.token ,"grId": record.grId]) { [unowned self] (data, error) in
        //                //如果存在error
        //                guard error == nil else {
        //                    Third.toast.message((error?.localizedDescription)!)
        //                    return
        //                }
        //                Third.toast.message("删除成功")
        //
        //                let indexPath = self.tableView.indexPath(for: cacheCell)
        //
        //                self.dataSource.remove(at: (indexPath?.row)!)
        //                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        //            }
        //        })
        //        alert.addAction(UIAlertAction(title: "取消", style: .cancel) { (action) in
        //            //
        //        })
        
        self.present(alert, animated: true) {
            //
        }
    }
}
