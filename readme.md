each Rmd should be able to knit standalone
uub

yaml format

```
title: my title
params:
    metaparameter:
        value: # required
    metaparam2: # nested
        value:
            a:
                value: a
            b: 
                value: b
    metaparam3: # more information
        value:
            c:
                value: c
                type: str
            d:
                value: d
                type: str
            


        


```
Metaparameter value: `r params$metaparameter$value`.

Metaparam2 values:
- A: `r params$metaparam2$value$a$value`
- B: `r params$metaparam2$value$b$value`

Metaparam3 values:
- C: `r params$metaparam3$value$c$value` (type: `r params$metaparam3$value$c$type`)
- D: `r params$metaparam3$value$d$value` (type: `r params$metaparam3$value$d$type`) 



hierarchy:
#            index.Rmd
#          /        \
#      MASIC.Rmd    tackle.Rmd
#                  /     |    \
#          metrics.Rmd  pca.Rmd  cluster.Rmd
#
#         