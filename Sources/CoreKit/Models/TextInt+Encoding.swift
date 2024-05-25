//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Text Int x Encoding
//*============================================================================*

extension TextInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func encode<T: BinaryInteger>(_ integer: T) -> String {
        var integer = integer // await consuming fix
        
        let integerAppendixIsSet = Bool(integer.appendix)
        let integerIsInfinite = !T.isSigned && integerAppendixIsSet
        let integerIsNegative =  T.isSigned && integerAppendixIsSet
        
        if  integerAppendixIsSet {
            integer = integer.complement(T.isSigned).value
        }
        
        return integer.withUnsafeBinaryIntegerElementsAsBytes {
            self.encode(
                sign: integerIsNegative ? .minus : nil,
                mask: integerIsInfinite ? .one   : nil,
                body: $0.body
            )
        }
    }
    
    @inlinable public func encode<T: UnsignedInteger>(sign: Sign, magnitude: consuming T) -> String {
        let integerIsInfinite = Bool(magnitude.appendix)
        let integerIsNegative = Bool(sign) && (magnitude != T.zero)
        
        if  integerIsInfinite {
            magnitude.toggle()
        }
        
        return magnitude.withUnsafeBinaryIntegerElementsAsBytes {
            self.encode(
                sign: integerIsNegative ? .minus : nil,
                mask: integerIsInfinite ? .one   : nil,
                body: $0.body
            )
        }
    }
    
    @inlinable public func encode(sign: Sign?, mask: Bit?, body: consuming DataInt<U8>.Body) -> String {
        //=--------------------------------------=
        // body: normalization
        //=--------------------------------------=
        body = body.normalized()
        //=--------------------------------------=
        let count = body.count(as: UX.self)
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Int(count)) { buffer in
            let words = MutableDataInt.Body(buffer.baseAddress!, count: count)
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            for index in words.indices {
                words[unchecked: index] = body[unchecked:(index &* IX(MemoryLayout<UX>.stride))...].load(as: UX.self)
            }
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                words.deinitialize()
            }
            //=----------------------------------=
            return self.encode(sign: sign, mask: mask, normalized: words)
        }
    }
}

//=------------------------------------------------------------------------=
// MARK: Algorithms
//=------------------------------------------------------------------------=

extension TextInt {
    
    //=--------------------------------------------------------------------=
    // MARK: Utilities
    //=--------------------------------------------------------------------=
    
    @usableFromInline func encode(sign: Sign?, mask: Bit?, normalized body: consuming MutableDataInt<UX>.Body) -> String {
        //=--------------------------------------=
        Swift.assert(body.count == .zero || body[unchecked: body.count - 1] != .zero)
        //=--------------------------------------=
        // text: capacity upper bound
        //=--------------------------------------=
        var capacity: IX = body.count(.nondescending(.zero))
        var rate: UX  = self.exponentiation.power.size()
        
        if  self.exponentiation.power != .zero {
            rate -= 1 + self.exponentiation.power.count(.descending(.zero))
        }

        capacity /= IX(raw: rate)
        capacity += 1
        capacity *= self.exponentiation.exponent
        capacity += IX(Bit(sign != nil))
        capacity += IX(Bit(mask != nil))
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: Int(capacity)) { ascii in
            //=----------------------------------=
            // pointee: initialization, 48 == "0"
            //=----------------------------------=
            ascii.initialize(repeating: 48)
            //=----------------------------------=
            var chunk: UX = 000 // must be zero
            var asciiIndex: Int = ascii.endIndex
            var chunkIndex: Int = ascii.endIndex
            //=----------------------------------=
            // text: set numerals
            //=----------------------------------=
            major: while true {
                                                
                if  let divisor = Divisor(exactly: self.exponentiation.power) {
                    chunk = body.divisionSetQuotientGetRemainder(divisor)
                    body  = body.normalized()
                }   else if body.count != .zero {
                    chunk = body[unchecked: (  )]
                    body  = body[unchecked: 1...]
                }   else {
                    Swift.assert(chunk == .zero)
                }
                
                minor: repeat {
                
                    let lowest: UX
                    (chunk, lowest) = chunk.division(Divisor(unchecked: self.radix)).unchecked().components()
                    let element = try! self.numerals.encode(U8(load: lowest))
                    precondition(asciiIndex > ascii .startIndex)
                    asciiIndex = ascii.index(before: asciiIndex)
                    ascii.initializeElement(at: asciiIndex, to: UInt8(element))
                    
                } while chunk != .zero
                //=------------------------------=
                if body.count == .zero { break }
                //=------------------------------=
                // note preinitialization to 48s
                //=------------------------------=
                chunkIndex = chunkIndex - Int(self.exponentiation.exponent)
                asciiIndex = chunkIndex
            }
            //=----------------------------------=
            // text: set sign and/or mask
            //=----------------------------------=
            if  let mask {
                precondition(asciiIndex > ascii.startIndex)
                asciiIndex = ascii.index(before: asciiIndex)
                ascii.initializeElement(at: asciiIndex, to: Self.encode(mask))
            }
            
            if  let sign {
                precondition(asciiIndex > ascii.startIndex)
                asciiIndex = ascii.index(before: asciiIndex)
                ascii.initializeElement(at: asciiIndex, to: Self.encode(sign))
            }
            //=----------------------------------=
            // pointee: move de/initialization
            //=----------------------------------=
            let prefix = UnsafeMutableBufferPointer(rebasing: ascii[..<asciiIndex])
            let suffix = UnsafeMutableBufferPointer(rebasing: ascii[asciiIndex...])
            
            prefix.deinitialize()
            
            return String(unsafeUninitializedCapacity: suffix.count) {
                _  = $0.moveInitialize(fromContentsOf: suffix)
                return suffix.count as Int as Int as Int as Int as Int
            }
        }
    }
}
