//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Division
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing the `dividend` by the `divisor` by trapping on `error` and `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public static func /(dividend: consuming Self, divisor: Self) -> Self {
        Finite(dividend).quotient(Nonzero(divisor)).unwrap()
    }
    
    /// Returns the `remainder` of dividing the `dividend` by the `divisor` by trapping on `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public static func %(dividend: consuming Self, divisor: Self) -> Self {
        Finite(dividend).remainder(Nonzero(divisor))
    }
    
    /// Forms the `quotient` of dividing the `dividend` by the `divisor` by trapping on `error` and `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public static func /=(dividend: inout Self, divisor: borrowing Self) {
        dividend = dividend / divisor
    }
    
    /// Forms the `remainder` of dividing the `dividend` by the `divisor` by trapping on `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public static func %=(dividend: inout Self, divisor: borrowing Self) {
        dividend = dividend % divisor
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Finite
//*============================================================================*

extension BinaryInteger where Self: FiniteInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Self>) -> Fallible<Self> {
        Finite(unchecked: self).quotient(divisor)
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Nonzero<Self>) -> Self {
        Finite(unchecked: self).remainder(divisor)
    }
    
    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Self>) -> Fallible<Division<Self, Self>> {
        Finite(unchecked: self).division(divisor)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantee
//=----------------------------------------------------------------------------=

extension Finite where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Value>) -> Fallible<Value> {
        (self.value.quotient(divisor) as Optional<Fallible<Value>>).unchecked()
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Nonzero<Value>) -> Value {
        (self.value.remainder(divisor) as Optional<Value>).unchecked()
    }
    
    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Value>) -> Fallible<Division<Value, Value>> {
        (self.value.division(divisor) as Optional<Fallible<Division<Value, Value>>>).unchecked()
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Natural
//*============================================================================*

extension BinaryInteger where Self: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Self>) -> Self {
        Natural(unchecked: self).quotient(divisor)
    }
    
    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Self>) -> Division<Self, Self> {
        Natural(unchecked: self).division(divisor)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Divider
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func quotient(_ divider: borrowing Divider<Self>) -> Self {
        divider.quotient(dividing: self)
    }
    
    @inlinable public consuming func division(_ divider: borrowing Divider<Self>) -> Division<Self, Self> {
        divider.division(dividing: self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantee
//=----------------------------------------------------------------------------=

extension Natural where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Value>) -> Value {
        Finite(unchecked: self.value).quotient(divisor).unchecked()
    }

    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Value>) -> Division<Value, Value> {
        Finite(unchecked: self.value).division(divisor).unchecked()
    }
}
