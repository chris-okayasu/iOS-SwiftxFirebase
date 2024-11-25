//
//  Utilities.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/25.
//

import Foundation
import UIKit

final class Utilities {
    
    static let shared = Utilities()
    private init() {}
    
    
    // the screen that shows up when user select sign is with google
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        // this warning is not a problem with are not going to multiple scenes
//        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        let controller = controller ?? UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene } 
                    .first(where: { $0.activationState == .foregroundActive })?
                    .windows
                    .first(where: { $0.isKeyWindow })?
                    .rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
