//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Fibonacci x Stride
//*============================================================================*

extension Fibonacci {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the sequence pair at `index + 1`, or `nil`.
    ///
    /// ### Fibonacci
    ///
    /// - Note: It produces `nil` of the operation is `lossy`.
    ///
    /// ### Development
    ///
    /// - Todo: Measure versus `components()` approach.
    ///
    @inlinable public consuming func incremented() -> Optional<Self> {
        self.base.incremented().map(Self.init(unsafe:)).optional()
    }
    
    /// Returns the sequence pair at `index - 1`, or `nil`..
    ///
    /// ### Fibonacci
    ///
    /// - Note: It produces `nil` of the operation is `lossy`.
    ///
    /// ### Development
    ///
    /// - Todo: Measure versus `components()` approach.
    ///
    @inlinable public consuming func decremented() -> Optional<Self> {
        self.base.decremented().map(Self.init(unsafe:)).optional()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the sequence pair at `index * 2`, or `nil`.
    ///
    /// ### Fibonacci
    ///
    /// - Note: It produces `nil` of the operation is `lossy`.
    ///
    /// ### Development
    ///
    /// - Todo: Measure versus `components()` approach.
    ///
    @inlinable public consuming func doubled() -> Optional<Self> {
        Self.doubled(self.base).map(Self.init(unsafe:)).optional()
    }
    
    /// Returns the sequence pair at `index + other.index`, or `nil`.
    ///
    /// ### Fibonacci
    ///
    /// - Note: It produces `nil` of the operation is `lossy`.
    ///
    /// ### Development
    ///
    /// - Todo: Measure versus `components()` approach.
    ///
    @inlinable public consuming func incremented(by other: borrowing Self) -> Optional<Self> {
        Self.incremented(self.base, by: other.base).map(Self.init(unsafe:)).optional()
    }
    
    /// Returns the sequence pair at `index - other.index`, or `nil`.
    ///
    /// ### Fibonacci
    ///
    /// - Note: It produces `nil` of the operation is `lossy`.
    ///
    /// ### Development
    ///
    /// - Todo: Measure versus `components()` approach.
    ///
    @inlinable public consuming func decremented(by other: borrowing Self) -> Optional<Self> {
        Self.decremented(self.base, by: other.base).map(Self.init(unsafe:)).optional()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension Fibonacci {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable package static func doubled(
        _ value: consuming Indexacci<Element>
    )   -> Fallible<Indexacci<Element>> {
        
        var (error) = false
        value.tuple = Self.doubled(value.tuple).sink(&error)
        value.index = ((value)).index.doubled().sink(&error)
        return value.veto(error)
    }
    
    @inlinable package static func doubled(
        _ value: consuming Tupleacci<Element>
    )   -> Fallible<Tupleacci<Element>> {
        
        var (error) = false
        let (extra) = value.major.doubled().sink(&error).minus(value.minor).sink(&error).times(value.minor).sink(&error)
        value.major = value.major.squared().sink(&error).plus((value.minor).squared().sink(&((((error)))))).sink(&error)
        value.minor = extra
        return value.veto(error)
    }
    
    @inlinable package static func incremented(
        _  value: consuming Indexacci<Element>,
        by other: borrowing Indexacci<Element>
    )   -> Fallible<Indexacci<Element>> {
        
        var (error) = false
        let (fails) = value.index.isNegative == other.index.isNegative
        value.index = value.index.plus(other.index).sink(&error)
        value.tuple = incremented(value.tuple, by: other.tuple).sink(&error)
        return value.veto(fails && error)
        
        func incremented(
            _  value: consuming Tupleacci<Element>,
            by other: borrowing Tupleacci<Element>
        )   -> Fallible<Tupleacci<Element>> {
            
            var (error) = false
            let (extra) = value.major.times(other.major).sink(&error).plus(value.minor.times(other.minor).sink(&error)).sink(&error)
            value.major = value.major.minus(value.minor).sink(&error)
            value.minor = value.minor.times(other.major).sink(&error).plus(value.major.times(other.minor).sink(&error)).sink(&error)
            value.major = extra
            return value.veto(error)
        }
    }
    
    @inlinable package static func decremented(
        _  value: consuming Indexacci<Element>,
        by other: borrowing Indexacci<Element>
    )   -> Fallible<Indexacci<Element>> {
        
        var (error) = false
        var (fails) = value.index.isNegative != other.index.isNegative
        value.index = value.index.minus(other.index).sink(&error)
        
        if !Element.isSigned {
            (fails) = error
        }
        
        value.tuple = decremented(value.tuple, by: other.tuple, index: other.index.lsb).sink(&error)
        return value.veto(fails && error)
        
        func decremented(
            _  value: consuming Tupleacci<Element>,
            by other: borrowing Tupleacci<Element>, index: Bit
        )   -> Fallible<Tupleacci<Element>> {
            
            var (error) = false
            var (((a))) = value.minor.times(other.major).sink(&error)
            var (((b))) = value.major.times(other.minor).sink(&error)
            var (((c))) = value.major.times(other.major).sink(&error)
            var (((d))) = value.major.plus (value.minor).sink(&error).times(other.minor).sink(&error)
            
            if  Bool(index) {
                Swift.swap(&a, &b)
                Swift.swap(&c, &d)
            }
            
            value.minor = a.minus(b).sink(&error)
            value.major = c.minus(d).sink(&error)
            return value.veto(error)
        }
    }
}
