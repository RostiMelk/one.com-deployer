# GitHub Action for deploying repos to One.com sites

This GitHub Action can be used to deploy your repo/branch from Github to a One.com site using SSH and a prefashioned rsync protocol. Deploy a theme, plugin or other directory with the TPO options. Post deploy, this action will automatically purge your ite cache to ensure all changes are visible.

## Example GitHub Action workflow

1. Create a `.github/workflows/main.yml` file in your root of your WordPress project/repo, if one doesn't exist already.

2. Add the following to the `main.yml` file, replacing <yourdomainname.com> and the public and private key var names if they were anything other than what is below. Consult "Furthur Reading" on how to setup keys in repo Secrets.

3. Git push your site repo.

```yml
name: Deploy to One.com

on:
  push:
    branches:
        - main

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: GitHub Deploy to One.com
      uses: rostimelk/one.com-deployer@master
      env:
          ONE_DOMAIN_NAME: yourdomainname.com
          ONE_SSH_KEY_PUBLIC: ${{ secrets.PUBLIC_KEY_NAME }}
          ONE_SSH_KEY_PRIVATE: ${{ secrets.PRIVATE_KEY_NAME }}
          TPO_SRC_PATH: ""
          TPO_PATH: ""
```

## Environment Variables & Secrets

### Required

| Name                  | Type                 | Usage                                                                                                 |
| --------------------- | -------------------- | ----------------------------------------------------------------------------------------------------- |
| `ONE_DOMAIN_NAME`     | Environment Variable | Insert the domain name of the One.com site you want to deploy to.                                     |
| `ONE_SSH_KEY_PRIVATE` | Secret               | Private SSH Key for deployment. See below for SSH key usage.                                          |
| `ONE_SSH_KEY_PUBLIC`  | Secret               | Public SSH Key for deployment. See below for SSH key usage and how to add your public key to One.com. |

### Optional

| Name           | Type                                                                                                                                                            | Usage |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `TPO_SRC_PATH` | Optional path to specify a theme, plugin, or other directory source to deploy from. Ex. `"wp-content/themes/your-theme-here/"` . Defaults to "." Dir.           |
| `TPO_PATH`     | Optional path to specify a theme, plugin, or other directory destination to deploy to. Ex. `"wp-content/themes/your-theme-here/"` . Defaults to root directory. |

### Further reading

-   [Defining environment variables in GitHub Actions](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#environment-variables)
-   [Storing secrets in GitHub repositories](https://developer.github.com/actions/managing-workflows/storing-secrets/)

## Setting up your SSH keys for repo

1. [Generate a new SSH key pair](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) as a special deploy key between your Github Repo and One.com. The simplest method is to generate a key pair with a blank passphrase, which creates an unencrypted private key.

2. Store your public and private keys in the GitHub repository of your website as new 'Secrets' (under your repository settings) using the names `PRIVATE_KEY_NAME` and `PUBLIC_KEY_NAME` respectively with the name in your specfic files. These can be customized, just remember to change the var in the yml file to call them correctly.

## Add up your public SSH key for your One.com site.

1. SSH in to your One.com install using terminal.
2. Without navigating to any path, create a .ssh folder with: `$ mkdir .ssh`.
3. Navigate into your folder: `$ cd .ssh`.
4. Create an empty file in the folder called authorized_keys: `$ touch authorized_keys`.
5. In the authorized_keys file, you want to add your SSH public key that you generated before. You can do this using nano: `$ nano authorized_keys`.
6. Paste in your key.
7. To exit nano, click Ctrl + X . If you ask nano to exit from a modified file, it will ask you if you want to save it. Press Y to save the file.
8. You can not safely exit SSH by typing: `$ exit`.
