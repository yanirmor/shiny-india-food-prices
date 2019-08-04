# <img align="left" height="40px" src="www/icons/food.png"></img> India Food Prices

Statistical & geo-spatial analysis and visualization of food prices in India, in R  
[https://yanirmor.shinyapps.io/india-food-prices](https://yanirmor.shinyapps.io/india-food-prices)  

### About

This app demonstrates statistical and geo-spatial analysis of food prices in India, in R.  
It is based on data collected by the World Food Programme.  
The results of the analysis are visualized using leaflet and ggplot2.

### Details

**Geo Analysis**  
Comparison of food prices between states in India.  
The color and the size of a circle represent the price of the selected commodity.  
Blocs of states within different geographical areas tend to have somewhat correlated prices.

**Time Series Analysis**  
Price trends visualized as standard scores (Z) over time.  
The distance between a tip of a bar and a point in a line can tell how faster (or slower) the price of the selected commodity changes relative to the prices of all commodities.

**Seasonal Analysis**  
Statistical analysis of seasonal trends.  
Seasoned are mapped to Jan-Mar (Winter), Apr-Jun (Summer), Jul-Sep (Monsoon) and Oct-Dec (Autumn).  
ANOVA and Tukey's HSD tests are used to determine if the differences are significant (P-value < 0.05).

### Author
Author: Yanir Mor  
Email: contact@yanirmor.com  
Website: [https://www.yanirmor.com](https://www.yanirmor.com)

### Credits

* Prices data by the [WFP](https://www.wfp.org/) and [HDX](https://data.humdata.org/) (CC BY 3.0 IGO)  
* Geo data by the [DIVA-GIS project](https://www.diva-gis.org/)  
* Icon by [PINPOINT.WORLD / Iconfinder](https://www.iconfinder.com/pinpointworld)

---
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)  
Copyright © 2019 Yanir Mor
