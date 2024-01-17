//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Integer Description Format x Encoding
//*============================================================================*

extension Namespace.IntegerDescriptionFormat {
    
    @frozen public struct Encoder<Element> where Element: UnsignedInteger & SystemInteger, Element.BitPattern == Word.BitPattern {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let radix = Radix<Element>()
        
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
    
    @inlinable public func encode(_ integer: some Integer) -> String {
        let sign = Sign(Bit(integer < 0))
        let magnitude = BitCastSequence(integer.magnitude.words, as: Element.self)
        return self.encode(sign: sign, magnitude: magnitude)
    }
    
    @inlinable public func encode(sign: Sign, magnitude: some Collection<Element>) -> String {
        Namespace.withUnsafeTemporaryAllocation(copying: magnitude) {
            var magnitude: UnsafeMutableBufferPointer<Element> = $0
            return self.encode(sign: sign, magnitude: &magnitude)
        }
    }
    
    @inline(never) @inlinable func encode(sign: Sign, magnitude: inout UnsafeMutableBufferPointer<Element>) -> String {
        let maxChunkCount = self.radix.divisibilityByPowerUpperBound(magnitude: magnitude) as Int
        return Swift.withUnsafeTemporaryAllocation(of: Element.self, capacity: maxChunkCount) { chunks in
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
            return Namespace.withUnsafeTemporaryAllocation(of: UInt8.self, count: radix.exponent.load(as: Int.self)) { first in
                var remainders = chunks[..<chunksIndex]
                var firstChunk = remainders.removeLast()
                var firstIndex = first.endIndex
                let minus = sign == Sign.minus && firstChunk != 0 as Element
                //=------------------------------=
                // pointee: initialization
                //=------------------------------=
                backwards: repeat {
                    let remainder: Element
                    (firstChunk, remainder) =  Overflow.ignore({ try firstChunk.divided(by: radix.base).components })
                    precondition(firstIndex >  first.startIndex)
                    firstIndex = first.index(before: firstIndex)
                    first.initializeElement(at: firstIndex, to: UInt8(ascii: "0") &+ UInt8(truncatingIfNeeded: remainder.load(as: UInt.self)))
                    
                }   while firstChunk != 0
                //=------------------------------=
                // pointee: deferred deinitialization
                //=------------------------------=
                defer {
                    first[firstIndex...].deinitialize()
                }
                //=------------------------------=
                let count: Int = (minus ? 1 : 0) + first[firstIndex...].count + radix.exponent.load(as: Int.self) * remainders.count
                return String(unsafeUninitializedCapacity: count) { ascii in
                    //=--------------------------=
                    // allocation: count <= $0.count
                    //=--------------------------=
                    var asciiIndex = ascii.index(ascii.startIndex, offsetBy: count)
                    //=--------------------------=
                    // pointee: initialization
                    //=--------------------------=
                    for var chunk in remainders {
                        for _  in 0 as UInt ..< radix.exponent.load(as: UInt.self) {
                            let remainder: Element
                            (chunk, remainder) = Overflow.ignore({ try chunk.divided(by: radix.base).components })
                            precondition(asciiIndex > ascii.startIndex)
                            ascii.formIndex(before: &asciiIndex)
                            ascii.initializeElement(at: asciiIndex, to: UInt8(ascii: "0") &+ UInt8(truncatingIfNeeded: remainder.load(as: UInt.self)))
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
