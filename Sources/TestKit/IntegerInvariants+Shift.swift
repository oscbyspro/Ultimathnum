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
// MARK: * Integer Invariants x Shift
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utiliteis
    //=------------------------------------------------------------------------=
    
    /// - TODO: deduplicate binary/systems integer versions
    /// - TODO: upshiftRepeatingBitForEachCoreSystemsInteger
    public func upshiftRepeatingBit() {
        always: do {
            test.upshift(T(repeating: 0), ~1 as T, T(repeating: 0))
            test.upshift(T(repeating: 0), ~0 as T, T(repeating: 0))
            test.upshift(T(repeating: 0),  0 as T, T(repeating: 0))
            test.upshift(T(repeating: 0),  1 as T, T(repeating: 0))
            test.upshift(T(repeating: 0),  2 as T, T(repeating: 0))
            
            test.upshift(T(repeating: 0),  Self.minEsque, T(repeating: 0))
            test.upshift(T(repeating: 0),  Self.maxEsque, T(repeating: 0))
            test.upshift(T(repeating: 1),  Self.minEsque, T(repeating: 1))
        }
        
        if  T.isSigned {
            test.upshift(T(repeating: 1), ~1 as T, T(repeating: 1))
            test.upshift(T(repeating: 1), ~0 as T, T(repeating: 1))
            test.upshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.upshift(T(repeating: 1),  1 as T, T(repeating: 1) * 2)
            test.upshift(T(repeating: 1),  2 as T, T(repeating: 1) * 4)
        }   else {
            test.upshift(T(repeating: 1), ~1 as T, T(repeating: 0))
            test.upshift(T(repeating: 1), ~0 as T, T(repeating: 0))
            test.upshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.upshift(T(repeating: 1),  1 as T, T(repeating: 1) - 1)
            test.upshift(T(repeating: 1),  2 as T, T(repeating: 1) - 3)
        }
        
        if !T.size.isInfinite {
            test.upshift(T(repeating: 1),  Self.maxEsque, T(repeating: 0))
        }
    }
    
    /// - TODO: deduplicate binary/systems integer versions
    /// - TODO: upshiftRepeatingBitForEachCoreSystemsInteger
    public func upshiftRepeatingBit() where T: SystemsInteger {
        always: do {
            test.upshift(T(repeating: 0), ~1 as T, T(repeating: 0))
            test.upshift(T(repeating: 0), ~0 as T, T(repeating: 0))
            test.upshift(T(repeating: 0),  0 as T, T(repeating: 0))
            test.upshift(T(repeating: 0),  1 as T, T(repeating: 0))
            test.upshift(T(repeating: 0),  2 as T, T(repeating: 0))
            
            test.upshift(T(repeating: 0),  Self.minEsque, T(repeating: 0))
            test.upshift(T(repeating: 0),  Self.maxEsque, T(repeating: 0))
            test.upshift(T(repeating: 1),  Self.minEsque, T(repeating: 1))
        }
        
        if  T.isSigned {
            test.upshift(T(repeating: 1), ~1 as T, T(repeating: 1))
            test.upshift(T(repeating: 1), ~0 as T, T(repeating: 1))
            test.upshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.upshift(T(repeating: 1),  1 as T, T(repeating: 1) * 2)
            test.upshift(T(repeating: 1),  2 as T, T(repeating: 1) * 4)
        }   else {
            test.upshift(T(repeating: 1), ~1 as T, T(repeating: 0))
            test.upshift(T(repeating: 1), ~0 as T, T(repeating: 0))
            test.upshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.upshift(T(repeating: 1),  1 as T, T(repeating: 1) - 1)
            test.upshift(T(repeating: 1),  2 as T, T(repeating: 1) - 3)
        }
        
        if !T.size.isInfinite {
            test.upshift(T(repeating: 1),  Self.maxEsque, T(repeating: 0))
        }
    }
    
    /// - TODO: deduplicate binary/systems integer versions
    /// - TODO: downshiftRepeatingBitForEachCoreSystemsInteger
    public func downshiftRepeatingBit() {
        always: do {
            test.downshift(T(repeating: 0), ~1 as T, T(repeating: 0))
            test.downshift(T(repeating: 0), ~0 as T, T(repeating: 0))
            test.downshift(T(repeating: 0),  0 as T, T(repeating: 0))
            test.downshift(T(repeating: 0),  1 as T, T(repeating: 0))
            test.downshift(T(repeating: 0),  2 as T, T(repeating: 0))
            
            test.downshift(T(repeating: 0),  Self.minEsque, T(repeating: 0))
            test.downshift(T(repeating: 0),  Self.maxEsque, T(repeating: 0))
        }
        
        if  T.isSigned {
            test.downshift(T(repeating: 1), ~1 as T, T(repeating: 1) * 4)
            test.downshift(T(repeating: 1), ~0 as T, T(repeating: 1) * 2)
            test.downshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  1 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  2 as T, T(repeating: 1))
            
        }   else if T.size.isInfinite {
            test.downshift(T(repeating: 1), ~1 as T, T(repeating: 1))
            test.downshift(T(repeating: 1), ~0 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  1 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  2 as T, T(repeating: 1))
            
        }   else {
            test.downshift(T(repeating: 1), ~1 as T, T(repeating: 0))
            test.downshift(T(repeating: 1), ~0 as T, T(repeating: 0))
            test.downshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  1 as T, T(repeating: 1) / 2)
            test.downshift(T(repeating: 1),  2 as T, T(repeating: 1) / 4)
        }
        
        if  T.isSigned || T.size.isInfinite {
            test.downshift(T(repeating: 1),  Self.maxEsque, T(repeating: 1))
        }   else {
            test.downshift(T(repeating: 1),  Self.maxEsque, T(repeating: 0))
        }
    }
    
    /// - TODO: deduplicate binary/systems integer versions
    /// - TODO: downshiftRepeatingBitForEachCoreSystemsInteger
    public func downshiftRepeatingBit() where T: SystemsInteger {
        always: do {
            test.downshift(T(repeating: 0), ~1 as T, T(repeating: 0))
            test.downshift(T(repeating: 0), ~0 as T, T(repeating: 0))
            test.downshift(T(repeating: 0),  0 as T, T(repeating: 0))
            test.downshift(T(repeating: 0),  1 as T, T(repeating: 0))
            test.downshift(T(repeating: 0),  2 as T, T(repeating: 0))
            
            test.downshift(T(repeating: 0),  Self.minEsque, T(repeating: 0))
            test.downshift(T(repeating: 0),  Self.maxEsque, T(repeating: 0))
        }
        
        if  T.isSigned {
            test.downshift(T(repeating: 1), ~1 as T, T(repeating: 1) * 4)
            test.downshift(T(repeating: 1), ~0 as T, T(repeating: 1) * 2)
            test.downshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  1 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  2 as T, T(repeating: 1))
            
        }   else if T.size.isInfinite {
            test.downshift(T(repeating: 1), ~1 as T, T(repeating: 1))
            test.downshift(T(repeating: 1), ~0 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  1 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  2 as T, T(repeating: 1))
            
        }   else {
            test.downshift(T(repeating: 1), ~1 as T, T(repeating: 0))
            test.downshift(T(repeating: 1), ~0 as T, T(repeating: 0))
            test.downshift(T(repeating: 1),  0 as T, T(repeating: 1))
            test.downshift(T(repeating: 1),  1 as T, T(repeating: 1) / 2)
            test.downshift(T(repeating: 1),  2 as T, T(repeating: 1) / 4)
        }
        
        if  T.isSigned || T.size.isInfinite {
            test.downshift(T(repeating: 1),  Self.maxEsque, T(repeating: 1))
        }   else {
            test.downshift(T(repeating: 1),  Self.maxEsque, T(repeating: 0))
        }
    }
}
