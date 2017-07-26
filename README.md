# XNAT Theme Packages

This repository contains UI theme packages that can be installed in XNAT 1.7.3 or higher.

> Although earlier versions of XNAT 1.7.x included basic support for themes, the packages 
> in this repo _require_ **XNAT 1.7.3** or higher for proper functionality and should be
> used as a reference for theme development going forward.


## Installing a Theme

There are a few different ways to install a theme:
 - upload a theme zip file using the Site Admin page (easy)
 - upload a theme from a bash terminal using the included `upload.sh` script (easier)
 - copy a theme _folder_ directly to the 'themes' directory in the webapp
 
If you want to upload one of the included themes through the admin UI, the theme folder 
will need to be compressed first using `zip` compression.

> One way to quickly install a theme is to use the included `upload.sh` script. Enter 
> the command below from this folder in a bash terminal, substituting the desired `theme-name`, 
> your admin `username:password` and the URL to the server (including app context, if applicable).

```
./upload.sh theme-name username:password http://yourserver.org
```


## Creating a Theme
 
You can use one of the themes included here as a starting point for your own custom theme - 
just duplicate the folder, give it a unique name, and you're ready. 

Specially-named files in certain folders are automatically parsed by the XNAT webapp and
will be used where theme-specific items are supported.

<!-- to be continued... -->