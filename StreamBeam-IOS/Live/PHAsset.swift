//
//  PHAsset.swift
//  StreamBeam
//
//  Created by Jeevan Sivagnanasuntharam on 20/11/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

import Photos


extension PHAsset // Utility
{
    class func getAssetFromlocalIdentifier(localIdentifier: String) -> PHAsset?
    {
        var result: PHAsset? = nil
        
        let list = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier], options: nil)
        if list.count > 0
        {
            result = list.objectAtIndex(0) as? PHAsset
        }
        return result
    }
    
}