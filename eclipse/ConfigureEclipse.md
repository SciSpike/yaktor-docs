# Eclipse editors for Yaktor

## Introduction

This document explains how to install editors for Yaktor into Eclipse.

These editors may help you be more productive when using Yaktor. 
The editor supports features such as:

- Syntax highlighting
- Incremental parsing (allows you to see errors immediately while typing)
- Autocompletion (Try `Ctr-Space`)
- Outlines
- Clickthrough to navigate to referenced elements
- Incremental compile
- etc.

## Dowload eclipse

The first thing to do is to download a version of Eclipse that fits your need. 
Pretty much any version of Eclipse will do. 

We would recommend perhaps downloading one of the versions that supports JavaScript development.
However, you may also download any of the other versions and then extend it later.

You can find al the eclipse versions at www.eclipse.org.

## Add the Yaktor Features

Yaktor provides a set of features that can be added to a standard Eclipse tool. 
Eclipse allows us to do this through what they call an update site.

For Eclipse to find our features, you'll have to add the Yaktor Update Site to the places where Eclipse searches for features.

The way to add an update site varies slightly from platform to platform, so to make sure we're current, we suggest you simply search Google for "how to add an update site to Eclipse".

The update site for Yaktor is:

- http://yaktor.io/eclipse

We depend on another set of features that is not available in all Eclipse versions. 
If the installation of the Yaktor features should fail (usually because it can't find some XText plugins), the remedy is to add the following additional update site:

- http://download.eclipse.org/modeling/tmf/xtext/composite/releases/

## Try it out

If you succeeded to install the features, you should now be able to import one of your projects and try out the editors.

The easiest way to get started is to take one of your project and import them by using the folliwng steps:

1. Select `File --> Import`
2. Select 'Existing Projects into Workspace` and press `Next`
3. Browse to the directory where you have your Yaktor project and press `Finish`

You should now be able to open the `cl` and `dm` files using the Yaktor editors.


