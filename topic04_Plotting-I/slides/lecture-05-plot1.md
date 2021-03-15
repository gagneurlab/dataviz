---
title       : Data Analysis and Visualization in R
author      : Daniela Klaproth-Andrade, Daniel Bader, Jun Cheng, Jan Krumsiek, Julien Gagneur
subtitle    : Grammar of graphics and plotting I
framework   : io2012
highlighter : highlight.js
hitheme     : tomorrow
widgets     : [mathjax, bootstrap, quiz]
ext_widgets : {rCharts: ["libraries/highcharts", "libraries/nvd3"]}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---



<!-- Center image on slide -->
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.min.js"></script>
<script type='text/javascript'>
$(function() {
    $("p:has(img)").addClass('centered');
});
</script>
</script>
<script type = 'text/javascript'>
$('p:has(img.build)').addClass('build')
</script>

<script type='text/javascript'>
// parameters
var sections = ["Grammar of graphics", "1 continuous variable", "2 variables - one discrete, one continuous", "2 variables - both continuous", "Axes and labels"];
var title = "Overview";
var fontsize = "20pt"
var unselected_color = "#888888"
// function
function toc(cur) {
  // header
  document.write("<h2>"+title+"</h2>");
  // find current
  ind = sections.indexOf(cur);
  if (ind==-1 && cur.length>0) {
     document.write("<br/>Error: section not defined '"+cur+"'");
     return;
  }
  // write all out
  document.write("<br/><ul>");
  for (i = 0; i < sections.length; i++) { 
    if (cur=="") 
      // all the same
      document.write("<li style='font-size:"+fontsize+"'>"+sections[i]+"</li>");
    else {
      if (i==ind)
        document.write("<li style='font-size:"+fontsize+"'><b>"+sections[i]+"</b></li>");
      else
        document.write("<li style='color:"+unselected_color+";font-size:"+fontsize+"'>"+sections[i]+"</li>");
    }
  }
  document.write("</ul>");
}
</script>



<!-- START LECTURE -->


```
## Error in knitr::include_graphics("assets/img/lec05_syllabus.png"): Cannot find the file(s): "assets/img/lec05_syllabus.png"
```


---

## Why plotting?

Data in scientific publications is shown as plots, sure. But there is more.

**A realistic example to warm up**:

A vector containing 500 (hypothetical) height measurements for adults in Germany:




```r
length(height)
```

```
## [1] 500
```

```r
head(height, n=20)
```

```
##  [1] 1.706833 1.635319 1.709841 1.707259 1.668659 1.580702 1.608214 1.636738
##  [9] 1.649740 1.758209 1.684362 1.614045 1.598355 1.636974 1.636535 1.631482
## [17] 1.661350 1.609864 1.669606 1.594311
```

We want to know their average height:


```r
mean(height)
```

```
## [1] 1.976743
```
Wait... what?


--- &radio

```r
mean(height)
```

```
## [1] 1.976743
```
<br/>

What happened?

1. A. `mean()` is not the right function to assess what we want to know.

2. B. Adults in Germany are exceptionally tall

3. C. _A decimal point error in one data point._

4. D. It's a multiple testing problem because we are looking at so many data points (n=500).

***.explanation
See next slide

---

## Solution

```r
mean(height)
```

```
## [1] 1.976743
```

**What happened?**<br/>

* A. `mean()` is not the right function to assess what we want to know.
  * *No, the mean is exactly what we want.*
* B. Adults in Germany are exceptionally tall.
  * *OK, no...*
* **C. A decimal point error in one data point.**
  * *Yes, see next slide.*
* D. It's a multiple testing problem because we are looking at so many data points (n=500).
  * *This question was intentionally misleading, this does not have anything to do with multiple testing.*



---
## The outlier...


```r
plot(height)
hist(height)
```

<img src="assets/fig/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="300px" height="400px" /><img src="assets/fig/unnamed-chunk-7-2.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="300px" height="400px" />


```r
mean(height)
```

```
## [1] 1.976743
```

---
## The outlier...

Getting rid of the outlier fixes the dataset


```r
fheight <- height[height < 3]
```


```r
plot(fheight)
hist(fheight)
```

<img src="assets/fig/unnamed-chunk-10-1.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" width="300px" height="400px" /><img src="assets/fig/unnamed-chunk-10-2.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" width="300px" height="400px" />


```r
mean(fheight)
```

```
## [1] 1.650043
```

---

## The outlier...

This is how the broken dataset was generated:


```r
height <- c(rnorm(499, mean=1.65, sd=0.045), 165)
```


---

## Visualization and the scientific method

Data visualization is important for:
* Exploring the data. Reveal surprising facts.
* Convingly showing interesting relationships.  


```
## Error in knitr::include_graphics("assets/img/lec05_scientific-method.png"): Cannot find the file(s): "assets/img/lec05_scientific-method.png"
```

---

## Our 3 visualization lectures

This lecture and the two following ones will cover:
* Grammar of graphics: a modular and felxible framework to build plots
* Standard plots based on dimension and nature of the data (discrete / continuous)
* Colors
* Dos and don'ts
* Algorithms for exploring high-dimensional data


---

<script type='text/javascript'>toc("")</script>

---

<script type='text/javascript'>toc("Grammar of graphics")</script>

---
## Grammar of Graphics
The Grammar of Graphics is a visualization theory developed by 
Leland Wilkinson in 1999.
<br> 

* influenced the development of graphics and visualization libraries alike 
* 3 key principles
  * Separation of data from aesthetics (e.g. x and y axis, color-coding)
  * Definition of common plot/chart elements (e.g. dot plots, boxplots, etc.)
  * Composition of these common elements (one can combine elements as layers)


---
## ggplot2 and Grammar of Graphics

```r
ggplot(mpg, aes(x=displ, y=cty, colour=class)) +  # Data: how variables in the data are mapped to aesthetic attributes 
  geom_point() +  # Layers: made up of geometric elements and statistical transformation.
  facet_wrap(~ class, ncol=4) + # Facets
  theme(axis.title = element_text(size=15), legend.title = element_text(size=15)) +
  labs(title='displ vs cty', x='Engine displacement', y='city miles per gallon') +
  stat_smooth() # Stats
```

<img src="assets/fig/lec05_plt1-1.png" title="plot of chunk lec05_plt1" alt="plot of chunk lec05_plt1" width="700px" height="400px" />


---
## Grammar Defines Components of Graphics
**Data:** data.frame (or data.table) object where columns correspond to variables

**Aesthetics:** describes visual characteristics that represent data (`aes`)
 - position (x,y), color, size, shape, transparency

**Layers:** made up of geometric objects that represent data (`geom_`)
 - points, lines, boxplots, ...

**Scales:** for each aesthetic, describes how visual characteristic is converted to display values (`scale_`)
 - log scales, color scales, size scales, shape scales, ...

**Facets:** describes how data is split into subsets and displayed as multiple sub graphs (`facet_`)

**Stats:** statistical transformations that typically summarize data (`stat`)
 - counts, means, medians, regression lines, ...
 
**Coordinate system:** describes 2D space that data is projected onto (`coord_`)
 - Cartesian coordinates, polar coordinates, map projections, ...

---

## Simple example: Human Development versus Corruption Perception

```r
ind <- fread('../extdata/CPI_HDI.csv')
```

```
## Error in fread("../extdata/CPI_HDI.csv"): File '../extdata/CPI_HDI.csv' does not exist or is non-readable. getwd()=='/data/nasif12/home_if12/theodora/Projects/dataviz/lectures-WS2021/topic04_Plotting-I/slides'
```

```r
ind
```

```
##       V1     country wbcode CPI   HDI            region
##   1:   1 Afghanistan    AFG  12 0.465      Asia Pacific
##   2:   2     Albania    ALB  33 0.733 East EU Cemt Asia
##   3:   3     Algeria    DZA  36 0.736              MENA
##   4:   4      Angola    AGO  19 0.532               SSA
##   5:   5   Argentina    ARG  34 0.836          Americas
##  ---                                                   
## 147: 147     Uruguay    URY  73 0.793          Americas
## 148: 148  Uzbekistan    UZB  18 0.675 East EU Cemt Asia
## 149: 149       Yemen    YEM  19 0.498              MENA
## 150: 150      Zambia    ZMB  38 0.586               SSA
## 151: 151    Zimbabwe    ZWE  21 0.509               SSA
```

<br>
CPI: Corruption Perceptions Index (http://www.transparency.org/)
HDI: Human Development Index (http://hdr.undp.org/)
Year: 2014
<br>
---

## Simple example: Human Development versus Corruption Perception

```r
ggplot(ind, aes(CPI, HDI)) + geom_point()
```

<img src="assets/fig/lec05_plt2-1.png" title="plot of chunk lec05_plt2" alt="plot of chunk lec05_plt2" width="500px" height="400px" />

<br>
CPI: Corruption Perceptions Index (http://www.transparency.org/)
HDI: Human Development Index (http://hdr.undp.org/)
Year: 2014
<br>
---

---
## Simple scatter plot

```r
ggplot(ind, aes(CPI, HDI)) + 
  geom_point()
```

<img src="assets/fig/lec05_plt3-1.png" title="plot of chunk lec05_plt3" alt="plot of chunk lec05_plt3" width="500px" height="400px" />

---
## ggplot returns an object

```r
p <- ggplot(ind, aes(CPI, HDI)) + geom_point()
p
```

<img src="assets/fig/lec05_plt7-1.png" title="plot of chunk lec05_plt7" alt="plot of chunk lec05_plt7" width="500px" height="400px" />

---
## ggplot returns an object

```r
names(p)
```

```
## [1] "data"        "layers"      "scales"      "mapping"     "theme"      
## [6] "coordinates" "facet"       "plot_env"    "labels"
```

```r
saveRDS(p, "../extdata/lec06_p.rds")
```

```
## Error in gzfile(file, mode): cannot open the connection
```

```r
p <- readRDS("../extdata/lec06_p.rds")
```

```
## Error in gzfile(file, "rb"): cannot open the connection
```

```r
p + geom_hline(yintercept = 0.7)
```

<img src="assets/fig/lec05_plt8-1.png" title="plot of chunk lec05_plt8" alt="plot of chunk lec05_plt8" width="400px" height="400px" />

---
## Mapping of aesthetics done globally at `ggplot()` 

```r
ggplot(ind, aes(CPI, HDI)) + 
  geom_point(size=0.5) + 
  geom_text(aes(label = wbcode), size=2, vjust=0)
```

<img src="assets/fig/lec05_plt4-1.png" title="plot of chunk lec05_plt4" alt="plot of chunk lec05_plt4" width="500px" height="400px" />

---
## Mapping of aesthetics can be done globally at `ggplot()` or at individual layers

```r
ggplot(ind) + 
  geom_point(aes(CPI, HDI))
```

<img src="assets/fig/lec05_plt12-1.png" title="plot of chunk lec05_plt12" alt="plot of chunk lec05_plt12" width="500px" height="400px" />

Global mapping is inherited by default to all geom layers, while `aes` mapping at individual layer is only recognized at that layer.

---
## Mapping of aesthetics done at individual layers

```r
ggplot(ind) + 
  geom_point(aes(CPI, HDI), size=0.5) + 
  geom_text(aes(CPI, HDI, label = wbcode), size=2, vjust=0)
```

<img src="assets/fig/lec05_plt5-1.png" title="plot of chunk lec05_plt5" alt="plot of chunk lec05_plt5" width="500px" height="400px" />

---
## Individual layer mapping cannot be recognized by other layers

```r
ggplot(ind) + 
  geom_point(aes(CPI, HDI)) + 
  geom_text(aes(label = wbcode))
```

```
## Error: geom_text requires the following missing aesthetics: x and y
```

<img src="assets/fig/lec05_plt6-1.png" title="plot of chunk lec05_plt6" alt="plot of chunk lec05_plt6" width="500px" height="400px" />

---
## You can easily map variables to different colours, sizes or shapes!
ggplot2 automatically scales for you.

```r
ggplot(data = ind) + 
  geom_point(aes(CPI, HDI, color = region))
```

<img src="assets/fig/lec05_plt9-1.png" title="plot of chunk lec05_plt9" alt="plot of chunk lec05_plt9" width="600px" height="400px" />


---
## You can easily map variables to different colours, sizes or shapes!


```r
ggplot(data = ind) + 
  geom_point(aes(CPI, HDI, shape = region))
```

<img src="assets/fig/lec05_plt10-1.png" title="plot of chunk lec05_plt10" alt="plot of chunk lec05_plt10" width="600px" height="400px" />

---
## Aesthetic mappings can also be supplied in individual layers

```r
ggplot(ind, aes(CPI, HDI)) + 
  geom_point(aes(color = region))
```

<img src="assets/fig/lec05_plt11-1.png" title="plot of chunk lec05_plt11" alt="plot of chunk lec05_plt11" width="600px" height="400px" />

--- &radio

What's the result of the following command?

`ggplot(data = mpg)`

1. A Nothing happens

2. B _A blank figure will be produced_

3. C A blank figure with axes will be produced

4. D All data in `mpg` will be visualized

***.hint
ggplot builds plot layer by layer. 

***.explanation
Neither variables were mapped nor geometry specified. 


--- &radio

What's the result of the following command?

`ggplot(data = mpg, aes(x = hwy, y = cty))`

1. A Nothing happens

2. B A blank figure will be produced

3. C _A blank figure with axes will be produced_

4. D A scatter plot will be produced

***.hint
ggplot builds plot layer by layer. 

***.explanation
Axis x and y are mapped. But no geometry specified.


--- &radio

What's the result of the following command?

`ggplot(data = mpg, aes(x = hwy, y = cty)) + geom_point()`

1. A Nothing happens

2. B A blank figure will be produced

3. C A blank figure with axes will be produced

4. D _A scatter plot will be produced_

***.hint
ggplot builds plot layer by layer. 

***.explanation
Data, axes and geometry specified.

---
## Answers
`ggplot(data = mpg)`: a blank figure will be produced

`ggplot(data = mpg, aes(x = hwy, y = cty))`: A blank figure with axes will be produced

`ggplot(data = mpg, aes(x = hwy, y = cty)) + geom_point()`: A scatter plot will be produced

---
<script type='text/javascript'>toc("1 continuous variable")</script>

---
## Histogram
Histogram of Human Development Index (HDI) in the ind dataset: 

```r
ind
```

```
##       V1     country wbcode CPI   HDI            region
##   1:   1 Afghanistan    AFG  12 0.465      Asia Pacific
##   2:   2     Albania    ALB  33 0.733 East EU Cemt Asia
##   3:   3     Algeria    DZA  36 0.736              MENA
##   4:   4      Angola    AGO  19 0.532               SSA
##   5:   5   Argentina    ARG  34 0.836          Americas
##  ---                                                   
## 147: 147     Uruguay    URY  73 0.793          Americas
## 148: 148  Uzbekistan    UZB  18 0.675 East EU Cemt Asia
## 149: 149       Yemen    YEM  19 0.498              MENA
## 150: 150      Zambia    ZMB  38 0.586               SSA
## 151: 151    Zimbabwe    ZWE  21 0.509               SSA
```

---
## Histogram
Histogram of Human Development Index (HDI) in the ind dataset: 

```r
ggplot(ind, aes(HDI)) +
  geom_histogram() + mytheme
```

<img src="assets/fig/lec05_hist1-1.png" title="plot of chunk lec05_hist1" alt="plot of chunk lec05_hist1" width="600px" height="400px" />

---
## Histogram: setting the number of bins
Histogram of Human Development Index (HDI) in the ind dataset: 

```r
ggplot(ind, aes(HDI)) +
  geom_histogram(bins=10) + mytheme
```

<img src="assets/fig/lec05_hist2-1.png" title="plot of chunk lec05_hist2" alt="plot of chunk lec05_hist2" width="600cm" height="1200cm" />


---
## Density plots
Histograms are sometimes not optimal to investigate the distribution of a variable due to discretization effects during the binning process.<br/><br/>
Solution: smoothed distribution plot by kernel density estimation:<br/>
[https://en.wikipedia.org/wiki/Kernel_density_estimation](https://en.wikipedia.org/wiki/Kernel_density_estimation)

Density plot of Human Development Index (HDI) in the ind dataset: 

```r
ggplot(ind, aes(HDI)) +
  geom_density() + mytheme
```

<img src="assets/fig/lec05_density1-1.png" title="plot of chunk lec05_density1" alt="plot of chunk lec05_density1" width="380px" height="400px" />


---
## Kernel density plots - smoothing bandwidth

Can be set manually. Default option is a bandwidth rule (which is usually a good choice). Be careful with density plots as the bandwith can have a huge impact on the visualization -> histograms can be better.


```r
ggplot(ind, aes(HDI)) +  geom_density(bw=0.01) + mytheme  # small bandwith
```

<img src="assets/fig/lec05_hist3-1.png" title="plot of chunk lec05_hist3" alt="plot of chunk lec05_hist3" width="250px" height="400px" />


```r
ggplot(ind, aes(HDI)) +  geom_density(bw=1) + mytheme  # large bandwith
```

<img src="assets/fig/lec05_density2-1.png" title="plot of chunk lec05_density2" alt="plot of chunk lec05_density2" width="250px" height="400px" />

---

## Boxplot
<img src="./assets/img/lec06_07_plotting/lec06_Boxplot_vs_PDF.png" width="400">

from https://en.wikipedia.org/wiki/Box_plot<br/><br/>

* median = the center of the data, middle value in sorted list, 50% quantile of the data
* quartiles = 25% and 75% quantiles of the data. IQR: interquartile range
* lines coming out of the box are called "whiskers"
* whiskers reach to the most extreme datapoint within $\pm  1.5\times IQR$
* anything outside of the "whiskers" is plotted as an "outlier"

---

## A boxplot example

<img src="assets/fig/lec05_boxplot1-1.png" title="plot of chunk lec05_boxplot1" alt="plot of chunk lec05_boxplot1" width="400px" height="800px" />

It is possible to not show the outliers. However, we strongly recommend to keep them.
Outliers can reveal interesting data points (discoveries "out of the box") or bugs in data preprocessing. 

--- &radio

For which type of data will boxplots produce meaningful visualizations? (2 possible answers)

1. A. For discrete data.

2. B. For bi-modal distributions.

3. C. For non-Gaussian, symmetric data.

4. D. For exponentially distributed data.

***.explanation
See next slide

---
## Solution

**For which type of data will boxplots produce meaningful visualizations?**
* **C. For non-Gaussian, symmetric data.**
* **D. For exponentially distributed data.**

Boxplots are bad for bimodal data since they only show one mode (the median), but are ok for both symmetric and non-symmetric data, since the quartiles are not symmetric.

```r
dt <- data.table(x=c(1,1,1,2,2,2,8,8,8), # Discrete data, bad for boxplot
                 y=rbeta(n=1000,shape1=2,shape2=2),
                 z=rexp(n=1000, rate=1),
                 group='x') %>% melt(id.var="group")
ggplot(dt, aes(group, value)) + geom_boxplot() + facet_wrap(~variable) + mytheme
```

<img src="assets/fig/lec05_boxplot2-1.png" title="plot of chunk lec05_boxplot2" alt="plot of chunk lec05_boxplot2" width="500px" height="400px" />

---

## Boxplots and multi-modal distributions



```r
x = c(rnorm(100,1), rnorm(100,1)+5)
hist(x)
boxplot(x)
```

<img src="assets/fig/lec05_boxplot3-1.png" title="plot of chunk lec05_boxplot3" alt="plot of chunk lec05_boxplot3" width="400px" height="400px" /><img src="assets/fig/lec05_boxplot3-2.png" title="plot of chunk lec05_boxplot3" alt="plot of chunk lec05_boxplot3" width="400px" height="400px" />


Boxplot does not properly represent the distribution.



```
## Error in fread("../extdata/CPI_HDI.csv"): File '../extdata/CPI_HDI.csv' does not exist or is non-readable. getwd()=='/data/nasif12/home_if12/theodora/Projects/dataviz/lectures-WS2021/topic04_Plotting-I/slides'
```

---

<script type='text/javascript'>toc("2 variables - one discrete, one continuous")</script>


---
## Boxplot by category


```r
ggplot(mpg, aes(class, hwy)) +
  geom_boxplot() + mytheme
```

<img src="assets/fig/lec05_boxplot4-1.png" title="plot of chunk lec05_boxplot4" alt="plot of chunk lec05_boxplot4" width="600px" height="400px" />

---
## Violin plot


```r
ggplot(mpg, aes(class, hwy)) +
  geom_violin() + mytheme
```

<img src="assets/fig/lec05_boxplot5-1.png" title="plot of chunk lec05_boxplot5" alt="plot of chunk lec05_boxplot5" width="600px" height="400px" />

---
## Beanplot
Useful only up to a certain number of data points. Use the package ggbeeswarm:


```r
# install.packages("ggbeeswarm")
library(ggbeeswarm)
ggplot(mpg, aes(class, hwy)) + 
  geom_beeswarm() + mytheme
```

<img src="assets/fig/lec05_beeswarm-1.png" title="plot of chunk lec05_beeswarm" alt="plot of chunk lec05_beeswarm" width="600px" height="400px" />

---
## Barplots

* bars are visual `heavyweights` compared to dots and lines 
* combining two attributes of 2-D location and 
  line length to encode quantitative values
* bars emphasize the individual values 
  of the thing being measured per categorical subdivision
* focus attention primarily on individual 
  values and support the comparison of one to another




```r
ggplot(countries_dt, aes(Continent, Number_countries)) + 
  geom_bar(stat = 'identity', width = .7) + mytheme
```

<img src="assets/fig/lec05_coun, -1.png" title="plot of chunk lec05_coun, " alt="plot of chunk lec05_coun, " width="500px" height="400px" />


--- &radio
## When to use a Barplot?

1. A To show a connection between a series of individual data points
2. B To show a correlation between two quantitative variables
3. C _To highlight individual quantitative values per category_
4. D To compare distributions of quantitative values across categories

--- 
## When to use a Barplot?

C **To highlight individual quantitative values per category**


---
## Visualize uncertainty

Visualizing uncertainty is important, otherwise barplots can be misleading. One way to visualize uncertainty is with error bars.

* Standard deviation (SD) and standard error of the mean (SEM) as error bars. SD and SEM are completely different concepts!
  * SD indicates the variation of quantity in the sample.
  * SEM represents how well the mean is estimated.
  
The central limit theorem implies that: $SEM = SD / \sqrt{(n)}$ , where $n$ is the sample size (number of observations).

With large $n$, SEM tends to 0.

---
## Barplots with error bars

Explain what this code does:

```r
as.data.table(mpg) %>% 
  .[, .(mean = mean(hwy),
        sd = sd(hwy)),
    by = class] %>% 
  ggplot(aes(class, mean, ymax=mean+sd, ymin=mean-sd)) + 
  geom_bar(stat='identity') +
  geom_errorbar(width = 0.3) + mytheme
```

<img src="assets/fig/lec05_erb, -1.png" title="plot of chunk lec05_erb, " alt="plot of chunk lec05_erb, " width="500px" height="400px" />

---

<script type='text/javascript'>toc("2 variables - both continuous")</script>


---
## Scatterplot

Scatterplots are useful for easily visualizing the relationship between two continuous variables 


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() + mytheme
```

<img src="assets/fig/lec05_point1-1.png" title="plot of chunk lec05_point1" alt="plot of chunk lec05_point1" width="500px" height="400px" />

---
## Scatterplot with too many colors can be hard to read 

```r
ggplot(mpg, aes(displ, hwy, color=class)) +
  geom_point() + mytheme
```

<img src="assets/fig/lec05_point2-1.png" title="plot of chunk lec05_point2" alt="plot of chunk lec05_point2" width="600px" height="400px" />

Too many colors, hard to distinguish. One can use `facet` to separate them into different plots.

---

## 2D density plots

2D plots count the number of observations within a particular area of the 2D space and are better suited than scatter plots for large datasets


```r
x <- rnorm(10000); y=x+rnorm(10000)
data.table(x, y) %>% ggplot(aes(x, y)) +
  geom_hex() + mytheme
```

<img src="assets/fig/lec05_hex-1.png" title="plot of chunk lec05_hex" alt="plot of chunk lec05_hex" width="500px" height="400px" />

---
## When to use a line plot?

Two main goals:
* To `connect` a series of individual data points
* To display the `trend` of a series of data points.

Why:
* showing the shape of data as it flows and changes from point to point. 
* strength: movement of values up and down through time
* it's often difficult to discern the overall trend of scatter plots, 
  but a simple trend line can bring it into sharp focus.

--- &radio
## When to use a line plot?

1. A _To show a connection between a series of individual data points_
2. B To show a correlation between two quantitative variables
3. C To highlight individual quantitative values per category
4. D To compare distributions of quantitative values across categories

--- 
## When to use a line plot?

A **To show a connection between a series of individual data points**



---
## Line plot


```r
ggplot(economics, aes(date, unemploy / pop)) +
  geom_line() + mytheme
```

<img src="assets/fig/lec05_line-1.png" title="plot of chunk lec05_line" alt="plot of chunk lec05_line" width="500px" height="400px" />


---

<script type='text/javascript'>toc("Axes and labels")</script>



---
## Every aesthetic has a scale
ggplot automatically scales aesthetics, e.g. `x, y, colour, size, shape, fill...`. 

What happens to:

```r
ggplot(ind, aes(CPI, HDI)) +
  geom_point(aes(color=region)) + mytheme
```

is actually:

```r
ggplot(ind, aes(CPI, HDI)) +
  geom_point(aes(color=region)) +
  scale_x_continuous() +
  scale_y_continuous() + mytheme
```

You can **overwrite** them with `scale_*` commands.

---
## Overwrite scales, example:
* log scale

```r
ggplot(ind, aes(CPI, HDI)) +
  geom_point(aes(color=region)) +
  scale_x_log10() + mytheme
```

<img src="assets/fig/lec05_point6-1.png" title="plot of chunk lec05_point6" alt="plot of chunk lec05_point6" width="600px" height="400px" />


---
## Specify axis breaks

```r
ggplot(ind, aes(CPI, HDI)) +
  geom_point(aes(color=region)) +
  scale_x_log10(breaks=c(10, 20, 50, 100)) + mytheme
```

<img src="assets/fig/lec05_point8-1.png" title="plot of chunk lec05_point8" alt="plot of chunk lec05_point8" width="600px" height="400px" />

Same operations apply to y axis. 

---
## Change axis title
Changing label is a so frequent task that ggplot has several ways to do it:


```r
ggplot(ind, aes(CPI, HDI)) +
  geom_point(aes(color=region)) +
  labs(x = 'Corruption Perceptions Index', 
       y = 'Human Development Index',
       title = 'Corruption vs Human Development',
       color = 'Region') + mytheme
```

<img src="assets/fig/lec05_point10-1.png" title="plot of chunk lec05_point10" alt="plot of chunk lec05_point10" width="500px" height="400px" />

Try also with `xlabs`, `ylabs`, `ggtitle`, `scale_x_continuous`, `scale_y_continuous`.

---
## Change axis limits

```r
df <- data.table(x = rep(c("A", "B"), each = 100),
                 y = c(rnorm(100, 20, 8), rnorm(100, 10, 7)))
ggplot(df, aes(x, y)) +
  geom_boxplot() + mytheme
# I want cut my y axis from 10 to 30.
ggplot(df, aes(x, y)) +
  geom_boxplot() +
  scale_y_continuous(limits = c(10, 30)) + mytheme
```

<img src="assets/fig/lec05_boxplot8-1.png" title="plot of chunk lec05_boxplot8" alt="plot of chunk lec05_boxplot8" width="500px" height="400px" />

Note that the computed median changed! 

---
## When you use `limits` in `scale_`, ggplot will treat data points outside the range as `NA`.

* If you don't want this to happen, but simply "zoom in", use `coord_cartesian`. More details later. 

* Axis limits can also be changed with `xlim`, `ylim` as in base plots.

```r
ggplot(df, aes(x, y)) +
  geom_boxplot() +
  ylim(10, 30) + mytheme
```

<img src="assets/fig/lec05_boxplot9-1.png" title="plot of chunk lec05_boxplot9" alt="plot of chunk lec05_boxplot9" width="400px" height="400px" />


---
## Take-home
* Visualization is as important as statistics. Both are needed.
* Visualization can help finding "bugs" in the data
* Grammar of graphics separates data, aesthetics, and geometries
* Show as much as the raw data as you can:
  * Extend boxplot and barplots with beeswarm plots
  * Combine density and individual data points in 1D or 2D.
  

---
## References

* Main reference: [Udacity's Data Visualization and D3.js](https://www.udacity.com/courses/all)
* perceptual edge:
  * [the right graph](http://www.perceptualedge.com/articles/ie/the_right_graph.pdf)
  * [visual perception](http://www.perceptualedge.com/articles/ie/visual_perception.pdf)
  * [rules for color](http://www.perceptualedge.com/articles/visual_business_intelligence/rules_for_using_color.pdf)
  * [choosing color](http://www.perceptualedge.com/articles/b-eye/choosing_colors.pdf)
* flowingdata.com: [graphical perception](http://flowingdata.com/2010/03/20/graphical-perception-learn-the-fundamentals-first/)
* [Color Brewer](http://colorbrewer2.org/)
* Graphics principles
  * [paper] (https://onlinelibrary.wiley.com/doi/full/10.1002/pst.1912)
  * [cheatsheet](https://graphicsprinciples.github.io/)


---
## Plotting libraries

- http://www.r-graph-gallery.com/portfolio/ggplot2-package/
- http://ggplot2.tidyverse.org/reference/
- https://plot.ly/r/
- https://plot.ly/ggplot2/
