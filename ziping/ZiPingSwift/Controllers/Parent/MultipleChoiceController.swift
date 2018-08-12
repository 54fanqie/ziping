//
//  MultipleChoiceTableViewController.swift
//  test
//
//  Created by 番茄 on 7/24/18.
//  Copyright © 2018 fanqie. All rights reserved.
//

import UIKit
import HandyJSON

class ShiJuanModel: CYJBaseModel {
    var historyid : Int = 0
    var isfinish : Int = 0
    var shijuanid : Int = 0
    var title : String?
    var content : String?
    var shitiData : [ShiTiDetailModel] = []
}

class ShiTiDetailModel: CYJBaseModel {
    var bigTitle : String?
    var catid1 : Int = 1
    var catid2 : Int = 2
    var catid3 : Int = 3
    var choices : [ChoicesDetailModel] = []
    var questioImg : String?
    var tiid : Int = 0
    var title : String?
    var type : Int = 0
    var yueduImg : String?
}

class ChoicesDetailModel : CYJBaseModel{
    var answer : Int = 0
    var chose : String?
    var scId : Int = 0
    var score : Int = 0
    var thumb : String?
}


class MultipleChoiceController: UIViewController,UITableViewDataSource, UITableViewDelegate, MultipleChoiceDelegate {
    
    
    var shijuanid : Int = 0
    var shiJuanModel : ShiJuanModel?
    
    var dataSource : [ShiTiDetailModel] = []
    
    var table: UITableView!
    var bottmView: UIView!
    var dataArray : NSMutableArray!
    
    /// 操作bar
    var actionView: CYJActionsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "问卷测评"
        //请求数据查看是否完成
        RequestManager.POST(urlString: APIManager.Valuation.getShiti, params: ["shijuanid": self.shijuanid], complete: { [weak self] (data, error) in
            
            guard error == nil else {
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            
            
            if let datas = data as? NSDictionary {
                print(datas)
                //遍历，并赋值
                let target = JSONDeserializer<ShiJuanModel>.deserializeFrom(dict: datas )
                self?.shiJuanModel = target
                self?.dataSource = (self?.shiJuanModel?.shitiData)!
                self?.table.reloadData()
            }
        })
        
        
        table = UITableView()
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.showsVerticalScrollIndicator = false
        //设置数据源
        table.dataSource = self
        //设置代理
        table.delegate = self
        table.theme_backgroundColor = Theme.Color.viewLightColor
        self.view.addSubview(table)
        //设置estimatedRowHeight属性默认值
                table.estimatedRowHeight = 44;
//        rowHeight属性设置为UITableViewAutomaticDimension
                table.rowHeight = UITableViewAutomaticDimension;
        
        
        table.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(view).offset(0)
            make.bottom.equalTo(44).offset(0)
        }
        
        
        
        actionView = CYJActionsView(frame: CGRect(x: 0, y: view.frame.height - 44, width: view.frame.width, height: 44))
        actionView.innerPadding = 0.5
        actionView.isFull = true
        
        let saveButton = UIButton(type: .custom)
        saveButton.theme_setTitleColor(Theme.Color.textColorlight, forState: .normal)
        saveButton.theme_backgroundColor = Theme.Color.ground
        saveButton.setTitle("暂存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveButton.tag = 2;
        saveButton.addTarget(self, action: #selector(updataAciton(button:)), for: .touchUpInside)
        
        let updataBtn = UIButton(type: .custom)
        updataBtn.theme_setTitleColor(Theme.Color.ground, forState: .normal)
        updataBtn.theme_backgroundColor = Theme.Color.main
        updataBtn.setTitle("提交并完成测评", for: .normal)
        updataBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        updataBtn.tag = 2;
        updataBtn.addTarget(self, action: #selector(updataAciton(button:)), for: .touchUpInside)
        actionView.actions = [saveButton, updataBtn]
        view.addSubview(actionView)
        
        
        
        
    }
    
    
    
    @objc func updataAciton(button:UIButton) {
        switch button.tag {
        case 1:
            break
            
        case 2:
            break
            
        default:
            break
            
        }
    }
    func selectResult(parma: String) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentifier = "ChoiceCell" + String(format: "%d%d", indexPath.row,indexPath.section)
        var cell:MultipleChoiceCell! = tableView.dequeueReusableCell(withIdentifier: indentifier)as?MultipleChoiceCell
        if cell == nil {
            cell = MultipleChoiceCell(style: .default, reuseIdentifier: indentifier, cellData:(self.shiJuanModel?.shitiData[indexPath.row])!)
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.theme_backgroundColor = Theme.Color.viewLightColor
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
//        static func  getData() -> NSDictionary {
//            let mutable1 : NSMutableDictionary = NSMutableDictionary()
//            mutable1.setObject("不符合", forKey:"question"  as NSCopying)
//            mutable1.setObject(1, forKey:"answer"  as NSCopying)
//
//
//            let mutable2 : NSMutableDictionary = NSMutableDictionary()
//            mutable2.setObject("不太符合", forKey:"question"  as NSCopying)
//            mutable2.setObject(0, forKey:"answer"  as NSCopying)
//
//
//            let mutable3 : NSMutableDictionary = NSMutableDictionary()
//            mutable3.setObject("中等", forKey:"question"  as NSCopying)
//            mutable3.setObject(0, forKey:"answer"  as NSCopying)
//
//            let mutable4 : NSMutableDictionary = NSMutableDictionary()
//            mutable4.setObject("符合", forKey:"question"  as NSCopying)
//            mutable4.setObject(0, forKey:"answer"  as NSCopying)
//
//            let mutable5 : NSMutableDictionary = NSMutableDictionary()
//            mutable5.setObject("完全符合", forKey:"question"  as NSCopying)
//            mutable5.setObject(0, forKey:"answer"  as NSCopying)
//
//            let arry:[NSDictionary] =  [mutable1, mutable2, mutable3,mutable4,mutable5]
//
//
//
//
//
//
//            let dicAll : NSMutableDictionary = NSMutableDictionary()
//            dicAll.setObject("在幼儿园或学校里遵守各项常规和纪律", forKey:"title"  as NSCopying)
//            dicAll.setObject(arry, forKey:"data"  as NSCopying)
//
//
//
//
//
//            //        muArray.add(mutable1)
//            //        muArray.add(mutable2)
//            //        muArray.add(mutable1)
//            //        muArray.add(mutable2)
//            //        muArray.add(mutable1)
//            //
//            //
//            //        let muArrayAll = NSMutableArray()
//            return dicAll
//        }
}
