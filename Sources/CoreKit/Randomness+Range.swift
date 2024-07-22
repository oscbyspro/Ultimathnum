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
    /// ### Algorithm
    ///
    /// This method uses an adaptation of "Fast Random Integer Generation in an
    /// Interval" by Daniel Lemire, which is also used in Swift's standard library
    /// at the time of writing. [Learn more](https://arxiv.org/abs/1805.10941)\.
    ///
    @inlinable public mutating func next<T>(
        through limit: T
    ) -> T where T: SystemsInteger & UnsignedInteger {
                
        if  let end = limit.incremented().optional() {
            return self.next(upTo: Divisor(unchecked: end))
            
        }   else {
            return self.next()
        }
    }
    
    /// Returns a random from zero up to the given `limit`.
    ///
    /// ### Algorithm
    ///
    /// This method uses an adaptation of "Fast Random Integer Generation in an
    /// Interval" by Daniel Lemire, which is also used in Swift's standard library
    /// at the time of writing. [Learn more](https://arxiv.org/abs/1805.10941)\.
    ///
    @inlinable public mutating func next<T>(
        upTo limit: Divisor<T>
    ) -> T where T: SystemsInteger & UnsignedInteger {
        //  product.low  = product % (2 ** T.size)
        //  product.high = product / (2 ** T.size)
        var product = limit.value.multiplication(self.next())
        if  product.low < limit.value {
            //  magic = (2 ** T.size) % limit
            let magic = limit.value.complement().remainder(limit)
            while product.low < magic {
                product = limit.value.multiplication(self.next())
            }
        }
        
        return product.high
    }
}
