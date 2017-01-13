//
//  PAPermissionsTableViewCell.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class PAPermissionsTableViewCell: UITableViewCell {
    
    var didSelectItem: ((PAPermissionsItem) -> ())?
    
    weak var iconImageView: UIImageView!
    weak var titleLabel: UILabel!
    weak var detailsLabel: UILabel!
    
    weak var permission: PAPermissionsItem!
    
    fileprivate weak var rightDetailsContainer: UIView!
    fileprivate weak var enableButton: UIButton!
    fileprivate weak var checkingIndicator: UIActivityIndicatorView!
    
    fileprivate var _permissionStatus = PAPermissionsStatus.disabled
    var permissionStatus: PAPermissionsStatus {
        get {
            return self._permissionStatus
        }
        
        set(newStatus) {
            self._permissionStatus = newStatus
            self.setupEnableButton(newStatus)
        }
    }
    
    override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set(newTintColor) {
            super.tintColor = newTintColor
            self.updateTintColor()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func updateTintColor() {
        self.setupImageView()
        self.setupTitleLabel()
        self.setupDetailsLabel()
        self.setupEnableButton(self.permissionStatus)
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = UIColor.clear
        self.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.setupImageView()
        self.setupTitleLabel()
        self.setupDetailsLabel()
        self.setupRightDetailsContainer()
        
        let views = ["iconImageView": self.iconImageView,
                     "titleLabel": self.titleLabel,
                     "detailsLabel": self.detailsLabel,
                     "rightDetailsContainer": self.rightDetailsContainer] as [String:UIView]
        
        var allConstraints = PAConstraintsUtils.concatenateConstraintsFromString([
            "V:|-2-[iconImageView]-2-|",
            "H:|-0-[iconImageView(15)]",
            "V:|-2-[rightDetailsContainer]-2-|",
            "H:[rightDetailsContainer(58)]-0-|",
            "V:|-4-[titleLabel(18@1000)]",
            "V:[titleLabel]-2-[detailsLabel]",
            "V:[detailsLabel(>=13,<=14@750)]-|",
            "H:[iconImageView]-8-[titleLabel]-4-[rightDetailsContainer]",
            "H:[iconImageView]-8-[detailsLabel]-4-[rightDetailsContainer]"
            ], views: views)
        
        //allConstraints.append(NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50))
        
        /*allConstraints.append(NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50))*/
        
        if #available(iOS 8.0, *) {
            NSLayoutConstraint.activate(allConstraints)
        } else {
            self.addConstraints(allConstraints)
        }
    
        
        self.setupEnableButton(.disabled)
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        self.detailsLabel.sizeToFit()
    }
    
    fileprivate func setupImageView() {
        if self.iconImageView == nil {
         let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFit
         self.contentView.addSubview(imageView)
         self.iconImageView = imageView
         self.iconImageView.backgroundColor = UIColor.clear
         self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
         }
         self.iconImageView.tintColor = self.tintColor
    }
    
    fileprivate func setupTitleLabel() {
        if self.titleLabel == nil {
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(titleLabel)
            self.titleLabel = titleLabel
            self.titleLabel.text = "Title"
            self.titleLabel.adjustsFontSizeToFitWidth = true
        }
        
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        self.titleLabel.minimumScaleFactor = 0.1
        self.titleLabel.textColor = self.tintColor
    }
    
    fileprivate func setupDetailsLabel() {
        if self.detailsLabel == nil {
            let detailsLabel = UILabel()
            detailsLabel.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(detailsLabel)
            self.detailsLabel = detailsLabel
            self.detailsLabel.text = "details"
        }
        
        self.detailsLabel.minimumScaleFactor = 0.1
        self.detailsLabel.numberOfLines = 0
        self.detailsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 11)
        self.detailsLabel.textColor = self.tintColor
        self.detailsLabel.lineBreakMode = .byWordWrapping
        self.detailsLabel.sizeToFit()
    }
    
    fileprivate func setupRightDetailsContainer() {
        if self.rightDetailsContainer == nil {
            let rightDetailsContainer = UIView()
            rightDetailsContainer.backgroundColor = UIColor.clear
            rightDetailsContainer.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(rightDetailsContainer)
            self.rightDetailsContainer = rightDetailsContainer
            self.rightDetailsContainer.backgroundColor = UIColor.clear
        }
    }
    
    fileprivate func setupEnableButton(_ status: PAPermissionsStatus) {
        if self.enableButton == nil {
         let enableButton = UIButton(type: .system)
         enableButton.translatesAutoresizingMaskIntoConstraints = false
         self.rightDetailsContainer.addSubview(enableButton)
         self.enableButton = enableButton
         self.enableButton.backgroundColor = UIColor.red
         self.enableButton.addTarget(self, action: #selector(PAPermissionsTableViewCell._didSelectItem), for: .touchUpInside)
         
         let checkingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
         checkingIndicator.translatesAutoresizingMaskIntoConstraints = false
         self.rightDetailsContainer.addSubview(checkingIndicator)
         self.checkingIndicator = checkingIndicator
         
         let views = ["enableButton": self.enableButton,
         "checkingIndicator": self.checkingIndicator] as [String : UIView]
         
         var allConstraints = PAConstraintsUtils.concatenateConstraintsFromString([
         "V:[enableButton(30)]",
         "H:|-2-[enableButton]-2-|",
         "V:[checkingIndicator(20)]",
         "H:[checkingIndicator(20)]"
         ], views: views)
         
         allConstraints.append(NSLayoutConstraint.init(item: self.enableButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.enableButton.superview, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
         
         allConstraints.append(NSLayoutConstraint.init(item: self.checkingIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.checkingIndicator.superview, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
         
         if #available(iOS 8.0, *) {
         NSLayoutConstraint.activate(allConstraints)
         } else {
         self.rightDetailsContainer.addConstraints(allConstraints)
         }
         }
         
         self.enableButton.tintColor = self.tintColor
         
         if status == .enabled {
         if !self.permission.canBeDisabled {
         self.enableButton.isHidden = false
         self.checkingIndicator.isHidden = true
         self.checkingIndicator.stopAnimating()
         self.enableButton.setTitle("", for: UIControlState())
         self.enableButton.layer.cornerRadius = 0.0
         self.enableButton.layer.borderColor = UIColor.clear.cgColor
         self.enableButton.layer.borderWidth = 0.0
         self.enableButton.setImage(UIImage(named: "pa_checkmark_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil), for: UIControlState())
         self.enableButton.imageView?.contentMode = .scaleAspectFit
         self.enableButton.isUserInteractionEnabled = false
         }else{
         self.setupEnableDisableButton(title: "Disable")
         }
         }else if status == .disabled || status == .denied {
         self.setupEnableDisableButton(title: "Enable")
         }else if status == .checking {
         self.enableButton.isHidden = true
         self.checkingIndicator.isHidden = false
         self.checkingIndicator.startAnimating()
         }else if status == .unavailable {
         self.enableButton.isHidden = false
         self.checkingIndicator.isHidden = true
         self.checkingIndicator.stopAnimating()
         self.enableButton.setTitle("", for: UIControlState())
         self.enableButton.layer.cornerRadius = 0.0
         self.enableButton.layer.borderColor = UIColor.clear.cgColor
         self.enableButton.layer.borderWidth = 0.0
         self.enableButton.setImage(UIImage(named: "pa_cancel_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil), for: UIControlState())
         self.enableButton.imageView?.contentMode = .scaleAspectFit
         self.enableButton.isUserInteractionEnabled = false
         }
    }
    
    private func setupEnableDisableButton(title: String) {
        self.enableButton.isHidden = false
        self.checkingIndicator.isHidden = true
        self.checkingIndicator.stopAnimating()
        self.enableButton.setTitle(NSLocalizedString(title, comment: ""), for: UIControlState())
        self.enableButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        self.enableButton.setImage(nil, for: UIControlState())
        self.enableButton.titleLabel?.minimumScaleFactor = 0.1
        self.enableButton.titleLabel?.adjustsFontSizeToFitWidth  = true
        self.enableButton.setTitleColor(self.tintColor, for: UIControlState())
        self.enableButton.backgroundColor = UIColor.clear
        self.enableButton.layer.cornerRadius = 2.0
        self.enableButton.layer.borderColor = self.tintColor.cgColor
        self.enableButton.layer.borderWidth = 1.0
        self.enableButton.clipsToBounds = true
        self.enableButton.isUserInteractionEnabled = true
    }
    
    @objc fileprivate func _didSelectItem() {
        if self.didSelectItem != nil {
            self.didSelectItem!(self.permission)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
