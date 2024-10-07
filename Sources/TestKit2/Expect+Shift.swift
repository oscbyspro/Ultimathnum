//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Expect x Shift x Data Integer
//*============================================================================*

@inlinable public func Ɣexpect<Element>(
    _  integer: [Element],
    up distance: IX,
    environment: Element,
    is expectation: [Element],
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerWhereIsUnsigned {
    //=------------------------------------------=
    try #require(integer.count == expectation.count)
    try #require(distance <    IX(expectation.count) * IX(size: Element.self))
    //=------------------------------------------=
    let (size) = IX(size: Element.self)
    let (major, minor) = distance.division(Nonzero(size)).unwrap().components()
    //=------------------------------------------=
    // upshift: any
    //=------------------------------------------=
    always: do {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.upshift(major: major, minor: minor, environment: environment)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    
    if  environment.isZero {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.upshift(major: major, minor: minor)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // upshift: major >= 1, minor == 0
    //=------------------------------------------=
    if  major >= 1, minor == 0 {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.upshift(majorAtLeastOne: major, minor: (( )), environment: environment)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    
    if  major >= 1, minor == 0, environment.isZero {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.upshift(majorAtLeastOne: major, minor: (( )))
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // upshift: major >= 0, minor >= 1
    //=------------------------------------------=
    if  major >= 0, minor >= 1 {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.upshift(major: major, minorAtLeastOne: minor, environment: environment)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    
    if  major >= 0, minor >= 1, environment.isZero {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.upshift(major: major, minorAtLeastOne: minor)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
}

@inlinable public func Ɣexpect<Element>(
    _  integer: [Element],
    down distance: IX,
    environment: Element,
    is expectation: [Element],
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerWhereIsUnsigned {
    //=------------------------------------------=
    try #require(integer.count == expectation.count)
    try #require(distance <    IX(expectation.count) * IX(size: Element.self))
    //=------------------------------------------=
    let (size) = IX(size: Element.self)
    let (major, minor) = distance.division(Nonzero(size)).unwrap().components()
    //=------------------------------------------=
    // downshift: any
    //=------------------------------------------=
    always: do {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.downshift(major: major, minor: minor, environment: environment)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    
    if  environment.isZero {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.downshift(major: major, minor: minor)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // downshift: major >= 1, minor == 0
    //=------------------------------------------=
    if  major >= 1, minor == 0 {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.downshift(majorAtLeastOne: major, minor: (( )), environment: environment)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    
    if  major >= 1, minor == 0, environment.isZero {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.downshift(majorAtLeastOne: major, minor: (( )))
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // downshift: major >= 0, minor >= 1
    //=------------------------------------------=
    if  major >= 0, minor >= 1 {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.downshift(major: major, minorAtLeastOne: minor, environment: environment)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    
    if  major >= 0, minor >= 1, environment.isZero {
        var result = integer; result.withUnsafeMutableBinaryIntegerBody {
            $0.downshift(major: major, minorAtLeastOne: minor)
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
}
