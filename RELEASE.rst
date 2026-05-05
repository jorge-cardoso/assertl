Release
========

To generate a `.vsix` file automatically every time you commit (or push) to GitHub, you should use **GitHub Actions**. This allows you to "package" the extension in a virtual environment and either attach it to a GitHub Release or save it as an "Artifact" that you can download.

**1. Create the Workflow File**
In your GitHub repository, create a folder named `.github/workflows/` and inside it, create a file named `release.yml`.

**2. Add the Automation Code**
Paste the following code into `release.yml`. This configuration will trigger every time you push to the `main` branch, package the extension, and upload the `.vsix` file so you can download it from the GitHub Actions tab.

.. code-block:: yaml
        
    name: Generate VSIX
    on:
    push:
        branches:
        - main  # Runs every time you push to the main branch

    jobs:
    build:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout Code
            uses: actions/checkout@v4

        - name: Setup Node.js
            uses: actions/setup-node@v4
            with:
            node-version: 20

        - name: Install Dependencies
            run: npm install

        - name: Package Extension
            run: npx @vscode/vsce package -o my-extension.vsix

        - name: Upload VSIX Artifact
            uses: actions/upload-artifact@v4
            with:
            name: vscode-extension-package
            path: my-extension.vsix



### How to get your file after a commit:
1.  **Commit and Push:** Push your changes to the `main` branch.
2.  **Go to GitHub:** Open your repository in your browser.
3.  **Actions Tab:** Click on the **Actions** tab at the top.
4.  **Select Workflow:** Click on the most recent workflow run (it will likely be named "Generate VSIX").
5.  **Download:** Scroll down to the **Artifacts** section. You will see `vscode-extension-package`. Click it to download a zip containing your `.vsix` file.

---

**Pro Tip: Automating "Real" Releases**
If you want GitHub to automatically create a formal **GitHub Release** (with a version tag) and attach the `.vsix` there, you can add one more step to the bottom of the file above:

.. code-block:: yaml

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        if: startsWith(github.ref, 'refs/tags/')
        with:
          files: my-extension.vsix

*Note: This specific step will only run if you push a **tag** (e.g., `git tag v1.0.0 && git push origin v1.0.0`), which is the professional way to handle versions.*