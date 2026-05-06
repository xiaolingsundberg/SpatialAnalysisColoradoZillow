# STA6709 Presentation Speaker Notes

## Slide 1: Title

Good morning/afternoon. My project is titled **Spatial Analysis of Colorado Zillow Housing Listings**. The purpose of this project is to use spatial statistics and mapping methods to better understand housing listing patterns in Colorado.

In this project, I used Zillow listing data and treated each house as a spatial point based on its latitude and longitude. I combined traditional summary statistics with maps, regression analysis, nearest-neighbor analysis, spatial clustering, and an interactive Leaflet map. The goal was not only to describe the housing data numerically, but also to show where listings are located and whether geography helps explain differences in listing price.

The cleaned dataset used in the analysis contains 123 listings, representing 44 cities and 82 ZIP codes. These listings provide enough geographic variation to explore how homes are distributed across Colorado and how price patterns relate to location.

## Slide 2: Project Objective

The main objective of this project was to apply spatial analysis methods to a real housing dataset. Housing prices are strongly connected to geography, so a regular table or regression model alone does not fully explain the data. A map can show patterns that may not be obvious from summary statistics.

There were five main goals for this project. First, I treated the Zillow listings as spatial points using latitude and longitude. Second, I mapped the listings within the Colorado state boundary and county polygons. Third, I used regression analysis to examine how listing price relates to home characteristics and location. Fourth, I used nearest-neighbor and cluster analysis to evaluate whether the listings were randomly distributed or geographically concentrated. Finally, I created an interactive Leaflet map so that individual listings could be explored visually.

Together, these steps help connect statistical results to geography.

## Slide 3: Dataset and Preparation

This slide summarizes the dataset after cleaning. The original data included Zillow housing listings with variables such as price, city, ZIP code, home type, beds, baths, square footage, latitude, and longitude.

Before analysis, the data needed to be cleaned. Duplicate listing IDs were removed so that the same property would not be counted more than once. Listings with missing values for important variables, including price, coordinates, beds, baths, or square footage, were excluded. The coordinates were also checked to make sure the homes were located within a reasonable Colorado range.

After cleaning, the dataset contained 123 listings. These listings covered 44 cities and 82 ZIP codes. The median listing price was 635 thousand dollars, while the mean listing price was about 3.97 million dollars. This large difference between the median and mean suggests that the dataset contains some very expensive listings that pull the average upward.

I also created two additional variables. Price per square foot was calculated by dividing listing price by square footage, and log price was created for regression because the raw price variable was highly skewed.

## Slide 4: Exploratory Summary: Price Is Highly Skewed

This slide shows two exploratory graphs. The histogram on the left shows the distribution of listing prices. Most homes are concentrated in the lower and moderate price ranges, but a few listings have extremely high prices. This creates a strongly right-skewed distribution.

The scatterplot on the right shows the relationship between listing price and home size, measured by area square feet. In general, larger homes tend to have higher listing prices, but the relationship is not perfectly linear. Some homes are much more expensive than expected based only on size. This suggests that other factors, such as location, luxury features, neighborhood characteristics, or market conditions, may also influence price.

Because of the skewness in price, I used log listing price as the response variable in the regression model. This makes the model more stable and reduces the influence of extreme luxury listings.

## Slide 5: Listings Are Concentrated Along the Front Range

This map shows the Zillow listing points over Colorado county boundaries. The county polygons provide geographic context and make it easier to see where the listings are concentrated.

The listings are not evenly distributed across the state. Most of them are located along the Front Range, especially near Denver, Colorado Springs, Boulder, and nearby communities. There are fewer listings in the western and mountain areas of Colorado.

This pattern is important because it shows that the dataset is geographically clustered. If we only looked at summary statistics, we might miss this concentration. The map shows that location is an important part of understanding the housing market in this dataset.

## Slide 6: Home Type Pattern

This slide maps listings by home type. The three home types in the dataset are single-family homes, condos, and townhouses. Single-family homes make up most of the dataset, so I made that layer more transparent to keep the smaller condo and townhouse groups visible on the map.

The table shows that there are 113 single-family homes, compared with only 5 condos and 5 townhouses. This means the overall results are mostly influenced by single-family homes. The condo and townhouse groups are much smaller, so their summary statistics should be interpreted carefully.

Home type was still included in the regression model because it can affect listing price. However, because the condo and townhouse sample sizes are small, the results for those categories should not be overgeneralized to the entire Colorado housing market.

## Slide 7: Regression Analysis

For the regression analysis, I used log listing price as the response variable. The predictors included beds, baths, square footage, home type, days on Zillow, latitude, and longitude.

The regression results show that several variables were meaningful predictors of log price. Square footage had a positive coefficient, meaning that larger homes were generally associated with higher prices. Bathrooms also had a positive coefficient. Days on Zillow had a negative coefficient, suggesting that homes listed for longer periods tended to have lower prices, holding the other variables constant.

Location was also important. Both latitude and longitude were significant predictors, which suggests that geography still matters even after accounting for property characteristics such as size, beds, baths, and home type.

This supports the main idea of the project: housing price is not only about the physical property. Location also plays an important role.

## Slide 8: Regression Residuals by Location

This slide shows the regression residual map. A residual is the difference between the actual price and the predicted price from the regression model. A positive residual means the actual price was higher than the model predicted. A negative residual means the actual price was lower than the model predicted.

Mapping residuals is useful because it connects the regression model back to geography. If large residuals appear in certain areas, that may suggest that the model is missing some location-specific information.

Some residuals may be related to factors that were not included in the dataset, such as neighborhood quality, school zones, mountain views, luxury amenities, or local market conditions. This map helps show where the model may overpredict or underpredict listing prices geographically.

## Slide 9: Nearest-Neighbor Analysis

The nearest-neighbor analysis was used to evaluate whether the listing points were randomly distributed, dispersed, or clustered. This method compares the observed average distance from each listing to its nearest neighbor with the expected distance under complete spatial randomness.

The observed mean nearest-neighbor distance was 8.356 kilometers. The expected distance under complete spatial randomness was 12.897 kilometers. The nearest-neighbor index was 0.648.

Because the index is less than 1, this indicates clustering. In other words, the listings are closer together than we would expect if they were randomly distributed across the Colorado study area.

This result matches what we saw visually in the maps. The listings are concentrated along the Front Range rather than spread evenly throughout the state.

## Slide 10: Spatial Cluster Analysis

The spatial cluster analysis grouped listings based on their coordinates. The purpose was to summarize regional listing groups and compare their basic housing characteristics.

Four clusters were identified. Cluster III was the largest, with 72 listings, and it was located around Denver and the central Front Range. Cluster I included 29 listings in southern Colorado and the Colorado Springs area. Cluster IV included 19 listings in the northern Front Range and Boulder-area region. Cluster II had only 3 listings, but it had very high prices and represented mountain or luxury-market listings.

Because Cluster II contains only three listings, it should be interpreted cautiously. However, it still shows how a small number of luxury homes can strongly affect price summaries.

Overall, the cluster analysis supports the conclusion that listing patterns are regional. It also helps connect price differences to geographic areas.

## Slide 11: Interactive Leaflet Map

The final product of the project is an interactive Leaflet map. Unlike the static maps shown in the report and slides, the Leaflet map allows the viewer to click on individual listings and inspect details.

The map includes the Colorado state boundary, county polygons, and Zillow listing points. Each listing has a popup that includes information such as address, city, actual price, predicted price, residual, home type, beds, baths, square footage, and spatial cluster.

This map is useful because it combines multiple parts of the analysis into one interactive tool. Instead of only viewing a static figure, the user can explore individual observations and see how the statistical results connect to specific homes.

The interactive map is submitted separately as a zipped HTML file. After unzipping the folder, the HTML file can be opened in a web browser.

## Slide 12: Conclusion

In conclusion, this project shows how spatial analysis can provide additional insight into housing data. The Colorado Zillow listings in this sample were not randomly distributed. They were clustered, especially along the Front Range.

The regression analysis showed that both property characteristics and location were related to listing price. Square footage, bathrooms, days on Zillow, latitude, and longitude were meaningful predictors. This supports the idea that geography remains important even after accounting for basic home features.

The nearest-neighbor index of 0.648 confirmed that the listings were spatially clustered. The cluster analysis further showed that the largest group of listings was located around Denver and the central Front Range.

Overall, the project demonstrates that maps, regression, nearest-neighbor analysis, clustering, and interactive visualization can work together to tell a stronger story than tables alone. Spatial statistics help reveal where housing patterns occur, while regression and summary statistics help describe the patterns numerically.

Thank you. That concludes my presentation.
