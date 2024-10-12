//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Swift x Optional
//*============================================================================*

extension Optional: BitCastable where Wrapped: BitCastable {
    
    public typealias BitPattern = Optional<Wrapped.BitPattern>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        if  let source {
            self.init(Wrapped(raw: source))
        }   else {
            self = nil
        }
    }
    
    @inlinable public func load(as type: BitPattern.Type) -> BitPattern {
        if  let self {
            return self.load(as: Wrapped.BitPattern.self)
        }   else {
            return nil
        }
    }
    
    //=----------------------------------------------------------------------------=
    // MARK: Utilities
    //=----------------------------------------------------------------------------=
    
    /// Returns the `value` by trapping on `nil`.
    @discardableResult @inlinable public consuming func unwrap(
        _ message: @autoclosure () -> String = String(),
        file: StaticString = #file, line: UInt = #line
    )   -> Wrapped {
        
        if  self == nil {
            Swift.preconditionFailure(message(), file: file, line: line)
        }
        
        return self.unsafelyUnwrapped
    }
    
    /// Returns the `value` by trapping on `nil` in debug mode.
    @discardableResult @inlinable public consuming func unchecked(
        _ message: @autoclosure () -> String = String(),
        file: StaticString = #file, line: UInt = #line
    )   -> Wrapped {
        
        #if DEBUG
        return self.unwrap(message(), file: file, line: line)
        #else
        return self.unsafelyUnwrapped
        #endif
    }
}
