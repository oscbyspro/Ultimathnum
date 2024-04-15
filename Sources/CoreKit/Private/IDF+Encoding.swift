//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Integer Description Format x Encoding
//*============================================================================*

extension Namespace.IntegerDescriptionFormat {
    
    @frozen public struct Encoder {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let radix = Exponentiation()
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init() { }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension Namespace.IntegerDescriptionFormat.Encoder {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func encode<T: BinaryInteger>(_ integer: consuming T) -> String {
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
        let integerIsNegative = Bool(sign) && (magnitude != 0)
        
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
    
    @inlinable public func encode(sign: Sign?, mask: Bit?, body: DataInt<U8>.Body) -> String {
        Namespace.withUnsafeTemporaryAllocation(copying: ExchangeInt<UX>(body).body()) {
            self.encode(
                sign: sign,
                mask: mask,
                body: DataInt.Canvas($0)!
            )
        }
    }
    
    @usableFromInline func encode(sign: Sign?, mask: Bit?, body: DataInt<UX>.Canvas) -> String {
        let maxChunkCount = self.radix.divisibilityByPowerUpperBound(magnitude: DataInt.Body(body))
        return Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Int(maxChunkCount)) { chunks in
            var magnitude = body as DataInt<UX>.Canvas
            var chunksIndex = chunks.startIndex
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            rebasing: while magnitude.count > 0 {
                let chunk = magnitude.divisionSetQuotientGetRemainder(Nonzero(unchecked: radix.power))
                magnitude = magnitude.normalized()
                chunks.initializeElement(at: chunksIndex, to: chunk)
                chunksIndex = chunks.index(after: chunksIndex)
            }
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                chunks[..<chunksIndex].deinitialize()
            }
            //=----------------------------------=
            return Namespace.withUnsafeTemporaryAllocation(of: UInt8.self, count: radix.exponent.base) { first in
                var remainders = chunks[..<chunksIndex]
                var firstChunk = remainders.popLast() ?? UX.zero
                var firstIndex = first.endIndex
                //=------------------------------=
                // pointee: initialization
                //=------------------------------=
                backwards: repeat {
                    
                    let remainder: UX
                    (firstChunk, remainder) = firstChunk.division(radix.base).assert().components
                    precondition(firstIndex >  first.startIndex)
                    firstIndex = first.index(before: firstIndex)
                    first.initializeElement(at: firstIndex, to: UInt8(ascii: "0") &+ UInt8(U8(load: remainder)))
                    
                }   while firstChunk != 0
                //=------------------------------=
                // pointee: deferred deinitialization
                //=------------------------------=
                defer {
                    first[firstIndex...].deinitialize()
                }
                //=------------------------------=
                let count: Int
                
                = (sign == nil ? 0 : 1)
                + (mask == nil ? 0 : 1)
                + first[firstIndex...].count + radix.exponent.base * remainders.count
                
                return String(unsafeUninitializedCapacity: count) { ascii in
                    //=--------------------------=
                    // allocation: count <= $0.count
                    //=--------------------------=
                    var asciiIndex = ascii.index(ascii.startIndex, offsetBy: count)
                    //=--------------------------=
                    // pointee: initialization
                    //=--------------------------=
                    for var chunk in remainders {
                        for _  in 0 as Int ..< radix.exponent.base {
                            let remainder: UX
                            (chunk, remainder) = chunk.division(radix.base).assert().components
                            precondition(asciiIndex > ascii.startIndex)
                            ascii.formIndex(before: &asciiIndex)
                            ascii.initializeElement(at: asciiIndex, to: UInt8(ascii: "0") &+ UInt8(U8(load: remainder)))
                        }
                    }
                    
                    for element in first[firstIndex...].reversed() {
                        precondition(asciiIndex > ascii.startIndex)
                        ascii.formIndex(before: &asciiIndex)
                        ascii.initializeElement(at: asciiIndex, to: element)
                    }
                    
                    if  let mask {
                        precondition(asciiIndex > ascii.startIndex)
                        ascii.formIndex(before: &asciiIndex)
                        let element =  UInt8(ascii: mask == .zero ? "#" : "&")
                        ascii.initializeElement(at: asciiIndex, to: element)
                    }
                    
                    if  let sign {
                        precondition(asciiIndex > ascii.startIndex)
                        ascii.formIndex(before: &asciiIndex)
                        let element =  UInt8(ascii: sign == .plus ? "+" : "-")
                        ascii.initializeElement(at: asciiIndex, to: element)
                    }
                    
                    Swift.assert(asciiIndex == ascii.startIndex)
                    return count as Int
                }
            }
        }
    }
}
