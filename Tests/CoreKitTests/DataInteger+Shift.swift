//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit2

//*============================================================================*
// MARK: * Data Integer x Shift
//*============================================================================*

@Suite struct DataIntegerTestsOnShift {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/upshift(major:minor:environment:) - [uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func upshift(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug:     64, release: 1024) {
                let value = [T].random(count: 1...32, using: &randomness)
                let major = (IX.random(in: 0..<IX(value.count), using: &randomness)!)
                let minor = (IX.random(in: 0..<IX(size:T.self), using: &randomness)!)
                let environment = T.random(using:  &randomness)
                
                try whereIs(value, major: major, minor: minor, environment: environment)
                try whereIs(value, major: 00000, minor: minor, environment: environment)
                try whereIs(value, major: major, minor: 00000, environment: environment)
            }
        }
        
        func whereIs<T>(_ value: [T], major: IX, minor: IX, environment: T) throws where T: SystemsIntegerWhereIsUnsigned {
            var expectation = value
            expectation.removeLast(Swift.Int(major))
            expectation.insert(contentsOf: repeatElement(environment, count: Swift.Int(major + 1)), at: 0)
            
            expectation.withUnsafeMutableBinaryIntegerBody {
                _ = $0.multiply(by: T.lsb << minor, add: environment >> (IX(size: T.self) - minor))
            }
            
            expectation.removeFirst()
            try Ɣexpect(value, up: IX(size: T.self) * major + minor, environment: environment, is: expectation)
        }
    }
    
    @Test("DataInt/downshift(major:minor:environment:) - [uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func downshift(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug:     64, release: 1024) {
                let value = [T].random(count: 1...32, using: &randomness)
                let major = (IX.random(in: 0..<IX(value.count), using: &randomness)!)
                let minor = (IX.random(in: 0..<IX(size:T.self), using: &randomness)!)
                let environment = T.random(using:  &randomness)
                
                try whereIs(value, major: major, minor: minor, environment: environment)
                try whereIs(value, major: 00000, minor: minor, environment: environment)
                try whereIs(value, major: major, minor: 00000, environment: environment)
            }
        }
        
        func whereIs<T>(_ value: [T], major: IX, minor: IX, environment: T) throws where T: SystemsIntegerWhereIsUnsigned {
            var expectation = value
            expectation.removeFirst(Swift.Int(major))
            expectation.append(contentsOf: repeatElement(environment, count: Swift.Int(major + 1)))
            
            expectation.withUnsafeMutableBinaryIntegerBody {
                _ = $0.divisionSetQuotientGetRemainder(Nonzero(T.lsb << minor))
            }
            
            expectation.removeLast()
            try Ɣexpect(value, down: IX(size: T.self) * major + minor, environment: environment, is: expectation)
        }
    }
}
