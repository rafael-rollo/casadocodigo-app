//
//  ViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource {
   
    // MARK: Attributes
    
    var showcase: [BookShowcaseItem] = []
    let showcaseFlowLayoutImpl: UICollectionViewDelegateFlowLayout = ShowcaseFlowLayout()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var showcaseCollectionView: UICollectionView!
    
    // MARK: View Lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        showcaseCollectionView.delegate = self.showcaseFlowLayoutImpl
        showcaseCollectionView.dataSource = self
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        
        loadShowcase();
    }
    
    // MARK: UICVDataSource impl
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showcase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showcaseBook = showcase[indexPath.row]
        
        guard let showcaseBookCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowcaseBookCell.reuseId, for: indexPath) as? ShowcaseBookCell else {
            fatalError("Invalid view cell type for showcase book. Please, check the configuration in the Cell and CollectionView's code or ib definition")
        }
        
        showcaseBookCell.setFrom(showcaseBook)
        return showcaseBookCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ShowcaseHeaderView.reuseId, for: indexPath)
                    as? ShowcaseHeaderView else {
                fatalError("Invalid view type for book showcase header")
            }
            return headerView.build()
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
    // MARK: View methods
    
    func loadShowcase() {
        let indicator = UIActivityIndicatorView.customIndicator(to: showcaseCollectionView)
        indicator.startAnimating()
        
        BookRepository().showcase { (books) in
            self.updateShowcase(with: books)
            indicator.stopAnimating()
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not load the book showcase from the API", in: self)
        }

    }
    
    func updateShowcase(with books: [BookShowcaseItem]) {
        self.showcase = books
        showcaseCollectionView.reloadData()
    }
}

