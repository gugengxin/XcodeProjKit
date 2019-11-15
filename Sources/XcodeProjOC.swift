//
//  XcodeProjOC.swift
//  XcodeProjKit
//
//  Created by GuGengxin on 2019/11/15.
//  Copyright © 2019 AnOrgaName. All rights reserved.
//

import Foundation

@objc public class XcodeProjOC : NSObject {
    
    var p : XcodeProj!
    
    
    @objc public init(data: Data) throws {
        super.init()

        p=try XcodeProj(propertyListData : data)
    }
    @objc public func openStepData(projectName: String? = nil) throws -> Data {
        return try p.openStepData(projectName: projectName)
    }
}
