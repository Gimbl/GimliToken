# Gimli Smart Contracts #

## 1. How to Deploy ##

## 2. Gimli Token Sale Bug Bounty ##
### 2.1 Overview ###
### 2.2 Why a bug bounty program? ###
### 2.3 Rules ###
### 2.4 Rewards ###
### 2.5 Contact ###

----------------------------------

## 1. How to Deploy ##

In order to deploy Gimli Smart Contract you need the
following software to be properly installed on your system:

1. Geth 1.6.5+ (https://geth.ethereum.org/)

Also, you need Ethereum node running on your system and synchronized with the
network.  If you do not have one, you may run it via one of the following
commands depending on whether you want to connect to PRODNET or TESTNET:

    geth
    geth --testnet

If you are running Ethereum node for the first time, you may also add "--fast"
flag to speed up initial synchronization:

    geth --fast
    geth --testnet --fast

Also you need at least one account in your node.  If you do not have any
accounts, you may create one using the following commands:

    geth attach
    > personal.newAccount ();
    > exit

It will ask you to choose passphrase and enter it twice, and it will output an
address of your new created account.

You will also need some ether on your primary account.

In order to deploy Gimli Smart Contract do the following:

1. Go to the directory containing deployment script, i.e. file named
   `deploy.js`.
2. Attach to your local Ethereum node: `geth attach`
4. Unlock your primary account:
   `personal.unlockAccount (web3.eth.accounts [0]);` (you will be
   asked for your passphrase here)
5. Run deployment script: `loadScript ("deploy.js");`
6. If everything will go fine, after several seconds you will see message like
   the following: `Deployed at ... (tx: ...)`,
   which means that your contract was deployed (message shows address of the
   contract and hash of the transaction the contract was deployed by)


## 2. Gimli Token Sale Bug Bounty ##

### 2.1 Overview ###
The Gimli Token Sale Bug Bounty provides bounties for bugs in the Token Sale contracts. This is not a bounty program for bugs in the betting, voting and donation functions of Gimli itself.

Our token sale contracts were designed and reviewed based on the [OpenZeppelin](https://openzeppelin.org/) model and can be found here on our Github.

Major bugs will be rewarded up to 50,000 GIM. Higher rewards are possible (up to 100,000 GIM) in case of very severe vulnerabilities.

### 2.2 Why a bug bounty program? ###
We at Gimli firmly believe in a decentralized tomorrow. We call on the blockchain community to help identify bugs and vulnerabilities in our code. While our contracts were designed and reviewed by experienced blockchain developers from Counterparty and others, nothing beats the wisdom of the crowd.

Our bug bounty program is modeled on the [Ethereum bug bounty program](https://bounty.ethereum.org).

### 2.3 Rules ###
Most of the rules on [https://bounty.ethereum.org](https://bounty.ethereum.org) apply:

- Issues that have already been submitted by another user or are already known to the Gimli team are not eligible for bounty rewards.
- Public disclosure of a vulnerability makes it ineligible for a bounty.
- Anyone who was a paid auditor of this code is not eligible for rewards.
- Determinations of eligibility, score and all terms related to an award are at the sole and final discretion of the Gimli team.
- The scope of the bounty includes all of the contracts on our Github.

### 2.4 Rewards ###
The value of rewards paid out will vary depending on Severity. The severity is calculated according to the [OWASP](https://www.owasp.org/index.php/OWASP_Risk_Rating_Methodology) risk rating model based on Impact and Likelihood, as used by the Ethereum bug bounty program.

![OWASP table](https://cdn-images-1.medium.com/max/800/1*lwB6Rzfck5wGqqRY-oPnQA.png)

Rewards are as follows:
- **Note:** Up to 1,000 GIM
- **Low:** Up to 5,000 GIM
- **Medium:** Up to 10,000 GIM
- **High:** Up to 50,000 GIM
- **Critical:** Up to 100,000 GIM

In addition to Severity, other variables are also considered when the Gimli team decides compensation, including (but not limited to):
- **Quality of description.** Higher rewards are paid for clear, well-written submissions.
- **Quality of reproducibility.** Please include test code, scripts and detailed instructions. The easier it is for us to reproduce and verify the vulnerability, the higher the reward.
- **Quality of fix, if included.** Higher rewards are paid for submissions with clear description of how to fix the issue.

### 2.5 Contact ###
For any questions, please join the [Gimli Slack](https://thegimliproject.slack.com/) (get your invite [here](http://auto-invite-contact.herokuapp.com/)) and join the #bug\_bounty channel.
For submissions, please send to [contact@gimli.io](mailto:contact@gimli.io). We also welcome anonymous submissions.
