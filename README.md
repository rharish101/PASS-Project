# PASS 2021 Course Project

## Repository Structure
* The `peck` directory contains a parser that transforms a Solidity contract into an intermediate representation (IR), and derives Datalog facts that encode the contract’s IR. You must not edit any files in this folder..
* The `project` directory contains the code template for your project. Technical details on the IR and its representation in Datalog can be found in `project/README-IR.md`. The `project/test_contracts` directory contains example test contracts with annotated ground truth in comments. The `project/analyze.dl` and `project/analyze.py` are the main source files for the analysis.

## Setup Instructions
The project requires `python 3.7`, `solc 0.5.7` and `souffle 1.5.1`. On the evaluation machine, we will use python `3.7.9`. You will need the following software and library:
* Solidity: https://github.com/ethereum/solidity
* Graphviz: https://gitlab.com/graphviz/graphviz/
* Souffle: https://github.com/souffle-lang/souffle
* py-solc: https://github.com/ethereum/py-solc

Make sure you have the required executables and versions in your system’s PATH. For Solidity and Souffle, you can find specific versions under the Github release page. 
```
$ python --version
Python 3.7.9
$ solc --version
solc, the solidity compiler commandline interface
Version: 0.5.7
$ souffle --version
Souffle: 1.5.1
```

Then create a python virtual environment and install python dependencies.
```
$ python -m venv venv
$ source venv/bin/activate
$ pip install --upgrade pip
$ pip install -e .
```

## Example Usage

Try it out:
```
$ cd project
$ python analyze.py test_contracts/0.sol
Tainted
```

You can also inspect the contract’s control flow graph / Datalog representation:
```
$ python analyze.py --visualize test_contracts/0.sol
$ ls test_contract_out 
facts.pdf  graph.pdf
```
