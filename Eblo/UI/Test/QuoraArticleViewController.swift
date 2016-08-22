//
//  AnimationViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-08-20.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit

/// A view controller to show content that like Quora Article screen.
class QuoraArticleViewController: UIViewController {
  let titleLabel = UILabel()
  let paragraphLabel = UILabel()
  let upVoteButton = UIButton()
  let commentLabel = UILabel()

  var normalConstraints: [NSLayoutConstraint] = []
  
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
    titleLabel.text = "Is it better to live near Google's Mountain View headquarters or in San Francisco?"
    
    paragraphLabel.minimumScaleFactor = 0.6
    paragraphLabel.adjustsFontSizeToFitWidth = true
    paragraphLabel.textColor = UIColor.black
    paragraphLabel.numberOfLines = 0
    paragraphLabel.font = UIFont.systemFont(ofSize: 18.0)
    paragraphLabel.text = "I’m a current Googler, married, no kids, but have 1 dog. I worked at Google in Mountain View while living in SF and seriously thought about moving. I took the shuttle every day for many years. It took 3–4 hours a day to commute from where I was living in SF to get to Mountain View. It was tough. But it was non-negotiable for me to leave SF because I’m a city girl and my husband loves the city and works here. And it was non-negotiable to leave Google because of all the places I’ve worked, it’s the best place ever to work and I love it. I had resigned myself to a life of shuttling and or driving to work and spending 4 waking hours a day in transit. \n Recently Google gave some of my colleagues and me the chance to work in SF, and we all jumped at the chance. It has been a lifechanger."
    
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
    self.dismiss(animated: true, completion: nil)
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

    normalConstraints = [titleLeading,
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
                         commentTrailing]
    NSLayoutConstraint.activate(normalConstraints)
  }
}

extension QuoraArticleViewController: EBPresentationDestinationViewController {

  func preparePreTransitionState() {
    self.titleLabel.alpha = 0.0
    self.titleLabel.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
    self.paragraphLabel.alpha = 0.0
    self.paragraphLabel.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
    self.upVoteButton.alpha = 0.0
    self.upVoteButton.layer.transform = CATransform3DTranslate(CATransform3DMakeScale(0.8, 0.8, 1), 30, -30, 0)
  }

  func setAnimationState() {
    self.titleLabel.alpha = 1.0
    self.titleLabel.layer.transform = CATransform3DIdentity
    self.paragraphLabel.alpha = 1.0
    self.paragraphLabel.layer.transform = CATransform3DIdentity
    self.upVoteButton.layer.transform = CATransform3DIdentity
    self.upVoteButton.alpha = 1.0
  }
}


