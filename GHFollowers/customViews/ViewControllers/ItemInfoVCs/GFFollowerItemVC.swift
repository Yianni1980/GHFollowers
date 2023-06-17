//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by ioannis on 17/6/23.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
    }
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(background: .systemGreen, title: "Get Followers")
        
    }
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}

