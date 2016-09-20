# Dot Files

Add all files in ./home/ folder to your local home directory (~/).  

## Tools/Configurations provided
Look at individual instructions to only use parts of this.

To setup everything just run `./install.py`

#### Vim
To update vim:  
 * Install Vundle  
    ```sh
       git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
   ```
 * Open Vim (obviously not Vi)
 * Type ':PluginInstall'.
 * Bam! You get all awesome plugins in one shot.
 * Enjoy your life :)

#### Bash
Bash should work right outta the box.  
Boy oh boy it looks amazing. Enjoy :)

#### Lynx
No configuration needed.

#### Top
Awesome interface to top command without any hassle.

#### Mutt
You'll have to add your username and password to make it work.

#### Ack
Some small custom configurations to the mighty ack tool.

#### [Oh My Zsh](http://ohmyz.sh)
```sh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

### Recommendation
I'd recommend you to use tool like [homeshick](https://github.com/andsens/homeshick) to clone this repo:
```sh
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
$HOME/.homesick/repos/homeshick clone https://github.com/shubhamchaudhary/dotfiles.git
```
