import UIKit

public struct PXLDefaults {
    public static func getBundleForApp(for aClass: AnyClass) -> Bundle {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: aClass)
        #endif
        return bundle
    }
}
