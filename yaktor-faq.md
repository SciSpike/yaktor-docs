# FAQ

## Why agent and not actor?

If you're familiar with the Actor Model from Carl Hewitt, you probably recognize the similarities between our model and that of the actor model. Our `agent` is very similar to the actor model's `actor`.

So why did we not use the keyword `actor` instead of `agent`?
We've had numerous discussions around this topic. 
Basically, we concluded that there are too many differences between the original `actors` and our `agents` to merit a seperation.

Here are some of the differences:

- Agents prefer broadcast protocols (point-to-point is an exception and the receivers have no implicit knowledge of the sender).
- Agents collaborate to conclude a conversation
- Agents are always created implicitly as a result of the specification of the conversation

This is not to say that we don't credit the original Actor model for their work. 
We are clearly standing on the shoulders of giants.
Our main reason for not using the keyword `actor` is primarily the risk of confusion.

We hope the name `Yaktor` will send sufficient credit in the direction of the giants behind the actor model.

## Why can't I run your yaktor/yaktor Docker image?

The good news about our docker image is that it seems it either works perfectly or not at all.

The most common reason for problems that we've seen is that someone has an older version of Docker that doesn't work with the latest docker-compose schema.
We have tested Docker out extensively on version 1.11. 
A good first step would be to install Docker version 1.11 first and try. 
If you believe you have a good version of 1.11 running and you still have problems, let us know and we'll try to debug the problem with you.

## How to get to the time series data?

By default, we'll put it to the log at log level `silly`.
We also have middleware that will send the time series data (or the events in an event sourcing solution) to Cassandra. 

One nice way (on Mac or Linux or in Windows Powershell) to isolate the activity logs is to pipe the log through a grep for "auditLogger".

E.g., assume I started my server as:

```bash
$ yak start > logfile.txt
```

I may for instance look at the audit log by running the following in a separate process:

```bash
tail -f logfile.txt | grep auditLogger
```

## How to get to the data in Mongo?

You may run the mongo client locally if you have an IP to your mongo container.

Another way, is to use the mongo client installed in the mongo container.

Do do so, start by finding out what your container name is:

```bash
$ docker ps
```

You'll see the mongo container named `${PROJECT_NAME}-mongo`.

Next you can start the mongo client using the docker command.

```bash
$ docker exec -it ${PROJECT_NAME}-mongo mongo
```

E.g., say my project is named `test`. The command would be:

```bash
$ docker exec -it test-mongo mongo
```

You can also add the database name as a parameter if you want to start in a database.


