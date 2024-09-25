//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit2

//*============================================================================*
// MARK: * Divider x Validation
//*============================================================================*

@Suite struct DividerTestsOnValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Divider.init(exactly:) - load each I8", arguments: systemsIntegersWhereIsUnsigned)
    func initForEachSignedByteEntropy(_ type: any SystemsIntegerWhereIsUnsigned.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for divisor in I8.all.lazy.map(T.init(load:)) {
                if !divisor.isZero {
                    #expect(Divider(divisor           ) .divisor == divisor)
                    #expect(Divider(unchecked: divisor) .divisor == divisor)
                    #expect(Divider(exactly:   divisor)?.divisor == divisor)
                    #expect(try Divider(divisor, prune: Bad.error).divisor == divisor)
                }   else {
                    #expect(Divider(exactly: divisor) == nil)
                    #expect(throws: Bad.error) {
                        try Divider(divisor, prune: Bad.error)
                    }
                }
            }
        }
    }
    
    @Test("Divider21.init(exactly:) - load each I8", arguments: systemsIntegersWhereIsUnsigned)
    func initForEachSignedByteEntropy21(_ type: any SystemsIntegerWhereIsUnsigned.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for divisor in I8.all.lazy.map(T.init(load:)) {
                if !divisor.isZero {
                    #expect(Divider21(divisor           ) .divisor == divisor)
                    #expect(Divider21(unchecked: divisor) .divisor == divisor)
                    #expect(Divider21(exactly:   divisor)?.divisor == divisor)
                    #expect(try Divider21(divisor, prune: Bad.error).divisor == divisor)
                }   else {
                    #expect(Divider21(exactly: divisor) == nil)
                    #expect(throws: Bad.error) {
                        try Divider21(divisor, prune: Bad.error)
                    }
                }
            }
        }
    }
}
