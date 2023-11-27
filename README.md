# ActoriousToday
This repository contains the code for a [TMS WEB Core](https://www.tmssoftware.com/site/tmswebcore.asp) web app that demonstrates how to use the [Actorious](https://www.actorious.com/) "TopToday" REST API endpoint to retrieve a set of the most popular actors with birthdays on the given date. 

This web app can be accessed directly at https://www.actorious.com/today and will also accept the following URL parameters.
- N: Number of people to display (max: 30)
- F: First person to display (useful when displaying sets with different sizes)
- W: Container width
- H: Container height
- X: Container left offset
- Y: Container top offset
- S: Container scale factor
- B: Container background (CSS color value)
- R: Border radius (for image rounding)
- M: Month (if different than current month)
- D: Day (if different than current day)

For example, to display the top 25 people with a June 7th birthday in a 5x5 grid, the following might be used. Leaving off the final two parameters (M and D) will return results for the current date.

[https://www.actorious.com/today/?N=25&W=950&H=1410&S=.486&B=%231C1C1C&X=1&R=10px&M=6&D=7](https://www.actorious.com/today/?N=25&W=950&H=1410&S=.486&B=%231C1C1C&X=1&R=10px&M=6&D=7)

This can be embedded into another page using an <iframe> or in the case of Home Assistant, a Webpage card (which internally uses an <iframe>). 
Multiple such links can be used to create more interesting arrangements. 
For example, maybe the top five are displayed with larger images 5-across, with the next 24 displayed with smaller thumbnails 8-across. 
This is where the need for the F parameter comes from - to skip over the first five when generating a second request for the remaining photos.

For more information about using <iframe> elements with TMS WEB Core web applications, check out [this post](https://www.tmssoftware.com/site/blog.asp?post=1090).

## Repository Information
[![Count Lines of Code](https://github.com/500Foods/ActoriousToday/actions/workflows/main.yml/badge.svg)](https://github.com/500Foods/ActoriousToday/actions/workflows/main.yml)
<!--CLOC-START -->
```
Last Updated at 2023-11-27 03:00:06 UTC
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Pascal                           2             48             62            160
Delphi Form                      1              0              0             39
Markdown                         1              7              2             39
YAML                             2             11             12             33
HTML                             2              7              0             23
-------------------------------------------------------------------------------
SUM:                             8             73             76            294
-------------------------------------------------------------------------------
```
<!--CLOC-END-->

## Sponsor / Donate / Support
If you find this work interesting, helpful, or valuable, or that it has saved you time, money, or both, please consider directly supporting these efforts financially via [GitHub Sponsors](https://github.com/sponsors/500Foods) or donating via [Buy Me a Pizza](https://www.buymeacoffee.com/andrewsimard500). Also, check out these other [GitHub Repositories](https://github.com/500Foods?tab=repositories&q=&sort=stargazers) that may interest you.
