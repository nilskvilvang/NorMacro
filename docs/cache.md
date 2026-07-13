
# Cache

NorMacro cacher nedlastede datasett lokalt i mappen `cache/`.

Første kjøring laster ned data fra eksterne kilder (SSB, Norges Bank, NAV, FRED og Yahoo) og tar omtrent 20–30 sekunder.
Senere kjøringer bruker lokale `.rds`-filer og går betydelig raskere - normalt under ett sekund.

For å tvinge ny nedlasting:

```r
get_kpi(refresh = TRUE)
```
For å slette all cache:

```r
unlink("cache", recursive = TRUE)
```