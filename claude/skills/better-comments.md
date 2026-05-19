I'd like you to consider all the code comments you added in this Graphite PR with a fine-toothed comb, and try to simplify.

Your goal is to consider all comments you added and consider carefully about "what would a future human or agent actually find useful about this?" Most notably: if the code is self-explanatory, it probably doesn't need a comment. Unless we are going out of our way to do some hacky thing.

You tend to add very verbose comments when you are writing your code, especially when iterating multiple times -- you will leave references to previous iterations that were never committed upstream, which could be confusing to future users.

You sometimes leave references to specific line numbers in your comments. This is a bad idea because the linked code could drift, so the line numbers don't add up, therefore confusing a future human or agent. You are allowed to leave a reference to a specific filepath / function / class, but please avoid line numbers.

When writing comments on the class or method, you will often include context about what happens inline. Please consider whether that detail should actually be an _inline_ comment. E.g. class comments can be inlined as function comments, function comments can be inlined as inline-code comments (where appropriate, of course). Top-level class or function comments should be focused on the higher-level functionality. Of course, sometimes it's important to call out a specific weird behavior of a function or class; put yourself in the shoes of a future agent or human and use your judgement here.

Furthermore, please consider all of your comments as a whole. You tend to put the same comment in multiple places. For example, if there is a typed payload that flows from Sinatra -> protobuf -> typescript, you will annotate the fields in all 3 places (!!!). Instead, pick one of two strategies:
  - Annotate everywhere, but keep comments short (one line)
  - For larger comments, pick one canonical place to annotate and reference the file from the other places.

Comments _are_ useful, but there is also cognitive overload when you arrive at a huge comment block. Please consider this.
