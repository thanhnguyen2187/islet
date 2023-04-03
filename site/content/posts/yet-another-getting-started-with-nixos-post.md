---
title: "Yet Another Getting Started With NixOS Post"
date: 2023-03-16T21:25:45+07:00
draft: false
toc: true
images:
categories:
  - explanation
  - how-to-guide
tags:
  - nixos
  - linux
---

## Introduction

I can imagine that everyone who is reading my blog is at least familiar with
"package/program installation":

- With Windows: downloading an installation file and clicking through the setup
  window
- With Ubuntu: typing `sudo apt install ...`

And wished that there is some way to automate that, NixOS has an approach for
that. You simply declare a configuration file, and NixOS is going to jump
through hoops to make sure that your machine has the right packages installed.

For example, I have this package list:

```
firefox
vim
clojure
```

I stored them as `my-machine-config.txt`. NixOS have some "magic" that allows me
to:

```shell
apply my-machine-config.txt
```

And have those packages ready on my machine. Also, when I want to install a new
package, `hugo` in this case, I only need to add a line to
`my-machine-config.txt`:

```
firefox
vim
clojure
hugo
```

Then type the same `apply` command again:

```shell
apply my-machine-config.txt
```

And have `hugo` ready:

```shell
hugo version
# hugo v0.106.0+extended linux/amd64 BuildDate=unknown VendorInfo=nixpkgs
```

There is a myriad of posts on NixOS and its benefits, but I found that they
often overwhelm the readers with too much new technical jargons. I hope that
this post fits in the right niche for people who:

- Have some experiences with Linux and is comfortable with the command line
- Have some familiarities with functional programming (knowing about "pure
  function")

If you are intrigued, then read ahead.

## Installing NixOS

The process is fairly trivial, with the new graphical ISO image. You can grab
one at: https://nixos.org/download.html#nixos-iso

![](../images/download-nixos-graphical-iso.png)

Then copy the file to your bootable USB. I recommend Ventoy as the tool here. It
creates a "bootable section", and a "disk section", which allows you to choose
from multiple ISOs. You can have Ubuntu's ISO there as a backup.

![](../images/ventoy.png)

The steps that you go through in the actual installation is not that different
from the "average" Ubuntu installation. In the end, you are going to get greeted
by a typical GNOME experience.

## Touching `/etc/nixos/configuration.nix`

Playing around, you will realize that NixOS does not have `python` ready like
Ubuntu/Pop OS. You do not have `apt` or `dnf` to install your package either. In
fact, it is quite bare-boned.

Here be the dragons. Your packages are defined `configuration.nix`. Only after
changing it and applying a specific command then your packages or applications
are installed. It is what sets NixOS apart from your "typical" Linux
distributions.

Try `cat`ing `/etc/nixos/configuration.nix` is going to give you:

```nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  ...

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.<username> = {
    isNormalUser = true;
    description = "Your Name";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  environment.systemPackages = with pkgs; [
     ...
  ];
}
```

Do notice what was filled in `packages`. `firefox` is listed, so you can check
for yourself if Firefox is ready. Also be noted that only `nano` is available as
NixOS's default, so to modify `configuration.nix`, you have to do:

```shell
sudo nano /etc/nixos/configuration.nix
```

Try adding `vim` to `systemPackages`, and then type this command:

```shell
sudo nixos-rebuild switch
```

One more thing to be noted, but I think you already figured is that
`systemPackages` is something installed system-wide, while `packages` within
`users.users.<username>` is specific per-user.

I know you are going to have a lot of question, but believe me that this is
enough for you to be dangerous with NixOS!

## Supporting USB WiFi Adapters

In my case, I was using an TP Link Archer T4U, which is correlated to module
`rtl88x2bu` of Linux kernel. Adding it to NixOS is really simple:

```nix
{ config, pkgs, ... }:
{
  ...

  boot.extraModulePackages = [
    config.boot.kernelPackages.rtl88x2bu
  ];

  ...
}
```

Run `sudo nixos-rebuild switch` again, and restart your computer should do the
trick. To findout what is the driver name for your device, simply Google "<your
device name> linux driver".

## Enabling IBus Bamboo

As you may or may have not know it, I am Vietnamese. Sometimes I need to type...
Vietnamese, which is not something enabled by default in Linux nor Windows.

The adding is simple:

```nix
{ config, pkgs, ... }:
{
  ...

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      bamboo
    ];
  };

  ...
}
```

As always, apply `sudo nixos-rebuild switch` after you make the changes. Since
GNOME is not smart enough to detect the changes of IBus, you have to reboot your
machine to see that IBus Bamboo is available:

![](../images/gnome-ibus-bamboo.png)

## Conclusion

I am glad that you made it here. The idea of "simple" versus "easy" did not come
to my mind when I plan the post, but it suddenly popped up in this conclusion.

Rich Hickey coined those terms really well:

- "easy":
  - near, at hand
  - near to our understanding/skillset
  - is relative
- "simple":
  - one fold/braid: one role, one task, one concept, one dimension
  - but not: one instance, one operation
  - about lack of interleaving, not cardinality
  - is objective

I feel like NixOS's approach is the "simple" way. Instead of considering various
factors of a system before you install anything, you add a line to your
configuration, and be confident that it is going to work. You also feel
confident saving your configuration file somewhere, and then be able to
"restore" it on a new machine.

I did not cover a few topics, since I think they are going to drag this post on
too long. They either are covered better somewhere else, or are not too relevant
to a new user, or deserve their own post:

- How does NixOS work?
- The difference between NixOS, and Nix the package manager, and Nix the
  language.
- User configurations/dotfiles managing with `home-manager`.

## Additional Resources

- NixOS home page: https://nixos.org/
- Search page for Nix packages: https://search.nixos.org/packages
- How Nix works: https://nixos.org/guides/how-nix-works.html

