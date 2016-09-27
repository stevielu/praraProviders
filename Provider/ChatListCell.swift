//
//  ChatListCell.swift
//  Provider
//
//  Created by imac on 2/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit
import SnapKit

struct unreadFormat {
    let userName:String
    let unreads:Int
}

class ConversationTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    var userEmail = ""
    
    var UserName:UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = globalStyle.nameTitleFont
        nameLabel.textColor = globalStyle.nameTextColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    var latestMsg:UILabel = {
        let latestMsgLabel = UILabel()
        latestMsgLabel.font = globalStyle.subTitleFontsize
        latestMsgLabel.textColor = globalStyle.subTitleColor2
        latestMsgLabel.translatesAutoresizingMaskIntoConstraints = false
        return latestMsgLabel
    }()
    
    var UserAvatar:UIImageView = {
        let avatar = UIImageView()
       // avatar.image = help.reSizeImage(scaledToSize: globalStyle.avatarSize)
        avatar.layer.cornerRadius = 25.0;
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = globalStyle.backgroundColor.CGColor
        avatar.clipsToBounds = true;
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()
    
    var latestDate:UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = globalStyle.dateTitleFont
        dateLabel.textColor = globalStyle.subTitleColor2
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    var badge = SwiftBadge()
    
    override init(style:UITableViewCellStyle,reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.userEmail = ""
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
        addSubview(UserName)
        addSubview(UserAvatar)
        addSubview(latestDate)
        addSubview(latestMsg)
        addSubview(badge)
        
        self.badge.snp_makeConstraints{(make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 25.5, left: globalStyle.screenSize.width-36, bottom: 25.5, right: 12.5))
        }
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[c4]-36-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["c4":badge]))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-25.5-[c4(>=25)]-25.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["c4":badge]))


        //auotlayout Username
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-87.5-[c0(>=100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["c0":UserName]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[c0(>=25)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["c0":UserName]))
        
        
        UserAvatar.snp_makeConstraints{(make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 12.5, left: 12.5, bottom: 12.5, right: globalStyle.screenSize.width-12.5-50))
        }
//        autolayout avatar
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12.5-[c1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["c1":UserAvatar]))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-12.5-[c1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["c1":UserAvatar]))
//
        //autolayout date
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat( "H:[c2]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["c2":latestDate]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat( "V:|[c2(>=25)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["c2":latestDate]))
        
        //autolayout subtitle
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat( "H:|-87.5-[c3(<=140)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["c3":latestMsg]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat( "V:[c3(>=25)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["c3":latestMsg]))
        

    }
}
