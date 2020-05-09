//
//  WifiCell.swift
//  Live
//
//  Created by Jeevan Sivagnanasuntharam on 08/08/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import UIKit
import Photos


class CustomViewFlowLayout : UICollectionViewFlowLayout {
    
    let cellSpacing:CGFloat = 0
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElementsInRect(rect) {
            for (index, attribute) in attributes.enumerate() {
                if index == 0 { continue }
                let prevLayoutAttributes = attributes[index - 1]
                let origin = CGRectGetMaxX(prevLayoutAttributes.frame)
                if(origin + cellSpacing + attribute.frame.size.width < self.collectionViewContentSize().width) {
                    attribute.frame.origin.x = origin + cellSpacing
                }
            }
            return attributes
        }
        return nil
    }
}

class LocalViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var selected: Bool {
        didSet {
            if self.selected {
                select();
            } else {
                deselect();
            }
        }
    }
    
    func select(){
        let overlayImage = UIImage(named:"playicon")
        let overlayImageView = UIImageView(image:overlayImage)

        self.imageView.addSubview(overlayImageView);
    }
    
    func deselect(){
        for view in self.imageView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func fillData(phAsset : PHAsset)  {
        let option = PHImageRequestOptions()
        option.deliveryMode = .Opportunistic
        option.synchronous = false
        option.networkAccessAllowed = true
        
        PHImageManager().requestImageForAsset(phAsset, targetSize: CGSizeMake(256, 256), contentMode: .AspectFit, options: option, resultHandler: { (image, objects) in
            if(image != nil){
            self.imageView.image = image!}
        })
    }
}
