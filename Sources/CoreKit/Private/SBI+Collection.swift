//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Binary Integer x Collection
//*============================================================================*

extension Namespace.StrictBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Prefix
    //=------------------------------------------------------------------------=
    
    /// Returns the first element.
    @inlinable package static func prefix1<T: SystemsInteger>(
        _ base: Base
    )   -> T where T.Magnitude == Base.Element.Magnitude {
        var index = base.startIndex as Base.Index
        return self.prefix1(base, pushing: &index)
    }
    
    /// Returns the first element by pushing the given `index`.
    @inlinable package static func prefix1<T: SystemsInteger>(
        _ base: Base,
        pushing index: inout Base.Index
    )   -> T where T.Magnitude == Base.Element.Magnitude {
        defer {
            base.formIndex(after: &index)
        }
        return T(bitPattern: base[index])
    }
    
    /// Returns the first two elements.
    @inlinable package static func prefix2<T: SystemsInteger>(
        _ base: Base
    )   -> Doublet<T> where T.Magnitude == Base.Element.Magnitude {
        var index = base.startIndex as Base.Index
        return self.prefix2(base, pushing: &index)
    }
    
    /// Returns the first two elements by pushing the given `index`.
    @inlinable package static func prefix2<T: SystemsInteger>(
        _ base: borrowing Base, 
        pushing index: inout Base.Index
    )   -> Doublet<T> where T.Magnitude == Base.Element.Magnitude {
        let low  = SBI.prefix1(base, pushing: &index) as T.Magnitude
        let high = SBI.prefix1(base, pushing: &index) as T
        return Doublet(low: low, high: high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Suffix
    //=------------------------------------------------------------------------=
    
    /// Returns the last element.
    @inlinable package static func suffix1<T: SystemsInteger>(
        _ base: Base
    )   -> T where T.Magnitude == Base.Element.Magnitude {
        var index = base.endIndex as Base.Index
        return self.suffix1(base, pulling: &index)
    }
    
    /// Returns the last element by pulling the given `index`.
    @inlinable package static func suffix1<T: SystemsInteger>(
        _ base: Base,
        pulling index: inout Base.Index
    )   -> T where T.Magnitude == Base.Element.Magnitude {
        base.formIndex(before: &index)
        return T(bitPattern: base[index])
    }
    
    /// Returns the last two elements.
    @inlinable package static func suffix2<T: SystemsInteger>(
        _ base: Base
    )   -> Doublet<T> where T.Magnitude == Base.Element.Magnitude {
        var index = base.endIndex as Base.Index
        return self.suffix2(base, pulling: &index)
    }
    
    /// Returns the last two elements by pulling the given `index`.
    @inlinable package static func suffix2<T: SystemsInteger>(
        _ base: Base,
        pulling index: inout Base.Index
    )   -> Doublet<T> where T.Magnitude == Base.Element.Magnitude {
        let high = SBI.suffix1(base, pulling: &index) as T
        let low  = SBI.suffix1(base, pulling: &index) as T.Magnitude
        return Doublet(high: high, low: low)
    }
}
