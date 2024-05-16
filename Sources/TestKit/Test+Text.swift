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
        var expectation: (base: String, lowercase: String, uppercase: String)
        //=--------------------------------------=
        let body/*----*/ = String(body.drop(while:{ $0 == ">" }))
        expectation.base = String(body.drop(while:{ $0 == "0" }))
        
        if  expectation.base.isEmpty {
            expectation.base.append(contentsOf: body.suffix(1))
        }
        
        expectation.lowercase = expectation.base.lowercased()
        expectation.uppercase = expectation.base.uppercased()
        //=--------------------------------------=
        // test: decoding
        //=--------------------------------------=
        if  radix == 10 {
            same(Integer.init(body),                  integer, "init?(_ description: String) [0]")
            same(Integer.init(expectation.base),      integer, "init?(_ description: String) [1]")
            same(Integer.init(expectation.lowercase), integer, "init?(_ description: String) [2]")
            same(Integer.init(expectation.uppercase), integer, "init?(_ description: String) [3]")
        }
        
        success({ try Integer.init(body,             as: lowercase) }, integer)
        success({ try Integer.init(expectation.base, as: uppercase) }, integer)
        //=--------------------------------------=
        // test: encoding
        //=--------------------------------------=
        if  radix == 10 {
            same(integer.description,  expectation.base, "BinaryInteger/description")
            same(String.init(integer), expectation.base, "String.init(_:) - LosslessStringConvertible")
        }
                
        same(integer.description(as: lowercase), expectation.lowercase, "description(as:) [0]")
        same(integer.description(as: uppercase), expectation.uppercase, "description(as:) [1]")
        
        always: do {
            let sign = Sign(integer.isNegative)
            let magnitude = integer.magnitude()
            
            same(lowercase.encode(sign: sign, magnitude: magnitude), expectation.lowercase, "TextInt/encode(sign:magnitude:) [0]")
            same(uppercase.encode(sign: sign, magnitude: magnitude), expectation.uppercase, "TextInt/encode(sign:magnitude:) [1]")
        }
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
