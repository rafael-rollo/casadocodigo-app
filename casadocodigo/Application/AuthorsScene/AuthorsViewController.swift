//
//  AuthorsViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class AuthorsViewController: UIViewController, UICollectionViewDataSource {
   
    // MARK: Attributes
    
    var authors: [Author] = []
    
    // MARK: IBOutlets
    
    @IBOutlet weak var authorsCollectionView: UICollectionView!
    
    // MARK: View lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorsCollectionView.dataSource = self
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        
        loadAuthorsList()
    }
    
    // MARK: UICVDataSource Impl
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.authors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let authorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuthorCell", for: indexPath) as! AuthorCell
        return authorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AuthorsHeaderView", for: indexPath)
                    as? AuthorsHeaderView else {
                fatalError("Invalid view type")
            }
            return headerView.build()
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
    // MARK: View methods
    
    func loadAuthorsList() {
        let indicator = UIActivityIndicatorView.customIndicator(to: self.authorsCollectionView)
        indicator.startAnimating()
        
        AuthorRepository().allAuthors { authors in
            self.updateAuthorsList(with: authors)
            indicator.stopAnimating()
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not possible to load our authors", in: self)
        }
    }
    
    func updateAuthorsList(with authors: [Author]) {
        self.authors = authors
        self.authorsCollectionView.reloadData()
    }
}