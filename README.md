# Pipeline Test Project

This project demonstrates a simple CI/CD pipeline with build and verification scripts.

## Scripts

### `build.sh`
- Builds the project and creates artifacts
- Generates build information and manifest files
- Creates a `build/` directory with output files

### `verification.sh`
- Verifies build artifacts exist and are valid
- Runs simulated tests
- Checks build status and displays summary

## Usage

1. Run the build script:
   ```bash
   ./build.sh
   ```

2. Run the verification script:
   ```bash
   ./verification.sh
   ```

3. Or run the complete pipeline:
   ```bash
   ./build.sh && ./verification.sh
   ```

## Output

The build process creates:
- `build/build-info.txt` - Build metadata
- `build/manifest.json` - Build manifest with status and version info
// Minor changes
