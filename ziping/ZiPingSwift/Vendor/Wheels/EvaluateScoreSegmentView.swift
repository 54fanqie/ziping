//
//  EvaluateScoreSegmentView.swift
//  ZiPingSwift
//
//  Created by fanqie on 2018/9/18.
//  Copyright © 2018年 Chinayoujiao. All rights reserved.
//

import UIKit

class EvaluateScoreSegmentView: ScrollSegmentBase {
    
    /// 点击响应的closure(click title)
     var titleBtnOnClick:((_ label: UILabel, _ index: Int) -> Void)?
    /// self.bounds.size.width
     var currentWidth: CGFloat = 0
    /// 记录当前选中的下标
     var currentIndex = 0
    /// 记录上一个下标
     var oldIndex = 0
    /// 用来缓存所有标题的宽度, 达到根据文字的字数和font自适应控件的宽度(save titles; width)
     var titlesWidthArray: [CGFloat] = []
    
    /// 头像、名字数据
     var titles:[String]
     var images:[String]
    
    
    // 存储头像、名字视图对象：label、imageView
     var labelsArray: [UILabel] = []
     var imageViewsArray: [UIImageView] = []
     var logImageViewArray: [UIImageView] = []
    //滚动箭头的宽和高
    let arrowImageViewHeight : CGFloat =  5
    let arrowImageViewWidth  : CGFloat =  21
    
    
    // 标题的滚动背景视图
     lazy var scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.bounces = true
        scrollV.isPagingEnabled = false
        scrollV.scrollsToTop = false
        scrollV.theme_backgroundColor = Theme.Color.main
        return scrollV
        
    }()
    //未选中状态颜色
    let unSelectColor = UIColor(red: 255.0/255.0, green:190.0/255.0, blue: 207/255.0, alpha: 1.0)
    // 滚动箭头
    fileprivate lazy var scrollArrowImageView: UIImageView? = {[unowned self] in
        let arrow = UIImageView()
        arrow.image = #imageLiteral(resourceName: "user-on-icon")
        return arrow
    }()
    
    
    
    //MARK:- life cycle
    public init(frame: CGRect, titles: [String],images: [String]) {
        
        self.titles = titles
        self.images = images
        super.init(frame: frame)
        
        addSubview(scrollView)
        // 根据titles添加相应的控件
        setupTitles()
        // 设置frame
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - private helper
extension EvaluateScoreSegmentView {
    fileprivate func setupTitles() {
        for (index, title) in titles.enumerated() {
            
            let label = CustomLabel(frame: CGRect.zero)
            label.tag = index
            label.text = title
            label.textColor = unSelectColor
            label.font = UIFont.systemFont(ofSize: 11)
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            
            // 计算文字尺寸
            let size = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
            //FIXME: 这里title的宽度要重新设置一下，
            titlesWidthArray.append(size.width + 30 + 5)
            // 缓存label
            labelsArray.append(label)
            // 添加label
            scrollView.addSubview(label)
            
            //头像
            let imageView = UIImageView(frame: CGRect.zero)
            imageView.kf.setImage(with: URL(fragmentString: images[index]) ,placeholder: #imageLiteral(resourceName: "default_user"))
            imageView.layer.cornerRadius = 15
            imageView.tag = index
            imageView.layer.borderWidth = 0.1
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.masksToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.alpha = 0.85
            imageViewsArray.append(imageView)
            scrollView.addSubview(imageView)
            
            //已评价标志
            let logImageView = UIImageView(frame: CGRect.zero)
            logImageView.image = #imageLiteral(resourceName: "user-yp")
            logImageViewArray.append(logImageView)
            scrollView.addSubview(logImageView)
            
            // 给头像、名字都添加点击手势切换页面
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelOnClick(_:)))
            label.addGestureRecognizer(tapGes)
            let tapGes2 = UITapGestureRecognizer(target: self, action: #selector(self.headerImageViewOnClick(_:)))
            imageView.addGestureRecognizer(tapGes2)
            
        }
    }
    func titleLabelOnClick(_ tapGes: UITapGestureRecognizer) {
        guard let currentLabel = tapGes.view as? CustomLabel else { return }
        currentIndex = currentLabel.tag
        adjustUIWhenBtnOnClickWithAnimate(true)
        
    }
    func headerImageViewOnClick(_ tapGes: UITapGestureRecognizer) {
        guard let headerImageView = tapGes.view as? UIImageView else { return }
        currentIndex = headerImageView.tag
        adjustUIWhenBtnOnClickWithAnimate(true)
        
    }
    //初始化UI视图
    fileprivate func setupUI() {
        // 先设置label的位置
        setUpPhotoViewPosition()
        //设置scoreView
        currentWidth = bounds.size.width
        scrollView.frame = CGRect(x: 0.0, y: 0.0, width: currentWidth, height: bounds.size.height)
        
        // 设置scrollView的contentSize滚动区域
        if let lastLabel = labelsArray.last {
            scrollView.contentSize = CGSize(width: lastLabel.frame.maxX + 30, height: 0)
        }
    }
    
    // 先设置label的位置，根据lable确定位置，在设置滚动条位置
    fileprivate func setUpPhotoViewPosition() {
        var titleX: CGFloat = 0.0
        let titleY: CGFloat = 4
        var titleW: CGFloat = 0.0
        
        titleX = 30
        
        for (index, label) in labelsArray.enumerated() {
            titleW = titlesWidthArray[index]
            
            if index != 0 {
                let lastLabel = labelsArray[index - 1]
                titleX = lastLabel.frame.maxX + 30
            }
            //设置头像位置
            let imageView = imageViewsArray[index]
            imageView.frame = CGRect(x: 0, y: titleY, width: 30, height: 30)
            
            //设置已评标志位置
            let logimageView = logImageViewArray[index]
            logimageView.frame = CGRect(x: 0, y: titleY - 4, width: 16, height: 9)
            
            label.frame = CGRect(x: titleX - 30, y:imageView.frame.maxY + 5 , width: titleW, height: 15)
            //直接设置中心位置，方便位置校准
            imageView.center.x = label.center.x
            logimageView.center.x = label.center.x
        }
        
        
        // 设置初始状态文字的颜色
        let firstLabel = labelsArray[0] as? CustomLabel
        firstLabel?.textColor = UIColor.white
        // 设置初始头像的颜色
        let  firstheaderImageView = imageViewsArray[0]
        firstheaderImageView.alpha = 1
        firstheaderImageView.layer.borderWidth = 1
        
        
        //设置滚动条和cover的位置
        scrollView.addSubview(scrollArrowImageView!)
        let coverW = labelsArray[0].frame.width
        let coverY = bounds.size.height - arrowImageViewHeight
        scrollArrowImageView?.frame = CGRect(x: (coverW - arrowImageViewWidth)/2, y: coverY, width: arrowImageViewWidth, height: arrowImageViewHeight)
    }
    
}




extension EvaluateScoreSegmentView {
    
    // 更改文字颜色状态、头像选择状态
    func changeSelectStatuas(oldIndex: Int, currentIndex: Int){
        //名称恢复未选中
        let oldLabel = labelsArray[oldIndex] as! CustomLabel
        oldLabel.textColor = unSelectColor
        //名称选中
        let currentLabel = labelsArray[currentIndex] as! CustomLabel
        currentLabel.textColor = UIColor.white
        
        //头像恢复未选中
        let oldHeaderImageView = imageViewsArray[oldIndex]
        oldHeaderImageView.layer.borderWidth = 0
        oldHeaderImageView.alpha = 0.85
        //头像选中
        let currentHeaderImageView  = imageViewsArray[currentIndex]
        currentHeaderImageView.layer.borderWidth = 1
        currentHeaderImageView.alpha = 1
    }
    
    
    // 自动或者手动点击按钮的时候调整UI
    public func adjustUIWhenBtnOnClickWithAnimate(_ animated: Bool) {
        // 重复点击时的相应, 这里没有处理, 可以传递给外界来处理
        if currentIndex == oldIndex {
            return
        }
        //获取当前点击头像，以确定滚动条位置
        let currentLabel = labelsArray[currentIndex] as! CustomLabel
        
        adjustTitleOffSetToCurrentIndex(currentIndex)
        
        let animatedTime = animated ? 0.2 : 0.0
        UIView.animate(withDuration: animatedTime, animations: {[unowned self] in
            // 更改文字颜色状态、
            self.changeSelectStatuas(oldIndex: self.oldIndex,currentIndex: self.currentIndex)
            // 设置滚动条的位置与宽度
            self.scrollArrowImageView?.frame.origin.x = currentLabel.frame.origin.x + currentLabel.frame.size.width/2 - 10
        })
        oldIndex = currentIndex
        //切换controller
        titleBtnOnClick?(currentLabel, currentIndex)
    }
    
    
    // 手动滚动时需要提供动画效果
    override func adjustUIWithProgress(_ progress: CGFloat,  oldIndex: Int, currentIndex: Int) {
        
        //获取当前的lable以及移动到的label 计算x坐标
        let oldLabel = labelsArray[oldIndex] as! CustomLabel
        let currentLabel = labelsArray[currentIndex] as! CustomLabel
        
        // 从一个label滚动到另一个label 需要改变的总的距离 和 总的宽度
        let xDistance = currentLabel.frame.origin.x - oldLabel.frame.origin.x
        
        // 设置滚动条位置 = 最初的位置 + 改变的总距离 * 进度
        scrollArrowImageView?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress + (currentLabel.frame.size.width - arrowImageViewWidth)/2
        
        
        // 更改文字颜色状态、
        self.changeSelectStatuas(oldIndex: self.oldIndex,currentIndex: currentIndex)
        // 记录当前的currentIndex,在下次更新时使用
        self.oldIndex = currentIndex
    }
    
    
    
    
    // 居中显示title
    override func adjustTitleOffSetToCurrentIndex(_ currentIndex: Int) {
        
        let currentLabel = labelsArray[currentIndex]
        
        
        // 目标是让currentLabel居中显示
        var offSetX = currentLabel.center.x - currentWidth / 2
        if offSetX < 0 {
            // 最小为0
            offSetX = 0
        }
        var maxOffSetX = scrollView.contentSize.width - currentWidth
        
        // 可以滚动的区域小余屏幕宽度
        if maxOffSetX < 0 {
            maxOffSetX = 0
        }
        
        if offSetX > maxOffSetX {
            offSetX = maxOffSetX
        }
        
        scrollView.setContentOffset(CGPoint(x:offSetX, y: 0), animated: true)
        
        
    }
}

