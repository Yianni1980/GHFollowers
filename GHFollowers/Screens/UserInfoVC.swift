//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by ioannis on 17/6/23.
//

import UIKit
import SafariServices

protocol userInfoVCdelegate: AnyObject {
    func didTapGitHubProfile(for user:User)
    func didTapGetFollowers(for user:User)
}

class UserInfoVC: GFDataLoadingVC {
    let headerView         = UIView()
    let itemViewOne        = UIView()
    let itemViewTwo        = UIView()
    let dateLabel          = GFBodyLabel(textAlignment: .center)
    var itemViews:[UIView] = []
    
    var username:String!
    weak var delegate: FollowerListVCDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result  in
            guard let self = self else {return}
            switch result {
            case .success(let user):
                DispatchQueue.main.async {self.configureUIElements(with: user)}
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "something went wrong", messsage: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func configureUIElements(with user:User){
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self
        let followersItemVC = GFFollowerItemVC(user: user)
        followersItemVC.delegate  = self
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followersItemVC, to: self.itemViewTwo)
        self.add(childVC: GHUserInfoHeaderVC(user: user), to: self.headerView)
        
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight:CGFloat =  140
        itemViews = [headerView,itemViewOne,itemViewTwo,dateLabel]
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor,constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    
    func add(childVC:UIViewController, to containerView:UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    @objc func dismissVC() {
        
        dismiss(animated: true)
    }
    
    
}


extension UserInfoVC:userInfoVCdelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", messsage: "The url attached to this user is invalid", buttonTitle: "ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    
    func didTapGetFollowers(for user: User) {
        guard  user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", messsage: "this user hasno followers. what a shame", buttonTitle: "ok")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}

