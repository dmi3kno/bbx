
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bbx <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `bbx` is to provide convenience functions for working with
bounding boxes and geometries for raster images.

## Installation

You can install the development version of bbox from
[Github](https://www.github.com) with:

``` r
remotes::install_github("dmi3kno/bbx")
```

## Example

Bounding boxes are common objects in workflows related to processing
images. You might have seen them when you worked with `hocr` package or
in relation to `hough`-transform functions in `magick`.

This is a basic example which shows you how to solve a common problem:

``` r
library(bbx)
## basic example code
library(magrittr)
```

### Validation and area

Bounding box is a character vector (of length 1 or more), where each
element contains 4 numbers separated by comma and/or space. These
objects are to be interpreted as “x1, y1, x2, y2” coordinates in a
raster image (top-left coordinates).

Valid `bbx` is where `x1<x2` and `y1<y2`.

``` r
bbx_is_valid("0 0 100 200")
#> [1] TRUE
bbx_validate(c("5,4,6,3", "1,1,5,6"))
#> [1] NA        "1,1,5,6"
```

Sometimes it is useful to know the area of a bounding box

``` r
bbx_area("100 100 200 200")
#> [1] 10000
```

### Composing `bbx`

You can create `bbx` objects from four vectors for x1, y1, x2 and y2,
respectively (together called coordinates).

``` r
coords_to_bbx(c(0,5,0,5), c(0,0,5,5),
              c(5,10,5,10), c(5,5,10,10))
#> [1] "0 0 5 5"   "5 0 10 5"  "0 5 5 10"  "5 5 10 10"
```

The reverse operation is also possible, converting `bbx` to list of
coordinates or a list of bounding box vectors.

``` r
l <- c("0 0 5 5", "5,5,10,10")
bbx_to_rlst(l)
#> [[1]]
#> [1] 0 0 5 5
#> 
#> [[2]]
#> [1]  5  5 10 10
bbx_to_clst(l)
#> [[1]]
#> [1] 0 5
#> 
#> [[2]]
#> [1] 0 5
#> 
#> [[3]]
#> [1]  5 10
#> 
#> [[4]]
#> [1]  5 10
```

These lists have special place in `bbx` package and you can always turn
them back into bounding boxes. Think of them as “raw-list” and
“coordinate-list”. Raw-list is called such, because, even though each
element is a numeric vector it is really containing a mix of entities in
every element (mixing `x` and `y` coordinates) and therefore requires
further processing before it can be used. There’s no class assigned to
these objects so you need to rememeber which is which.

``` r
l <- list(c(0,0,5,5), c(5,0,10,5), c(0,5,5,10), c(5,5,10,10))
rlst_to_bbx(l)
#> [1] "0 0 5 5"   "5 0 10 5"  "0 5 5 10"  "5 5 10 10"

l <- list(c(0,5,0,5,0),
          c(0,0,5,5,0),
          c(5,10,5,10,10),
          c(5,5,10,10,10))
clst_to_bbx(l)
#> [1] "0 0 5 5"   "5 0 10 5"  "0 5 5 10"  "5 5 10 10" "0 0 10 10"
```

### Converting to matrix (and back)

Most of calculations performed by `bbx` is done using numeric matrix, so
these functions are also exposed to user.

``` r
bbx_to_bbm(c("0 0 5 5", "5 5 10 10"))
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    0    5    5
#> [2,]    5    5   10   10
bbm_to_bbx(matrix(c(0,0,5,5,5,5,10,10), nrow=2, byrow=TRUE))
#> [1] "0 0 5 5"   "5 5 10 10"
```

You can also extract slope/intersept and angle of bbox diagonals. Note
that the function expects a bounding box matrix.

``` r
m <-bbx_to_bbm(c("0 0 5 5", "5 5 10 10"))
bbm_to_abm(m)
#>      slope intercept
#> [1,]     1         0
#> [2,]     1         0
bbm_to_angle(m)
#> [1] 45 45
```

### Editing `bbx` objects

In certain instances it might be necessary to update one coordinate of a
bounding box in a pipe. The following example with change `x2`
coordinate for every incoming `bbx` to a value of 800.

``` r
c("100 100 200 200", "300 400 500 600") %>% 
 bbx_reset(x2=800)
#> [1] "100 100 800 200" "300 400 800 600"
```

In certain circumstances (especially when performing OCR) it is
important to “pad” the word with some empty space. You can do it either
by specifying number of pixels directly or by providing a `word`, in
which case the number will be interpreted as number of characters to pad
(using average character width/height).

``` r
bbx_pad_width("10 10 40 40", 1)
#> [1] "9 10 41 40"
bbx_pad_width("10 10 40 40", word="There")
#> [1] "4 10 46 40"
bbx_pad_height("10 10 40 40", 1)
#> [1] "10 9 40 41"
bbx_pad_height("10 10 40 40", word="There\nbe\ndragons")
#> [1] "10 0 40 50"
```

### Intersection and ovelaps

There are many circumstances where it is important to know whether one
`bbx` is intersecting with another `bbx` (or to find a new `bbx` which
is the intersection of the two above). Note you need to supply a pair of
vectors to this predicate function (as it performs pair-wise
comparison).

``` r
bbx_intersects("5 1 7 3", "2 4 6 8") # should return FALSE
#> [1] FALSE
bbx_intersects("5 1 7 3", "2 2 6 8") # should return TRUE
#> [1] TRUE
```

### Aggregation

Once the intersection is assured, area of intesection can be calculated
and returned as a new `bbx` object. If the bounding boxes are not
overlappling `bbx_intersect` will return `NA`. Intersect is nothing
other than `max/pmax()` applied to `x1` and `y1` and `min/pmin()`
applied to `x2` and `y2`.

``` r
bbx_intersect(c("5 1 7 3", "2 4 6 8")) # should return NA
#> [1] NA
bbx_intersect("5 1 7 3", "2 2 6 8")
#> [1] "5 1 7 3"
```

In some sense, `union` is opposite of `intersect`. Union is applying
`min/pmin()` to `x1`/`y1`, and `max/pmax()` to `x2`/`y2`.

``` r
bbx_union(c("5 1 7 3", "2 4 6 8"))
#> [1] "2 1 7 8"
bbx_union(c("5 1 7 3", "2 4 6 8"), c("1 1 1 1"))
#> [1] "2 1 7 8"
```

However, there is an opportunity to use `bbx_union` (not `bbx_union2`)
as aggregation function. You can pass your own aggregating function(s)
into arguments of `bbx_aggregate` to perform other types of aggregation.
This example is aggregating height, but taking median of width.

``` r
bbx_aggregate(c("5 1 7 3", "2 4 6 8", "10 10 20 20"), 
              fx1=median, fy1=min, fx2=median, fy2=max)
#> [1] "5 1 7 20"
```

### Slicing `bbx`

Sometimes it is necessary to partition existing `bbx` into pieces by
“cutting” it horizontally or vertically (or both). It is possible to
do it with `bbx_slice_*` functions.

``` r
bbx_slice_x("0 0 100 200", 80)
#> $left
#> [1] "0 0 79 200"
#> 
#> $right
#> [1] "80 0 100 200"
bbx_slice_x(c("0 0 100 200", "100 100 200 200"), c(80, 150))
#> $left
#> [1] "0 0 79 200"      "100 100 149 200"
#> 
#> $right
#> [1] "80 0 100 200"    "150 100 200 200"
bbx_slice_y("0 0 100 200", 120)
#> $top
#> [1] "0 0 100 119"
#> 
#> $bottom
#> [1] "0 120 100 200"
bbx_slice_y(c("0 0 100 200", "100 100 200 200"), c(120,150))
#> $top
#> [1] "0 0 100 119"     "100 100 200 149"
#> 
#> $bottom
#> [1] "0 120 100 200"   "100 150 200 200"
bbx_slice_xy("0 0 100 200", 50, 100)
#> $top_left
#> [1] "0 0 49 99"
#> 
#> $top_right
#> [1] "50 0 100 99"
#> 
#> $bottom_left
#> [1] "0 100 49 200"
#> 
#> $bottom_right
#> [1] "50 100 100 200"
bbx_slice_xy(c("0 0 100 200", "100,100, 200, 200"), c(50, 150), c(100, 150))
#> $top_left
#> [1] "0 0 49 99"       "100 100 149 149"
#> 
#> $top_right
#> [1] "50 0 100 99"     "150 100 200 149"
#> 
#> $bottom_left
#> [1] "0 100 49 200"    "100 150 149 200"
#> 
#> $bottom_right
#> [1] "50 100 100 200"  "150 150 200 200"
```

### Convert to `magick` geometry

Ultimately `bbx` is intended as input to `image_crop()` (or other “area
geometry”-requiring) function in `magick`. The following function will
translate `bbx` to geometry and back.

``` r
bbx_to_geometry("0 0 100 200")
#> [1] "100x200+0+0"
bbx_to_geometry(c("0 0 100 200", "100,100,200, 200"))
#> [1] "100x200+0+0"     "100x100+100+100"
geometry_to_bbx(c("100x200+12+14", "100x200", "+12+14", "x200+12+14"))
#> [1] "12 14 112 214" "0 0 100 200"   "12 14 12 14"   "12 14 12 214"
```

\[1\] Finger Frame by Magdalene Kan from the Noun Project
