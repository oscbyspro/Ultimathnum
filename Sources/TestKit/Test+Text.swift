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
        guard let lowercase = success(try TextInt(radix: radix, letters: .lowercase)) else { return }
        guard let uppercase = success(try TextInt(radix: radix, letters: .uppercase)) else { return }
        //=--------------------------------------=
        var expectation: (base: String, lowercase: String, uppercase: String)
        //=--------------------------------------=
        let ((((body)))) = String(body.drop(while:{ $0 == ">" }))
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
        
        success(try Integer.init(body,             as: lowercase), integer)
        success(try Integer.init(expectation.base, as: uppercase), integer)
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
    /// - Note: Use this method when you can't inline your expectation.
    ///
    public func description<Integer>(roundtripping integer: Integer, radix: UX) where Integer: BinaryInteger {
        if  let lowercase = success(try TextInt(radix: radix, letters: .lowercase)) {
            success(try lowercase.decode(lowercase.encode(integer)), integer, "[\(radix)][lowercase]")
        }
        
        if  let uppercase = success(try TextInt(radix: radix, letters: .uppercase)) {
            success(try uppercase.decode(uppercase.encode(integer)), integer, "[\(radix)][uppercase]")
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Pyramids
    //=------------------------------------------------------------------------=
    
    /// Generates a text pyramid and compares the result of text manipulation
    /// versus arithmetic where the pyramid is built by appending 0s to 1.
    ///
    ///     10
    ///     100
    ///     1000
    ///     .....
    ///
    public func descriptionByBaseNumeralPyramid<T>(_ type: T.Type, radix: UX, limit: UX = .max) where T: BinaryInteger {
        var decoded = T(1)
        var encoded = String("1")
        let multiplier = T(radix)
                
        always: do {
            
            for _ in 0 ..< limit {
                decoded = try decoded.times(multiplier).prune(TextInt.Error.overflow)
                encoded.append("0")
                
                self.description(decoded, radix: radix, body: encoded)
            }
            
        }   catch {
            nay(T.isArbitrary, "arbitrary integers should not overflow in this test")
        }
    }
    
    /// Generates a text pyramid and compares the result of text manipulation
    /// versus arithmetic where the pyramid is built by repeating numerals in
    /// ascending order from 1 with wrapping behavior.
    ///
    ///     1
    ///     12
    ///     123
    ///     1234
    ///     .....
    ///
    public func descriptionByEachNumeralPyramid<T>(_ type: T.Type, radix: UX, limit: UX = .max) where T: BinaryInteger {
        let encoder = try! TextInt.Numerals(36, letters: .lowercase)
        var decoded = T.zero
        var encoded = String()
        
        always: do {
            
            for index in (0 ..< limit).lazy.map({ ($0 &+ 1) % radix }) {
                decoded = try decoded.times(T(radix)).prune(TextInt.Error.overflow)
                decoded = try decoded.plus (T(index)).prune(TextInt.Error.overflow)
                encoded.append(String(UnicodeScalar(UInt8(try! encoder.encode(U8(load: index))))))

                self.description(decoded, radix: radix, body: encoded)
            }
            
        }   catch {
            nay(T.isArbitrary, "arbitrary integers should not overflow in this test")
        }
    }
    
    /// Generates a text pyramid and compares the result of text manipulation 
    /// versus arithmetic where the pyramid is built by repeating the highest
    /// numeral.
    ///
    ///     9
    ///     99
    ///     999
    ///     9999
    ///     .....
    ///
    public func descriptionByHighNumeralPyramid<T>(_ type: T.Type, radix: UX, limit: UX = .max) where T: BinaryInteger {
        let encoder = try! TextInt.Numerals(36, letters: .lowercase)
        var decoded = T.zero
        var encoded = String()
        
        let values: (radix: T, index: T, numeral: String)
        
        values.radix   = T(radix)
        values.index   = T(radix - 1)
        values.numeral = String(UnicodeScalar(UInt8(try! encoder.encode(U8(radix - 1)))))
        
        always: do {
            
            for _ in 0 ..< limit {
                decoded = try decoded.times(values.radix).prune(TextInt.Error.overflow)
                decoded = try decoded.plus (values.index).prune(TextInt.Error.overflow)
                encoded.append(values.numeral)
                
                self.description(decoded, radix: radix, body: encoded)
            }
            
        }   catch {
            nay(T.isArbitrary, "arbitrary integers should not overflow in this test")
        }
    }
}
