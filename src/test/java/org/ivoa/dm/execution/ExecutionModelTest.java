package org.ivoa.dm.execution;
/*
 * Created on 10/05/2023 by Paul Harrison (paul.harrison@manchester.ac.uk).
 */

import org.ivoa.dm.tool.Author;
import org.ivoa.vodml.testing.AutoRoundTripWithValidationTest;

import java.util.List;

/**
 * This will run an XML and JSON round trip test on the model inst
 */
public class ExecutionModelTest extends AutoRoundTripWithValidationTest<ExecutionModel> {
    @Override
    public ExecutionModel createModel() {
        // create the model instance here.
        ExecutionModel retval = new ExecutionModel();
        Author author = Author.createAuthor(a -> {
            a.name = "Paul Harrison";
            a.email = "paul.harrison@manchester.ac.uk";
            a.github = "pahjbo";
        });
        
        PhysicalLocation jbo = new PhysicalLocation("JBO", "UK", 53.2361, +2.3056);
        PhysicalLocation cam = new PhysicalLocation("Cambridge", "UK", 52.20, -0.13);

        ComputeResource small = ComputeResource.createComputeResource(n -> {
            n.name = "Small Compute Resource";
            n.memory = 4.0;
            n.numberOfCores = 2;
        });
        ComputeResource medium = ComputeResource.createComputeResource(n -> {
            n.name = "Medium Compute Resource";
            n.memory = 8.0;
            n.numberOfCores = 4;
        });
        ComputeResource large = ComputeResource.createComputeResource(n -> {
            n.name = "Large Compute Resource";
            n.memory = 16.0;
            n.numberOfCores = 15;
            n.gpu = true;
        });

        ExecutionNode jboNode = ExecutionNode.createExecutionNode(n -> {
            n.name = "JBO Node";
            n.location =    jbo;
            n.computeResources = List.of(small, medium, large);
        });

        ExecutionNode camNode = ExecutionNode.createExecutionNode(n -> {
            n.name = "Cam Node";
            n.location =    cam;
            n.computeResources = List.of(small, medium);

        });
        return retval;
    }

    @Override
    public void testModel(ExecutionModel executionModel) {
        //this could do specialized testing on the model instance
    }
}
