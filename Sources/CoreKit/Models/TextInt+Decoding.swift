//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Text Int x Decoding
//*============================================================================*

extension TextInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func decode<T: BinaryInteger>(_ description: StaticString) -> T {
        description.withUTF8Buffer({ try! self.decode($0) })
    }
    
    @inlinable public func decode<T: BinaryInteger>(_ description: some StringProtocol) throws -> T {
        var description = String(description)
        return try description.withUTF8(self.decode)
    }
    
    @inlinable public func decode<T: BinaryInteger>(_ description: UnsafeBufferPointer<UInt8>) throws -> T {
        let components = TextInt.decompose(description)
        let numerals   = UnsafeBufferPointer(rebasing: components.body)
        var magnitude  = Fallible(T.Magnitude.zero, error: true)
        
        if  self.exponentiation.power == .zero {
            try self.words16(numerals: numerals) {
                magnitude = T.Magnitude.exactly($0, mode: .unsigned)
            }
        }   else {
            try self.words10(numerals: numerals) {
                magnitude = T.Magnitude.exactly($0, mode: .unsigned)
            }
        }
        
        if  magnitude.error {
            throw Failure.overflow
        }
        
        if  components.mask == Bit.one {
            if  T.size.isInfinite {
                magnitude.value.toggle()
            }   else {
                throw Failure.overflow
            }
        }
        
        return try T.exactly(sign: components.sign, magnitude: magnitude.value).prune(Failure.overflow)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension TextInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @usableFromInline func words10(
        numerals: consuming UnsafeBufferPointer<UInt8>, success: (DataInt<UX>) -> Void
    )   throws {
        //=--------------------------------------=
        Swift.assert(self.exponentiation.power != .zero)
        //=--------------------------------------=
        // text must contain at least one numeral
        //=--------------------------------------=
        if  numerals.isEmpty {
            throw Failure.invalid
        }   else {
            numerals = UnsafeBufferPointer(rebasing: numerals.drop(while:{ $0 == 48 }))
        }
        //=--------------------------------------=
        // capacity is measured in radix powers
        //=--------------------------------------=
        var capacity:  IX
        var alignment: IX
        
        let divisor = Divisor(unchecked: self.exponentiation.exponent)
        (capacity, alignment) = IX(numerals.count).division(divisor).unchecked().components()
        (capacity) = capacity.plus(IX(Bit(alignment != .zero))).unchecked()
        //=--------------------------------------=
        return try Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Int(capacity)) {
            let words = MutableDataInt<UX>.Body(consume $0)![unchecked: ..<capacity]
            var index = IX.zero
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                                
                words[unchecked: ..<index].deinitialize()
                
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            var stride = alignment
            if  stride == .zero {
                stride = self.exponentiation.exponent
            }
            
            forwards: while !numerals.isEmpty {
                let part = UnsafeBufferPointer(rebasing: numerals[..<Int(stride)])
                numerals = UnsafeBufferPointer(rebasing: numerals[Int(stride)...])
                let element = try self.numerals.load(part, as: UX.self)
                // note that the index advances faster than the product
                words[unchecked: index] = words[unchecked: ..<index].multiply(by: self.exponentiation.power, add: element)
                stride = self.exponentiation.exponent
                index  = index.incremented().unchecked()
            }
            //=----------------------------------=
            // path: success
            //=----------------------------------=
            Swift.assert(numerals.isEmpty)
            Swift.assert(index == (words).count)
            return success(DataInt(words))
        }
    }
    
    @usableFromInline func words16(
        numerals: consuming UnsafeBufferPointer<UInt8>, success: (DataInt<UX>) -> Void
    )   throws {
        //=--------------------------------------=
        Swift.assert(self.exponentiation.power == .zero)
        Swift.assert(self.exponentiation.exponent.count(1) == 1)
        //=--------------------------------------=
        // text must contain at least one numeral
        //=--------------------------------------=
        if  numerals.isEmpty {
            throw Failure.invalid
        }   else {
            numerals = UnsafeBufferPointer(rebasing: numerals.drop(while:{ $0 == 48 }))
        }
        //=--------------------------------------=
        // capacity is measured in radix powers
        //=--------------------------------------=
        var capacity:  IX
        var alignment: IX
        
        let divisor = Divisor(unchecked: self.exponentiation.exponent)
        (capacity, alignment) = IX(numerals.count).division(divisor).unchecked().components()
        (capacity) = capacity.plus(IX(Bit(alignment != .zero))).unchecked()
        //=--------------------------------------=
        return try Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Int(capacity)) {
            let words = MutableDataInt<UX>.Body(consume $0)![unchecked: ..<capacity]
            var index = words.count
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                                
                words[unchecked: index...].deinitialize()
                
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            var stride = alignment
            if  stride == .zero {
                stride = self.exponentiation.exponent
            }
            
            backwards: while !numerals.isEmpty {
                let part = UnsafeBufferPointer(rebasing: numerals[..<Int(stride)])
                numerals = UnsafeBufferPointer(rebasing: numerals[Int(stride)...])
                index  = index.decremented().unchecked()
                words[unchecked: index] = try self.numerals.load(part, as: UX.self)
                stride = self.exponentiation.exponent
            }
            //=----------------------------------=
            // path: success
            //=----------------------------------=
            Swift.assert(numerals.isEmpty)
            Swift.assert(index == IX.zero)
            return success(DataInt(words))
        }
    }
}
