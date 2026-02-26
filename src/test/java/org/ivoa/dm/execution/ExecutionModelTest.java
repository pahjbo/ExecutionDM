package org.ivoa.dm.execution;
/*
 * Created on 10/05/2023 by Paul Harrison (paul.harrison@manchester.ac.uk).
 */

import org.ivoa.vodml.testing.AutoRoundTripWithValidationTest;

/**
 * This will run a XML and JSON round trip test on the model inst
 */
public class ExecutionModelTest extends AutoRoundTripWithValidationTest<ExecutionModel> {
    @Override
    public ExecutionModel createModel() {
        // create the model instance here.
        ExecutionModel retval = new ExecutionModel();

        Another another = new Another("test");
        retval.addContent(another);
        return retval;
    }

    @Override
    public void testModel(ExecutionModel executionModel) {
        //this could do specialized testing on the model instance
    }
}
