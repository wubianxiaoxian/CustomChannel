//
//  SelectedChannelCell.swift
//  GenialTone
//
//  Created by 五月 on 2017/8/21.
//  Copyright © 2017年 SNDA. All rights reserved.
//

import UIKit
import SnapKit

class SelectedChannelCell: UITableViewCell {
    var channelNameLabel: UILabel!
    var markLabel: UILabel!

    var tagList: PureTagList! {
        didSet {
            self.contentView.addSubview(tagList)

        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        channelNameLabel = UILabel()
        channelNameLabel.font = UIFont.systemFont(ofSize: 12)
        channelNameLabel.textColor = .black
        channelNameLabel.textAlignment = .center
        self.contentView.addSubview(channelNameLabel)
        channelNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(18)
            make.height.equalTo(14)
        }
        channelNameLabel.text = "已选频道"
        markLabel = UILabel()
        markLabel.textColor = .gray
        markLabel.font = UIFont.systemFont(ofSize: 12)

        markLabel.textAlignment = .center
        self.contentView.addSubview(markLabel)
        markLabel.snp.makeConstraints { (make) in
            make.left.equalTo(channelNameLabel.snp.right).offset(7)
            make.centerY.equalTo(channelNameLabel.snp.centerY)
         }
        markLabel.text = "按住推动调整顺序"
        markLabel.isHidden = true
        let bottomLine = UIImageView(image: UIImage.image(color: UIColor.gray))
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.right.left.equalTo(0)
            make.bottom.equalTo(0)
        }

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
