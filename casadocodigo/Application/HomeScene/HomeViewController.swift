//
//  ViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    // MARK: Attributes
    
    var showcase: [BookShowcaseItem] = []
    
    // MARK: IBOutlets
    
    @IBOutlet weak var showcaseCollectionView: UICollectionView!
    
    // MARK: View Lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showcaseCollectionView.delegate = self
        self.showcaseCollectionView.dataSource = self
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        
        BookRepository().showcase(completionHandler: self.updateShowcase)
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
    
    // MARK: UICVDFlowLayout impl
    
    private func calculateHeightProportional(to width: CGFloat) -> CGFloat {
        let coverBaseWidth: CGFloat = 336
        let coverBaseHeight: CGFloat = 480
        
        let proportionalHeight = coverBaseHeight * width / coverBaseWidth
        return proportionalHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerLine = 2
        let horizontalMargin = 16
        let collectionWidth = Int(collectionView.bounds.width)
        
        let adjustedWidth = CGFloat((collectionWidth) / cellsPerLine - horizontalMargin)
        
        let labelHeight: CGFloat = 70
        let adjustedHeight = self.calculateHeightProportional(to: adjustedWidth) + labelHeight
    
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
    
    // MARK: View methods
    
    func updateShowcase(with books: [BookShowcaseItem]) {
        self.showcase = books
        self.showcaseCollectionView.reloadData()
    }
}

