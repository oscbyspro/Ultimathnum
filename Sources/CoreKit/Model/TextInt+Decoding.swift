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
        let components = TextInt.makeSignMaskBody(from: description)
        let numerals = UnsafeBufferPointer(rebasing: components.body)
        var body: T.Magnitude = try self.magnitude(numerals: numerals)
        
        if  components.mask == Bit.one {
            if  T.size.isInfinite {
                body.toggle()
            }   else {
                throw Failure.overflow
            }
        }
        
        branch: do {
            return try T.exactly(sign: components.sign, magnitude: body).get()
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
    
    @inlinable func magnitude<Magnitude: BinaryInteger>(
        numerals: consuming UnsafeBufferPointer<UInt8>
    )   throws -> Magnitude {
        var magnitude: Magnitude?
        
        if  self.exponentiation.power == 0 {
            try self.words16(numerals: numerals) {
                magnitude = Magnitude.exactly($0, mode: .unsigned).optional()
            }
        }   else {
            try self.words10(numerals: numerals) {
                magnitude = Magnitude.exactly($0, mode: .unsigned).optional()
            }
        }
        
        if  let magnitude {
            return magnitude
        }   else {
            throw Failure.overflow
        }
    }
    
    /// - Requires: The `power` must be zero.
    @usableFromInline func words16(
        numerals: consuming UnsafeBufferPointer<UInt8>,
        success: (DataInt<UX>) throws -> Void
    )   throws {
        //=--------------------------------------=
        Swift.assert(self.exponentiation.power == 0)
        //=--------------------------------------=
        if  numerals.isEmpty {
            throw Failure.invalid
        }
        //=--------------------------------------=
        numerals = UnsafeBufferPointer(rebasing: numerals.drop(while:{ $0 == 48 }))
        let division = IX(numerals.count).division(self.exponentiation.exponent).unwrap()
        return try Namespace.withUnsafeTemporaryAllocation(of: UX.self, count: Int(division.ceil().unwrap())) {
            let words = DataInt<UX>.Canvas(consume $0)!
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
            var stride = division.remainder
            if  stride == IX.zero {
                stride = self.exponentiation.exponent
            }
                        
            while  index > IX.zero {
                let part = UnsafeBufferPointer(rebasing: numerals[..<Int(stride)])
                numerals = UnsafeBufferPointer(rebasing: numerals[Int(stride)...])
                let element = try self.numerals.load(part, as: UX.self)
                index[{ $0.decremented().assert() }]
                words[unchecked: index] = element
                stride = self.exponentiation.exponent
            }
            
            Swift.assert(numerals.isEmpty)
            Swift.assert(index == IX.zero)
            return try success(DataInt(words))
        }
    }
    
    /// - Requires: The `power` must be nonzero.
    @usableFromInline func words10(
        numerals: consuming UnsafeBufferPointer<UInt8>,
        success: (DataInt<UX>) throws -> Void
    )   throws {
        //=--------------------------------------=
        Swift.assert(self.exponentiation.power != 0)
        //=--------------------------------------=
        if  numerals.isEmpty {
            throw Failure.invalid
        }
        //=--------------------------------------=
        numerals = UnsafeBufferPointer(rebasing: numerals.drop(while:{ $0 == 48 }))
        let division = IX(numerals.count).division(self.exponentiation.exponent).unwrap()
        return try Namespace.withUnsafeTemporaryAllocation(of: UX.self, count: Int(division.ceil().unwrap())) {
            let words = DataInt<UX>.Canvas(consume $0)!
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
            var stride = division.remainder
            if  stride == IX.zero {
                stride = self.exponentiation.exponent
            }
            
            while  index < words.count {
                let part = UnsafeBufferPointer(rebasing: numerals[..<Int(stride)])
                numerals = UnsafeBufferPointer(rebasing: numerals[Int(stride)...])
                let element = try self.numerals.load(part, as: UX.self)
                words[unchecked: index] = words[unchecked: ..<index].multiply(by: self.exponentiation.power, add: element)
                index[{  $0.incremented().assert() }]
                stride = self.exponentiation.exponent
            }
            
            Swift.assert(numerals.isEmpty)
            Swift.assert(index == words.count)
            return try success(DataInt(words))
        }
    }
}
