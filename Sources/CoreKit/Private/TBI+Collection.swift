//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer x Collection
//*============================================================================*

extension Namespace.TupleBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Prefix
    //=------------------------------------------------------------------------=
    
    /// Returns the first element.
    @inlinable package static func prefix1<Base: Collection>(
    _   base: Base) -> X1 where Base.Element == High.Magnitude {
        var index = base.startIndex as Base.Index
        return self.prefix1(base, pushing: &index)
    }
    
    /// Returns the first element by pushing the given `index`.
    @inlinable package static func prefix1<Base: Collection>(
    _   base: Base, pushing index: inout Base.Index) -> X1 where Base.Element == High.Magnitude {
        defer{ base.formIndex(after: &index) }
        return High(bitPattern: base[index])
    }
    
    /// Returns the first two elements.
    @inlinable package static func prefix2<Base: Collection>(
    _   base: Base) -> X2 where Base.Element == High.Magnitude {
        var index = base.startIndex as Base.Index
        return self.prefix2(base, pushing: &index)
    }
    
    /// Returns the first two elements by pushing the given `index`.
    @inlinable package static func prefix2<Base: Collection>(
    _   base: Base, pushing index: inout Base.Index) -> X2 where Base.Element == High.Magnitude {
        let low  = TBI.prefix1(base, pushing: &index) as X1.Magnitude
        let high = TBI.prefix1(base, pushing: &index) as X1
        return X2(high: consume high, low: consume low)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Suffix
    //=------------------------------------------------------------------------=
    
    /// Returns the last element.
    @inlinable package static func suffix1<Base: BidirectionalCollection>(
    _   base: Base) -> X1 where Base.Element == High.Magnitude {
        var index = base.endIndex as Base.Index
        return self.suffix1(base, pulling: &index)
    }
    
    /// Returns the last element by pulling the given `index`.
    @inlinable package static func suffix1<Base: BidirectionalCollection>(
    _   base: Base, pulling index: inout Base.Index) -> X1 where Base.Element == High.Magnitude {
        base.formIndex(before: &index)
        return High(bitPattern: base[index])
    }
    
    /// Returns the last two elements.
    @inlinable package static func suffix2<Base: BidirectionalCollection>(
    _   base: Base) -> X2 where Base.Element == High.Magnitude {
        var index = base.endIndex as Base.Index
        return self.suffix2(base, pulling: &index)
    }
    
    /// Returns the last two elements by pulling the given `index`.
    @inlinable package static func suffix2<Base: BidirectionalCollection>(
    _   base: Base, pulling index: inout Base.Index) -> X2 where Base.Element == High.Magnitude {
        let high = TBI.suffix1(base, pulling: &index) as X1
        let low  = TBI.suffix1(base, pulling: &index) as X1.Magnitude
        return X2(high: consume high, low: consume low)
    }
}
