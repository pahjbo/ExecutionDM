Product Requirements Document (PRD)
==================================


##  Vision and Problem Statement

With modern scientific instruments producing increasingly large and complex datasets, it is often better from an overall
resource usage point of view to move the compute to the data, rather than move the data to the compute. In general the Virtual Observatory (VO) has focussed on defining some useful API-level patterns for accessing data (i.e. moving data to the compute). The paradigm of moving the compute to the data is less well supported by current VO standards, and there is a need for a reusable data model that can drive API and service definitions for computational execution in the VO context.

The assertion of this project is that a data-model-first approach to defining execution semantics and the processing environment will allow for more comprehensive ecosystem of APIs and services to be defined, as the underlying data model will provide a "big picture" view of that environment.

The resulting system should free the scientist from having to worry about the details of orchestrating data in the execution environment, and allow them to focus on the scientific problem at hand. From the system providers point of view, it should also allow for more efficient use of resources, as the system can optimise the execution of tasks based on the available resources and the requirements of the tasks.

## Goals

- Define a VO-DML-based execution data model for computational task execution in the Virtual Observatory context.
- Prioritise batch job execution semantics over interactive session semantics in the initial scope.
- Support efficient, scalable execution in distributed/containerized environments.
- Keep execution internals opaque (black-box container approach) and model only required inputs, outputs, and execution context.
- Enable downstream derivation of APIs/services from a stable, evolvable data model.

##  Non-Goals (Initial Scope)

- Interactive sessions. 
- Resource booking and reservation workflows.
- Deep interoperability mapping to ExecutionBroker in this phase.
- Standardising internal behaviour of software inside containers.

##  Context and References

ExecutionDM is informed by:

- AstroGrid CEA: <https://www.ivoa.net/Documents/Notes/CEA/CEADesignIVOANote-20050513.html>
- UWS: <https://www.ivoa.net/documents/UWS/>
- IVOA PDL: <https://www.ivoa.net/documents/PDL/>
- ExecutionBroker: <https://github.com/ivoa-std/ExecutionBroker>
- PanDA <https://panda-wms.readthedocs.io/en/latest/
- OpenCADC Library Tools: <http://www.opencadc.org/library-tools/>

## Users, Personas and Stakeholders

- **The Researcher**: Wants to run a heavy data-processing script on a remote cluster and be notified when the results are ready.
- **The Service Provider**: Wants to offer computing cycles (e.g., a Kubernetes cluster or a Slurm-managed HPC) to the VO community without writing custom wrappers for every possible application.
- **The Workflow Developer**: Needs a stable API to chain multiple non-interactive jobs together.
- **The Standards Contributor**: Wants to define a clear, implementable data model that can drive interoperable execution services in the VO.


## Product Scope

In scope for this PRD version:

- Model concepts needed to describe batch computational task execution.
- Model concepts supporting resource matching - The system shall match a job’s requirements (RAM, CPU, GPU, storage requirements) against a registry of available "Execution Platforms."
- Model constructs for execution inputs, outputs, and runtime environment metadata.
    - inputs and outputs to use a "data locator" metadata concept.
- Container-first deployment assumptions (for example Docker/Kubernetes-backed platforms) without platform lock-in.
- Documentation and schema artefacts that support implementation.

Out of scope for this PRD version:

- End-user UX requirements for interactive tools.
- Reservation-based scheduling economics or policy negotiation.
- Full broker-to-ExecutionDM semantic crosswalk.

##  Risks and Assumptions

Assumptions:

- Containerized execution patterns will remain the dominant deployment model for target adopters.
- A model-first approach will reduce long-term API evolution cost.

Risks:

- Under-specification in early model versions may delay interoperable implementation.
- Delayed broker compatibility analysis may defer some integration use cases.


## Requirements Overview
This section outlines the key functional and technical requirements for the ExecutionDM project, derived from the goals and scope defined above. Traceable specific requirements are detailed in the [requirements-detail.md](./design-log/requirements-detail.md) document, but this overview provides a high-level summary of the expected capabilities and constraints of the system.

###  Functional Requirements

####  Brokerage & Discovery (IEB Core)
The system must act as a middleman between the user and the available compute resources.

* **Resource Matching:** The system shall match a job’s requirements (RAM, CPU, GPU, software dependencies) against a registry of available "Execution Platforms."
* **Dynamic Capability Discovery:** Instead of static WSDL files, the system shall query platforms for their current load, available "slots," and supported runtimes

####  Non-Interactive Job Management
Borrowed from the IVOA UWS ideas, the focus is on "fire-and-forget" workflows.

* **Asynchronous Execution:** All jobs are asynchronous by default. The system must support `PENDING`, `RUNNING`, `COMPLETED`, and `ERROR` states.
* **Input/Output Staging:**

    - Support for **VOSpace** and **S3** URIs for input data.
    - Automatic "push-back" of results to a user-specified storage location upon completion.

* **Persistent Job Tokens:** Users should be able to disconnect and return days later to retrieve results using a unique Job ID.

####  The "Executable Thing" Model
Moving beyond the custom "wrapped application" model of CEA: Support tooling similar to [OpenCADC Library Tools](http://www.opencadc.org/library-tools/) where users can package their code and dependencies into a standard container image, and then submit that image for approval in the execution environment. There will be a set of base images provided by the execution environment, and users can build on top of those to create their own custom images. 

The runtime environment is described in more detail in the [runtimeEnvironment.md](./runtimeEnvironment.md) document, but the key point is that the system will treat the execution environment as a "black box" and will only be concerned with the inputs and outputs of the "black box". This allows for a more flexible and extensible system, as it does not need to be concerned with the details of how the execution environment is implemented, and it also allows for a more secure execution environment, as the system does not need to have access to any files that it should not have access to.

###  Technical Requirements & Architecture

#### API Architecture
* **RESTful Interface:** The system must implement an **OpenAPI 3.0** compliant interface (replacing CEA’s SOAP/XML).
* **UWS Compliance:** The job management lifecycle will be the **IVOA Universal Worker Service (UWS 1.1)** pattern. However the intention is to modernise the API design and not be constrained by the original UWS XML schema (creating a possible candidate for UWS 2.0).

####  Security & Authentication
* **Identity Federation:** Integration with **OpenID Connect (OIDC)** and **OAuth2**.
* **Credential Delegation:** The system must securely delegate the user's credentials to the execution platform so it can access private data on the user's behalf.

###  Non-Functional Requirements
* **Scalability:** The Broker should handle at least 1,000 concurrent job states without degradation.
* **Interoperability:** The system must be able to discover execution platforms ( via the **IVOA Registry (RegTAP)**?).
* **Extensibility:** New execution backends (e.g., AWS Lambda, Google Batch, local Slurm) should be addable via a standard driver interface.


##  Success Metrics
1.  **Time-to-Execution:** Reduction in time spent by a researcher "wrapping" a script for the VO from hours to minutes.
2.  **Resource Utilization:** Percentage of available computing time across the federated network successfully brokered.
3.  **Portability:** Ability to run the same "executable thing" on three different hardware providers without modifying the code.
4. **Adoption:** Number of unique users and institutions using the system within the first year of release.


##  Future Considerations

* **Interactive Sessions:** Future versions may include support for interactive sessions (e.g., Jupyter notebooks). 
