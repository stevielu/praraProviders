//
//  AccountCell.swift
//  Provider
//
//  Created by imac on 27/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

class MyAccountSettingCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.width = globalStyle.screenSize.width-37.5
            super.frame = frame
        }
    }
    
    var cellTitle:UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = globalStyle.nameTitleFont
        nameLabel.textColor = globalStyle.nameTextColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    var arrow:UIImageView = {
        let arrow = UIImageView()
        arrow.image = UIImage(named: "arrow")!
        arrow.translatesAutoresizingMaskIntoConstraints = false
        return arrow
    }()
    
    var avatar:UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()
    
    var badge = SwiftBadge()
    
    override init(style:UITableViewCellStyle,reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemneted")
    }
    
    func configureBadge(){
        //badge.insets = CGSize(width: 10, height: 10 )
        badge.badgeColor = UIColor.redColor()
        badge.textColor = UIColor.whiteColor()
        badge.shadowOpacityBadge = 0.5
        badge.shadowOffsetBadge = CGSize(width: 0, height: 0)
        badge.shadowRadiusBadge = 1.0
        badge.shadowColorBadge = UIColor.blackColor()
        badge.font = globalStyle.dateTitleFont
        badge.alpha = 0.0
    }
    
    func setupViews(){
        configureBadge()
        addSubview(cellTitle)
        addSubview(badge)
        addSubview(arrow)
        
        self.cellTitle.snp_makeConstraints{(make) in
            make.center.equalTo(self)
            make.left.equalTo(25)
        }
        
        self.badge.snp_makeConstraints{(make) in
            make.center.equalTo(self)
            make.width.height.equalTo(25)
            make.right.equalTo(55)
            //make.edges.equalTo(self).inset(UIEdgeInsets(top: 25.5, left: globalStyle.screenSize.width-36, bottom: 25.5, right: 12.5))
        }
        
        self.arrow.snp_makeConstraints{(make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 20, left: globalStyle.screenSize.width-37.5-12.5-10, bottom: 20, right: 12.5))
        }
        
    }
}
