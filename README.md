# XNAT Theme Packages

This repository contains UI theme packages that can be installed in XNAT 1.7.3 or higher.

> Although earlier versions of XNAT 1.7.x included basic support for themes, the packages 
> in this repo _require_ **XNAT 1.7.3** or higher for proper functionality and should be
> used as a reference for theme development going forward.

> Support for UI themes in XNAT is still relatively new. If you run across a bug, please
> send a bug report to bugs@xnat.org.

## Installing a Theme

There are a few different ways to install a theme:
 - upload a theme 'package' zip file using the Site Admin page (easy)
 - upload a theme from a bash terminal using the included `upload.sh` script (easier)
 - copy a theme _folder_ directly to the 'themes' directory in the webapp
 
If you want to upload one of the included themes through the admin UI, the theme folder 
will need to be compressed first using `zip` compression.

One way to quickly install a theme is to use the included `upload.sh` script. Enter 
the command below from this folder in a bash terminal, substituting the desired `theme-name`, 
your admin `username:password` and the URL to the server (including app context, if applicable).

```bash
./upload.sh theme-name username:password http://yourserver.org
```

> **NOTE:** Since themes are stored directly in the running web app, installed themes
> will be lost when deploying a new webapp `.war` and will need to be re-uploaded
> after webapp deployment. This is a limitation of the current themes implemenation.


## Activating a Theme

After a theme is uploaded, it must be activated, either through an XAPI REST call, or 
by selecting it from the themes menu in the theme management panel on 
the site admin page. If you use the `upload.sh` script to upload your theme, you will 
be prompted to activate the newly uploaded theme package. If you enter `y` at the prompt, 
this will run the `curl` command below and activate the theme for you.

To activate a theme with a `PUT` request using `curl`:

```bash
curl -v -X PUT "http://yourserver.org/xapi/theme/theme-name" -u "username:password"
```

To activate a theme using the site admin page (you must be logged in as an admin user),
go to the site admin page `/app/template/Page.vm?view=admin` and click the "Themes & Features"
tab on the left. Select the desired theme from the menu in the "Theme Management" panel and 
click the "Set Theme" button to activate theme (simply selecting it will not activate it).

Go to the URL below in your webapp to directly access the "Themes & Features" tab:

```
/app/template/Page.vm?view=admin#tab=themes-and-features
```

> **NOTE:** When a theme is activated, the changes take effect _immediately_ and will
> affect appearance and page content for logged-in users.


## Deactivating or Deleting a Theme

To deactivate a theme without completely removing it from your webapp, use the theme management
panel on the site admin page and choose "None" from the theme list menu then click "Set Theme" 
to effectively disable the active theme.

A theme can be deleted by selecting it from the theme list menu and clicking the "Delete Theme"
button. This action is _destructive_ and _cannot be undone_ - it will permanently delete all files 
for the selected theme along with the associated zip file (if present). 

Deactivation and deletion can also be done using XAPI requests:

```bash
# deactivate the active theme without deleting it (activate the 'none' pseudo-theme)
curl -v -X PUT "http://yourserver.org/xapi/theme/none" -u "username:password"

# delete all theme files for a specified theme (which will also deactivate it)
curl -v -X DELETE "http://yourserver.org/xapi/theme/theme-name" -u "username:password"
```

## Creating a Theme
 
You can use one of the themes included here as a starting point for your own custom theme - 
just duplicate the folder, give it a unique name, and go from there. 

Specially-named files in certain folders are automatically parsed by the XNAT webapp and
will be used where theme-specific items are supported.

### Theme CSS File(s)

Custom CSS style overrides will be automatically loaded from `/css/theme.css`, and redefined 
style rules will override default styles contained in the main `app.css` file. If you need
to load more css files, you can do so with a simple `@import` statement in the `theme.css` 
file or include them as you would any other stylesheet in your theme's custom pages.

### Theme JavaScript File(s)

If there's a `/js/theme.js` file in the theme, it will be automatically loaded after all other 
core XNAT js files have been loaded. If you need to include other js files, you can lazy load
them in your `theme.js` file using the `loadjs('main.js')` global function, or of course you
can include them in `<script>` tags in your theme's custom pages.

When loading theme-specific resources with JavaScript, you'll need to include the theme
name in the url. You can hard code this to match the theme's folder name, or access the
theme name through the global XNAT variable `XNAT.themeName`. For example, to dynamically
load an image from a theme, you can use the `XNAT.url.rootUrl()` method like this:

```html
<img id="dyn-img" src="" width="200" height="200">
<script>
    var imgSrc = XNAT.url.rootUrl('/themes/' + XNAT.themeName + '/images/foo.png');
    document.getElementById('dyn-img').src = imgSrc;
</script>
```

> There are also variables for theme name defined for use in Velocity and JSP templates.
> JSP pages also have access to a `${themeRoot}` variable. See the 'Theme Pages' section 
> below for more info.

### Theme Pages

Files placed in the theme's `/pages/` folder will be automatically picked up when
that theme is active. Which page to load is determined by the value of the `view` 
query string parameter in the following URL pattern:

```
/app/template/Page.vm?view=example
```

There are a few different options for theme page file types and locations 
(relative to the theme root):

 - `/pages/example.vm` - a Velocity template in the root of `/pages`
 - `/pages/example.jsp` - a JSP template in the root of `/pages`
 - `/pages/example/content.vm` - a Velocity template named `content.vm` in a named folder
 - `/pages/example/content.jsp` - a JSP template named `content.jsp` in a named folder
 - `/pages/example/content.html` - an HTML file named `content.html` in a named folder

When a theme is active and contains a page that matches the name of a standard XNAT
page, the _theme's_ page content will have priority when loading. For example, if
you wanted to create a custom user management page for your theme, you would create
a file with the following path and name (relative to the theme root):

```
/pages/admin/users/content.jsp
```
 
Then visiting the url below would display your theme's custom user admin page:

```
/app/template/Page.vm?view=admin/users
```

> As other core pages start using this structure, they can very easily be overriden in a theme.

Velocity templates will get parsed in the context of the `Page.vm` file, so some variables
and methods that are available on other standard templates may not be available for use in 
a theme template.

When creating JSP templates, make sure to start your file with _AT LEAST_ the following lines:

```
<%@ page contentType="text/html" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pg" tagdir="/WEB-INF/tags/page" %>

```

You'll also want to include the `init.tag` file for access to certain JSP variables and the
`jsvars.tag` file for access to JavaScript variables that can be used in your js functions.

```xml
<pg:init/>
<pg:jsvars/>
```

JSP templates (or portions of templates) can easily be secured to allow admin-only access
by putting restricted content inside a custom `<pg:restricted>` tag:

Then put the secure content inside the `<pg:restricted>` tag:

```xml
<pg:restricted> Administrators Only </pg:restricted>
```

Other available tags can be explored in the `/WEB-INF/tags/page` folder in the XNAT webapp source.

#### Other Theme-specific Resources and Variables

When including theme-specific resources (images, html fragments, etc.) in your theme pages, you'll
need to use the full path to the resource (relative to the site root). To load an image named `foo.png`
into a JSP template from your theme's `/images/` folder, you can use the JSP variable `${themeRoot}`
for the first part of the path, as shown here:

```html
<img src="${themeRoot}/images/foo.png">
```

In Velocity templates, the theme name itself is defined in the `$theme` variable (but there's no 
predefined `$themeRoot` variable). To load the same `foo.png` image shown above in a Velocity
template, you'd need to include the `/themes/` part of the url:

```html
<img src="$content.getURI('/themes')/$theme/images/foo.png">
```

Or define a `$themeRoot` variable in that template and use it just like the JSP example:

```html
#set($themeRoot="$content.getURI('/themes')/$theme")
<img src="$themeRoot/images/foo.png">
```

Images that are referenced in CSS files should use relative paths since JS or template variables 
are not available in CSS files and the path is always relative to the CSS file itself, not the 
page that's loading it.

```css
#foo-img { background-image: url('../images/foo.png') }
```

JSP pages or page fragments can be included using a relative (to the parent page) path with the 
JSP `include` directive:

```
<%@ include file="foo.jsp" %>
```

...or using an absolute path with the `<jsp:include/>` JSTL tag...

```xml
<jsp:include page="${themeRoot}/pages/foo.jsp"/>
```

> Don't forget the `${themeRoot}` variable when using absolute paths in JSP templates.

## Included Themes

The themes in this repo can be used as a reference and starting point for creating your own theme.
These will evolve with more detailed and concrete examples of how to create styles and pages for 
XNAT themes.

- **XNAT "Retro" theme** \
  This theme includes a stylesheet that will turn your XNAT UI colors brown and yellow and 
  uses Verdana as the main font, harkening back to XNAT 1.5 and earlier, before shades of 
  blue dominated UI elements.
- _more themes to come..._

<!-- to be continued...? -->