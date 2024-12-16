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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and `error` of dividing `self` by the `divisor`, or `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func quotient(_ divisor: borrowing Self) -> Optional<Fallible<Self>> {
        guard  let divisor = Nonzero(exactly: copy divisor) else { return nil }
        return self.quotient(divisor)
    }
    
    /// Returns the `remainder` of dividing `self` by the `divisor`, or `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func remainder(_ divisor: borrowing Self) -> Optional<Self> {
        guard  let divisor = Nonzero(exactly: copy divisor) else { return nil }
        return self.remainder(divisor)
    }
    
    /// Returns the `quotient`, `remainder` and `error` of dividing `self` by the `divisor`, or `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func division(_ divisor: borrowing Self) -> Optional<Fallible<Division<Self, Self>>> {
        guard  let divisor = Nonzero(exactly: copy divisor) else { return nil }
        return self.division(divisor)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Finite
//*============================================================================*

extension BinaryInteger where Self: FiniteInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and `error` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Self>) -> Fallible<Self> {
        Finite(unchecked: self).quotient(divisor)
    }
    
    /// Returns the `remainder` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func remainder(_ divisor: borrowing Nonzero<Self>) -> Self {
        Finite(unchecked: self).remainder(divisor)
    }
    
    /// Returns the `quotient`, `remainder` and `error` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
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
    
    /// Returns the `quotient` and `error` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Value>) -> Fallible<Value> {
        (self.value.quotient(divisor) as Optional<Fallible<Value>>).unchecked()
    }
    
    /// Returns the `remainder` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func remainder(_ divisor: borrowing Nonzero<Value>) -> Value {
        (self.value.remainder(divisor) as Optional<Value>).unchecked()
    }
    
    /// Returns the `quotient`, `remainder` and `error` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Value>) -> Fallible<Division<Value, Value>> {
        (self.value.division(divisor) as Optional<Fallible<Division<Value, Value>>>).unchecked()
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Lenient
//*============================================================================*

extension BinaryInteger where Self: ArbitraryInteger & SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing `self` by the `divisor`, or `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func quotient(_ divisor: borrowing Self) -> Optional<Self> {
        guard  let divisor = Nonzero(exactly: copy divisor) else { return nil }
        return self.quotient(divisor)
    }
    
    /// Returns the `quotient` and `remainder` of dividing `self` by the `divisor`, or `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func division(_ divisor: borrowing Self) -> Optional<Division<Self, Self>> {
        guard  let divisor = Nonzero(exactly: copy divisor) else { return nil }
        return self.division(divisor)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Self>) -> Self {
        self.quotient(divisor).unchecked()
    }
    
    /// Returns the `quotient` and `remainder` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Self>) -> Division<Self, Self> {
        self.division(divisor).unchecked()
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Natural
//*============================================================================*

extension BinaryInteger where Self: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing `self` by the `divisor`, or `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func quotient(_ divisor: borrowing Self) -> Optional<Self> {
        guard  let divisor = Nonzero(exactly: copy divisor) else { return nil }
        return self.quotient(divisor)
    }
    
    /// Returns the `quotient` and `remainder` of dividing `self` by the `divisor`, or `nil`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func division(_ divisor: borrowing Self) -> Optional<Division<Self, Self>> {
        guard  let divisor = Nonzero(exactly: copy divisor) else { return nil }
        return self.division(divisor)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Self>) -> Self {
        Natural(unchecked: self).quotient(divisor)
    }
    
    /// Returns the `quotient` and `remainder` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Self>) -> Division<Self, Self> {
        Natural(unchecked: self).division(divisor)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Divider
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing `self` by the `divider`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public borrowing func quotient(_ divider: borrowing Divider<Self>) -> Self {
        divider.quotient(dividing: self)
    }
    
    /// Returns the `quotient` and `remainder` of dividing `self` by the `divider`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func division(_ divider: borrowing Divider<Self>) -> Division<Self, Self> {
        divider.division(dividing: self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Divider x 2-by-1
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient`, `remainder` and `error` of dividing the `dividend` by the `divider`.
    ///
    /// ### Division of 2 by 1
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func division(
        _ dividend: consuming Doublet<Self>,
        by divider: borrowing Divider21<Self>
    )   -> Fallible<Division<Self, Self>> {
        divider.division(dividing: dividend)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantee
//=----------------------------------------------------------------------------=

extension Natural where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Value>) -> Value {
        Finite(unchecked: self.value).quotient(divisor).unchecked()
    }

    /// Returns the `quotient` and `remainder` of dividing `self` by the `divisor`.
    ///
    /// ### Division
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `divisor`  is `zero`.
    ///
    /// - Note: It produces `nil` if the `dividend` is `infinite`.
    ///
    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Value>) -> Division<Value, Value> {
        Finite(unchecked: self.value).division(divisor).unchecked()
    }
}
