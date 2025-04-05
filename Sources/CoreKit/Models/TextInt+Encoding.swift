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
// MARK: + Algorithms
//=------------------------------------------------------------------------=

extension TextInt {
    
    //=--------------------------------------------------------------------=
    // MARK: Utilities
    //=--------------------------------------------------------------------=
    
    /// A minor small-prefix unification.
    ///
    /// - Note: `U32` is big enough for `-&0x` (negative infinite hexadecimal).
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
            return small.withUnsafeMutableBinaryIntegerBody {
                return self.encode(info: info, quasinormalized: $0)
            }
            
        }   else {
            return body.withUnsafeBinaryIntegerBody(as: U8.self) {
                return self.encode(info: info, body: $0)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Non-generic & Non-inlinable
    //=------------------------------------------------------------------------=
    
    @usableFromInline package func encode(
        info: consuming UnsafeBufferPointer<UInt8>,
        body: consuming DataInt<U8>.Body
    )   -> String {
        
        let count = body.count(as: UX.self)
        
        return  Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Swift.Int(count)) {
            let body  = consume body // or nonzero exit
            let words = MutableDataInt.Body($0.baseAddress.unchecked(), count: count)

            for index: IX  in words.indices {
                let start: IX =  index.times(IX(MemoryLayout<UX>.stride)).unchecked()
                words[unchecked: index] = DataInt(body[unchecked: start...]).load(as: UX.self)
            }

            defer {
                words.deinitialize()
            }
            
            return self.encode(info: info, quasinormalized: words.normalized())
        }
    }
    
    /// Returns the contents of `info` followed by the contents of `body`.
    ///
    /// - parameter body: It must be normalized or contain exactly one element.
    ///
    @usableFromInline package func encode(
        info: consuming UnsafeBufferPointer<UInt8>,
        quasinormalized body: consuming MutableDataInt<UX>.Body
    )   -> String {
        
        if !body.isNormal, body.count != 1 {
            Swift.assertionFailure("req. quasinormalized")
        }
        
        let radix    = Nonzero(unchecked: UX(load: self.radix as U8))
        let length   = Natural.init(unchecked: IX(raw: body .nondescending(Bit.zero)))
        var capacity = Swift.Int(Self.capacity(IX(raw: radix.value), length: length)!)
        
        capacity += info.count
        
        return String(unsafeUninitializedCapacity: capacity) {
            //  note that we use capacity and not $0.count
            let (start): UnsafeMutablePointer<Swift.UInt8> = $0.baseAddress.unchecked()
            let ((end)): UnsafeMutablePointer<Swift.UInt8> = start.advanced(by: capacity)
            var pointer: UnsafeMutablePointer<Swift.UInt8> = end
            var segment: UnsafeMutablePointer<Swift.UInt8> = end
            var ((body)) = consume body // or nonzero exit
            
            loop: while true {
                var part: UX, remainder: UX
                
                if  body.count <= 1 {
                    part = body.first ?? UX.zero
                    body = body[unchecked: ..<0]
                }   else if self.power.div == 1 {
                    part = body[unchecked: (  )]
                    body = body[unchecked: 1...]
                }   else {
                    part = body.divisionSetQuotientGetRemainder(self.power)
                    body = body.normalized()
                }
                
                repeat {
                    (part, remainder) = part.division(radix).components()
                    let element = self.numerals.encode(U8(load: remainder)).unchecked()
                    precondition(pointer > start)
                    pointer = pointer.predecessor()
                    pointer.initialize(to: Swift.UInt8(element))
                }   while !part.isZero
                
                finished: if body.isEmpty {
                    break loop
                }
                
                segment -= Swift.Int(self.exponent)
                Swift.precondition(segment >= start)
                while pointer >  segment {
                    Swift.assert(pointer > start)
                    pointer = pointer.predecessor()
                    pointer.initialize(to: 0x30)
                }
            }
            
            for element in info.reversed() {
                precondition(pointer > start)
                pointer = pointer.predecessor()
                pointer.initialize(to: element)
            }
            
            Swift.assert(pointer >= start)
            let count  = pointer.distance(to:  end)
            Swift.assert(capacity - count <= count)
            if  count != capacity {
                //  move to start index
                var destination = start
                while pointer < end {
                    destination.initialize(to: pointer.move())
                    destination = destination.successor()
                    ((pointer)) = ((pointer)).successor()
                }
            }
            
            return count // as Swift.Int as Swift.Int
        }
    }
}
