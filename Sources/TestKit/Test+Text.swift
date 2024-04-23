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
    
    /// ### Development
    ///
    /// - TODO: Perform sign and mask transformations too.
    ///
    public func description<Integer>(_ integer: Integer, radix: UX, body: String) where Integer: BinaryInteger {
        //=--------------------------------------=
        guard let lowercase = success({ try TextInt(radix: radix, letters: .lowercase) }) else { return }
        guard let uppercase = success({ try TextInt(radix: radix, letters: .uppercase) }) else { return }
        //=--------------------------------------=
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
        
        success({ try Integer.init(body,        in: lowercase) }, integer)
        success({ try Integer.init(expectation, in: uppercase) }, integer)
        //=--------------------------------------=
        // test: encoding
        //=--------------------------------------=
        if  radix == 10 {
            same(integer.description,  expectation, "BinaryInteger/description")
            same(String.init(integer), expectation, "String.init(_:) - LosslessStringConvertible")
        }
                
        same(integer.description(in: lowercase), expectationLowercased, "description(in:) [0]")
        same(integer.description(in: uppercase), expectationUppercased, "description(in:) [1]")
    }
}
