//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Double Int Layout x Division
//*============================================================================*

extension DoubleIntLayout {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (_ divisor: borrowing Base) -> Fallible<Base> {
        self.division(divisor).map({ $0.quotient  })
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Base) -> Fallible<Base> {
        self.division(divisor).map({ $0.remainder })
    }
    
    @inlinable public consuming func division (_ divisor: borrowing Base) -> Fallible<Division<Base, Base>> {
        Base.division(self, by: divisor)
    }
}
