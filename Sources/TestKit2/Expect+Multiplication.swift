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
// MARK: * Expect x Multiplication x Data Integer
//*============================================================================*

@inlinable public func Ɣexpect<Element>(
    _ integer: [Element],
    times multiplier: [Element],
    plus increment: Element,
    is expectation: [Element],
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerWhereIsUnsigned {
    //=------------------------------------------=
    try #require(expectation.count == integer.count  + multiplier.count)
    try #require(expectation.count >= 0000000000001 || increment.isZero)
    //=------------------------------------------=
    // multiplication: expectation <= U64.max
    //=------------------------------------------=
    if  IX(expectation.count) * IX(size: Element.self) <= 64 {
        let a = try #require(U64.exactly(integer    ).optional())
        let b = try #require(U64.exactly(multiplier ).optional())
        let c = try #require(U64.exactly(increment  ).optional())
        let d = try #require(U64.exactly(expectation).optional())
        #expect(a.times(b).plus(c).optional() == d, "DataInt/initialize(to:times:plus:) <= U64.max", sourceLocation: location)
    }
    //=------------------------------------------=
    // multiplication: many × some + some
    //=------------------------------------------=
    if  integer.count == 1 {
        var result = multiplier
        let last = result.withUnsafeMutableBinaryIntegerBody {
            $0.multiply(by: integer.first!, add: increment)
        }
        
        result.append(last)
        #expect(result == expectation, sourceLocation: location)
    }
    
    if  multiplier.count == 1 {
        var result = integer
        let last = result.withUnsafeMutableBinaryIntegerBody {
            $0.multiply(by: multiplier.first!, add: increment)
        }
        
        result.append(last)
        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // multiplication: many × many
    //=------------------------------------------=
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        try result.withUnsafeMutableBinaryIntegerBody { result in
            try integer.withUnsafeBinaryIntegerBody { integer in
                try multiplier.withUnsafeBinaryIntegerBody { multiplier in
                    result.initializeByLongAlgorithm(to: integer, times: multiplier)
                    if !result.isEmpty {
                        try #require(!result.increment(by: increment).error)
                    }
                }
            }
        }

        #expect(result == expectation, sourceLocation: location)
    }

    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        try result.withUnsafeMutableBinaryIntegerBody { result in
            try integer.withUnsafeBinaryIntegerBody { integer in
                try multiplier.withUnsafeBinaryIntegerBody { multiplier in
                    result.initializeByKaratsubaAlgorithm(to: integer, times: multiplier)
                    if !result.isEmpty {
                        try #require(!result.increment(by: increment).error)
                    }
                }
            }
        }

        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // multiplication: many × many + some
    //=------------------------------------------=
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        result.withUnsafeMutableBinaryIntegerBody { result in
            integer.withUnsafeBinaryIntegerBody { integer in
                multiplier.withUnsafeBinaryIntegerBody { multiplier in
                    result.initializeByLongAlgorithm(to: integer, times: multiplier, plus: increment)
                }
            }
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
}

@inlinable public func Ɣexpect<Element>(
    squared integer: [Element],
    plus increment: Element,
    is expectation: [Element],
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerWhereIsUnsigned {
    //=------------------------------------------=
    try #require(expectation.count == integer.count  + integer   .count)
    try #require(expectation.count >= 0000000000001 || increment.isZero)
    //=------------------------------------------=
    // multiplication: long
    //=------------------------------------------=
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        try result.withUnsafeMutableBinaryIntegerBody { result in
            try integer.withUnsafeBinaryIntegerBody { integer in
                result.initializeByLongAlgorithm(toSquareProductOf: integer)
                if !result.isEmpty {
                    try #require(!result.increment(by: increment).error)
                }
            }
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        result.withUnsafeMutableBinaryIntegerBody { result in
            integer.withUnsafeBinaryIntegerBody { integer in
                result.initializeByLongAlgorithm(toSquareProductOf: integer, plus: increment)
            }
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // multiplication: karatsuba
    //=------------------------------------------=
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        try result.withUnsafeMutableBinaryIntegerBody { result in
            try integer.withUnsafeBinaryIntegerBody { integer in
                result.initializeByKaratsubaAlgorithm(toSquareProductOf: integer)
                if !result.isEmpty {
                    try #require(!result.increment(by: increment).error)
                }
            }
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
}
