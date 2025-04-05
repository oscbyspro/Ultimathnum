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
    
    /// Returns the `value` of `description` and an `error` indicator, or `nil`.
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `description` is `invalid`.
    ///
    /// - Note: The default `format` is `TextInt.decimal`.
    ///
    @inlinable public func decode<Integer>(
        _  description: consuming String,
        as type: Integer.Type = Integer.self
    )   -> Optional<Fallible<Integer>> where Integer: BinaryInteger {
        
        description.withUTF8 {
            self.decode($0, as: Integer.self)
        }
    }
    
    /// Returns the `value` of `description` and an `error` indicator, or `nil`.
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `description` is `invalid`.
    ///
    /// - Note: The default `format` is `TextInt.decimal`.
    ///
    @inlinable public func decode<Integer>(
        _  description: UnsafeBufferPointer<UInt8>,
        as type: Integer.Type = Integer.self
    )   -> Optional<Fallible<Integer>> where Integer: BinaryInteger {
        
        var body = description[...]
        let sign = TextInt.remove(from: &body, prefix: Self.sign) ?? Sign.plus
        let mask = TextInt.remove(from: &body, prefix: Self.mask) != nil
        
        var magnitude: Optional<Fallible<Integer.Magnitude>> = nil
        
        self.decode(body: UnsafeBufferPointer(rebasing: body)) {
            magnitude = Integer.Magnitude.exactly($0, mode: Signedness.unsigned)
        }
        
        guard var magnitude = consume magnitude else { return nil }
        
        if  mask {
            magnitude.value.toggle()
        }
        
        if  mask, Integer.isFinite {
            magnitude.error = true
        }
        
        return Integer.exactly(sign: sign, magnitude: magnitude.value).veto(magnitude.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension TextInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable package func decode(
        body: consuming UnsafeBufferPointer<UInt8>,
        callback: (DataInt<UX>) -> Void
    )   -> Void {
        
        if  self.power.div == 1 {
            self.decode16(body: body, callback: callback)
            
        }   else {
            self.decode10(body: body, callback: callback)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Non-generic & Non-inlinable
    //=------------------------------------------------------------------------=
    
    @usableFromInline package func decode10(
        body: consuming UnsafeBufferPointer<UInt8>,
        callback: (DataInt<UX>) -> Void
    )   -> Void {
        
        Swift.assert(self.power.div != 1)
        //=--------------------------------------=
        if  body.isEmpty { return }
        //=--------------------------------------=
        body = UnsafeBufferPointer(rebasing: body.drop(while:{ $0 == 48 }))
        //=--------------------------------------=
        let divisor = Nonzero(unchecked: self.exponent)
        var steps:    IX = IX(body.count).remainder(divisor)
        var capacity: IX = IX(body.count).quotient (divisor).unchecked()
        
        if  steps.isZero {
            steps = self.exponent
        }   else {
            capacity = capacity.incremented().unchecked()
        }
        //=--------------------------------------=
        Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Int(capacity)) {
            var body  = consume body // or nonzero exit code
            let words = MutableDataInt<UX>.Body($0)![unchecked: ..<capacity]
            var index = IX.zero
            
            defer {
                words[unchecked: ..<index].deinitialize()
            }
            
            forwards: while !body.isEmpty {
                let part = UnsafeBufferPointer(rebasing: body[..<Int(steps)])
                ((body)) = UnsafeBufferPointer(rebasing: body[Int(steps)...])
                guard let element: UX = self.numerals.load(part) else { return }
                words[unchecked: index] = words[unchecked: ..<index].multiply(by: self.power.div, add: element)
                steps = (self.exponent)
                index = index.incremented().unchecked()
            }
            
            Swift.assert(body.isEmpty)
            Swift.assert(index == words.count)
            callback(DataInt((words)))
        }
    }
    
    @usableFromInline package func decode16(
        body: consuming UnsafeBufferPointer<UInt8>,
        callback: (DataInt<UX>) -> Void
    )   -> Void {
        
        Swift.assert(self.power.div == 1)
        Swift.assert(self.exponent.count(Bit.one) == Count(1))
        //=--------------------------------------=
        if  body.isEmpty { return }
        //=--------------------------------------=
        body = UnsafeBufferPointer(rebasing: body.drop(while:{ $0 == 48 }))
        //=--------------------------------------=
        let divisor = Nonzero(unchecked: self.exponent)
        var steps:    IX = IX(body.count).remainder(divisor)
        var capacity: IX = IX(body.count).quotient (divisor).unchecked()
        
        if  steps.isZero {
            steps = self.exponent
        }   else {
            capacity = capacity.incremented().unchecked()
        }
        //=--------------------------------------=
        Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Swift.Int(capacity)) {
            var body  = consume body // or nonzero exit code
            let words = MutableDataInt<UX>.Body($0)![unchecked: ..<capacity]
            var index = words.count
            
            defer {
                words[unchecked: index...].deinitialize()
            }
            
            backwards: while !body.isEmpty {
                let part = UnsafeBufferPointer(rebasing: body[..<Int(steps)])
                ((body)) = UnsafeBufferPointer(rebasing: body[Int(steps)...])
                guard let element: UX = self.numerals.load(part) else { return }
                steps = (self.exponent)
                index = index.decremented().unchecked()
                words[unchecked: index] = element
            }
            
            Swift.assert(body.isEmpty)
            Swift.assert(index.isZero)
            callback(DataInt((words)))
        }
    }
}
