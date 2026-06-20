# NorMacro

NorMacro is an open, reproducible macroeconomic database for Norway.

The goal of the project is to provide a transparent and easily accessible collection of historical macroeconomic time series for teaching, research, and policy analysis in R.

## Objectives

* Retrieve data automatically from official sources.
* Provide clean and documented datasets.
* Support reproducible workflows.
* Integrate seamlessly with R and Quarto.
* Serve as a teaching resource for economics and data analysis.

## Data Sources

NorMacro is based exclusively on official and publicly available sources, including:

* Statistics Norway (SSB)
* Norges Bank
* NAV
* OECD (planned)
* Technical Calculation Committee for Wage Settlements (TBU) (planned)

## Current Status

### Implemented

* Historical Consumer Price Index (CPI) from Statistics Norway

  * Source: SSB Table 14711
  * Coverage: 1865–present
  * Variables:

    * `Aar`
    * `KPI`
    * `Inflasjon`

### Planned

#### Labour Market

* Registered unemployment (NAV)
* Labour force
* Employment
* Participation rate

#### Prices

* CPI
* Core inflation
* Inflation measures

#### Monetary Policy

* Historical interest rates
* Policy rate
* Money market rates

#### Real Economy

* GDP
* Mainland GDP
* GDP growth

#### Demographics

* Population
* Working-age population

#### Labour Market and Wages

* Nominal wages
* Real wages
* Productivity

## Project Structure

```text
NorMacro/

NorMacro.Rproj

utils.R

source_ssb.R

get_kpi.R

get_befolkning.R

get_arbeidsstyrke.R

get_ledighet.R

get_rente.R

data_raw/

data_clean/
```

## Example

```r
source("utils.R")
source("source_ssb.R")
source("get_kpi.R")

kpi <- get_kpi()

head(kpi)
```

## Long-Term Vision

The long-term ambition is to create a Norwegian equivalent of FRED (Federal Reserve Economic Data), providing a consistent and well-documented set of macroeconomic indicators for Norway.

## License

MIT License

```
```
