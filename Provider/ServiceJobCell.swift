//
//  ServiceJobCell.swift
//  Provider
//
//  Created by imac on 23/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit

class ServiceJobCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    var itemShown = false
    
    override init(style:UITableViewCellStyle,reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemneted")
    }
    
    let UserName:UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = globalStyle.nameTitleFont
        nameLabel.textColor = globalStyle.nameTextColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    let postDate:UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = globalStyle.dateTitleFont
        dateLabel.textColor = globalStyle.subTitleColor2
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    
    let subTitle:UILabel = {
        let TitleLabel = UILabel()
        TitleLabel.font = globalStyle.subTitleFontsize
        TitleLabel.textColor = globalStyle.subTitleColor2
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return TitleLabel
    }()
    
    let workType:UILabel = {
        let TypeLabel = UILabel()
        TypeLabel.font = globalStyle.nameTitleFont
        TypeLabel.textColor = globalStyle.subTitleColor2
        TypeLabel.translatesAutoresizingMaskIntoConstraints = false
        return TypeLabel
    }()
    
    let UserAvatar:UIImageView = {
        let avatar = UIImageView()
        avatar.image = help.reSizeImage(scaledToSize: globalStyle.avatarSize)
        avatar.layer.cornerRadius = 25.0;
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = globalStyle.backgroundColor.CGColor
        avatar.clipsToBounds = true;
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()
    
    let userDetails:myButton = {
        let info = myButton()
        info.setImage(iconLists.infoBtn, forState: UIControlState.Normal)
        info.translatesAutoresizingMaskIntoConstraints = false
        info.alpha = 0
        return info
    }()
    
    let userAddress:myButton = {
        let info = myButton()
        info.setImage(iconLists.infoAddress, forState: UIControlState.Normal)
        info.translatesAutoresizingMaskIntoConstraints = false
        info.alpha = 0
        return info
    }()
    let userPhone:myButton = {
        let info = myButton()
        info.setImage(iconLists.infoPhone, forState: UIControlState.Normal)
        info.translatesAutoresizingMaskIntoConstraints = false
        info.alpha = 0
        return info
    }()
    let userChat:myButton = {
        let info = myButton()
        info.setImage(iconLists.infoChat, forState: UIControlState.Normal)
        info.translatesAutoresizingMaskIntoConstraints = false
        info.alpha = 0
        return info
    }()
    let returnBtn:myButton = {
        let info = myButton()
        
        info.setImage(iconLists.returnBtn, forState: UIControlState.Normal)
        info.translatesAutoresizingMaskIntoConstraints = false
        info.alpha = 0
        info.frame.size.width = 44.0
        info.frame.size.height = 44.0
        return info
    }()
    
    func setupViews(){
        addSubview(UserName)
        addSubview(UserAvatar)
        addSubview(postDate)
        addSubview(subTitle)
        addSubview(workType)
        addSubview(userDetails)
        addSubview(userAddress)
        addSubview(userPhone)
        addSubview(userChat)
        addSubview(returnBtn)
        //auotlayout Username
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-87.5-[v0(>=100)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":UserName]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0(>=25)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":UserName]))
        
        //autolayout avatar
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12.5-[v1(<=50)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1":UserAvatar]))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-12.5-[v1(<=50)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1":UserAvatar]))
        UserAvatar.snp_makeConstraints{(make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 12.5, left: 12.5, bottom: 12.5, right: globalStyle.screenSize.width-12.5-50))
        }
        //autolayout date
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[v2]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2":postDate]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v2(>=25)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2":postDate]))
        
        //autolayout subtitle
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-87.5-[v3(<=140)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v3":subTitle]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v3(>=25)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v3":subTitle]))
        
        //autolayout type
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[v4(<=120)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v4":workType]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v4(>=25)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v4":workType]))
        
        //autolayout info button
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-87.5-[v5(>=25)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":userDetails]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v5(>=25)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":userDetails]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-137.5-[v6(>=25)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v6":userAddress]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v6(>=25)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v6":userAddress]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-187.5-[v7(>=25)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v7":userPhone]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v7(>=25)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v7":userPhone]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-237.5-[v8(>=25)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v8":userChat]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v8(>=25)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v8":userChat]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[v9(>=25)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v9":returnBtn]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v9(>=25)]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v9":returnBtn]))
    }
    
    
}
class myButton : UIButton{
    var indexPath = NSIndexPath()
}

extension myButton{
    override internal func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsetsMake(-10.5, -10.5, -10.5, -10.5)
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return CGRectContainsPoint(hitFrame, point)
    }
}