//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Validation
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Consumes the `value` and `error` with no other effect.
    @inlinable public consuming func discard() {
        
    }
    
    /// Tries to return its `value` but returns `nil` on `error`.
    @inlinable public consuming func optional() -> Optional<Value> {
        if  self.error {
            return Optional.none
        }   else {
            return Optional.some(self.value)
        }
    }
    
    /// Tries to return its `value` but throws `error()` on `error`.
    @inlinable public consuming func prune<Error>(_ error: @autoclosure () -> Error) throws(Error) -> Value {
        if  self.error {
            throw  error()
        }   else {
            return self.value
        }
    }
    
    /// Tries to return its `value` but returns `error()` on `error`.
    @inlinable public consuming func result<Error>(_ error: @autoclosure () -> Error) -> Result<Value, Error> {
        if  self.error {
            return Result.failure(error())
        }   else {
            return Result.success(self.value)
        }
    }
    
    /// Returns the `value` by trapping on `error`.
    @discardableResult @inlinable public consuming func unwrap(
        _ message: @autoclosure () -> String = String(),
        file: StaticString = #file, line: UInt = #line
    )   -> Value {
        
        if  self.error {
            Swift.preconditionFailure(message(), file: file, line: line)
        }
        
        return self.value
    }
    
    /// Returns the `value` by trapping on `error` in debug mode.
    @discardableResult @inlinable public consuming func unchecked(
        _ message: @autoclosure () -> String = String(),
        file: StaticString = #file, line: UInt = #line
    )   -> Value {
        
        if  self.error {
            Swift.assertionFailure(message(), file: file, line: line)
        }
         
        return self.value
    }
}
