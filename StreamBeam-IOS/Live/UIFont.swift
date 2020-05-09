

import UIKit

extension UIFont {
    
    static func defaultFont(size size: CGFloat) -> UIFont {
        return UIFont(name: UIFont.defaultFontName(), size: size)!
    }
    
    static func defaultFontName() -> String {
        return "AppleSDGothicNeo-Bold";
    }
    
}
