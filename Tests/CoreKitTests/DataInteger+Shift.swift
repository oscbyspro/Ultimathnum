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
import TestKit

//*============================================================================*
// MARK: * Data Integer x Shift
//*============================================================================*

@Suite struct DataIntegerTestsOnShift {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DataInt/shift: upshift",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func upshift(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
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
        
        func whereIs<T>(_ value: [T], major: IX, minor: IX, environment: T) throws where T: CoreIntegerAsUnsigned {
            var expectation = value
            expectation.removeLast(Swift.Int(major))
            expectation.insert(contentsOf: repeatElement(environment, count: Swift.Int(major + 1)), at: 0)
            
            expectation.withUnsafeMutableBinaryIntegerBody {
                _ = $0.multiply(by: T.lsb << minor, add: environment >> (IX(size: T.self) - minor))
            }
            
            expectation.removeFirst()
            try Ɣrequire(value, up: IX(size: T.self) * major + minor, environment: environment, is: expectation)
        }
    }
    
    @Test(
        "DataInt/shift: downshift",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func downshift(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
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
        
        func whereIs<T>(_ value: [T], major: IX, minor: IX, environment: T) throws where T: CoreIntegerAsUnsigned {
            var expectation = value
            expectation.removeFirst(Swift.Int(major))
            expectation.append(contentsOf: repeatElement(environment, count: Swift.Int(major + 1)))
            
            expectation.withUnsafeMutableBinaryIntegerBody {
                _ = $0.divisionSetQuotientGetRemainder(Nonzero(T.lsb << minor))
            }
            
            expectation.removeLast()
            try Ɣrequire(value, down: IX(size: T.self) * major + minor, environment: environment, is: expectation)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<Element>(
        _  integer: [Element],
        up distance: IX,
        environment: Element,
        is expectation: [Element],
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        try #require(integer.count == expectation.count)
        try #require(distance <    IX(expectation.count) *   IX(size: Element.self))
        let (major, minor) = Natural(distance).division(Nonzero(size: Element.self)).components()
        //=--------------------------------------=
        // upshift: any
        //=--------------------------------------=
        always: do {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.upshift(major: major, minor: minor, environment: environment)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        
        if  environment.isZero {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.upshift(major: major, minor: minor)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // upshift: major >= 1, minor == 0
        //=--------------------------------------=
        if  major >= 1, minor == 0 {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.upshift(majorAtLeastOne: major, minor: (( )), environment: environment)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        
        if  major >= 1, minor == 0, environment.isZero {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.upshift(majorAtLeastOne: major, minor: (( )))
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // upshift: major >= 0, minor >= 1
        //=--------------------------------------=
        if  major >= 0, minor >= 1 {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.upshift(major: major, minorAtLeastOne: minor, environment: environment)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        
        if  major >= 0, minor >= 1, environment.isZero {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.upshift(major: major, minorAtLeastOne: minor)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
    }

    private func Ɣrequire<Element>(
        _  integer: [Element],
        down distance: IX,
        environment: Element,
        is expectation: [Element],
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        try #require(integer.count == expectation.count)
        try #require(distance <    IX(expectation.count) *   IX(size: Element.self))
        let (major, minor) = Natural(distance).division(Nonzero(size: Element.self)).components()
        //=--------------------------------------=
        // downshift: any
        //=--------------------------------------=
        always: do {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.downshift(major: major, minor: minor, environment: environment)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        
        if  environment.isZero {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.downshift(major: major, minor: minor)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // downshift: major >= 1, minor == 0
        //=--------------------------------------=
        if  major >= 1, minor == 0 {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.downshift(majorAtLeastOne: major, minor: (( )), environment: environment)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        
        if  major >= 1, minor == 0, environment.isZero {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.downshift(majorAtLeastOne: major, minor: (( )))
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // downshift: major >= 0, minor >= 1
        //=--------------------------------------=
        if  major >= 0, minor >= 1 {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.downshift(major: major, minorAtLeastOne: minor, environment: environment)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
        
        if  major >= 0, minor >= 1, environment.isZero {
            var result = integer; result.withUnsafeMutableBinaryIntegerBody {
                $0.downshift(major: major, minorAtLeastOne: minor)
            }
            
            try #require(result == expectation, sourceLocation: location)
        }
    }
}
