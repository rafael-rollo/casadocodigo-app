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
        self.showcaseCollectionView.delegate = self.showcaseFlowLayoutImpl
        self.showcaseCollectionView.dataSource = self
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        
        self.loadShowcase();
    }
    
    // MARK: UICVDataSource impl
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.showcase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showcaseBook = showcase[indexPath.row]
        
        let showcaseBookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowcaseBookCell", for: indexPath) as! ShowcaseBookCell
        showcaseBookCell.setFrom(showcaseBook)
        
        return showcaseBookCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShowcaseHeaderView", for: indexPath)
                    as? ShowcaseHeaderView else {
                fatalError("Invalid view type")
            }
            return headerView
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
    // MARK: View methods
    
    func loadShowcase() {
        let indicator = UIActivityIndicatorView.customIndicator(to: self.showcaseCollectionView)
        indicator.startAnimating()
    
        BookRepository().showcase { books in
            self.updateShowcase(with: books)
            indicator.stopAnimating()
        }
    }
    
    func updateShowcase(with books: [BookShowcaseItem]) {
        self.showcase = books
        self.showcaseCollectionView.reloadData()
    }
}

