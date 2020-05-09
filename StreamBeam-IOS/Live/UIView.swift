

import UIKit

extension UIView {
    
    var scale: CGFloat {
        set(value) {
            transform = CGAffineTransformMakeScale(value, value)
        }
        get {
            return 0
        }
    }
}
