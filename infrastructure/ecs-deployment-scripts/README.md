This is a collection of scripts to aid with deploying using our ECS pipeline.

Table of Contents
- [Requirements](#requrements)
- [Script usage](#script-usage)
     - [Common override variables](#common-overrid-variables)
     - [release](#release)
     - [manage-stacks](#manage-stacks)
       - Variables
       - Usage
     - [deploy](#deploy)
       - Variables
       - Usage
- [Usage in your repository](#usage-in-your-repository)
     - [Add remote](#add-remote)
     - [Add subtree](#add-subtree)
     - [Update subtreen](#update-subtree)

#Requirements
- awscli (python client)

#Script usage

## Common override variables
The following variables are declared with sensible defaults however they can all be overridden;
- COMPONENT_NAME - ( this is defaulted to the git repo name and is used for generating all resources )

The release and deploy script rely on the amazon credentials to be in a credential file or to be declared on the command line as follows
    
    export AWS_ACCESS_KEY_ID=<ID>
    export AWS_ACCESS_SECRET_KEY=<KEY>

## release
This script is used to generate an artifact and push it to S3
It uses the `build` or `build-boot2docker script` and then the `upload script` to copy the artifact

    eg.
    ./infrastructure/ecs-deployment-scripts/release <VERSION>

## manage-stacks
This script will manage a cloudformation stack for the ECS service this is where portions like the ELB and security group attachment to the ECS cluster are declared, it does rely on the CONFIG_FOLDER being 

###Variables for manage-stacks
    CONFIG_FOLDER - ( the top level config folder for the service, defaults to ./team-config )
    PROJECT - ( this is the project tag that will be added to the stack, generally the team name )

### Example usage
    ./infrastructure/ecs-deployment-scripts/manage-stacks <ENV>

## deploy
This script will create or update an ECS service using the configuration in the CONFIG_FOLDER

###Variables for deploy 
    STACK - ( this is the cloudformation stackname, it defaults to ENV-COMPONENT_NAME)
    CONFIG_FOLDER - ( the top level config folder for the service, defaults to ./team-config )
    CONFIG_DEFAULTS - ( the global default config file, defaults to CONFIG_FOLDER/global-config/slug-defaults.jq )
    DEPLOY_TIMEOUT - ( defaults 600 seconds )
    DESIRED_COUNT - ( desired number of containers, defaults to 2 in dev and 3 in production)

### Example usage
    ./infrastructure/ecs-deployment-scripts/create-or-update-service <ENV> <VERSION> 


# Usage in your repository

It is recommended to pull this project into your project under `infrastructure/ecs-deployment-script` using git subtree:

### Add remote

So we can refer to it as simply `ecs-deployment-scripts`:

    git remote add -f ecs-deployment-scripts \
        git@github.com:mergermarket/ecs-deployment-scripts.git

### Add subtree

This pulls the code into your own repository:

    git subtree add --prefix infrastructure/ecs-deployment-scripts \
        ecs-deployment-scripts master --squash

### Update subtree

Note: if you update in a new clone, you will need to add the remote again (see "Add remote" above).

The following will output these commands in your terminal to make them easy to copy and paste:

    cat infrastructure/ecs-deployment-scripts/README.md

This code pulls updates to the code into your own repository:

    git fetch ecs-deployment-scripts master
    
    git subtree pull --prefix infrastructure/ecs-deployment-scripts \
        ecs-deployment-scripts master --squash 



