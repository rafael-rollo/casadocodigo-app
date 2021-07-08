//
//  HorizontalListView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/04/21.
//

import UIKit

class TagsHorizontalList: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IdentifiableView {
    
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
        Bundle.main.loadNibNamed(TagsHorizontalList.nibName, owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseId, for: indexPath) as? TagCell else {
            fatalError("Invalid view cell type for tag items. Please check the implementation and fix it")
        }
        
        tagCell.set(label: item)
        return tagCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultSize = CGSize(width: 100, height: collectionView.bounds.height)
        
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseId, for: indexPath) as? TagCell else {
            return defaultSize
        }
        
        let item = items[indexPath.row]
        
        guard let size = tagCell.getMinSizeForCell(with: item, in: collectionView) else {
            return defaultSize
        }

        return size
    }
    
    func setFrom(_ items: [String]) {
        self.items = items
        collectionView.reloadData()
    }
}
