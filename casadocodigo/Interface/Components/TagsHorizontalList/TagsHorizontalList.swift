//
//  HorizontalListView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/04/21.
//

import UIKit

class TagsHorizontalList: UIView, IdentifiableView {
    
    private lazy var tagsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCell.self,
                                forCellWithReuseIdentifier: TagCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        collectionView.contentInset = insets
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    
    var items = [String]() {
        didSet {
            tagsCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func set(items: [String]) {
        self.items = items
    }
}

extension TagsHorizontalList: UICollectionViewDataSource {
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
}

extension TagsHorizontalList: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
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
}

extension TagsHorizontalList: ViewCode {
    func addViews() {
        addSubview(tagsCollectionView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            tagsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
