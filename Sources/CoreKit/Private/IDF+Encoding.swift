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
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        @usableFromInline let radix = Exponentiation()
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
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
    
    @inlinable public func encode<T: BinaryInteger>(_ integer: T) -> String {
        let sign = Sign(bitPattern: integer.isLessThanZero)
        return integer.magnitude().withUnsafeBinaryIntegerElementsAsBytes {
            self.encode(sign: sign, magnitude: $0)
        }
    }
    
    @inlinable public func encode(sign: Sign, magnitude: MemoryInt<U8>) -> String {
        Namespace.withUnsafeTemporaryAllocation(copying: ExchangeInt<UX>(magnitude).body()) {
            var magnitude: UnsafeMutableBufferPointer<UX> = $0
            return self.encode(sign: sign, magnitude: &magnitude)
        }
    }
    
    @inline(never) @inlinable func encode(sign: Sign, magnitude: inout UnsafeMutableBufferPointer<UX>) -> String {
        let maxChunkCount = Int(self.radix.divisibilityByPowerUpperBound(magnitude: magnitude))
        return Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: maxChunkCount) { chunks in
            var magnitude = magnitude[...]
            var chunksIndex = chunks.startIndex
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            rebasing: while !magnitude.isEmpty {
                let chunk = SUISS.formQuotientWithRemainder(dividing: &magnitude, by: radix.power)
                magnitude = magnitude.dropLast(while:{ $0 == 0 })
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
                var firstChunk = remainders.removeLast()
                var firstIndex = first.endIndex
                let minus = sign == Sign.minus && firstChunk != 0 as UX
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
                let count: Int = (minus ? 1 : 0) + first[firstIndex...].count + radix.exponent.base * remainders.count
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
                    
                    if  minus {
                        precondition(asciiIndex > ascii.startIndex)
                        ascii.formIndex(before: &asciiIndex)
                        ascii.initializeElement(at: asciiIndex, to: UInt8(ascii: "-"))
                    }
                    
                    Swift.assert(asciiIndex == ascii.startIndex)
                    return count as Int
                }
            }
        }
    }
}
