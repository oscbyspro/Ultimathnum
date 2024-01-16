//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer x Partition x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence  {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Splits `base` at `index` then trims redundant zeros from each sequence.
    @inlinable public static func partitionNoRedundantZeros<T>(
    _   base: Base, at index: Base.Index) -> (high: Base, low: Base) where Base == UnsafeBufferPointer<T> {
        let partition = Swift.min(base.count, index)
        let low  = Base(start: base.baseAddress!,  /*------*/ count: base[..<partition].dropLast(while:{ $0 == 0 }).count)
        let high = Base(start: base.baseAddress! + partition, count: base[partition...].dropLast(while:{ $0 == 0 }).count)
        return (high: high,  low: low)
    }
}
