# The Yaktor Demo Project Explained

## Introduction

In this article we'll explain the conversation contained in the default project.

## Code generators 

Yaktor provides a set of code generators.
We'll focus on a subset here. 

### gen-src

The first code generator we'll look at is `gen-src`. 

The `gen-src` command reads the Yaktor language files and generates source code from them.

If you run Yaktor using the Docker image, the command is:

```
$ yak gen-src
```

> If you decided to go the **hard** route when installing Yaktor, you may have all the Node.js and Grunt tools installed and may run the command as `grunt gen-src`.

A set of artifacts are being produced by this command. 
We'll discuss these in a different article. For now, we'll just say that this command generates:

- The Node.js code required to execute the agents' behaviors
- Visualization of the language files

Because we'll only explain the demo file in this article, we'll focus on what is generated from the `*.cl` files, AKA "conversation language" files.

### gen-views

The `gen-views` command is used to generate user interfaces.
It can be run as:

```
$ yak gen-views
```

> Again, if you're running outside the Docker container, issue command `grunt gen-views`.

## start

You can start the server after having completed the code generation commands as follows:

```
$ yak start
```

## Study the conversation language file

Use your favorite editor to open the `demo.cl` file. 

You should see a complete listing looking something like this:

```
/*
 * This is a simple demo of Yaktor.
 * The demo describes two simple agents:
 *
 * - Switch. Represents a simple switch that when receiving a command to 'flip' turns itself on or off
 * - Outlet. Represents some electrical outlet controlled by the switch
 */ 
conversation demo {

  /*
   * The Circuit is what we call a `conversation type`. 
   * Agents collaborate over the same instance of an object; here, the object is an instance of a Circuit.
   */
  type Circuit {
    String name!
  }

  /*
   * A simple switch agent
   */
  infinite agent Switch concerning Circuit {
    privately receives flip
    sends turnOn
    sends turnOff

    initially becomes off {
      on {
        flip -> off > turnOff
      }
      off {
        flip -> on > turnOn
      }
    }
  }

  /*
   * A simple electrical outlet agent
   */
  infinite agent Outlet concerning Circuit {

    initially becomes off {
      off {
        Switch.turnOn -> flowing
      }
      flowing {
        Switch.turnOff -> off
      }
    }
  }

}
```

The file above defines a Yaktor `conversation`, the top-level declaration in the file.

```
conversation demo {
// content goes here
}
```

You may also note that the conversation language allows two kinds of comments:

```
/* c-style comment */
// comment to the end of the line
```

The conversation defines a collaboration between two agents, `Switch` and `Outlet`.

Lets start by studying the agent `Switch`. 
Agents are defined with the keyword `agent`.

In our example:

```
infinite agent Switch {
  // definition of the agent
}
```

The `infinite` qualifier in front of `agent` means that this agent doesn't have an ending state; once created, we expect it to exist forever.

The `Switch` agent has two states:

- `on`
- `off`

We define these states in the `Switch` agent as follows:

```
initially becomes off {
  off { /* ... */ }
  on { /* ... */ }
}
```

The statement `initially becomes off` states that the agent will be in the `off` state
when first created (usually called the "initial" state).

The `Switch` agent changes state on the event `flip`.

Which events the agent produces and consumes are typically defined in the body of the agent. 
The agent `Switch` defines the following events:

```
privately receives flip
sends turnOn
sends turnOf
```

`privately receives` simply means that the agent (or its user-agent, like a UI) will internally
produce and consume the event; it will never be visible to other agents in the conversation.
This makes sense for `flip`, as the switch does not expect to receive this event from any other agent.
We could, for instance, imagine that we'll build a cellphone app with a button labeled `Flip`.
This cellphone app would act as a user-agent to for the agent `Switch`.

`sends` means that the agent produces an event that itself or other agents reacts to.
The switch sends two events, `turnOn` and `turnOff`.

The next thing to look at is the definition of a state. Let's look at the definition of the state `on`.

```
on {
  flip -> off > turnOff
}
```

We are using a shorthand notation here. Another way to write the same thing would be:

```
on {
  receives flip becomes off sends turnOff
}
```

In other words, we're saying "if an instance of the agent `Switch` is in the state `on` and it receives the
event `flip`, it changes state to `off` and sends the event `turnOff`".

Now, let's look at the complete agent definition again:

```
infinite agent Switch concerning Circuit {
  privately receives flip
  sends turnOn
  sends turnOff

  initially becomes off {
    on {
      flip -> off > turnOff
    }
    off {
      flip -> on > turnOn
    }
  }
}
```

A natural language description of the agent `Switch` would go something like this:

* A `Switch` is an `agent` that collaborates with other `agent`s over an instance of a `Circuit`.
* When created, it starts in the `off` state.
* The `Switch` reacts to the event `flip` and produces the events `turnOn` and `turnOff`.
* If the `Switch` receives the `flip` event when in the `on` state, it changes state to `off` and
produces the event `turnOff`.
* If the `Switch` receives the `flip` event when in the `off` state, it changes state to `on` and
produces the event `turnOn`.

The agent `Outlet`, representing an electrical outlet wired to the `Switch`, has a definition similar
 to that of agent `Switch`.
What is new is that the `Outlet` reacts to events produced by the `Switch`.
Note the following definition in the `Outlet` state:

```
off {
  Switch.turnOn -> flowing
}
```

This definition could also have been written as:

```
off {
  receives Switch.turnOn becomes flowing
}
```

What we are defining is a collaboration between two agents. 
We're saying that when the `Switch` produces the event `turnOn`, we will change our `Outlet` state to `flowing`.

## Running the sample

Let's see the conversation in action.
If you haven't already done so, we have to run the code generators and start the server.

You can do them all with this command:

```
$ yak gen-src gen-views start
```

If you're on Linux, your app should be available at `http://<appName>.yaktor`.
For example, if you named your application `test`, try `http://test.yaktor`.

If that doesn't work or you're on Mac OS X & the server comes up, it will display
the IP of the running application in the console log.
With Docker, it would typically be something like 172.x.x.x.
Without Docker, it'll probably be `http://localhost:3000`.

Next, simply open the browser on the IP with the path `/demo/test.html`,
so either `http://test.yaktor/demo/test.html` or, say, `http://172.0.20.4/demo/test.html`
if that's the IP that Docker assigned to your Yaktor container.

Now you should see an HTML form with the two agents, `Switch` and `Outlet`.

Click on the button `connect` followed by `Init All`.

You should now see two state machines, one for each agent. 
You should also be able to click on the button to `flip` the `Switch` agent with the event `flip`.

If you now see the `Outlet` change state as a result of `flip`, we have a working application!
