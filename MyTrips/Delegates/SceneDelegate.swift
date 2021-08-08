//
//  SceneDelegate.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/23/21.
//

import UIKit
import MapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        //print("becoming active")
        /*
        guard let tabBarController = self.window?.rootViewController as? TabBarController else {
            print("window doesn't exist")
            return
        }
        
        guard let tripViewController = tabBarController.children[0] as? TripViewController else {
            print("couldn't cast as TripViewController")
            return
        }
        
        let start = tabBarController.data.start
        if start == nil {
            tripViewController.start = nil
        } else {
            tripViewController.start = CLLocation(
                coordinate: CLLocationCoordinate2D(
                    latitude: start!.loc.latitude,
                    longitude: start!.loc.longitude
                ),
                altitude: 0,
                horizontalAccuracy: tripViewController.manager.desiredAccuracy,
                verticalAccuracy: tripViewController.manager.desiredAccuracy,
                timestamp: start!.date
            
            )
            
        }
        */
 

        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        //print("resigning active")
        /*
        guard let tabBarController = self.window?.rootViewController as? TabBarController else {
            print("window doesn't exist")
            return
        }
        
        guard let tripViewController = tabBarController.children[0] as? TripViewController else {
            print("couldn't cast as TripViewController")
            return
        }
        
        
        let start = tripViewController.start
        if start == nil {
            tabBarController.data.start = nil
        } else {
            tabBarController.data.start = Start(
                loc: Location(start!),
                date: start!.timestamp
            )
        }
        
        write(url: getURL(filename: "data")!, data: tabBarController.data)
        
        */
        
        
        
        
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        //print("entered foreground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        //print("entered background")
    }


}

