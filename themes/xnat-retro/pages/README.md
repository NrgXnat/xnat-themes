Files placed in the 'pages' folder will be automatically picked up in an active theme 
using the value of the `view` query string parameter in following URL pattern:

`//app/template/Page.vm?view=example`

There are a few different options for file types and locations:

 - `/pages/example.vm` - a Velocity template in the root of `/pages`
 - `/pages/example.jsp` - a JSP template in the root of `/pages`
 - `/pages/example/content.vm` - a Velocity template named `content.vm` in a named folder
 - `/pages/example/content.jsp` - a JSP template named `content.jsp` in a named folder
 - `/pages/example/content.html` - an HTML file named `content.html` in a named folder

When a theme is active and contains a page that matches the name of a standard XNAT
page, the theme's page content will have priority when loading. For example, if
you wanted to create a custom user management page for your theme, you would create
a file with the following path and name:

 - `/pages/admin/users/content.jsp`
 
> As more standard pages move to this structure, they can very easily be overriden in a theme.

Velocity templates will get parsed in the context of the `Page.vm` file, so some variables
and methods that are available on other standard templates may not be available for a
theme template.

JSP templates (or portions of a template) can easily be secured to allow access to only
site administrators by putting restricted content inside a custom tag:

Add this line at the top of the page where used taglibs are defined:

```
<%@ taglib prefix="pg" tagdir="/WEB-INF/tags/page" %>
```

Then put the secure content inside the custom `<pg:restricted>` tag:

```
<pg:restricted> Administrators Only </pg:restricted>
```

Other custom tags can be explored in the `/WEB-INF/tags/page` folder in the XNAT webapp source.