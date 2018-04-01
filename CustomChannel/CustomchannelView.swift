//
//  CustomchannelView.swift
//  GenialTone
//
//  Created by 孙凯峰 on 2017/8/17.
//  Copyright © 2017年 SNDA. All rights reserved.
//

import UIKit

class CustomchannelView: UIView, UITableViewDataSource, UITableViewDelegate {
    var backgrouncView: UIView!
    var CustomTableview: UITableView!
    var selectTagDict = [String:AnyObject]()
    
    var customchannelViewDismissBlock: (([PureTagModel]) -> Void)?
    fileprivate var selectedtagList: PureTagList!//已选择的标签
    var selectedtitleModels:[PureTagModel] = []
    fileprivate var tagList0: PureTagList!//第一个分区的标签
    var tagList0Models:[PureTagModel] = [] //第一个分区的数据
    fileprivate var playGametagList: PureTagList!//第二个分区的标签
    fileprivate var entertainmenttagList: PureTagList!//第三个分区的标签
    // MARK: - init
    convenience init() {
        self.init(frame:CGRect(x: 0, y: 0, width: UIScreen.appWidth(), height: UIScreen.appHeight()-67))
        self.layer.cornerRadius = 10
        CustomTableview.reloadData()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgrouncView = UIView(frame: .zero)
        backgrouncView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.backgroundColor = .white
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.top)
            make.size.equalTo(CGSize(width: 30, height: 50))
        }

        var playGameModels:[PureTagModel] = []
        var entertainmentModels:[PureTagModel] = []

      // 可从外部传入
        let arr0 = ["夜的第七章","听妈妈的话","千里之外 ","本草纲目","退后","贻笑大方","红模仿","心雨","白色风车"," 迷迭香","菊花台"]
        let arr1 = ["不能说的秘密","牛仔很忙","彩虹","青花瓷","阳光宅男","蒲公英的约定","无双","我不配","扯","甜甜的","最长的电影"]
        let arr2 = ["龙战骑士","给我一首歌的时间","蛇舞","花海","魔术先生","说好的幸福呢","兰亭序","流浪诗人","时光机","稻香"]


        for (i,str) in arr0.enumerated() {
            let model = PureTagModel(title: str, category_id:   NSNumber.init(value: i))
            tagList0Models.append(model)
        }
        for (i,str) in arr1.enumerated() {
            let model = PureTagModel(title: str, category_id:   NSNumber.init(value: i+12))
            playGameModels.append(model)
        }
        for (i,str) in arr2.enumerated() {
            let model = PureTagModel(title: str, category_id:   NSNumber.init(value: i+12))
            entertainmentModels.append(model)
        }



        selectedtagList = PureTagList(frame: CGRect(x: 0, y: 34, width: UIScreen.appWidth(), height: 0))
        let itemWidth2 = (UIScreen.appWidth() - 15*3-24)/4
        selectedtagList.tagSize = CGSize(width: itemWidth2, height: 26)
        selectedtagList.clickTagBlock = {[weak self] (model: PureTagModel) in
            self?.selectedtagclick(model)
        }
        selectedtagList.isSort = true
        selectedtagList.addTags(selectedtitleModels)

        tagList0 = PureTagList(frame: CGRect(x: 0, y: 34, width: UIScreen.appWidth(), height: 0))
        tagList0.tagSize = CGSize(width: itemWidth2, height: 26)
        tagList0.clickTagBlock = {[weak self] (model: PureTagModel) in
            self?.otherTagClick(model)
        }
        tagList0.tagBackgroundColor = .white
        tagList0.borderColor = .gray
        tagList0.tagTitleColor = .gray
        tagList0.isAddDeleteImageView = false
        tagList0.addTags(tagList0Models)

        playGametagList = PureTagList(frame: CGRect(x: 0, y: 34, width: UIScreen.appWidth(), height: 0))
        playGametagList.tagSize = CGSize(width: itemWidth2, height: 26)
        playGametagList.isAddDeleteImageView = false

        playGametagList.clickTagBlock = {[weak self] (model: PureTagModel) in
            self?.otherTagClick(model)
        }
        playGametagList.tagBackgroundColor = .white
        playGametagList.borderColor = .gray
        playGametagList.tagTitleColor = .gray
        playGametagList.addTags(playGameModels)

        entertainmenttagList = PureTagList(frame: CGRect(x: 0, y: 34, width: UIScreen.appWidth(), height: 0))
        entertainmenttagList.isAddDeleteImageView = false
        entertainmenttagList.tagSize = CGSize(width: itemWidth2, height: 26)
        entertainmenttagList.clickTagBlock = {[weak self] (model: PureTagModel) in
            self?.otherTagClick(model)
        }
        entertainmenttagList.tagBackgroundColor = .white
        entertainmenttagList.borderColor = .gray
        entertainmenttagList.tagTitleColor = .gray
        entertainmenttagList.addTags(entertainmentModels)

        CustomTableview = UITableView()
        CustomTableview.delegate = self
        CustomTableview.dataSource = self
        CustomTableview.register(SelectedChannelCell.self, forCellReuseIdentifier: "SelectedChannelCell")
        CustomTableview.separatorStyle = .none
        self.addSubview(CustomTableview)
        CustomTableview.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(7)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedChannelCell") as!  SelectedChannelCell
        if  indexPath.row == 0 {
            cell.tagList = self.selectedtagList
            cell.markLabel.isHidden = false
        } else if indexPath.row == 1 {
            cell.tagList = self.tagList0
            cell.channelNameLabel.text = "依然范特西"
        } else if indexPath.row == 2 {
            cell.tagList = self.playGametagList
            cell.channelNameLabel.text = "不能说的秘密"

        } else if indexPath.row == 3 {
            cell.tagList = self.entertainmenttagList
            cell.channelNameLabel.text = "魔杰座"

        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return selectedtagList.tagListH! + 44
        } else if indexPath.row == 1 {
            return tagList0.tagListH! + 44
        } else if indexPath.row == 2 {
            return playGametagList.tagListH! + 44
        } else if indexPath.row == 3 {
            return entertainmenttagList.tagListH! + 44
        }
        return 0
    }

    // MARK: - tag 点击方法 selectedtagclick
    func selectedtagclick(_ model: PureTagModel) {
        ////        // 标签最少6个
        //        if selectedtagList.tagModelArray.count == 6 {
        ////            BaseToast.toast(failure: "提示", message: "请至少保留6个频道！")
        //            return
        //        }
        selectedtagList.deleteTag(model.title)

        switch model.category_type {
        case 1:
            playGametagList.addTag(model)
        case 2:
            tagList0.addTag(model)
        case 3:
            entertainmenttagList.addTag(model)
        default:
            break
        }
        CustomTableview.reloadData()
    }
    func otherTagClick (_ model: PureTagModel) {
        switch model.category_type {
        case 1:
            playGametagList.deleteTag(model.title)
        case 2:
            tagList0.deleteTag(model.title)
        case 3:
            entertainmenttagList.deleteTag(model.title)
        default:
            break
        }
        selectedtagList.addTag(model)
        CustomTableview.reloadData()
    }

    fileprivate lazy var cancelBtn: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "btn_close_nor"), for: .normal)
        v.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        return v
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - show
    func show(inView view: UIView) {
        UIApplication.shared.delegate?.window??.addSubview(backgrouncView)
        backgrouncView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIApplication.shared.delegate?.window??.addSubview(self)
        let size = frame.size
        frame = CGRect(x: (view.frame.size.width - size.width)/2, y: view.frame.size.height + 50, width: size.width, height: size.height)
        backgrouncView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.backgrouncView.alpha = 1
            self.frame = CGRect(x: (view.frame.size.width - size.width)/2, y: view.frame.size.height - size.height, width: size.width, height: size.height)
        }

    }
    @objc func cancelAction(_ sender: UIButton) {
        self.customchannelViewDismissBlock!(selectedtagList.tagModelArray)
        dismiss()
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        let testBtnPoint = cancelBtn.convert(point, from: self)
        if (self.cancelBtn.point(inside: testBtnPoint, with: event)) {
            return self.cancelBtn
        }

        return result
    }
    // MARK: - dismiss
    func dismiss() {
        let size = frame.size
        UIView.animate(withDuration: 0.25, animations: {
            self.backgrouncView.alpha = 0
            self.frame = CGRect(x: (self.superview!.frame.size.width - size.width)/2, y: self.superview!.frame.size.height + 50, width: size.width, height: size.height)
        }) { (_) in
            self.backgrouncView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

}
