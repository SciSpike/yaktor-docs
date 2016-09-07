# Create a Domain Model

## Introduction

If you went through the tutorials sequentially, you learned about our conversation language. The conversation language defined behavior.

We also have a language that defines data structures. Data structures can be used for two things:

- To define vocabulary for messages in the conversation language
- To define a data structure to be persisted in a database technology

We'll primary focus on the latter variation.

## `dm`-files

We define our data structuress in files with the extension `dm` which is an abbreviation for domain model.

The domain models defines the following constructs:

- Entities. Definition of a set of persistent objects (similar to entities in JPA or other object-persistence technologies)
- Types. Definition of complex data structures which are used by entities
- Association. Definition of relationships (or links) between entities.
- Attributes. Properties of entities or types

## Create a simple domain model

In this simple tutorial we'll build up a domain model.

### Steps

#### 1. Create a new domain model

Start by creating a new file in your favorite editor.

Call the file `installation.dm` and place it in the root of your projedct (again, you can actually place it anywhere in your project, but we'll use the root in this example).

#### 2. Define the domain model element

A domain model starts with the keyword `domain-model` followed by the name of the domain model. The domain model is further scoped with curly braces.

E.g.:

```
domain-model Installations {

}
```

#### 3. Define your first entity

Inside the curly braces for the Installation define an entity.
Entities are denoted by the keyword `entity` followed by the name of the entity and curly braces.

E.g.:

```
domain-model Installations {

    entity Device {

    }

}
```

#### 4. Define a few Attributes

Entities can have attributes.
Attributes are named and typed properties of an entity (or a type as we'll see later).

We want to say that all devices have a name.

Here is how we do that:

```
domain-model Installations {

    entity Device {
      String name!
    }

}
```

Notice the use of a `!` (bang) after the definition of the name.
This tells us that the name is a required attribute.

Here are some annotations that specifies multiplicities of attributes:

| Syntax | Semantic |
|--------|----------|
| ! | Required (exactly 1) |
| ? | Optional (0 or 1) |
| + | At least one (1 or more) |
| * | Any number (0 or more) |

The same annotation can be used for associations as we'll see later.

We have also typed the attribute to be of type `String`.
We support a set of other attributes types such as `Numeric`, `Date`, etc.

The fact that it is a string also means that the attribute can be even more strongly typed (e.g., we could provide a regular expression pattern that it has to satisfy, specify minimum and maximum length, etc.).

#### 5. Define a type

Let's say that each device has some connection parameters such as tcp/ip address and port.
We could simply have defined those as attributes on the Device, but we believe that the grouping of those attributes provides an advantage. We could for instance define a set of connection options.

This is where a type come in handy.

```
domain-model Installations {

    type SocketConnection {
      String server!
      Integer port!
    }
    entity Device {
      String name!
      SocketConnection tcpAddress?
    }

}
```

#### 6. Define a unique identifier for the device

Let's say we want to give each Device a unique identifier.

To add the identifier we first have to define the attribute that we want to be unique.
I could use the name of course, but I think it would be good to have a unique attribute that is different from the name.

Here is how we could do that:

```
entity Device {
  ShortId id unique
  String name!
  SocketConnnection tcpAddress?
}
```

#### 7. Select MongoDB as the persistence mechanism

Next we will specify how we want the store the entities in the file.
We will select to store the devices in MongoDB.

We can specify how we want to persist the data by adding an element to the top of the domain model definition.

```
domain-model Installations {
  node-mongo {
  }
  // as before
}
```
Notice the open and close parenthesis after the `node-mongo` keyword.
This is where you would configure up various parameters.
We'll use defaults in this walkthrough.

#### 8. Generate code

Now it would have been convenient to be in an IDE with incremental compile, but we decided to do this walkthrough without an IDE, so we'll have to manually generate code.

Save the file and run the following command:

```bash
$ npm run gen-src
```

If you know Node.js and its mongoose library, you can now take a look at the following files.

#### 9. How do we test?

All we have done this far is to to define a schema for MongoDB.
To do something with this, we would have to try it out.
If you know how to use mongoose, you can obviously try it out, but we'll continue this tutorial by creating API's.

## Creating a REST service over the data structure

### Steps

#### 1. Relationship between the `cl` and `dm` files

We will build a REST API over the data structure that we've created.

The REST API is part of the behavior and hence is defined in the `cl` files.
However, we're able to use the information in the `dm` files from the `cl` files.

#### 2. Create a `cl` file

We'll start by creating a new file (we'll use the root of the project again) called `sample-api.cl`.

You can start by adding the conversation definition.

E.g:

```
conversation api {

}
```

#### 3. Define a type based derived from a domain model

When exposing a data structure to the external world, we almost always want to show a projection of the data.

The cl langauge supports such projection when defining types.

```
conversation api {
    type Device from Installations.Device {

    }
}
```
