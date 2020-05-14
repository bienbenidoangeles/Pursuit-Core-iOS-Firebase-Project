//
//  FeedViewController.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    private var feedView = InstagramFeedView()
    
    private var listener: ListenerRegistration?
    private var posts = [IgPost]() {
        didSet {
            DispatchQueue.main.async {
                self.feedView.collectionView.reloadData()
            }
            if posts.isEmpty {
                self.feedView.collectionView.backgroundView = EmptyView(title: "No Posts Found", messege: "Add a new post!")
            } else {
                self.feedView.collectionView.backgroundView = nil
            }
        }
    }

    override func loadView() {
        view = feedView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegatesAndDataSources()
        registerCells()
    }
    
    private func registerCells(){
        feedView.collectionView.register(UINib(nibName: "FeedCell", bundle: nil), forCellWithReuseIdentifier: "feedCell")
    }

    private func delegatesAndDataSources(){
        feedView.collectionView.delegate = self
        feedView.collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.igPostCollection).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Fire Store Error", message: "\(error)")
                }
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map {IgPost ($0.data()) }
                self.posts = posts
            }
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
    }

}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = maxWidth
        return CGSize(width: itemWidth, height: itemWidth * 0.90)
    }

}

extension FeedViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            fatalError()
        }
        let selectedCell = posts[indexPath.row]
        dvc.post = selectedCell
        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCell else {
            fatalError("could not cast to instagram feed cell")
        }
        let post = posts[indexPath.row]
        cell.configureCell(for: post)
        return cell
    }
    
    
}
