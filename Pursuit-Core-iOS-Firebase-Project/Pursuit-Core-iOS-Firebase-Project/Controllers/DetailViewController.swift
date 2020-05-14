//
//  DetailViewController.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailIV: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    public var post: IgPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        guard let post = post, let url = URL(string: post.photoURL) else {
            return
        }
        detailIV.kf.setImage(with: url)
        descLabel.text = "Post made by \(post.username)\nCreated on \(post.creationDate)"
        
    }
    

}
