//
//  SceneDelegate.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/12/24.
//

import UIKit
import Network

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var errorWindow: UIWindow?

    var networkMonitor = NetworkMonitor()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        networkMonitor.startMonitoring(statusUpdateHandler: { [weak self] connectionStatus in
            guard let self else { return }
            switch connectionStatus {
            case .satisfied:
                removeNetworkErrorWindow()
                print("dismiss networkError View if is present")
            case .unsatisfied:
                loadNetworkErrorWindow(on: scene)
                print("No Internet!! show network Error View")
            default:
                break
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertForRelogin), name: .refreshTokenExpired, object: nil)
        
        if UserDefaults.standard.accessToken == "" {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
            window?.makeKeyAndVisible()
        } else {
            guard let refreshTokenDueDate = UserDefaults.standard.refreshTokenDueDate else {
                return }
            print("dueDate", Date().timeIntervalSince(refreshTokenDueDate))
            if Date().timeIntervalSince(refreshTokenDueDate) <= 0 {
                guard let windowScene = (scene as? UIWindowScene) else { return }
                
                window = UIWindow(windowScene: windowScene)
                window?.rootViewController = HomeTabBarViewController()
                window?.makeKeyAndVisible()
            } else {
                UserDefaults.standard.clearAllData()
                
                guard let windowScene = (scene as? UIWindowScene) else { return }

                window = UIWindow(windowScene: windowScene)
                window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
                window?.makeKeyAndVisible()
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        networkMonitor.stopMonitoring()
        NotificationCenter.default.removeObserver(self, name: .refreshTokenExpired, object: nil)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    private func loadNetworkErrorWindow(on scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = .statusBar
            window.makeKeyAndVisible()
            
            let noNetworkView = NoNetworkView(frame: window.bounds)
            window.addSubview(noNetworkView)
            self.errorWindow = window
        }
    }
    
    private func removeNetworkErrorWindow() {
        errorWindow?.resignKey()
        errorWindow?.isHidden = true
        errorWindow = nil
    }
}

extension SceneDelegate {
    @objc private func showAlertForRelogin(notification: Notification) {
        if let userInfo = notification.userInfo,
           let showReloginAlert = userInfo["showReloginAlert"] as? Bool {
            
            if showReloginAlert {
                window?.rootViewController?.show(reloginAlert(), sender: nil)
            }
        }
    }
    
    private func reloginAlert() -> UIAlertController {
        let alert = UIAlertController(title: "재로그인", message: "세션이 만료되어 재 로그인이 필요합니다!!", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "재로그인 하러가기", style: .default) { [weak self] _ in
            guard let self else { return }
            
            UserDefaults.standard.clearAllData()
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let signInNav = UINavigationController(rootViewController: SignInViewController())
            
            sceneDelegate?.window?.rootViewController = signInNav
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    
        alert.addAction(confirmButton)
        
        return alert
    }
}

