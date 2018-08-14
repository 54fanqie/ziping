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
    
    //要上传的参数
    var uploadChoiceslParsam = Dictionary<String,Any>()
    
    /// 操作bar
    var actionView: CYJActionsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "问卷测评"
        
        print(["shijuanid": self.shijuanid])
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
                //获取到数据后处理下准备上传的数据
                self?.assemblyData();
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
        table.estimatedRowHeight = 237;
        //rowHeight属性设置为UITableViewAutomaticDimension
        table.rowHeight = UITableViewAutomaticDimension;
        
        
        table.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.top.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(-44)
        }
        
        
        
        actionView = CYJActionsView(frame: CGRect(x: 0, y: view.frame.height - 44, width: view.frame.width, height: 44))
        actionView.innerPadding = 0.5
        actionView.isFull = true
        
        let saveButton = UIButton(type: .custom)
        saveButton.theme_setTitleColor(Theme.Color.textColorlight, forState: .normal)
        saveButton.theme_backgroundColor = Theme.Color.ground
        saveButton.setTitle("暂存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveButton.tag = 0;
        saveButton.addTarget(self, action: #selector(updataAciton(button:)), for: .touchUpInside)
        
        let updataBtn = UIButton(type: .custom)
        updataBtn.theme_setTitleColor(Theme.Color.ground, forState: .normal)
        updataBtn.theme_backgroundColor = Theme.Color.main
        updataBtn.setTitle("提交并完成测评", for: .normal)
        updataBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        updataBtn.tag = 1;
        updataBtn.addTarget(self, action: #selector(updataAciton(button:)), for: .touchUpInside)
        actionView.actions = [saveButton, updataBtn]
        view.addSubview(actionView)
        
    }
    
    
    //暂存  或者提交
    @objc func updataAciton(button:UIButton) {
        if button.tag == 1 {
            //            let result_data = getDictionaryFromJSONString(jsonString: uploadChoiceslParsam.object(forKey: "result_data") as! String)
//            let result_data = uploadChoiceslParsam.object(forKey: "result_data") as! NSDictionary
//            let dataDict = result_data.object(forKey: "data") as! NSArray
//
//            for item  in dataDict {
//                let dict = item as! NSDictionary
//
//                if dict.object(forKey: "choice") as! Int == 0 {
//                    let alert = ValuationAlertController()
//                    alert.message = "您需将所有题目完成后提交，请检查是否有遗漏掉的题目~"
//                    alert.completeHandler = { [] in
//                        alert.dismiss(animated:true, completion: nil)
//                    }
//                    alert.showAlert()
//                    return
//                }
//            }
        }
        
        uploadChoiceslParsam["isfinish"] =  button.tag
        print(toJSONString(dict: uploadChoiceslParsam))
        
       
        
        
        //        print(getDictionaryFromJSONString(jsonString: params))
        let result_data = uploadChoiceslParsam["result_data"] as! Dictionary<String,Any>
        let params = [ "datiNums" : "10",
                       "historyid" : "3",
                       "spentTime" : "0",
                       "title" : "笔试班学员专享课后测",
                       "shijuanid" : "1",
                       "isfinish" : "0",
                       "result_data" : nil]
        print(params)
//        let parameters: Dictionary = ["key" : "93c921ea8b0348af8e8e7a6a273c41bd"]
//        let headers: HTTPHeaders = ["Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
//                                    "Accept": "application/json"]
//        Alamofire.request("http://apis.haoservice.com/weather/city", method: .post,  parameters:parameters) .responseJSON {response  in
//            print("result==\(response.result)")
//            //有错误就打印错误，没有就解析数据
//            if let Error = response.result.error
//            {
//                print(Error)
//            }
//            else if let jsonValue = response.result.value
//            {
//                print("code = \(jsonValue)")
//            }
//
//        }
        

        
        RequestManager.POST(urlString: APIManager.Valuation.addAnswer, params: params ) { [weak self] (data, error) in
            //如果存在error
            guard error == nil else {
                Third.toast.message((error?.localizedDescription)!)
                return
            }
            if let info = data as? NSDictionary {
                //遍历，并赋值
                if info["status"] as! Int == 200{
                    self?.navigationController?.popToViewController(self?.navigationController?.viewControllers[1] as! QuestionnaireViewController, animated: true)
                }
                Third.toast.message(info["message"]as! String)
            }
        }
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
            cell = MultipleChoiceCell(style: .default, reuseIdentifier: indentifier, cellData:(self.shiJuanModel?.shitiData[indexPath.row])! , index : indexPath.row)
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.theme_backgroundColor = Theme.Color.viewLightColor
        cell.tag = indexPath.row
        return cell
    }
    //答案选择
    func selectResult(cellIndex : Int ,choesIndex : Int, score : String) {
 
        print(uploadChoiceslParsam)
        var result_data = uploadChoiceslParsam["result_data"] as! Dictionary<String,Any>
        let dataArray = result_data["data"] as! NSArray
        
        var dict = dataArray[cellIndex] as! Dictionary<String,Any>
        dict["choice"] = choesIndex
        dict["score"] = score
    }
    
    
    //数据组装
    func assemblyData()  {
        
        var muDict = Dictionary<String,Any>()
//        var muDict : [String : Any] = [String : Any]()
        
        muDict["title"] = self.shiJuanModel?.title
        muDict["shijuanid"] = (self.shiJuanModel?.shijuanid)!
        muDict["historyid"] = (self.shiJuanModel?.historyid)!
        muDict["isfinish"] = 0
        muDict["spentTime"] = 0
        muDict["datiNums"] = 10
        
        
        //选项数据
        let dataArray = NSMutableArray()
        for shiTiDetailModel in (self.shiJuanModel?.shitiData)! {
            var subDict = Dictionary<String,Int>()
            
            subDict["tiid"] = shiTiDetailModel.tiid
            subDict["catid1"] = shiTiDetailModel.catid1
            subDict["catid2"] = shiTiDetailModel.catid2
            subDict["catid3"] = shiTiDetailModel.catid3
            subDict["choice"] = 0
            subDict["score"] = 0
            dataArray.add(subDict)
        }
        var  dataDict = Dictionary<String,NSArray>();
        dataDict["data"] = dataArray as NSArray
        
        muDict["result_data"] = dataDict
        uploadChoiceslParsam = muDict
        
    }
    
    func toJSONString(dict: Any)-> String{
        do {
            
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let strJson = String(data: data, encoding: .utf8)
            return strJson ?? ""
        }catch
        {
            return ""
        }
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
}
