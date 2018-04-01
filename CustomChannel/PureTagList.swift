//
//  PureTagList.swift
//  PureTagList
//
//  Created by 孙凯峰 on 2017/8/17.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//

import UIKit

class PureTagList: UIView {
    /* 标签删除图片 */
    var tagDeleteimage: UIImage?
    var isAddDeleteImageView: Bool = true
    /*   标签间距,和距离左，上间距,默认10 */
    var tagMargin: CGFloat = 10.0
    /* 标签颜色，默认白色 */
    var tagTitleColor: UIColor = .white
    /*  标签背景颜色 */
    var tagBackgroundColor: UIColor = .blue
    /*  标签背景图片   */
    var tagFont: UIFont = UIFont.systemFont(ofSize: 13)
    /* 标签按钮内容间距，标签内容距离左上下右间距，默认5 */
    var tagCornerRadius: CGFloat = 11
    var tagButtonMargin: CGFloat = 5
    var tagListH: CGFloat? {
        get {
            if self.tagButtons.count <= 0 {
                return 0
            }
            return (self.tagButtons.last?.frame)!.maxY + 0
        }
    }
    var borderWidth: CGFloat = 0.5
    var borderColor: UIColor = .blue
    /** 获取所有标签*/
    lazy private(set) var tagModelArray = [PureTagModel]()
    /* 是否需要自定义tagList高度，默认为true*/
    var isFitTagListH: Bool = true
    /* 是否需要排序功能*/
    var isSort: Bool = false
    var scaleTagInSort: CGFloat = 1.3 {
        didSet {
            let scale: CGFloat = 1.0
            if  scaleTagInSort < scale {
                print("scaleTagInSort必须大于1")
            }
        }
    }
    var tagClass: UIButton?
    var tagSize: CGSize?
    /*标签间距会自动计算*/
    var tagListCols: Int = 4
    var clickTagBlock: ((PureTagModel) -> Void)?
    weak var  tagListView: UICollectionView?
    lazy var tags: [String: AnyObject] = [String:AnyObject]()
    lazy var tagButtons: [UIButton] = [UIButton]()
    /* 需要移动的矩阵 */
    var moveFinalRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var oriCenter: CGPoint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 添加多个标签
    func addTags(_ tagStrs: [PureTagModel]) {
        assert(self.frame.size.width != 0, "先设置标签列表的frame")
        for titleModel in tagStrs {
            self.addTag(titleModel)
        }
    }
    func addTag(_ titleModel: PureTagModel) {
        let tagStr = titleModel.title
        if (self.tags[tagStr] != nil) {
            // 重复标签不添加
            return
        }
        let tagButton = PureTagButton(frame:CGRect(x: 0, y: 0, width: (tagSize?.width)!, height: (tagSize?.height)!))
        tagButton.setTitle("fff", for: .normal)
        var  normalImage = UIImage.image(color: tagBackgroundColor, size: tagSize!)
        normalImage = normalImage?.roundCorner(radius: (tagSize?.height)!/2, borderWidth: 0.5, borderColor: borderColor)
        tagButton.setBackgroundImage(normalImage, for: .normal)
        tagButton.setTitleColor(tagTitleColor, for: .normal)
        tagButton.tag = self.tagButtons.count
        tagButton.setTitle(tagStr, for: .normal)
        tagButton.titleLabel?.font = tagFont
         tagButton.titleLabel?.adjustsFontSizeToFitWidth = true
        tagButton.setBackgroundImage(normalImage, for: .normal)
        tagButton.addTarget(self, action: #selector(clickTag(_:)), for: .touchUpInside)
        if isSort {
            let pan = UIPanGestureRecognizer.init(target: self, action:  #selector(pan(_:)))
            tagButton .addGestureRecognizer(pan)
        }
        self.addSubview(tagButton)
        self.tagButtons.append(tagButton)
        self.tags[tagStr]  = tagButton
        self.tagModelArray.append(titleModel)
        // 设置按钮的位置
        self.updateTagButtonFrame(tagButton.tag, extreMargin: true)
        if (isFitTagListH) {
            var frame = self.frame
            frame.size.height = self.tagListH!
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = frame
            })
        }
        if isAddDeleteImageView == false {
            tagButton.deleImgeView.isHidden = true
        }
        if tagStr == "推荐" {
            tagButton.isEnabled = false
            var disableImage = UIImage.image(color: .gray, size: tagSize!)
            disableImage = disableImage?.roundCorner(radius: (tagSize?.height)!/2, borderWidth: 0.5, borderColor: .gray)
            tagButton.setBackgroundImage(disableImage, for: .disabled)
            tagButton.setTitleColor(.gray, for: .disabled)
            tagButton.deleImgeView.isHidden = true
        }

    }
    @objc func clickTag(_ sender: UIButton) {
        if (clickTagBlock != nil) {
            let model = self.tagModelArray [sender.tag]
            clickTagBlock!(model)
        }
    }
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        //获取偏移量
        let transP = sender.translation(in: self)
        let tagButton = sender.view as! UIButton
        // 开始
        if sender.state == .began {
            oriCenter = tagButton.center
            UIView.animate(withDuration: 0.25, animations: {
                tagButton.transform = CGAffineTransform(scaleX: self.scaleTagInSort, y: self.scaleTagInSort)
            })
            self.addSubview(tagButton)
        }
        var center = tagButton.center
        center.x += transP.x
        center.y += transP.y
        tagButton.center = center
        // 改变
        if sender.state == .changed {
            let otherButton = self.buttonCenterInButtons(tagButton)
            if (otherButton != nil) { //插入到当前按钮的位置
                // 获取插入的角标
                let i = otherButton?.tag
                // 这里可以设置哪个标签不被改变
//                if  i == 0 {
//                    return
//                }
                //获取当前角标
                let curI = tagButton.tag
                let model = self.tagModelArray[curI]
                moveFinalRect = (otherButton?.frame)!
                //排序
                // 移除之前的按钮
                self.tagButtons.remove(at: curI)
                self.tagButtons.insert(tagButton, at: i!)
                self.tagModelArray .remove(at: curI)
                self.tagModelArray.insert(model, at: i!)
                //更新tag
                self.updateTag()
                if curI > i! {//向前插入
                    //更新之后的标签frame
                    UIView.animate(withDuration: 0.25, animations: {
                        self.updateLaterTagButtonFrame(i!+1)
                    })
                } else { // 往后插入
                    UIView.animate(withDuration: 0.25, animations: {
                        self.updateBeforeTagButtonFrame(i!)
                    })
                }
            }
        }
        // 结束
        if sender.state == .ended {
            print("--self.tagArray --\(self.tagModelArray)")
            UIView.animate(withDuration: 0.25, animations: {
                tagButton.transform = CGAffineTransform.identity
                if self.moveFinalRect.size.width <= CGFloat(0) {
                    tagButton.center = self.oriCenter!
                } else {
                    tagButton.frame = self.moveFinalRect
                }
            }, completion: { (true) in
                self.moveFinalRect = .zero
            })
        }
        sender.setTranslation(.zero, in: self)
    }
    //更新标签
    func updateTag() {
        for (i, button) in self.tagButtons.enumerated() {
            let tagButton = button
            tagButton.tag = i
        }
    }
    func deleteTag(_ tagStr: String) {
        //  获取对应的标签
        guard let button = self.tags[tagStr] as? UIButton else {
            return
        }
        button.removeFromSuperview()
        self.tagButtons.remove(at: (button.tag))
        self.tags.removeValue(forKey: tagStr)
        self.tagModelArray.remove(at: (button.tag))
        self.updateTag()
        UIView.animate(withDuration: 0.25) {
            self.updateLaterTagButtonFrame((button.tag))
        }
        if isFitTagListH {
            var frame = self.frame
            frame.size.height = self.tagListH!
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = frame
            })
        }
    }

    func updateBeforeTagButtonFrame(_ beforeI: Int) {
        for i in 0..<beforeI {
            // 更新按钮
            updateTagButtonFrame(i, extreMargin: false)
        }
    }
    //更新以后的按钮
    func updateLaterTagButtonFrame(_ laterI: Int) {
        let count: Int = tagButtons.count
        for i in laterI..<count {
            // 更新按钮
            updateTagButtonFrame(i, extreMargin: false)
        }
    }
    func updateTagButtonFrame(_ i: Int, extreMargin: Bool) {
        //获取上一个按钮
        let preI = i - 1
        //定义上一个按钮
        var preButton: UIButton?
        //过滤上一个脚标
        if preI >= 0 {
            preButton = self.tagButtons[preI]
        }
        //获取当前按钮
        let tagButton = self.tagButtons[i]
        // 判断是否设置标签的尺寸
        //        if  tagSize?.width == 0 {// 没有设置标签尺寸
        // 自适应标签尺寸
        self.setupTagButtonRegularFrame(tagButton)
        //        }

    }
    // 看下当前按钮中心点在哪个按钮上
    func buttonCenterInButtons(_ curButton: UIButton) -> UIButton? {
        for button in self.tagButtons {
            if curButton == button {
                continue
            }
            if button.frame.contains(curButton.center) {
                return button
            }
        }
        return nil
    }

    func setupTagButtonRegularFrame(_ tagButton: UIButton) {
        // 获取角标
        let i = tagButton.tag
        let col = i % tagListCols
        let row = i / tagListCols
        let btnW: CGFloat = (tagSize?.width)!
        let btnH: CGFloat = (tagSize?.height)!
        let margin = (self.bounds.size.width - CGFloat(tagListCols) * btnW - 2 * tagMargin) / CGFloat(tagListCols - 1)
        let btnX =  tagMargin + CGFloat(col) * (btnW + margin)
        let btnY = tagMargin + CGFloat(row) * (btnH + margin)
        tagButton.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)

    }
}
class PureTagButton: UIButton {
    var margin: CGFloat?
    var deleImgeView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        deleImgeView = UIImageView(frame: CGRect(x: bounds.size.width-12, y: -5, width: 17, height: 17))
        addSubview(deleImgeView!)
        deleImgeView.image = UIImage(named: "btn_delete")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class  PureTagModel: NSObject {
    var title: String    = ""
    var oriImageUrl: String = ""
    var highlightImageUrl: String = ""

    var category_id: NSNumber = 0
    var category_type: NSNumber = 0

    init(title: String, category_id: NSNumber) {
        self.title = title
        self.category_id = category_id
    }
}
