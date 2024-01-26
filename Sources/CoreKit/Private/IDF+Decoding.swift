//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Integer Description Format x Decoding
//*============================================================================*

extension Namespace.IntegerDescriptionFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable package static func decode(ascii: UInt8) throws -> UInt8 {
        let index = ascii &- UInt8(ascii: "0")
        
        if  index < 10 {
            return index
        }   else {
            throw Decoder.Error.unknown
        }
    }
    
    /// Returns an `UTF-8` encoded integer's `sign` and `body`.
    ///
    /// ```
    /// ┌──────────── → ──────┬────────┐
    /// │ description │ sign  │   body │
    /// ├──────────── → ──────┼────────┤
    /// │      "+123" │ plus  │  "123" │
    /// │      "-123" │ minus │  "123" │
    /// ├──────────── → ──────┼────────┤
    /// │      "~123" │ plus  │ "~123" │
    /// └──────────── → ──────┴────────┘
    /// ```
    ///
    /// - Note: Integers without sign are interpreted as positive.
    ///
    @inlinable package static func makeSignBody<UTF8>(from description: UTF8)
    -> (sign: Sign, body: UTF8.SubSequence) where UTF8: Collection<UInt8> {
        var body = description[...] as UTF8.SubSequence
        let sign = self.removeLeadingSign(from: &body) ?? Sign.plus
        return (sign: sign, body: body)
    }
    
    /// Removes and returns an `UTF-8` encoded `sign` prefix, if it exists.
    ///
    /// ```
    /// ┌──────────── → ──────┬────────┐
    /// │ description │ sign  │   body │
    /// ├──────────── → ──────┼────────┤
    /// │      "+123" │ plus  │  "123" │
    /// │      "-123" │ minus │  "123" │
    /// │      "~123" │ nil   │ "~123" │
    /// └──────────── → ──────┴────────┘
    /// ```
    ///
    @inlinable package static func removeLeadingSign<UTF8>(from description: inout UTF8)
    ->  Sign? where UTF8: Collection<UInt8>, UTF8 == UTF8.SubSequence {
        switch description.first {
        case UInt8(ascii: "+"): description.removeFirst(); return Sign.plus
        case UInt8(ascii: "-"): description.removeFirst(); return Sign.minus
        default: return nil  }
    }
    
    //*========================================================================*
    // MARK: * Decoder
    //*========================================================================*
    
    @frozen public struct Decoder {
        
        @frozen public enum Error: Swift.Error { case unknown }
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let radix = Exponentiation()
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init() { }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func decode<T: BinaryInteger>(_ description: StaticString) -> T {
            description.withUTF8Buffer({ try! self.decode($0) })
        }
        
        @inlinable public func decode<T: BinaryInteger>(_ description: some StringProtocol) throws -> T {
            var description = String(description); return try description.withUTF8(self.decode)
        }
        
        @inlinable public func decode<T: BinaryInteger>(_ description: UnsafeBufferPointer<UInt8>) throws -> T {
            let components = Namespace.IntegerDescriptionFormat.makeSignBody(from: description)
            let numerals = UnsafeBufferPointer(rebasing: components.body)
            let magnitude: T.Magnitude = try self.magnitude(numerals: numerals)
            return try T(sign: components.sign, magnitude: magnitude)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension Namespace.IntegerDescriptionFormat.Decoder {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func magnitude<Magnitude>(numerals: UnsafeBufferPointer<UInt8>) throws -> Magnitude where Magnitude: BinaryInteger {
        //=--------------------------------------=
        if  numerals.isEmpty {
            throw Error.unknown
        }
        //=--------------------------------------=
        var digits: UnsafeBufferPointer<UInt8>.SubSequence = numerals.drop(while:{ $0 == UInt8(ascii: "0") })
        let division = try! IX(digits.count).divided(by: self.radix.exponent)
        return try Namespace.withUnsafeTemporaryAllocation(of: UX.self, count: try! division.ceil().stdlib) {
            var words = consume $0
            var index = words.startIndex
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                words[..<index].deinitialize()
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            forwards: if division.remainder > 0 {
                var element = 0 as UX
                
                for (ascii) in UnsafeBufferPointer(rebasing: digits.removePrefix(count: division.remainder.stdlib)) {
                    element = try element &* 10 &+ U8(IDF.decode(ascii: ascii)).load(as: UX.self)
                }
                
                words.initializeElement(at: index, to: element)
                index = words .index(after: index)
            }
            
            forwards: while index < words.endIndex {
                var element = 0 as UX
                
                for (ascii) in UnsafeBufferPointer(rebasing: digits.removePrefix(count: self.radix.exponent.stdlib)) {
                    element = try element &* 10 &+ U8(IDF.decode(ascii: ascii)).load(as: UX.self)
                }
                
                words.initializeElement(at: index, to: SUISS.multiply(&words[..<index], by: radix.power, add: element))
                index = words .index(after: index)
            }
            
            Swift.assert(digits.isEmpty)
            Swift.assert(index == words.endIndex)
            return try Magnitude(elements: ExchangeInt(words, repeating: Bit.zero), isSigned: false)
        }
    }
}
