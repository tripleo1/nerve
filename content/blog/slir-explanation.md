+++
date = "2021-11-08T20:54:00-05:00"
draft = false
title = "Introduction to SLIR"

+++


There is a branch in git I have called pull-model.  What it's designed to do is assert the liveness of certain parts of a \[set of\] source code.  These certain parts are classes/namespaces, functions and member variables.  \[What about deciding the types of specifically member variables?\]  It's not meant to work on the inside of a function (code paths and things like that).  Specifically, it was created to create ClassInvocations and FunctionInvocations.  (As a note, FunctionInvocations existed before the creation of pull-model and ClassInvocations).  pull-model was created because I ran into a problem where ClassInvocations were needed (most likely the representation of generic constructor calls) but weren't being created and a code reorganization was necessary.

One of the problems I've been having is I've been working on this branch for a long time, for so long, in fact, that I created a branch called post-pull-model that focuses on things that are beyond the scope of pull-model.  And the scope of pull-model was defined to be something in DeduceTypes2 that specifically created a ClassInvocation (and FunctionInvocation) everywhere it was needed.

A related problem is the co-evolution of the compiler code where there is no overlap with the mandate of pull-model.  (This has led me to want to create another branch call pre-post-pull-model to house changes which would fit this.)   This inability to close the pull-model branch (and integrate it with post-pull-model and genericA) meant something was amiss.  It was a design smell.  It meant that I didn't have enough tests.  But what to test?  I didn't have anything that could easily be queried.  This led to the creation of a methodology (or framework, you choose) to test pull-model called SLIR.  SLIR stands for Source Level Internal Representation.  What it does is it records the liveness of nodes or elements or whatever the proper term is.  A Node is created by the Deduce layer, and you'll find them in GeneratedClass, GeneratedFunction and GeneratedNamespace.  By Node, I also mean the DeferredMembers that represent member variables (which haven't been deduced yet.)  By Element, I mean an \[Java level\] object that points back to the programmer's original source, basically an AST Node.  

--

pull-model is likely going to have to be extended to expressions becauase live expressions eventually point to an element, (think IdentExpression or StatementWrapper over an ProcedureCallExpression), whether that element is directly in the source or virtual (created by the compiler).  

Right now, I just have an outline of what we'll call nodes that are live, and it's actually not complete because I did not put in the dependencies of Prelude.println.  Also, one interesting thing is I have a not-live node (on paper), and I don't know how to represent that.

So, let's go into the code that I have right now.  There is a root node, then there's SourceFiles.  One thing about the RootNode is here it's attached to a compilation, so I think it's obvious that the compilation is going to play a big part in the discovery of these nodes.  You go into the compilation and you select a module by iteration or by knowing the SourceNode that you need.  Or maybe you could just pick it up by the element (or maybe even an expression).

A question is where does this go in the compiler code?  Do I attach one of these SlirNodes to each element and each expression?  As much as I don't want to change those interfaces, maybe that's the best way...  But look at everything done with DeduceTypes2 and GenereateFunctions and those two don't modify what I'm calling the parse tree.  So that's why I say with Compilation or Module (SourceNode), maybe we could have a hash table or something like that, or maybe even a mirror hierarchy.  A lot to think about.

So we have the RootNode and we have the SourceFile, and right now it's not connected to the module, and then we have the SourceNode, which at some level, represents the module.  They are not connected at this point, but they probably will be at some point int the future.  

One of the problems -- a design goal -- is the query language.  How do I find out whether something is live or not?  And that's not represented now in the test.  What is represented is just the building up of these data structures, and I have 3 TODOs.  1) "Finish function", because I haven't translated everything I have on paper to code. 2) "Refactor the sources".  This is attaching SLIR into the code, and maybe that's solved by SourceNode or maybe it is solved by extending those 2 classes OS_Element and IExpression.  Or maybe, it can be attached in the Deduce layer, where it's likely alot of the information for this will be coming from.  A related design goal I have is for the parse tree -- it should be completely immutable after creation.  So, after the parse stage (or phase) is finished, that's it -- it stays like it is.  Something else is, once I integrate post-pull-model, I want to rip out types from IExpression, because that's not being used -- a relic of DeduceTypes 1, and DeduceTypes2 has it's own way to represent the types it finds.  

One benefit to integration is it's going to create all of this information "automatically" (with greater ease that me typing all this stuff out), or at least that's the hope.  So I wanted to decide on an API and hope I get it right the first time.  And of course you have to add asserts (that's TODO #3).  After "finish function" that's the second thing I'll likely do, and I'll refactor to sources a little later, after I add the asserts for the queries, making sure that everything that's supposed to be live is live.  And this will show that pull-model is working.  

Now the funny thing about all this is that, in my mind at least, is that SLIR has no connection to either ClassInstantiation or FunctionInvocation.  (ClassInvocation is really supposed to be ClassInstantiation and ClassInvocation, ie: two separate classes but I have left them as only one in the curernt source as there is no real semantic (??) demand to keep them separate.  One is meant to represent the calling of a constructor and one is meant to represent the creation of an instance of a type, a nuanced distinction, but one that has presented no problems in the compiler source as of yet.)  

--

After adding assertions and a query language, where do you stop?  Do you stop right there or do you do ahead and manually test some of the other files (or all of them).  Of course, that's what tests are for.  This requires alot ot trial and error.  It's not really a problem, it just seems like alot of typing to do, especially if you get all greens on the first go, because it means you did all that typing for nothing.  But then again, that's what tests are for -- to get greens.

Beyond that, there's usages and the parts of the nodes that we have to check, for example in an import statement.  We are testing what we are using from each one of those imports.  Just like we test what is being used from each one of those types.  And then this extends down into conditionals like matches as well, so how can we test that?  This is a question for when SLIR is more mature and develops a code path analysis function.
