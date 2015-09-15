# opstack

[![Build Status](https://travis-ci.org/OpSitters/opstack.svg)](https://travis-ci.org/OpSitters/opstack)

``opstack`` provides an easy way to switch between sets of env variables and generate chef/knife configs based on those settings

----------

## Installing OpStack ##
`gem install opstack`

##Importing an environment
``opstack env import demo demo/accounts.json`` will read the json file with your config variables and save them as an encrypted json file in the opstack config directory (~/.opstack)

##Export an environment to bash
``eval $(opstack env export demo) `` will export the environment variables for the demo enviornment

##Using the environment in a knife.rb
You can see an example knife.rb that uses opstack at https://github.com/OpSitters/opstack/blob/master/demo/knife.rb

##TODO##
Just about everything!



---------------------

