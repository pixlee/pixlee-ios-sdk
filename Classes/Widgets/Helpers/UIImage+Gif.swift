import UIKit
import ImageIO
import Gifu
import Nuke

extension Gifu.GIFImageView {
    public override func nuke_display(image: Image?) {
        prepareForReuse()
        if let data = image?.animatedImageData {
            animate(withGIFData: data)
        } else {
            self.image = image
        }
    }
}

