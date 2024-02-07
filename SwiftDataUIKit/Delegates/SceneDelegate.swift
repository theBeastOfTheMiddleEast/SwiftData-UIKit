import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard 
            let windowScene = (scene as? UIWindowScene),
            let databaseManager = LocalDatabaseManager() else {
                return
        }
        
        let viewModel = MainViewModel(databaseManager: databaseManager)
        let controller = MainViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: controller)
        
        window = UIWindow(frame: windowScene.screen.bounds)
        window?.rootViewController = navController
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
