

import UIKit
import TextAttributes

public extension NSAttributedString {
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let boundingSize = CGSize(width: width, height: CGFloat.max)
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin
        let size = boundingRectWithSize(boundingSize, options: options, context: nil)
        return ceil(size.height)
    }
}

public extension String {
    
    public func indexOfCharacter(char: Character) -> Int? {
            if let idx = self.characters.indexOf(char) {
                return self.startIndex.distanceTo(idx)
            }
            return nil
        }

    func attributedComment() -> NSAttributedString {
        let attrs = TextAttributes()
            .font(UIFont.defaultFont(size: 13))
            .foregroundColor(UIColor.whiteColor())
            .alignment(.Left)
            .lineSpacing(1)
            .dictionary
        return NSAttributedString(string: self, attributes: attrs)
    }
    
    static func random(length: Int = 4) -> String {
        let base = "abcdefghijklmnopqrstuvwxyz"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }
        return randomString
    }
    
}