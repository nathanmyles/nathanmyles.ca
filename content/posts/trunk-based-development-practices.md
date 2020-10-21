+++
date = 2020-11-12T01:00:00Z
lastmod = 2020-10-12T01:00:00Z
author = "default"
title = "Trunk Based Development Practices"
subtitle = "The ways I use git to manage code"
feature = "/img/truck-based-development.png"
+++

For the last few years, I've been ditching gitflow and local feature branches almost entirely in favour of trunk-based 
development. Trunk based development is the idea that developers should work off a single branch. In Git, this is usually 
something like `master` or `dev`, depending on your organizational situation. Developers should work off this branch and 
make pull requests into it. For more information on truck based development, [this](https://trunkbaseddevelopment.com/) is 
a great resource. I've built up a set of practices that have helped make this work well for me.

## Workflows

### Rebasing

Always be [rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing). I have completely stopped merging locally. 
The only merge commits should be the merges of feature branches into the main branch (and between main branches if you have 
a couple, for say dev and production). I created a git alias to make this easy: `git up`. Here's the code you need to enter 
into your `.gitconfig` to make this work:

```
[alias]
    up = pull --rebase --autostash
```

This pulls changes from the branch you're tracking (which should be your main branch, `main`, `master`, `dev`, whatever 
it is). It stashes any uncommitted changes, rebases any commits you've made that are not in the main branch, and then 
unstashes your uncommitted changes. This makes it easy to work directly on your main branch locally. 

### Create branches when pushing changes to the remote git repository. 

This makes branches short-lived and just for review purposes. I usually push branches using the following command so that 
I can name the branch as I push it to the remote repo:

```bash
git push origin HEAD:feature/name-of-my-feature
```

This allows me to stay on the main branch most of the time. If I need to make changes to address feedback on the PR, I amend
the commit or add a follow-up commit depending on the situation. When moving onto another change while that code is in 
review, I'll reset my local branch using `git reset --hard origin/dev` to set my local branch back to what's in the main 
branch. If I need to address feedback in the previous change, I'll just pull the branch down from the remote repo, make 
the needed updates, and push it back up. When doing this, I usually set my upstream branch back to the main branch. This 
helps if I need to update the branch with changes that have been added to the main branch, I can just run `git up`. You 
can set the upstream branch of the current git branch using the following command: 

```bash
git branch --set-upstream-to=origin/dev
```

### Focus on getting pull requests merged as quickly as possible

When you have a pull request (PR) open, getting feedback addressed and the change merged should be your number one priority.
Branch lives should be as short as possible, this makes development much easier. It reduces the chances of other changes 
going into the main branch which could cause conflicts. Make sure you get your build checks passing, and let other team
members know about the review ASAP. Reviewing PRs often is important to keeping code moving from development and testing
into the main code branch and deployment as quick as possible, so the changes are available for all the other developers.

### Make small changes

Big changes are hard to review, and increase the probability of creating conflicts with other developers work. This mainly
comes down to making sure you are breaking down tasks as much as possible and ensuring that changes can be made and merged 
into the main branch without breaking functionality. Go through several steps if necessary to complete a task, making sure
the tests are passing and features are working at each step. Only make one change in each PR. Using techniques like feature 
/ release flagging is important to be able to iterate on a feature and merge in small changes without having to expose the 
feature to the users. But it's important to make sure flags are used wisely and for as short a time as possible, since they
can create branches in your code that can be hard to deal with over time. Feature flags are usually best for hiding initial 
development of an MVP, the goal should be to get to a releasable state as soon as possible and make small iterations from 
there.

## Tips and Tricks

### Use a GUI for staging commits

I use a program called [GitX](https://rowanj.github.io/gitx/) on Mac and [gitg](https://wiki.gnome.org/Apps/Gitg/) on Linux. 
The main reason I use these programs is to give me line by line control when staging and amending commits. The reason I 
like these specific programs is that they work well when amending commits, allowing me to add and remove lines from the 
commit I'm fixing up. This can be done by creating a new commit and squashing it into the existing commit (which is what 
I do when the commit I'm fixing isn't at the top of the history), but it's so much easier to use a GUI with amend functionality.

### Get REALLY comfortable with rebasing

I've mentioned it already, but rebasing is better than merging locally. When you get use to rebasing, it's easy to keep
the history clean and easy to follow. Rebasing is also a powerful tool to amend and fix up git commits / history while 
creating and updating pull requests during the code review process. Instead of having many commits for fixing linting, 
fixing tests, fixing typos, etc, you can just rewrite the commit history in the PR so that it's straight forward and clean. 
It takes a bit of practice to learn how to use the rebasing toolset to rewrite commits and history but it is definitely 
worth it.

## Conclusion

Truck based development has made a huge improvement in my development workflow. Making small changes directly to the main 
branch and getting them merged as quickly as possible has made me more productive and effective. I hope these practices can
help in your development and let me know if you have any questions! Happy coding!