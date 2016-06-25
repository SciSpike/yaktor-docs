# Installation of Yaktor using Docker

## Introduction

We've tried to minimize the tools required to run Yaktor. 
Yaktor is a rather extensive tool and it depends on a very large set of open source components.

When we've used Yaktor for different projects, it seems many developers end up in a non-predictable state where they've installed some tool the wrong way.
To minimize the number of steps, we decided to use Docker to install our dependencies + Yaktor.

In theory, that means that as long as you get Docker installed correctly, all other dependencies should take care of themselves. 

As you get more familiar with Yaktor and start to explore it on your own, you probably want to know a bit more about our dependencies, but for this document, we'll just try to focus on the installation without much justification.
It's worth knowing, however, that the steps below avoids having to explain how to install a large set of tools (MongoDB, Node.js, Grunt, Ruby, Perl, ...).

The only tools we'll ask you to install are:

- Docker
- Docker-compose

Later on, you may want to use our editor. 
This would require the installation of Eclipse and the special plug-ins that makes up the Yaktor development environment.

You may also want to experiment with your own installation of the tools running inside the Yaktor container.

## Linux description

Each of the operating systems have slight variation of how you get Docker up and running, how you configure your terminal window, etc. 
To keep this description relatively short, we've decided to either just refer to the dependent tools installation instruction and to examplify in Linux only (the platform that we verified the installation on ran Ubuntu 16.04 LTS.

## Install Docker

Go to the docker siten (https://www.docker.com) and follow the instructions to install docker.

Make sure you install the docker-engine before moving on. 

### Configure docker to allow your user to run in the docker group

### [Probably not required] Add the docker group

Docker would typically have created this group during installation, however, just to make sure, please run:

```bash
$ sudo groupadd docker
```

### Add your user to the docker group

The reason for this step is to avoid having to run Docker as the super user.

```bash
$ sudo gpasswd -a ${USER} docker
```

E.g., say my user is called yaktor:

```bash
$ sudo gpasswd -a yaktor docker
```

### Restart the docker daemon

This may be slightly different based on the version of Linux you run.

Try this first:

``` bash
sudo service docker restart
```

If that doesn't work, try this:

``` bash

sudo service docker.io restart
```

### Activate the group

```bash
$ newgrp docker
```

Note:
	You have to do this in every shell once to make docker run without the sudo command.

## Install docker-compose

Please install the latest version of docker-compose. 
At present you can find the documenation of how to do so at https://docs.docker.com/compose/.

## Install Yaktor

### Pull the yaktor docker image

When docker has been successfully installed, the installation of Yaktor is easy. 
All you have to do is:

```bash
$ docker pull yaktor/yaktor
```

This downloads and installs the docker image.

### Insert the `npm-bin` path in your shell

You have to make sure you include the path to the local and global npm bin path (if you want to be able to run the commands without providing the full path).

The completion of this step would vary based on operating system and your preferences for setup. 
Here is how it could be done on Linux...

Change the `${HOME}/.profile by adding the following:

```profile
# set the PATH for NPM if exists 
if [ -d "$HOME/.node_modules" ] ; then
    PATH="$HOME/.node_modules/.bin:$PATH"
fi

PATH="./node_modules/.bin:$PATH"
```

### [OPTIONAL] Create an alias

We run all the tools through docker. 
The command to run the tools to docker is rather verbose and you may want to setup an alias for this.
The alias could be a script file or a simple shell alias.

Here is how you may do it in Linux.

Modify the `${HOME}/.bashrc file to add this alias:

```bash
alias yaktor='docker run -it -v "$PWD":/app --rm yaktor/yaktor'
```

This will allow you to simply run `yaktor` from the command line instead of typing in the complete docker command.

## Try it out!!!

### Logon to the docker group

We've seen this step before. 
All this step does is to log you on to the docker group so that you don't have to run docker as a super user.

```bash
$ newgrp docker
```

### Create a Yaktor project

Go to the directory where you want to create the new project.

Run the command (assuming you setup the alias described above):

```bash
$ yaktor yaktor create test
```

This may take awhile the first time you run it. 
The command does a set of things and most of it is related to npm downloading the code that you need.

### Change directory to your project directory

```bash
$ cd test
```

For most steps beolow, you'll want to be in the root of your project directory.

### Run the code generators

The steps above create a simple project template.

We want to make sure it works, so we'll run the code generators.
The code generators run in the docker image.
It may take some time to get this running the first time (depending mostly on your network speed), but after that, it should be fast.

Here is the command to run:

```bash
$ yak grunt gen-src gen-views
```

This runs two grunt (see: http://gruntjs.com/):

- `gen-src` which generates the backend server code
- `gen-views` which generates the U/I code

Grunt, node, npm, and all the other tools we need are installed in the docker image we created, so no need to install those (neat, huh?).

You should see a ton of log messages from the code generator, and hopefully, it completes successfully.

### Run the server

```bash
$ yak grunt start
```

You should now see the server start up (it is actually running a set of Docker containers, but for now, let's just think of it as the server starting up).

Successful startup should end up with a log statement to the console similar to this:

```console
2016-06-24T19:18:23.352Z - info: yaktor started; DEFAULT@172.20.0.2:80
```

Take a note of the IP address (in the example above, `172.20.0.2`). We'll need this to verify that it all works in your browser.

### Verify that it all runs in your browser

Bring your browser up on the IP address from the last step. 
In the example, the IP was 172.20.0.2. 
We can then launch the browser on: 
http://172.20.0.2

Congratulations, you  have successfully installed Yaktor!!!

## Next steps

We suggest that you next start to browse the code and understand the conversation langauge of Yaktor.

[This article](YaktorInitialTemplate.md) explains the defualt project you created above.


