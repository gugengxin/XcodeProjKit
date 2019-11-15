//
//  XcodeProj+Serialization.swift
//  XcodeProjKit
//
//  Created by phimage on 30/07/2017.
//  Copyright © 2017 phimage (Eric Marchand). All rights reserved.
//

import Foundation

extension XcodeProj {

    public func write(to url: URL, format: PropertyListSerialization.PropertyListFormat? = nil,
                      projectName: String? = nil, lineEnding: String? = nil, atomic: Bool = true) throws {
        let pbxprojURL: URL
        let name: String
        if url.isDirectoryURL {
            pbxprojURL = url.appendingPathComponent(XcodeProj.pbxprojFileName, isDirectory: false)
            let subpaths = url.pathComponents
            if let projectName = projectName {
                name = projectName
            } else {
                // Find in project
                if let last = subpaths.last, let range = last.range(of: ".xcodeproj") {
                    name = String(last[...range.lowerBound])
                } else {
                    name = self.projectName // default
                }
            }
        } else {
            pbxprojURL = url
            name = projectName ?? self.projectName
        }
        let lineEnding = lineEnding ?? self.lineEnding
        let format = format ?? self.format
        if format == .openStep {
            let serializer = OpenStepSerializer(projectName: name, lineEnding: lineEnding, projectFile: self)
            try serializer.serialize().write(to: pbxprojURL, atomically: atomic, encoding: .utf8)
        } else {
            let data = try PropertyListSerialization.data(fromPropertyList: dict, format: format, options: 0)
            try data.write(to: pbxprojURL, options: atomic ? [.atomicWrite] : [])
        }
    }

    public func data(projectName: String? = nil) throws -> Data {
        if format == .openStep {
            let projectName = projectName ?? self.projectName
            let serializer = OpenStepSerializer(projectName: projectName, projectFile: self)
            return try serializer.serialize().data(using: .utf8) ?? Data()
        } else {
            return try PropertyListSerialization.data(fromPropertyList: dict, format: format, options: 0)
        }
    }
    
    public func openStepData(projectName: String? = nil) throws -> Data {
        let projectName = projectName ?? self.projectName
        let serializer = OpenStepSerializer(projectName: projectName, projectFile: self)
        return try serializer.serialize().data(using: .utf8) ?? Data()
    }

}
