//
//  AuthorsViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class AuthorsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    // MARK: Attributes
    
    var authors: [Author] = []
    
    // MARK: IBOutlets
    
    @IBOutlet weak var authorsCollectionView: UICollectionView!
    
    // MARK: View lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        authorsCollectionView.dataSource = self
        authorsCollectionView.delegate = self
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        
        loadAuthorsList()
    }
    
    // MARK: UICVDataSource Impl
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return authors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let author = authors[indexPath.row]
        
        guard let authorCell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthorCell.reuseId, for: indexPath) as? AuthorCell else {
            fatalError("Invalid view cell type for author item. Please, check the configuration in the Cell and CollectionView's code or ib definition")
        }
        
        authorCell.setFrom(author)
        return authorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AuthorsHeaderView.reuseId, for: indexPath)
                    as? AuthorsHeaderView else {
                fatalError("Invalid view type for the authors header")
            }
            return headerView.build()
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
    // MARK: UICVDFlowLayout Impl
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalMargin: CGFloat = 16
        
        let superviewWidth: CGFloat = collectionView.bounds.width
        let adjustedWidth = superviewWidth - horizontalMargin * 2
        
        return CGSize(width: adjustedWidth, height: 206)
    }
    
    // MARK: View methods
    
    func loadAuthorsList() {
        let indicator = UIActivityIndicatorView.customIndicator(to: authorsCollectionView)
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
        authorsCollectionView.reloadData()
    }
}
