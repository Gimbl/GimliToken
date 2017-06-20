#!/usr/bin/env python3

import json
import os
import shutil
import tempfile

import sh

# Quik and dirty Solidity doc generator
def gen_md(contract_name):
    with open("{}.docdev".format(contract_name)) as fp:
        docdev_data = fp.read()

    with open("{}.docuser".format(contract_name)) as fp:
        docuser_data = fp.read()

    docdev = json.loads(docdev_data)
    docuser = json.loads(docuser_data)

    for method_name in docdev['methods']:
        docdev['methods'][method_name].update(docuser['methods'][method_name])

    docmd = """# {}

""".format(docdev["title"])

    for method_name, method_info in docdev['methods'].items():
        docmd += """### `{}`

""".format(method_name)

        if "notice" in method_info:

            docmd += """{}

""".format(method_info["notice"])

        if "details" in method_info:
            docmd += """{}

""".format(method_info["details"])

        if "params" in method_info:
            docmd += """**Parameters:**

"""
            for param_name, param_description in method_info["params"].items():
                docmd += """  - `{}`: {}
""".format(param_name, param_description)
            docmd += """
"""

        if "return" in method_info:
            docmd += """**Returns:**

{}

""".format(method_info["return"])

    return docmd


def gen_web3_deploy():
    with open("../abi/Gimli.abi") as fp:
        abi_data = fp.read()
    with open("../bin/Gimli.bin") as fp:
        bin_data = fp.read()

    deployjs = """var gimli_sol_gimliContract = web3.eth.contract({});
var gimli_sol_gimli = gimli_sol_gimliContract.new({{
    from: web3.eth.accounts[0],
    data: '0x{}',
    gas: '4700000'
}}, function (e, contract) {{
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {{
        console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }}
}});""".format(abi_data, bin_data)

    with open("../deploy.js", "w+") as fp:
        fp.write(deployjs)


for dirname in ["doc", "bin", "abi"]:
    shutil.rmtree(dirname)
    os.mkdir(dirname)

temp_dir = tempfile.mkdtemp()

os.chdir("sol/")

sh.solc("Gimli.sol", abi=True, overwrite=True, output_dir=temp_dir)
os.rename("{}/Gimli.abi".format(temp_dir), "../abi/Gimli.abi")

sh.solc("Gimli.sol", bin=True, overwrite=True, output_dir=temp_dir)
os.rename("{}/Gimli.bin".format(temp_dir), "../bin/Gimli.bin")

sh.solc("Gimli.sol", userdoc=True, devdoc=True, overwrite=True, output_dir=temp_dir)
os.rename("{}/Gimli.docuser".format(temp_dir), "../doc/Gimli.docuser")
os.rename("{}/Gimli.docdev".format(temp_dir), "../doc/Gimli.docdev")

with open("../doc/README.md", "w+") as fp:
    fp.write(gen_md("../doc/Gimli"))

gen_web3_deploy()

shutil.rmtree(temp_dir)
