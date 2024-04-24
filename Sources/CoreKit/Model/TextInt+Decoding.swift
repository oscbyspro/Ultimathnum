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
        
        try self.words(numerals: numerals) {
            magnitude = T.Magnitude.exactly($0, mode: .unsigned)
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
        
        branch: do {
            return try T.exactly(sign: components.sign, magnitude: magnitude.value).get()
        }   catch {
            throw Failure.overflow
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension TextInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utiliites
    //=------------------------------------------------------------------------=
    
    @usableFromInline func words(
        numerals: consuming UnsafeBufferPointer<UInt8>, success: (DataInt<UX>) -> Void
    )   throws {
        //=--------------------------------------=
        if  numerals.isEmpty {
            throw Failure.invalid
        }   else {
            numerals = UnsafeBufferPointer(rebasing: numerals.drop(while:{ $0 == 48 }))
        }
        //=--------------------------------------=
        // capacity is measured in radix powers
        //=--------------------------------------=
        let division = IX(numerals.count).division(self.exponentiation.exponent).assert()
        let capacity = division.ceil().assert()
        //=--------------------------------------=
        return try Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Int(capacity)) {
            let words = DataInt<UX>.Canvas(consume $0)![unchecked: ..<(consume capacity)]
            var index = IX.zero  as IX as IX as IX as IX as IX
            let backwards = self.exponentiation.power == .zero
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                
                let initialized = if backwards {
                    words[unchecked: (words.count - index)...]
                }   else {
                    words[unchecked: ..<index]
                };  initialized.deinitialize()
                
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            let mask = IX(repeating: Bit(backwards))
            let head = words.count & mask
            
            var stride = division.remainder
            if  stride == IX.zero {
                stride = self.exponentiation.exponent
            }
                        
            while  index < words.count {
                let part = UnsafeBufferPointer(rebasing: numerals[..<Int(stride)])
                numerals = UnsafeBufferPointer(rebasing: numerals[Int(stride)...])
                var element = try self.numerals.load(part, as: UX.self)

                if !backwards {
                    // the index advances faster than the product
                    element = words[unchecked: ..<index].multiply(
                        by: self.exponentiation.power, add: element
                    )
                }
                
                words[unchecked:index ^ mask &+ head] = element
                index[{  $0.incremented().assert() }]
                stride = self.exponentiation.exponent
            }
            //=----------------------------------=
            // path: success
            //=----------------------------------=
            Swift.assert(numerals.isEmpty)
            Swift.assert(index == words.count)
            return success(DataInt(words))
        }
    }
}
