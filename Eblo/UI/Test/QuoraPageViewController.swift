//
//  QuoraPageViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-08-21.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation

import UIKit

class QuoraPageViewController: UIViewController {
  
  let titleLabel = UILabel()
  let paragraphLabel = UILabel()
  let upVoteButton = UIButton()
  let commentLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.navigationController?.navigationBar.isTranslucent = false
    self.setupSubViews()
    self.buildContraints()
  }
  
  func setupSubViews() {
    titleLabel.minimumScaleFactor = 0.6
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.numberOfLines = 0
    titleLabel.textColor = UIColor.black
    titleLabel.font = UIFont.systemFont(ofSize: 22.0)
    titleLabel.text = "Why are feminists going crazy about Hermione in Harry Potter and the Cursed Child?"
    
    paragraphLabel.minimumScaleFactor = 0.6
    paragraphLabel.adjustsFontSizeToFitWidth = true
    paragraphLabel.textColor = UIColor.black
    paragraphLabel.numberOfLines = 0
    paragraphLabel.font = UIFont.systemFont(ofSize: 18.0)
    paragraphLabel.text = "In Cursed Child, Hermione is the Minister of Magic before the crazy time travel plot occurs. As a result of the time travel plot caused by Albus and Scorpius, Hermione is now a bitter DADA professor. She is not married to Ron. \n Teachers are awesome. They're important. However, people are angry that the play insinuates that Hermione is not the Minister of Magic because she isn't married to Ron. It does send an awful message considering how ambitious and amazing Hermione is. I honestly think that when the boys did change time, they changed a lot of smaller factors that led to Hermione being a bitter DADA teacher."
    
    upVoteButton.backgroundColor = UIColor.blue
    upVoteButton.setTitle("UpVote", for: .normal)
    upVoteButton.setTitleColor(UIColor.white, for: .normal)
    upVoteButton.addTarget(self,
                           action: #selector(self.upVote),
                           for: .touchUpInside)
    
    commentLabel.minimumScaleFactor = 0.6
    commentLabel.adjustsFontSizeToFitWidth = true
    commentLabel.textColor = UIColor.black
    commentLabel.font = UIFont.systemFont(ofSize: 18.0)
    commentLabel.text = "Comment"
    
    self.view.addAutoLayoutSubView(titleLabel)
    self.view.addAutoLayoutSubView(paragraphLabel)
    self.view.addAutoLayoutSubView(upVoteButton)
    self.view.addAutoLayoutSubView(commentLabel)
  }
  
  func upVote() {
    print("upVote Tapped")
    let nextVC = AnimationViewController()
    nextVC.transitioningDelegate = self
    nextVC.modalPresentationStyle = .fullScreen
    self.present(nextVC, animated: true, completion: nil)
  }
  
  func buildContraints() {
    let titleLeading = titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
    let titleTrailing = titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    let titleTop = titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0)
    
    let paraLeading = paragraphLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
    let paraTrailing = paragraphLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    let paraTop = paragraphLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 36.0)
    let paraBottom = paragraphLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.commentLabel.topAnchor)
    
    let upVoteLeading = upVoteButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0)
    let upVoteWidth = upVoteButton.widthAnchor.constraint(equalToConstant: 80.0)
    let upVoteBottom = upVoteButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20.0)
    let upVoteCenter = upVoteButton.centerYAnchor.constraint(equalTo: commentLabel.centerYAnchor)
    
    let commentTrailing = commentLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0)
    NSLayoutConstraint.activate([titleLeading,
                                 titleTrailing,
                                 titleTop,
                                 paraLeading,
                                 paraTrailing,
                                 paraTop,
                                 paraBottom,
                                 upVoteLeading,
                                 upVoteWidth,
                                 upVoteBottom,
                                 upVoteCenter,
                                 commentTrailing])
  }
}

extension QuoraPageViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return QuoraAnimationController()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return QuoraDismissAnimationController()
  }
}
