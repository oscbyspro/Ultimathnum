//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Overflow Result
//*============================================================================*

extension Overflow {
    
    @frozen public struct Result {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        public var value: Value
        public var overflow: Bool
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        @inlinable public init(_ value: consuming Value, overflow: consuming Bool) {
            self.value = value; self.overflow = overflow
        }
        
        @inlinable public init(_ value: () throws -> Value) {
            brr: do {
                self.init(try value(), overflow: false)
            }   catch let error as Overflow<Value> {
                self.init((consume error).value, overflow: true)
            }   catch {
                fatalError("await typed throws")
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=

        @inlinable public var components: (value: Value, overflow: Bool) {
            consuming get {
                (value: self.value, overflow: self.overflow)
            }
            
            consuming set {
                (value: self.value, overflow: self.overflow) = newValue
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func resolve() throws -> Value {
            try Overflow.resolve(self.value, overflow: self.overflow)
        }
    }
}
