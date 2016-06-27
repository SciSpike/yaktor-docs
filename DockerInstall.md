# Installation of Yaktor using Docker

## Introduction

We've tried to minimize the tools required to run Yaktor.
Yaktor is a rather extensive tool and it depends on a very large set of open source components.

When we've used Yaktor for different projects, many developers end up in a unpredictable state where they've installed some dependency the wrong way.
To minimize the number of steps, we decided to use Docker to install our dependencies along with Yaktor.

In theory, that means that as long as you get Docker installed correctly, all other dependencies should take care of themselves.

As you get more familiar with Yaktor and start to explore it on your own, you probably want to know a bit more about our dependencies, but for this document, we'll just try to focus on the installation without much justification.
It's worth knowing, however, that the steps below avoid our having to explain how to install a large set of tools (MongoDB, Node.js, Grunt, Ruby, Perl, ...).

The only tools we'll ask you to install are:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

Later on, you may want to use our eclipse-based editor.
This would require the installation of eclipse and the special plug-ins that makes up the Yaktor development environment.

You may also want to experiment with your own installation of the tools running inside the Yaktor container.

## Linux description

Each of the operating systems and command shells have slight variation of how you get Docker up and running, how you configure your terminal window, etc.
To keep this description relatively short, we've decided to either just refer to the dependent tools installation instruction and to give examples for Linux (the platform that we verified the installation on ran Ubuntu 16.04 LTS) and bash.

## Install Docker 1.11 (not 1.12!)

Install [Docker 1.11 for Mac](https://docs.docker.com/v1.11/mac/), [Docker 1.11 for Windows](https://docs.docker.com/v1.11/windows/), or [Docker 1.11 for Linux](https://docs.docker.com/v1.11/linux/), accoding to your platform.

On Mac, we've also tested Docker with [DLite 1.1.5](https://github.com/nlf/dlite), but these instructions are not written for it.  If you're using DLite, then you probably already know what you're doing and can adjust accordingly.

> NOTE: we have _not_ tested Yaktor with the impending Docker 1.12 for [Linux](https://docs.docker.com/engine/installation/linux/) or the new, native distributions [Mac](https://docs.docker.com/docker-for-mac/) or [Windows](https://docs.docker.com/docker-for-windows/), which are in beta at the time of this writing.

### Configure docker to allow your user to run in the docker group

#### [Probably not required] Add the docker group

Docker would typically have created this group during installation, however, just to make sure, please run:

```bash
$ sudo groupadd docker
```

#### Add your user to the docker group

The reason for this step is to avoid having to run Docker as the super user.

```bash
$ sudo gpasswd -a ${USER} docker
```

E.g., say my user is called yaktor:

```bash
$ sudo gpasswd -a yaktor docker
```

#### Restart the docker daemon

This may be slightly different based on the version of Linux you run.

Try this first:

``` bash
sudo service docker restart
```

If that doesn't work, try this:

``` bash
sudo service docker.io restart
```

#### Activate the group

```bash
$ newgrp docker
```

Note:
	You have to do this in every shell once to make docker run without the sudo command.

## Install docker-compose

Ensure `docker-compose` is installed.  If you installed Docker Toolbox for Linux, Mac or Windows, then it already is.
Otherwise, make sure you install it.
You can verify that it's installed and on your path by simply issuing the command `docker-compose` in your shell.
If it is, you'll see the usage/help message from `docker-compose`.

## Install Yaktor

Since we're using Docker, there's acutally not much you have to do to install Yaktor!

### [OPTIONAL] Create an alias

We run all the tools through Docker.
The command to create Yaktor applications is rather verbose and you may want to setup an alias for this.
The alias could be a script file or a simple shell alias.

Here is how you may do it in Linux.

Create this alias (or modify your `~/.bashrc`, `~/.bash_profile` or `~/.profile` to make it permanent):

```bash
alias yaktor-create='docker run -it -v "$PWD":/app --rm yaktor/yaktor yaktor create'
```

This will allow you to simply run `yaktor-create` from the command line instead of typing in the complete docker command.
It is only needed when creating a new Yaktor application.

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
$ yaktor-create test
```

This may take awhile the first time you run it.
The command does a set of things and most of it is related to npm downloading the code that you need.

### Change directory to your project directory

For the steps below, you'll want to be in the root of your project directory.

```bash
$ cd test
```

### Add your project's npm `.bin` directory to your `PATH`

You have to make sure you include in your `PATH` the path to the local npm `.bin` path.
The completion of this step would vary based on operating system and your preferences for setup.
Here is how it could be done on Linux.

To make this so just for your current shell, issue the following command

```bash
PATH="./node_modules/.bin:$PATH"
```

To do it for all shells, edit your `~/.bashrc`, `~/.bash_profile`, or `~/.profile` by adding the following:

```bash
# prepend the project-local npm bin to PATH
PATH="./node_modules/.bin:$PATH"
```

### Run the code generators

The steps above created a simple Yaktor project.

> NOTE: the primary means of interacting with a Yaktor is via its command script, `yak`.
> If you prepended `./node_modules/.bin` to your `PATH`, then that's all you'll have to type.
> Otherwise, you'll need to use `./node_modules/.bin/yak`.

We want to make sure it works, so we'll run the code generators.
The code generators run in the docker image.
There may be a slight delay running this for the first time (depending on your connection speed), but
after that, it will be faster.
Run the following command.

```bash
$ yak gen-src gen-views
```

This runs two commands:

- `gen-src` which generates the backend server code
- `gen-views` which generates the U/I code

You should see a log messages from the code generator, followed by a successful completion message.

### Run the server

```bash
$ yak start
```

You should now see the server start up.

> NOTE: `docker-compose` is actually running a set of Docker containers, but for now, let's just think of it as your Yaktor application starting up.

Successful startup should end up with a log statement to the console similar to this:

```console
2016-06-27T16:14:23.048Z - info: server DEFAULT listening at http://localhost (ip 172.27.0.4)
2016-06-27T16:14:23.078Z - silly: gathering modules from /app/conversations/js
2016-06-27T16:14:23.150Z - silly: loading conversation test
2016-06-27T16:14:23.153Z - info: yaktor started ok
```

Take a note of the IP address (in the example above, `172.20.0.4`). We'll need this to verify that it all works in your browser.

### Verify that it all runs in your browser

Bring your browser up on the IP address from the last step.
In the example, the IP was 172.20.0.4.
We can then launch the browser on:
http://172.20.0.4

Congratulations, you have successfully installed Yaktor!!!

## Next steps

We suggest that you next start to browse the code and understand the conversation language of Yaktor.

[This article](YaktorInitialTemplate.md) explains the default project you created above.
