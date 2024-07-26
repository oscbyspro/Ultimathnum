//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Randomness x Range
//*============================================================================*

extension Randomness {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns a random from zero through the given `limit`.
    ///
    /// - Requires: The `limit` must not be infinite.
    ///
    /// ### Algorithm
    ///
    /// Systems integers use an adaptation of "Fast Random Integer Generation in
    /// an Interval" by Daniel Lemire, which is also used in Swift's standard library
    /// at the time of writing. [Learn more](https://arxiv.org/abs/1805.10941)\.
    ///
    /// Arbitrary integers accept-reject random bit patterns.
    ///
    @inlinable public mutating func next<T>(through limit: borrowing T) -> T where T: UnsignedInteger {
        if !T.isArbitrary {
            return self.systems(through: limit)
            
        }   else {
            return self.arbitrary(upTo: Signum.more, relativeTo: limit)
        }
    }
    
    /// Returns a random from zero up to the given `limit`.
    ///
    /// - Requires: The `limit` must not be infinite.
    ///
    /// ### Algorithm
    ///
    /// Systems integers use an adaptation of "Fast Random Integer Generation in
    /// an Interval" by Daniel Lemire, which is also used in Swift's standard library
    /// at the time of writing. [Learn more](https://arxiv.org/abs/1805.10941)\.
    ///
    /// Arbitrary integers accept-reject random bit patterns.
    ///
    @inlinable public mutating func next<T>(upTo limit: borrowing Divisor<T>) -> T where T: UnsignedInteger {
        if !T.isArbitrary {
            return self.systems(upTo: limit)
            
        }   else {
            return self.arbitrary(upTo: Signum.same, relativeTo: limit.value)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension Randomness {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns a random from zero through the given `limit`.
    ///
    /// ### Algorithm
    ///
    /// Systems integers use an adaptation of "Fast Random Integer Generation in
    /// an Interval" by Daniel Lemire, which is also used in Swift's standard library
    /// at the time of writing. [Learn more](https://arxiv.org/abs/1805.10941)\.
    ///
    /// Arbitrary integers accept-reject random bit patterns.
    ///
    @inlinable internal mutating func systems<T>(
        through limit: T
    ) -> T where T: UnsignedInteger {

        if  let end = limit.incremented().optional() {
            return self.systems(upTo: Divisor(unchecked: end))
            
        }   else {
            return self.systems()
        }
    }
    
    /// Returns a random from zero up to the given `limit`.
    ///
    /// ### Algorithm
    ///
    /// Systems integers use an adaptation of "Fast Random Integer Generation in
    /// an Interval" by Daniel Lemire, which is also used in Swift's standard library
    /// at the time of writing. [Learn more](https://arxiv.org/abs/1805.10941)\.
    ///
    /// Arbitrary integers accept-reject random bit patterns.
    ///
    @inlinable internal mutating func systems<T>(
        upTo limit: Divisor<T>
    ) -> T where T: UnsignedInteger {
        //  product.low  = product % (2 ** T.size)
        //  product.high = product / (2 ** T.size)
        var product = limit.value.multiplication(self.systems())
        if  product.low < limit.value {
            //  magic = (2 ** T.size) % limit
            let magic = limit.value.complement().remainder(limit)
            while product.low < magic {
                product = limit.value.multiplication(self.systems())
            }
        }
        
        return product.high
    }
    
    /// A common arbitrary binary integer algorithm.
    ///
    /// - Requires: The `comparison` must terminate.
    ///
    /// - Requires: The `limit` must not be infinite.
    ///
    /// ### Algorithm
    ///
    /// Systems integers use an adaptation of "Fast Random Integer Generation in
    /// an Interval" by Daniel Lemire, which is also used in Swift's standard library
    /// at the time of writing. [Learn more](https://arxiv.org/abs/1805.10941)\.
    ///
    /// Arbitrary integers accept-reject random bit patterns.
    ///
    ///
    @inline(never) @inlinable internal mutating func arbitrary<T>(upTo comparison: Signum, relativeTo limit: /* borrowing */ T) -> T where T: UnsignedInteger {
        //=--------------------------------------=
        precondition(T.isArbitrary, String.pleaseDoNotGenerateCodeForThisPath())
        //=--------------------------------------=
        if  limit.isInfinite {
            Swift.preconditionFailure(String.overflow())
        }
        
        if  comparison == Signum.less {
            Swift.assertionFailure(String.brokenInvariant())
        }
        
        if  comparison == Signum.same {
            Swift.assert(!limit.isZero)
        }
        
        return (limit).withUnsafeBinaryIntegerBody {
            let limit = (consume $0).normalized()
            //  TODO: req. normalized body, maybe?
            return T.arbitrary(uninitialized: limit.count, repeating: .zero) { body in
                guard !body.isEmpty else { return }
                
                let lastIndex = body.count.decremented().unchecked()
                let last = body[unchecked: lastIndex...].start
                let down = IX(raw: limit[unchecked: lastIndex].descending(Bit.zero))
                
                probabilistic: repeat {
                    
                    self.fill(body.bytes())
                    last.pointee &>>= down
                    
                } while body.compared(to: limit) >= comparison
            }!
        }
    }
}
