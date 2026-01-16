### Changelog 1.0.6

[](#changelog-106)

- Plugin loads faster on start up

### Changelog 1.0.5

[](#changelog-105)

- Added option to automatically sync on start up if behind remote
- Added "Sync with Remote" command to command palette

### Changelog 1.0.4

[](#changelog-104)

- Simplified setup process.
- Allow SSH url for remote.

[![](https://camo.githubusercontent.com/8b3eaad21442fed6d978bd9e1ca985845a7cfcd33a7d79af3c197166e45909ae/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f64796e616d69632f6a736f6e3f6c6f676f3d6f6273696469616e26636f6c6f723d253233343833363939266c6162656c3d646f776e6c6f6164732671756572793d2532342535422532326769746875622d73796e632532322535442e646f776e6c6f6164732675726c3d68747470732533412532462532467261772e67697468756275736572636f6e74656e742e636f6d2532466f6273696469616e6d642532466f6273696469616e2d72656c65617365732532466d6173746572253246636f6d6d756e6974792d706c7567696e2d73746174732e6a736f6e)](https://camo.githubusercontent.com/8b3eaad21442fed6d978bd9e1ca985845a7cfcd33a7d79af3c197166e45909ae/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f64796e616d69632f6a736f6e3f6c6f676f3d6f6273696469616e26636f6c6f723d253233343833363939266c6162656c3d646f776e6c6f6164732671756572793d2532342535422532326769746875622d73796e632532322535442e646f776e6c6f6164732675726c3d68747470732533412532462532467261772e67697468756275736572636f6e74656e742e636f6d2532466f6273696469616e6d642532466f6273696469616e2d72656c65617365732532466d6173746572253246636f6d6d756e6974792d706c7567696e2d73746174732e6a736f6e)

Simple plugin that allows you to sync your vault to a personal GitHub repo for **syncing across devices**.

[![](https://github.com/kevinmkchin/Obsidian-GitHub-Sync/raw/main/screenshots/ribbon-button.png)](https://github.com/kevinmkchin/Obsidian-GitHub-Sync/blob/main/screenshots/ribbon-button.png)

## How to Use

[](#how-to-use)

Click the **Sync with Remote** ribbon icon to pull changes from your GitHub repo and push local changes. If there are any conflicts, the unmerged files will be opened for you to resolve (or just push again with the unresolved conflicts - that should work too).

## Setup

[](#setup)

### Setting up a GitHub repo

[](#setting-up-a-github-repo)

If your vault is already set up as a GitHub repository, you can skip this step. Otherwise, create a new public or private GitHub repository that you want to use for your vault.

Navigate to your vault and `git init` the folder. At this point, add anything you don't want syncing across your devices to a `.gitignore`.

This is not required, but you should try pushing your vault to your GitHub repository before continuing to make sure you can do that in the first place before using this plugin:

```
git add .
git commit -m "my obsidian vault first commit"
git branch -M main
git remote add origin <remote-url>
git push -u origin main
```

Verify that this works before continuing.

> For simplicity, this plugin does not support branching. Everything gets pushed to main.

### Setting up remote URL

[](#setting-up-remote-url)

All this plugin needs now is your GitHub repo's remote URL. You can grab this from the GitHub repo page for your vault:

[![](https://github.com/kevinmkchin/Obsidian-GitHub-Sync/raw/main/screenshots/remote-url.png)](https://github.com/kevinmkchin/Obsidian-GitHub-Sync/blob/main/screenshots/remote-url.png)

You can use either the HTTPS or SSH url. Grab it and paste it in the GitHub Sync settings tab like so:

[![](https://github.com/kevinmkchin/Obsidian-GitHub-Sync/raw/main/screenshots/new-settings-page.png)](https://github.com/kevinmkchin/Obsidian-GitHub-Sync/blob/main/screenshots/new-settings-page.png)

Done. Try clicking the Sync button now - it should work.

The first time may prompt you to authenticate if you haven't, or it may ask you to configure git with your email and name.

### Optional

[](#optional)

If your git binary is not accessible from your system PATH (i.e. if you open up Command Prompt or Terminal and can't use git), you need to provide its location. I initialize git only when launching Cmder, so I need to input a custom path like so: `C:/Users/Kevin/scoop/apps/cmder-full/current/vendor/git-for-windows/cmd/`. Note that I excluded `git.exe` from the end of the path.

You can also include your GitHub username and personal access token in the remote url. Like so: `https://{username}:{personal access token}@github.com/{username}/{repository name}`. This is not recommended anymore, but it was how the plugin worked prior to 1.0.4. If you're doing this, you'll have to add `.obsidian/plugins/github-sync/data.json` to your `.gitignore`. See: [#2 (comment)](https://github.com/kevinmkchin/Obsidian-GitHub-Sync/issues/2#issuecomment-2168384792).

## Rationale

[](#rationale)

This plugin is for personal use, but I figured others might find it useful too. This is basically a glorified script - the code is tiny its like ~200 SLOC. I keep a private GitHub repository for my Markdown notes, and I wanted some way to pull/push my notes from within Obsidian without opening a command line to run a script or set up an auto sync script on a timer. I don't use Git branches for my notes so this plugin doesn't support branching.

The Node API used by this plugin works with any remote host, but I use GitHub so I centered the whole plugin around that.

Mobile support could come in the future depending on how much I need it myself.

Follow my stuff at [https://kevin.gd/](https://kevin.gd/)