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
    
    /// Returns the binary integer description of `integer`.
    @inlinable public func encode<Integer>(
        _ integer: consuming Integer
    )   -> String where Integer: BinaryInteger {
        
        var data  = U32.zero
        var size  = IX .zero
        
        if  Bool(integer.appendix) {
            integer = integer.complement(Integer.isSigned).value
            data  = U32(load: U8(UInt8(ascii: Integer.isSigned ? "-" : "&")))
            size  = 1
        }
        
        return self.encode(
            info: data,
            size: size,
            body: Finite(unchecked: Integer.Magnitude(raw: integer))
        )
    }
    
    /// Returns the binary integer description of `sign` and `magnitude`.
    @inlinable public func encode<Integer>(
        sign: Sign, magnitude: consuming Integer
    )   -> String where Integer: UnsignedInteger {
        
        var data  = U32.zero
        var size  = IX .zero
        let mask  = Bool(magnitude.appendix)
        let sign  = Bool(sign == Sign.minus)
        
        if  mask {
            magnitude.toggle()
            data  = U32(load: U8(UInt8(ascii: "&")))
            size  = 1
        }
        
        if  sign, mask || !magnitude.isZero {
            data  = data.up(U8.size)
            data |= U32(load: U8(UInt8(ascii: "-")))
            size  = size.incremented().unchecked()
        }
        
        return self.encode(
            info: data,
            size: size,
            body: Finite(unchecked: magnitude)
        )
    }
}

//=------------------------------------------------------------------------=
// MARK: Algorithms
//=------------------------------------------------------------------------=

extension TextInt {
    
    //=--------------------------------------------------------------------=
    // MARK: Utilities
    //=--------------------------------------------------------------------=
    
    /// A minor small-prefix unification.
    ///
    /// - Note: `U32` is big enough for `-0x&` (infinitely negative hexadecimal).
    ///
    @inlinable package func encode<Integer>(
        info: consuming U32,
        size: consuming IX,
        body: consuming Finite<Integer>
    )   -> String where Integer: UnsignedInteger {
        
        let body = consume body // await ownership fix
        
        return Swift.withUnsafePointer(to: info.endianness(Order.ascending)) {
            $0.withMemoryRebound(to: UInt8.self, capacity: 4) {
                self.encode(
                    info: UnsafeBufferPointer(start: $0, count: size.stdlib()),
                    body: body
                )
            }
        }
    }
    
    @inlinable package func encode<Integer>(
        info: consuming UnsafeBufferPointer<UInt8>,
        body: consuming Finite<Integer>
    )   -> String where Integer: UnsignedInteger {
        
        let body = (consume body).value
        
        if  Integer.size <= UX.size {
            var small = UX(load: body)
            let range = PartialRangeUpTo(IX(Bit(!small.isZero)))
            return small.withUnsafeMutableBinaryIntegerBody {
                self.encode(info: info, normalized: $0[unchecked: range])
            }
            
        }   else {
            return body.withUnsafeBinaryIntegerBody(as: U8.self) {
                self.encode(info: info, body: $0)
            }
        }
    }
    
    @usableFromInline package func encode(
        info: consuming UnsafeBufferPointer<UInt8>,
        body: consuming DataInt<U8>.Body
    )   -> String {
        
        let count = body.count(as: UX.self)
        
        return  Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Swift.Int(count)) {
            let words = MutableDataInt.Body($0.baseAddress!, count: count)
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            for index: IX  in words.indices {
                let start: IX =  index.times(IX(MemoryLayout<UX>.stride)).unchecked()
                words[unchecked: index] = DataInt(body[unchecked: start...]).load(as: UX.self)
            }
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                words.deinitialize()
            }
            //=----------------------------------=
            return self.encode(info: info, normalized: words.normalized())
        }
    }
    
    @usableFromInline package func encode(
        info: consuming  UnsafeBufferPointer<UInt8>,
        normalized body: consuming MutableDataInt<UX>.Body
    )   -> String {
        
        Swift.assert(body.isNormal)
        //=--------------------------------------=
        // text: capacity upper bound
        //=--------------------------------------=
        var capacity = IX(raw: body.nondescending(Bit.zero))
        let speed = if self.power.div == 1 {
            IX(raw: self.power.div.size())
        }   else  {
            IX(raw: self.power.div.nondescending(Bit.zero)).decremented().unchecked()
        }
        
        capacity /= speed
        capacity += 1
        capacity *= self.exponent
        capacity += IX(info.count)
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: Int(capacity)) { ascii in
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            ascii.initialize(repeating: UInt8(ascii: "0"))
            //=----------------------------------=
            var chunk: UX = 000 // must be zero
            var asciiIndex: Int = ascii.endIndex
            var chunkIndex: Int = ascii.endIndex
            let radix = Nonzero(unchecked: UX(load: self.radix as U8))
            //=----------------------------------=
            // text: set numerals
            //=----------------------------------=
            major: while true {
                
                if  self.power.div != 1 {
                    chunk = (body).divisionSetQuotientGetRemainder(self.power)
                    body  = (body).normalized()
                }   else if !body .isEmpty {
                    chunk = (body)[unchecked: (  )]
                    body  = (body)[unchecked: 1...]
                }   else {
                    Swift.assert(chunk.isZero)
                }
                
                minor: repeat {
                
                    let lowest: UX
                    (chunk, lowest) =  chunk.division(radix).components()
                    let element = try! self.numerals.encode(U8(load: lowest))
                    precondition(asciiIndex > ascii .startIndex)
                    asciiIndex = ascii.index(before: asciiIndex)
                    ascii.initializeElement(at: asciiIndex, to: UInt8(element))
                    
                }   while !chunk.isZero
                //=------------------------------=
                if  body.isEmpty { break }
                //=------------------------------=
                // note preinitialization to 48s
                //=------------------------------=
                chunkIndex = chunkIndex - Int(self.exponent)
                asciiIndex = chunkIndex
            }
            //=----------------------------------=
            // text: set sign and/or mask
            //=----------------------------------=
            for element in info.reversed() {
                precondition(asciiIndex >  ascii.startIndex)
                asciiIndex = ascii.index(before: asciiIndex)
                ascii.initializeElement(at: asciiIndex, to: UInt8(element))
            }
            //=----------------------------------=
            // pointee: move de/initialization
            //=----------------------------------=
            let prefix = UnsafeMutableBufferPointer(rebasing: ascii[..<asciiIndex])
            let suffix = UnsafeMutableBufferPointer(rebasing: ascii[asciiIndex...])
            
            prefix.deinitialize()
            
            return String(unsafeUninitializedCapacity: suffix.count) {
                _  = $0.moveInitialize(fromContentsOf: suffix); return suffix.count
            }
        }
    }
}
