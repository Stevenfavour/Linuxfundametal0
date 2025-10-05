## GitHub Actions and CI/CD -YAML

YAML is a human-readable data serialization standard used for configuration files. 
Key Concept: Identation and Key-Value pairs, lists
YAML (which stands for "YAML Ain't Markup Language") is a human-readable data serialization language that is widely used for configuration files and data exchange between programming languages.

Here is an overview of its key characteristics and uses:

### Core Concepts
Human-Readability: The primary design goal of YAML is to be easy for humans to read and write. It uses minimal punctuation and relies on a clean, visually clear structure.


Data Serialization: It provides a standardized format for representing structured data (like lists and dictionaries) in a way that is easily understandable by both humans and machines.

Structure via Indentation: Unlike formats like JSON (which use curly braces and square brackets), YAML uses Python-style whitespace and indentation to denote structure, hierarchy, and nesting. Tabs are forbidden; only spaces must be used for indentation.

Superset of JSON: YAML is considered a superset of JSON, meaning a valid JSON file can typically be parsed by a YAML parser.

Common Use Cases
YAML's readability and comment support have made it the format of choice in the DevOps and configuration management space.

Configuration Files: It is the standard format for configuration in many modern software applications.

Infrastructure as Code (IaC): Used to define and manage cloud infrastructure and application deployments.

Kubernetes: Uses YAML extensively for defining resource manifests (Pods, Deployments, Services, etc.).

Docker Compose: Uses YAML files to configure multi-container Docker applications.

Ansible: Uses YAML for writing "playbooks" which define automation and configuration management tasks.

CI/CD Pipelines: Tools like GitHub Actions and GitLab CI use YAML to define build, test, and deployment workflows.

Data Exchange: Used for cross-language data sharing, often for structured data that needs to be human-editable.

An example is this 

```
name: Example Workflow
on: [push]

```

![](/Img27/1.png)

### Workflow Structure and Components:

Workflow File: Located in .github/workflows directory, e.g., main.yml.

Jobs: Define tasks like building, testing, deploying.

Steps: Individual tasks within a job.

Actions: Reusable units of code within steps.

Events: Triggers for the workflow, e.g., push, pull_request.

Runners: The server where the job runs, e.g., ubuntu-latest.


### Setting up Build Step

#### Defining the build job: 
In the Github action workflow e.g `./github/workflow/main.yml` start by defining a job named `build`. 
This job is responsible for building your code.  

![](/Img27/7.png)

#### Adding build steps

Each step perform a specific task and here we add couple steps; installing dependecies and running the build script.

![](/Img27/8.png)

### Running tests steps in the workflow

After the build step, include steps to execute your test scripts. This is to ensure the code is not only built but also passes all neccessary steps. 

![](/Img27/3.png)

## Additional YAML concepts in GitHub Actions

### Using Environmental Variables

Environmaental variables can be defined at the workflow, job or step level. They allow you to dynamically pass congiguration and setting within the workflow. 
A good example of this is shown below. 

![](/Img27/4.png)

Below is an image showing how it cann be used in the workflow

![](/Img27/5.png)

### Working with Secrets

Secrets are encrypted variables set in the repository, could be Github repository or as an environmental varible in the Azure DevOps environment.
Ideal for storing sensitive data like keys, passwords, access tokens etc as we would not not want hardcode these data. 

![](/Img27/6.png)

### Conditional Execution

This helps control when jobs, steps or workflow run based on condition.

```
jobs:
  conditional-job:
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    # The job runs only for push events to the 'main' branch.
    steps:
    - uses: actions/checkout@v2

```

### Using Inputs and Outputs between steps 

Share data between step in a job using outputs 

```
jobs:
  example:
    runs-on: ubuntu-latest
    steps:
    - id: step-one
      run: echo "::set-output name=value::$(echo hello)"
      # Set an output named 'value' in 'step-one'.
    - id: step-two
      run: |
        echo "Received value from previous step: ${{" steps.step-one.outputs.value "}}"
        # Access the output of 'step-one' in 'step-two'.


```

* Environment variables and secrets are crucial for managing configurations and sensitive data in your CI/CD pipelines.

* Conditional execution helps tailor the workflow based on specific criteria, making your CI/CD process more efficient.

* Sharing data between steps using outputs and inputs allows for more complex workflows where the output of one step can influence or provide data to subsequent steps.

* These advanced features enhance the flexibility and security of your GitHub Actions workflows, enabling a more robust CI/CD process.


### Implementing parallel and matrix Build

The specific implementation details for parallel and matrix builds depend on your Continuous Integration/Continuous Delivery (CI/CD) platform (e.g., GitHub Actions, GitLab CI/CD), but the core concept is similar: defining a set of configurations that the CI system will automatically run in parallel as separate jobs.

Here is a general guide for the two most common platforms:

1. GitHub Actions: Using a Matrix Strategy
In GitHub Actions, you use a matrix strategy within a job definition to generate a set of parallel jobs.

Core Steps:
Define a Job: Start by defining a job within your workflow file (.github/workflows/*.yml).

Add strategy and matrix: Inside the job, add a strategy block and then a matrix key.

Define Variables: Under matrix, define one or more variables (axes) as lists of values. GitHub Actions automatically creates a unique job for every possible combination (permutation) of these values, and all these jobs run in parallel.

Reference Variables: Use the matrix variables in the job's steps or in the runs-on key using the context syntax ${{ matrix.variable_name }}.

Example (Testing on multiple OS and Node.js versions):

```
jobs:
  test_and_build:
    # Use the matrix variable 'os' to dynamically select the runner OS
    runs-on: ${{ matrix.os }} 
    
    strategy:
      matrix:
        # First axis: Operating Systems
        os: [ubuntu-latest, windows-latest, macos-latest]
        # Second axis: Node.js versions
        node-version: [18.x, 20.x, 22.x]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Set up Node ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          
      - name: Install dependencies and run tests
        run: npm install && npm test
```

This configuration creates 9 parallel jobs (3×3 combinations).

Or

```
stages:
  - build

matrix_build_job:
  stage: build
  script:
    - echo "Building for $DISTRIBUTION on $ARCH"
    - ./build.sh --dist $DISTRIBUTION --arch $ARCH

  parallel:
    matrix:
      # First axis
      - DISTRIBUTION: [rhel8, ubuntu20, alpine]
      # Second axis
        ARCH: [x64, arm64]

```

This configuration creates 6 parallel jobs (3×2 combinations).