//
//  FunPlusSDK.swift
//  FunPlusSDK
//
//  Created by Yuankun Zhang on 08/10/2016.
//  Copyright © 2016 funplus. All rights reserved.
//

import Foundation

// MARK: - FunPlusSDKError

public enum FunPlusSDKError: Error {
    case invalidConfig
}

// MARK: - FunPlusSDK

public class FunPlusSDK {
    
    public static let VERSION = "4.0.3-alpha.1"
    
    static var instance: FunPlusSDK?
    
    /// Shared instance of `FunPlusSDK`.
    /// Must be used after SDK is installed, otherwise will throw exception.
    static var shared = { return instance! }()
    
    static let INSTALL_DATE_SAVED_KEY = "com.funplus.sdk.InstallDate"
    
    let funPlusConfig: FunPlusConfig
    
    /// Data events are interested in app's install date.
    let installDate: Date
    
    // Deprecated
    public class func install(funPlusConfig: FunPlusConfig) {
        if instance == nil {
            print("[FunPlusSDK] Installing FunPlus SDK: {sdkVersion=\(FunPlusSDK.VERSION), appId=\(funPlusConfig.appId), env=\(funPlusConfig.environment)}")
            instance = FunPlusSDK(funPlusConfig: funPlusConfig)
        } else {
            print("[FunPlusSDK] FunPlus SDK has been installed, there's no need to install it again")
        }
    }
    
    // Deprecated
    public class func install(appId: String, appKey: String, environment: SDKEnvironment) throws {
        if instance == nil {
            let funPlusConfig = try ConfigManager(appId: appId, appKey: appKey, environment: environment).getFunPlusConfig()
            install(funPlusConfig: funPlusConfig)
        } else {
            print("[FunPlusSDK] FunPlus SDK has been installed, there's no need to install it again")
        }
    }
    
    public class func install(appId: String, appKey: String, rumTag: String, rumKey: String, environment: SDKEnvironment) {
        if (instance == nil) {
            let funPlusConfig = FunPlusConfig(appId: appId, appKey: appKey, rumTag: rumTag, rumKey: rumKey, environment: environment)
            instance = FunPlusSDK(funPlusConfig: funPlusConfig)
        } else {
            print("[FunPlusSDK] FunPlus SDK has been installed, there's no need to install it again")
        }
    }
    
    private init(funPlusConfig: FunPlusConfig) {
        self.funPlusConfig = funPlusConfig
        
        installDate = UserDefaults.standard.object(forKey: FunPlusSDK.INSTALL_DATE_SAVED_KEY) as? Date ?? Date()
        UserDefaults.standard.set(installDate, forKey: FunPlusSDK.INSTALL_DATE_SAVED_KEY)
        
        let _ = FunPlusFactory.getLoggerDataConsumer(funPlusConfig: funPlusConfig)
        let _ = FunPlusFactory.getFunPlusID(funPlusConfig: funPlusConfig)
        let _ = FunPlusFactory.getFunPlusRUM(funPlusConfig: funPlusConfig)
        let _ = FunPlusFactory.getFunPlusData(funPlusConfig: funPlusConfig)
    }
    
    public class func getInstallDate() -> Date {
        return instance?.installDate ?? Date()
    }
    
    class func getSessionManager() -> SessionManager {
        if instance == nil {
            print("[FunPlusSDK] FunPlus SDK has not been installed yet.")
        }
        return FunPlusFactory.getSessionManager(funPlusConfig: shared.funPlusConfig)
    }
    
    public class func getFunPlusID() -> FunPlusID {
        if instance == nil {
            print("[FunPlusSDK] FunPlus SDK has not been installed yet.")
        }
        return FunPlusFactory.getFunPlusID(funPlusConfig: shared.funPlusConfig)
    }
    
    public class func getFunPlusRUM() -> FunPlusRUM {
        if instance == nil {
            print("[FunPlusSDK] FunPlus SDK has not been installed yet.")
        }
        return FunPlusFactory.getFunPlusRUM(funPlusConfig: shared.funPlusConfig)
    }
    
    public class func getFunPlusData() -> FunPlusData {
        if instance == nil {
            print("[FunPlusSDK] FunPlus SDK has not been installed yet.")
        }
        return FunPlusFactory.getFunPlusData(funPlusConfig: shared.funPlusConfig)
    }
}
