# Implementing Continuous Integration with GitHub Actions

## Code Quality Checks

We begin this module by configuring build matrices. 

Build a matrix as discussed in the previous module, allows us to run multiple versions of node builds across multiple environments.

A good demonstration of this is shown below. 

![](/Img28/12.png)

Here, we defined the workflow to build on ubuntu-latest OS and install two different versions of nodes (22.x and 20.x)

The image below verifies this.

![](/Img28/11.png)

## Managing Build Dependencies by using a Caching strategy.

Handling dependencies and services required for the build process is crucial. We utilize caching so as to reduce the time spent on downloading and installing dependencies repeatedly. 

The script below is an example of this. 

```
- name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22.x'
          cache: 'npm' # This line enables dependency caching
          
      - name: Install Dependencies, Build, and Test
        run: |
          npm ci # This command uses the cache efficiently
          # ... rest of your commands
```

How the Caching Works:
cache: 'npm': By setting the cache input to 'npm' in the actions/setup-node@v4 step, you instruct GitHub Actions to automatically cache the global npm cache directory (typically ~/.npm).

Cache Key: The setup-node action automatically generates a unique cache key based on the contents of your package-lock.json file.

Performance:

On the first run, the cache is created after the npm ci step finishes.

On subsequent runs, if the package-lock.json has not changed (i.e., you have not added or updated dependencies), the cache is restored before npm ci runs. This drastically speeds up the "Install Dependencies" step by avoiding the need to download and install packages from the registry again.

npm ci: Using npm ci (clean install) ensures that the exact versions from the lockfile are installed, which works perfectly with this caching mechanism.

![](/Img28/1.png)

The image below shows the cache 

![](/Img28/15.png)


## Integrating Code Quality Checks

Here, we will code analysis tools into the GitHub actions workflow and configure linters and static code analyzers for maintaining code quality. 

Before proceeding, we want to understand what the terms means.


* Lint	In software development, lint is the collective term for the many types of programmatic and stylistic errors, questionable constructs, and anti-patterns that static analysis tools can detect in source code. Think of "lint" as the digital fluff or fuzz in your code—minor issues that don't crash the program but can lead to bugs, poor readability, or maintenance headaches.

* Linter	A linter (or lint program) is a static code analysis tool used to flag those "lint" issues. It examines your source code without executing it. Linters check for two main things: 1. Programmatic Errors: Mistakes that could cause bugs, like using an unassigned variable, forgetting a return statement, or infinite loops. 2. Stylistic Issues: Violations of coding style rules, like improper indentation, using double quotes instead of single quotes, or unused variables.

* ESLint	ESLint is the most popular, open-source linter for JavaScript and JSX (which is used in React). It is highly configurable, allowing developers to set their own rules or use popular pre-set configurations (like those from Google, Airbnb, or Standard JS). Since your project uses Node.js, ESLint is the perfect tool for the "Code Quality Checks (Lint)" step I recommended.

To set up Lint, we need to run some configurations

First, we configure `eslint` in the project root directory. This involves installing it as a dev dependency. 

![](/Img28/3.png)

We then create a configuration file inside the root of the project's directory.

![](/Img28/13.png)

```
import js from "@eslint/js";
import globals from "globals";
import { defineConfig } from "eslint/config";

export default defineConfig([
  { files: ["**/*.{js,mjs,cjs}"], plugins: { js }, extends: ["js/recommended"], languageOptions: { globals: globals.browser } },
]);
```

Afterwards, we add a lint script to the project's package.json file. This is the cleanest way to run linters in CI

![](/Img28/4.png)

Finally, we update the workflow by separating `npm ci` into its own step to ensure dependencies are installed first.

![](/Img28/2.png)

Lets test this configuration locally.

run `npm run lint` to test locally so as to avoid failure on during execution on the remote repo.

![](/Img28/14.png)

As seen above, the test was successful. 

We can finally push the updates to GitHub.

![](/Img28/6.png)

Upon push, the workflow is automatically initiated. 

![](/Img28/10.png)


As seen above, the output shown is the result of the code quality check (linting) and it is showing that your code is failing the quality gate.

When we run `npm run lint`, the script executes ESLint, which then scans the code. Because the linter found 10 errors and issued 0 warnings, the `npm run lint` command will typically exit with a non-zero code.

If this were running in your GitHub Actions workflow (as intended), the "Run Code Quality Checks (Lint)" step would fail, and the rest of the workflow (including the deployment steps) would stop immediately.

Since it is for learning purpose and not a live production we will stop here since we have being able to verify the codes will not deploy as it has failed adherence to the set coding standards.

