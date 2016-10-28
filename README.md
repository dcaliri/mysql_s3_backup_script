Simple script that will create a backup system for a MySQL daily backup
with upload to Amazon S3. You'll get 2 scripts: one for creating the
nightly backup on a tar.gz file and uploaded to S3 and another that will
run on a weekly basis to clean the S3 leaving just one backup per week.

# REQUIREMENTS

[aws cli](https://aws.amazon.com/cli/) installed and configured

# INSTALLATION

1. Make the setup file executable

`chmod +x setup.sh`

2. Run the setup

`./setup.sh`

3. Follow the setup's instructions

# NEXT STEPS TO IMPROVE

* Make another script to clean and leave 1 backup per month on a monthly
  basis
* Make the setup script to install python, pip and awscli
* Pimp the output of the setup script to add verbosity and colors
* Extend to other DB engines
