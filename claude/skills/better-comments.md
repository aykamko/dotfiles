I'd like you to consider all the code comments you added in this Graphite PR with a fine-toothed comb.

Look through all comments you added and consider carefully about "what would a future human or agent actually find useful about this?"

If the code is self-explanatory, it probably doesn't need a comment. Use your judgement though. For example, if we are going out of our way to do a unconventional or hacky thing, then it may deserve a comment.

You sometimes leave references to specific line numbers in your comments. This is a bad idea because the linked code could drift, causing line numbers reference to break, therefore confusing a future human or agent. You are allowed to leave a reference to a specific filepath / function / class, but please avoid line numbers.

When writing comments at the top of a file, on a class, or on a function/method: you will often include context about what happens inline. Please consider whether that detail is better placed at a lower-level. E.g. file-top comments may be inlined as class/function comments, class comments may be inlined as function comments, function comments can be inlined as inline-code comments. Top-level file, class, or function comments should be focused on the higher-level functionality. Of course, use your judgement. Sometimes it's important to call out details or a specific surprising behavior at a higher level; put yourself in the shoes of a future agent or human and use your judgement here.

Furthermore, please consider all of your comments as a whole. You tend to put the same comment in multiple places. For example, if there is a typed payload that flows from Sinatra -> protobuf -> typescript, you will annotate the fields in all 3 places (!!!). Instead, pick one of two strategies:
  - Annotate everywhere, but keep comments short (one line)
  - For larger comments, pick one canonical place to annotate and reference the file from the other places.

You will leave verbose references to previous iterations that were never committed upstream, which could be confusing to future users. Here is an rough example:
>  ```
>  master:
>   - commit0:
>     ```
>     def approach_foo():
>       ...
>     ```
>  my_local_branch:
>   - commit1:
>     ```
>     def approach_bar():
>       ...
>     ```
>   - commit2:
>     ```
>     # approach_bar was too buggy because of x,y,z so we are using approach_baz instead
>     def approach_baz():
>       ...
>     ```
>  ```
>  If `my_local_branch` were to merge into `master`, we would land it as one squashed commit. This would make the code comment confusing: future readers would only see `foo -> baz` in the git history; they would never see the full context of `foo -> bar -> baz`, because `bar` was an ephemeral during-local-development state. We should avoid doing this.

Comments _are_ useful, but there is also cognitive overload when you arrive at a huge comment block. Please consider this.

Lastly, please _only_ change comments that you specifically added or modified in this PR. If you edited a file that already existed, please _do not_ change comments that you haven't touched with this PRs changes.
