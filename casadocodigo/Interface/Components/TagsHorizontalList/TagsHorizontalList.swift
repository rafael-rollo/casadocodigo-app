//
//  HorizontalListView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/04/21.
//

import UIKit

class TagsHorizontalList: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private static let cellReuseIdentifier = "tagCell"
    
    var items: [String] = []
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // for using the custom view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // for using the custom view in interface builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        Bundle.main.loadNibNamed("TagsHorizontalList", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    
        self.collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagsHorizontalList.cellReuseIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.items[indexPath.row]
        
        let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsHorizontalList.cellReuseIdentifier, for: indexPath) as! TagCell
        tagCell.setFrom(item)
        
        return tagCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsHorizontalList.cellReuseIdentifier, for: indexPath) as! TagCell
        let item = self.items[indexPath.row]
        
        guard let size = tagCell.getMinSizeForCell(with: item, in: collectionView) else {
            return CGSize(width: 100, height: collectionView.bounds.height)
        }
        
        debugPrint("OIA")
        debugPrint(size)
        return size
    }
    
    func setFrom(_ items: [String]) {
        self.items = items
        self.collectionView.reloadData()
    }
}
