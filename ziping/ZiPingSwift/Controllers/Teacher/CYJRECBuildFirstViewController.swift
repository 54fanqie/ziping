//
//  CYJRECBuildFirstViewController.swift
//  ZiPingSwift
//
//  Created by kyang on 2017/8/30.
//  Copyright © 2017年 Chinayoujiao. All rights reserved.
//

import UIKit

class CYJRECBuildFirstViewController: UIViewController {

    var dynamicTree: KYDynamicTree!
    var allDomains: [CYJDomain]!
    var allnodes: [KYDynamicTreeNode] = []
    var evaluateScoreSegmentView : EvaluateScoreSegmentView!
    /// 整个界面通过recordParam 创建
    var recordParam : CYJNewRECParam {
        return CYJRECBuildHelper.default.recordParam
    }
    
    var index: Int = 0
    
    var evaluate: CYJNewRECParam.ChildEvaluate {
        return self.recordParam.info[index]
    }
    var selectedNodes = [KYDynamicTreeNode]() {
        didSet{
            if let com = IamChangedHandler {
                com(selectedNodes.count > 0)
            }
        }
    }
    
    var IamChangedHandler: CYJCompleteHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.theme_backgroundColor = Theme.Color.ground
        // Do any additional setup after loading the view.
        
        self.makeData()
        
        if allnodes.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 35, y: 100, width: Theme.Measure.screenWidth - 70, height: 100))
            emptyLabel.text = "该年级园长未设置成评价指标，暂不能设置评分"
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            emptyLabel.lineBreakMode = .byWordWrapping
            emptyLabel.theme_textColor = Theme.Color.textColorlight
            
            view.addSubview(emptyLabel)
        }else {
            
            // 滚动条
//            evaluateScoreSegmentView = EvaluateScoreSegmentView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80), titles: children, images: images)
            view.addSubview(evaluateScoreSegmentView)
            
            dynamicTree = KYDynamicTree(frame: CGRect(x: 0, y: 80, width: view.frame.width, height: Theme.Measure.screenHeight - 64 - 58 - 8 - 44 - 44 ), nodes: self.allnodes)
            dynamicTree.delegate = self
            view.addSubview(dynamicTree)
        }
    }
    
    func makeData() {
        
        let evaluate = self.recordParam.info[index]
        let allSelected = evaluate.lId
        let allSelectedDID = evaluate.dId
        let allSelectedDiID = evaluate.diId
        let allSelectedQid = evaluate.qId

        self.allDomains.forEach { (domain) in
            let dnode = KYDynamicTreeNode()
//            dnode.floor = 0
            dnode.shouldSelected = false
            dnode.fatherNodeId = nil
            dnode.nodeId = "domain-" + "\(domain.dId ?? 0)"
            dnode.name = domain.dName
//            dnode.ext = ["name":"北京大洋国际科技有限公司", "count": "3"]
            dnode.markedCount = allSelectedDID.filter({ $0 == "\(domain.dId ?? 0)"}).count
            allnodes.append(dnode)
            
            domain.dimension?.forEach({ (dimension) in
                let dinode = KYDynamicTreeNode()
//                dinode.floor = 1
                dinode.shouldSelected = false
                dinode.fatherNodeId = dnode.nodeId
                dinode.nodeId = "dimension" + dimension.diId!
                dinode.name = dimension.diName
//                dinode.ext = ["name":"北京大洋国际科技有限公司", "count": "3"]
                dinode.markedCount = allSelectedDiID.filter({ $0 == "\(dimension.diId ?? "0")"}).count

                allnodes.append(dinode)
                dimension.quota?.forEach({ (quota) in
                    let qunode = KYDynamicTreeNode()
//                    qunode.floor = 2
                    qunode.shouldSelected = false
                    qunode.fatherNodeId = dinode.nodeId
                    qunode.nodeId = "quota" + quota.qId!
                    qunode.name = quota.qTitle
//                    qunode.ext = ["name":"北京大洋国际科技有限公司", "count": "3"]
                    qunode.markedCount = allSelectedQid.filter({ $0 == "\(quota.qId ?? "0")"}).count


                    allnodes.append(qunode)
                    quota.level?.forEach({ (level) in
                        let lenode = KYDynamicTreeNode()
//                        lenode.floor = 3
                        lenode.shouldSelected = true
                        lenode.fatherNodeId = qunode.nodeId
                        lenode.nodeId = "level-" + level.lId!
                        lenode.name = level.lName
                        lenode.ext = ["lId": "\(level.lId!)"]
                        
                            if allSelected.contains("\(level.lId!)") {
                                lenode.isSelected = true
                                selectedNodes.append(lenode)
                            }
                        
                        allnodes.append(lenode)
                    })
                })
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CYJRECBuildFirstViewController: KYDynamicTreeDelegate {
    func dynamicTree(_ dynamicTree: KYDynamicTree, didSelectedRowWith node: KYDynamicTreeNode) {
        //
    }
    func dynamicTree(_ dynamicTree: KYDynamicTree, didSelectedStatusButtonWith node: KYDynamicTreeNode) {
        // 查找相同父id的内容，如果存在，那么更新，否则直接加！
        
        if node.isSelected { //选中当前
            if let index = selectedNodes.index(where: {$0.fatherNodeId == node.fatherNodeId}) {
                selectedNodes[index] = node
            }else
            {
                selectedNodes.append(node)
            }
        }else
        {
            //取消选中当前
            if let index = selectedNodes.index(where: {$0.fatherNodeId == node.fatherNodeId}) {
                selectedNodes.remove(at: index)
            }
        }
    }
}

