//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
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
    
    @inlinable package static func makeSignMaskBody<UTF8>(from description: UTF8)
    -> (sign: Sign, mask: Bit?, body: UTF8.SubSequence) where UTF8: Collection<UInt8> {
        var body = description[...] as UTF8.SubSequence
        let sign = self.removeLeadingSign(from: &body) ?? .plus
        let mask = self.removeLeadingMask(from: &body) ?? .zero
        return (sign: sign, mask: mask, body: body)
    }
    
    @inlinable package static func removeLeadingSign<UTF8>(from description: inout UTF8)
    ->  Sign? where UTF8: Collection<UInt8>, UTF8 == UTF8.SubSequence {
        switch description.first {
        case UInt8(ascii: "+"): description.removeFirst(); return Sign.plus
        case UInt8(ascii: "-"): description.removeFirst(); return Sign.minus
        default: return nil
        }
    }
    
    @inlinable package static func removeLeadingMask<UTF8>(from description: inout UTF8)
    ->  Bit? where UTF8: Collection<UInt8>, UTF8 == UTF8.SubSequence {
        switch description.first {
        case UInt8(ascii: "#"): description.removeFirst(); return Bit.zero
        case UInt8(ascii: "&"): description.removeFirst(); return Bit.one
        default: return nil
        }
    }
    
    //*========================================================================*
    // MARK: * Decoder
    //*========================================================================*
    
    @frozen public struct Decoder {
        
        @frozen public enum Error: Swift.Error { 
            case unknown
            case magnitudeIsInfinite
        }
        
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
            let components = Namespace.IntegerDescriptionFormat.makeSignMaskBody(from: description)
            let numerals = UnsafeBufferPointer(rebasing: components.body)
            var body: T.Magnitude = try self.magnitude(numerals: numerals)
            
            if  components.mask == Bit.one {
                if  T.size.isInfinite {
                    body.toggle()
                }   else {
                    throw Error.magnitudeIsInfinite
                }
            }
            
            return try T.exactly(sign: components.sign, magnitude: body).get()
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
        let division = IX(digits.count).division(self.radix.exponent).unwrap()
        return try Namespace.withUnsafeTemporaryAllocation(of: UX.self, count: Int(division.ceil().unwrap())) {
            let words = DataInt<UX>.Canvas(consume $0)!
            var index = IX.zero
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                words.start.deinitialize(count: Int(index))
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            forwards: if division.remainder > 0 {
                var element = 0 as UX
                
                for ascii  in UnsafeBufferPointer(rebasing: digits.removePrefix(count: division.remainder.base)) {
                    element = try element &* 10 &+ UX(load: U8(IDF.decode(ascii: ascii)))
                }
                
                words[unchecked: index] = element
                index = index.plus(1).assert()
            }
            
            forwards: while index < words.count {
                var element = 0 as UX
                
                for ascii  in UnsafeBufferPointer(rebasing: digits.removePrefix(count: self.radix.exponent.base)) {
                    element = try element &* 10 &+ UX(load: U8(IDF.decode(ascii: ascii)))
                }
                
                words[unchecked: index] = words[unchecked: ..<index].multiply(by: radix.power, add: element)
                index = index.plus(1).assert()
            }
            //=----------------------------------=
            Swift.assert(digits.isEmpty)
            Swift.assert(index == words.count)
            //=----------------------------------=
            return try Magnitude.exactly(DataInt(words), mode: .unsigned).get()
        }
    }
}
