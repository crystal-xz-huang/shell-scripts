# Shell Scripts

Collection of shell scripts that can be used for convenience.

## How to Execute a Shell Script

There a few ways to execute a shell script `file.sh`.

### Option 1

1. Make the file executable by using the `chmod` command to turn on the execute bit e.g., `chmod +x file.sh`

```shell
chmod +x file.sh
```
2. Now you can run the shell script via the command:

```shell
/path/to/file.sh
# or if the `file.sh` is in the current directory (.):
./file.sh
```

### Option 2

Execute the script with the interper (assuming its installed in your system):

```shell
bash file.sh
# or
dash file.sh
```
or using the system’s default sh ([zsh or bash for macOS](https://support.apple.com/en-ca/102360)):

```shell
sh file.sh
```

### Option 3

It is common to put these scripts (without the .sh extension) in a dedicated directory such as `~/bin` or `$HOME/bin`, and then adding this directory to the `PATH` variable in your `~/.bashrc` or `~/.bash_profile` file (`~/.zshrc` or `~/.zprofile` in macOS Catalina or later).

For example in your `.bashrc` file:

```txt
PATH=$HOME/bin:$PATH
```

Then you can run the script directly by name, `file`, from anywhere.
