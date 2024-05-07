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
// MARK: * Test x Text
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Tests integer text de/encoding.
    ///
    /// - Note: You may prefix the body with `">"` and `"0"` and characters.
    ///
    /// ### Development
    ///
    /// - TODO: Perform sign and mask transformations.
    ///
    public func description<Integer>(_ integer: Integer, radix: UX, body: String) where Integer: BinaryInteger {
        //=--------------------------------------=
        guard let lowercase = success({ try TextInt(radix: radix, letters: .lowercase) }) else { return }
        guard let uppercase = success({ try TextInt(radix: radix, letters: .uppercase) }) else { return }
        //=--------------------------------------=
        let body/*---*/ = String(body.drop(while:{ $0 == ">" }))
        var expectation = String(body.drop(while:{ $0 == "0" }))
        if  expectation.isEmpty {
            expectation.append(contentsOf: body.suffix(1))
        }
        
        let expectationLowercased = expectation.lowercased()
        let expectationUppercased = expectation.uppercased()
        //=--------------------------------------=
        // test: decoding
        //=--------------------------------------=
        if  radix == 10 {
            same(Integer.init(body),                  integer, "init?(_ description: String) [0]")
            same(Integer.init(expectation),           integer, "init?(_ description: String) [1]")
            same(Integer.init(expectationLowercased), integer, "init?(_ description: String) [2]")
            same(Integer.init(expectationUppercased), integer, "init?(_ description: String) [3]")
        }
        
        success({ try Integer.init(body,        as: lowercase) }, integer)
        success({ try Integer.init(expectation, as: uppercase) }, integer)
        //=--------------------------------------=
        // test: encoding
        //=--------------------------------------=
        if  radix == 10 {
            same(integer.description,  expectation, "BinaryInteger/description")
            same(String.init(integer), expectation, "String.init(_:) - LosslessStringConvertible")
        }
                
        same(integer.description(as: lowercase), expectationLowercased, "description(in:) [0]")
        same(integer.description(as: uppercase), expectationUppercased, "description(in:) [1]")
    }
    
    /// Tests whether an integer's description is stable.
    ///
    /// - Note: Use this method when you can't inline the your expectation.
    ///
    public func description<Integer>(roundtripping integer: Integer, radices: Range<UX> = 2 ..< 37) where Integer: BinaryInteger {
        for radix in  radices {
            guard let lowercase = success({ try TextInt(radix: radix, letters: .lowercase) }) else { return }
            guard let uppercase = success({ try TextInt(radix: radix, letters: .uppercase) }) else { return }
            
            for coder in [lowercase, uppercase] {
                success({ try coder.decode(coder.encode(integer)) }, integer, "[\(radix)]")
            }
        }
    }
}
