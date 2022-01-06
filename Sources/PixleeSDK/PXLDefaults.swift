import UIKit

public struct PXLDefaults {
    public static var bundleModule = Bundle.module
    
    public static func getBundleForApp(for aClass: AnyClass) -> Bundle {
        #if SWIFT_PACKAGE
        let bundle = PXLDefaults.bundleModule
        #else
        let bundle = Bundle(for: aClass)
        #endif
        return bundle
    }
}
