# ghost-themer

ghost-themer is a [Docker](https://www.docker.com/) container for managing [Ghost](https://ghost.org/) blog [themes](https://themes.ghost.org/). It supports installing and updating themes located on Github.

There are many free and paid themes available in the [Ghost Marketplace](http://marketplace.ghost.org/themes/free/), [All Ghost Themes](http://www.allghostthemes.com/tag/free/) and other places.

### Quick Start

Create and run the ghost-themes container with the volume from your Ghost data container:

`docker run --rm --volumes-from <your-data-container> bennetimo/ghost-themer`

Where:

`<your-data-container>` is where your ghost themes live (your Ghost container or separate data container)

This will run a container that will install the default [Casper](https://github.com/TryGhost/Casper) theme into the `/var/lib/ghost/themes` directory (or update it if it exists).

> N.B. If a theme already exists that was not installed via Git, then it will be ignored.

### Installing multiple themes

Additional themes can be passed as arguments, in the form 'themename:githubrepo'.

For example to explicitly specify the Casper theme:

`docker run --volumes-from <your-data-container>  bennetimo/ghost-themer casper:TryGhost/Casper`

You can list as many themes as you want, space separated. For example:

`docker run --volumes-from <your-data-container>  bennetimo/ghost-themer casper:TryGhost/Casper casper-copy:TryGhost/Casper`

Would install two copies of Casper, one as 'casper' and one 'casper-copy'

> The container only retrieves and extracts the theme files, so if there is additional post-installation setup needed for a particular theme then you still need to do that

### Updating themes

ghost-themer will check for the existence of any themes specified, and if they exist already they will be updated instead by doing a `git pull origin master` on the themes Github repo. So to update all of the themes, just run ghost-themer again.

### Changing the theme location

The default theme directory is `/var/lib/ghost/themes`. You can override this by setting the `THEMES_LOCATION` environment variable when you start the container.

`docker run --volumes-from <your-data-container> -e THEMES_LOCATION="/my/theme/directory" bennetimo/ghost-themer`