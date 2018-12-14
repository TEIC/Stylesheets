# Documentation for the build_odd.xml Ant file

This file documents the components and functionality of the build_odd.xml ant file, which handles testing of ODD processing.

## Invocation
build_odd.xml is a separate file in order to provide some modularization and keep file sizes under control, but it should be invoked using the main ant file, build.xml:

`ant odd`

## ODD to RELAX NG tests

Most of the work done so far is on converting ODD to RELAX NG. The basic process works like this:

An input ODD file (for example `testPure1.odd1`) exists in the inputFiles folder. That file is included in the tests because it appears as one of the files in the build_odd.xml property `oddFileList`:

```
<property name="oddFileList" value="testSpecificationDescription.odd testPure1.odd testNonTeiOdd1.odd"/>
```

All the files in that list are processed by default. Each file goes through the following process:

- Conversion to RELAX NG (using `bin/teitoRELAX NG`). This creates the result `outputFiles/testPure1.rng`.
- Preparation of the result for diffing against expected results. This runs a range of normalization processes against the generated RELAX NG, to remove any components of the output which are processor- or occasion-dependent.
- Diffing against expected results. The expected results file is `expected-results/testPure1.rng`.
- Extraction of Schematron from the ODD file. This creates a file called `outputFiles/testPure1FromOdd.sch`.

## Testing of the RELAX NG

Generated RELAX NG files are not simply diffed against expected results; they're also tested against two TEI instance files, one of which is intended to be valid, and one of which is intended to be invalid in specific ways. These two files are named according to a convention based on the original ODD file name:

- `inputFiles/validInstances/testPure1ValidInstance.xml`
- `inputFiles/invalidInstances/testPure1InvalidInstance.xml`

Note that for a single input ODD file, we expect at most a single valid instance and a single invalid instance file. Every test ODD should have well-documented components which match up to components in the two instance files, so that features in the ODD are tested in useful ways.

If there are no such files, then nothing happens during this stage, but if instance files are found, they are processed in the following way:

- The valid instance file is validated with the newly-generated RELAX NG file (`outputFiles/testPure1.rng`). If this validation fails, the process stops with an error.

- The invalid instance file is validated against the RELAX NG file. The error messages resulting from this validation are stored in a text file in the `outputFiles` folder, again named according to convention: `testNonTeiOdd1InvalidInstanceRngMessages.txt`.
- The error message file is diffed against a file with the same name in the `expected-results` folder. If the files are different, the process stops with an error.


